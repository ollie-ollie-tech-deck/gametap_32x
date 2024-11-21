; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Slenderman boss object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjSlendermanBoss:
	SET_OBJECT_LAYER move.w,0,obj.layer(a6)			; Set layer

	move.w	#32,obj.collide_width(a6)			; Set hitbox size
	move.w	#48,obj.collide_height(a6)
	
	move.w	#160,obj.draw_width(a6)				; Set draw size
	move.w	#128,obj.draw_height(a6)

	move.w	#160,obj.x(a6)					; Set position
	move.w	#256,obj.y(a6)
	move.w	#$100,slenderman.scale(a6)			; Set scale

	move.b	#8,slenderman.hit_count(a6)			; Set hit count

	move.l	#MoveUpState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Move up state
; ------------------------------------------------------------------------------

MoveUpState:
	subq.w	#1,obj.y(a6)					; Move up
	cmpi.w	#64,obj.y(a6)					; Have we moved all the way up?
	bgt.s	.Draw						; If not, branch
	
	move.w	#64,obj.y(a6)					; Stop moving
	move.l	#AttackState,obj.update(a6)			; Set attack state

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Attack state
; ------------------------------------------------------------------------------

AttackState:
	tst.b	slenderman.flash(a6)				; Are we flashing?
	bne.w	CheckFlashDraw					; If so, branch

	jsr	SpawnObject					; Spawn left fist
	move.l	#ObjFist,obj.update(a1)
	move.w	#64,obj.x(a1)
	move.w	a1,slenderman.fist(a6)

	move.l	#.WaitLeftFist,obj.update(a6)			; Wait for the left fist to finish

; ------------------------------------------------------------------------------

.WaitLeftFist:
	movea.w	slenderman.fist(a6),a1				; Has the fist disappeared?
	tst.l	obj.update(a1)
	bne.s	.Draw						; If not, branch

	jsr	SpawnObject					; Spawn right fist
	move.l	#ObjFist,obj.update(a1)
	bset	#OBJ_FLIP_X,obj.flags(a1)
	move.w	#256,obj.x(a1)
	move.w	a1,slenderman.fist(a6)

	move.l	#.WaitRightFist,obj.update(a6)			; Wait for the right fist to finish

; ------------------------------------------------------------------------------

.WaitRightFist:
	movea.w	slenderman.fist(a6),a1				; Has the fist disappeared?
	tst.l	obj.update(a1)
	bne.s	.Draw						; If not, branch

	move.l	#MoveForwardState,obj.update(a6)		; Start moving forward

; ------------------------------------------------------------------------------

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Move forward state
; ------------------------------------------------------------------------------

MoveForwardState:
	subq.w	#4,slenderman.scale(a6)				; Move forward
	cmpi.w	#$60,slenderman.scale(a6)			; Have we moved all the way?
	bgt.s	.Draw						; If not, wait

	move.l	#.Wait,obj.update(a6)				; Wait for a bit
	move.b	#120,slenderman.timer(a6)

; ------------------------------------------------------------------------------

.Wait:
	subq.b	#1,slenderman.timer(a6)				; Decrement timer
	beq.s	.MoveBackward					; If it has run out, branch

	jsr	BossObject					; Have we been hit?
	bne.s	.Draw						; If not, branch
	
	lea	Sfx_HitBoss,a0					; Play hit boss sound
	jsr	PlaySfx

	subq.b	#1,slenderman.hit_count(a6)			; Decrement hit count
	bne.s	.GotHit						; If we haven't been defeated, branch
	move.l	#DefeatedState,obj.update(a6)			; Set defeated state

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------

.GotHit:
	move.b	#140,slenderman.flash(a6)			; Start flashing
	move.l	#HitState,obj.update(a6)
	bra.s	.Draw

.MoveBackward:
	move.l	#MoveBackwardState,obj.update(a6)		; Start moving backward
	bra.s	.Draw

; ------------------------------------------------------------------------------
; Hit state
; ------------------------------------------------------------------------------

HitState:
	addq.w	#2,slenderman.scale(a6)				; Move backward
	cmpi.w	#$100,slenderman.scale(a6)			; Have we moved all the way?
	blt.s	CheckFlashDraw					; If not, wait

	move.l	#AttackState,obj.update(a6)			; Start attacking again

; ------------------------------------------------------------------------------
; Flash and check for drawing
; ------------------------------------------------------------------------------

CheckFlashDraw:
	tst.b	slenderman.flash(a6)				; Are we flashing?
	beq.s	.Draw						; If not, branch
	
	subq.b	#1,slenderman.flash(a6)				; Decrement flash timer
	cmpi.b	#60,slenderman.flash(a6)			; Should we stop flashing the sprite?
	bcs.s	.Draw						; If so, branch

	btst	#3,slenderman.flash(a6)				; Should we draw on this frame?
	bne.s	.Draw						; If so, branch
	rts

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Move backward state
; ------------------------------------------------------------------------------

