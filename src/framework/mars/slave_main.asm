; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Slave CPU program
; ------------------------------------------------------------------------------
	
	section sh2_code
	include	"src/framework/mars.inc"
	
; ------------------------------------------------------------------------------

SlaveInit:
	mov.w	#FRT,r1						; Free running timer
	
	xor	r0,r0						; Disable timer interrupt
	mov.b	r0,@(TIER,r1)
	mov.b	#%11100010,r0					; Select OCRA and output 1 on compare match A
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

SlaveReset:
	mov.l	#SlaveVector,r0					; Reset VBR and SP
	mov.l	#SLAVE_STACK,r15
	ldc	r0,vbr

	mov.l	#SYS_REGS,r14					; System registers

	xor	r0,r0						; Reset interrupts
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
	
	mov.b	#$20,r0						; Enable interrupts
	ldc	r0,sr

; ------------------------------------------------------------------------------

	xor	r0,r0						; Reset communication registers for PWM driver
	mov.l	r0,@(COMM_8,r14)
	mov.l	r0,@(COMM_12,r14)

	mov.l	#SlaveCache,r1					; Cache program
	mov.l	#CACHE,r2					; Store in cache
	mov.w	#(SlaveCacheEnd-SlaveCache)/4,r3		; Length of cache program

.CopyCacheProgram:
	mov.l	@r1+,r0						; Copy to cache
	dt	r3
	mov.l	r0,@r2
	bf/s	.CopyCacheProgram
	add	#4,r2
	
	mov.l	#InitPwmDriver,r0				; Initialize PWM driver
	jsr	@r0
	nop
	
; ------------------------------------------------------------------------------

	mov.l	#"S_ST",r1					; Start flag

.WaitStart:
	mov.l	@(COMM_4,r14),r0				; Have we been given permission to start?
	cmp/eq	r0,r1
	bf	.WaitStart					; If not, wait

	xor	r0,r0						; Mark as running
	mov.l	r0,@(COMM_4,r14)
	
	mov.b	#BIT_PWMIRQ|BIT_CMDIRQ,r0			; Enable PWM and CMD interrupt
	mov.b	r0,(INT_MASK,r14)
	
; ------------------------------------------------------------------------------

.Loop:
	bra	.Loop						; Loop here
	nop
	
	lits

; ------------------------------------------------------------------------------
