; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Spring object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjSpring:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer

	move.w	#16,obj.collide_width(a6)			; Set hitbox size
	move.w	#8,obj.collide_height(a6)
	
	move.w	#16,obj.draw_width(a6)				; Set draw size
	move.w	#8,obj.draw_height(a6)

	lea	obj.anim(a6),a0					; Set spring color
	lea	Anim_Spring(pc),a1
	moveq	#0,d0
	move.b	obj.subtype(a6),d0
	jsr	SetAnimation

	move.l	#ObjSpringUpdate,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

ObjSpringUpdate:
	btst	#0,obj.anim+anim.id+1(a6)			; Are we animating?
	bne.s	.Draw						; If so, branch

	movea.w	player_object,a1				; Player object
	
	cmpa.w	player.ride_object(a1),a6			; Is the player standing on us?
	bne.s	.NotStoodOn					; If not, branch

	move.w	#-$1000,d0					; Get strength
	btst	#1,obj.subtype(a6)
	beq.s	.BouncePlayer
	move.w	#-$A00,d0

.BouncePlayer:
	addq.w	#8,obj.y(a1)					; Align with spring

	move.w	d0,obj.y_speed(a1)				; Bounce the player in the air
	move.l	a6,-(sp)
	movea.w	a1,a6
	jsr	SetSonicPlayerAirborne
	movea.l	(sp)+,a6

	lea	obj.anim(a6),a0					; Set bounce animation
	lea	Anim_Spring(pc),a1
	moveq	#0,d0
	move.b	obj.subtype(a6),d0
	addq.w	#1,d0
	jsr	SetAnimation

	lea	Sfx_Spring,a0					; Play spring sound
	jsr	PlaySfx
	bra.s	.Draw

.NotStoodOn:
	moveq	#OBJ_FULL_SOLID,d0				; Make solid
	jsr	SolidObject

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	jsr	DrawObject					; Draw sprite
	jmp	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	#6,-(sp)					; Draw sprite
	move.b	obj.anim+anim.frame+1(a6),-(sp)
	clr.b	-(sp)
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

Anim_Spring:
	dc.w	.StaticRed-Anim_Spring
	dc.w	.BounceRed-Anim_Spring
	dc.w	.StaticYellow-Anim_Spring
	dc.w	.BounceYellow-Anim_Spring

.StaticRed:
	ANIM_START $100, ANIM_RESTART
	dc.w	0
	ANIM_END

.BounceRed:
	ANIM_START $80, ANIM_SWITCH, 0
	dc.w	1, 2, 3, 4, 5, 6, 7
	ANIM_END

.StaticYellow:
	ANIM_START $100, ANIM_RESTART
	dc.w	8
	ANIM_END

.BounceYellow:
	ANIM_START $80, ANIM_SWITCH, 2
	dc.w	9, 10, 11, 12, 13, 14, 15
	ANIM_END

; ------------------------------------------------------------------------------
