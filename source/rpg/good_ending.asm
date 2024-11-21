; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Good ending cutscene
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"source/rpg/shared.inc"

; ------------------------------------------------------------------------------

GoodEndingCutscene:
	lea	Sfx_Warp,a0					; Play appear sound
	jsr	PlaySfx

	jsr	FadePaletteToWhite				; Fade to white
	jsr	DisableDisplay					; Disable display
	
	move	#$2700,sr					; Disable interrupts
	move.w	#$C000,d0					; Clear VRAM tables
	move.l	#$4000,d1
	jsr	ClearVramRegion
	jsr	InitMarsGraphics				; Initialize 32X graphics
	jsr	InitScript					; Initialize scripting

	VDP_CMD move.l,$BFC0,VRAM,WRITE,VDP_CTRL		; Patch ~ into black bar
	moveq	#$FFFFFFFF,d0
	rept 16
		move.l	d0,VDP_DATA
	endr

	pea	MarsPal_Global					; Load global 32X palette
	move.b	#2,-(sp)
	clr.b	-(sp)
	jsr	LoadMarsPalette
	
	pea	MarsPal_GoodEnding				; Load good ending cutscene 32X palette
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

	pea	MarsSpr_GoodEnding				; Load good ending cutscene 32X sprites
	move.b	#1,-(sp)
	move.b	#$80,-(sp)
	jsr	LoadMarsSprites
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMarsGraphicsData
	
	bsr.w	DrawFrame					; Draw frame

	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in

	lea	GoodEndingScript,a0				; Run script
	jsr	StartScript
	
	bra.s	StartScriptLoop					; Start script loop

; ------------------------------------------------------------------------------

ScriptLoop:
	jsr	VSync						; VSync
	bsr.w	DrawFrame					; Draw frame

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

	lea	GoodEndingScript2,a0				; Run script
	jsr	StartScript
	
	bra.s	StartScriptEndLoop				; Start script end loop

; ------------------------------------------------------------------------------

ScriptEndLoop:
	jsr	VSync						; VSync
	jsr	ClearMarsScreen					; Draw frame

	jsr	DrawScriptTextbox				; Draw textbox
	
	jsr	UpdateMarsPaletteFade				; Update 32X palette fade
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	
	jsr	UpdateCram					; Update CRAM

StartScriptEndLoop:
	jsr	UpdateScript					; Update script

	tst.l	script_address					; Is the script done?
	bne.s	ScriptEndLoop					; If not, loop
	
	SET_EVENT EVENT_STAGE_1					; Stage 1 finished
	move.b	#1,sonic_stage_id				; Go to Ring Girl boss

	move.w	#$FF26,MARS_COMM_10+MARS_SYS			; Play music
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

GoodEndingScript:
	SCRIPT_DELAY			45

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			RealOllieIcon, 0
	
	SCRIPT_TEXT			"Ollie? "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"Ollie, is that you?"	  
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			OllieIcon, 0
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Yes, it is I, cousin."
	SCRIPT_WAIT_INPUT

	SCRIPT_ICON			RealOllieIcon, 0
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"It's time for you to accept\n", &
					"who you really are, "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"~~~~~~~~~."
	SCRIPT_WAIT_INPUT

	SCRIPT_ICON			OllieIcon, 0
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"..."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"You're right. "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"No more hiding.\n", &
					"I have to face who I really am\n", &
					"and accept that you're gone."
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"It's so difficult, I looked up\n", &
					"to you so highly, only to see\n", &
					"you buried deep down below."
	SCRIPT_WAIT_INPUT

	SCRIPT_ICON			RealOllieIcon, 0
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"There's nothing for you to be\n", &
					"ashamed of."
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"If you want to truly keep my\n", &
					"memory alive, just remember me,\n", &
					"be true to yourself."
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Smile, for tomorrow is a new\n", &
					"day, and tomorrow comes today."
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Goodbye for now, cousin. "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"'til\n", &
					"we meet again."
	SCRIPT_WAIT_INPUT

	SCRIPT_ICON			OllieIcon, 0
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Wait! Please! Don't go! Don't\n", &
					"leave me again!!!"
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			15
	
	SCRIPT_END

; ------------------------------------------------------------------------------

GoodEndingScript2:
	SCRIPT_DELAY			90

	SCRIPT_ICON			OllieIcon, 0
			
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"What am I doing? "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"Why am I\n", &
					"living like this?"
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Have I really let myself slip\n", &
					"down this far in the name of my\n", &
					"cousin?"
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"He really was a talented and\n", &
					"amazing guy... "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"I could never\n", &
					"fill in his shoes."
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"He's right. I should start\n", &
					"living for myself, and only\n", &
					"myself."
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Why insult his legacy like\n", &
					"this?"
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I've done enough damage. It's\n", &
					"time that I move on and get\n", &
					"myself figured out."
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Maybe one day, I could make him\n", &
					"proud in my own unique way,\n", &
					"instead of trying to copy him."
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Look out, everyone, because\n", &
					"Ollie_Ollie_TechDeck is coming\n", &
					"to rock this world."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			15
	
	SCRIPT_END

; ------------------------------------------------------------------------------
; Icons
; ------------------------------------------------------------------------------

RealOllieIcon:
	dc.l	MarsSpr_RpgTextboxIcons
	dc.w	2
	dc.l	0

.Anims:
	dc.w	.Static-.Anims

.Static:
	ANIM_START $100, ANIM_RESTART
	dc.w	5
	ANIM_END

; ------------------------------------------------------------------------------
