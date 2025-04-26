; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sonic CulT flashback
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"src/rpg/shared.inc"

; ------------------------------------------------------------------------------

SonicCultFlashback:
	jsr	FadePaletteToWhite				; Fade to white
	
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
	
	pea	MarsPal_Textbox					; Load textbox 32X palette
	move.b	#$F4,-(sp)
	move.b	#1,-(sp)
	jsr	LoadMarsPalette

	pea	MarsSpr_Textbox					; Load textbox 32X sprites
	clr.b	-(sp)
	move.b	#$F4,-(sp)
	jsr	LoadMarsSprites

	pea	MarsSpr_SonicCult				; Load Sonic CulT flashback 32X sprites
	move.b	#1,-(sp)
	move.b	#2,-(sp)
	jsr	LoadMarsSprites
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMarsGraphicsData
	
	move.w	#60,d0						; Delay for a bit
	jsr	Delay
	
	jsr	ClearMarsScreen					; Draw monitor
	moveq	#2,d0
	bsr.w	DrawMonitorFrame
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMarsDraw
	
	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in
	
	lea	SonicCultScript,a0				; Run script
	jsr	StartScript
	
	clr.b	sonic_cult_screen				; Reset screen ID
	clr.b	prev_sonic_cult_screen

	bra.s	StartScriptLoop					; Start script loop

; ------------------------------------------------------------------------------

ScriptLoop:
	jsr	VSync						; VSync
	
	moveq	#0,d0						; Get previous ID
	move.b	sonic_cult_flashback,d0
	cmp.b	prev_sonic_cult_screen,d0			; Has it changed?
	beq.s	.Draw						; If not, branch
	move.b	d0,prev_sonic_cult_screen			; Set previous screen ID

	move.w	d0,-(sp)					; Fade to black
	jsr	FadePaletteToBlack
	jsr	DisableDisplay
	move.w	(sp)+,d0
	
	move.w	d0,-(sp)					; Clear 32X screen
	jsr	ClearMarsScreen
	move.w	(sp)+,d0
	
	lsl.w	#3,d0						; Draw screen
	lea	DrawScreen(pc),a0
	jsr	(a0,d0.w)

	jsr	EnableDisplay					; Fade palette in
	jsr	FadePaletteIn
	bra.s	.DrawDone

.Draw:
	tst.l	script_address					; Is there a script running?
	beq.s	.DrawDone					; If not, branch

	move.w	d0,-(sp)					; Clear 32X screen
	jsr	ClearMarsScreen
	move.w	(sp)+,d0

	lsl.w	#3,d0						; Draw screen
	lea	DrawScreen(pc),a0
	jsr	(a0,d0.w)

.DrawDone:
	jsr	DrawScriptTextbox				; Draw textbox
	
	jsr	UpdateMarsPaletteFade				; Update 32X palette fade
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	
	jsr	UpdateCram					; Update CRAM

StartScriptLoop:
	jsr	UpdateScript					; Update script
	
	btst	#SCRIPT_PAUSE_FLAG,script_flags			; Is the script paused yet?
	beq.w	ScriptLoop					; If not, loop

	move.w	#30,d0						; Delay for a bit
	jsr	Delay

	bra.w	StartPunchLoop					; Start punch loop
	
; ------------------------------------------------------------------------------

PunchLoop:
	jsr	VSync						; VSync
	jsr	ClearMarsScreen					; Clear 32X screen

	moveq	#0,d0						; Get fist frame
	move.b	sonic_cult_fist_frame,d0
	lea	FistFrames(pc),a0
	move.b	(a0,d0.w),d0
	move.b	d0,-(sp)
	
	cmpi.b	#-1,d0						; Is this a dummy frame?
	beq.s	.GetMonitorFrame				; If so, branch

	tst.b	d0						; Should we shake on this frame?
	bpl.s	.CheckShakeSet					; If not, branch

	neg.w	camera_fg_y_shake				; Shake the screen

.CheckShakeSet:
	btst	#6,d0						; Should we set the shake offset?
	beq.s	.GetMonitorFrame				; If so, branch

	tst.w	camera_fg_y_shake				; Set shake offset
	seq	d0
	ext.w	d0
	add.w	d0,d0
	move.w	d0,camera_fg_y_shake

.GetMonitorFrame:
	moveq	#2,d0						; Draw monitor
	cmpi.b	#FistHitFrame-FistFrames,sonic_cult_fist_frame
	beq.s	.PlaySound
	bcc.s	.SetMonitorFrame
	bra.s	.DrawMonitor

.PlaySound:
	move.w	#$FF19,MARS_COMM_10+MARS_SYS

.SetMonitorFrame:
	moveq	#3,d0

.DrawMonitor:
	bsr.w	DrawMonitorFrame

	move.b	(sp)+,d0					; Get fist frame
	cmpi.b	#-1,d0						; Should we draw on this frame?
	beq.s	.NoFistDraw					; If not, branch
	andi.w	#$3F,d0						; Remove shake flag

.DrawFist:
	move.b	#1,-(sp)					; Draw fist
	move.b	d0,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#160,d0
	add.w	camera_fg_y_shake,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	
.NoFistDraw:
	jsr	UpdateMarsPaletteFade				; Update 32X palette fade
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	
	jsr	UpdateCram					; Update CRAM

