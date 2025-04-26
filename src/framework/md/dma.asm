; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ultra DMA queue by Flamewing
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"src/framework/md.inc"
	
; ------------------------------------------------------------------------------
; Convert VDP address in register to VDP command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	reg   - Register containing source address in 68000 memory
;	clear - Mask out garbage bits
; ------------------------------------------------------------------------------

VDP_CMD_REG macro reg, clear
	lsl.l	#2,\reg						; Move high bits into (word-swapped) position, accidentally moving everything else
	addq.w	#1,\reg						; Add upper access type bits
	ror.w	#2,\reg						; Put upper access type bits into place, also moving all other bits into their correct (word-swapped) places
	swap	\reg						; Put all bits in proper places
	if (\clear)<>0
		andi.w	#3,\reg					; Strip whatever junk was in upper word of reg
	endif
	tas.b	\reg						; Add in the DMA flag -- tas fails on memory, but works on registers
	endm

; ------------------------------------------------------------------------------
; Queue DMA transfer
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d1.l - Source address
;	d2.w - Destination VRAM address
;	d3.w - Transfer size
; ------------------------------------------------------------------------------

QueueDma:
	move.w	sr,-(sp)					; Save current interrupt mask
	move	#$2700,sr					; Mask off interrupts
	
	movea.w	dma_slot,a1
	cmpa.w	#dma_slot,a1
	beq.s	.done						; Return if there's no more room in the buffer

	lsr.l	#1,d1						; Fix source address for DMA
	bclr	#23,d1

	lsr.w	#1,d3						; Fix transfer size for DMA

	movep.l	d1,dma.source(a1)				; Write source address
	movep.w	d3,dma.size(a1)					; Write DMA length, overwriting useless top byte of source address
	
	moveq	#0,d0						; Command to specify destination address and begin DMA
	move.w	d2,d0
	lsl.l	#2,d0						; Move high bits into (word-swapped) position, accidentally moving everything else
	addq.w	#1,d0						; Add upper access type bits
	ror.w	#2,d0						; Put upper access type bits into place, also moving all other bits into their correct (word-swapped) places
	swap	d0						; Put all bits in proper places
	tas.b	d0						; Add in the DMA flag -- tas fails on memory, but works on registers
	
	lea	dma.vdp_command(a1),a1				; Seek to correct RAM address to store VDP DMA command
	move.l	d0,(a1)+					; Write VDP DMA command for destination address
	move.w	a1,dma_slot					; Write next queue slot

.done:
	move.w	(sp)+,sr					; Restore interrupts to previous state
	rts

; ------------------------------------------------------------------------------
; Flush DMA queue
; ------------------------------------------------------------------------------

FlushDmaQueue:
	move.w	dma_slot,d0					; Start flushing queue
	subi.w	#dma_queue,d0
	jmp	.JumpTable(pc,d0.w)

; ------------------------------------------------------------------------------

.JumpTable:
	rts
	rept (dma.struct_len-2)/2
		trap	#0					; Just in case
	endr

; ------------------------------------------------------------------------------

	.c: =	1
	rept DMA_ENTRY_COUNT
		lea	VDP_CTRL,a5				; VDP control port
		lea	dma_queue,a1				; DMA queue
		if .c<>DMA_ENTRY_COUNT
			bra.w	.Jump0-(.c*8)
		endif
		rept	(dma.struct_len-$E)/2
			nop
		endr
		.c: =	.c+1
	endr

; ------------------------------------------------------------------------------

	rept DMA_ENTRY_COUNT
		move.l	(a1)+,(a5)				; Transfer length
		move.l	(a1)+,(a5)				; Source address high
		move.l	(a1)+,(a5)				; Source address low + destination high
		move.w	(a1)+,(a5)				; Destination low, trigger DMA
	endr

.Jump0:
	move.w	#dma_queue,dma_slot				; Reset DMA queue slot
	rts
FlushDmaQueueEnd:

; ------------------------------------------------------------------------------
; Pre-initializes the DMA queue with VDP register numbers in alternating bytes.
; Must be called before the queue is used, and the queue expects that only
; it write to this region of RAM.
; ------------------------------------------------------------------------------

InitDmaQueue:
	lea	dma_queue,a0
	moveq	#$FFFFFF94,d0					; Fast-store $94 (sign-extended) in d0
	move.l	#$93979695,d1

	.c: =	0
	rept DMA_ENTRY_COUNT
		move.b	d0,.c+dma.reg_94(a0)
		movep.l	d1,.c+dma.reg_93(a0)
		.c: =	.c+dma.struct_len
	endr

; ------------------------------------------------------------------------------
; Reset the DMA queue
; ------------------------------------------------------------------------------

ResetDmaQueue:
	move.w	#dma_queue,dma_slot				; Reset the DMA queue
	rts

; ------------------------------------------------------------------------------
