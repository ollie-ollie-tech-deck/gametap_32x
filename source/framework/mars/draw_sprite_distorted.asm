; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Distorted sprite drawing function
; ------------------------------------------------------------------------------

	section sh2_code
	include	"source/framework/mars.inc"

; ------------------------------------------------------------------------------
; Draw distorted sprite
; ------------------------------------------------------------------------------

DrawDistortedSprite:
	mov.w	#$800,r0
	sub	r0,r15
	mov.l	r0,@-r15
	shlr	r0
	sub	r0,r15
	mov.l	r0,@-r15
	sts.l	pr,@-r15
	mov.l	r2,@-r15
	mov.l	r1,@-r15
	mov.w	@r4+,r6
	mov.w	@r4+,r8
	mov.l	r15,r2
	bsr	DrawDistortedSprite_GetParams
	add	#$16,r2
	mov.w	r9,@-r2
	mov.w	r8,@-r2
	mov.w	r7,@-r2
	mov.b	@r4+,r6
	add	#1,r4
	mov.b	@r4+,r8
	add	#1,r4
	add	#1,r8
	mov.w	#$61A,r2
	bsr	DrawDistortedSprite_GetParams
	add	r15,r2
	mov.w	r9,@-r2
	mov.w	r8,@-r2
	mov.w	r7,@-r2
	mov.l	r15,r2
	add	#$10,r2
	mov.l	r2,r11
	mov.w	#$200,r12
	add	r11,r12
	mov.w	@r2+,r7
	mov.w	@r2+,r8
	mov.w	@r2+,r9
	mov.l	#Sprite2dBounds,r0
	mov.w	@r0+,r13
	mov.w	@r0+,r14
	rotr	r3
	bt/s	DrawDistortedSprite_InitFlippedX
	mov.l	@r15+,r0
	
; ---------------------------------------------------------------------------

DrawDistortedSprite_InitNotFlippedX:
	add	r0,r7
	cmp/ge	r14,r7
	bt	loc_6002480
	add	r7,r9
	cmp/ge	r13,r9
	bf	loc_6002480

loc_600244C:
	mov.w	@r2+,r0
	mov.l	r7,r5
	add	r0,r7
	mov.l	r7,r0
	cmp/gt	r13,r5
	bt/s	loc_600245C
	cmp/gt	r13,r0
	mov.l	r13,r5

loc_600245C:
	bt/s	loc_6002462
	cmp/gt	r14,r0
	mov.l	r13,r0

loc_6002462:
	bt	loc_6002484
	sub	r5,r0
	mov.w	r5,@r11
	add	#2,r11
	mov.w	r0,@r12
	dt	r8
	bf/s	loc_600244C
	add	#2,r12
	bra	DrawDistortedSprite_InitY
	nop

loc_6002480:
	bra	DrawDistortedSprite_End
	add	#4,r15
	
loc_6002484:
	sub	r5,r14

loc_6002486:
	mov.w	r5,@r11
	add	#2,r11
	mov.w	r14,@r12
	add	#2,r12
	dt	r8
	bf/s	loc_6002486
	xor	r14,r14
	bra	DrawDistortedSprite_InitY
	nop

	lits
	
; ---------------------------------------------------------------------------

DrawDistortedSprite_InitFlippedX:
	add	#-1,r13
	add	#-1,r14
	neg	r7,r7
	add	r0,r7
	add	#-1,r7
	cmp/gt	r13,r7
	bf	loc_60024D8
	neg	r9,r9
	add	r7,r9
	cmp/gt	r14,r9
	bt	loc_60024D8

loc_60024AE:
	mov.w	@r2+,r0
	mov.l	r7,r5
	sub	r0,r7
	mov.l	r7,r0
	cmp/gt	r14,r5
	bf/s	loc_60024BE
	cmp/gt	r14,r0
	mov.l	r14,r5

loc_60024BE:
	bf/s	loc_60024C4
	cmp/gt	r13,r0
	mov.l	r14,r0

loc_60024C4:
	bf	loc_60024DC
	mov.w	r5,@r11
	add	#2,r11
	sub	r0,r5
	mov.w	r5,@r12
	dt	r8
	bf/s	loc_60024AE
	add	#2,r12
	bra	DrawDistortedSprite_InitY
	nop
	
loc_60024D8:
	bra	DrawDistortedSprite_End
	add	#4,r15
	
loc_60024DC:
	sub	r13,r0

loc_60024E0:
	mov.w	r5,@r11
	add	#2,r11
	mov.w	r0,@r12
	add	#2,r12
	dt	r8
	bf/s	loc_60024E0
	xor	r0,r0

; ---------------------------------------------------------------------------

DrawDistortedSprite_InitY:
	mov.b	#-6,r0
	mov.w	@(r0,r4),r0
	shll	r0
	sub	r0,r11
	sub	r0,r12
	mov.w	#$410,r13
	add	r15,r13
	mov.w	#$200,r2
	mov.l	r2,r14
	add	r13,r2
	add	r2,r14
	mov.w	@r2+,r7
	mov.w	@r2+,r8
	mov.w	@r2+,r5
	mov.l	#OVER_WRITE+$200,r1
	mov.l	#Sprite2dBounds+4,r0
	mov.l	@r0+,r9
	mov.l	@r0+,r10
	shlr8	r9
	shlr8	r10
	rotr	r3
	bt/s	DrawDistortedSprite_InitFlippedY
	mov.l	@r15+,r0

; ---------------------------------------------------------------------------

DrawDistortedSprite_InitNotFlippedY:
	add	r0,r7
	cmp/gt	r10,r7
	bt	DrawDistortedSprite_End
	add	r7,r5
	cmp/ge	r9,r5
	bf	DrawDistortedSprite_End

