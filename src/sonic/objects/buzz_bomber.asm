; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Buzz Bomber object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjBuzzBomber:
	SET_OBJECT_LAYER move.w,5,obj.layer(a6)			; Set layer

	move.w	#24,obj.collide_width(a6)			; Set hitbox size
	move.w	#8,obj.collide_height(a6)
	
	move.w	#24,obj.draw_width(a6)				; Set draw size
	move.w	#24,obj.draw_height(a6)

	lea	obj.anim(a6),a0					; Set move animation
	lea	Anim_BuzzBomber(pc),a1
	moveq	#0,d0
	jsr	SetAnimation

	lea	buzz_bomber.wing_anim(a6),a0			; Set wing animation
	lea	Anim_BuzzBomber(pc),a1
	moveq	#3,d0
	jsr	SetAnimation

	lea	buzz_bomber.fire_anim(a6),a0			; Set fire animation
	lea	Anim_BuzzBomber(pc),a1
	moveq	#4,d0
	jsr	SetAnimation

	move.l	#WaitState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Wait state
; ------------------------------------------------------------------------------

WaitState:
	bsr.w	BadnikObject					; Badnik object

	subq.w	#1,buzz_bomber.timer(a6)			; Decrement wait timer
	bpl.w	StateEnd					; If it hasn't run out, branch

	btst	#1,obj.flags+1(a6)				; Are we near the player?
	bne.s	.Fire						; If so, branch

	move.l	#StartMoveState,obj.update(a6)			; Set start move state
	
	btst	#0,obj.flags+1(a6)				; Did we fire a missile?
	beq.s	StateEnd					; If not, branch

	lea	obj.anim(a6),a0					; Set fire stop animation
	lea	Anim_BuzzBomber(pc),a1
	moveq	#2,d0
	jsr	SetAnimation
	bra.s	StateEnd

.Fire:
	bsr.w	SpawnObject					; Spawn missile
	bne.s	StateEnd					; If it failed, branch
	
	move.l	#ObjMissile,obj.update(a1)			; Setup missile
	move.b	obj.flags(a6),obj.flags(a1)
	move.w	obj.x(a6),obj.x(a1)
	move.w	obj.y(a6),obj.y(a1)
	move.w	#$200,obj.x_speed(a1)
	move.w	#$200,obj.y_speed(a1)
	addi.w	#28,obj.y(a1)
	move.w	#15-1,buzz_missile.timer(a1)
	move.w	a6,buzz_missile.parent(a1)

	moveq	#16,d0						; Get X offset
	btst	#OBJ_FLIP_X,obj.flags(a6)
	bne.s	.SetMissileX
	neg.w	d0
	neg.w	obj.x_speed(a1)

.SetMissileX:
	add.w	d0,obj.x(a1)					; Add X offset

	move.b	#1,obj.flags+1(a6)				; Mark missile as fired
	move.w	#60-1,buzz_bomber.timer(a6)			; Set wait timer

	lea	obj.anim(a6),a0					; Set fire animation
	lea	Anim_BuzzBomber(pc),a1
	moveq	#1,d0
	jsr	SetAnimation

; ------------------------------------------------------------------------------

StateEnd:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation

StateEnd2:
	lea	buzz_bomber.wing_anim(a6),a0			; Animate wing sprite
	jsr	UpdateAnimation

	lea	buzz_bomber.fire_anim(a6),a0			; Animate fire sprite
	jsr	UpdateAnimation

	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Start move state
; ------------------------------------------------------------------------------

StartMoveState:
	bsr.w	BadnikObject					; Badnik object

	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation

	tst.w	obj.anim+anim.id(a6)				; Has the animation switched?
	bne.s	StateEnd					; If not, wait

	move.l	#MoveState,obj.update(a6)			; Set movement state
	move.w	#128-1,buzz_bomber.timer(a6)			; Set move timer

	move.w	#$400,obj.x_speed(a6)				; Set X speed
	btst	#OBJ_FLIP_X,obj.flags(a6)
	bne.s	CheckNearPlayer
	neg.w	obj.x_speed(a6)
	bra.s	CheckNearPlayer

