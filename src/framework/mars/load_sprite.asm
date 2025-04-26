; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sprite loading functions
; ------------------------------------------------------------------------------

	section sh2_code
	include	"src/framework/mars.inc"

; ------------------------------------------------------------------------------
; Load sprites
; ------------------------------------------------------------------------------
; PARAMETERS:
;	r1.l - Sprite data address
;	r2.l - Sprite data slot address
;	r3.b - CRAM index
; RETURNS:
;	r0.l - Length of sprite data
; ------------------------------------------------------------------------------

LoadSprites:
	mov.l	r7,@-r15					; Save registers
	mov.l	r6,@-r15
	mov.l	r5,@-r15
	mov.l	r4,@-r15
	mov.l	r2,@-r15
	mov.l	r1,@-r15
	sts.l	pr,@-r15

	mov.l	r1,r4						; Get sprite data
	mov.l	r1,r7
	mov.l	r2,r5						; Get sprite data slot

	mov.l	@r4+,r6						; Get number of sprites
	add	r6,r2						; Advance sprite data slot past sprite frame index
	add	r6,r2
	add	r6,r2
	add	r6,r2

.LoadFrames:
	mov.l	@r4+,r1						; Get sprite frame address
	mov.l	r2,@r5						; Store loaded sprite frame address
	
	cmp/pz  r1						; Is this a valid frame?
	bf/s	.NextFrame					; If not, branch
	xor	r0,r0						; Don't advance sprite data slot for invalid frames

	add	r7,r1						; Load sprite frame
	bsr     LoadSpriteFrame

.NextFrame:
	add	#4,r5						; Advance sprite frame index
	dt	r6						; Decrement number of frames
	bf/s	.LoadFrames					; If we aren't done, branch
	add	r0,r2						; Advance sprite data slot

	add	#3,r2						; Align sprite data slot
	mov.b	#$FFFFFFFC,r0
	and	r0,r2

	lds.l	@r15+,pr					; Restore registers
	mov.l	@r15+,r1
	mov.l	r2,r0
	mov.l	@r15+,r2
	mov.l	@r15+,r4
	mov.l	@r15+,r5
	mov.l	@r15+,r6
	mov.l	@r15+,r7
	rts
	sub	r2,r0						; Get length of sprite data

; ------------------------------------------------------------------------------
; Load sprite frame
; ------------------------------------------------------------------------------
; PARAMETERS:
;	r1.l - Sprite frame data address
;	r2.l - Sprite data slot address
;	r3.b - CRAM index
; RETURNS:
;	r0.l - Length of sprite frame data
; ------------------------------------------------------------------------------

LoadSpriteFrame:
	mov.b	@(2,r1),r0					; Is this sprite compressed?
	cmp/eq	#66,r0
	bf	LoadUncSpriteFrame				; If not, branch
	
	mov.l	r14,@-r15					; Save registers
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
	mov.l	r2,@-r15
	mov.l	r1,@-r15
	sts.l	pr,@-r15

	mov.w	@r1+,r0						; Get uncompressed size
	add	#1,r1
	extu.w  r0,r0
	mov.l	r0,@-r15

	mov.b	@r1+,r4						; Get left boundary
	mov.b	@r1+,r5						; Get bits per X value
	mov.b	@r1+,r6						; Get top boundary
	mov.b	@r1+,r7						; Get bits per Y value
	mov.b	@r1+,r8						; Get base pixel value
	mov.b	@r1+,r9						; Get bits per pixel value
	
	xor	r14,r14						; Reset bit counter
	
	mov.w	r4,@r2						; Store left boundary

	bsr     ReadSpriteBits					; Store right boundary
	mov.l	r5,r12
	add	r4,r0
	mov.w	r0,@(2,r2)
	add	#4,r2

	mov.l	r6,r0						; Store top boundary
	shll8	r0
	mov.w	r0,@r2

	bsr     ReadSpriteBits					; Store bottom boundary
	mov.l	r7,r12
	add	r6,r0
	shll8	r0
	mov.w	r0,@(2,r2)
	bra	.GetNextRow
	add	#4,r2

; --------------------------------------------------------------------------------

.GetRow:
	sub	r10,r0						; Get row width
	mov.l	r0,r10

	bsr     ReadSpriteBits					; Store Y position
	mov.l	r7,r12
	add	r6,r0
	shll8	r0
	mov.w	r0,@(2,r2)
	add	#4,r2

.GetPixels:
	bsr     ReadSpriteBits					; Get pixel value
	mov.l	r9,r12
	add	r8,r0
	tst	r0,r0						; Is it transparent?
	bt/s	.WritePixel					; If so, branch
	dt	r10						; Decrement pixels left in row
	add	r3,r0						; Add CRAM index

