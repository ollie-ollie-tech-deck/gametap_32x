; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Master CPU program
; ------------------------------------------------------------------------------

	section sh2_code
	include	"src/framework/mars.inc"

; ------------------------------------------------------------------------------

MasterInit:
	mov.w	#FRT,r1						; Free running timer
	
	xor	r0,r0						; Disable timer interrupt
	mov.b	r0,@(TIER,r1)
	mov.b	#%11100010,r0					; Select OCRA
	mov.b	r0,@(TOCR,r1)
	xor	r0,r0						; Set FRC comparison value
	mov.b	r0,@(OCRH,r1)
	mov.b	#1,r0
	mov.b	r0,@(OCRL,r1)
	xor	r0,r0						; Set internal clock
	mov.b	r0,@(TCR,r1)
	mov.b	#1,r0						; Clear FRC on compare match A
	mov.b	r0,@(TCSR,r1)
	xor	r0,r0						; Set FRC
	mov.b	r0,@(FRCL,r1)
	mov.b	r0,@(FRCH,r1)
	
	mov.b	#%11110010,r0					; Select OCRB
	mov.b	r0,@(TOCR,r1)
	xor	r0,r0						; Set FRC comparison value
	mov.b	r0,@(OCRH,r1)
	mov.b	#1,r0
	mov.b	r0,@(OCRL,r1)
	mov.b	#%11100010,r0					; Select OCRA
	mov.b	r0,@(TOCR,r1)

; ------------------------------------------------------------------------------

MasterReset:
	mov.l	#MasterVector,r0				; Reset VBR and SP
	mov.l	#MASTER_STACK,r15
	ldc	r0,vbr
	
	mov.l	#SYS_REGS,r14					; System registers

	xor	r0,r0						; Clear interrupts
	mov.b	r0,@(INT_MASK,r14)
	mov.w	r0,@(VRES_CLEAR,r14)
	mov.w	r0,@(VBLANK_CLEAR,r14)
	mov.w	r0,@(HBLANK_CLEAR,r14)
	mov.w	r0,@(CMD_CLEAR,r14)
	mov.w	r0,@(PWM_CLEAR,r14)
	
	mov.b	#DMA0,r1					; Stop DMA
	mov.l	r0,@(DMAOR-DMA0,r1)
	mov.l	@(CHCR0,r1),r0
	mov.l	@((DMA1+CHCR1)-DMA0,r1),r0
	mov.w	#%0100010011100000,r0
	mov.l	r0,@(CHCR0,r1)
	mov.l	r0,@((DMA1+CHCR1)-DMA0,r1)
	
	mov.w	#CCR,r1						; Purge cache and disable it
	mov.b	#%10000,r0
	mov.b	r0,@r1
	rept	8
		nop
	endr

	mov.w	#CCR,r1						; Enable cache, and set two-way mode
	mov.b	#%01001,r0
	mov.b	r0,@r1

	mov.b	#BIT_FM,r0					; Get VDP access
	mov.b	r0,@(ADAPTER,r14)
	
	mov.b	#$20,r0						; Enable interrupts
	ldc	r0,sr
	
; ------------------------------------------------------------------------------

	mov.l	#InitScreen,r1					; Initialize screen
	jsr	@r1
	nop
	
.WaitPalAccess:
	mov.l	#VDP_REGS+VDP_STATUS,r0				; Do we have palette access?
	mov.b	@r0,r0
	tst	#BIT_PEN,r0
	bt	.WaitPalAccess					; If not, wait

	mov.w	#$8000,r0					; Reset background color
	mov.l	#palette,r1
	mov.l	#cram_buffer,r2
	mov.l	#CRAM,r3
	mov.w	r0,@r1
	mov.w	r0,@r2
	mov.w	r0,@r3

	xor	r0,r0						; Clear palette
	mov.l	#palette,r1
	mov.l	#cram_buffer,r2
	mov.l	#CRAM,r3
	mov.w	#$FF,r4

.ClearPalette:
	add	#2,r1
	add	#2,r2
	add	#2,r3
	mov.w	r0,@r1
	mov.w	r0,@r2
	dt	r4
	bf/s	.ClearPalette
	mov.w	r0,@r3

	mov.l	#sprite_data_slot,r0				; Reset sprite data slot
	mov.l	#sprite_data,r1
	mov.l	r1,@r0

	mov.l	#loaded_sprites,r0				; Unload sprites
	mov.b	#-1,r1
	mov.w	#$100,r2

.UnloadSprites:
	mov.l	r1,@r0
	dt	r2
	bf/s	.UnloadSprites
	add	#4,r0

	mov.b	#DMAOR,r1					; Enable DMAs
	mov.b	#1,r0
	mov.l	r0,@r1

	mov.b	#BIT_VIRQ|BIT_CMDIRQ,r0				; Enable V-BLANK and CMD interrupts
	mov.b	r0,(INT_MASK,r14)

; ------------------------------------------------------------------------------

	mov.l	#"M_ST",r1					; Start flag

.WaitStart:
	mov.l	@(COMM_0,r14),r0				; Have we been given permission to start?
	cmp/eq	r0,r1
	bf	.WaitStart					; If not, wait

	xor	r0,r0						; Mark as running
	mov.l	r0,@(COMM_0,r14)

; ------------------------------------------------------------------------------

	mov.l	#GraphicsRenderer,r0				; Go to graphics renderer
	jmp	@r0
	nop
	
	lits

; ------------------------------------------------------------------------------
