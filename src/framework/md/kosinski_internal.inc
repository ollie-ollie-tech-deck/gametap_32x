; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Kosinski decompression function
; ------------------------------------------------------------------------------

	moveq	#8-1,d7						; Prepare for decompression
	moveq	#0,d0
	moveq	#0,d1
	lea	KosDec_ByteMap(pc),a4
	
	move.b	(a0)+,d0					; Get desc field low-byte.
	move.b	(a0)+,d1					; Get desc field hi-byte.
	move.b	(a4,d0.w),d0					; Invert bit order...
	move.b	(a4,d1.w),d1					; ... for both bytes.
	
	moveq	#7,d2						; Set repeat count to 8.
	moveq	#0,d3						; d3 will be desc field switcher.
	bra.s	.FetchNewCode

; ------------------------------------------------------------------------------

.FetchCodeLoop:
	; Code 1 (Uncompressed byte).
	_Kos_RunBitStream
	move.b	(a0)+,(a1)+

.FetchNewCode:
	_Kos_ReadBit
	bcs.s	.FetchCodeLoop					; If code = 1, branch.

	; Codes 00 and 01.
	moveq	#-1,d5
	lea	(a1),a5
	_Kos_RunBitStream
	_Kos_ReadBit
	bcs.w	.Code_01

	; Code 00 (Dictionary ref. short).
	_Kos_RunBitStream
	_Kos_ReadBit
	bcs.s	.Copy45
	_Kos_RunBitStream
	_Kos_ReadBit
	bcs.s	.Copy3
	_Kos_RunBitStream
	move.b	(a0)+,d5					; d5 = displacement.
	adda.w	d5,a5
	move.b	(a5)+,(a1)+
	move.b	(a5)+,(a1)+
	bra.s	.FetchNewCode

; ------------------------------------------------------------------------------

.Copy3:
	_Kos_RunBitStream
	move.b	(a0)+,d5					; d5 = displacement.
	adda.w	d5,a5
	move.b	(a5)+,(a1)+
	move.b	(a5)+,(a1)+
	move.b	(a5)+,(a1)+
	bra.w	.FetchNewCode

; ------------------------------------------------------------------------------

.Copy45:
	_Kos_RunBitStream
	_Kos_ReadBit
	bcs.s	.Copy5
	_Kos_RunBitStream
	move.b	(a0)+,d5					; d5 = displacement.
	adda.w	d5,a5
	move.b	(a5)+,(a1)+
	move.b	(a5)+,(a1)+
	move.b	(a5)+,(a1)+
	move.b	(a5)+,(a1)+
	bra.w	.FetchNewCode

; ------------------------------------------------------------------------------

.Copy5:
	_Kos_RunBitStream
	move.b	(a0)+,d5					; d5 = displacement.
	adda.w	d5,a5
	move.b	(a5)+,(a1)+
	move.b	(a5)+,(a1)+
	move.b	(a5)+,(a1)+
	move.b	(a5)+,(a1)+
	move.b	(a5)+,(a1)+
	bra.w	.FetchNewCode

; ------------------------------------------------------------------------------

.Code_01:
	moveq	#0,d4						; d4 will contain copy count.
	; Code 01 (Dictionary ref. long / special).
	_Kos_RunBitStream
	move.b	(a0)+,d6					; d6 = %LLLLLLLL.
	move.b	(a0)+,d4					; d4 = %HHHHHCCC.
	move.b	d4,d5						; d5 = %11111111 HHHHHCCC.
	lsl.w	#5,d5						; d5 = %111HHHHH CCC00000.
	move.b	d6,d5						; d5 = %111HHHHH LLLLLLLL.
	and.w	d7,d4						; d4 = %00000CCC.
	bne.s	.StreamCopy 					; if CCC=0, branch.

	; special mode (extended counter)
	move.b	(a0)+,d4					; Read cnt
	beq.s	.Quit						; If cnt=0, quit decompression.
	subq.b	#1,d4
	beq.w	.FetchNewCode 					; If cnt=1, fetch a new code.

	adda.w	d5,a5
	move.b	(a5)+,(a1)+ 					; Do 1 extra copy (to compensate +1 to copy counter).
	move.w	d4,d6
	not.w	d6
	and.w	d7,d6
	add.w	d6,d6
	lsr.w	#3,d4
	jmp	.LargeCopy(pc,d6.w)

; ------------------------------------------------------------------------------

.LargeCopy:
	rept 8
		move.b	(a5)+,(a1)+
	endr
	dbf	d4,.LargeCopy
	bra.w	.FetchNewCode

; ------------------------------------------------------------------------------

.StreamCopy:
	adda.w	d5,a5
	move.b	(a5)+,(a1)+ 					; Do 1 extra copy (to compensate +1 to copy counter).
	eor.w	d7,d4
	add.w	d4,d4
	jmp	.MediumCopy(pc,d4.w)

; ------------------------------------------------------------------------------

.MediumCopy:
	rept 8
		move.b	(a5)+,(a1)+
	endr
	bra.w	.FetchNewCode

; ------------------------------------------------------------------------------

.Quit:
	
; ------------------------------------------------------------------------------
