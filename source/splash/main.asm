; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Splash screen scene
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/splash/shared.inc"
	
; ------------------------------------------------------------------------------

SplashTextDitherLen	equ SplashTextDitherEnd-SplashTextDither
GameTapLogoScaleDownLen	equ GameTapLogoScaleDownEnd-GameTapLogoScaleDown
GameTapLogoScaleUpLen	equ GameTapLogoScaleUpEnd-GameTapLogoScaleUp

; ------------------------------------------------------------------------------

SplashScreenScene:
	bsr.w	FadePaletteToBlack				; Fade to black
	bsr.w	DisableDisplay					; Disable display

	move	#$2700,sr					; Setup V-BLANK
	bsr.w	ClearVBlankRoutine
	
	bsr.w	InitScene					; Initialize scene

	moveq	#PLANE_SIZE_64_32,d0				; Set plane size to 64x32
	bsr.w	SetPlaneSize

	lea	Pal_SplashText,a0				; Load palette
	moveq	#0,d0
	moveq	#9,d1
	bsr.w	LoadPalette

	move.w	#$8000,-(sp)					; Set 32X background color
	clr.b	-(sp)
	bsr.w	SetMarsColor

	pea	MarsPal_SplashBackground			; Load background 32X palette
	move.b	#$E0,-(sp)
	st.b	-(sp)
	bsr.w	LoadMarsPalette

	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bsr.w	WaitMarsGraphicsData

	lea	GameTapLogo,a0					; Run GameTap logo
	bsr.s	RunLogo

	lea	ClownancyLogo,a0				; Run Clownancy logo
	bsr.s	RunLogo

	lea	OllieLogo,a0					; Run Ollie logo
	bsr.s	RunLogo

	jmp	TitleScreenScene				; Go to title screen

; ------------------------------------------------------------------------------
; Run logo
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Logo data address
; ------------------------------------------------------------------------------

RunLogo:
	bsr.w	WaitMars					; Wait for the 32X to not be busy

	move	#$2700,sr					; Disable interrupts

	move.w	#$C000,d0					; Clear planes
	move.l	#$3000,d1
	move.l	a0,-(sp)
	bsr.w	ClearVramRegion
	movea.l	(sp)+,a0

	bsr.w	UnloadMarsSprites				; Unload sprites

	move.l	(a0)+,d0					; Load text art
	move.l	a0,-(sp)
	movea.l	d0,a0
	lea	logo_text_art,a1
	bsr.w	KosDec
	movea.l	(sp)+,a0
	move.l	a1,d0
	sub.l	#logo_text_art,d0
	move.w	d0,text_art_length

	move.l	(a0)+,d3					; Decompress text mappings
	move.l	(a0)+,d0
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	move.l	a0,-(sp)
	movem.l	d0-d2,-(sp)
	movea.l	d3,a0
	lea	logo_text_map,a1
	moveq	#1,d0
	bsr.w	EniDec
	
	lea	logo_text_map,a0				; Load text mappings
	movem.l	(sp)+,d0-d2
	moveq	#0,d3
	bsr.w	DrawTilemap
	movea.l	(sp)+,a0

	move.l	(a0)+,-(sp)					; Load 32X palette
	move.b	#1,-(sp)
	st	-(sp)
	bsr.w	LoadMarsPalette
	
	pea	MarsSpr_SplashBackground			; Load background 32X sprites
	clr.b	-(sp)
	move.b	#$E0,-(sp)
	bsr.w	LoadMarsSprites

	move.l	(a0)+,-(sp)					; Load logo 32X sprites
	move.b	#1,-(sp)
	move.b	#1,-(sp)
	bsr.w	LoadMarsSprites

	move.l	(a0)+,logo_state				; Set initial logo state
	move.l	(a0)+,logo_draw					; Set draw routine
	move.w	(a0)+,logo_scale				; Set initial scale factor
	move.w	(a0)+,sample_command				; Set sample playback command
	move.b	(a0)+,-(sp)					; Save fade in flag

	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bsr.w	WaitMarsGraphicsData

	clr.l	logo_left_distort				; Reset logo drawing parameters
	clr.w	logo_x_intensity
	clr.l	logo_top_distort
	clr.w	logo_x_intensity
	clr.w	gametap_scale

	bsr.s	DrawBackground					; Draw background

	tst.b	(sp)+						; Should we fade in?
	beq.s	.Update						; If not, branch

	bsr.w	EnableDisplay					; Enable display
	bsr.w	FadePaletteIn					; Fade palette in

