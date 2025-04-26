; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Wall object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjWall:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer

	move.w	#8,obj.collide_width(a6)			; Set hitbox size
	move.w	#32,obj.collide_height(a6)
	
	move.w	#8,obj.draw_width(a6)				; Set draw size
	move.w	#32,obj.draw_height(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	btst	#4,obj.subtype(a6)				; Are we solid?
	bne.s	.NotSolid					; If not, branch

	moveq	#OBJ_HORIZ_SOLID,d0				; Make solid
	jsr	SolidObject

.NotSolid:
	jsr	DrawObject					; Draw sprite
	jmp	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	pea	Spr_Wall					; Draw sprite
	moveq	#$F,d0
	and.b	obj.subtype(a6),d0
	move.w	d0,-(sp)
	move.w	#$449C,-(sp)
	move.b	obj.flags(a6),-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	jsr	DrawSprite
	rts

; ------------------------------------------------------------------------------
