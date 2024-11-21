; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; NPC object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/rpg/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjRpgNpc:
	SET_OBJECT_LAYER move.w,2,obj.layer(a6)			; Set layer
	
	move.w	#14,obj.collide_width(a6)			; Set hitbox size
	move.w	#14,obj.collide_height(a6)
	
	move.w	#32,obj.draw_width(a6)				; Set draw size
	move.w	#32,obj.draw_height(a6)
	
	move.l	#Draw,obj.draw(a6)				; Set draw routine

	moveq	#0,d0						; Set state and sprite data address
	move.b	obj.subtype(a6),d0
	lsl.w	#3,d0
	movea.l	.InitData(pc,d0.w),a0
	move.l	.InitData+4(pc,d0.w),npc.sprites(a6)
	move.l	a0,obj.update(a6)
	jmp	(a0)

; ------------------------------------------------------------------------------

.InitData:
	dc.l	InitBurglar, MarsSpr_Burglar			; Burglar
	dc.l	DrawObject, MarsSpr_Doctor			; Doctor
	dc.l	InitCop, MarsSpr_Cop				; Cop
	dc.l	InitMainCultist, MarsSpr_Cultist		; Main Cultist
	dc.l	InitCultist1, MarsSpr_Cultist			; Cultist 1
	dc.l	InitCultist2, MarsSpr_Cultist			; Cultist 2
	dc.l	InitWarden, MarsSpr_Warden			; Warden

; ------------------------------------------------------------------------------
; Burglar initialization state
; ------------------------------------------------------------------------------

InitBurglar:
	CHECK_EVENT EVENT_STAGE_1				; Have we beaten stage 1?
	beq.s	.Delete						; If not, branch
	CHECK_EVENT EVENT_STAGE_2				; Have we beaten stage 2?
	bne.s	.Delete						; If so, branch
	CHECK_EVENT EVENT_BREAK_IN				; Have we broken in?
	bne.s	.Init						; If so, branch

.Delete:
	jmp	DeleteObject					; Delete ourselves

.Init:
	SET_OBJECT_LAYER move.w,4,obj.layer(a6)			; Set layer
	move.b	#2,rpg_obj.angle(a6)				; Face down
	
	movea.w	player_object,a1				; Set player's burglar object
	move.w	a6,player.burglar(a1)

	move.l	#.Wait,obj.update(a6)				; Start waiting for the player
	
; ------------------------------------------------------------------------------

.Wait:
	moveq	#0,d0						; Animate sprite
	lea	Anim_Npc(pc),a1
	jsr	AnimateRpgObject
	
	jsr	UpdateRpgObject					; Update object
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Burglar aggression state
; ------------------------------------------------------------------------------

BurglarAggressionState:
	move.l	#.MoveRight,obj.update(a6)			; Move right
	move.w	#$100,obj.x_speed(a6)

; ------------------------------------------------------------------------------

.MoveRight:
	cmpi.w	#$138,obj.x(a6)					; Have we moved enough?
	blt.s	.Update						; If not, branch

	move.w	#$138,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)

	lea	obj.anim(a6),a0					; Set beat animation
	lea	Anim_Burglar(pc),a1
	moveq	#0,d0
	jsr	SetAnimation

	move.l	#.BeatPlayer,obj.update(a6)			; Beat the player
	
; ------------------------------------------------------------------------------

.BeatPlayer:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation

	cmpi.w	#11,obj.anim+anim.frame(a6)			; Is the animation done?
	bne.s	.Draw						; If not, branch
	
	move.w	#$FF19,MARS_COMM_10+MARS_SYS			; Play hit sound

	st	cut_to_black					; Cut to black
	bra.s	.Draw

; ------------------------------------------------------------------------------

.Update:
	moveq	#0,d0						; Animate sprite
	lea	Anim_Npc(pc),a1
	jsr	AnimateRpgObject

	jsr	UpdateRpgObject					; Update object

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Cop initialization state
; ------------------------------------------------------------------------------

InitCop:
	move.b	#6,rpg_obj.angle(a6)				; Face up

	CHECK_EVENT EVENT_SUSPECT_CHOOSE			; Have we chosen a suspect?
	beq.s	.NoSuspectChoose				; If not, branch