StartPunchLoop:
	addq.b	#1,sonic_cult_fist_frame			; Increment frame ID
	cmpi.b	#FistFramesEnd-FistFrames,sonic_cult_fist_frame	; Are we done?
	blt.w	PunchLoop					; If not, branch
	
	move.w	#90,d0						; Delay for a bit
	jsr	Delay

	jsr	FadePaletteToBlack				; Fade to black
	jsr	DisableDisplay					; Disable display
	
	jsr	ClearMarsScreen					; Clear screen
	jsr	WaitMarsDraw
	
	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in

	jsr	UnpauseScript					; Unpause script
	bra.s	StartScriptEndLoop				; Start script end loop

; ------------------------------------------------------------------------------

ScriptEndLoop:
	jsr	VSync						; VSync
	jsr	ClearMarsScreen					; Clear screen

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
	jmp	SonicStageScene
	
; ------------------------------------------------------------------------------

FistFrames:
	dc.b	4, 4
	dc.b	5, 5
FistHitFrame:
	dc.b	$C6, 6, $86, 6, $86, 6, $86, 6, $46, 6, 6, 6
	dc.b	5, 5, 5
	dc.b	4, 4, 4
	dc.b	-1, -1
FistFramesEnd:
	even

; ------------------------------------------------------------------------------

DrawScreen:
	moveq	#2,d0						; Monitor
	bra.w	DrawMonitorFrame
	nop
	moveq	#0,d0						; Post 1
	bra.w	DrawZoomedScreen
	nop
	moveq	#8,d0						; Post 2
	bra.w	DrawZoomedScreen
	nop
	moveq	#16,d0						; Post 3
	bra.w	DrawZoomedScreen
	nop
	moveq	#2,d0						; Monitor (before punch)

; ------------------------------------------------------------------------------
; Draw monitor frame
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Screen frame ID
; ------------------------------------------------------------------------------

DrawMonitorFrame:
	move.w	d0,-(sp)					; Save screen frame ID

	move.b	#1,-(sp)					; Draw monitor (left)
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,d0
	add.w	camera_fg_y_shake,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	
	move.b	#1,-(sp)					; Draw monitor (right)
	move.b	#1,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#112,d0
	add.w	camera_fg_y_shake,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	move.w	(sp)+,d0

	move.b	#1,-(sp)					; Draw screen
	move.b	d0,-(sp)
	clr.b	-(sp)
	move.w	#160,-(sp)
	move.w	#112,d0
	add.w	camera_fg_y_shake,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Draw zoomed up screen
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Screen frame ID
; ------------------------------------------------------------------------------

DrawZoomedScreen:
	move.w	d0,-(sp)					; Save screen frame ID

	pea	MarsSpr_SonicCultScreens			; Draw screen (top left)
	move.b	d0,-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite
	move.w	(sp),d0
	
	pea	MarsSpr_SonicCultScreens			; Draw screen (top middle left)
	addq.b	#1,d0
	move.b	d0,-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite
	move.w	(sp),d0
	
	pea	MarsSpr_SonicCultScreens			; Draw screen (bottom left)
	addq.b	#2,d0
	move.b	d0,-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite
	move.w	(sp),d0
	
	pea	MarsSpr_SonicCultScreens			; Draw screen (bottom middle left)
	addq.b	#3,d0
	move.b	d0,-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite
	move.w	(sp),d0
	
	pea	MarsSpr_SonicCultScreens			; Draw screen (top middle right)
	addq.b	#4,d0
	move.b	d0,-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite
	move.w	(sp),d0
	
	pea	MarsSpr_SonicCultScreens			; Draw screen (top right)
	addq.b	#5,d0
	move.b	d0,-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite
	move.w	(sp),d0
	
	pea	MarsSpr_SonicCultScreens			; Draw screen (bottom middle right)
	addq.b	#6,d0
	move.b	d0,-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite
	move.w	(sp),d0
	
	pea	MarsSpr_SonicCultScreens			; Draw screen (bottom right)
	addq.b	#7,d0
	move.b	d0,-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite
	move.w	(sp)+,d0
	rts

; ------------------------------------------------------------------------------
; Scripts
; ------------------------------------------------------------------------------

SonicCultScript:
	SCRIPT_DELAY			60

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I wonder how Sonic CulT reacted\n", &
					"to the fan comic that I posted.\n"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			60
	SCRIPT_SET_NUMBER_BYTE		sonic_cult_flashback, 1
	SCRIPT_DELAY			5*60
	
	SCRIPT_SET_NUMBER_BYTE		sonic_cult_flashback, 2
	SCRIPT_DELAY			5*60
	
	SCRIPT_SET_NUMBER_BYTE		sonic_cult_flashback, 3
	SCRIPT_DELAY			5*60
	
	SCRIPT_SET_NUMBER_BYTE		sonic_cult_flashback, 4
	SCRIPT_DELAY			60

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"They hated it."
	SCRIPT_WAIT_INPUT

	SCRIPT_SET_NUMBER_BYTE		sonic_cult_fist_frame, $FF
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			2
	SCRIPT_PAUSE

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"Fuck this shit."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_SET_NUMBER_BYTE		sonic_cult_flashback, 0
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			60
	
	SCRIPT_END	

; ------------------------------------------------------------------------------
