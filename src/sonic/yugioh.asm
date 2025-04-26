; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Yu-Gi-Oh card functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialize cards
; ------------------------------------------------------------------------------

InitYugiohCards:
	lea	yugioh_card_states,a0				; Clear card states
	move.w	#YUGIOH_STATE_SLOTS,d0
	bra.w	ClearMemory

; ------------------------------------------------------------------------------
; Check collision with cards
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; ------------------------------------------------------------------------------

CheckYugiohCardCollide:
	movea.l	map_yugioh_cards,a0				; Card data
	lea	yugioh_card_states,a2				; Card states
	
	move.b	camera_fg_x_draw,d0				; Get current chunk
	move.b	camera_fg_y_draw,d1
	ext.w	d0
	ext.w	d1

	bsr.s	CheckCollision					; (0, 0)

	addq.w	#1,d0						; (1, 0)
	bsr.s	CheckCollision

	addq.w	#1,d0						; (2, 0)
	bsr.s	CheckCollision

	subq.w	#2,d0						; (0, 1)
	addq.w	#1,d1
	bsr.s	CheckCollision

	addq.w	#1,d0						; (1, 1)
	bsr.s	CheckCollision

	addq.w	#1,d0						; (2, 1)

; ------------------------------------------------------------------------------
; Check card chunk collision
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Chunk X index
;	d1.w - Chunk Y index
;	a0.l - Card layout address
;	a6.l - Object slot
; ------------------------------------------------------------------------------

CheckCollision:
	movem.l	d0-d1,-(sp)					; Save registers

	cmp.w	(a0),d0						; Is the X index too large?
	bcc.w	.End						; If so, branch
	cmp.w	2(a0),d1					; Is the Y index too large?
	bcc.w	.End						; If so, branch

	add.w	d1,d1						; Get row address
	move.w	4(a0,d1.w),d1
	bmi.w	.End
	lea	(a0,d1.w),a5

	add.w	d0,d0						; Get chunk address
	move.w	(a5,d0.w),d0
	bmi.w	.End						; If it's null, branch
	lea	(a0,d0.w),a5

	move.w	(a5)+,d7					; Get number of cards to check
	subq.w	#1,d7
	bmi.s	.End						; If there are none, branch

	moveq	#16+8,d5					; Position offset
	moveq	#8,d6						; Maximum collision distance

.Check:
	move.w	(a5)+,d0					; Get state entry

	tst.b	(a2,d0.w)					; Has this card already been collected?
	bne.s	.Skip						; If so, branch

	move.w	(a5)+,d1					; Get position
	move.w	(a5)+,d2

	movem.l	obj.collide_width(a6),d3-d4			; Get maximum distance needed for collision
	add.w	d6,d3
	add.w	d6,d4
	
	sub.w	d5,d1						; Get horizontal distance from the other object
	sub.w	obj.x(a6),d1
	bpl.s	.CheckCollideX
	neg.w	d1

.CheckCollideX:
	cmp.w	d3,d1						; Is there a horizontal collision?
	bge.s	.NoCollision					; If not, branch
	
	sub.w	d5,d2						; Get vertical distance from the other object
	sub.w	obj.y(a6),d2
	bpl.s	.CheckCollideY
	neg.w	d2

.CheckCollideY:
	cmp.w	d4,d2						; Is there a vertical collision?
	bge.s	.NoCollision					; If not, branch

	move.w	#$8805,MARS_COMM_12+MARS_SYS			; Play sound
	move.b	#-1,(a2,d0.w)					; Mark as collected

.NoCollision:
	dbf	d7,.Check					; Loop until cards are updated
	movem.l	(sp)+,d0-d1					; Restore registers
	rts

.Skip:
	addq.w	#4,a5						; Skip card
	dbf	d7,.Check					; Loop until cards are updated

.End:
	movem.l	(sp)+,d0-d1					; Restore registers
	rts

; ------------------------------------------------------------------------------
; Draw cards
; ------------------------------------------------------------------------------

