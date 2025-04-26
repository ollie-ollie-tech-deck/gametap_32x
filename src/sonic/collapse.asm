; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Collapsing piece functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialize collapsing pieces
; ------------------------------------------------------------------------------

InitCollapsePieces:
	lea	collapse_pieces,a0				; Initialize collapsing piece pool
	moveq	#collapse.struct_len,d0
	moveq	#COLLAPSE_COUNT,d1
	bra.w	InitList
	
; ------------------------------------------------------------------------------
; Update collapsing pieces
; ------------------------------------------------------------------------------

UpdateCollapsePieces:
	lea	collapse_pieces,a1				; Get first collapsing piece
	move.w	list.head(a1),d0
	beq.s	.End						; If there are no pieces, branch

.UpdateLoop:
	movea.w	d0,a1						; Set piece
	move.w	item.next(a1),-(sp)				; Get next piece

	tst.b	collapse.delay(a1)				; Is the delay timer active?
	beq.s	.NoDelay					; If not, branch
	subq.b	#1,collapse.delay(a1)				; Decrement delay timer
	bne.s	.NextPiece					; If it hasn't run out, branch

.NoDelay:
	move.w	collapse.y_speed(a1),d0				; Make piece fall
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,collapse.y(a1)
	addi.w	#$38,collapse.y_speed(a1)

	move.w	camera_fg_y,d0					; Are we offscreen?
	addi.w	#224+16,d0
	cmp.w	collapse.y(a1),d0
	bge.s	.NextPiece					; If not, branch

	bsr.w	RemoveListItem					; Delete piece

.NextPiece:
	move.w	(sp)+,d0					; Get next piece
	bne.s	.UpdateLoop					; Loop until finished

.End:
	rts
	
; ------------------------------------------------------------------------------
; Draw collapsing pieces
; ------------------------------------------------------------------------------

DrawCollapsePieces:
	movea.w	sprite_slot,a3					; Get sprite slot
	
	lea	collapse_pieces,a1				; Get first collapsing piece
	move.w	list.head(a1),d0
	beq.s	.End						; If there are no pieces, branch

	moveq	#0,d1						; Clear sprite flip index registers
	moveq	#0,d2

; ------------------------------------------------------------------------------

.DrawLoop:
	tst.w	sprite_slots_left				; Are there any sprite slots left?
	bmi.s	.End						; If not, branch

	movea.w	d0,a1						; Set piece
	move.w	item.next(a1),-(sp)				; Get next piece

	move.w	collapse.x(a1),d0				; Get position
	sub.w	camera_fg_x_draw,d0
	move.w	collapse.y(a1),d1
	sub.w	camera_fg_y_draw,d1
	
	cmpi.w	#-32,d1						; Is this piece on screen?
	ble.s	.NextPiece					; If not, branch
	cmpi.w	#224,d1
	bge.s	.NextPiece					; If not, branch
	cmpi.w	#-32,d0
	ble.s	.NextPiece					; If not, branch
	cmpi.w	#320,d0
	bge.s	.NextPiece					; If not, branch

	add.w	d1,(a3)+					; Set Y position

	move.b	collapse.size(a1),(a3)+				; Set size
	addq.w	#1,a3						; Skip link
	move.w	collapse.tile(a1),(a3)+				; Set tile ID

	add.w	d0,(a3)+					; Set X position

	subq.w	#1,sprite_slots_left				; Decrement sprite slots left

.NextPiece:
	move.w	(sp)+,d0					; Get next piece
	bne.s	.DrawLoop					; Loop until finished

.End:
	move.w	a3,sprite_slot					; Update sprite slot
	rts

; ------------------------------------------------------------------------------
