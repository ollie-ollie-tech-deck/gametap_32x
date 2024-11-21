; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Crabmeat object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjCrabmeat:
	SET_OBJECT_LAYER move.w,5,obj.layer(a6)			; Set layer

	move.w	#8,obj.collide_width(a6)			; Set hitbox size
	move.w	#16,obj.collide_height(a6)
	
	move.w	#24,obj.draw_width(a6)				; Set draw size
	move.w	#16,obj.draw_height(a6)

	lea	obj.anim(a6),a0					; Set pause animation
	lea	Anim_Crabmeat(pc),a1
	moveq	#1,d0
	jsr	SetAnimation

	move.l	#.Fall,obj.update(a6)				; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------

.Fall:
	bsr.w	BadnikObject					; Badnik object

	bsr.w	MoveObject					; Apply speed
	addi.w	#$38,obj.y_speed(a6)

	bsr.w	ObjMapCollideDown				; Check floor collision
	tst.w	d1
	bpl.s	.Draw						; If there was no collision, branch
	
	add.w	d1,obj.y(a6)					; Align with floor
	clr.w	obj.y_speed(a6)					; Stop moving downwards

	move.l	#WaitState,obj.update(a6)			; Set wait state

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Wait state
; ------------------------------------------------------------------------------

WaitState:
	bsr.w	BadnikObject					; Badnik object

	subq.w	#1,crabmeat.timer(a6)				; Decrement wait timer
	bpl.w	.Draw						; If it hasn't run out, branch
	
	bsr.w	CheckObjectOnScreen				; Are we onscreen?
	bne.s	.DontFire					; If not, branch

	bchg	#1,obj.flags+1(a6)				; Should we fire?
	bne.s	.Fire						; If not, branch

.DontFire:
	move.l	#MoveState,obj.update(a6)			; Set move state
	move.w	#128-1,crabmeat.timer(a6)			; Set move timer

	lea	obj.anim(a6),a0					; Set move animation
	lea	Anim_Crabmeat(pc),a1
	moveq	#0,d0
	jsr	SetAnimation

	move.w	#$80,obj.x_speed(a6)				; Start moving
	bchg	#OBJ_FLIP_X,obj.flags(a6)
	bne.s	.Draw
	neg.w	obj.x_speed(a6)
	bra.s	.Draw

.Fire:
	move.w	#60-1,crabmeat.timer(a6)			; Set wait timer

	lea	obj.anim(a6),a0					; Set fire animation
	lea	Anim_Crabmeat(pc),a1
	moveq	#3,d0
	jsr	SetAnimation
	
	bsr.w	SpawnObject					; Spawn left missile
	bne.s	.FireRight					; If it failed, branch
	
	move.l	#ObjMissile,obj.update(a1)			; Setup left missile
	move.w	obj.x(a6),obj.x(a1)
	move.w	obj.y(a6),obj.y(a1)
	subi.w	#16,obj.x(a1)
	move.w	#-$100,obj.x_speed(a1)

.FireRight:
	bsr.w	SpawnObject					; Spawn right missile
	bne.s	.Draw						; If it failed, branch
	
	move.l	#ObjMissile,obj.update(a1)			; Setup right missile
	move.w	obj.x(a6),obj.x(a1)
	move.w	obj.y(a6),obj.y(a1)
	addi.w	#16,obj.x(a1)
	move.w	#$100,obj.x_speed(a1)

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Movement state
; ------------------------------------------------------------------------------

MoveState:
	bsr.w	BadnikObject					; Badnik object

	subq.w	#1,crabmeat.timer(a6)				; Decrement timer
	bmi.s	.Stop						; If it's time to stop, branch

	bsr.w	MoveObject					; Apply speed

	bchg	#0,obj.flags+1(a6)				; Should we check for ledges?
	bne.s	.AlignFloor					; If not, branch

	moveq	#16,d3						; Check for cliff or wall
	btst	#OBJ_FLIP_X,obj.flags(a6)
	beq.s	.CheckCliffWall
	neg.w	d3

.CheckCliffWall:
	add.w	obj.x(a6),d3
	bsr.w	ObjMapCollideDown2
	cmpi.w	#-8,d1						; Did we hit a wall?
	blt.s	.Stop						; If so, branch
	cmpi.w	#$C,d1						; Did we reach a cliff?
	bge.s	.Stop						; If so, branch
	bra.s	.Draw

.AlignFloor:
	bsr.w	ObjMapCollideDown				; Check floor collision
	add.w	d1,obj.y(a6)					; Align with floor
	
	lea	obj.anim(a6),a0					; Set move animation
	lea	Anim_Crabmeat(pc),a1
	moveq	#0,d0
	jsr	SetAnimation
	bra.s	.Draw

.Stop:
	move.l	#WaitState,obj.update(a6)			; Set wait state
	move.w	#60-1,crabmeat.timer(a6)			; Set wait timer
	clr.w	obj.x_speed(a6)					; Stop moving

	moveq	#1,d0						; Set animation
	btst	#1,obj.flags+1(a6)
	beq.s	.SetAnimation
	moveq	#2,d0

.SetAnimation:
	lea	obj.anim(a6),a0
	lea	Anim_Crabmeat(pc),a1
	jsr	SetAnimation

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	#9,-(sp)					; Draw sprite
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
; Missile initialization state
; ------------------------------------------------------------------------------

ObjMissile:
	SET_OBJECT_LAYER move.w,5,obj.layer(a6)			; Set layer

	move.w	#8,obj.collide_width(a6)			; Set hitbox size
	move.w	#8,obj.collide_height(a6)
	
	move.w	#8,obj.draw_width(a6)				; Set draw size
	move.w	#8,obj.draw_height(a6)
	
	move.w	#-$400,obj.y_speed(a6)				; Set Y speed

	lea	obj.anim(a6),a0					; Set animation
	lea	Anim_Crabmeat(pc),a1
	moveq	#4,d0
	jsr	SetAnimation

	move.l	#MoveMissileState,obj.update(a6)		; Set state
	move.l	#DrawMissile,obj.draw(a6)			; Set draw routine

; ------------------------------------------------------------------------------
; Move missile state
; ------------------------------------------------------------------------------

MoveMissileState:
	bsr.w	HazardObject					; Hazard object
	
	bsr.w	MoveObject					; Apply speed
	addi.w	#$38,obj.y_speed(a6)

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
	move.b	#9,-(sp)					; Draw missile sprite
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

Anim_Crabmeat:
	dc.w	.Move-Anim_Crabmeat
	dc.w	.Wait-Anim_Crabmeat
	dc.w	.FireStart-Anim_Crabmeat
	dc.w	.FireEnd-Anim_Crabmeat
	dc.w	.Missile-Anim_Crabmeat

.Move:
	ANIM_START $30, ANIM_RESTART
	dc.w	0, 1, 2, 3, 4, 5, 6
	ANIM_END

.Wait:
	ANIM_START $100, ANIM_RESTART
	dc.w	0
	ANIM_END

.FireStart:
	ANIM_START $60, ANIM_LOOP_POINT, 2
	dc.w	0, 7, 8
	ANIM_END

.FireEnd:
	ANIM_START $60, ANIM_SWITCH, 1
	dc.w	9, 8, 8, 8
	ANIM_END

.Missile:
	ANIM_START $A0, ANIM_RESTART
	dc.w	10, 11, 12, 13, 14, 15
	ANIM_END

; ------------------------------------------------------------------------------