DrawYugiohCards:
	movea.l	map_yugioh_cards,a0				; Card data
	lea	yugioh_card_states,a1				; Card states
	
	move.b	camera_fg_x_draw,d0				; Get current chunk
	move.b	camera_fg_y_draw,d1
	ext.w	d0
	ext.w	d1
	
	bsr.s	DrawCardChunk					; (0, 0)
	
	addq.w	#1,d0						; (1, 0)
	bsr.s	DrawCardChunk
	
	addq.w	#1,d0						; (2, 0)
	bsr.s	DrawCardChunk

	subq.w	#2,d0						; (0, 1)
	addq.w	#1,d1
	bsr.s	DrawCardChunk

	addq.w	#1,d0						; (1, 1)
	bsr.s	DrawCardChunk

	addq.w	#1,d0						; (2, 1)

; ------------------------------------------------------------------------------
; Draw card chunk
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Chunk X index
;	d1.w - Chunk Y index
;	a0.l - Card layout address
; ------------------------------------------------------------------------------

DrawCardChunk:
	movem.l	d0-d1,-(sp)					; Save registers

	move.w	sprite_slots_left,d3				; Get number of sprite slots left
	bmi.w	.End						; If there are none left, branch
	
	cmp.w	(a0),d0						; Is the X index too large?
	bcc.w	.End						; If so, branch
	cmp.w	2(a0),d1					; Is the Y index too large?
	bcc.w	.End						; If so, branch

	add.w	d1,d1						; Get row address
	move.w	4(a0,d1.w),d1
	bmi.w	.End
	lea	(a0,d1.w),a2

	add.w	d0,d0						; Get chunk address
	move.w	(a2,d0.w),d0
	bmi.w	.End						; If it's null, branch
	lea	(a0,d0.w),a2

	move.w	(a2)+,d7					; Get number of cards to check
	subq.w	#1,d7
	bmi.s	.End						; If there are none, branch

	movea.w	sprite_slot,a3					; Get sprite slot
	
	move.w	#320+32,d4					; Sprite boundaries
	move.w	#224+32,d5
	moveq	#32,d6						; Sprite position offset

.Check:
	move.w	(a2)+,d0					; Get state entry

	move.b	(a1,d0.w),d0					; Has this card already been collected?
	bmi.s	.Skip						; If so, branch
	beq.s	.GotFrame					; If it's being collected, branch
	
	andi.w	#$FFFC,d0					; Get collection animation frame
	lsr.w	#1,d0
	bra.s	.GetPosition
	
.GotFrame:
	moveq	#0,d0						; Get animation frame
	move.b	yugioh_anim_frame,d0
	add.w	d0,d0

.GetPosition:
	move.w	(a2)+,d1					; Get position
	sub.w	camera_fg_x_draw,d1
	move.w	(a2)+,d2
	sub.w	camera_fg_y_draw,d2

	cmp.w	d4,d1						; Is the card offscreen?
	bcc.s	.Next						; If so, branch
	cmp.w	d5,d2
	bcc.s	.Next						; If so, branch

	sub.w	d6,d2						; Draw card
	add.w	d2,(a3)+
	move.b	#%0101,(a3)+
	addq.w	#1,a3
	move.w	.Frames(pc,d0.w),(a3)+
	sub.w	d6,d1
	add.w	d1,(a3)+

	subq.w	#1,d3						; Decrement number of sprite slots left
	dbmi	d7,.Check					; Loop until cards are drawn
	
	move.w	a3,sprite_slot					; Update sprite slot
	move.w	d3,sprite_slots_left				; Update number of sprite slots left

	movem.l	(sp)+,d0-d1					; Restore registers
	rts

.Skip:
	addq.w	#4,a2						; Skip card

.Next:
	dbf	d7,.Check					; Loop until cards are drawn

	move.w	a3,sprite_slot					; Update sprite slot
	move.w	d3,sprite_slots_left				; Update number of sprite slots left

.End:
	movem.l	(sp)+,d0-d1					; Restore registers
	rts

; ------------------------------------------------------------------------------

.Frames:
	dc.w	$400|$0000
	dc.w	$404|$0000
	dc.w	$408|$0000
	dc.w	$40C|$0000
	dc.w	$410|$0000
	dc.w	$40C|$0800
	dc.w	$408|$0800
	dc.w	$404|$0800

; ------------------------------------------------------------------------------
