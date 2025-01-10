; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ao Oni object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/rpg/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjAoOni:
	move.w	#32,obj.draw_width(a6)				; Set draw size
	move.w	#96,obj.draw_height(a6)

	andi.w	#~$1F,obj.x(a6)					; Align with grid
	addi.w	#16,obj.x(a6)
	andi.w	#~$1F,obj.y(a6)
	addi.w	#16,obj.y(a6)
	
	move.l	#WaitPlayerState,obj.update(a6)			; Set wait state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Wait for the player to get near state
; ------------------------------------------------------------------------------

WaitPlayerState:
	move.w	ao_oni_object,d0				; Is there already an active Ao Oni object?
	beq.s	.StartChase					; If not, branch
	movea.w	d0,a1						; Get active Ao Oni object

	move.w	a6,-(sp)					; Is the active Ao Oni object on screen?
	movea.w	a1,a6
	bsr.w	CheckOnScreen
	movea.w	(sp)+,a6
	beq.s	.Despawn					; If so, branch

	bsr.s	CheckNearby					; Are we nearby?
	bne.s	.Despawn					; If not, branch

	jsr	ClearOtherObjectSpawnFlag			; Despawn active Ao Oni object
	jsr	DeleteOtherObject

.StartChase:
	move.l	#ChaseState,obj.update(a6)			; Start chasing player
	move.w	a6,ao_oni_object

.Despawn:
	bra.w	CheckDespawn					; Check despawn

; ------------------------------------------------------------------------------
; Check if Ao Oni is nearby
; ------------------------------------------------------------------------------
; RETURNS:
;	eq/ne - Nearby/Not nearby
; ------------------------------------------------------------------------------

CheckNearby:
	bsr.s	CheckOnScreen					; Are we on screen?
	beq.s	.NotNearby					; If so, branch

	move.w	obj.y(a6),d0					; Are past the top boundary?
	addi.w	#16+64,d0
	cmp.w	camera_fg_y,d0
	blt.s	.NotNearby					; If so, branch

	move.w	obj.y(a6),d0					; Are we past the bottom boundary?
	subi.w	#96+64,d0
	move.w	camera_fg_y,d1
	addi.w	#224,d1
	cmp.w	d1,d0
	bgt.s	.NotNearby					; If so, branch
	
	move.w	obj.x(a6),d0					; Are past the left side boundary?
	addi.w	#24+64,d0
	cmp.w	camera_fg_x,d0
	blt.s	.NotNearby					; If so, branch

	move.w	obj.x(a6),d0					; Are we past the right side boundary?
	subi.w	#24+64,d0
	move.w	camera_fg_x,d1
	addi.w	#320,d1
	cmp.w	d1,d0
	bgt.s	.NotNearby					; If so, branch

	ori	#4,sr						; Nearby
	rts

.NotNearby:
	andi	#~4,sr						; Not nearby
	rts

; ------------------------------------------------------------------------------
; Check if Ao Oni is on screen
; ------------------------------------------------------------------------------
; RETURNS:
;	eq/ne - On screen/Off screen
; ------------------------------------------------------------------------------

CheckOnScreen:
	move.w	obj.y(a6),d0					; Are past the top of the screen?
	addi.w	#16,d0
	cmp.w	camera_fg_y,d0
	blt.s	.OffScreen					; If so, branch

	move.w	obj.y(a6),d0					; Are we past the bottom of the screen?
	subi.w	#96,d0
	move.w	camera_fg_y,d1
	addi.w	#224,d1
	cmp.w	d1,d0
	bgt.s	.OffScreen					; If so, branch
	
	move.w	obj.x(a6),d0					; Are past the left side of the screen?
	addi.w	#24,d0
	cmp.w	camera_fg_x,d0
	blt.s	.OffScreen					; If so, branch

	move.w	obj.x(a6),d0					; Are we past the right side of the screen?
	subi.w	#24,d0
	move.w	camera_fg_x,d1
	addi.w	#320,d1
	cmp.w	d1,d0
	bgt.s	.OffScreen					; If so, branch

	ori	#4,sr						; On screen
	rts

.OffScreen:
	andi	#~4,sr						; Off screen
	rts

; ------------------------------------------------------------------------------
; Chase state
; ------------------------------------------------------------------------------

ChaseState:
	CHECK_EVENT EVENT_HOSPITAL_HALLWAY			; Has the player ran into the hallway?
	beq.s	.Despawn					; If not, branch
	
	bsr.w	TriggerRpgObject				; Check collision with player
	bne.s	.NoTouch					; If there's no collision, branch

	st	ao_oni_touched					; Set touched flag

.NoTouch:
	jsr	UpdateRpgObject					; Update
	bsr.s	SetDirection					; Set direction
	
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer
	
	movea.w	player_object,a1				; Is the player in front of us?
	move.w	obj.y(a1),d0
	subq.w	#8,d0
	cmp.w	obj.y(a6),d0
	bgt.s	.Draw						; If so, branch

	SET_OBJECT_LAYER move.w,2,obj.layer(a6)			; Set layer

