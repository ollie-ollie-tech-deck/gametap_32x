; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Memory functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/framework/md.inc"

; ------------------------------------------------------------------------------
; Clear memory
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Length of memory to clear
;	a0.l - Memory address
; RETURNS:
;	a0.l - End of memory address
; ------------------------------------------------------------------------------

ClearMemory:
	moveq	#0,d1						; Fill with 0

; ------------------------------------------------------------------------------
; Clear memory
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Length of memory to clear
;	d1.b - Value to fill with
;	a0.l - Memory address
; RETURNS:
;	a0.l - End of memory address
; ------------------------------------------------------------------------------

FillMemory:
	move.b	d1,-(sp)					; Set fill value
	move.b	d1,1(sp)
	move.w	(sp),-(sp)
	move.l	(sp)+,d1

	move.w	d0,d2						; Get number of 16 bytes blocks to clear
	lsr.w	#4,d2
	subq.w	#1,d2
	bmi.s	.NoBlockClear					; If there's not enough, branch

.BlockClear:
	move.l	d1,(a0)+					; Clear block
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	move.l	d1,(a0)+
	dbf	d2,.BlockClear					; Loop until blocks are cleared

.NoBlockClear:
	move.w	d0,d2						; Get number of words to clear
	moveq	#$E,d3
	and.w	d3,d2
	eor.w	d3,d2
	jmp	.WordClear(pc,d2.w)

.WordClear:
	move.w	d1,(a0)+					; 7 words
	move.w	d1,(a0)+					; 6 words
	move.w	d1,(a0)+					; 5 words
	move.w	d1,(a0)+					; 4 words
	move.w	d1,(a0)+					; 3 words
	move.w	d1,(a0)+					; 2 words
	move.w	d1,(a0)+					; 1 word

.CheckByte:
	lsr.b	#1,d0						; Is there one last byte to clear?
	bcc.s	.End						; If not, branch
	move.b	d1,(a0)+					; Clear last byte

.End:
	rts

; ------------------------------------------------------------------------------
