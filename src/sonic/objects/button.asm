; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Button object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjButton:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer

	move.w	#14,obj.collide_width(a6)			; Set hitbox size
	move.w	#8,obj.collide_height(a6)
	
	move.w	#16,obj.draw_width(a6)				; Set draw size
	move.w	#8,obj.draw_height(a6)

	move.l	#UnpressedState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UnpressedState:
	movea.w	player_object,a1				; Player object
	
	cmpa.w	player.ride_object(a1),a6			; Is the player standing on us?
	bne.s	.NotStoodOn					; If not, branch

	move.w	#14,obj.collide_width(a6)			; Set hitbox size
	move.w	#2,obj.collide_height(a6)
	addq.w	#6,obj.y(a1)
	addq.w	#6,obj.previous_y(a1)

	move.w	#1,obj.anim+anim.frame(a6)			; Set pressed frame

	moveq	#0,d0						; Set button flag
	move.b	obj.subtype(a6),d0
	bset	d0,button_flags

	move.l	#PressedState,obj.update(a6)			; Set pressed state
	bra.s	PressedState

.NotStoodOn:
	moveq	#OBJ_FULL_SOLID,d0				; Make solid
	jsr	SolidObject

	jsr	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Pressed state
; ------------------------------------------------------------------------------

PressedState:
	movea.w	player_object,a1				; Player object
	
	cmpa.w	player.ride_object(a1),a6			; Is the player standing on us?
	beq.s	.StoodOn					; If so, branch

	move.w	#14,obj.collide_width(a6)			; Set hitbox size
	move.w	#8,obj.collide_height(a6)
	subq.w	#6,obj.y(a1)
	subq.w	#6,obj.previous_y(a1)

	clr.w	obj.anim+anim.frame(a6)				; Set unpressed frame

	moveq	#0,d0						; Clear button flag
	move.b	obj.subtype(a6),d0
	bclr	d0,button_flags

	move.l	#UnpressedState,obj.update(a6)			; Set unpressed state
	bra.s	UnpressedState

.StoodOn:
	moveq	#OBJ_FULL_SOLID,d0				; Make solid
	jsr	SolidObject

	jsr	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	#$C,-(sp)					; Draw sprite
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