.Draw:
	moveq	#0,d0						; Animate sprite
	lea	Anim_AoOni(pc),a1
	jsr	AnimateRpgObject
	jsr	DrawObject					; Draw sprite

.Despawn:
	bra.w	CheckDespawn					; Check despawn

; ------------------------------------------------------------------------------
; Set direction
; ------------------------------------------------------------------------------

SetDirection:
	move.w	#32,obj.collide_width(a6)			; Set hitbox size
	move.w	#32,obj.collide_height(a6)

	tst.w	obj.x_speed(a6)					; Are we moving horizontally?
	beq.s	.CheckY						; If not, branch

	move.w	obj.x(a6),d0					; Have we horizontally crossed a grid tile?
	addi.w	#16,d0
	andi.w	#~$1F,d0
	move.w	obj.previous_x(a6),d1
	addi.w	#16,d1
	andi.w	#~$1F,d1
	cmp.w	d0,d1
	beq.w	.End						; If not, branch

.CheckY:
	tst.w	obj.y_speed(a6)					; Are we moving vertically?
	beq.s	.CheckDirection					; If not, branch

	move.w	obj.y(a6),d0					; Have we horizontally crossed a grid tile?
	addi.w	#16,d0
	andi.w	#~$1F,d0
	move.w	obj.previous_y(a6),d1
	addi.w	#16,d1
	andi.w	#~$1F,d1
	cmp.w	d0,d1
	beq.w	.End						; If not, branch

.CheckDirection:
	movea.w	player_object,a1				; Get player object

	moveq	#0*4,d6						; No movement
	move.l	#$7FFFFFFF,d7					; Minimum distance

.CheckUp:
	cmpi.w	#1,obj.y_speed(a6)				; Are we moving down?
	bge.s	.CheckDown					; If so, branch

	movem.l	d6-d7/a1,-(sp)					; Is there a wall in the way?
	jsr	ObjMapCollideUpWide
	movem.l	(sp)+,d6-d7/a1
	tst.w	d1
	bpl.s	.CheckUpDistance				; If so, branch
	bra.s	.CheckDown

.CheckUpDistance:
	move.w	obj.x(a6),d0					; Get distance from player if moving
	sub.w	obj.x(a1),d0
	move.w	obj.y(a6),d1
	subi.w	#32,d1
	sub.w	obj.y(a1),d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0

	cmp.l	d7,d0						; Is this the shortest distance so far?
	bgt.s	.CheckDown					; If not, branch
	move.l	d0,d7						; Set new minimum distance

	moveq	#1*4,d6						; Move up

.CheckDown:
	tst.w	obj.y_speed(a6)					; Are we moving up?
	bmi.s	.CheckLeft					; If so, branch

	movem.l	d6-d7/a1,-(sp)					; Is there a wall in the way?
	jsr	ObjMapCollideDownWide
	movem.l	(sp)+,d6-d7/a1
	tst.w	d1
	bpl.s	.CheckDownDistance				; If so, branch
	bra.s	.CheckLeft

.CheckDownDistance:
	move.w	obj.x(a6),d0					; Get distance from player if moving
	sub.w	obj.x(a1),d0
	move.w	obj.y(a6),d1
	addi.w	#32,d1
	sub.w	obj.y(a1),d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0

	cmp.l	d7,d0						; Is this the shortest distance so far?
	bgt.s	.CheckLeft					; If not, branch
	move.l	d0,d7						; Set new minimum distance

	moveq	#2*4,d6						; Move down

.CheckLeft:
	cmpi.w	#1,obj.x_speed(a6)				; Are we moving right?
	bge.s	.CheckRight					; If so, branch

	movem.l	d6-d7/a1,-(sp)					; Is there a wall in the way?
	jsr	ObjMapCollideLeftWide
	movem.l	(sp)+,d6-d7/a1
	tst.w	d1
	bpl.s	.CheckLeftDistance				; If so, branch
	bra.s	.CheckRight

.CheckLeftDistance:
	move.w	obj.x(a6),d0					; Get distance from player if moving
	subi.w	#32,d0
	sub.w	obj.x(a1),d0
	move.w	obj.y(a6),d1
	sub.w	obj.y(a1),d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0

	cmp.l	d7,d0						; Is this the shortest distance so far?
	bgt.s	.CheckRight					; If not, branch
	move.l	d0,d7						; Set new minimum distance

	moveq	#3*4,d6						; Move left

.CheckRight:
	tst.w	obj.x_speed(a6)					; Are we moving left?
	bmi.s	.Move						; If so, branch

	movem.l	d6-d7/a1,-(sp)					; Is there a wall in the way?
	jsr	ObjMapCollideRightWide
	movem.l	(sp)+,d6-d7/a1
	tst.w	d1
	bpl.s	.CheckRightDistance				; If so, branch
	bra.s	.Move

