; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Credits scene
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/credits/shared.inc"

; ------------------------------------------------------------------------------

CreditsScene:
	jsr	FadePaletteToBlack				; Fade to black
	jsr	DisableDisplay					; Disable display

	move	#$2700,sr					; Setup V-BLANK
	jsr	ClearVBlankRoutine
	
	jsr	InitScene					; Initialize scene

	moveq	#PLANE_SIZE_64_32,d0				; Set plane size to 64x32
	jsr	SetPlaneSize
	
	pea	MarsPal_Global					; Load global 32X palette
	move.b	#2,-(sp)
	clr.b	-(sp)
	jsr	LoadMarsPalette

	pea	MarsSpr_Credits					; Load credits 32X sprites
	clr.b	-(sp)
	move.b	#2,-(sp)
	jsr	LoadMarsSprites

	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMarsGraphicsData

	moveq	#0,d0						; Draw frame 1
	bsr.s	DrawFrame

	move.w	#8*60,d0					; Delay for a bit
	jsr	Delay

	moveq	#1,d0						; Draw frame 2
	bsr.s	DrawFrame

	move.w	#8*60,d0					; Delay for a bit
	jsr	Delay

	moveq	#2,d0						; Draw frame 3
	bsr.s	DrawFrame

	move.w	#8*60,d0					; Delay for a bit
	jsr	Delay

	moveq	#3,d0						; Draw frame 4
	bsr.s	DrawFrame

	move.w	#8*60,d0					; Delay for a bit
	jsr	Delay

	moveq	#4,d0						; Draw frame 5
	bsr.s	DrawFrame

	move.w	#8*60,d0					; Delay for a bit
	jsr	Delay

	moveq	#5,d0						; Draw frame 6
	bsr.s	DrawFrame

.WaitStart:
	jsr	VSync						; VSync
	tst.b	p1_ctrl_tap					; Was the start button pressed?
	bpl.s	.WaitStart					; If not, branch

	move.w	#$FF00,MARS_COMM_10+MARS_SYS			; Stop music
	jmp	Main						; Restart game

; ------------------------------------------------------------------------------
; Draw frame
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Frame ID
; ------------------------------------------------------------------------------

DrawFrame:
	add.w	d0,d0						; Save frame ID
	move.w	d0,-(sp)

	jsr	FadePaletteToBlack				; Fade to black
	jsr	DisableDisplay					; Disable display

	jsr	ClearMarsScreen					; Clear screen
	
	move.w	(sp),d0						; Draw background piece 1
	clr.b	-(sp)
	move.b	d0,-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

	move.w	(sp)+,d0					; Draw background piece 2
	addq.w	#1,d0
	clr.b	-(sp)
	move.b	d0,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	
	jsr	UpdateMarsPaletteFade				; Update 32X palette fade
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands

	jsr	UpdateCram					; Update CRAM
	
	jsr	EnableDisplay					; Enable display
	jmp	FadePaletteIn					; Fade palette in

; ------------------------------------------------------------------------------
