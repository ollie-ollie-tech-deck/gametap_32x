; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sprite functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/framework/md.inc"
	
; ------------------------------------------------------------------------------
; Initialize sprites
; ------------------------------------------------------------------------------
	
InitSprites:
	lea	sprites,a0					; Sprite table
	move.w	a0,sprite_slot
	move.w	#$50-1,sprite_slots_left			; Number of sprites

	moveq	#0,d0						; Sprite Y position
	
	.c: = 0
	rept $50
		.l: = (.c/8)+1
		move.w	d0,.c(a0)
		if .l=$50
			move.b	d0,.c+3(a0)
		else
			move.b	#.l,.c+3(a0)
		endif
		.c: = .c+8
	endr
	rts
	
; ------------------------------------------------------------------------------
; Start drawing sprites
; ------------------------------------------------------------------------------

StartSpriteDraw:
	move.w	#sprites,sprite_slot				; Reset sprite slot
	move.w	#$50-1,sprite_slots_left			; Reset number of sprite slots left
	
	lea	sprites,a0					; Sprite table
	move.w	#128,d0						; Default position
	
	.c: = 0
	rept $50
		move.w	d0,.c(a0)				; Set sprite position
		move.w	d0,.c+6(a0)
		.c: = .c+8
	endr
	rts

; ------------------------------------------------------------------------------
; Finish drawing sprites
; ------------------------------------------------------------------------------

FinishSpriteDraw:
	lea	sprites,a0					; Sprite table
	moveq	#0,d0						; Unused sprite Y position
	
	move.w	sprite_slots_left,d1				; Number of sprite slots left
	subi.w	#$50-1,d1
	neg.w	d1
	
	add.w	d1,d1						; Start moving unused sprites out of the way
	add.w	d1,d1
	jmp	.MoveUnused(pc,d1.w)
	
.MoveUnused:
	pusho
	opt oz-
	.c: = 0
	rept $50
		move.w	d0,.c(a0)				; Move unused sprite out of the way
		.c: = .c+8
	endr
	popo
	rts
	
; ------------------------------------------------------------------------------
; Draw a sprite
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).w  - Y position
;	2(sp).w  - X position
;	4(sp).b  - Flags
;	           Bit 0: X flip
;	           Bit 1: Y flip
;	           Bit 2: Draw 1 direct piece
;	6(sp).w  - Base tile ID
;	8(sp).w  - Sprite frame ID
;	$A(sp).l - Sprite data address
; ------------------------------------------------------------------------------

DrawSprite:
	move.w	sprite_slots_left,d6				; Get number of sprite slots left
	bmi.w	.End						; If there are none left, branch
	
	movea.l	$A+4(sp),a0					; Get sprite data
	movea.w	sprite_slot,a1					; Get sprite slot
	moveq	#1-1,d0						; 1 piece
	
	btst	#2,4+4(sp)					; Should we only draw 1 direct piece?
	bne.s	.Draw						; If so, branch
	
	move.w	8+4(sp),d0					; Get sprite frame data
	add.w	d0,d0
	adda.w	(a0,d0.w),a0
	
	move.w	(a0)+,d0					; Get number of pieces
	subq.w	#1,d0
	bmi.w	.DrawDone					; If there are none, branch

; ------------------------------------------------------------------------------
	
.Draw:
	moveq	#0,d5						; Clear flip table index

	move.b	4+4(sp),d1					; Get flags
	lsr.b	#1,d1						; Should the sprite be flipped horizontally?
	bcs.s	.DrawFlipX					; If so, branch
	lsr.b	#1,d1						; Should the sprite be flipped vertically?
	bcs.w	.DrawFlipY					; If so, branch

; ------------------------------------------------------------------------------

.DrawNoFlip:
	move.b	(a0)+,d1					; Get Y position
	ext.w	d1
	add.w	0+4(sp),d1
	
	move.b	(a0)+,d2					; Get size
	
	move.w	(a0)+,d3					; Get tile ID
	add.w	6+4(sp),d3
	
	move.w	(a0)+,d4					; Get X position
	add.w	2+4(sp),d4
	
	cmpi.w	#-32,d1						; Is this piece on screen?
	ble.s	.SkipPieceNoFlip				; If not, branch
	cmpi.w	#-32,d4
	ble.s	.SkipPieceNoFlip				; If not, branch
	cmpi.w	#224,d1
	bge.s	.SkipPieceNoFlip				; If not, branch
	cmpi.w	#320,d4
	bge.s	.SkipPieceNoFlip				; If not, branch
	
	add.w	d1,(a1)+					; Draw sprite
	move.b	d2,(a1)+
	addq.w	#1,a1
	move.w	d3,(a1)+
	add.w	d4,(a1)+

.NextPieceNoFlip:
	subq.w	#1,d6						; Decrement number of sprite slots left
	dbmi	d0,.DrawNoFlip					; Loop until finished
	bra.w	.DrawDone

.SkipPieceNoFlip:
	dbf	d0,.DrawNoFlip					; Loop until finished
	bra.w	.DrawDone

; ------------------------------------------------------------------------------

.DrawFlipX:
	lsr.b	#1,d1						; Should the sprite be flipped both ways?
	bcs.s	.DrawFlipXY					; If so, branch

; ------------------------------------------------------------------------------

