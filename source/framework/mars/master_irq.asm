; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Master CPU IRQ handler
; ------------------------------------------------------------------------------

	section sh2_code
	include	"source/framework/mars.inc"

; ------------------------------------------------------------------------------

MasterIrq:
	mov.l	r0,@-r15					; Save registers
	mov.l	r1,@-r15
	stc.l	gbr,@-r15
	sts.l	pr,@-r15

	mov.l	#SYS_REGS,r0					; Get system registers
	ldc	r0,gbr
	
	mov.w	#FRT,r1						; Toggle FRT bit as required
	mov.b	@(TOCR,r1),r0
	xor	#2,r0
	mov.b	r0,@(TOCR,r1)

	stc	sr,r0						; Get IRQ level
	shlr2	r0
	and	#$3C,r0
	
	mov.b	#$F0,r1						; Disable interrupts
	extu.b	r1,r1
	ldc	r1,sr
	
	mov.l	r0,r1						; Run IRQ handler
	mova	.IRQFunctions,r0
	mov.l	@(r0,r1),r1
	jsr	@r1
	nop

	lds.l	@r15+,pr					; Restore registers
	ldc.l	@r15+,gbr
	mov.l	@r15+,r1
	mov.l	@r15+,r0
	rte
	nop

	lits
	cnop 0,4

; ------------------------------------------------------------------------------

.IRQFunctions:
	dc.l	MasterNullIrq					; IRQ 0
	dc.l	MasterNullIrq					; IRQ 1
	dc.l	MasterNullIrq					; IRQ 2
	dc.l	MasterNullIrq					; IRQ 3
	dc.l	MasterNullIrq					; IRQ 4
	dc.l	MasterNullIrq					; IRQ 5
	dc.l	MasterPwmIrq, MasterPwmIrq			; PWM
	dc.l	MasterCmdIrq, MasterCmdIrq			; CMD
	dc.l	MasterHBlankIrq, MasterHBlankIrq		; H-BLANK
	dc.l	MasterVBlankIrq, MasterVBlankIrq		; V-BLANK
	dc.l	MasterVresIrq, MasterVresIrq			; Reset

; ------------------------------------------------------------------------------
; Null interrupt
; ------------------------------------------------------------------------------

MasterNullIrq:
	rts
	nop
	
	lits

; ------------------------------------------------------------------------------
; Reset interrupt
; ------------------------------------------------------------------------------

MasterVresIrq:
	mov.w	r0,@(VRES_CLEAR,gbr)				; Clear interrupt flag

	mov.l	#"M_OK",r0					; Reset
	bra	MasterReset
	mov.l	r0,@(COMM_0,gbr)

	lits

; ------------------------------------------------------------------------------
; V-BLANK interrupt
; ------------------------------------------------------------------------------

MasterVBlankIrq:
	mov.l	r3,@-r15					; Save registers
	mov.l	r2,@-r15
	
	mov.w	r0,@(VBLANK_CLEAR,gbr)				; Clear interrupt flag
	
	mov.l	#screen_drawn,r1				; Has the screen been drawn to?
	mov.l	@r1,r0
	tst	r0,r0
	bt	.UpdatePalette					; If not, branch

	xor	r0,r0						; Reset screen drawn flag
	mov.l	r0,@r1

	mov.l	#SYS_REGS+COMM_4,r1				; Drawing finished
	xor	r0,r0
	mov.b	r0,@r1

	mov.l	#VDP_REGS+VDP_STATUS,r1				; Swap frame buffers
	mov.w	@r1,r0
	xor	#1,r0
	mov.w	r0,@r1

.UpdatePalette:	
	mov.l	#cram_buffer,r1					; CRAM buffer
	mov.w	#$100/2,r2					; Number of colors / 2
	mov.l	#CRAM,r3					; CRAM

.LoadPalette:
	mov.l	@r1+,r0						; Load colors
	mov.l	r0,@r3
	dt	r2						; Decrement number of colors left
	bf/s	.LoadPalette					; If there's still colors to load, loop
	add	#4,r3

	mov.l	@r15+,r2					; Restore registers
	rts
	mov.l	@r15+,r3

	lits

; ------------------------------------------------------------------------------
; H-BLANK interrupt
; ------------------------------------------------------------------------------

MasterHBlankIrq:
	mov.w	r0,@(HBLANK_CLEAR,gbr)				; Clear interrupt flag
	rts
	nop

	lits

; ------------------------------------------------------------------------------
; CMD interrupt
; ------------------------------------------------------------------------------

MasterCmdIrq:
	mov.b	@(COMM_6,gbr),r0				; Run command type
	shll2	r0
	mov.l	r0,r1
	mova	.Commands,r0
	mov.l	@(r0,r1),r0
	jmp	@r0
	nop

	lits
	cnop 0,4

; ------------------------------------------------------------------------------

.Commands:
	dc.l	MasterCmdIrq_DrawDmaStart			; Draw commands DMA start
	dc.l	MasterCmdIrq_DrawDmaEnd				; Draw commands DMA end
	dc.l	MasterCmdIrq_GfxDataDmaStart			; Graphics data DMA start
	dc.l	MasterCmdIrq_GfxDataDmaEnd			; Graphics data DMA end
	dc.l	MasterCmdIrq_MdError				; Mega Drive error

