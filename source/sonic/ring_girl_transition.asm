; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ring Girl transition
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------

ROTOSCOPE_SPEED		equ 4					; Rotoscope animation speed

; ------------------------------------------------------------------------------

RingGirlTransition:
	moveq	#60,d0						; Delay for a bit
	bsr.w	Delay
	
	bsr.w	DisableAtGamesSound				; Disable AtGames sound mode
	bsr.w	WaitSoundCommand
	bsr.w	StopSound					; Stop sound

	moveq	#120,d0						; Delay for a bit
	bsr.w	Delay
	
	move	#$2700,sr					; Reset screen
	bsr.w	DisableDisplay
	bsr.w	ClearVdpMemory
	bsr.w	InitMarsGraphics

	pea	MarsSpr_RingGirlRotoscope			; Load Ring Girl rotoscope 32X sprites
	clr.b	-(sp)
	move.b	#1,-(sp)
	bsr.w	LoadMarsSprites
	clr.b	ring_girl_trns_frame
	
	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bsr.w	WaitMarsGraphicsData

	bsr.w	DrawRingGirlRotoscope				; Draw Ring Girl rotoscope
	bsr.w	WaitMars

	bsr.w	VSync						; Enable display
	moveq	#0,d0
	bsr.w	SetPaletteFadeIntensity
	bsr.w	EnableDisplay

.AnimateRotoscope:
	bsr.w	VSync						; VSync
	
	cmpi.b	#9*ROTOSCOPE_SPEED,ring_girl_trns_frame		; Should we play the scare sound?
	bne.s	.NoScareSound					; If not, branch
	move.w	#$FF12,MARS_COMM_10+MARS_SYS			; Play scare sound

.NoScareSound:
	addq.b	#1,ring_girl_trns_frame				; Next frame
	cmpi.b	#(13*ROTOSCOPE_SPEED)+2,ring_girl_trns_frame	; Are we done?
	bcc.s	.RotoscopeDone					; If so, branch

	bsr.w	DrawRingGirlRotoscope				; Draw Ring Girl rotoscope
	bra.s	.AnimateRotoscope				; Loop

.RotoscopeDone:
	move	#$2700,sr					; Reset screen
	bsr.w	DisableDisplay
	bsr.w	ClearVdpMemory
	bsr.w	InitMarsGraphics

	move.w	#45,d0						; Delay for a bit
	bsr.w	Delay

; ------------------------------------------------------------------------------

	pea	MarsPal_Global					; Load global 32X palette
	move.b	#2,-(sp)
	clr.b	-(sp)
	bsr.w	LoadMarsPalette

	pea	MarsSpr_OllieWakeUp				; Load Ollie wake up 32X sprites
	clr.b	-(sp)
	move.b	#2,-(sp)
	bsr.w	LoadMarsSprites
	clr.b	ring_girl_trns_frame
	
	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bsr.w	WaitMarsGraphicsData

	bsr.w	DrawOllieWakeUp					; Draw Ollie waking up
	bsr.w	WaitMars

	bsr.w	VSync						; Enable display
	moveq	#0,d0
	bsr.w	SetPaletteFadeIntensity
	bsr.w	EnableDisplay

	moveq	#45,d0						; Delay for a bit
	bsr.w	Delay

	addq.b	#1,ring_girl_trns_frame				; Open eyes a bit
	bsr.w	DrawOllieWakeUp	
	moveq	#4,d0
	bsr.w	Delay

	addq.b	#1,ring_girl_trns_frame				; Open eyes all the way
	bsr.w	DrawOllieWakeUp	
	moveq	#120,d0
	bsr.w	Delay

; ------------------------------------------------------------------------------

	clr.b	rpg_room_id					; Go to Ollie's room
	clr.b	rpg_warp_entry_id
	jmp	RpgStageScene

; ------------------------------------------------------------------------------
; Draw Ring Girl rotoscope screen
; ------------------------------------------------------------------------------

DrawRingGirlRotoscope:
	clr.w	-(sp)						; Load rotoscope 32X palette
	move.w	#$1F,-(sp)
	moveq	#0,d0
	move.b	ring_girl_trns_frame,d0
	addq.b	#1,d0
	divu.w	#ROTOSCOPE_SPEED,d0
	move.w	d0,-(sp)
	bsr.w	LoadMarsRotoscopePalette

	bsr.w	ClearMarsScreen					; Clear 32X screen

	clr.b	-(sp)						; Draw frame (left)
	moveq	#0,d0
	move.b	ring_girl_trns_frame,d0
	divu.w	#ROTOSCOPE_SPEED*8,d0
	add.b	d0,d0
	move.b	d0,-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#128,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

	clr.b	-(sp)						; Draw frame (right)
	moveq	#0,d0
	move.b	ring_girl_trns_frame,d0
	divu.w	#ROTOSCOPE_SPEED*8,d0
	add.b	d0,d0
	addq.b	#1,d0
	move.b	d0,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#128,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

	bsr.w	UpdateMarsPaletteFade				; Update 32X palette fade
	bra.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	
; ------------------------------------------------------------------------------
; Draw Ollie wake up screen
; ------------------------------------------------------------------------------

DrawOllieWakeUp:
	bsr.w	ClearMarsScreen					; Clear 32X screen

	clr.b	-(sp)						; Draw Ollie base (left)
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

	clr.b	-(sp)						; Draw Ollie base (right)
	clr.b	-(sp)
	move.b	#%01,-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

	clr.b	-(sp)						; Draw Ollie eye (left)
	move.b	ring_girl_trns_frame,d0
	addq.b	#1,d0
	move.b	d0,-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

	clr.b	-(sp)						; Draw Ollie eye (right)
	move.b	ring_girl_trns_frame,d0
	addq.b	#1,d0
	move.b	d0,-(sp)
	move.b	#%01,-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite

	bsr.w	UpdateMarsPaletteFade				; Update 32X palette fade
	bra.w	SendMarsGraphicsCmds				; Send 32X graphics commands

; ------------------------------------------------------------------------------