loc_6002528:
	mov.w	@r2+,r0
	mov.l	r7,r5
	add	r0,r7
	mov.l	r7,r0
	cmp/ge	r9,r5
	bt/s	loc_6002538
	cmp/ge	r9,r0
	mov.l	r9,r5

loc_6002538:
	bt/s	loc_600253E
	cmp/gt	r10,r0
	mov.l	r9,r0

loc_600253E:
	bt	loc_6002564
	sub	r5,r0
	mov.l	r0,@r14
	add	#4,r14
	shll8	r5
	shll	r5
	add	r1,r5
	mov.l	r5,@r13
	dt	r8
	bf/s	loc_6002528
	add	#4,r13
	bra	DrawDistortedSprite_InitDone
	nop
	
loc_6002564:
	sub	r5,r10
	shll8	r5
	shll	r5
	add	r1,r5
	add	#1,r10

loc_600256E:
	mov.l	r5,@r13
	add	#4,r13
	mov.l	r10,@r14
	add	#4,r14
	dt	r8
	bf/s	loc_600256E
	xor	r10,r10
	bra	DrawDistortedSprite_InitDone
	nop
	
	lits
	
; ---------------------------------------------------------------------------

DrawDistortedSprite_InitFlippedY:
	neg	r7,r7
	add	r0,r7
	cmp/ge	r9,r7
	bf	DrawDistortedSprite_End
	neg	r5,r5
	add	r7,r5
	cmp/gt	r10,r5
	bt	DrawDistortedSprite_End

loc_6002590:
	mov.w	@r2+,r0
	mov.l	r7,r5
	sub	r0,r7
	mov.l	r7,r0
	cmp/gt	r10,r5
	bf/s	loc_60025A0
	cmp/gt	r10,r0
	mov.l	r10,r5

loc_60025A0:
	bf/s	loc_60025A6
	cmp/ge	r9,r0
	mov.l	r10,r0

loc_60025A6:
	bf	loc_60025C0
	sub	r0,r5
	mov.l	r5,@r14
	add	#4,r14
	shll8	r0
	shll	r0
	add	r1,r0
	mov.l	r0,@r13
	dt	r8
	bf/s	loc_6002590
	add	#4,r13
	bra	DrawDistortedSprite_InitDone
	nop
	
loc_60025C0:
	sub	r9,r5
	shll8	r9
	shll	r9
	add	r1,r9

loc_60025C8:
	mov.l	r9,@r13
	add	#4,r13
	mov.l	r5,@r14
	add	#4,r14
	dt	r8
	bf/s	loc_60025C8
	xor	r5,r5

; ---------------------------------------------------------------------------

DrawDistortedSprite_InitDone:
	mov.b	#-2,r0
	mov.b	@(r0,r4),r0
	add	#1,r0
	shll2	r0
	sub	r0,r13
	sub	r0,r14
	bra	DrawScaledSprite_StartDraw
	lds.l	@r15+,pr
	
; ---------------------------------------------------------------------------

DrawDistortedSprite_End:
	lds.l	@r15+,pr
	mov.l	@r15+,r0
	add	r0,r15
	mov.l	@r15+,r0
	rts
	add	r0,r15
	
	lits
	
; ---------------------------------------------------------------------------

DrawDistortedSprite_GetParams:
	mov.l	#DIV,r14
	mov.w	@r5+,r0
	sub	r6,r8
	mov.l	r0,@(DVSR,r14)
	shll8	r6
	mov.l	r6,@(DVDNT,r14)
	mov.w	@r5+,r6
	mov.w	@r5+,r9
	mov.w	@r5+,r10
	shll8	r6
	shll8	r9
	sub	r6,r9
	swap.w	r8,r0
	rotl	r9
	rotr	r9
	subc	r0,r9
	add	r0,r9
	div0s	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	div1	r0,r9
	exts.w	r9,r9
	rotcl	r9
	addc	r0,r9
	sub	r0,r9
	add	#$7F,r6
	mov.l	#MarsSineTable+$80,r11
	xor	r12,r12
	mov.l	r8,r13
	mov.w	#$100,r1
	mov.l	@(DVDNT,r14),r7
	swap.b	r8,r0
	mov.l	r0,@(DVDNT,r14)

loc_600264E:
	swap.b	r6,r0
	extu.b	r0,r0
	shll	r0
	mov.w	@(r0,r11),r0
	add	r9,r6
	muls	r10,r0
	sts	macl,r0
	shlr8	r0
	exts.w	r0,r0
	add	r1,r0
	mov.w	r0,@r2
	add	#2,r2
	dt	r13
	bf/s	loc_600264E
	add	r0,r12
	mov.l	@(DVDNT,r14),r9
	mov.l	r9,r0
	mov.l	r12,@(DVSR,r14)
	shll16	r0
	mov.l	r0,@(DVDNT,r14)
	mov.b	#$7F,r11
	shll8	r11
	sub	r8,r2
	sub	r8,r2
	mov.l	r8,r13
	mov.l	@(DVDNT,r14),r10

loc_6002682:
	mov.w	@r2,r0
	muls	r10,r0
	mov.l	r11,r12
	shlr16	r12
	sts	macl,r0
	add	r0,r11
	mov.l	r11,r0
	shlr16	r0
	sub	r12,r0
	mov.w	r0,@r2
	dt	r13
	bf/s	loc_6002682
	add	#2,r2
	sub	r8,r2
	rts
	sub	r8,r2
	
	lits
	
; ------------------------------------------------------------------------------
