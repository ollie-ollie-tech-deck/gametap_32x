; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Scary Maze jumpscare
; ------------------------------------------------------------------------------
	
	section m68k_rom_fixed
	include	"src/rpg/shared.inc"

; ------------------------------------------------------------------------------

ScaryMazeJumpscare:
	move	#$2700,sr					; Disable interrupts
	move.w	#$C000,d0					; Clear VRAM tables
	move.l	#$4000,d1
	jsr	ClearVramRegion

	jsr	VSync						; VSync
	jsr	ClearMarsScreen					; Clear 32X screen
	
	move.b	#1,-(sp)					; Draw image (left)
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	
	move.b	#1,-(sp)					; Draw image (right)
	move.b	#1,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands

	move.w	#$FF25,MARS_COMM_10+MARS_SYS			; Play crash sound

	moveq	#120,d0						; Delay for a bit
	jsr	Delay

	move.w	#$FF00,MARS_COMM_10+MARS_SYS			; Stop crash sound
	
	jsr	VSync						; Cut to black
	jsr	ClearMarsScreen
	moveq	#-7,d0
	jsr	SetPaletteFadeIntensity
	jsr	DisableDisplay
	
	jmp	RpgStageScene					; Go to RPG stage

; ------------------------------------------------------------------------------