.WritePixel:
	mov.b	r0,@r2						; Store pixel value
	bf/s	.GetPixels					; Loop until finished
	add	#1,r2

.GetNextRow:
	bsr     ReadSpriteBits					; Store row left position
	mov.l	r5,r12
	add	r4,r0
	mov.b	r0,@r2
	mov.l	r0,r10

	bsr     ReadSpriteBits					; Get row right position
	mov.l	r5,r12
	add	r4,r0
	cmp/eq	r10,r0						; Are we done loading the sprite frame?
	bf/s	.GetRow						; If not, branch
	mov.b	r0,@(1,r2)					; Store row right position
	
	xor	r0,r0						; Store terminator
	mov.w	r0,@r2
	
	mov.l	@r15+,r0					; Restore registers
	lds.l	@r15+,pr
	mov.l	@r15+,r1
	mov.l	@r15+,r2
	mov.l	@r15+,r4
	mov.l	@r15+,r5
	mov.l	@r15+,r6
	mov.l	@r15+,r7
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14

; ------------------------------------------------------------------------------
; Load uncompressed sprite frame
; ------------------------------------------------------------------------------
; PARAMETERS:
;	r1.l - Sprite frame data address
;	r2.l - Sprite data slot address
;	r3.b - CRAM index
; RETURNS:
;	r0.l - Length of sprite frame data
; ------------------------------------------------------------------------------

LoadUncSpriteFrame:
	mov.l	r4,@-r15					; Save registers
	mov.l	r2,@-r15
	mov.l	r1,@-r15

	mov.b	#4,r4						; Number of header entries

.GetBounds:
	mov.w	@r1+,r0						; Store header entry
	dt	r4						; Decrement number of header entries left
	mov.w	r0,@r2
	bf/s	.GetBounds					; Loop until finished
	add	#2,r2
	bt	.GetNextRow					; Start loading sprite frame data

.GetRow:
	sub	r4,r0						; Get row width
	mov.w	@r1+,r4						; Get row Y position
	mov.w	r4,@r2
	add	#2,r2

.GetPixels:
	mov.b	@r1+,r4						; Get pixel value
	tst	r4,r4						; Is it transparent?
	bt/s	.WritePixel					; If so, branch
	dt	r0						; Decrement pixels left in row
	add	r3,r4						; Add CRAM index

.WritePixel:
	mov.b	r4,@r2						; Store pixel value
	bf/s	.GetPixels					; Loop until finished
	add	#1,r2

.GetNextRow:
	mov.b	@r1+,r4						; Get row left position
	mov.b	@r1+,r0						; Get row right position
	mov.b	r4,@r2						; Store row positions
	mov.b	r0,@(1,r2)
	cmp/eq	r4,r0						; Are we done loading the sprite frame?
	bf/s	.GetRow						; If not, branch
	add	#2,r2
	
	mov.l	r2,r0						; Get end of sprite frame data
	
	mov.l	@r15+,r1					; Restore registers
	mov.l	@r15+,r2
	mov.l	@r15+,r4
	rts
	sub	r2,r0						; Get length of sprite frame data

; ------------------------------------------------------------------------------
; Read compressed sprite bits
; ------------------------------------------------------------------------------
; PARAMETERS:
;	r12.l - Number of bits to read
;	r13.l - Read buffer
; RETURNS:
;	r0.l  - Read value
;	r13.l - Updated read buffer
; ------------------------------------------------------------------------------

ReadSpriteBits:
	xor	r0,r0						; Reset read value

	cmp/pl  r12						; Is the bit count valid?
	bf	.End						; If not, branch

.ReadLoop:
	tst	r14,r14						; Do we need to go to the next byte?
	bf	.GetReadLength					; If not, branch

	mov.b	@r1+,r13					; Read byte
	shll16  r13						; Shift it to top byte so we can use rotation
	shll8	r13
	mov.b	#8,r14						; Reset bit counter

.GetReadLength:
	cmp/hi  r14,r12						; Will we need to read another byte?
	bf/s	.GotReadLength					; If not, branch
	mov.l	r12,r11

	mov.l	r14,r11						; Get remaining bits in current byte

.GotReadLength:
	sub	r11,r12						; Decrement bits to read

.ReadBits:
	shll	r13						; Get bit
	rotcl   r0
	dt	r11						; Decrement bits left for current byte
	bf/s	.ReadBits					; Loop until byte is
	add	#-1,r14
	
	tst	r12,r12						; Do we still have more bits to read?
	bf	.ReadLoop					; If so, branch

.End:
	rts
	nop

; ------------------------------------------------------------------------------
