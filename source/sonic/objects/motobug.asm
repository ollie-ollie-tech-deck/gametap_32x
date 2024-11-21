; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Motobug object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjMotobug:
	SET_OBJECT_LAYER move.w,5,obj.layer(a6)			; Set layer

	move.w	#8,obj.collide_width(a6)			; Set hitbox size
	move.w	#14,obj.collide_height(a6)
	
	move.w	#32,obj.draw_width(a6)				; Set draw size
	move.w	#16,obj.draw_height(a6)

	lea	obj.anim(a6),a0					; Set wait animation
	lea	Anim_Motobug(pc),a1
	moveq	#1,d0
	jsr	SetAnimation

	st	motobug.smoke_frame(a6)				; Reset smoke animation

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
	bchg	#OBJ_FLIP_X,obj.flags(a6)			; Face the other way

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

	subq.w	#1,motobug.wait_timer(a6)			; Decrement wait timer
	bpl.s	.Draw						; If it hasn't run out, branch
	
	lea	obj.anim(a6),a0					; Set turn animation
	lea	Anim_Motobug(pc),a1
	moveq	#2,d0
	jsr	SetAnimation

	move.l	#TurnState,obj.update(a6)			; Set turn state

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Turn state
; ------------------------------------------------------------------------------

TurnState:
	bsr.w	BadnikObject					; Badnik object

	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation

	tst.w	obj.anim+anim.id(a6)				; Has the animation switched?
	bne.s	.Draw						; If not, wait

	move.l	#MoveState,obj.update(a6)			; Set movement state
	move.w	#-$100,obj.x_speed(a6)				; Set X speed

	bchg	#OBJ_FLIP_X,obj.flags(a6)			; Face the other way
	bne.s	.Draw						; If we are now facing left, branch
	neg.w	obj.x_speed(a6)					; Move the other way

.Draw:
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Movement state
; ------------------------------------------------------------------------------

MoveState:
	bsr.w	BadnikObject					; Badnik object
	bsr.w	MoveObject					; Apply speed

	bsr.w	ObjMapCollideDown				; Check floor collision
	cmpi.w	#-8,d1						; Did we hit a wall?
	blt.s	.Stop						; If so, branch
	cmpi.w	#$C,d1						; Did we reach a cliff?
	bge.s	.Stop						; If so, branch
	
	add.w	d1,obj.y(a6)					; Align with floor
	
	subq.b	#1,motobug.smoke_timer(a6)			; Decrement smoke timer
	bpl.s	.Draw						; If it hasn't run out, branch
	move.b	#16-1,motobug.smoke_timer(a6)			; Reset smoke timer

	move.b	obj.flags(a6),motobug.smoke_flags(a6)		; Set up smoke
	move.w	obj.x(a6),motobug.smoke_x(a6)
	move.w	obj.y(a6),motobug.smoke_y(a6)
	move.w	#15<<8,motobug.smoke_frame(a6)

	bra.s	.Draw

.Stop:
	move.l	#WaitState,obj.update(a6)			; Set wait state
	move.w	#60-1,motobug.wait_timer(a6)			; Set wait timer
	clr.w	obj.x_speed(a6)					; Stop moving

	lea	obj.anim(a6),a0					; Set wait animation
	lea	Anim_Motobug(pc),a1
	moveq	#1,d0
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
	move.b	#7,-(sp)					; Draw sprite
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

	move.b	motobug.smoke_frame(a6),d0			; Should we draw the smoke?
	bmi.s	.End						; If not, branch
	
	move.b	#7,-(sp)					; Draw smoke sprite
	move.b	d0,-(sp)
	move.b	motobug.smoke_flags(a6),-(sp)
	move.w	motobug.smoke_x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	motobug.smoke_y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite

	addi.w	#$80,motobug.smoke_frame(a6)			; Next smoke frame
	cmpi.b	#23,motobug.smoke_frame(a6)			; Are we done animating?
	bcs.s	.End						; If not, branch
	st	motobug.smoke_frame(a6)				; Stop drawing smoke

.End:
	rts
	
; ------------------------------------------------------------------------------
; Animations
; ------------------------------------------------------------------------------

Anim_Motobug:
	dc.w	.Move-Anim_Motobug
	dc.w	.Wait-Anim_Motobug
	dc.w	.Turn-Anim_Motobug

.Move:
	ANIM_START $50, ANIM_RESTART
	dc.w	0, 1, 2, 3, 4, 5, 6, 7
	ANIM_END

.Wait:
	ANIM_START $50, ANIM_RESTART
	dc.w	8, 9
	ANIM_END

.Turn:
	ANIM_START $50, ANIM_SWITCH, 0
	dc.w	10, 11, 12, 13, 14
	ANIM_END

; ------------------------------------------------------------------------------
