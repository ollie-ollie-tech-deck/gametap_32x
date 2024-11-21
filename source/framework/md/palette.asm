; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Palette functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/framework/md.inc"

; ------------------------------------------------------------------------------
; Load palette
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Palette data
;	d0.w - Starting CRAM index
;	d1.w - Size of palette
; ------------------------------------------------------------------------------

LoadPalette:
	lea	palette,a1					; Get palette buffer offset
	add.w	d0,d0
	adda.w	d0,a1
	
	subq.w	#1,d1						; Get loop count
	bmi.s	.End
	
.Load:
	move.w	(a0)+,(a1)+					; Load palette data
	dbf	d1,.Load					; Loop until data is loaded
	
.End:
	rts

; ------------------------------------------------------------------------------
; Fade palette to black
; ------------------------------------------------------------------------------

FadePaletteToBlack:
	cmpi.w	#-7*2,pal_fade_intensity			; Are we faded to black?
	ble.s	.End						; If so, branch

	bsr.w	VSync						; VSync
	bsr.w	VSync

	subq.w	#2,pal_fade_intensity				; Fade to black
	bsr.w	UpdateCram
	bsr.w	UpdateMarsPaletteFade
	bsr.w	SendMarsGraphicsCmds

	bra.s	FadePaletteToBlack				; Loop

.End:
	move.w	#-7*2,pal_fade_intensity			; Cap intensity at minimum value
	bsr.w	UpdateCram
	bsr.w	UpdateMarsPaletteFade
	bsr.w	SendMarsGraphicsCmds
	bra.w	VSync

; ------------------------------------------------------------------------------
; Fade palette to white
; ------------------------------------------------------------------------------

FadePaletteToWhite:
	cmpi.w	#7*2,pal_fade_intensity				; Are we faded to black?
	bge.s	.End						; If so, branch

	bsr.w	VSync						; VSync
	bsr.w	VSync

	addq.w	#2,pal_fade_intensity				; Fade to white
	bsr.w	UpdateCram
	bsr.w	UpdateMarsPaletteFade
	bsr.w	SendMarsGraphicsCmds

	bra.s	FadePaletteToWhite				; Loop

.End:
	move.w	#7*2,pal_fade_intensity				; Cap intensity at maximum value
	bsr.s	UpdateCram
	bsr.w	UpdateMarsPaletteFade
	bsr.w	SendMarsGraphicsCmds
	bra.w	VSync

; ------------------------------------------------------------------------------
; Fade palette in
; ------------------------------------------------------------------------------

FadePaletteIn:
	tst.w	pal_fade_intensity				; Are we faded in?
	beq.s	.End						; If so, branch

	bsr.w	VSync						; VSync
	bsr.w	VSync

	moveq	#2,d0						; Fade in
	tst.w	pal_fade_intensity
	bmi.s	.Fade
	moveq	#-2,d0

.Fade:
	add.w	d0,pal_fade_intensity
	bsr.s	UpdateCram
	bsr.w	UpdateMarsPaletteFade
	bsr.w	SendMarsGraphicsCmds

	bra.s	FadePaletteIn					; Loop

.End:
	rts
	
; ------------------------------------------------------------------------------
; Set palette fade intensity
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Palette fade intensity
; ------------------------------------------------------------------------------

SetPaletteFadeIntensity:
	cmpi.w	#-7,d0						; Is the intensity value too small?
	bge.s	.CheckMax					; If not, branch
	moveq	#-7,d0						; Cap at minimum intensity

.CheckMax:
	cmpi.w	#7,d0						; Is the intensity value too large?
	ble.s	.SetIntensity					; If not, branch
	moveq	#7,d0						; Cap at maximum intensity

.SetIntensity:
	add.w	d0,d0						; Is this intensity already set?
	cmp.w	pal_fade_intensity,d0
	beq.s	.End						; If so, branch

	move.w	d0,pal_fade_intensity				; Set intensity
	
	bsr.s	UpdateCram					; Update CRAM
	bsr.w	UpdateMarsPaletteFade				; Update 32X CRAM
	bsr.w	SendMarsGraphicsCmds
	bra.w	WaitMars

.End:
	rts

; ------------------------------------------------------------------------------
; Update CRAM buffer
; ------------------------------------------------------------------------------

UpdateCram:
	lea	palette,a0					; Palette buffer
	lea	cram_buffer,a1					; CRAM buffer
	
	moveq	#0,d0						; Clear color value

	move.w	pal_fade_intensity,d2				; Get brightness tables
	lea	.BrightnessRedBlue(pc,d2.w),a2
	lea	.BrightnessGreen(pc),a3
	lsl.w	#4,d2
	adda.w	d2,a3
	
	moveq	#$40-1,d3					; Number of colors
	
.Loop:
	move.b	(a0)+,d0					; Store blue
	move.b	(a2,d0.w),(a1)+
	
	move.b	(a0)+,d0					; Store green and red
	moveq	#$E,d1
	and.b	d0,d1
	sub.b	d1,d0
	move.b	(a3,d0.w),d0
	or.b	(a2,d1.w),d0
	move.b	d0,(a1)+
	
	dbf	d3,.Loop					; Loop until colors are processed
	rts

; ------------------------------------------------------------------------------

	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.BrightnessRedBlue:
	dc.b	$00, $00, $02, $02, $04, $04, $06, $06, $08, $08, $0A, $0A, $0C, $0C
	dc.b	$0E, $0E
	dc.b	$0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E
	
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.BrightnessGreen:
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
	dc.b	$20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
	dc.b	$40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40
	dc.b	$40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40
	dc.b	$60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60
	dc.b	$60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60
	dc.b	$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
	dc.b	$80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
	dc.b	$A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0
	dc.b	$A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0
	dc.b	$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0
	dc.b	$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0
	dc.b	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0

; ------------------------------------------------------------------------------