; ------------------------------------------------------------------------------
; Move state
; ------------------------------------------------------------------------------

MoveState:
	bsr.w	BadnikObject					; Badnik object

	subq.w	#1,buzz_bomber.timer(a6)			; Decrement timer
	bmi.s	ChangeDirection					; If it's time to stop, branch

CheckNearPlayer:
	tst.b	obj.flags+1(a6)					; Did we fire a missile?
	bne.s	.Move						; If so, branch

	movea.w	player_object,a1				; Get distance from player
	move.w	obj.x(a1),d0
	sub.w	obj.x(a6),d0
	bpl.s	.CheckDistance
	neg.w	d0

.CheckDistance:
	cmpi.w	#96,d0						; Are we near the player?
	bcc.s	.Move						; If not, branch

	bsr.w	CheckObjectOnScreen				; Are we onscreen?
	bne.s	.Move						; If not, branch

	move.b	#2,obj.flags+1(a6)				; Mark as near player
	move.w	#30-1,buzz_bomber.timer(a6)			; Set wait timer
	bra.s	StopMoving

.Move:
	bsr.w	MoveObject					; Apply speed
	bra.w	StateEnd

ChangeDirection:
	clr.b	obj.flags+1(a6)					; Clear fire flag
	bchg	#OBJ_FLIP_X,obj.flags(a6)			; Go the other direction
	move.w	#60-1,buzz_bomber.timer(a6)			; Set wait timer

StopMoving:
	move.l	#WaitState,obj.update(a6)			; Set wait state
	clr.w	obj.x_speed(a6)					; Stop moving
	bra.w	StateEnd

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.w	obj.anim+anim.frame(a6),d0			; Get X offset
	add.w	d0,d0
	lea	.Offsets(pc),a0
	move.w	(a0,d0.w),d0
	btst	#OBJ_FLIP_X,obj.flags(a6)
	beq.s	.DrawWing
	neg.w	d0

.DrawWing:
	move.w	d0,-(sp)					; Draw wing sprite
	move.b	#8,-(sp)
	move.b	buzz_bomber.wing_anim+anim.frame+1(a6),-(sp)
	move.b	obj.flags(a6),-(sp)
	move.w	obj.x(a6),d1
	add.w	d0,d1
	sub.w	camera_fg_x_draw,d1
	move.w	d1,-(sp)
	move.w	obj.y(a6),d1
	sub.w	camera_fg_y_draw,d1
	move.w	d1,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite
	
	move.b	#8,-(sp)					; Draw sprite
	move.b	obj.anim+anim.frame+1(a6),-(sp)
	move.b	obj.flags(a6),-(sp)
	move.w	obj.x(a6),d1
	sub.w	camera_fg_x_draw,d1
	move.w	d1,-(sp)
	move.w	obj.y(a6),d1
	sub.w	camera_fg_y_draw,d1
	move.w	d1,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite
	move.w	(sp)+,d0
	
	tst.w	obj.x_speed(a6)					; Are we moving?
	beq.s	.End						; If not, branch
	
	move.b	#8,-(sp)					; Draw fire sprite
	move.b	buzz_bomber.fire_anim+anim.frame+1(a6),-(sp)
	move.b	obj.flags(a6),-(sp)
	move.w	obj.x(a6),d1
	add.w	d0,d1
	sub.w	camera_fg_x_draw,d1
	move.w	d1,-(sp)
	move.w	obj.y(a6),d1
	sub.w	camera_fg_y_draw,d1
	move.w	d1,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite

.End:
	rts

; ------------------------------------------------------------------------------

.Offsets:
	dc.w	0, 1, 2, 3, 4, 4, 4

; ------------------------------------------------------------------------------
; Missile initialization state
; ------------------------------------------------------------------------------

ObjMissile:
	subq.w	#1,buzz_missile.timer(a6)			; Decrement wait timer
	bmi.s	.Initialize					; If it has run out, branch
	bsr.s	CheckMissileDestroy				; Check if the Buzz Bomber has been destroyed
	rts