; ------------------------------------------------------------------------------

.Update:
	bsr.w	VSync						; VSync
	bsr.s	UpdateLogo					; Update and draw logo

	tst.b	p1_ctrl_tap					; Has the start button been pressed?
	bpl.s	.Update						; If not, loop
	
	cmpi.l	#GameTapLogoExitState,logo_state		; Are we already exiting?
	bcc.s	.Update						; If so, loop

	clr.w	wait_timer					; Set text hide state
	move.l	#LogoTextHideState,logo_state
	
	move.w	#$FF00,MARS_COMM_10+MARS_SYS			; Stop playing sound
	bsr.w	StopLogoScale					; Stop scaling logo
	
	bra.s	.Update						; Loop

; ------------------------------------------------------------------------------
; Update and draw logo
; ------------------------------------------------------------------------------

UpdateLogo:
	bsr.w	ClearMarsScreen					; Clear 32X screen

	movea.l	logo_state,a0					; Handle state
	jsr	(a0)

DrawLogo:
	bsr.s	DrawBackground					; Draw background

	movea.l	logo_draw,a0					; Draw logo
	jsr	(a0)

	bsr.w	UpdateMarsPaletteFade				; Update 32X palette fade
	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bra.w	UpdateCram					; Update CRAM

; ------------------------------------------------------------------------------
; Draw background
; ------------------------------------------------------------------------------

DrawBackground:
	clr.b	-(sp)						; Draw background piece 1
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite

	clr.b	-(sp)						; Draw background piece 2
	move.b	#1,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Draw GameTap logo
; ------------------------------------------------------------------------------

DrawGameTapLogo:
	move.b	#1,-(sp)					; Draw logo sprite
	move.b	logo_frame,-(sp)
	clr.b	-(sp)
	move.w	#160,-(sp)
	move.w	#96,-(sp)
	move.w	logo_scale,-(sp)
	move.w	logo_scale,-(sp)
	bsr.w	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Draw normal logo
; ------------------------------------------------------------------------------

DrawNormalLogo:
	move.b	#1,-(sp)					; Draw logo sprite
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	#160,-(sp)
	move.w	#88,-(sp)
	move.w	logo_scale,-(sp)
	move.w	logo_left_distort,-(sp)
	move.w	logo_right_distort,-(sp)
	move.w	logo_x_intensity,-(sp)
	move.w	logo_scale,-(sp)
	move.w	logo_top_distort,-(sp)
	move.w	logo_bottom_distort,-(sp)
	move.w	logo_y_intensity,-(sp)
	bsr.w	DrawDistortedLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; GameTap scale down state
; ------------------------------------------------------------------------------

GameTapScaleDownState:
	move.w	sample_command,MARS_COMM_10+MARS_SYS		; Play sample
	clr.w	sample_command

	move.w	gametap_scale,d0				; Get scale table index
	addq.w	#4,gametap_scale

	lea	GameTapLogoScaleDown,a0				; Set scale and rotation
	move.w	(a0,d0.w),logo_scale
	move.b	2(a0,d0.w),logo_frame

	cmpi.w	#GameTapLogoScaleDownLen,gametap_scale		; Are we done scaling?
	bcs.s	.End						; If not, branch

	move.l	#LogoTextShowState,logo_state			; Set text show state

.End:
	rts

; ------------------------------------------------------------------------------
; Logo scale up state
; ------------------------------------------------------------------------------

