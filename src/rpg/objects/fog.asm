; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Fog object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/rpg/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjFog:
	SET_OBJECT_LAYER move.w,7,obj.layer(a6)			; Set layer

	move.w	#160,obj.draw_width(a6)				; Set draw size
	move.w	#112,obj.draw_height(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	move.w	camera_fg_x,obj.x(a6)				; Make sure we stay drawn
	move.w	camera_fg_y,obj.y(a6)

	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	lea	mars_sprite_chain,a0				; Sprite chain buffer
	move.w	#16,(a0)+					; Set sprite count

	move.w	camera_fg_y_draw,d0				; Get offset
	neg.w	d0
	ext.l	d0
	divs.w	#80,d0
	move.l	d0,d1
	swap	d1
	andi.w	#1,d0
	lsl.w	#7,d0

	bsr.s	.DrawFogCloudRow				; Set cloud row
	eori.w	#$80,d0
	
	addi.w	#80,d1						; Set cloud row
	bsr.s	.DrawFogCloudRow
	eori.w	#$80,d0
	
	addi.w	#80,d1						; Set cloud row
	bsr.s	.DrawFogCloudRow
	eori.w	#$80,d0

	addi.w	#80,d1						; Set cloud row
	bsr.s	.DrawFogCloudRow

	move.b	#2,-(sp)					; Draw sprites
	pea	mars_sprite_chain
	jsr	DrawLoadedMarsSpriteChain
	rts

; ------------------------------------------------------------------------------

.DrawFogCloudRow:
	move.w	stage_frame_count,d2				; Get X offset
	add.w	camera_fg_x_draw,d2
	add.w	d0,d2
	neg.w	d2
	ext.l	d2
	divs.w	#320,d2
	swap	d2

	bsr.s	.DrawFogCloud					; Set cloud

	addi.w	#320,d2						; Set cloud

; ------------------------------------------------------------------------------

.DrawFogCloud:
	movem.w	d0-d2,-(sp)					; Set sprite (left)
	move.b	#3,(a0)+
	clr.b	(a0)+
	addi.w	#80,d2
	move.w	d2,(a0)+
	addi.w	#48,d1
	move.w	d1,(a0)+
	movem.w	(sp),d0-d2
	
	move.b	#4,(a0)+					; Set sprite (right)
	clr.b	(a0)+
	addi.w	#240,d2
	move.w	d2,(a0)+
	addi.w	#48,d1
	move.w	d1,(a0)+
	movem.w	(sp)+,d0-d2

.End:
	rts

; ------------------------------------------------------------------------------
