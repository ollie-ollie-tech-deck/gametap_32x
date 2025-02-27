; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ben tear screen
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------

BenTearScreen:
	jsr	FadePaletteToWhite				; Fade to white
	
	move	#$2700,sr					; Reset screen
	jsr	DisableDisplay
	bsr.w	ClearVram
	bsr.w	ClearVsram
	bsr.w	InitMarsGraphics2

	pea	MarsPal_Global					; Load global 32X palette
	move.b	#2,-(sp)
	clr.b	-(sp)
	bsr.w	LoadMarsPalette

	pea	MarsSpr_BenTear					; Load Ben tear 32X sprites
	clr.b	-(sp)
	move.b	#2,-(sp)
	bsr.w	LoadMarsSprites
	
	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bsr.w	WaitMarsGraphicsData

	bsr.w	DrawFrame					; Draw frame
	bsr.w	WaitMars
	
	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in

	clr.w	stage_frame_count				; Reset frame count

; ------------------------------------------------------------------------------

.Loop:
	bsr.w	VSync						; VSync
	bsr.w	DrawFrame					; Draw frame

	addq.w	#1,stage_frame_count				; Increment frame counter
	cmpi.w	#3*60,stage_frame_count				; Has enough time passed?
	bcs.s	.Loop						; If not, loop

; ------------------------------------------------------------------------------

.ScreenEnd:
	jsr	FadePaletteToBlack				; Fade to black

	move.b	#4,sonic_stage_id				; Go to next stage
	jmp	SonicStageScene

; ------------------------------------------------------------------------------
; Draw frame
; ------------------------------------------------------------------------------

DrawFrame:
	bsr.w	ClearMarsScreen					; Clear 32X screen

	clr.b	-(sp)						; Draw image (left)
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

	clr.b	-(sp)						; Draw image (right)
	move.b	#1,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

	jsr	Random						; Get impact lines offset
	andi.w	#3,d0
	subq.w	#2,d0
	addi.w	#112,d0
	move.w	d0,-(sp)
	jsr	Random
	andi.w	#3,d0
	subq.w	#2,d0
	addi.w	#80,d0
	move.w	(sp)+,d1

	movem.w	d0-d1,-(sp)					; Draw impact lines (left)
	clr.b	-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	d0,-(sp)
	move.w	d1,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

	movem.w	(sp)+,d0-d1					; Draw impact lines (right)
	clr.b	-(sp)
	move.b	#3,-(sp)
	clr.b	-(sp)
	addi.w	#160,d0
	move.w	d0,-(sp)
	move.w	d1,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

	bsr.w	UpdateMarsPaletteFade				; Update 32X palette fade
	bra.w	SendMarsGraphicsCmds				; Send 32X graphics commands

; ------------------------------------------------------------------------------