LogoScaleUpState:
	cmpi.w	#$E0,logo_scale					; Have we scaled up enough?
	bcc.s	.ScaleUp					; If not, branch

	move.l	#LogoScaleDownState,logo_state			; Set scale down state
	move.w	#$E0,logo_scale					; Stop scaling

	move.l	#$300,logo_left_distort				; Set up distortion
	move.w	#$60,logo_x_intensity
	move.l	#$3000000,logo_top_distort
	move.w	#$60,logo_y_intensity

.ScaleUp:
	subi.w  #$40,logo_scale					; Scale up
	rts

; ------------------------------------------------------------------------------
; Logo scale down state
; ------------------------------------------------------------------------------

LogoScaleDownState:
	cmpi.w	#$100,logo_scale				; Have we scaled down enough?
	bne.s	.ScaleDown					; If not, branch

	move.l	#LogoTextShowState,logo_state			; Set text show state
	bra.s	StopLogoScale					; Stop scaling

.ScaleDown:
	addq.w	#1,logo_scale					; Scale down
	
	addi.l  #$100004,logo_left_distort			; Distort
	addi.l  #$40010,logo_top_distort
	subq.w	#1,logo_x_intensity
	subq.w	#1,logo_y_intensity
	rts

; ------------------------------------------------------------------------------
; Stop scaling logo
; ------------------------------------------------------------------------------

StopLogoScale:
	move.w	#$100,logo_scale				; Stop scaling
	clr.b	logo_frame					; Stop animation
	
	clr.l	logo_left_distort				; Stop distorion
	clr.w	logo_x_intensity
	clr.l	logo_top_distort
	clr.w	logo_x_intensity

.End:
	rts

; ------------------------------------------------------------------------------
; Logo text show state
; ------------------------------------------------------------------------------

LogoTextShowState:
	addi.w	#$20,text_dither_offset				; Next dither pattern
	cmpi.w	#SplashTextDitherLen,text_dither_offset		; Are we done?
	bne.w	LoadTextArt					; If not, branch
	
	move.w	sample_command,MARS_COMM_10+MARS_SYS		; Play sample

	move.w	#$70,wait_timer					; Set text hide state
	move.l	#LogoTextHideState,logo_state
	rts

; ------------------------------------------------------------------------------
; Logo text hide state
; ------------------------------------------------------------------------------

LogoTextHideState:
	tst.w	text_dither_offset				; Is the text gone?
	bne.s	.CheckTimer					; If not, branch

	move.w	#$20,wait_timer					; Set exit state
	bra.s	.Exit

.CheckTimer:
	tst.w	wait_timer					; Is the wait timer active?
	beq.s	.UndoDither					; If not, branch
	subq.w	#1,wait_timer					; Decrement wait timer
	beq.s	.UndoDither					; If it has run out, branch
	rts

.UndoDither:
	subi.w	#$20,text_dither_offset				; Next dither pattern
	bne.s	LoadTextArt					; If not, branch

.Exit:
	move.l	#LogoExitState,logo_state			; Set exit state and clear text
	
	tst.w	gametap_scale
	beq.s	LoadTextArt

	move.l	#GameTapLogoExitState,logo_state
	clr.w	gametap_scale
	move.w	#$FF04,sample_command

; ------------------------------------------------------------------------------
; Load text art
; ------------------------------------------------------------------------------

LoadTextArt:
	lea	logo_text_art,a0				; Text art
	lea	logo_text_art_dither,a1

	lea	SplashTextDither,a2				; Get dither pattern
	move.w	text_dither_offset,d0
	adda.w	d0,a2

	move.w	text_art_length,d1				; Length of text art
	lsr.w	#5,d1
	subq.w	#1,d1

.Dither:
	.c: = 0
	rept 8							; Dither text
		move.l	(a0)+,d0
		and.l	.c(a2),d0
		move.l	d0,(a1)+
		.c: = .c+4
	endr
	dbf	d1,.Dither					; Loop until finished

	move.l	#logo_text_art_dither,d1			; Load text art into VRAM
	move.w	#$20,d2
	move.w	text_art_length,d3
	bra.w	QueueDma

