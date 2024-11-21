; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Photo cutscene
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"source/rpg/shared.inc"

; ------------------------------------------------------------------------------

PhotoCutscene:
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
	
	pea	MarsPal_Textbox					; Load textbox 32X palette
	move.b	#$F4,-(sp)
	move.b	#1,-(sp)
	jsr	LoadMarsPalette

	pea	MarsSpr_Textbox					; Load textbox 32X sprites
	clr.b	-(sp)
	move.b	#$F4,-(sp)
	jsr	LoadMarsSprites

	pea	MarsSpr_PhotoCutscene				; Load photo cutscene 32X sprites
	move.b	#1,-(sp)
	move.b	#2,-(sp)
	jsr	LoadMarsSprites
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMarsGraphicsData
	
	move.w	#-32,photo_x					; Set initial photo position
	move.w	#320,photo_y
	
	bsr.w	DrawFrame					; Draw frame
	
	jsr	StopSound					; Stop sound
	move.w	#$FF1C,MARS_COMM_10+MARS_SYS			; Play music

	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in
	
	move.w	#15*60,d0					; Delay for a bit
	jsr	Delay
	
	bra.s	StartPhotoLoop					; Start photo loop

; ------------------------------------------------------------------------------

PhotoLoop:
	jsr	VSync						; VSync
	bsr.w	DrawFrame					; Draw frame

StartPhotoLoop:
	addq.w	#4,photo_x					; Move hand into view
	subq.w	#6,photo_y
	
	cmpi.w	#128,photo_y					; Has the hand moved enough?
	bgt.s	PhotoLoop					; If not, branch
	
	bsr.w	DrawFrame					; Draw frame
	jsr	VSync						; VSync
	
	move.w	#1*60,d0					; Delay for a bit
	jsr	Delay
	
	move.w	#$FF1D,MARS_COMM_12+MARS_SYS			; Play crying sound
	
	move.w	#7*60,d0					; Delay for a bit
	jsr	Delay
	
	jsr	FadePaletteToBlack				; Fade to black
	jsr	DisableDisplay					; Disable display
	
	jsr	ClearMarsScreen					; Clear screen
	jsr	WaitMarsDraw
	
	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in
	
	lea	LeaveScript,a0					; Run script
	jsr	StartScript

	bra.s	StartScriptLoop					; Start script loop
	
; ------------------------------------------------------------------------------

ScriptLoop:
	jsr	VSync						; VSync
	jsr	ClearMarsScreen					; Draw frame
	bsr.s	DrawFrame2

StartScriptLoop:
	jsr	UpdateScript					; Update script
	tst.l	script_address					; Is the script done?
	bne.s	ScriptLoop					; If not, loop
	
	move.b	#4,rpg_room_id					; Go to outside of Ollie's house
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

	move.b	#1,-(sp)					; Draw hand with photo
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	photo_x,-(sp)
	move.w	photo_y,-(sp)
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

LeaveScript:
	SCRIPT_DELAY			3*60

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I need to get out of here.\n"
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			30
	
	SCRIPT_END

; ------------------------------------------------------------------------------
