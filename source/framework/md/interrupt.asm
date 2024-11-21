; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Interrupt functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/framework/md.inc"
	
; ------------------------------------------------------------------------------
; V-BLANK interrupt
; ------------------------------------------------------------------------------

VBlankInt:
	move	#$2700,sr					; Disable interrupts
	
	move.l	sp,vblank_return				; Set return address
	movem.l	d0-a6,-(sp)					; Save registers

	addq.l	#1,frame_count					; Increment frame count
	
	bsr.w	CheckSh2Error					; Check for SH-2 errors

	bsr.w	Random						; Shuffle random number seed
	bsr.w	SetKosBookmark					; Set Kosinski decompression bookmark
	
	tst.b	vsync_flag					; Are we lagging?	
	beq.w	.End						; If so, branch
	clr.b	vsync_flag					; Clear VSync flag
	
	lea	VDP_CTRL,a5					; VDP control port
	lea	VDP_DATA-VDP_CTRL(a5),a6			; VDP data port

	VDP_CMD move.l,0,VSRAM,WRITE,(a5)			; Set vertical scroll data
	move.w	camera_fg_y_draw,(a6)
	move.w	camera_bg_y_draw,(a6)

	STOP_Z80						; Stop the Z80
	bsr.w	ReadControllers					; Read controller data
	
	DMA_68K cram_buffer,0,$80,CRAM,(a5)			; Load CRAM data
	DMA_68K sprites,$F800,$280,VRAM,(a5)			; Load sprite data
	DMA_68K hscroll,$FC00,$380,VRAM,(a5)			; Load horizontal scroll data
	
	jsr	FlushDmaQueue					; Flush DMA queue	
	START_Z80						; Start the Z80

	bsr.w	FlushMapBlocks					; Flush and draw map blocks

	move.l	vblank_routine,d0				; Get V-BLANK routine
	beq.s	.End						; If it's not set, branch
	
	movea.l	d0,a0						; Run V-BLANK routine
	jsr	(a0)

.End:
	movem.l	(sp)+,d0-a6					; Restore registers
	rte
	
; ------------------------------------------------------------------------------
; Clear V-BLANK routine address
; ------------------------------------------------------------------------------

ClearVBlankRoutine:
	clr.l	vblank_routine					; Clear V-BLANK routine address
	rts
	
; ------------------------------------------------------------------------------
; Set V-BLANK routine address
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - V-BLANK routine address
; ------------------------------------------------------------------------------

SetVBlankRoutine:
	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr
	move.l	a0,vblank_routine				; Set V-BLANK routine address
	move	(sp)+,sr					; Restore interrupt settings
	rts

; ------------------------------------------------------------------------------
; VSync
; ------------------------------------------------------------------------------

VSync:
	st	vsync_flag					; Set VSync flag

WaitVSync:
	if DEBUG<>0
		move.w	#$9100,VDP_CTRL				; Hide performance meter
	endif
	move	#$2000,sr					; Enable interrupts

.Wait:
	tst.b	vsync_flag					; Has the V-BLANK interrupt run?
	bne.s	.Wait						; If not, wait
	if DEBUG<>0
		move.w	#$9193,VDP_CTRL				; Show performance meter
	endif
	rts

; ------------------------------------------------------------------------------
; Delay for a number of frames
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Number of frames to delay
; ------------------------------------------------------------------------------

Delay:
	move	sr,-(sp)					; Disable interrupts
	subq.w	#1,d0						; Subtract 1 for loop
	bmi.s	.End						; If there is no delay time, branch

.Delay:
	bsr.w	VSync						; VSync
	dbf	d0,.Delay					; Loop until finished

.End:
	move	(sp)+,sr					; Restore interrupt settings
	rts

; ------------------------------------------------------------------------------
