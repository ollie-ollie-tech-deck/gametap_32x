; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Silent Hill cutscene
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"source/rpg/shared.inc"

; ------------------------------------------------------------------------------

SilentHillCutscene:
	jsr	FadePaletteToBlack				; Fade to black
	jsr	DisableDisplay					; Disable display
	
	move	#$2700,sr					; Disable interrupts
	move.w	#$C000,d0					; Clear VRAM tables
	move.l	#$4000,d1
	jsr	ClearVramRegion
	jsr	InitMarsGraphics				; Initialize 32X graphics
	jsr	InitScript					; Initialize scripting
	
	pea	MarsPal_Global					; Load global 32X palette
	move.b	#2,-(sp)
	clr.b	-(sp)
	jsr	LoadMarsPalette
	
	pea	MarsPal_SilentHill				; Load Silent Hill cutscene 32X palette
	move.b	#$80,-(sp)
	clr.b	-(sp)
	jsr	LoadMarsPalette
	
	pea	MarsPal_Textbox					; Load textbox 32X palette
	move.b	#$F4,-(sp)
	move.b	#1,-(sp)
	jsr	LoadMarsPalette

	pea	MarsSpr_Textbox					; Load textbox 32X sprites
	clr.b	-(sp)
	move.b	#$F4,-(sp)
	jsr	LoadMarsSprites

	pea	MarsSpr_SilentHill				; Load Silent Hill cutscene 32X sprites
	move.b	#1,-(sp)
	move.b	#$80,-(sp)
	jsr	LoadMarsSprites
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMarsGraphicsData
	
	bsr.w	DrawFrame					; Draw frame

	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in

	lea	SilentHillScript,a0				; Run script
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
	
	jsr	FadePaletteToWhite				; Fade to white
	jsr	DisableDisplay					; Disable display

	moveq	#60,d0						; Delay for a bit
	jsr	Delay
	
	SET_EVENT EVENT_STAGE_3					; Stage 3 finished
	move.b	#5,sonic_stage_id				; Go to Slenderman boss
	jmp	SonicStageScene

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

	jsr	DrawScriptTextbox				; Draw textbox
	
	jsr	UpdateMarsPaletteFade				; Update 32X palette fade
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	
	jmp	UpdateCram					; Update CRAM

; ------------------------------------------------------------------------------
; Scripts
; ------------------------------------------------------------------------------

SilentHillScript:
	SCRIPT_DELAY			45

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"A small hand radio would have\n", &
					"helped me out if there's\n", &
					"anything scary out here."
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"It's almost as if there's a\n", &
					"silence over these hills."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			90

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"I'm so tired of living like\n", &
					"this..."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"My life constantly in danger...\n", &
					"on the straight knife edge of\n", &
					"of starvation..."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"All the while being the\n", &
					"antithesis of good health."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"...I'm going to die alone,\n", &
					"aren't I?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Rotting away, with nothing left\n", &
					"but a small, sad, and trivial\n", &
					"effort of a ROM hack."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I did Clownancy so wrong...\n"
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"oh, God... "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"my God..."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Clownancy... "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"hear my cries and\n", &
					"deliver me from this awful\n", &
					"hell."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			90

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"Oh God, I'm not feeling well."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			60
	
	SCRIPT_END

; ------------------------------------------------------------------------------
