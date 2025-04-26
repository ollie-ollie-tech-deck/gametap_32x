; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Scene functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/framework/md.inc"

; ------------------------------------------------------------------------------
; Initialize scene
; ------------------------------------------------------------------------------

InitScene:
	bsr.w	ClearVram					; Clear VRAM
	bsr.w	ClearVsram					; Clear VSRAM
	bsr.w	ResetWindowPlanePos				; Reset window plane position
	bsr.w	InitMarsGraphics2				; Initialize 32X graphics
	bsr.w	InitSprites					; Initialize sprites
	bsr.w	ResetDmaQueue					; Reset DMA queue
	
	bsr.w	InitKosQueue					; Initialize Kosinski queue
	bsr.w	InitObjects					; Initialize objects

	moveq	#0,d0						; Reset camera
	move.l	d0,camera_fg_x
	move.l	d0,camera_fg_y
	move.l	d0,camera_fg_x_draw
	move.l	d0,camera_fg_y_draw
	move.l	d0,camera_bg_x
	move.l	d0,camera_bg_y
	move.l	d0,camera_bg_x_draw
	move.l	d0,camera_bg_y_draw
	move.w	d0,cam_focus_object

	lea	hscroll,a0					; Clear scroll buffers
	move.w	#($E0+$40)*4,d0
	bsr.w	ClearMemory

; ------------------------------------------------------------------------------
; Clear scene variables
; ------------------------------------------------------------------------------

ClearSceneVariables:
	lea	scene_variables,a0				; Clear scene variables
	move.w	#scene_variables_end-scene_variables,d0
	bra.w	ClearMemory

; ------------------------------------------------------------------------------