; ------------------------------------------------------------------------------
; Draw commands DMA start
; ------------------------------------------------------------------------------

MasterCmdIrq_DrawDmaStart:
	mov.b	#DMA0,r1					; DMA0 parameters
	
	mov.l	#SYS_REGS+DREQ_FIFO,r0				; Transfer from DREQ FIFO
	mov.l	r0,@(SAR0,r1)

	mov.l	#draw_cmd_buffer,r0				; Transfer into draw command buffer
	mov.l	r0,@(DAR0,r1)

	mov.w	@(DREQ_LENGTH,gbr),r0				; Set DMA length to DREQ length
	mov.l	r0,@(TCR0,r1)

	mov.l	@(CHCR0,r1),r0					; Start DMA
	mov.w	#%0100010011100001,r0
	mov.l	r0,@(CHCR0,r1)

	mov.w	r0,@(CMD_CLEAR,gbr)				; Clear interrupt flag
	rts
	nop

	lits
	
; ------------------------------------------------------------------------------
; Draw commands DMA end
; ------------------------------------------------------------------------------

MasterCmdIrq_DrawDmaEnd:
	mov.l	r2,@-r15					; Save registers

	mov.l	#$40000000+draw_cmd_buffer,r0			; Get associative purge space
	mov.b	#$400/$10,r1
	xor	r2,r2

.PurgeCache:
	mov.l	r2,@r0						; Purge draw command buffer cache area
	dt	r1
	bf/s	.PurgeCache					; Loop until cache area is purged
	add	#$10,r0

	mov.b	#DMA0+CHCR0,r1					; Stop DMA
	mov.l	@r1,r0
	mov.w	#%0100010011100000,r0
	mov.l	r0,@r1
	
	mov.w	r0,@(CMD_CLEAR,gbr)				; Clear interrupt flag

	mov.b	#1,r0						; Drawing started
	mov.b	r0,@(COMM_4,gbr)
	
	rts							; Restore registers
	mov.l	@r15+,r2

	lits

; ------------------------------------------------------------------------------
; Graphics data commands DMA start
; ------------------------------------------------------------------------------

MasterCmdIrq_GfxDataDmaStart:
	mov.b	#DMA0,r1					; DMA0 parameters
	
	mov.l	#SYS_REGS+DREQ_FIFO,r0				; Transfer from DREQ FIFO
	mov.l	r0,@(SAR0,r1)

	mov.l	#gfx_data_cmd_buffer,r0				; Transfer into graphics data buffer
	mov.l	r0,@(DAR0,r1)

	mov.w	@(DREQ_LENGTH,gbr),r0				; Set DMA length to DREQ length
	mov.l	r0,@(TCR0,r1)

	mov.l	@(CHCR0,r1),r0					; Start DMA
	mov.w	#%0100010011100001,r0
	mov.l	r0,@(CHCR0,r1)

	mov.w	r0,@(CMD_CLEAR,gbr)				; Clear interrupt flag
	rts
	nop

	lits
	
; ------------------------------------------------------------------------------
; Graphics data commands DMA end
; ------------------------------------------------------------------------------

MasterCmdIrq_GfxDataDmaEnd:
	mov.l	r2,@-r15					; Save registers
	
	mov.l	#$40000000+gfx_data_cmd_buffer,r0		; Get associative purge space
	mov.b	#$40,r1
	xor	r2,r2

.PurgeCache:
	mov.l	r2,@r0						; Purge graphics data buffer cache area
	dt	r1
	bf/s	.PurgeCache					; Loop until cache area is purged
	add	#$10,r0

	mov.b	#DMA0+CHCR0,r1					; Stop DMA
	mov.l	@r1,r0
	mov.w	#%0100010011100000,r0
	mov.l	r0,@r1
	
	mov.w	r0,@(CMD_CLEAR,gbr)				; Clear interrupt flag

	mov.b	#1,r0						; Graphics data commands processing started
	mov.b	r0,@(COMM_5,gbr)
	
	rts							; Restore registers
	mov.l	@r15+,r2

	lits

; ------------------------------------------------------------------------------
; Mega Drive error
; ------------------------------------------------------------------------------

MasterCmdIrq_MdError:
	mov.w	r0,@(CMD_CLEAR,gbr)				; Clear interrupt flag

	xor	r0,r0						; Disable interrupts
	mov.b	r0,(INT_MASK,r14)

	mov.l	#InitScreen,r0					; Clear screen
	jsr	@r0
	nop

.WaitPalAccess:
	mov.l	#VDP_REGS+VDP_STATUS,r0				; Do we have palette access?
	mov.b	@r0,r0
	tst	#BIT_PEN,r0
	bt	.WaitPalAccess					; If not, wait

	mov.w	#$8000,r0					; Set background color
	mov.l	#CRAM,r1
	mov.w	r0,@r1

.Loop:
	bra	.Loop						; Loop here forever
	nop

	lits

; ------------------------------------------------------------------------------
; PWM interrupt
; ------------------------------------------------------------------------------

MasterPwmIrq:
	mov.w	r0,@(PWM_CLEAR,gbr)				; Clear interrupt flag
	rts
	nop

	lits

; ------------------------------------------------------------------------------
