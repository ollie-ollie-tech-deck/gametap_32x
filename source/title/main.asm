; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Title screen scene
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/title/shared.inc"
	include	"source/splash/data/mars.inc"

; ------------------------------------------------------------------------------

TitleScreenScene:
	move	#$2700,sr					; Setup V-BLANK
	bsr.w	ClearVBlankRoutine
	
	bsr.w	ClearVram					; Clear VRAM
	bsr.w	ClearVsram					; Clear VSRAM
	bsr.w	ClearSceneVariables				; Clear scene variables
	
	bsr.w	UnloadMarsSprites				; Unload 32X sprites
	bsr.w	SendMarsGraphicsCmds
	bsr.w	WaitMars
	
	move.w	#$8B03,VDP_CTRL					; Line horizontal scroll, screen vertical scroll

	moveq	#PLANE_SIZE_64_32,d0				; Set plane size to 64x32
	bsr.w	SetPlaneSize

	moveq	#CHUNK_SIZE_128,d0				; Set chunk size to 128x128
	bsr.w	SetMapChunkSize

	clr.w	-(sp)						; Set 32X background color
	clr.b	-(sp)
	bsr.w	SetMarsColor

	pea	MarsPal_SplashBackground			; Load background 32X palette
	move.b	#$E0,-(sp)
	st.b	-(sp)
	bsr.w	LoadMarsPalette

	pea	MarsPal_TitleLogos				; Load logo 32X palette
	move.b	#2,-(sp)
	clr.b	-(sp)
	bsr.w	LoadMarsPalette

	pea	MarsSpr_TitleBackground				; Load background 32X sprites
	clr.b	-(sp)
	move.b	#2,-(sp)
	bsr.w	LoadMarsSprites

	pea	MarsSpr_TitleLogos				; Load logo 32X sprites
	move.b	#1,-(sp)
	move.b	#2,-(sp)
	bsr.w	LoadMarsSprites
	
	lea	Art_TitlePressStart,a1				; Load press start text art
	move.w	#$8000,d2
	bsr.w	QueueKosmData

	bsr.w	FlushKosmQueue					; Flush Kosinski Moduled queue
	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bsr.w	WaitMarsGraphicsData

; ------------------------------------------------------------------------------

	move.w	#gametap_scale,cur_logo_scale			; Scale GameTap logo up
	bsr.w	ScaleLogoUp

	move.w	#cup_noodles_scale,cur_logo_scale		; Scale Cup Noodles logo up
	bsr.w	ScaleLogoUp

	move.w	#bitter_tears_scale,cur_logo_scale		; Scale Bitter Tears logo up
	bsr.w	ScaleLogoUp
	
	moveq	#20,d0						; Delay for a bit
	bsr.w	Delay

FlashTitleWhite:
	lea	Sfx_Flash,a0					; Play flash sound
	bsr.w	PlaySfx
	
	bsr.w	FadePaletteToWhite				; Fade to white
	bsr.w	DisableDisplay					; Disable display

; ------------------------------------------------------------------------------

	move	#$2700,sr					; Disable interrupts

	move.w	#2,camera_fg_x					; Set camera position
	move.w	#-12,camera_fg_y
	
	move.b	#6-1,pal_cycle_timer				; Reset palette cycle timer

	bsr.w	ClearMarsScreen					; Erase background
	bsr.w	DrawLogos
	bsr.w	WaitMars

	lea	TitleMapData,a0					; Load map data
	moveq	#0,d0
	bsr.w	LoadMapData
	
	bsr.w	FlushKosmQueue					; Flush Kosinski Moduled queue
	
	lea	Deformation,a0					; Initialize map scrolling
	bsr.w	ScrollDeformed

	clr.b	map_bg_flags					; Initialize map drawing
	bsr.w	RefreshMapBg

	moveq	#60,d0						; Delay for a bit
	bsr.w	Delay
	
	bsr.w	DisableAtGamesSound				; Disable AtGames sound mode
	bsr.w	WaitSoundCommand

	lea	Song_Title,a0					; Play music
	bsr.w	PlayMusic

	bsr.w	EnableDisplay					; Enable display
	bsr.w	FadePaletteIn					; Fade palette in
	
; ------------------------------------------------------------------------------

UpdateLoop:
	bsr.w	VSync						; VSync
	bsr.w	ClearMarsScreen					; Clear 32X screen
	
	bsr.w	DrawLogos					; Draw logos

	subq.b	#1,pal_cycle_timer				; Decrement palette cycle timer
	bpl.s	.NoPalCycle					; If it hasn't run out, branch
	move.b	#6-1,pal_cycle_timer				; Reset palette cycle timer

	lea	palette+$50+6,a1				; Cycle water palette
	move.w	(a1),d0
	move.w	-(a1),2(a1)
	move.w	-(a1),2(a1)
	move.w	-(a1),2(a1)
	move.w	d0,(a1)