.WaitPause:
	btst	#SCRIPT_PAUSE_FLAG,script_flags			; Is the script paused?
	beq.s	.Update						; If not, branch

	move.l	#CopLeaveState,obj.update(a6)			; Set leave state
	bra.s	CopLeaveState

; ------------------------------------------------------------------------------

.NoSuspectChoose:
	subq.w	#1,npc.timer(a6)				; Decrement timer
	bne.s	.Update						; If it hasn't run out, branch

	move.l	#.WalkUp,obj.update(a6)				; Start walking up
	move.w	#-$100,obj.y_speed(a6)

; ------------------------------------------------------------------------------

.WalkUp:
	cmpi.w	#$130,obj.y(a6)					; Have we moved up enough?
	bgt.s	.Update						; If not, branch

	move.w	#$130,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)
	move.b	#6,rpg_obj.angle(a6)				; Face up

	move.l	#.WalkLeft,obj.update(a6)			; Start walking left
	move.w	#-$100,obj.x_speed(a6)

; ------------------------------------------------------------------------------

.WalkLeft:
	cmpi.w	#$134,obj.x(a6)					; Have we moved up enough?
	bgt.s	.Update						; If not, branch

	move.w	#$134,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)
	
	move.b	#6,rpg_obj.angle(a6)				; Face up

	jsr	UnpauseScript					; Unpause script
	move.l	#.Update,obj.update(a6)				; Set state

; ------------------------------------------------------------------------------

.Update:
	jsr	UpdateRpgObject					; Update object

	moveq	#0,d0						; Animate sprite
	lea	Anim_Npc(pc),a1
	jsr	AnimateRpgObject
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Cop leave state
; ------------------------------------------------------------------------------

CopLeaveState:
	move.l	#.WalkRight,obj.update(a6)			; Start walking right
	move.w	#$100,obj.x_speed(a6)

; ------------------------------------------------------------------------------

.WalkRight:
	cmpi.w	#$150,obj.x(a6)					; Have we walked far enough?
	blt.s	.Update						; If not, branch

	move.w	#$150,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)

	move.l	#.WalkDown,obj.update(a6)			; Start walking down
	move.w	#$100,obj.y_speed(a6)

; ------------------------------------------------------------------------------

.WalkDown:
	cmpi.w	#$160,obj.y(a6)					; Have we walked far enough?
	blt.s	.Update						; If not, branch
	
	move.w	#$FF0F,MARS_COMM_12+MARS_SYS			; Play door close sound

	jsr	UnpauseScript					; Unpause script
	jmp	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------

.Update:
	moveq	#0,d0						; Animate sprite
	lea	Anim_Npc(pc),a1
	jsr	AnimateRpgObject

	jsr	UpdateRpgObject					; Update object
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Main cultist initialization state
; ------------------------------------------------------------------------------

InitMainCultist:
	CHECK_EVENT EVENT_CULT_KILLED				; Was the cult killed?
	bne.s	.Delete						; If so, branch
	CHECK_EVENT EVENT_STAGE_3				; Has stage 3 been beaten?
	bne.s	.Init						; If so, branch

.Delete:
	jmp	DeleteObject					; Delete ourselves

.Init:
	SET_OBJECT_LAYER move.w,2,obj.layer(a6)			; Set layer
	move.b	#4,rpg_obj.angle(a6)				; Face left
	
	movea.w	player_object,a1				; Set player's cultist object
	move.w	a6,player.cultist(a1)

	move.l	#.Update,obj.update(a6)				; Set state
	
; ------------------------------------------------------------------------------

.Update:
	moveq	#0,d0						; Animate sprite
	lea	Anim_Npc(pc),a1
	jsr	AnimateRpgObject

	jsr	UpdateRpgObject					; Update object
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Cultist 1 initialization state
; ------------------------------------------------------------------------------

InitCultist1:
	CHECK_EVENT EVENT_CULT_KILLED				; Was the cult killed?
	bne.s	.Delete						; If so, branch
	CHECK_EVENT EVENT_STAGE_3				; Has stage 3 been beaten?
	bne.s	.Init						; If so, branch

.Delete:
	jmp	DeleteObject					; Delete ourselves

.Init:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer
	move.b	#2,rpg_obj.angle(a6)				; Face down

	move.l	#.Update,obj.update(a6)				; Set state
	
