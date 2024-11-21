; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Newtron object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjNewtron:
	SET_OBJECT_LAYER move.w,5,obj.layer(a6)			; Set layer

	move.w	#16,obj.collide_width(a6)			; Set hitbox size
	move.w	#16,obj.collide_height(a6)
	
	move.w	#24,obj.draw_width(a6)				; Set draw size
	move.w	#24,obj.draw_height(a6)

	lea	newtron.fire_anim(a6),a0			; Set fire animation
	lea	Anim_Newtron(pc),a1
	moveq	#4,d0
	jsr	SetAnimation

	move.l	#WaitPlayerState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Wait for player state
; ------------------------------------------------------------------------------

WaitPlayerState:
	bset	#OBJ_FLIP_X,obj.flags(a6)			; Face right

	movea.w	player_object,a1				; Get distance from player
	move.w	obj.x(a1),d0
	sub.w	obj.x(a6),d0
	bpl.s	.CheckDistance					; If the player is right of us, branch
	
	neg.w	d0						; Get absolute distance
	bclr	#OBJ_FLIP_X,obj.flags(a6)			; Face left

.CheckDistance:
	cmpi.w	#128,d0						; Are we near the player?
	bcc.s	.End						; If not, branch

	move.l	#BlueAppearState,obj.update(a6)			; Set appear state (blue)
	moveq	#0,d0

	tst.b	obj.subtype(a6)					; Is this a green Newtron?
	beq.s	.SetAnimation					; If not, branch

	move.l	#GreenAppearState,obj.update(a6)		; Set appear state (green)
	moveq	#2,d0

.SetAnimation:
	lea	obj.anim(a6),a0					; Set animation
	lea	Anim_Newtron(pc),a1
	jsr	SetAnimation

.End:
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Appear state (blue)
; ------------------------------------------------------------------------------

BlueAppearState:
	cmpi.w	#13,obj.anim+anim.frame(a6)			; Are we still appearing?
	bcs.s	.CheckFall					; If so, branch
	bsr.w	BadnikObject					; Badnik object

.CheckFall:
	cmpi.w	#6,obj.anim+anim.frame(a6)			; Are we about to fall?
	bcc.s	.Fall						; If so, branch

	bset	#OBJ_FLIP_X,obj.flags(a6)			; Face right
	
	movea.w	player_object,a1				; Is the player right of us?
	move.w	obj.x(a1),d0
	sub.w	obj.x(a6),d0
	bpl.s	.Draw						; If so, branch
	
	bclr	#OBJ_FLIP_X,obj.flags(a6)			; Face left
	bra.s	.Draw

.Fall:
	bsr.w	MoveObject					; Apply speed
	addi.w	#$38,obj.y_speed(a6)

	move.w	#16,obj.collide_width(a6)			; Set new hitbox size
	move.w	#8,obj.collide_height(a6)

	bsr.w	ObjMapCollideDown				; Check floor collision
	tst.w	d1
	bpl.s	.Draw						; If there was no collision, branch
	
	add.w	d1,obj.y(a6)					; Align with floor
	clr.w	obj.y_speed(a6)					; Stop moving downwards

	move.l	#BlueMoveState,obj.update(a6)			; Set move state

	lea	obj.anim(a6),a0					; Set move animation
	lea	Anim_Newtron(pc),a1
	moveq	#1,d0
	jsr	SetAnimation

	move.w	#$200,obj.x_speed(a6)				; Start moving
	btst	#OBJ_FLIP_X,obj.flags(a6)
	bne.s	.Draw
	neg.w	obj.x_speed(a6)

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Move state (blue)
; ------------------------------------------------------------------------------

BlueMoveState:
	bsr.w	BadnikObject					; Badnik object
	bsr.w	MoveObject					; Apply speed

	bsr.w	ObjMapCollideDown				; Check floor collision
	cmpi.w	#-8,d1						; Did we hit a wall?
	blt.s	.Airborne					; If so, branch
	cmpi.w	#$C,d1						; Did we reach a cliff?
	bge.s	.Airborne					; If so, branch

	add.w	d1,obj.y(a6)					; Align with floor
	bra.s	.Draw

.Airborne:
	move.l	#BlueAirState,obj.update(a6)			; Set air state

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation

	lea	newtron.fire_anim(a6),a0			; Animate fire sprite
	jsr	UpdateAnimation
	
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Move in the air state (blue)
; ------------------------------------------------------------------------------

