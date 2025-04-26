; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Slave CPU IRQ handler
; ------------------------------------------------------------------------------

	section sh2_code
	include	"src/framework/mars.inc"
	
; ------------------------------------------------------------------------------

SlaveIrq:
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
	mova	.IrqFunctions,r0
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

.IrqFunctions:
	dc.l	SlaveNullIrq					; IRQ 0
	dc.l	SlaveNullIrq					; IRQ 1
	dc.l	SlaveNullIrq					; IRQ 2
	dc.l	SlaveNullIrq					; IRQ 3
	dc.l	SlaveNullIrq					; IRQ 4
	dc.l	SlaveNullIrq					; IRQ 5
	dc.l	SlavePwmIrq, SlavePwmIrq			; PWM
	dc.l	SlaveCmdIrq, SlaveCmdIrq			; CMD
	dc.l	SlaveHBlankIrq, SlaveHBlankIrq			; H-BLANK
	dc.l	SlaveVBlankIrq, SlaveVBlankIrq			; V-BLANK
	dc.l	SlaveVresIrq, SlaveVresIrq			; Reset

; ------------------------------------------------------------------------------
; Null interrupt
; ------------------------------------------------------------------------------

SlaveNullIrq:
	rts
	nop
	
	lits
	
; ------------------------------------------------------------------------------
; Reset interrupt
; ------------------------------------------------------------------------------

SlaveVresIrq:
	mov.w	r0,@(VRES_CLEAR,gbr)				; Clear interrupt flag

	mov.l	#"S_OK",r0					; Reset
	bra	SlaveReset
	mov.l	r0,@(COMM_4,gbr)

	lits

; ------------------------------------------------------------------------------
; V-BLANK interrupt
; ------------------------------------------------------------------------------

SlaveVBlankIrq:
	mov.w	r0,@(VBLANK_CLEAR,gbr)				; Clear interrupt flag
	rts
	nop

	lits

; ------------------------------------------------------------------------------
; H-BLANK interrupt
; ------------------------------------------------------------------------------

SlaveHBlankIrq:
	mov.w	r0,@(HBLANK_CLEAR,gbr)				; Clear interrupt flag
	rts
	nop

	lits

; ------------------------------------------------------------------------------
; CMD interrupt
; ------------------------------------------------------------------------------

SlaveCmdIrq:
	mov.w	r0,@(CMD_CLEAR,gbr)				; Clear interrupt flag
	rts
	nop

	lits

; ------------------------------------------------------------------------------
; PWM interrupt
; ------------------------------------------------------------------------------

SlavePwmIrq:
	mov.w	r0,@(PWM_CLEAR,gbr)				; Clear interrupt flag

	mov.l	#UpdatePwmDriver,r0				; Update driver
	jmp	@r0
	nop

	lits

; ------------------------------------------------------------------------------
