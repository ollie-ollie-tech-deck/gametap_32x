; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Error handler
; ------------------------------------------------------------------------------

	section sh2_code
	include	"source/framework/mars.inc"
	
; ------------------------------------------------------------------------------
; Bring up error handler
; ------------------------------------------------------------------------------
; PARAMETERS:
;	cpu  - 0 for Master, 1 for Slave
;	code - Error code
; ------------------------------------------------------------------------------

ERROR_START macro cpu, code
	stc.l	vbr,@-r15					; Save all registers
	stc.l	gbr,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	sts.l	mach,@-r15
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	mov.l	r7,@-r15
	mov.l	r6,@-r15
	mov.l	r5,@-r15
	mov.l	r4,@-r15
	mov.l	r3,@-r15
	mov.l	r2,@-r15
	mov.l	r1,@-r15
	mov.l	r0,@-r15

	mov.l	#SYS_REGS,r14					; System registers
	
	xor	r0,r0						; Reset interrupts
	mov.b	r0,@(INT_MASK,r14)
	mov.w	r0,@(VRES_CLEAR,r14)
	mov.w	r0,@(VBLANK_CLEAR,r14)
	mov.w	r0,@(HBLANK_CLEAR,r14)
	mov.w	r0,@(CMD_CLEAR,r14)
	mov.w	r0,@(PWM_CLEAR,r14)

	mov.l	#((\code)*4)|("ER"<<16),r0			; Set error code
	if (\cpu)=0
		mov.l	#SYS_REGS+COMM_0,r1
		mov.l	r0,@r1
		mov.l	#MasterError,r0
	else
		mov.l	#SYS_REGS+COMM_4,r1
		mov.l	r0,@r1
		mov.l	#SlaveError,r0
	endif
	
	jmp	@r0						; Jump to error handler
	nop
	lits
	
	endm

; ------------------------------------------------------------------------------
; Error handler
; ------------------------------------------------------------------------------
; PARAMETERS:
;	r1  - Communication register
;	cpu - 0 for Master, 1 for Slave
; ------------------------------------------------------------------------------

ERROR_HANDLER macro cpu
	if (\cpu)=0
		mov.l	r1,@-r15				; Save registers

		mov.l	#InitScreen,r0				; Clear screen
		jsr	@r0
		nop

.WaitPalAccess\@:
		mov.l	#VDP_REGS+VDP_STATUS,r0			; Do we have palette access?
		mov.b	@r0,r0
		tst	#BIT_PEN,r0
		bt	.WaitPalAccess\@			; If not, wait

		mov.w	#$8000,r0				; Set background color
		mov.l	#CRAM,r1
		mov.w	r0,@r1
		
		mov.l	@r15+,r1				; Restore registers
	endif

	mov.l	#"MDER",r2					; Mega Drive response code

.WaitMd\@:
	mov.l	@r1,r0						; Has the Mega Drive responded?
	cmp/eq	r0,r2
	bf	.WaitMd\@					; If not, wait
	
; ------------------------------------------------------------------------------

	mov	#22,r3						; Send register data to the Mega Drive

.SendInfo\@:
	mov.l	@r15+,r0					; Send debugging info to the Mega Drive
	mov.l	r0,@r1
	
.WaitMd2\@:
	mov.l	@r1,r0						; Has the Mega Drive responded?
	cmp/eq	r0,r2
	bf	.WaitMd2\@					; If not, wait

	dt	r3						; Decrement number of entries to send
	bf	.SendInfo\@					; If we're not done, loop
	
	mov.l	r15,@r1						; Send stack pointer to the Mega Drive

; ------------------------------------------------------------------------------

.Loop\@:
	bra	.Loop\@						; Loop here indefinitely
	nop

	lits
	endm

; ------------------------------------------------------------------------------
; Exceptions	
; ------------------------------------------------------------------------------

MasterIllegalInstr:
	ERROR_START 0,0
MasterIllegalSlot:
	ERROR_START 0,1
MasterCpuAddrError:
	ERROR_START 0,2
MasterDmaAddrError:
	ERROR_START 0,3
MasterUserBreak:
	ERROR_START 0,4

SlaveIllegalInstr:
	ERROR_START 1,0
SlaveIllegalSlot:
	ERROR_START 1,1
SlaveCpuAddrError:
	ERROR_START 1,2
SlaveDmaAddrError:
	ERROR_START 1,3
SlaveUserBreak:
	ERROR_START 1,4
	
Exception:
	bra	Exception
	nop
	
MasterError:
	ERROR_HANDLER 0

SlaveError:
	ERROR_HANDLER 1
	
; ------------------------------------------------------------------------------
