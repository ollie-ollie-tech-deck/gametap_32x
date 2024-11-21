; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Vector tables
; ------------------------------------------------------------------------------

	section sh2_vectors
	include	"source/framework/mars.inc"
	
; ------------------------------------------------------------------------------
; Master CPU vector table
; ------------------------------------------------------------------------------

MasterVector:
	dc.l	MasterInit, MASTER_STACK			; Soft reset PC/SP
	dc.l	MasterInit, MASTER_STACK			; Hard reset PC/SP
	dc.l	MasterIllegalInstr				; Illegal instruction
	dc.l	0						; Reserved
	dc.l	MasterIllegalSlot				; Invalid slot instruction
	dc.l	$20100400					; Reserved
	dc.l	$20100420					; Reserved
	dc.l	MasterCpuAddrError				; CPU address error
	dc.l	MasterCpuAddrError				; DMA address error
	dc.l	Exception					; NMI vector
	dc.l	MasterUserBreak					; User break vector
	dcb.l	19, 0						; Reserved
	dcb.l	32, Exception					; Trap user vectors
	dc.l	MasterIrq					; Level 1 IRQ
	dc.l	MasterIrq					; Level 2/3 IRQ
	dc.l	MasterIrq					; Level 4/5 IRQ
	dc.l	MasterIrq					; Level 6/7 IRQ (PWM)
	dc.l	MasterIrq					; Level 8/9 IRQ (CMD)
	dc.l	MasterIrq					; Level 10/11 IRQ (H-BLANK)
	dc.l	MasterIrq					; Level 12/13 IRQ (V-BLANK)
	dc.l	MasterIrq					; Level 14/15 IRQ (Reset)

; ------------------------------------------------------------------------------
; Slave CPU vector table
; ------------------------------------------------------------------------------

SlaveVector:
	dc.l	SlaveInit, SLAVE_STACK				; Cold start PC/SP
	dc.l	SlaveInit, SLAVE_STACK				; Hot start PC/SP
	dc.l	SlaveIllegalInstr				; Illegal instruction
	dc.l	0						; Reserved
	dc.l	SlaveIllegalSlot				; Invalid slot instruction
	dc.l	$20100400					; Reserved
	dc.l	$20100420					; Reserved
	dc.l	SlaveCpuAddrError				; CPU address error
	dc.l	SlaveCpuAddrError				; DMA address error
	dc.l	Exception					; NMI vector
	dc.l	SlaveUserBreak					; User break vector
	dcb.l	19, 0						; Reserved
	dcb.l	32, Exception					; Trap user vectors
	dc.l	SlaveIrq					; Level 1 IRQ
	dc.l	SlaveIrq					; Level 2/3 IRQ
	dc.l	SlaveIrq					; Level 4/5 IRQ
	dc.l	SlaveIrq					; Level 6/7 IRQ (PWM)
	dc.l	SlaveIrq					; Level 8/9 IRQ (CMD)
	dc.l	SlaveIrq					; Level 10/11 IRQ (H-BLANK)
	dc.l	SlaveIrq					; Level 12/13 IRQ (V-BLANK)
	dc.l	SlaveIrq					; Level 14/15 IRQ (Reset)

; ------------------------------------------------------------------------------
