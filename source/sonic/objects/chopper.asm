; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Chopper object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjChopper:
	SET_OBJECT_LAYER move.w,5,obj.layer(a6)			; Set layer

	move.w	#12,obj.collide_width(a6)			; Set hitbox size
	move.w	#12,obj.collide_height(a6)
	
	move.w	#16,obj.draw_width(a6)				; Set draw size
	move.w	#16,obj.draw_height(a6)
	
	move.w	#-$700,obj.y_speed(a6)				; Jump
	move.w	obj.y(a6),chopper.y_origin(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	bsr.w	BadnikObject					; Badnik object

	bsr.w	MoveObject					; Apply speed
	addi.w	#$18,obj.y_speed(a6)

	move.w	chopper.y_origin(a6),d1				; Have we returned to our original position?
	cmp.w	obj.y(a6),d1
	bcc.s	.GetAnimation					; If not, branch

	move.w	d1,obj.y(a6)					; Jump
	move.w	#-$700,obj.y_speed(a6)

.GetAnimation:
	moveq	#1,d0						; Fast animation

	subi.w	#192,d1						; Are we near the top?
	cmp.w	obj.y(a6),d1
	bcc.s	.SetAnimation					; If not, branch

	moveq	#0,d0						; Slow animation
	tst.w	obj.y_speed(a6)					; Are we at the very top?
	bmi.s	.SetAnimation					; If not, branch
	moveq	#2,d0						; If so, use static animation

.SetAnimation:
	lea	obj.anim(a6),a0					; Set animation
	lea	Anim_Chopper(pc),a1
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
	move.b	#$A,-(sp)					; Draw sprite
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

Anim_Chopper:
	dc.w	.Slow-Anim_Chopper
	dc.w	.Fast-Anim_Chopper
	dc.w	.Static-Anim_Chopper

.Slow:
	ANIM_START $50, ANIM_RESTART
	dc.w	0, 1, 2, 3, 4, 3, 2, 1
	ANIM_END

.Fast:
	ANIM_START $A0, ANIM_RESTART
	dc.w	0, 1, 2, 3, 4, 3, 2, 1
	ANIM_END

.Static:
	ANIM_START $100, ANIM_RESTART
	dc.w	0
	ANIM_END

; ------------------------------------------------------------------------------
