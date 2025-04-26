; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; VDP functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/framework/md.inc"

; ------------------------------------------------------------------------------
; Get VRAM read command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - VRAM address
; RETURNS:
;	d0.l - VRAM read command
; ------------------------------------------------------------------------------

GetVramReadCommand:
	lsl.l	#2,d0						; Convert address to command
	ror.w	#2,d0
	swap	d0
	andi.w	#3,d0
	rts

; ------------------------------------------------------------------------------
; Get VRAM write command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - VRAM address
; RETURNS:
;	d0.l - VRAM write command
; ------------------------------------------------------------------------------

GetVramWriteCommand:
	lsl.l	#2,d0						; Convert address to command
	addq.w	#1,d0
	ror.w	#2,d0
	swap	d0
	andi.w	#3,d0
	rts

; ------------------------------------------------------------------------------
; Get VRAM DMA command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - VRAM address
; RETURNS:
;	d0.l - VRAM DMA command
; ------------------------------------------------------------------------------

GetVramDmaCommand:
	bsr.s	GetVramWriteCommand				; Convert address to command
	tas.b	d0
	rts

; ------------------------------------------------------------------------------
; Get VRAM copy command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - VRAM address
; RETURNS:
;	d0.l - VRAM copy command
; ------------------------------------------------------------------------------

GetVramCopyCommand:
	bsr.s	GetVramReadCommand				; Convert address to command
	ori.b	#$C0,d0
	rts

; ------------------------------------------------------------------------------
; Get CRAM read command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - CRAM address
; RETURNS:
;	d0.l - CRAM read command
; ------------------------------------------------------------------------------

GetCramReadCommand:
	swap	d0						; Convert address to command
	move.w	#$20,d0
	rts

; ------------------------------------------------------------------------------
; Get CRAM write command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - CRAM address
; RETURNS:
;	d0.l - CRAM write command
; ------------------------------------------------------------------------------

GetCramWriteCommand:
	ori.w	#$C000,d0					; Convert address to command
	swap	d0
	clr.w	d0
	rts

; ------------------------------------------------------------------------------
; Get CRAM DMA command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - CRAM address
; RETURNS:
;	d0.l - CRAM DMA command
; ------------------------------------------------------------------------------

GetCramDmaCommand:
	ori.w	#$C000,d0					; Convert address to command
	swap	d0
	move.w	#$80,d0
	rts

; ------------------------------------------------------------------------------
; Get VSRAM read command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - VSRAM address
; RETURNS:
;	d0.l - VSRAM read command
; ------------------------------------------------------------------------------

GetVsramReadCommand:
	swap	d0						; Convert address to command
	move.w	#$10,d0
	rts

; ------------------------------------------------------------------------------
; Get VSRAM write command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - VSRAM address
; RETURNS:
;	d0.l - VSRAM write command
; ------------------------------------------------------------------------------

GetVsramWriteCommand:
	ori.w	#$4000,d0					; Convert address to command
	swap	d0
	move.w	#$10,d0
	rts

; ------------------------------------------------------------------------------
; Get VSRAM DMA command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - VSRAM address
; RETURNS:
;	d0.l - VSRAM DMA command
; ------------------------------------------------------------------------------

GetVsramDmaCommand:
	ori.w	#$4000,d0					; Convert address to command
	swap	d0
	move.w	#$90,d0
	rts

; ------------------------------------------------------------------------------
; Clear VDP memory
; ------------------------------------------------------------------------------

ClearVdpMemory:
	bsr.w	ClearCram					; Clear CRAM
	bsr.w	ClearVsram					; Clear VSRAM

; ------------------------------------------------------------------------------
; Clear VRAM
; ------------------------------------------------------------------------------

ClearVram:
	moveq	#0,d0						; Clear VRAM
	move.l	#$10000,d1
	bra.s	ClearVramRegion

; ------------------------------------------------------------------------------
; Fill VRAM with value
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Value to fill with
; ------------------------------------------------------------------------------

FillVram:
	move.b	d0,d2						; Fill VRAM with value
	moveq	#0,d0
	move.l	#$10000,d1
	bra.s	FillVramRegion

; ------------------------------------------------------------------------------
; Clear region of VRAM
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - VRAM address
;	d1.l - Number of bytes to clear
; ------------------------------------------------------------------------------

ClearVramRegion:
	moveq	#0,d2						; Fill with 0

; ------------------------------------------------------------------------------
; Fill region of VRAM with value
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - VRAM address
;	d1.l - Number of bytes to fill
;	d2.b - Value to fill with
; ------------------------------------------------------------------------------