BlueAirState:
	bsr.w	BadnikObject					; Badnik object
	bsr.w	MoveObject					; Apply speed
	
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation

	lea	newtron.fire_anim(a6),a0			; Animate fire sprite
	jsr	UpdateAnimation

	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Appear state (green)
; ------------------------------------------------------------------------------

GreenAppearState:
	cmpi.w	#3,obj.anim+anim.frame(a6)			; Are we still appearing?
	bcs.s	.CheckDisappear					; If so, branch
	bsr.w	BadnikObject					; Badnik object

.CheckDisappear:
	cmpi.w	#3,obj.anim+anim.id(a6)				; Should we disappear?
	bne.s	.NoDisappear					; If not, branch
	bra.w	DeleteObject					; Delete ourselves

.NoDisappear:
	cmpi.w	#15,obj.anim+anim.frame(a6)			; Should we shoot a missile?
	bne.s	.NoShoot					; If not, branch

	bset	#0,obj.flags+1(a6)				; Set shoot flag
	bne.s	.NoShoot					; If it's already set, branch

	bsr.w	SpawnObject					; Spawn missile
	bne.s	.NoShoot					; If it failed, branch
	
	move.l	#ObjMissile,obj.update(a1)			; Setup missile
	move.b	obj.flags(a6),obj.flags(a1)
	move.w	obj.x(a6),obj.x(a1)
	move.w	obj.y(a6),obj.y(a1)
	subq.w	#8,obj.y(a1)
	move.w	#$200,obj.x_speed(a1)
	
	moveq	#20,d0						; Get X offset
	btst	#OBJ_FLIP_X,obj.flags(a6)
	bne.s	.SetMissileX
	neg.w	d0
	neg.w	obj.x_speed(a1)

.SetMissileX:
	add.w	d0,obj.x(a1)					; Add X offset

.NoShoot:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	#$B,-(sp)					; Draw sprite
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

	tst.w	obj.x_speed(a6)					; Are we moving?
	beq.s	.End						; If not, branch
	
	move.b	#$B,-(sp)					; Draw fire sprite
	move.b	newtron.fire_anim+anim.frame+1(a6),-(sp)
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

.End:
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

	lea	obj.anim(a6),a0					; Set animation
	lea	Anim_Newtron(pc),a1
	moveq	#5,d0
	jsr	SetAnimation

	move.l	#MoveMissileState,obj.update(a6)		; Set state
	move.l	#DrawMissile,obj.draw(a6)			; Set draw routine

; ------------------------------------------------------------------------------
; Move missile state
; ------------------------------------------------------------------------------

MoveMissileState:
	bsr.w	HazardObject					; Hazard object
	
	bsr.w	CheckObjectOnScreen				; Are we onscreen?
	bne.s	.Destroy					; If not, branch

	bsr.w	MoveObject					; Apply speed
	
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite

.Destroy:
	bra.w	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Draw missile sprite
; ------------------------------------------------------------------------------

DrawMissile:
	move.b	#$B,-(sp)					; Draw missile sprite
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

Anim_Newtron:
	dc.w	.BlueAppear-Anim_Newtron
	dc.w	.BlueMove-Anim_Newtron
	dc.w	.Green-Anim_Newtron
	dc.w	.GreenDone-Anim_Newtron
	dc.w	.Fire-Anim_Newtron
	dc.w	.Missile-Anim_Newtron

.BlueAppear:
	ANIM_START $68, ANIM_LOOP_POINT, 20
	dc.w	0, 0, 1, 1, 2
	dc.w	3, 3, 3, 3, 3, 3, 3, 3, 3, 3
	dc.w	4, 5, 6, 7, 8, 9
	ANIM_END

.BlueMove:
	ANIM_START $100, ANIM_RESTART
	dc.w	9
	ANIM_END

.Green:
	ANIM_START $68, ANIM_SWITCH, 3
	dc.w	10, 10, 11, 11, 12
	dc.w	13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13
	dc.w	14, 15, 15, 16
	dc.w	13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13
	dc.w	13, 13, 13, 13, 13, 13, 13
	dc.w	12, 11, 11, 10
	ANIM_END

.GreenDone:
	ANIM_START $100, ANIM_RESTART
	dc.w	10
	ANIM_END

.Fire:
	ANIM_START $80, ANIM_RESTART
	dc.w	17, 18, 19, 20
	ANIM_END

.Missile:
	ANIM_START $80, ANIM_RESTART
	dc.w	21, 22, 23, 24, 25, 26
	ANIM_END

; ------------------------------------------------------------------------------