.NoPalCycle:
	bsr.w	StartSpriteDraw					; Start drawing sprites

	addi.l	#$C000,camera_fg_y				; Move the logos up
	cmpi.w	#10,camera_fg_y					; Have the logos moved up enough?
	blt.s	.FinishSprites					; If not, branch	
	move.w	#10,camera_fg_y					; Stop moving

	btst	#6,camera_fg_x+1				; Should we draw the press start text?
	bne.s	.FinishSprites					; If not, branch

	pea	Spr_TitlePressStart				; Draw press start text
	clr.w	-(sp)
	move.w	#$400,-(sp)
	clr.b	-(sp)
	move.w	#160,-(sp)
	move.w	#200,-(sp)
	bsr.w	DrawSprite

.FinishSprites:
	bsr.w	FinishSpriteDraw				; Finish drawing sprites

	cmpi.w	#10,camera_fg_y					; Should we move the camera to the right?
	bne.s	.NoScroll					; If not, branch
	addq.w	#2,camera_fg_x					; Move the camera to the right

.NoScroll:
	lea	Deformation,a0					; Scroll map
	bsr.w	ScrollDeformed
	
	bsr.w	UpdateCram					; Update CRAM
	
	tst.b	p1_ctrl_tap					; Loop
	bpl.w	UpdateLoop

; ------------------------------------------------------------------------------

	bsr.w	VSync						; VSync
	move	#$2700,sr					; Disable interrupts

	bsr.w	HaltSound					; Halt sound
	bsr.w	UnloadMarsSprites				; Unload 32X sprites

	pea	MarsSpr_TitleGlitchedLogos			; Load glitched logo 32X sprites
	move.b	#1,-(sp)
	move.b	#2,-(sp)
	bsr.w	LoadMarsSprites

	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bsr.w	WaitMarsGraphicsData

	bsr.w	Random						; Corrupt 32X background color
	ori.w	#$8000,d0
	move.w	d0,-(sp)
	clr.b	-(sp)
	bsr.w	SetMarsColor

	moveq	#2,d2						; Corrupt 32X palette

.CorruptMarsPalette:
	bsr.w	Random
	andi.w	#$7FFF,d0
	move.w	d0,-(sp)
	move.b	d2,-(sp)
	bsr.w	SetMarsColor
	addq.b	#1,d2
	cmpi.b	#84,d2
	bne.s	.CorruptMarsPalette

	lea	palette,a0					; Corrupt palette
	moveq	#$40-1,d2

.CorruptPalette:
	bsr.w	Random
	andi.w	#$EEE,d0
	move.w	d0,(a0)+
	dbf	d2,.CorruptPalette

	lea	hscroll,a0					; Corrupt horizontal scroll data
	move.w	#224-1,d2

.CorruptHScroll:
	bsr.w	Random
	move.w	d0,(a0)+
	bsr.w	Random
	move.w	d0,(a0)+
	dbf	d2,.CorruptHScroll
	
	bsr.w	Random						; Corrupt vertical scroll value
	move.w	d0,camera_bg_y

	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bsr.w	WaitMarsGraphicsData
	
	bsr.w	ClearMarsScreen					; Draw logos
	bsr.w	DrawLogos

	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bsr.w	WaitMars

	bsr.w	UpdateCram					; Update CRAM

	move.w	#135,d0						; Delay for a bit
	bsr.w	Delay

	bsr.w	StopSound					; Stop sound

	moveq	#-7,d0						; Set palette fade intensity
	bsr.w	SetPaletteFadeIntensity

	move.w	#15,d0						; Delay for a bit
	bsr.w	Delay

	clr.b	sonic_stage_id					; Go to the first Sonic stage
	jmp	SonicStageScene

; ------------------------------------------------------------------------------
; Scale logo up
; ------------------------------------------------------------------------------

ScaleLogoUp:
	bsr.w	WaitMars					; Wait for the 32X to not be busy

.Loop:
	bsr.w	VSync						; VSync

	tst.b	p1_ctrl_tap					; Has the start button been pressed?
	bpl.s	.GetScale					; If so, branch

	move.w	#$100,d0					; Skip scaling
	move.w	d0,gametap_scale
	move.w	d0,cup_noodles_scale
	move.w	d0,bitter_tears_scale

	move.l	#FlashTitleWhite,(sp)				; Immediately flash to white
	rts

.GetScale:
	bsr.w	ClearMarsScreen					; Clear 32X screen
	
	movea.w	cur_logo_scale,a0				; Get scale value address

	tst.w	(a0)						; Is the scale value initialized?
	bne.s	.CheckScaleUp					; If not, branch
	move.w	#$A0*$30,(a0)					; Initialize scale value