FillVramRegion:
	lea	VDP_CTRL,a0					; VDP control port
	move.w	#$8F01,(a0)					; Set auto-increment to 1 for VRAM fill

	subq.l	#1,d1						; Set up registers
	move.l	#$94009300,-(sp)
	movep.w	d1,1(sp)
	move.l	(sp)+,(a0)
	move.w	#$9780,(a0)

	bsr.w	GetVramDmaCommand				; Start operation
	move.l	d0,(a0)
	move.b	d2,-4(a0)

	WAIT_DMA (a0)						; Wait for the operation to finish
	move.w	#$8F02,(a0)					; Set auto-increment to 2
	rts

; ------------------------------------------------------------------------------
; Copy region of VRAM to another place in VRAM
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Source VRAM address
;	d1.w - Destination VRAM address
;	d2.l - Number of bytes to copy
; ------------------------------------------------------------------------------

CopyVramRegion:
	lea	VDP_CTRL,a0					; VDP control port
	move.w	#$8F01,(a0)					; Set auto-increment to 1 for VRAM fill

	subq.l	#1,d2						; Set up registers
	move.l	#$94009300,-(sp)
	move.l	#$96009500,-(sp)
	movep.w	d0,1(sp)
	movep.w	d2,5(sp)
	move.l	(sp)+,(a0)
	move.l	(sp)+,(a0)
	move.w	#$97C0,(a0)

	move.w	d1,d0						; Start operation
	bsr.w	GetVramCopyCommand
	move.l	d0,(a0)

	WAIT_DMA (a0)						; Wait for the operation to finish
	move.w	#$8F02,(a0)					; Set auto-increment to 2
	rts

; ------------------------------------------------------------------------------
; Clear CRAM
; ------------------------------------------------------------------------------

ClearCram:
	moveq	#0,d0						; Clear CRAM
	move.w	#$80/2,d1
	bra.s	ClearCramRegion
	
; ------------------------------------------------------------------------------
; Fill CRAM with color
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Color to fill with
; ------------------------------------------------------------------------------

FillCram:
	move.w	d0,d2						; Fill CRAM with value
	moveq	#0,d0
	move.w	#$80/2,d1
	bra.s	FillCramRegion

; ------------------------------------------------------------------------------
; Clear CRAM region
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - CRAM address
;	d1.w - Number of colors to clear
; ------------------------------------------------------------------------------

ClearCramRegion:
	moveq	#0,d2						; Fill with 0

; ------------------------------------------------------------------------------
; Fill CRAM region with color
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - CRAM address
;	d1.w - Number of colors to fill
;	d2.w - Color to fill with
; ------------------------------------------------------------------------------

FillCramRegion:
	subq.w	#1,d1						; Get fill loop count
	bmi.s	.End
	
	bsr.w	GetCramWriteCommand				; Set CRAM write command
	move.l	d0,VDP_CTRL

.Fill:
	move.w	d2,VDP_DATA					; Fill CRAM region with color
	dbf	d1,.Fill					; Loop until the region is filled

.End:
	rts

; ------------------------------------------------------------------------------
; Clear VSRAM
; ------------------------------------------------------------------------------

ClearVsram:
	moveq	#0,d0						; Clear VSRAM
	move.w	#$50/2,d1
	bra.s	ClearVsramRegion

; ------------------------------------------------------------------------------
; Fill VSRAM with value
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Value to fill with
; ------------------------------------------------------------------------------

FillVsram:
	move.w	d0,d2						; Fill VSRAM with value
	moveq	#0,d0
	move.w	#$50/2,d1
	bra.s	FillVsramRegion
	
; ------------------------------------------------------------------------------
; Clear VSRAM region
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - VSRAM address
;	d1.w - Number of entries to clear
; ------------------------------------------------------------------------------

ClearVsramRegion:
	moveq	#0,d2						; Fill with 0

; ------------------------------------------------------------------------------
; Fill VSRAM region with value
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - VSRAM address
;	d1.w - Number of entries to fill
;	d2.w - Value to fill with
; ------------------------------------------------------------------------------

FillVsramRegion:
	subq.w	#1,d1						; Get fill loop count
	bmi.s	.End
	
	bsr.w	GetVsramWriteCommand				; Set VSRAM write command
	move.l	d0,VDP_CTRL

.Fill:
	move.w	d2,VDP_DATA					; Fill VSRAM region with value
	dbf	d1,.Fill					; Loop until the region is filled

.End:
	rts

; ------------------------------------------------------------------------------
; Disable display
; ------------------------------------------------------------------------------

DisableDisplay:
	move.w	#$8134,VDP_CTRL					; Disable display
	rts

; ------------------------------------------------------------------------------
; Enable display
; ------------------------------------------------------------------------------

EnableDisplay:
	move.w	#$8174,VDP_CTRL					; Enable display
	rts

; ------------------------------------------------------------------------------
; Reset window plane position
; ------------------------------------------------------------------------------

ResetWindowPlanePos:
	move.w	#$9100,VDP_CTRL					; Reset window plane position
	move.w	#$9200,VDP_CTRL
	rts

; ------------------------------------------------------------------------------
