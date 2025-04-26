; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Padded cell cutscene
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"src/rpg/shared.inc"

; ------------------------------------------------------------------------------

PaddedCellCutscene:
	lea	Song_Promise,a0					; Play music
	jsr	PlayMusic

	lea	Pal_PaddedCell,a0				; Load palette
	moveq	#0,d0
	moveq	#16,d1
	jsr	LoadPalette

	pea	MarsSpr_PaddedCell				; Load padded cell cutscene 32X sprites
	move.b	#1,-(sp)
	move.b	#2,-(sp)
	jsr	LoadMarsSprites
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMarsGraphicsData
	
	bsr.w	DrawFrame					; Draw frame

	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in

	lea	PaddedCellScript,a0				; Run script
	jsr	StartScript
	
	bra.s	StartScriptLoop					; Start script loop

; ------------------------------------------------------------------------------

ScriptLoop:
	jsr	VSync						; VSync
	bsr.s	DrawFrame					; Draw frame

StartScriptLoop:
	jsr	UpdateScript					; Update script
	tst.l	script_address					; Is the script done?
	bne.s	ScriptLoop					; If not, loop
	
	jsr	FadePaletteToBlack				; Fade to black
	jsr	DisableDisplay					; Disable display
	
	jsr	ClearMarsScreen					; Clear screen
	jsr	WaitMarsDraw
	
	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in
	
	lea	EndingScript,a0					; Run ending script
	jsr	StartScript
	
	bra.s	StartScriptLoop2				; Start script loop 2

; ------------------------------------------------------------------------------

ScriptLoop2:
	jsr	VSync						; VSync
	jsr	ClearMarsScreen					; Draw frame
	bsr.s	DrawFrame2

StartScriptLoop2:
	jsr	UpdateScript					; Update script
	tst.l	script_address					; Is the script done?
	bne.s	ScriptLoop2					; If not, loop

	jmp	CreditsScene					; Go to credits

; ------------------------------------------------------------------------------
; Draw frame
; ------------------------------------------------------------------------------

DrawFrame:
	jsr	ClearMarsScreen					; Clear 32X screen
	
	move.b	#1,-(sp)					; Draw background (left)
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	
	move.b	#1,-(sp)					; Draw background (right)
	move.b	#1,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

DrawFrame2:
	jsr	DrawScriptTextbox				; Draw textbox
	
	jsr	UpdateMarsPaletteFade				; Update 32X palette fade
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	
	jmp	UpdateCram					; Update CRAM

; ------------------------------------------------------------------------------
; Scripts
; ------------------------------------------------------------------------------

PaddedCellScript:
	SCRIPT_DELAY			45

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I'M TELLING YOU, I'M NOT CRAZY!\n", &
					"IT'S THE WORMS... THE WORMS!!!\n", &
					"THE WORMS ARE IN MY BRAIN!!!"
					  
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			15
	
	SCRIPT_END

; ------------------------------------------------------------------------------

EndingScript:
	SCRIPT_SHOW_TEXTBOX
	
	SCRIPT_TEXT			"Ollie has been found not guilty by\n", &
					"reason of insanity."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			30
	
	SCRIPT_END

; ------------------------------------------------------------------------------
; Data
; ------------------------------------------------------------------------------

	section m68k_rom_bank_3
Pal_PaddedCell:
	incbin	"src/rpg/maps/prison/palette.bin", 0, $20
	even

; ------------------------------------------------------------------------------