; ------------------------------------------------------------------------------

.Update:
	moveq	#0,d0						; Animate sprite
	lea	Anim_Npc(pc),a1
	jsr	AnimateRpgObject

	jsr	UpdateRpgObject					; Update object
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Cultist 2 initialization state
; ------------------------------------------------------------------------------

InitCultist2:
	CHECK_EVENT EVENT_CULT_KILLED				; Was the cult killed?
	bne.s	.Delete						; If so, branch
	CHECK_EVENT EVENT_STAGE_3				; Has stage 3 been beaten?
	bne.s	.Init						; If so, branch

.Delete:
	jmp	DeleteObject					; Delete ourselves

.Init:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer
	clr.b	rpg_obj.angle(a6)				; Face right

	move.l	#.Update,obj.update(a6)				; Set state
	
; ------------------------------------------------------------------------------

.Update:
	moveq	#0,d0						; Animate sprite
	lea	Anim_Npc(pc),a1
	jsr	AnimateRpgObject

	jsr	UpdateRpgObject					; Update object
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Cultist aggression state
; ------------------------------------------------------------------------------

CultistAggressionState:
	movea.w	player_object,a1				; Set player's layer
	SET_OBJECT_LAYER move.w,3,obj.layer(a1)

	move.l	#.MoveDown,obj.update(a6)			; Move down
	move.w	#$100,obj.y_speed(a6)

; ------------------------------------------------------------------------------

.MoveDown:
	cmpi.w	#$130,obj.y(a6)					; Have we moved enough?
	blt.s	.Update						; If not, branch

	move.w	#$130,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

	move.l	#.MoveLeft,obj.update(a6)			; Move left
	move.w	#-$100,obj.x_speed(a6)
	
; ------------------------------------------------------------------------------

.MoveLeft:
	cmpi.w	#$1F0,obj.x(a6)					; Have we moved enough?
	bgt.s	.Update						; If not, branch

	move.w	#$1F0,obj.x(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

	move.b	#2,rpg_obj.angle(a6)				; Face down
	move.w	#$FF19,MARS_COMM_10+MARS_SYS			; Play hit sound

	st	cut_to_black					; Cut to black

; ------------------------------------------------------------------------------

.Update:
	moveq	#0,d0						; Animate sprite
	lea	Anim_Npc(pc),a1
	jsr	AnimateRpgObject

	jsr	UpdateRpgObject					; Update object
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Warden initialization state
; ------------------------------------------------------------------------------

InitWarden:
	SET_OBJECT_LAYER move.w,4,obj.layer(a6)			; Set layer

	movea.w	player_object,a1				; Set player's warden object
	move.w	a6,player.warden(a1)
	
	move.l	#.Wait,obj.update(a6)				; Wait half a minute
	move.w	#30*60,npc.timer(a6)

; ------------------------------------------------------------------------------

.Wait:
	tst.l	script_address					; Is a script active?
	bne.w	.Draw						; If so, branch

	subq.w	#1,npc.timer(a6)				; Decrement timer
	bne.w	.Update						; If it hasn't run out, branch

	move.l	#.MoveRight,obj.update(a6)			; Move right
	move.w	#$200,obj.x_speed(a6)

; ------------------------------------------------------------------------------

.MoveRight:
	tst.l	script_address					; Is a script active?
	bne.w	.Draw						; If so, branch

	cmpi.w	#$150,obj.x(a6)					; Have we moved enough?
	blt.w	.Update						; If not, branch

	move.w	#$150,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)

	move.l	#.MoveUp,obj.update(a6)				; Move up
	move.w	#-$200,obj.y_speed(a6)

; ------------------------------------------------------------------------------

.MoveUp:
	tst.l	script_address					; Is a script active?
	bne.w	.Draw						; If so, branch

	cmpi.w	#$1A8,obj.y(a6)					; Have we moved enough?
	bgt.s	.Update						; If not, branch

	move.w	#$1A8,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)
	
	movea.w	player_object,a1				; Face player down
	move.b	#2,rpg_obj.angle(a1)

	movea.w	player.prison_door(a1),a1			; Delete prison door
	jsr	DeleteOtherObject

	lea	WardenScript,a0					; Run warden script
	jsr	StartScript
	
	move.l	#.WaitOllieMove,obj.update(a6)			; Wait for Ollie to move