.Initialize:
	SET_OBJECT_LAYER move.w,5,obj.layer(a6)			; Set layer

	move.w	#8,obj.collide_width(a6)			; Set hitbox size
	move.w	#8,obj.collide_height(a6)
	
	move.w	#16,obj.draw_width(a6)				; Set draw size
	move.w	#16,obj.draw_height(a6)

	lea	obj.anim(a6),a0					; Set animation
	lea	Anim_BuzzBomber(pc),a1
	moveq	#5,d0
	jsr	SetAnimation

	move.l	#WaitMissileState,obj.update(a6)		; Set state
	move.l	#DrawMissile,obj.draw(a6)			; Set draw routine

; ------------------------------------------------------------------------------
; Wait state
; ------------------------------------------------------------------------------

WaitMissileState:
	bsr.w	HazardObject					; Hazard object
	bsr.s	CheckMissileDestroy				; Check if the Buzz Bomber has been destroyed

	cmpi.w	#6,obj.anim+anim.id(a6)				; Has the animation switched?
	bne.s	.Draw						; If not, wait
	move.l	#MoveMissileState,obj.update(a6)		; Set move state

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Check if we should destroy the missile
; ------------------------------------------------------------------------------

CheckMissileDestroy:
	movea.w	buzz_missile.parent(a6),a1			; Has the Buzz Bomber been destroyed?
	cmpi.l	#ObjBuzzBomber,obj.update(a1)
	bcs.s	.Delete						; If so, branch
	cmpi.l	#ObjMissile,obj.update(a1)
	bcs.s	.End						; If not, branch

.Delete:
	addq.w	#4,sp						; Don't return to caller
	bra.w	DeleteObject					; Delete ourselves

.End:
	rts

; ------------------------------------------------------------------------------
; Move missile state
; ------------------------------------------------------------------------------

MoveMissileState:
	bsr.w	HazardObject					; Hazard object
	
	bsr.w	CheckObjectOnScreen				; Are we onscreen?
	bne.s	.Destroy					; If not, branch

	movea.w	buzz_missile.parent(a6),a1			; Has the Buzz Bomber been destroyed?
	tst.w	item.list(a1)
	bne.s	.NoDelete					; If not, branch
	bra.w	DeleteObject					; Delete ourselves

.NoDelete:
	bsr.w	MoveObject					; Apply speed

	move.w	map_fg_bound_bottom,d0				; Are we at the bottom of the stage?
	addi.w	#64,d0
	cmp.w	obj.y(a6),d0
	blt.s	.Destroy					; If soot, branch
	
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite

.Destroy:
	bra.w	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Draw missile sprite
; ------------------------------------------------------------------------------

DrawMissile:
	move.b	#8,-(sp)					; Draw missile sprite
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
	bsr.w	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Animations
; ------------------------------------------------------------------------------

Anim_BuzzBomber:
	dc.w	.Move-Anim_BuzzBomber
	dc.w	.StartShoot-Anim_BuzzBomber
	dc.w	.EndShoot-Anim_BuzzBomber
	dc.w	.Wing-Anim_BuzzBomber
	dc.w	.Fire-Anim_BuzzBomber
	dc.w	.MissileStart-Anim_BuzzBomber
	dc.w	.Missile-Anim_BuzzBomber

.Move:
	ANIM_START $100, ANIM_RESTART
	dc.w	0
	ANIM_END

.StartShoot:
	ANIM_START $A0, ANIM_LOOP_POINT, 5
	dc.w	1, 2, 3, 4, 5, 6
	ANIM_END

.EndShoot:
	ANIM_START $A0, ANIM_SWITCH, 0
	dc.w	5, 4, 3, 2, 1
	ANIM_END

.Wing:
	ANIM_START $100, ANIM_RESTART
	dc.w	7, 8, 9
	ANIM_END

.Fire:
	ANIM_START $80, ANIM_RESTART
	dc.w	10, 11, 12, 13
	ANIM_END

.MissileStart:
	ANIM_START $80, ANIM_SWITCH, 6
	dc.w	14, 15, 16, 17, 18, 19
	ANIM_END

.Missile:
	ANIM_START $80, ANIM_RESTART
	dc.w	20, 21, 22, 23, 24, 25
	ANIM_END

; ------------------------------------------------------------------------------
