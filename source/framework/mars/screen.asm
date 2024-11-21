; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Screen functions
; ------------------------------------------------------------------------------

	section sh2_code
	include	"source/framework/mars.inc"

; ------------------------------------------------------------------------------
; Initialize screen
; ------------------------------------------------------------------------------

InitScreen:
	mov.l	r8,@-r15					; Save registers
	mov.l	r1,@-r15
	mov.l	r0,@-r15
	sts.l	pr,@-r15

	mov.l	#VDP_REGS,r8					; VDP registers

	bsr	ClearFrameBuffer				; Clear frame buffer
	nop
	mov.l	#InitLineTable,r1				; Initialize line table
	jsr	@r1
	nop

	mov.w	@(VDP_STATUS,r8),r0				; Are we in V-BLANK?
	cmp/pz	r0
	bf	.ClearOther					; If so, branch

.WaitVBlankStart:
	mov.w	@(VDP_STATUS,r8),r0				; Are we in V-BLANK?
	cmp/pz	r0
	bt	.WaitVBlankStart				; If not, wait

.ClearOther:
	mov.b	@(FRAME_CTRL,r8),r0				; Swap and clear frame buffer
	xor	#1,r0
	bsr	ClearFrameBuffer
	mov.b	r0,@(FRAME_CTRL,r8)
	jsr	@r1						; Initialize line table
	nop
	
	mov.b	#BIT_PRI|1,r0					; Set to packed pixel mode and give 32X priority
	mov.b	r0,@(BITMAP_MODE,r8)
	xor	r0,r0						; Clear screen shift
	mov.b	r0,@(SCREEN_SHIFT,r8)
	
	lds.l	@r15+,pr					; Restore registers
	mov.l	@r15+,r0
	mov.l	@r15+,r1
	rts
	mov.l	@r15+,r8

	lits
	cnop 0,4

; ------------------------------------------------------------------------------
; Clear frame buffer
; ------------------------------------------------------------------------------

ClearFrameBuffer:
	mov.l	r8,@-r15					; Save registers
	mov.l	r3,@-r15
	mov.l	r2,@-r15
	mov.l	r1,@-r15
	mov.l	r0,@-r15

	mov.l	#VDP_REGS,r8					; VDP registers
	mov.w	#$100,r0					; Fill length (512 pixels per line)
	mov.l	r0,r1						; Fill start (after line table, which is 256 word entries)
	mov.l	r0,r2						; Fill increment (512 pixels per line)
	mov.l	r0,r3						; Number of lines (256)

	add	#-1,r0						; Set fill length and start
	bra	.WaitFill
	mov.w	r0,@(FILL_LENGTH,r8)

; --------------------------------------------------------------------------------

.ClearLoop:
	mov.l	r1,r0						; Set fill start
	mov.w	r0,@(FILL_START,r8)
	xor	r0,r0						; Fill with 0
	mov.w	r0,@(FILL_DATA,r8)
	add	r2,r1						; Next line

.WaitFill:
	mov.b	@(FRAME_CTRL,r8),r0				; Do we have frame buffer access?
	tst	#BIT_FEN,r0
	bf	.WaitFill					; If not, wait

	dt	r3						; Decrement number of lines left
	bf	.ClearLoop					; If there are still some left, loop

	mov.l	@r15+,r0					; Restore registers
	mov.l	@r15+,r1
	mov.l	@r15+,r2
	mov.l	@r15+,r3
	rts
	mov.l	@r15+,r8

	lits

; ------------------------------------------------------------------------------
; Initialize line table
; ------------------------------------------------------------------------------

InitLineTable:
	mov.l	r8,@-r15					; Save registers
	mov.l	r2,@-r15
	mov.l	r1,@-r15
	mov.l	r0,@-r15

	mov.l	#FRAME_BUFFER+$200,r8				; End of line table
	mov.l	#$100*(255+1),r0				; Last line offset
	mov.w	#$100,r1					; 512 pixels per line
	mov.l	r1,r2						; Number of line table entries (256)

.SetLineEntries:
	mov.w	r0,@-r8						; Set line offset
	sub	r1,r0						; Set next line offset
	dt	r2						; Decrement number of line table entries left
	bf	.SetLineEntries					; If there are still line table entries to set, loop

	mov.l	@r15+,r0					; Restore registers
	mov.l	@r15+,r1
	mov.l	@r15+,r2
	rts
	mov.l	@r15+,r8

	lits

; ------------------------------------------------------------------------------
; Clear screen
; ------------------------------------------------------------------------------

ClearScreen:
	mov.w	#$100,r1					; 512 pixels per line
	mov.l	r1,r2						; Fill increment (512 pixels per line)
	mov.w	#224,r3						; Number of lines (224)

	mov.l	#VDP_REGS,r8					; VDP registers

.WaitAccess:
	mov.b	@(FRAME_CTRL,r8),r0				; Do we have frame buffer access?
	tst	#BIT_FEN,r0
	bf	.WaitAccess					; If not, wait

	mov.w	#320/2,r0					; Set fill length (320 pixels)
	mov.w	r0,@(FILL_LENGTH,r8)

	mov.l	r8,r9						; Fill start register
	add	#FILL_START,r9
	mov.l	r8,r10						; Fill data registers
	add	#FILL_DATA,r10

	xor	r5,r5						; Fill data

.FillRow:
	mov.w	r1,@r9						; Set fill start
	mov.w	r5,@r10						; Set fill data

.WaitFill:
	mov.b	@(FRAME_CTRL,r8),r0				; Do we have frame buffer access?
	tst	#BIT_FEN,r0
	bf	.WaitFill					; If not, wait

	dt	r3						; Decrement number of lines left
	bf/s	.FillRow					; If there are still line to clear, branch
	add	r2,r1

	rts
	nop

	lits

; ------------------------------------------------------------------------------