; ------------------------------------------------------------------------------

.WaitOllieMove:
	btst	#SCRIPT_PAUSE_FLAG,script_flags			; Is the script paused?
	beq.s	.Update						; If not, branch

	movea.w	player_object,a1				; Make the player move towards us
	move.l	#RpgPlayerWardenState,obj.update(a1)

	move.l	#.WaitOllieDone,obj.update(a6)			; Wait for Ollie to move

; ------------------------------------------------------------------------------

.WaitOllieDone:
	btst	#SCRIPT_PAUSE_FLAG,script_flags			; Is the script paused?
	bne.s	.Update						; If so, branch
	
	move.l	#.Update,obj.update(a6)				; Set state

; ------------------------------------------------------------------------------

.Update:
	moveq	#0,d0						; Animate sprite
	lea	Anim_Npc(pc),a1
	jsr	AnimateRpgObject

	jsr	UpdateRpgObject					; Update object

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Warden punch state
; ------------------------------------------------------------------------------

WardenPunchState:
	cmpi.w	#$1C0,obj.y(a6)					; Have we moved enough?
	blt.s	.Update						; If not, branch

	move.w	#$1C0,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

	move.l	#.Wait,obj.update(a6)				; Wait for a second
	move.w	#60,npc.timer(a6)

; ------------------------------------------------------------------------------

.Wait:
	subq.w	#1,npc.timer(a6)				; Decrement timer
	bne.s	.Update						; If it hasn't run out, branch

	move.l	#.MoveUp,obj.update(a6)				; Move up
	move.w	#-$200,obj.y_speed(a6)

; ------------------------------------------------------------------------------

.MoveUp:
	cmpi.w	#$1A8,obj.y(a6)					; Have we moved enough?
	bgt.s	.Update						; If not, branch

	move.w	#$1A8,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

	jsr	UnpauseScript					; Unpause script
	move.l	#.Update,obj.update(a6)				; Set state

; ------------------------------------------------------------------------------

.Update:
	jsr	UpdateRpgObject					; Update object
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Warden drag player state
; ------------------------------------------------------------------------------

WardenDragPlayerState:
	cmpi.w	#$1D0,obj.y(a6)					; Have we moved enough?
	blt.s	.Update						; If not, branch

	move.w	#$1D0,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

	move.l	#.MoveLeft,obj.update(a6)			; Move left
	move.w	#-$200,obj.x_speed(a6)

; ------------------------------------------------------------------------------

.MoveLeft:
	cmpi.w	#-48,obj.x(a6)					; Have we moved enough?
	bgt.s	.Update						; If not, branch

	move.w	#-48,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)

	move.l	#.Update,obj.update(a6)				; Set state

; ------------------------------------------------------------------------------

.Update:
	moveq	#0,d0						; Animate sprite
	lea	Anim_Npc(pc),a1
	jsr	AnimateRpgObject
	
	jsr	UpdateRpgObject					; Update object
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.l	npc.sprites(a6),-(sp)				; Draw sprite
	move.b	obj.anim+anim.frame+1(a6),-(sp)
	move.b	#2,-(sp)
	move.b	obj.flags(a6),-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite
	rts

; ------------------------------------------------------------------------------
; Scripts
; ------------------------------------------------------------------------------

WardenScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			WardenIcon, 0

	SCRIPT_TEXT			"Alright, you're free to go, Mr.\n", &
					"TechDeck."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_PAUSE

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"Make sure next time to bring\n", &
					"some lube when I shove this\n", &
					"nightstick up your ass."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I really want to hurt this guy."
	SCRIPT_SELECTION		"Don't bother", .StageEnd, &
					"Punch the warden", .Punch

.StageEnd:
	SCRIPT_ICON			WardenIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Let's get you out of here."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			2

	SCRIPT_SET_NUMBER_BYTE		cut_to_black, 1
	SCRIPT_END
	
