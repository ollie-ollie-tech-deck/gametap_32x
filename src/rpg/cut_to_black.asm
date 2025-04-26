; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Cut to black cutscene
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"src/rpg/shared.inc"

; ------------------------------------------------------------------------------

RpgCutToBlack:
	CHECK_EVENT EVENT_STAGE_5				; Have we beaten stage 5?
	bne.s	.Fade						; If so, branch
	CHECK_EVENT EVENT_STAGE_4				; Have we beaten stage 4?
	beq.s	.NoFade						; If not, branch
	CHECK_EVENT EVENT_CULT_ESCAPE_FAIL			; Did the player fail to escape the cult?
	bne.s	.NoFade						; If so, branch

.Fade:
	jsr	FadePaletteToBlack				; Fade to black
	bra.s	.DisableDisplay

.NoFade:
	moveq	#-7,d0						; Cut to black
	jsr	SetPaletteFadeIntensity
	jsr	VSync

.DisableDisplay:
	jsr	DisableDisplay					; Disable display
	
	jsr	ClearMarsScreen					; Clear 32X screen
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMars

	move.w	#2*60,d0					; Delay for a bit
	jsr	Delay

	CHECK_EVENT EVENT_STAGE_3				; Have we beaten stage 3?
	bne.s	.Stage4						; If so, branch
	
	SET_EVENT EVENT_STAGE_2					; Stage 2 finished
	move.b	#3,sonic_stage_id				; Go to Ben boss
	jmp	SonicStageScene

.Stage4:
	CHECK_EVENT EVENT_STAGE_4				; Have we beaten stage 4?
	bne.s	.Stage5						; If so, branch

	SET_EVENT EVENT_STAGE_4					; Stage 4 finished
	move.b	#7,sonic_stage_id				; Go to Toad boss
	jmp	SonicStageScene

.Stage5:
	CHECK_EVENT EVENT_STAGE_5				; Have we beaten stage 5?
	bne.s	.Stage6						; If so, branch

	CHECK_EVENT EVENT_ASSAULTED_CULT			; Did the player assault the cult?
	bne.s	.Stage5Prison					; If so, branch
	CHECK_EVENT EVENT_CULT_ESCAPE_FAIL			; Did the player fail to escape the cult?
	bne.s	CultEscapeFail					; If so, branch

	SET_EVENT EVENT_STAGE_5					; Stage 5 finished
	move.b	#11,sonic_stage_id				; Go to computer final stage
	jmp	SonicStageScene

.Stage5Prison:
	CHECK_EVENT EVENT_ASSAULTED_WARDEN			; Was the warden assaulted?
	bne.s	.Stage5Assault					; If so, branch

	SET_EVENT EVENT_STAGE_5					; Stage 5 finished
	move.b	#9,sonic_stage_id				; Go to normal final stage
	jmp	SonicStageScene

.Stage5Assault:
	SET_EVENT EVENT_STAGE_5					; Stage 5 finished
	move.b	#10,sonic_stage_id				; Go to prison final stage
	jmp	SonicStageScene

.Stage6:
	pea	NeutralEndingScript				; Go to netural ending
	bra.s	EndingMessage

; ------------------------------------------------------------------------------

CultEscapeFail:
	pea	CultEscapeFailScript				; Go to cult escape fail ending

; ------------------------------------------------------------------------------

EndingMessage:
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
	
	pea	MarsPal_Textbox					; Load textbox 32X palette
	move.b	#$F4,-(sp)
	move.b	#1,-(sp)
	jsr	LoadMarsPalette

	pea	MarsSpr_Textbox					; Load textbox 32X sprites
	clr.b	-(sp)
	move.b	#$F4,-(sp)
	jsr	LoadMarsSprites
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMarsGraphicsData

	jsr	ClearMarsScreen					; Clear screen
	jsr	WaitMarsDraw
	
	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in
	
	movea.l	(sp)+,a0					; Run script
	jsr	StartScript

	bra.s	.StartScriptLoop				; Start script loop
	
; ------------------------------------------------------------------------------

.ScriptLoop:
	jsr	VSync						; VSync
	
	jsr	ClearMarsScreen					; Clear 32X screen
	jsr	DrawScriptTextbox				; Draw textbox
	
	jsr	UpdateMarsPaletteFade				; Update 32X palette fade
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	
	jsr	UpdateCram					; Update CRAM

.StartScriptLoop:
	jsr	UpdateScript					; Update script
	tst.l	script_address					; Is the script done?
	bne.s	.ScriptLoop					; If not, loop

	jmp	CreditsScene					; Go to credits

; ------------------------------------------------------------------------------
; Scripts
; ------------------------------------------------------------------------------

CultEscapeFailScript:
	SCRIPT_SHOW_TEXTBOX
	
	SCRIPT_TEXT			"Ollie has been murdered by the\n", &
					"cultists."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			30
	
	SCRIPT_END

; ------------------------------------------------------------------------------

NeutralEndingScript:
	SCRIPT_SHOW_TEXTBOX
	
	SCRIPT_TEXT			"Ollie continues to live his miserable\n", &
					"life as he always has."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			30
	
	SCRIPT_END

; ------------------------------------------------------------------------------