.CheckScaleUp:
	cmpi.w	#$100,(a0)					; Should we scale down?
	blt.s	.ScaleDown					; If so, branch

	subi.w	#$A0,(a0)					; Scale up
	cmpi.w	#$D8,(a0)					; Are we done scaling up?
	bgt.s	.Draw						; If not, branch
	move.w	#$D8,(a0)					; Cap scale value

	lea	Sfx_Dash,a0					; Play dash sound
	bsr.w	PlaySfx

	bsr.s	DrawInitialBackground				; Draw initial background
	bsr.s	DrawLogos					; Draw logos
	bra.s	.Loop						; Loop

.ScaleDown:
	addq.w	#4,(a0)						; Scale down
	cmpi.w	#$100,(a0)					; Are we done scaling up?
	blt.s	.Draw						; If not, branch
	move.w	#$100,(a0)					; Cap scale value

	bsr.w	WaitMars					; Wait for the 32X to not be busy
	bsr.s	DrawInitialBackground				; Draw initial background
	bra.s	DrawLogos					; Draw logos

.Draw:
	bsr.s	DrawInitialBackground				; Draw initial background
	bsr.s	DrawLogos					; Draw logos
	bra.s	.Loop						; Loop

; ------------------------------------------------------------------------------
; Draw initial background
; ------------------------------------------------------------------------------

DrawInitialBackground:
	moveq	#0,d0						; Draw background piece 1
	cmpi.w	#$100,gametap_scale
	bne.s	.DrawPiece1
	moveq	#2,d0

.DrawPiece1:
	clr.b	-(sp)
	move.b	d0,-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite

	moveq	#1,d0						; Draw background piece 2
	cmpi.w	#$100,cup_noodles_scale
	bne.s	.DrawPiece2
	moveq	#3,d0

.DrawPiece2:
	clr.b	-(sp)
	move.b	d0,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Draw logos
; ------------------------------------------------------------------------------

DrawLogos:
	tst.w	camera_fg_x					; Is the camera moving?
	bne.s	.DrawGameTap					; If so, branch
	cmpi.w	#$100,gametap_scale				; Should we draw the GameTap logo?
	beq.s	.NoGameTap					; If not, branch

.DrawGameTap:
	move.b	#1,-(sp)					; Draw GameTap logo
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	#92,-(sp)
	move.w	#70,d0
	move.w	camera_fg_y,d1
	bmi.s	.SetGameTapY
	sub.w	d1,d0

.SetGameTapY:
	move.w	d0,-(sp)
	move.w	gametap_scale,-(sp)
	move.w	gametap_scale,-(sp)
	bsr.w	DrawLoadedMarsSprite

.NoGameTap:
	tst.w	camera_fg_x					; Is the camera moving?
	bne.s	.DrawCupNoodles					; If so, branch
	cmpi.w	#$100,cup_noodles_scale				; Should we draw the Cup Noodles logo?
	beq.s	.NoCupNoodles					; If not, branch

.DrawCupNoodles:
	move.b	#1,-(sp)					; Draw Cup Noodles logo
	move.b	#1,-(sp)
	clr.b	-(sp)
	move.w	#226,-(sp)
	move.w	#70,d0
	move.w	camera_fg_y,d1
	bmi.s	.SetCupNoodlesY
	sub.w	d1,d0

.SetCupNoodlesY:
	move.w	d0,-(sp)
	move.w	cup_noodles_scale,-(sp)
	move.w	cup_noodles_scale,-(sp)
	bsr.w	DrawLoadedMarsSprite

.NoCupNoodles
	move.b	#1,-(sp)					; Draw Bitter Tears logo
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	#160,-(sp)
	move.w	#158,d0
	move.w	camera_fg_y,d1
	bmi.s	.SetBitterTearsY
	sub.w	d1,d0

.SetBitterTearsY:
	move.w	d0,-(sp)
	move.w	bitter_tears_scale,-(sp)
	move.w	bitter_tears_scale,-(sp)
	bsr.w	DrawLoadedMarsSprite
	
	bra.w	SendMarsGraphicsCmds				; Send 32X graphics commands

; ------------------------------------------------------------------------------
; Deformation table
; ------------------------------------------------------------------------------

	section m68k_rom_fixed_data
	
Deformation:
	; Clouds
	DEFORM	32, camera_fg_x, $0060, -$0002AA00, $0000, 0
	DEFORM	16, camera_fg_x, $0060, -$00020000, $0000, 0
	DEFORM	16, camera_fg_x, $0060, -$00015500, $0000, 0

	; Mountains
	DEFORM	48, camera_fg_x, $0060,  $00000000, $0000, 0
	DEFORM	40, camera_fg_x, $0080,  $00000000, $0000, 0

	; Water
	DEFORM	72, camera_fg_x, $0080,  $00000000, $013B, 1

	DEFORM_END

; ------------------------------------------------------------------------------
