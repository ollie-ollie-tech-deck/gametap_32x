; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Cult at front door cutscene
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"source/rpg/shared.inc"

; ------------------------------------------------------------------------------

CultFrontDoorCutscene:
	clr.w	stage_frame_count				; Reset frame count

	jsr	FadePaletteToBlack				; Fade to black
	
	move	#$2700,sr					; Disable interrupts
	jsr	DisableDisplay					; Disable display
	move.w	#$C000,d0					; Clear VRAM tables
	move.l	#$4000,d1
	jsr	ClearVramRegion
	jsr	InitMarsGraphics2				; Initialize 32X graphics
	jsr	InitScript					; Initialize scripting
	
	pea	MarsPal_Global					; Load global 32X palette
	move.b	#2,-(sp)
	clr.b	-(sp)
	jsr	LoadMarsPalette
	
	pea	MarsPal_CultFrontDoor				; Load cult at front door cutscene 32X palette
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

	pea	MarsSpr_CultFrontDoor				; Load cult at front door cutscene 32X sprites
	move.b	#1,-(sp)
	move.b	#$80,-(sp)
	jsr	LoadMarsSprites
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMarsGraphicsData
	
	bsr.w	DrawFrame					; Draw frame

	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in

	lea	CultFrontDoorScript,a0				; Run script
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
	
	SET_EVENT EVENT_STAGE_4					; Stage 4 finished
	move.b	#7,sonic_stage_id				; Go to Toad boss
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

	tst.b	cult_front_door					; Should the laser be drawn?
	beq.s	.NoLaser					; If not, branch

	move.w	stage_frame_count,d0				; Get X offset
	addq.w	#8,stage_frame_count
	jsr	CalcSine
	asr.w	#1,d0
	addi.w	#76,d0

	move.b	#1,-(sp)					; Draw laser
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	#158,-(sp)
	move.w	d0,-(sp)
	move.w	#$81,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

.NoLaser:
	jsr	DrawScriptTextbox				; Draw textbox
	
	jsr	UpdateMarsPaletteFade				; Update 32X palette fade
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	
	jmp	UpdateCram					; Update CRAM

; ------------------------------------------------------------------------------
; Scripts
; ------------------------------------------------------------------------------

CultFrontDoorScript:
	SCRIPT_DELAY			45

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Can I help you, gentlemen?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_ICON
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Hello, is this the TechDeck residence?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			OllieIcon, 0
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Who is asking?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_ICON
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"We're part of the brotherhood of Godly\n", &
					"Deeds."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			OllieIcon, 0
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"What do you people want?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_ICON
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"We were wondering if you were\n", &
					"interested in perhaps donating to our\n", &
					"newest charity drive."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			OllieIcon, 0
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I'm not interested. Now, get\n", &
					"off of my lawn before I hurt\n", &
					"one of you."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_ICON
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Please, Mr. TechDeck, there's no need\n", &
					"for that."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_SET_NUMBER_BYTE		cult_front_door, 1
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			30
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"AAAAAAAAAAAAAAAHHHHHHHHHH!!!!"
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			2
	
	SCRIPT_SET_EVENT		EVENT_ASSAULTED_CULT
	SCRIPT_END

; ------------------------------------------------------------------------------