; ------------------------------------------------------------------------------
; GameTap exit state
; ------------------------------------------------------------------------------

GameTapLogoExitState:
	tst.w	wait_timer					; Is the wait timer active?
	beq.s	.ScaleUp					; If not, branch
	subq.w	#1,wait_timer					; Decrement wait timer
	bne.s	.End						; If it hasn't run out, branch

.ScaleUp:
	move.w	sample_command,MARS_COMM_10+MARS_SYS		; Play sample
	clr.w	sample_command

	move.w	gametap_scale,d0				; Get scale table index
	addq.w	#4,gametap_scale

	lea	GameTapLogoScaleUp,a0				; Set scale and rotation
	move.w	(a0,d0.w),logo_scale
	move.b	2(a0,d0.w),logo_frame

	cmpi.w	#GameTapLogoScaleUpLen,gametap_scale		; Are we done scaling?
	bcs.s	.End						; If not, branch

	addq.w	#8,sp						; Don't return to caller
	
	bsr.w	WaitMars						; Wait for the 32X to not be busy
	bsr.w	DrawBackground
	bra.w	SendMarsGraphicsCmds

.End:
	rts

; ------------------------------------------------------------------------------
; Logo exit state
; ------------------------------------------------------------------------------

LogoExitState:
	tst.w	wait_timer					; Is the wait timer active?
	beq.s	.ScaleUp					; If not, branch
	subq.w	#1,wait_timer					; Decrement wait timer
	bne.s	.End						; If it hasn't run out, branch

.ScaleUp:
	subq.w  #8,logo_scale					; Scale down
	bgt.s	.End						; If we are not done scaling, branch
	
	addq.w	#8,sp						; Don't return to caller
	
	bsr.w	WaitMars						; Wait for the 32X to not be busy
	bsr.w	DrawBackground
	bra.w	SendMarsGraphicsCmds

.End:
	rts

; ------------------------------------------------------------------------------
; Logos
; ------------------------------------------------------------------------------

GameTapLogo:
	dc.l	Art_SplashGameTapText
	dc.l	Map_SplashGameTapText
	VDP_CMD dc.l,$C992,VRAM,WRITE
	dc.w	22, 4
	dc.l	MarsPal_SplashGameTap
	dc.l	MarsSpr_SplashGameTap
	dc.l	GameTapScaleDownState
	dc.l	DrawGameTapLogo
	dc.w	1
	dc.w	$FF04
	dc.b	1
	even

ClownancyLogo:
	dc.l	Art_SplashClownancyText
	dc.l	Map_SplashClownancyText
	VDP_CMD dc.l,$CA08,VRAM,WRITE
	dc.w	32, 6
	dc.l	MarsPal_SplashClownancy
	dc.l	MarsSpr_SplashClownancy
	dc.l	LogoScaleUpState
	dc.l	DrawNormalLogo
	dc.w	$1000
	dc.w	$FF00
	dc.b	0
	even

OllieLogo:
	dc.l	Art_SplashOllieText
	dc.l	Map_SplashOllieText
	VDP_CMD dc.l,$CA90,VRAM,WRITE
	dc.w	24, 4
	dc.l	MarsPal_SplashOllie
	dc.l	MarsSpr_SplashOllie
	dc.l	LogoScaleUpState
	dc.l	DrawNormalLogo
	dc.w	$1000
	dc.w	$FF06
	dc.b	0
	even
	
; ------------------------------------------------------------------------------
; Logo effects
; ------------------------------------------------------------------------------

	section m68k_rom_fixed_data

SplashTextDither:
	incbin	"source/splash/data/md/text_dither.bin"
SplashTextDitherEnd:
	even
	
GameTapLogoScaleDown:
	incbin	"source/splash/data/md/gametap_scale_down.bin"
GameTapLogoScaleDownEnd:
	even
	
GameTapLogoScaleUp:
	incbin	"source/splash/data/md/gametap_scale_up.bin"
GameTapLogoScaleUpEnd:
	even

; ------------------------------------------------------------------------------
