; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Controller functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/framework/md.inc"
	
; ------------------------------------------------------------------------------
; Read controller data
; ------------------------------------------------------------------------------

ReadControllers:
	lea	p1_ctrl_data,a0					; Read player 1 controller
	lea	IO_DATA_1,a1
	bsr.s	ReadController
	
	addq.w	#p2_ctrl_data-p1_ctrl_data,a1			; Read player 2 controller

; ------------------------------------------------------------------------------
; Read a controller's data
; ------------------------------------------------------------------------------

ReadController:
	move.b	#0,(a1)						; Pull TH low
	nop
	nop
	move.b	(a1),d0						; Get start and A button
	lsl.b	#2,d0
	andi.b	#$C0,d0
	move.b	#$40,(a1)					; Pull TH high
	nop
	nop
	move.b	(a1),d1						; Get B, C, and directional buttons
	andi.b	#$3F,d1
	or.b	d1,d0						; Combine buttons
	not.b	d0						; Swap bits
	move.b	(a0),d1						; Prepare previously held buttons
	eor.b	d0,d1
	move.b	d0,(a0)+					; Store new held buttons
	and.b	d0,d1						; Update pressed buttons
	move.b	d1,(a0)+
	rts

; ------------------------------------------------------------------------------
