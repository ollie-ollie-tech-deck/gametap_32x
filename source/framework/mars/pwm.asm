; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; PWM driver
; ------------------------------------------------------------------------------

	section sh2_s_cache
	include	"source/framework/mars.inc"

; ------------------------------------------------------------------------------
; PWM channel structure
; ------------------------------------------------------------------------------

	rsreset
pwm.addr		rs.l	1				; Address
pwm.length		rs.l	1				; Length
pwm.loop		rs.l	1				; Loop point
pwm.loop_length		rs.l	1				; Loop length
pwm.samples_left	rs.l	1				; Samples left
pwm.pan_left		rs.l	1				; Left panning
pwm.pan_right		rs.l	1				; Right panning
pwm.pitch		rs.l	1				; Pitch
pwm.sample_left		rs.l	1				; Left sample
pwm.sample_right	rs.l	1				; Right sample
pwm.pitch_counter	rs.l	1				; Pitch counter
pwm.struct_len		rs.b	0				; Size of structure

; ------------------------------------------------------------------------------
; Initial PWM channel data
; ------------------------------------------------------------------------------

PWM_CHANNEL macro
	dc.l	0						; Address
	dc.l	0						; Length
	dc.l	0						; Loop point
	dc.l	0						; Loop length
	dc.l	0						; Samples left
	dc.l	$10						; Left panning
	dc.l	$10						; Right panning
	dc.l	$800						; Pitch
	dc.l	0						; Left sample
	dc.l	0						; Right sample
	dc.l	0						; Pitch counter
	endm

;------------------------------------------------------------------------------
; Initialize driver
;------------------------------------------------------------------------------

InitPwmDriver:
	mov.l	#SYS_REGS+PWM_TIMER,r0				; Set interrupt interval and panning
	mov.w	#%0000001000000101,r1
	mov.w	r1,@r0
	
	mov.l	#SYS_REGS+PWM_CYCLE,r0				; Set PWM cycle
	if REFRESH_RATE=60
		mov.w	#1045,r1
	else
		mov.w	#1035,r1
	endif
	mov.w	r1,@r0

	mov.l	#SYS_REGS+PWM_LEFT,r1				; Fill PWM FIFO
	xor	r0,r0
	mov.w	r0,@r1
	mov.w	r0,@r1
	mov.w	r0,@r1
	mov.l	#SYS_REGS+PWM_RIGHT,r1
	mov.w	r0,@r1
	mov.w	r0,@r1
	mov.w	r0,@r1

	rts
	nop

	lits

;------------------------------------------------------------------------------
; Update driver
;------------------------------------------------------------------------------

UpdatePwmDriver:
	mov.l	r2,@-r15					; Save registers
	mov.l	r3,@-r15
	mov.l	r6,@-r15
	mov.l	r7,@-r15
	mov.l	r4,@-r15
	mov.l	r5,@-r15
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15

	xor	r4,r4						; Clear sample data
	xor	r5,r5
	xor	r6,r6
	xor	r7,r7

	mov.l	#SYS_REGS+COMM_8,r1				; Mix PWM1
	mov.l	#pwm_channel_1,r14
	bsr	MixPwmChannel
	nop

	mov.l	#SYS_REGS+COMM_10,r1				; Mix PWM2
	mov.l	#pwm_channel_2,r14
	bsr	MixPwmChannel
	nop

	mov.l	#SYS_REGS+COMM_12,r1				; Mix PWM3
	mov.l	#pwm_channel_3,r14
	bsr	MixPwmChannel
	nop

	mov.l	#SYS_REGS+COMM_14,r1				; Mix PWM4
	mov.l	#pwm_channel_4,r14
	bsr	MixPwmChannel
	nop

	mov.w	#$400,r1					; Convert sample data
	xor	r1,r4
	xor	r1,r5
	xor	r1,r6
	xor	r1,r7
	mov.w	#$7FF,r1
	and	r1,r4
	and	r1,r5
	and	r1,r6
	and	r1,r7
	mov.w	#$200,r1
	sub	r1,r4
	sub	r1,r5
	sub	r1,r6
	sub	r1,r7
	
	mov.l	#SYS_REGS+PWM_LEFT,r0				; Sample registers
	mov.l	#SYS_REGS+PWM_RIGHT,r1

	mov.w	r4,@r0						; Send first set of sample data
	mov.w	r5,@r1

.WaitPwmFifo:
	mov.w	@r0,r2						; Is the FIFO full?
	cmp/pz	r2
	bf	.WaitPwmFifo					; If not, branch

	mov.w	r6,@r0						; Send second set of sample data
	mov.w	r7,@r1
	
	lds.l	@r15+,macl					; Restore registers
	lds.l	@r15+,pr
	mov.l	@r15+,r14
	mov.l	@r15+,r5
	mov.l	@r15+,r4
	mov.l	@r15+,r7
	mov.l	@r15+,r6
	mov.l	@r15+,r3
	mov.l	@r15+,r2

PwmDriverDone:
	rts
	nop

	lits

;------------------------------------------------------------------------------
; Mix PWM channel
;------------------------------------------------------------------------------
; PARAMETERS:
;	r1.l  - Queued sample data
;	r4.l  - Left channel data 1
;	r5.l  - Right channel data 1
;	r6.l  - Left channel data 2
;	r7.l  - Right channel data 2
;	r14.l - Sample variables
; RETURNS:
;	r4.l  - Mixed left channel data 1
;	r5.l  - Mixed right channel data 1
;	r6.l  - Mixed left channel data 2
;	r7.l  - Mixed right channel data 2
;------------------------------------------------------------------------------