.CheckRightDistance:
	move.w	obj.x(a6),d0					; Get distance from player if moving
	addi.w	#32,d0
	sub.w	obj.x(a1),d0
	move.w	obj.y(a6),d1
	sub.w	obj.y(a1),d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0

	cmp.l	d7,d0						; Is this the shortest distance so far?
	bgt.s	.Move						; If not, branch
	move.l	d0,d7						; Set new minimum distance

	moveq	#4*4,d6						; Move right

.Move:
	move.l	.Speeds(pc,d6.w),obj.x_speed(a6)		; Set speed

.End:
	move.w	#4,obj.collide_width(a6)			; Set hitbox size
	move.w	#4,obj.collide_height(a6)
	rts

; ------------------------------------------------------------------------------

.Speeds:
	dc.w	  0,    0					; No movement
	dc.w	  0,   -$200					; Up
	dc.w	  0,    $200					; Down
	dc.w	-$200,  0					; Left
	dc.w	 $200,  0					; Right

; ------------------------------------------------------------------------------
; Check despawn
; ------------------------------------------------------------------------------

CheckDespawn:
	jsr	CheckObjectDespawn				; Should we despawn?
	bne.s	.End						; If not, branch

	cmpa.w	ao_oni_object,a6				; Are we the active Ao Oni object?
	bne.s	.Delete						; If not, branch
	clr.w	ao_oni_object					; Unset active Ao Oni object

.Delete:
	jsr	ClearObjectSpawnFlag				; Clear spawn flag
	jmp	DeleteObject					; Delete ourselves

.End:
	rts

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	#3,-(sp)					; Draw sprite
	move.b	obj.anim+anim.frame+1(a6),-(sp)
	move.b	obj.flags(a6),-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Animations
; ------------------------------------------------------------------------------

Anim_AoOni:
	dc.w	.IdleDown-Anim_AoOni
	dc.w	.MoveDown-Anim_AoOni
	dc.w	.IdleHoriz-Anim_AoOni
	dc.w	.MoveHoriz-Anim_AoOni
	dc.w	.IdleUp-Anim_AoOni
	dc.w	.MoveUp-Anim_AoOni

.IdleDown:
	ANIM_START $100, ANIM_RESTART
	dc.w	0
	ANIM_END

.MoveDown:
	ANIM_START $30, ANIM_RESTART
	dc.w	1, 0, 2, 0
	ANIM_END

.IdleHoriz:
	ANIM_START $100, ANIM_RESTART
	dc.w	3
	ANIM_END

.MoveHoriz:
	ANIM_START $30, ANIM_RESTART
	dc.w	4, 3, 5, 3
	ANIM_END

.IdleUp:
	ANIM_START $100, ANIM_RESTART
	dc.w	6
	ANIM_END

.MoveUp:
	ANIM_START $30, ANIM_RESTART
	dc.w	7, 6, 8, 6
	ANIM_END

; ------------------------------------------------------------------------------
; Handle chase music
; ------------------------------------------------------------------------------

HandleAoOniMusic:
	cmpi.b	#9,rpg_room_id					; Are we in the hospital hallway?
	bne.s	.End						; If not, branch
	CHECK_EVENT EVENT_HOSPITAL_HALLWAY			; Has the player ran into the hallway?
	beq.s	.End						; If not, branch

	move.w	ao_oni_object,d0				; Is there an active Ao Oni object?
	beq.s	.End						; If not, branch
	movea.w	d0,a6						; Get active Ao Oni object
	
	move.w	obj.y(a6),d0					; Are they off screen at the top?
	addi.w	#16+32,d0
	cmp.w	camera_fg_y,d0
	blt.s	.OffScreen					; If so, branch

	move.w	obj.y(a6),d0					; Are they off screen at the bottom?
	subi.w	#96+32,d0
	move.w	camera_fg_y,d1
	addi.w	#224,d1
	cmp.w	d1,d0
	bgt.s	.OffScreen					; If so, branch
	
	move.w	obj.x(a6),d0					; Are they off screen at the left?
	addi.w	#24+32,d0
	cmp.w	camera_fg_x,d0
	blt.s	.OffScreen					; If so, branch

	move.w	obj.x(a6),d0					; Are they off screen at the right?
	subi.w	#24+32,d0
	move.w	camera_fg_x,d1
	addi.w	#320,d1
	cmp.w	d1,d0
	bgt.s	.OffScreen					; If so, branch
	
	tst.b	ao_oni_chase_music				; Is the timer already set?
	bne.s	.ResetTimer					; If so, branch

	move.w	#$FF29,MARS_COMM_10+MARS_SYS			; Play chase music

.ResetTimer:
	move.b	#150,ao_oni_chase_music				; Set timer
	rts

.OffScreen:
	tst.b	ao_oni_chase_music				; Is the timer active?
	beq.s	.End						; If not, branch
	subq.b	#1,ao_oni_chase_music				; Decrement timer
	bne.s	.End						; If it hasn't run out, branch

	move.w	#$FF00,MARS_COMM_10+MARS_SYS			; Stop chase music

.End:
	rts

; ------------------------------------------------------------------------------