.DrawFlipXLoop:
	move.b	(a0)+,d1					; Get Y position
	ext.w	d1
	add.w	0+4(sp),d1
	
	move.b	(a0)+,d2					; Get size
	
	move.w	(a0)+,d3					; Get tile ID
	add.w	6+4(sp),d3
	eori.w	#$800,d3
	
	move.w	(a0)+,d4					; Get X position
	neg.w	d4
	move.b	.XFlipOffsets(pc,d2.w),d5
	sub.w	d5,d4
	add.w	2+4(sp),d4
	
	cmpi.w	#-32,d1						; Is this piece on screen?
	ble.s	.SkipPieceFlipX					; If not, branch
	cmpi.w	#-32,d4
	ble.s	.SkipPieceFlipX					; If not, branch
	cmpi.w	#224,d1
	bge.s	.SkipPieceFlipX					; If not, branch
	cmpi.w	#320,d4
	bge.s	.SkipPieceFlipX					; If not, branch
	
	add.w	d1,(a1)+					; Draw sprite
	move.b	d2,(a1)+
	addq.w	#1,a1
	move.w	d3,(a1)+
	add.w	d4,(a1)+
	
	subq.w	#1,d6						; Decrement number of sprite slots left
	dbmi	d0,.DrawFlipXLoop				; Loop until finished
	bra.w	.DrawDone

.SkipPieceFlipX:
	dbf	d0,.DrawFlipXLoop				; Loop until finished
	bra.w	.DrawDone

; ------------------------------------------------------------------------------

.XFlipOffsets:
	dc.b	$08, $08, $08, $08
	dc.b	$10, $10, $10, $10
	dc.b	$18, $18, $18, $18
	dc.b	$20, $20, $20, $20

; ------------------------------------------------------------------------------

.DrawFlipXY:
	move.b	(a0)+,d1					; Get Y position
	ext.w	d1
	neg.w	d1
	add.w	0+4(sp),d1
	
	move.b	(a0)+,d2					; Get size and apply Y flip
	move.b	.YFlipOffsets(pc,d2.w),d5
	sub.w	d5,d1
	
	move.w	(a0)+,d3					; Get tile ID
	add.w	6+4(sp),d3
	eori.w	#$1800,d3
	
	move.w	(a0)+,d4					; Get X position
	neg.w	d4
	move.b	.XFlipOffsets(pc,d2.w),d5
	sub.w	d5,d4
	add.w	2+4(sp),d4
	
	cmpi.w	#-32,d1						; Is this piece on screen?
	ble.s	.SkipPieceFlipXY				; If not, branch
	cmpi.w	#-32,d4
	ble.s	.SkipPieceFlipXY				; If not, branch
	cmpi.w	#224,d1
	bge.s	.SkipPieceFlipXY				; If not, branch
	cmpi.w	#320,d4
	bge.s	.SkipPieceFlipXY				; If not, branch
	
	add.w	d1,(a1)+					; Draw sprite
	move.b	d2,(a1)+
	addq.w	#1,a1
	move.w	d3,(a1)+
	add.w	d4,(a1)+
	
	subq.w	#1,d6						; Decrement number of sprite slots left
	dbmi	d0,.DrawFlipXY					; Loop until finished
	bra.w	.DrawDone

.SkipPieceFlipXY:
	dbf	d0,.DrawFlipXY					; Loop until finished
	bra.s	.DrawDone

; ------------------------------------------------------------------------------

.YFlipOffsets:
	dc.b	$08, $10, $18, $20
	dc.b	$08, $10, $18, $20
	dc.b	$08, $10, $18, $20
	dc.b	$08, $10, $18, $20

; ------------------------------------------------------------------------------

.DrawFlipY:
	move.b	(a0)+,d1					; Get Y position
	ext.w	d1
	neg.w	d1
	add.w	0+4(sp),d1
	
	move.b	(a0)+,d2					; Get size and apply Y flip
	move.b	.YFlipOffsets(pc,d2.w),d5
	sub.w	d5,d1
	
	move.w	(a0)+,d3					; Get tile ID
	add.w	6+4(sp),d3
	eori.w	#$1000,d3
	
	move.w	(a0)+,d4					; Get X position
	add.w	2+4(sp),d4
	
	cmpi.w	#-32,d1						; Is this piece on screen?
	ble.s	.SkipPieceFlipY					; If not, branch
	cmpi.w	#-32,d4
	ble.s	.SkipPieceFlipY					; If not, branch
	cmpi.w	#224,d1
	bge.s	.SkipPieceFlipY					; If not, branch
	cmpi.w	#320,d4
	bge.s	.SkipPieceFlipY					; If not, branch
	
	add.w	d1,(a1)+					; Draw sprite
	move.b	d2,(a1)+
	addq.w	#1,a1
	move.w	d3,(a1)+
	add.w	d4,(a1)+
	
	subq.w	#1,d6						; Decrement number of sprite slots left
	dbmi	d0,.DrawFlipY					; Loop until finished
	bra.s	.DrawDone

.SkipPieceFlipY:
	dbf	d0,.DrawFlipY					; Loop until finished
	
; ------------------------------------------------------------------------------

.DrawDone:
	move.w	a1,sprite_slot					; Update sprite slot
	move.w	d6,sprite_slots_left				; Update number of sprite slots left

.End:
	move.l	(sp),$E(sp)					; Deallocate variables and exit
	lea	$E(sp),sp
	rts

; ------------------------------------------------------------------------------
