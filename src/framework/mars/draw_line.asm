; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Line drawing function
; ------------------------------------------------------------------------------

	section sh2_code
	include	"src/framework/mars.inc"

; ------------------------------------------------------------------------------

DrawLineEnd:
	rts
	nop

; ------------------------------------------------------------------------------
; Draw a line
; ------------------------------------------------------------------------------

DrawLine:
	mov.l	#LineBoundaries,r8
	cmp/ge	r0,r2
	bt	loc_6002E9A
	xor	r0,r2
	xor	r2,r0
	xor	r0,r2
	xor	r1,r3
	xor	r3,r1
	xor	r1,r3

loc_6002E9A:
	mov.w	@r8+,r5
	cmp/ge	r5,r2

loc_6002E9E:
	bf	DrawLineEnd
	cmp/ge	r5,r0
	bt	loc_6002EE4
	sub	r3,r1
	sub	r2,r5
	muls	r5,r1
	add	r2,r5
	sub	r2,r0
	sts	macl,r1
	shll16	r0
	rotl	r1
	rotr	r1
	subc	r0,r1
	add	r0,r1
	div0s	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	div1	r0,r1
	exts.w	r1,r1
	rotcl	r1
	addc	r3,r1
	mov.l	r5,r0

loc_6002EE4:
	mov.w	@r8+,r5
	cmp/gt	r5,r0
	bt	DrawLineEnd
	cmp/gt	r5,r2
	bf	loc_6002F2E
	sub	r1,r3
	sub	r0,r5
	muls	r5,r3
	add	r0,r5
	sub	r0,r2
	sts	macl,r3
	shll16	r2
	rotl	r3
	rotr	r3
	subc	r2,r3
	add	r2,r3
	div0s	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	div1	r2,r3
	exts.w	r3,r3
	rotcl	r3
	addc	r1,r3
	mov.l	r5,r2

loc_6002F2E:
	cmp/ge	r1,r3
	bt	loc_6002F3E
	xor	r0,r2
	xor	r2,r0
	xor	r0,r2
	xor	r1,r3
	xor	r3,r1
	xor	r1,r3

loc_6002F3E:
	mov.w	@r8+,r5
	cmp/ge	r5,r3
	bf	DrawLineEnd
	cmp/ge	r5,r1
	bt	loc_6002F88
	sub	r2,r0
	sub	r3,r5
	muls	r5,r0
	add	r3,r5
	sub	r3,r1
	sts	macl,r0
	shll16	r1
	rotl	r0
	rotr	r0
	subc	r1,r0
	add	r1,r0
	div0s	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	div1	r1,r0
	exts.w	r0,r0
	rotcl	r0
	addc	r2,r0
	mov.l	r5,r1

loc_6002F88:
	mov.w	@r8+,r5
	cmp/gt	r5,r1
	bt	loc_6002E9E
	cmp/gt	r5,r3
	bf	loc_6002FD2
	sub	r0,r2
	sub	r1,r5
	muls	r5,r2
	add	r1,r5
	sub	r1,r3
	sts	macl,r2
	shll16	r3
	rotl	r2
	rotr	r2
	subc	r3,r2
	add	r3,r2
	div0s	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	div1	r3,r2
	exts.w	r2,r2
	rotcl	r2
	addc	r0,r2
	mov.l	r5,r3

loc_6002FD2:
	cmp/hs	r0,r2
	bt	loc_6002FE2
	xor	r0,r2
	xor	r2,r0
	xor	r0,r2
	xor	r1,r3
	xor	r3,r1
	xor	r1,r3

loc_6002FE2:
	sub	r0,r2
	sub	r1,r3
	mov.w	#$200,r5
	cmp/pz	r3
	bt/s	loc_6002FF2
	shll8	r1
	neg	r3,r3
	neg	r5,r5

loc_6002FF2:
	shll	r1
	add	r1,r0
	mov.l	#FRAME_BUFFER+$200,r8
	cmp/hi	r2,r3
	bt/s	loc_6003034
	add	r0,r8
	mov.l	r2,r0
	mov.l	r2,r1
	shll	r2
	shll	r3
	add	#1,r5
	add	#1,r0

loc_600300A:
	sub	r3,r1
	cmp/pl	r1
	bf/s	loc_6003028
	mov.b	r4,@r8
	dt	r0
	bf/s	loc_600300A
	add	#1,r8
	rts
	nop

	lits

; ------------------------------------------------------------------------------

loc_6003028:
	add	r2,r1
	dt	r0
	bf/s	loc_600300A
	add	r5,r8
	rts
	nop

; ------------------------------------------------------------------------------

loc_6003034:
	mov.l	r3,r0
	mov.l	r3,r1
	shll	r2
	shll	r3
	add	#1,r0

loc_600303E:
	sub	r2,r1
	cmp/pl	r1
	bt/s	loc_600304A
	mov.b	r4,@r8
	add	r3,r1
	add	#1,r8

loc_600304A:
	dt	r0
	bf/s	loc_600303E
	add	r5,r8
	rts
	nop

; ------------------------------------------------------------------------------

	cnop 0,4
LineBoundaries:
	dc.w	0, 320-1
	dc.w	0, 224-1

; ------------------------------------------------------------------------------
