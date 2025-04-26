; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Rock object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjRock:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer

	move.w	#16,obj.collide_width(a6)			; Set hitbox size
	move.w	#16,obj.collide_height(a6)
	
	move.w	#24,obj.draw_width(a6)				; Set draw size
	move.w	#16,obj.draw_height(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	moveq	#OBJ_FULL_SOLID,d0				; Make solid
	jsr	SolidObject

	jsr	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	#3,-(sp)					; Draw sprite
	clr.b	-(sp)
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
