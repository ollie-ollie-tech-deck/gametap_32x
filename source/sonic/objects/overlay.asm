; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Overlay object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjSonicOverlay:
	SET_OBJECT_LAYER move.w,4,obj.layer(a6)			; Set layer
	
	move.w	#40,obj.draw_width(a6)				; Set draw size
	move.w	#32,obj.draw_height(a6)
	
	tst.b	obj.subtype(a6)					; Is this a loop overlay?
	bne.s	.NotLoop					; If not, branch
	
	move.w	#112,obj.draw_width(a6)				; Set draw size
	move.w	#112,obj.draw_height(a6)

.NotLoop:
	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	tst.b	obj.subtype(a6)					; Is this a loop overlay?
	beq.s	.Loop						; If so, branch

	clr.b	-(sp)						; Draw sprite
	move.b	obj.subtype(a6),d0
	addi.b	#13,d0
	move.b	d0,-(sp)
	clr.b	-(sp)
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

.Loop:
	lea	.Pieces(pc),a0					; Sprite pieces
	movea.w	player_object,a1				; Player object
	moveq	#(.PiecesEnd-.Pieces)/6-1,d6			; Number of pieces

.DrawPieces:
	move.b	(a0)+,d0					; Frame ID
	move.b	(a0)+,d1					; Flip flags
	move.w	obj.x(a6),d2					; X
	add.w	(a0)+,d2
	move.w	obj.y(a6),d3					; Y
	add.w	(a0)+,d3

	move.w	obj.x(a1),d4					; Get horizontal distance from player object
	sub.w	d2,d4
	bpl.s	.CheckXDistance
	neg.w	d4

.CheckXDistance:
	cmpi.w	#32+4,d4					; Should we draw this piece?
	bge.s	.NextPiece					; If not, branch

	move.w	obj.y(a1),d5					; Get vertical distance from player object
	sub.w	d3,d5
	bpl.s	.CheckDraw
	neg.w	d5

.CheckDraw:
	cmpi.w	#32+4,d5
	bge.s	.NextPiece					; If not, branch

	move.w	a1,-(sp)					; Draw sprite piece
	clr.b	-(sp)
	move.b	d0,-(sp)
	move.b	d1,-(sp)
	sub.w	camera_fg_x_draw,d2
	move.w	d2,-(sp)
	sub.w	camera_fg_y_draw,d3
	move.w	d3,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite
	movea.w	(sp)+,a1

.NextPiece:
	dbf	d6,.DrawPieces					; Loop until finished
	rts
	
; ------------------------------------------------------------------------------

.Pieces:
	dc.b	0, %00
	dc.w	16+0, 16-128
	dc.b	1, %00
	dc.w	16+32, 16-128
	dc.b	2, %00
	dc.w	16+32, 16-96
	dc.b	3, %00
	dc.w	16+64, 16-128
	dc.b	3, %00
	dc.w	16+96, 16-128
	dc.b	4, %00
	dc.w	16+64, 16-96
	dc.b	5, %00
	dc.w	16+96, 16-96
	dc.b	6, %00
	dc.w	16+64, 16-64
	dc.b	5, %00
	dc.w	16+96, 16-64
	dc.b	6, %10
	dc.w	16+64, 16-32
	dc.b	5, %00
	dc.w	16+96, 16-32
	dc.b	7, %00
	dc.w	16-64, 16+32
	dc.b	8, %00
	dc.w	16-32, 16+32
	dc.b	9, %00
	dc.w	16+0, 16+32
	dc.b	10, %00
	dc.w	16+32, 16+0
	dc.b	11, %00
	dc.w	16+32, 16+32
	dc.b	12, %00
	dc.w	16+64, 16+0
	dc.b	13, %00
	dc.w	16+96, 16+0
	dc.b	13, %00
	dc.w	16+64, 16+32
	dc.b	3, %10
	dc.w	16+0, 16+64
	dc.b	3, %10
	dc.w	16+32, 16+64
.PiecesEnd:

; ------------------------------------------------------------------------------