.Punch:
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Fuck you, you disgusting pig!"
	SCRIPT_WAIT_INPUT

	SCRIPT_CALL_M68K		.PunchWarden
	SCRIPT_SET_EVENT		EVENT_ASSAULTED_WARDEN

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_PAUSE

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			WardenIcon, 0

	SCRIPT_TEXT			"Ha! I got you where I want now!"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CALL_M68K		.DragPlayer
	
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"THE REVOLUTION BEGINS NOW!!"
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"NO MORE CHARACTER SWAPS! NO\n", &
					"MORE GLITCHY PALETTES! NO MORE\n", &
					"HORRIBLE BOSS FIGHTS!"
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"DOWN WITH THE SICKNESS WE'RE\n", &
					"BURNING DOWN THE HOUSE!\n", &
					"BURNING DOWN THE HOUSE!"
	SCRIPT_WAIT_INPUT

	SCRIPT_END

; ------------------------------------------------------------------------------

.PunchWarden:
	move.w	#$FF19,MARS_COMM_10+MARS_SYS			; Play punch sound
	
	movea.w	player_object,a1				; Punch the warden
	movea.w	player.warden(a1),a1
	move.l	#WardenPunchState,obj.update(a1)
	move.w	#$400,obj.y_speed(a1)
	rts

; ------------------------------------------------------------------------------

.DragPlayer:
	movea.w	player_object,a1				; Deag the player away
	move.l	#RpgPlayerDragState,obj.update(a1)
	move.w	#$200,obj.y_speed(a1)

	movea.w	player.warden(a1),a1				; Move the warden
	move.l	#WardenDragPlayerState,obj.update(a1)
	move.w	#$200,obj.y_speed(a1)
	rts

; ------------------------------------------------------------------------------
; Animations
; ------------------------------------------------------------------------------

Anim_Npc:
	dc.w	.IdleDown-Anim_Npc
	dc.w	.MoveDown-Anim_Npc
	dc.w	.IdleHoriz-Anim_Npc
	dc.w	.MoveHoriz-Anim_Npc
	dc.w	.IdleUp-Anim_Npc
	dc.w	.MoveUp-Anim_Npc

.IdleDown:
	ANIM_START $100, ANIM_RESTART
	dc.w	0
	ANIM_END

.MoveDown:
	ANIM_START $20, ANIM_RESTART
	dc.w	1, 0, 2, 0
	ANIM_END

.IdleHoriz:
	ANIM_START $100, ANIM_RESTART
	dc.w	3
	ANIM_END

.MoveHoriz:
	ANIM_START $20, ANIM_RESTART
	dc.w	4, 3, 5, 3
	ANIM_END

.IdleUp:
	ANIM_START $100, ANIM_RESTART
	dc.w	6
	ANIM_END

.MoveUp:
	ANIM_START $40, ANIM_RESTART
	dc.w	7, 6, 8, 6
	ANIM_END

; ------------------------------------------------------------------------------

Anim_Burglar:
	dc.w	.Beat-Anim_Burglar

.Beat:
	ANIM_START $20, ANIM_LOOP_POINT, 2
	dc.w	3, 3, 3, 3, 9, 10, 11
	ANIM_END

; ------------------------------------------------------------------------------
; Icons
; ------------------------------------------------------------------------------

DoctorIcon:
	dc.l	MarsSpr_RpgTextboxIcons
	dc.w	2
	dc.l	0

.Anims:
	dc.w	.Static-.Anims

.Static:
	ANIM_START $100, ANIM_RESTART
	dc.w	1
	ANIM_END

; ------------------------------------------------------------------------------

CopIcon:
	dc.l	MarsSpr_RpgTextboxIcons
	dc.w	2
	dc.l	0

.Anims:
	dc.w	.Static-.Anims

.Static:
	ANIM_START $100, ANIM_RESTART
	dc.w	2
	ANIM_END

; ------------------------------------------------------------------------------

CultistIcon:
	dc.l	MarsSpr_RpgTextboxIcons
	dc.w	2
	dc.l	0

.Anims:
	dc.w	.Static-.Anims

.Static:
	ANIM_START $100, ANIM_RESTART
	dc.w	3
	ANIM_END

; ------------------------------------------------------------------------------

WardenIcon:
	dc.l	MarsSpr_RpgTextboxIcons
	dc.w	2
	dc.l	0

.Anims:
	dc.w	.Static-.Anims

.Static:
	ANIM_START $100, ANIM_RESTART
	dc.w	4
	ANIM_END

; ------------------------------------------------------------------------------
