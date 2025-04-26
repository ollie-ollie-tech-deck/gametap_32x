; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Overlay object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/rpg/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjRpgOverlay:
	SET_OBJECT_LAYER move.w,4,obj.layer(a6)			; Set layer
	
	move.w	#16,obj.draw_width(a6)				; Set draw size
	move.w	#16,obj.draw_height(a6)
	
	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

	cmpi.b	#3,obj.subtype(a6)				; Are we the garage overlay?
	bne.s	UpdateState					; If not, branch

	CHECK_EVENT EVENT_LEFT_CAR				; Has Ollie gotten out of the car?
	bne.s	.Delete						; If so, branch
	CHECK_EVENT EVENT_STAGE_1				; Have we beaten stage 1?
	beq.s	.Delete						; If not, branch
	CHECK_EVENT EVENT_STAGE_2				; Have we beaten stage 2?
	bne.s	.Delete						; If so, branch
	
	move.w	#48,obj.draw_width(a6)				; Set garage overlay draw size
	move.w	#32,obj.draw_height(a6)
	
	move.l	#DrawObject,obj.update(a6)			; Set state
	jmp	DrawObject

.Delete:
	jmp	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	movea.w	player_object,a1				; Player object
	
	move.w	obj.x(a1),d0					; Get horizontal distance from player object
	sub.w	obj.x(a6),d0
	bpl.s	.CheckXDistance
	neg.w	d0

.CheckXDistance:
	cmpi.w	#48,d0						; Should we draw this piece?
	bge.s	.End						; If not, branch

	move.w	obj.y(a1),d0					; Get vertical distance from player object
	sub.w	obj.y(a6),d0
	bpl.s	.CheckDraw
	neg.w	d0

.CheckDraw:
	cmpi.w	#48,d0
	bge.s	.End						; If not, branch

	cmpi.b	#1,obj.subtype(a6)				; Are we the counter overlay?
	beq.s	.Layer						; If so, branch
	cmpi.b	#2,obj.subtype(a6)				; Are we the fence overlay?
	bne.s	.Draw						; If not, branch

.Layer:
	movea.w	player_object,a1				; Is the player behind us?
	move.w	obj.y(a1),d0
	cmp.w	obj.y(a6),d0
	ble.s	.Draw						; If so, branch

.End:
	rts

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	#1,-(sp)					; Draw sprite
	move.b	obj.subtype(a6),-(sp)
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
	
.End:
	rts

; ------------------------------------------------------------------------------