MixPwmChannel:
	mov.w	@r1,r2						; Has a sample been queued?
	swap.b	r2,r0
	extu.b	r0,r0
	tst	r0,r0
	bt	.NoReset					; If not, branch

	xor	r0,r0						; Clear queue
	mov.w	r0,@r1

	exts.b	r2,r0						; Get sample ID
	cmp/pz	r0						; Are we just changing the panning?
	bf	.SetPanning					; If so, branch

	mov.l	#MarsPwmIndex,r1				; Get sample metadata
	shll2	r0
	shll2	r0
	add	r0,r1

.GotSampleMetadata:
	mov.l	@r1+,r0						; Set sample address
	mov.l	r0,@(pwm.addr,r14)
	mov.l	r0,r3
	mov.l	@r1+,r0						; Set sample length
	mov.l	r0,@(pwm.length,r14)
	mov.l	r0,@(pwm.samples_left,r14)
	mov.l	@r1+,r0						; Set loop point
	mov.l	r0,@(pwm.loop,r14)
	sub	r3,r0						; Set loop length
	mov.l	@(pwm.length,r14),r3
	sub	r0,r3
	mov.l	r3,@(pwm.loop_length,r14)
	mov.l	@r1+,r0						; Set pitch
	mov.l	r0,@(pwm.pitch,r14)
	xor	r0,r0						; Reset pitch counter
	mov.l	r0,@(pwm.pitch_counter,r14)

.SetPanning:
	swap.b	r2,r0						; Set left panning
	shlr2	r0
	shlr	r0
	and	#$1E,r0
	add	#2,r0
	mov.l	r0,@(pwm.pan_left,r14)

	swap.b	r2,r0						; Set right panning
	shll	r0
	and	#$1E,r0
	add	#2,r0
	mov.l	r0,@(pwm.pan_right,r14)

; ------------------------------------------------------------------------------

.NoReset:
	mov.l	@(pwm.addr,r14),r1				; Get sample data address
	tst	r1,r1
	bt	.SilentSample					; If it's not set, branch

	mov.l	@(pwm.pitch_counter,r14),r0			; Increment pitch counter
	mov.l	@(pwm.pitch,r14),r3
	add	r3,r0
	mov.l	r0,@(pwm.pitch_counter,r14)

	mov.w	#$800,r2					; Is it time to fetch a sample?
	cmp/hs	r2,r0
	bt	.GetSample					; If so, branch

	mov.l	@(pwm.sample_left,r14),r0			; Reuse previous samples
	mov.l	@(pwm.sample_right,r14),r1
	add	r0,r4
	add	r0,r6
	add	r1,r5
	add	r1,r7
	
.SilentSample:
	rts
	nop

	lits

; ------------------------------------------------------------------------------

.GetSample:
	sub	r2,r0						; Reset pitch counter
	mov.l	r0,@(pwm.pitch_counter,r14)

	mov.l	@(pwm.samples_left,r14),r0			; Are we at the end of the sample?
	dt	r0
	bf	.ReadSample					; If not, branch

	mov.l	@(pwm.loop_length,r14),r0			; Get loop point
	mov.l	@(pwm.loop,r14),r1
	tst	r1,r1
	bf	.ReadSample					; If there's one set, branch

	xor	r1,r1						; Stop sample
	rts
	mov.l	r1,@(pwm.addr,r14)

.ReadSample:
	mov.b	@r1+,r3						; Read sample
	mov.l	r0,@(pwm.samples_left,r14)			; Reset samples left
	mov.l	r1,@(pwm.addr,r14)				; Reset sample data address

	mov.l	@(pwm.pitch_counter,r14),r0			; Should we fetch another sample?
	mov.w	#$800,r2
	cmp/hs	r2,r0
	bt	.GetSample					; If so, branch

	mov	#$FFFFFF80,r0					; Fix sample
	xor	r0,r3

	mov.l	@(pwm.pan_left,r14),r1				; Mix left channel
	muls	r1,r3
	mov.l	@(pwm.sample_left,r14),r1
	sts	macl,r0
	shar	r0
	shar	r0
	shar	r0
	shar	r0
	mov.l	r0,@(pwm.sample_left,r14)
	add	r0,r6
	add	r1,r0
	shar	r0
	add	r0,r4

	mov.l	@(pwm.pan_right,r14),r1				; Mix right channel
	muls	r1,r3
	mov.l	@(pwm.sample_right,r14),r1
	sts	macl,r0
	shar	r0
	shar	r0
	shar	r0
	shar	r0
	mov.l	r0,@(pwm.sample_right,r14)
	add	r0,r7
	add	r1,r0
	shar	r0
	rts
	add	r0,r5

	lits
	cnop 0,4

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

pwm_channel_1:
	PWM_CHANNEL						; PWM1
pwm_channel_2:
	PWM_CHANNEL						; PWM2
pwm_channel_3:
	PWM_CHANNEL						; PWM3
pwm_channel_4:
	PWM_CHANNEL						; PWM4
	
;------------------------------------------------------------------------------