MoveBackwardState:
	addq.w	#4,slenderman.scale(a6)				; Move backward
	cmpi.w	#$100,slenderman.scale(a6)			; Have we moved all the way?
	blt.s	.Draw						; If not, wait

	move.l	#AttackState,obj.update(a6)			; Start attacking again

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Defeated state
; ------------------------------------------------------------------------------

DefeatedState:
	st	boss_end					; End of boss
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	clr.b	-(sp)						; Draw sprite
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	slenderman.scale(a6),-(sp)
	move.w	slenderman.scale(a6),-(sp)
	jsr	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Fist initialization state
; ------------------------------------------------------------------------------

ObjFist:
	SET_OBJECT_LAYER move.w,0,obj.layer(a6)			; Set layer

	move.w	#24,obj.collide_width(a6)			; Set hitbox size
	move.w	#28,obj.collide_height(a6)
	
	move.w	#32,obj.draw_width(a6)				; Set draw size
	move.w	#32,obj.draw_height(a6)

	move.w	#256,obj.y(a6)					; Set Y position
	move.w	#-$E80,obj.y_speed(a6)				; Move up

	move.l	#FistMoveUpState,obj.update(a6)			; Set state
	move.l	#DrawFist,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Fist move up state
; ------------------------------------------------------------------------------

FistMoveUpState:
	jsr	MoveObject					; Move
	addi.w	#$80,obj.y_speed(a6)				; Slow down
	bmi.s	.Draw						; If we haven't stopped, branch

	clr.w	obj.y_speed(a6)					; Stop moving
	move.l	#FistFollowState,obj.update(a6)			; Start following the player

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Fist follow state
; ------------------------------------------------------------------------------

FistFollowState:
	move.w	#180,slender_fist.timer(a6)			; Set timer
	move.l	#.Follow,obj.update(a6)				; Start following

; ------------------------------------------------------------------------------

.Follow:
	subq.w	#1,slender_fist.timer(a6)			; Decrement timer
	beq.s	.Slam						; If it has run out, branch

	movea.w	player_object,a1				; Get speed to move towards player
	move.w	obj.x(a1),d0
	sub.w	obj.x(a6),d0
	asl.w	#3,d0

	cmpi.w	#-$400,d0					; Is it too large for moving left?
	bge.s	.CheckRightMax					; If not, branch
	move.w	#-$400,d0					; Cap the speed

.CheckRightMax:
	cmpi.w	#$400,d0					; Is it too large for moving right?
	ble.s	.SetXSpeed					; If not, branch
	move.w	#$400,d0					; Cap the speed

.SetXSpeed:
	move.w	d0,obj.x_speed(a6)				; Set X speed

	jsr	MoveObject					; Move

	cmpi.w	#32,obj.x(a6)					; Are we at the left edge of the screen?
	bge.s	.CheckRight					; If not, branch

	move.w	#32,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)

.CheckRight:
	cmpi.w	#288,obj.x(a6)					; Are we at the right edge of the screen?
	ble.s	.Draw						; If not, branch

	move.w	#288,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)

.Draw:
	jmp	DrawObject					; Draw sprite

.Slam:
	clr.w	obj.x_speed(a6)					; Prepare to slam
	move.w	#15,slender_fist.timer(a6)
	move.l	#FistSlamState,obj.update(a6)

; ------------------------------------------------------------------------------
; Fist slam state
; ------------------------------------------------------------------------------

FistSlamState:
	subq.w	#1,slender_fist.timer(a6)			; Decrement timer
	bne.s	.Draw						; If it hasn't run out, branch
	
	move.w	#-$600,obj.y_speed(a6)				; Start slamming
	move.l	#.Slam,obj.update(a6)

; ------------------------------------------------------------------------------

.Slam:
	jsr	HazardObject					; Hazard object

	jsr	MoveObject					; Move
	addi.w	#$80,obj.y_speed(a6)				; Apply gravity

	tst.w	obj.y_speed(a6)					; Are we falling?
	bmi.s	.Draw						; If not, branch

	jsr	ObjMapCollideDownWide				; Check floor collision
	tst.w	d1
	bpl.s	.Draw						; If there was no collision, branch

	add.w	d1,obj.y(a6)					; Align with floor
	clr.w	obj.y_speed(a6)					; Stop moving
	
	lea	Sfx_Thump,a0					; Play thump sound
	jsr	PlaySfx
	
	move.w	#-$600,obj.y_speed(a6)				; Start leaving
	move.l	#FistLeaveState,obj.update(a6)

.Draw:
	jmp	DrawObject					; Draw

; ------------------------------------------------------------------------------
; Fist leave state
; ------------------------------------------------------------------------------

FistLeaveState:
	jsr	MoveObject					; Move
	addi.w	#$80,obj.y_speed(a6)				; Apply gravity

	cmpi.w	#256,obj.y(a6)					; Are we gone?
	blt.s	.Draw						; If not, branch
	jmp	DeleteObject					; Delete ourselves

.Draw:
	jmp	DrawObject					; Draw

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

DrawFist:
	clr.b	-(sp)						; Draw sprite
	move.b	#1,-(sp)
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
