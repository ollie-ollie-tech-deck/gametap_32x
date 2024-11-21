; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Suspect choose screen
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"source/rpg/shared.inc"

; ------------------------------------------------------------------------------

SuspectChoose:
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
	
	pea	MarsPal_SuspectChoose				; Load suspect choose 32X palette
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

	pea	MarsSpr_SuspectChoose				; Load suspect choose 32X sprites
	move.b	#1,-(sp)
	move.b	#$80,-(sp)
	jsr	LoadMarsSprites
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMarsGraphicsData
	
	bsr.w	DrawFrame					; Draw frame

	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in
	
	lea	ChooseScript,a0					; Run script
	jsr	StartScript

	bra.s	StartChooseLoop					; Start choose loop

; ------------------------------------------------------------------------------

ChooseLoop:
	jsr	VSync						; VSync
	bsr.s	DrawFrame					; Draw frame

StartChooseLoop:
	jsr	UpdateScript					; Update script
	tst.l	script_address					; Is the script done?
	bne.s	ChooseLoop					; If not, loop

	SET_EVENT EVENT_SUSPECT_CHOOSE				; Set suspect choose event flag

	move.b	#8,rpg_room_id					; Go to hospital room
	bra.w	ResumeRpgStageScene

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

	btst	#SCRIPT_SELECTION_FLAG,script_flags		; Should we draw the arrow?
	beq.s	.NoArrow					; If not, branch
	
	move.b	#1,-(sp)					; Draw arrow
	move.b	#2,-(sp)
	clr.b	-(sp)
	moveq	#64,d0
	tst.b	script_selection_id
	beq.s	.SetArrowX
	move.w	#256,d0

.SetArrowX:
	move.w	d0,-(sp)
	move.w	#24,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

.NoArrow:
	jsr	DrawScriptTextbox				; Draw textbox
	
	jsr	UpdateMarsPaletteFade				; Update 32X palette fade
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	
	jmp	UpdateCram					; Update CRAM

; ------------------------------------------------------------------------------
; Scripts
; ------------------------------------------------------------------------------

ChooseScript:
	SCRIPT_DELAY			15

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			CopIcon, 0

	SCRIPT_TEXT			"Which of them did this to you?"
	SCRIPT_SELECTION		"Suspect 1", .Chosen, &
					"Suspect 2", .Chosen

.Chosen:
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			15
	SCRIPT_END

; ------------------------------------------------------------------------------
