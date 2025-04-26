; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Shape drawing functions
; ------------------------------------------------------------------------------

	section sh2_code
	include	"src/framework/mars.inc"

; ------------------------------------------------------------------------------
; Draw a 3D shape
; ------------------------------------------------------------------------------

DrawShape3d:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	
	mov.w	@r1+,r12

	mov.w	@r1+,r13
	mov.w	r13,@-r15
	mov.w	@r1+,r13
	mov.w	r13,@-r15
	mov.l	@r15+,r13

	add	#-$18,r15
	bsr	sub_60042C4
	mov.l	r15,r2

	bsr	sub_6004382
	mov.l	r13,r1

	add	#$18,r15
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14

	lits

; ------------------------------------------------------------------------------

sub_60042C4:
	mov.b	@r1+,r3
	mov.b	@r1+,r5
	mov.b	@r1+,r7
	add	#1,r1

	mov.w	@r1+,r0
	mov.w	r0,@(6,r2)
	mov.w	@r1+,r0
	mov.w	r0,@($E,r2)
	mov.w	@r1+,r0
	mov.w	r0,@($16,r2)
	
	mov.l	r5,r9
	add	r3,r9
	mov.l	r5,r11
	sub	r3,r11
	extu.b	r3,r3
	extu.b	r5,r5
	extu.b	r7,r7
	extu.b	r9,r9
	extu.b	r11,r11
	shll	r3
	shll	r5
	shll	r7
	shll	r9
	shll	r11
	mov.l	#MarsSineTable,r0
	mov.w	@(r0,r3),r4
	mov.w	@(r0,r5),r6
	mov.w	@(r0,r7),r8
	mov.w	@(r0,r9),r10
	mov.w	@(r0,r11),r1
	mov.l	#MarsSineTable+$80,r0
	mov.w	@(r0,r3),r3
	mov.w	@(r0,r5),r5
	mov.w	@(r0,r7),r7
	mov.w	@(r0,r9),r9
	mov.w	@(r0,r11),r11
	mov.l	r10,r0
	add	r1,r0
	neg	r0,r0
	shar	r0
	mov.w	r0,@($10,r2)
	mov.l	r4,r0
	mov.w	r0,@($12,r2)
	mov.l	r9,r0
	add	r11,r0
	shar	r0
	mov.w	r0,@($14,r2)
	sub	r9,r11
	shar	r11
	sub	r1,r10
	shar	r10
	muls	r7,r5
	sts	macl,r0
	muls	r8,r11
	sts	macl,r1
	sub	r1,r0
	shlr8	r0
	mov.w	r0,@r2
	muls	r8,r3
	sts	macl,r0
	neg	r0,r0
	shlr8	r0
	mov.w	r0,@(2,r2)
	muls	r7,r6
	sts	macl,r0
	muls	r8,r10
	sts	macl,r1
	add	r1,r0
	shlr8	r0
	mov.w	r0,@(4,r2)
	muls	r8,r5
	sts	macl,r0
	muls	r7,r11
	sts	macl,r1
	add	r1,r0
	shlr8	r0
	mov.w	r0,@(8,r2)
	muls	r7,r3
	sts	macl,r0
	shlr8	r0
	mov.w	r0,@($A,r2)
	muls	r8,r6
	sts	macl,r0
	muls	r7,r10
	sts	macl,r1
	sub	r1,r0
	shlr8	r0
	rts
	mov.w	r0,@($C,r2)

	lits

; ------------------------------------------------------------------------------

sub_600437C:
	lds.l	@r15+,pr
	rts
	nop

; ------------------------------------------------------------------------------

sub_6004382:
	sts.l	pr,@-r15
	mov.w	@r1+,r9
	tst	r9,r9
	bt	sub_600437C
	add	#-$80,r15
	mov.l	r15,r8
	mov.w	r9,@r8
	add	#2,r8

loc_6004392:
	clrmac
	mac.w	@r1+,@r2+
	mac.w	@r1+,@r2+
	mac.w	@r1+,@r2+
	mov.w	@r2+,r3
	add	#-6,r1
	sts	macl,r0
	shlr8	r0
	add	r3,r0
	mov.w	r0,@r8
	clrmac
	mac.w	@r1+,@r2+
	mac.w	@r1+,@r2+
	mac.w	@r1+,@r2+
	mov.w	@r2+,r3
	add	#-6,r1
	sts	macl,r0
	shlr8	r0
	add	r3,r0
	mov.w	r0,@(2,r8)
	clrmac
	mac.w	@r1+,@r2+
	mac.w	@r1+,@r2+
	mac.w	@r1+,@r2+
	mov.w	@r2+,r3
	add	#-$18,r2
	sts	macl,r0
	shlr8	r0
	add	r3,r0
	mov.w	r0,@(4,r8)
	dt	r9
	bf/s	loc_6004392
	add	#6,r8
	mov.w	@(2,r15),r0
	mov.w	r0,@r8
	mov.w	@(4,r15),r0
	mov.w	r0,@(2,r8)
	mov.w	@(6,r15),r0
	mov.w	r0,@(4,r8)
	mov.l	r15,r8
	add	#-$80,r15
	mov.l	r15,r7
	mov.l	#Shape3dBounds,r0
	mov.w	@r0+,r10
	mov.w	@r0+,r11
	mov.w	@r8+,r9
	add	#4,r7
	mov.w	@r8+,r4
	mov.w	@r8+,r5
	mov.w	@r8+,r6
	mov.w	#DIV,r14
	cmp/ge	r10,r6
	bf	loc_6004474
	cmp/gt	r11,r6
	bt	loc_6004494

; ------------------------------------------------------------------------------

sub_6004400:
	mov.l	r4,r1
	mov.l	r5,r2
	mov.l	r6,r3
	mov.l	#$10000,r0
	shll16	r6
	rotl	r0
	rotr	r0
	subc	r6,r0
	add	r6,r0
	div0s	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	div1	r6,r0
	exts.w	r0,r0
	rotcl	r0
	addc	r6,r0
	sub	r6,r0
	muls	r0,r4
	sts	macl,r4
	muls	r0,r5
	shlr8	r4
	add	#$50,r4
	add	#$50,r4
	sts	macl,r0
	mov.w	r4,@r7
	shlr8	r0
	add	#$70,r0
	mov.w	r0,@(2,r7)
	add	#4,r7
	mov.w	@r8+,r4
	mov.w	@r8+,r5
	mov.w	@r8+,r6
	cmp/ge	r10,r6
	bf	loc_60044B8
	cmp/gt	r11,r6
	bt	loc_60044C8
	dt	r9
	bf	sub_6004400
	bra	loc_60044D0
	nop

	lits

; ------------------------------------------------------------------------------

loc_6004474:
	mov.l	r4,r1
	mov.w	@r8+,r4
	mov.l	r5,r2
	mov.w	@r8+,r5
	mov.l	r6,r3
	mov.w	@r8+,r6
	cmp/ge	r10,r6
	bf	loc_60044BC
	cmp/gt	r11,r6
	bt	loc_60044C4
	bsr	sub_60044F4
	sub	r6,r3
	dt	r9
	bf	sub_6004400
	bra	loc_60044D0
	nop

; ------------------------------------------------------------------------------

loc_6004494:
	mov.l	r4,r1
	mov.w	@r8+,r4
	mov.l	r5,r2
	mov.w	@r8+,r5
	mov.l	r6,r3
	mov.w	@r8+,r6
	cmp/ge	r10,r6
	bf	loc_60044B4
	cmp/gt	r11,r6
	bt	loc_60044CC
	bsr	sub_600456C
	sub	r6,r3
	dt	r9
	bf	sub_6004400
	bra	loc_60044D0
	nop

; ------------------------------------------------------------------------------

loc_60044B4:
	bsr	sub_600456C
	sub	r6,r3

loc_60044B8:
	bsr	sub_60044F4
	sub	r6,r3

loc_60044BC:
	dt	r9
	bf	loc_6004474
	bra	loc_60044D0
	nop

; ------------------------------------------------------------------------------

loc_60044C4:
	bsr	sub_60044F4
	sub	r6,r3

loc_60044C8:
	bsr	sub_600456C
	sub	r6,r3

loc_60044CC:
	dt	r9
	bf	loc_6004494

loc_60044D0:
	mov.l	r15,r1
	add	#4,r1
	mov.l	r7,r0
	sub	r1,r0
	shlr2	r0
	tst	r0,r0
	bt	loc_60044E8
	mov.b	r0,@-r1
	mov.b	r12,@-r1
	swap.b	r12,r12
	bsr	DrawShape
	mov.b	r12,@-r1

loc_60044E8:
	mov.b	#1,r0
	shll8	r0
	add	r0,r15
	lds.l	@r15+,pr
	rts
	nop

; ------------------------------------------------------------------------------

sub_60044F4:
	mov.l	r10,r0
	sub	r6,r0
	mov.l	r3,@(DVSR,r14)
	shll16	r0
	mov.l	r0,@(DVDNT,r14)
	sub	r4,r1
	sub	r5,r2
	mov.l	#$10000,r3
	mov.l	r10,r0
	shll16	r0
	rotl	r3
	rotr	r3
	subc	r0,r3
	add	r0,r3
	div0s	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	exts.w	r3,r3
	rotcl	r3
	addc	r0,r3
	sub	r0,r3
	mov.l	@(DVDNT,r14),r0
	dmuls.l	r0,r1
	sts	macl,r1
	shlr16	r1
	exts.w	r1,r1
	add	r4,r1
	dmuls.l	r0,r2
	sts	macl,r2
	shlr16	r2
	exts.w	r2,r2
	add	r5,r2
	muls	r3,r1
	sts	macl,r0
	muls	r3,r2
	shlr8	r0
	add	#$50,r0
	add	#$50,r0
	mov.w	r0,@r7
	sts	macl,r0
	shlr8	r0
	add	#$70,r0
	mov.w	r0,@(2,r7)
	add	#4,r7
	rts
	mov.l	r10,r3

; ------------------------------------------------------------------------------

sub_600456C:
	mov.l	r11,r0
	sub	r6,r0
	mov.l	r3,@(DVSR,r14)
	shll16	r0
	mov.l	r0,@(DVDNT,r14)
	sub	r4,r1
	sub	r5,r2
	mov.l	r11,r0
	mov.l	#$10000,r3
	shll16	r0
	rotl	r3
	rotr	r3
	subc	r0,r3
	add	r0,r3
	div0s	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	div1	r0,r3
	exts.w	r3,r3
	rotcl	r3
	addc	r0,r3
	sub	r0,r3
	mov.l	@(DVDNT,r14),r0
	dmuls.l	r0,r1
	sts	macl,r1
	shlr16	r1
	exts.w	r1,r1
	add	r4,r1
	dmuls.l	r0,r2
	sts	macl,r2
	shlr16	r2
	exts.w	r2,r2
	add	r5,r2
	muls	r3,r1
	sts	macl,r0
	muls	r3,r2
	shlr8	r0
	add	#$50,r0
	add	#$50,r0
	mov.w	r0,@r7
	sts	macl,r0
	shlr8	r0
	add	#$70,r0
	mov.w	r0,@(2,r7)
	add	#4,r7
	rts
	mov.l	r11,r3

	lits

; ------------------------------------------------------------------------------
; Draw a shape
; ------------------------------------------------------------------------------

DrawShape:
	mov.b	@r1+,r13
	mov.b	@r1+,r12
	mov.b	#$10,r0
	tst	r0,r12
	bt	loc_6004616
	add	#1,r1
	mov.w	@r1+,r2
	mov.w	@r1+,r3
	mov.w	@r1+,r4
	mov.w	@r1+,r5
	mov.w	@r1+,r6
	mov.w	@r1+,r7
	sub	r4,r2
	sub	r5,r7
	muls	r2,r7
	sub	r4,r6
	sub	r5,r3
	sts	macl,r2
	muls	r3,r6
	add	#-$D,r1
	sts	macl,r3
	cmp/gt	r2,r3
	bf	locret_6004624

loc_6004616:
	mov.b	#3,r2
	and	r12,r2
	shll	r2
	mova	off_6004628,r0
	mov.w	@(r0,r2),r0
	braf	r0
	nop

locret_6004624:
	rts
	nop
	
	cnop 0,4

; ------------------------------------------------------------------------------

off_6004628:
	dc.w	DrawShape_Corners-locret_6004624
	dc.w	DrawShape_Wireframe-locret_6004624
	dc.w	DrawShape_Solid-locret_6004624
	dc.w	DrawShape_Solid-locret_6004624

; ------------------------------------------------------------------------------
; Draw a solid shape
; ------------------------------------------------------------------------------

DrawShape_Solid:
	add	#-$80,r15
	mov.l	r15,r8
	add	#-$80,r15
	mov.l	r15,r9
	sts.l	pr,@-r15
	extu.b	r13,r13
	swap.b	r13,r0
	bsr	sub_6004858
	or	r0,r13
	mov.l	@r8+,r1
	tst	r1,r1
	bt	loc_6004736
	mov.l	r1,r7
	shll2	r7
	mov.l	r7,r9
	add	r8,r7
	mov.l	@r8+,r0
	mov.l	r8,r6
	mov.l	r0,@r7
	add	#4,r7
	exts.w	r0,r2
	exts.w	r0,r3

loc_600465C:
	mov.l	@r6+,r0
	mov.l	r0,@r7
	exts.w	r0,r0
	cmp/ge	r2,r0
	bt/s	loc_600466C
	cmp/gt	r3,r0
	mov.l	r0,r2
	mov.l	r6,r8

loc_600466C:
	bf/s	loc_6004672
	dt	r1
	mov.l	r0,r3

loc_6004672:
	bf/s	loc_600465C
	add	#4,r7
	cmp/eq	r2,r3
	bt	loc_6004736
	add	#-4,r8
	add	r8,r9
	mov.l	#VDP_REGS,r0
	mov.l	#ReciprocalTable,r14
	ldc	r0,gbr
	mov.l	#FRAME_BUFFER+$200,r12
	shll8	r2
	shll	r2
	add	r2,r12
	mov.w	#$200,r11
	mov.w	@r8+,r3
	mov.w	@r8+,r2
	mov.w	@(2,r8),r0
	mov.w	@r8,r4
	sub	r2,r0
	mov.l	r0,r2
	shll	r0
	mov.w	@(r0,r14),r0
	sub	r3,r4
	muls	r0,r4
	shll8	r3
	sts	macl,r4
	add	#$7F,r3
	shar	r4
	shar	r4
	shar	r4
	shar	r4
	shar	r4
	shar	r4

loc_60046B4:
	mov.w	@r9+,r6
	mov.w	@r9+,r5
	add	#-8,r9
	mov.w	@(2,r9),r0
	mov.w	@r9,r7
	sub	r5,r0
	mov.l	r0,r5
	shll	r0
	mov.w	@(r0,r14),r0
	sub	r6,r7
	muls	r0,r7
	shll8	r6
	sts	macl,r7
	add	#$7F,r6
	shar	r7
	shar	r7
	shar	r7
	shar	r7
	shar	r7
	cmp/gt	r2,r5
	bf/s	loc_600471E
	shar	r7

loc_60046E0:
	cmp/pl	r2
	bf	loc_60046F4
	sub	r2,r5

loc_60046E6:
	mov.l	r6,r10
	bsr	sub_6004750
	mov.l	r3,r1
	add	r7,r6
	dt	r2
	bf/s	loc_60046E6
	add	r4,r3

loc_60046F4:
	mov.w	@r8+,r3
	mov.w	@r8+,r2
	mov.w	@(2,r8),r0
	mov.w	@r8,r4
	sub	r2,r0
	mov.l	r0,r2
	shll	r0
	mov.w	@(r0,r14),r0
	sub	r3,r4
	muls	r0,r4
	shll8	r3
	sts	macl,r4
	add	#$7F,r3
	shar	r4
	shar	r4
	shar	r4
	shar	r4
	shar	r4
	cmp/gt	r2,r5
	bt/s	loc_60046E0
	shar	r4

loc_600471E:
	cmp/pl	r5
	bf	loc_6004732
	sub	r5,r2

loc_6004724:
	mov.l	r6,r10
	bsr	sub_6004750
	mov.l	r3,r1
	add	r7,r6
	dt	r5
	bf/s	loc_6004724
	add	r4,r3

loc_6004732:
	cmp/hi	r8,r9
	bt	loc_60046B4

loc_6004736:
	lds.l	@r15+,pr
	mov.b	#1,r0
	shll8	r0
	rts
	add	r0,r15

	lits

; ------------------------------------------------------------------------------

sub_6004750:
	shlr8	r10
	shlr8	r1
	sub	r10,r1
	cmp/pz	r1
	bt/s	loc_6004760
	add	r12,r10
	add	r1,r10
	neg	r1,r1

loc_6004760:
	add	r11,r12
	mov.b	#2,r0
	shlr	r10
	bt/s	loc_60047DC
	shlr	r1
	bf	loc_6004798
	cmp/ge	r0,r1
	bf	loc_6004784

loc_6004770:
	mov.b	@(FRAME_CTRL,gbr),r0
	tst	#BIT_FEN,r0
	bf	loc_6004770
	mov.l	r1,r0
	mov.w	r0,@(FILL_LENGTH,gbr)
	mov.l	r10,r0
	mov.w	r0,@(FILL_START,gbr)
	mov.l	r13,r0
	rts
	mov.w	r0,@(FILL_DATA,gbr)

; ------------------------------------------------------------------------------

loc_6004784:
	shll	r10

loc_6004786:
	mov.b	@(FRAME_CTRL,gbr),r0
	tst	#BIT_FEN,r0
	bf	loc_6004786
	tst	r1,r1
	bt/s	locret_6004794
	mov.l	r13,r0
	mov.w	r0,@(2,r10)

locret_6004794:
	rts
	mov.w	r0,@r10

; ------------------------------------------------------------------------------

loc_6004798:
	cmp/gt	r0,r1
	bf	loc_60047B8
	add	#-1,r1

loc_600479E:
	mov.b	@(FRAME_CTRL,gbr),r0
	tst	#BIT_FEN,r0
	bf	loc_600479E
	mov.l	r1,r0
	mov.w	r0,@(FILL_LENGTH,gbr)
	mov.l	r10,r0
	mov.w	r0,@(FILL_START,gbr)
	mov.l	r13,r0
	add	r10,r1
	shll	r1
	mov.b	r0,@(2,r1)
	rts
	mov.w	r0,@(FILL_DATA,gbr)

; ------------------------------------------------------------------------------

loc_60047B8:
	add	r1,r10
	cmp/pl	r1
	bt/s	loc_60047CA
	shll	r10

loc_60047C0:
	mov.b	@(FRAME_CTRL,gbr),r0
	tst	#BIT_FEN,r0
	bf	loc_60047C0
	rts
	mov.b	r13,@r10

; ------------------------------------------------------------------------------

loc_60047CA:
	mov.b	@(FRAME_CTRL,gbr),r0
	tst	#BIT_FEN,r0
	bf	loc_60047CA
	dt	r1
	bt/s	locret_60047D8
	mov.b	r13,@r10
	mov.w	r13,@-r10

locret_60047D8:
	rts
	mov.w	r13,@-r10

; ------------------------------------------------------------------------------

loc_60047DC:
	bt/s	loc_6004818
	add	#1,r10
	cmp/gt	r0,r1
	bf	loc_60047FE
	add	#-1,r1

loc_60047E6:
	mov.b	@(FRAME_CTRL,gbr),r0
	tst	#BIT_FEN,r0
	bf	loc_60047E6
	mov.l	r1,r0
	mov.w	r0,@(FILL_LENGTH,gbr)
	mov.l	r10,r0
	mov.w	r0,@(FILL_START,gbr)
	shll	r10
	mov.b	r13,@-r10
	mov.l	r13,r0
	rts
	mov.w	r0,@(FILL_DATA,gbr)

; ------------------------------------------------------------------------------

loc_60047FE:
	add	r1,r10

loc_6004800:
	mov.b	@(FRAME_CTRL,gbr),r0
	tst	#BIT_FEN,r0
	bf	loc_6004800
	tst	r1,r1
	bt/s	locret_6004814
	shll	r10
	dt	r1
	bt/s	locret_6004814
	mov.w	r13,@-r10
	mov.w	r13,@-r10

locret_6004814:
	rts
	mov.b	r13,@-r10

; ------------------------------------------------------------------------------

loc_6004818:
	cmp/gt	r0,r1
	bf	loc_600483C
	add	#-1,r1

loc_600481E:
	mov.b	@(FRAME_CTRL,gbr),r0
	tst	#BIT_FEN,r0
	bf	loc_600481E
	mov.l	r1,r0
	mov.w	r0,@(FILL_LENGTH,gbr)
	mov.l	r10,r0
	mov.w	r0,@(FILL_START,gbr)
	shll	r10
	mov.b	r13,@-r10
	mov.l	r13,r0
	shll	r1
	add	r10,r1
	mov.b	r0,@(3,r1)
	rts
	mov.w	r0,@(FILL_DATA,gbr)

; ------------------------------------------------------------------------------

loc_600483C:
	add	r1,r10
	shll	r10

loc_6004840:
	mov.b	@(FRAME_CTRL,gbr),r0
	tst	#BIT_FEN,r0
	bf	loc_6004840
	tst	r1,r1
	bt/s	locret_6004854
	mov.b	r13,@r10
	dt	r1
	bt/s	locret_6004854
	mov.w	r13,@-r10
	mov.w	r13,@-r10

locret_6004854:
	rts
	mov.b	r13,@-r10

; ------------------------------------------------------------------------------

sub_6004858:
	sts.l	pr,@-r15
	mov.l	r1,r2
	mov.b	@r2+,r3
	mov.w	@r2+,r4
	mov.w	@r2+,r5
	mov.l	r4,r6
	mov.l	r5,r7
	add	#-1,r3

loc_6004868:
	mov.w	@r2+,r0
	mov.w	@r2+,r10
	cmp/gt	r0,r4
	bf/s	loc_6004874
	cmp/ge	r0,r6
	mov.l	r0,r4

loc_6004874:
	bt/s	loc_600487A
	cmp/gt	r10,r5
	mov.l	r0,r6

loc_600487A:
	bf/s	loc_6004880
	cmp/ge	r10,r7
	mov.l	r10,r5

loc_6004880:
	bt/s	loc_6004886
	dt	r3
	mov.l	r10,r7

loc_6004886:
	bf	loc_6004868
	mov.l	#Shape2dBounds,r0
	mov.w	@r0+,r2
	mov.w	@r0+,r3
	cmp/ge	r2,r6
	bf	loc_60048EC
	cmp/gt	r3,r4
	bt	loc_60048EC
	mov.w	@r0+,r10
	mov.w	@r0+,r11
	cmp/ge	r10,r7
	bf	loc_60048EC
	cmp/gt	r11,r5
	bt	loc_60048EC
	cmp/ge	r2,r4
	bt/s	loc_60048AC
	cmp/gt	r3,r6
	mova	sub_60048F4,r0
	mov.l	r0,@-r15

loc_60048AC:
	bf/s	loc_60048B4
	cmp/ge	r10,r5
	mova	sub_6004968,r0
	mov.l	r0,@-r15

loc_60048B4:
	bt/s	loc_60048BC
	cmp/gt	r11,r7
	mova	loc_60049C4,r0
	mov.l	r0,@-r15

loc_60048BC:
	bf/s	loc_60048C4
	sts	pr,r11
	mova	loc_6004A24,r0
	mov.l	r0,@-r15

loc_60048C4:
	mov.b	@r1+,r2
	mov.l	r8,r7
	mov.l	r2,@r7
	add	#4,r7

loc_60048CC:
	mov.w	@r1+,r3
	mov.w	@r1+,r0
	mov.w	r3,@r7
	dt	r2
	mov.w	r0,@(2,r7)
	bf/s	loc_60048CC
	add	#4,r7
	mov.l	@(4,r8),r0
	lds.l	@r15+,pr
	mov.w	#DIV,r14
	rts
	mov.l	r0,@r7

	lits

; ------------------------------------------------------------------------------

loc_60048EC:
	lds.l	@r15+,pr
	xor	r0,r0
	rts
	mov.l	r0,@r8
	
	cnop 0,4
	
; ------------------------------------------------------------------------------

sub_60048F4:
	mov.l	r8,r6
	mov.l	@r6+,r4
	tst	r4,r4
	bt	loc_6004960
	mov.l	#Shape2dBounds,r5
	mov.l	r9,r7
	mov.w	@r5,r5
	add	#4,r7

loc_6004904:
	mov.w	@r6+,r1
	mov.w	@r6+,r2
	cmp/ge	r5,r1
	bf/s	loc_6004928
	mov.w	@r6,r3
	mov.w	r1,@r7
	add	#2,r7
	mov.w	r2,@r7
	cmp/ge	r5,r3
	bf/s	loc_600492C
	add	#2,r7
	dt	r4
	bf	loc_6004904
	bra	loc_600494E
	mov.l	@(4,r9),r0

	lits

; ------------------------------------------------------------------------------

loc_6004928:
	cmp/ge	r5,r3
	bf	loc_6004948

loc_600492C:
	mov.w	@(2,r6),r0
	sub	r3,r5
	sub	r0,r2
	muls	r5,r2
	sub	r3,r1
	mov.l	r1,@(DVSR,r14)
	sts	macl,r2
	mov.l	r2,@(DVDNT,r14)
	add	r3,r5
	mov.w	r5,@r7
	mov.l	@(DVDNT,r14),r2
	add	r2,r0
	mov.w	r0,@(2,r7)
	add	#4,r7

loc_6004948:
	dt	r4
	bf	loc_6004904
	mov.l	@(4,r9),r0

loc_600494E:
	mov.l	r0,@r7
	mov.l	r7,r0
	sub	r9,r0
	shlr2	r0
	add	#-1,r0
	mov.l	r0,@r9
	xor	r8,r9
	xor	r9,r8
	xor	r8,r9

loc_6004960:
	lds.l	@r15+,pr
	rts
	nop
	
	cnop 0,4

; ------------------------------------------------------------------------------

sub_6004968:
	mov.l	r8,r6
	mov.l	@r6+,r4
	tst	r4,r4
	bt	loc_6004960
	mov.l	#Shape2dBounds+2,r5
	mov.l	r9,r7
	mov.w	@r5,r5
	add	#4,r7

loc_6004978:
	mov.w	@r6+,r1
	mov.w	@r6+,r2
	cmp/gt	r5,r1
	bt/s	loc_600499C
	mov.w	@r6,r3
	mov.w	r1,@r7
	add	#2,r7
	mov.w	r2,@r7
	cmp/gt	r5,r3
	bt/s	loc_60049A0
	add	#2,r7
	dt	r4
	bf	loc_6004978
	bra	loc_600494E
	mov.l	@(4,r9),r0
	
	lits

; ------------------------------------------------------------------------------

loc_600499C:
	cmp/gt	r5,r3
	bt	loc_60049BC

loc_60049A0:
	mov.w	@(2,r6),r0
	sub	r3,r5
	sub	r0,r2
	muls	r5,r2
	sub	r3,r1
	mov.l	r1,@(DVSR,r14)
	sts	macl,r2
	mov.l	r2,@(DVDNT,r14)
	add	r3,r5
	mov.w	r5,@r7
	mov.l	@(DVDNT,r14),r2
	add	r2,r0
	mov.w	r0,@(2,r7)
	add	#4,r7

loc_60049BC:
	dt	r4
	bf	loc_6004978
	bra	loc_600494E
	mov.l	@(4,r9),r0
	
	cnop 0,4

; ------------------------------------------------------------------------------

loc_60049C4:
	mov.l	r8,r6
	mov.l	@r6+,r4
	tst	r4,r4
	bt	loc_6004960
	mov.l	#Shape2dBounds+4,r5
	mov.l	r9,r7
	mov.w	@r5,r5
	add	#4,r7

loc_60049D4:
	mov.w	@r6+,r1
	mov.w	@r6+,r2
	cmp/ge	r5,r2
	bf/s	loc_60049F8
	mov.w	@(2,r6),r0
	mov.w	r1,@r7
	add	#2,r7
	mov.w	r2,@r7
	cmp/ge	r5,r0
	bf/s	loc_60049FC
	add	#2,r7
	dt	r4
	bf	loc_60049D4
	bra	loc_600494E
	mov.l	@(4,r9),r0

	lits

; ------------------------------------------------------------------------------

loc_60049F8:
	cmp/ge	r5,r0
	bf	loc_6004A1A

loc_60049FC:
	mov.w	@r6,r3
	sub	r0,r5
	sub	r3,r1
	muls	r5,r1
	sub	r0,r2
	mov.l	r2,@(DVSR,r14)
	sts	macl,r1
	mov.l	r1,@(DVDNT,r14)
	add	r0,r5
	mov.l	r5,r0
	mov.w	r0,@(2,r7)
	mov.l	@(DVDNT,r14),r1
	add	r3,r1
	mov.w	r1,@r7
	add	#4,r7

loc_6004A1A:
	dt	r4
	bf	loc_60049D4
	bra	loc_600494E
	mov.l	@(4,r9),r0
	nop
	
	cnop 0,4

loc_6004A24:
	mov.l	r8,r6
	mov.l	@r6+,r4
	tst	r4,r4
	bt	loc_6004960
	mov.l	#Shape2dBounds+6,r5
	mov.l	r9,r7
	mov.w	@r5,r5
	add	#4,r7
	add	#1,r5

loc_6004A36:
	mov.w	@r6+,r1
	mov.w	@r6+,r2
	cmp/gt	r5,r2
	bt/s	loc_6004A58
	mov.w	@(2,r6),r0
	mov.w	r1,@r7
	add	#2,r7
	mov.w	r2,@r7
	cmp/gt	r5,r0
	bt/s	loc_6004A5C
	add	#2,r7
	dt	r4
	bf	loc_6004A36
	bra	loc_600494E
	mov.l	@(4,r9),r0

	lits

; ------------------------------------------------------------------------------

loc_6004A58:
	cmp/gt	r5,r0
	bt	loc_6004A7A

loc_6004A5C:
	mov.w	@r6,r3
	sub	r0,r5
	sub	r3,r1
	muls	r5,r1
	sub	r0,r2
	mov.l	r2,@(DVSR,r14)
	sts	macl,r1
	mov.l	r1,@(DVDNT,r14)
	add	r0,r5
	mov.l	r5,r0
	mov.w	r0,@(2,r7)
	mov.l	@(DVDNT,r14),r1
	add	r3,r1
	mov.w	r1,@r7
	add	#4,r7

loc_6004A7A:
	dt	r4
	bf	loc_6004A36
	bra	loc_600494E
	mov.l	@(4,r9),r0

; ------------------------------------------------------------------------------
; Draw a shape's corners
; ------------------------------------------------------------------------------

DrawShape_Corners:
	mov.l	#Shape2dBounds,r0
	mov.w	@r0+,r3
	mov.w	@r0+,r4
	mov.w	@r0+,r5
	mov.w	@r0+,r6
	mov.l	#FRAME_BUFFER+$200,r7
	mov.b	@r1+,r8

.PlotPoints:
	mov.w	@r1+,r0
	mov.w	@r1+,r2
	cmp/ge	r3,r0
	bf	.NextPoint
	cmp/gt	r4,r0
	bt	.NextPoint
	cmp/ge	r5,r2
	bf	.NextPoint
	cmp/gt	r6,r2
	bt	.NextPoint
	shll8	r2
	shll	r2
	add	r2,r0
	mov.b	r13,@(r0,r7)

.NextPoint:
	dt	r8
	bf	.PlotPoints
	rts
	nop

	lits

; ------------------------------------------------------------------------------
; Draw shape as a wireframe
; ------------------------------------------------------------------------------

DrawShape_Wireframe:
	sts.l	pr,@-r15
	mov.l	r1,r10
	mov.l	r13,r4
	mov.b	@r10+,r11
	mov.l	#DrawLine,r12
	mov.l	r11,r0
	shll2	r0
	add	r10,r0
	add	#-4,r0
	mov.w	@r0+,r2
	mov.w	@r0+,r3

loc_6004AD2:
	mov.l	#VDP_REGS+FRAME_CTRL,r0
	mov.b	@r0,r0
	tst	#BIT_FEN,r0
	bf	loc_6004AD2

loc_6004ADA:
	mov.w	@r10+,r0
	mov.w	@r10+,r1
	mov.l	r0,r6
	jsr	@r12
	mov.l	r1,r7
	mov.l	r6,r2
	dt	r11
	bf/s	loc_6004ADA
	mov.l	r7,r3
	lds.l	@r15+,pr
	rts
	nop

	lits
	
; ------------------------------------------------------------------------------

	cnop 0,4
Shape2dBounds:
	dc.w	0, 320-1					; 2D shape horizontal boundaries
	dc.w	0, 224-1					; 2D shape vertical boundaries

	cnop 0,4
Shape3dBounds:
	dc.w	4						; 3D shape near boundary
	dc.w	$4000						; 3D shape far boundary

; ------------------------------------------------------------------------------
; Sine table
; ------------------------------------------------------------------------------

	cnop 0,4
MarsSineTable:
	dc.w	 $000,  $006,  $00C,  $012,  $019,  $01F,  $025,  $02B
	dc.w	 $031,  $038,  $03E,  $044,  $04A,  $050,  $056,  $05C
	dc.w	 $061,  $067,  $06D,  $073,  $078,  $07E,  $083,  $088
	dc.w	 $08E,  $093,  $098,  $09D,  $0A2,  $0A7,  $0AB,  $0B0
	dc.w	 $0B5,  $0B9,  $0BD,  $0C1,  $0C5,  $0C9,  $0CD,  $0D1
	dc.w	 $0D4,  $0D8,  $0DB,  $0DE,  $0E1,  $0E4,  $0E7,  $0EA
	dc.w	 $0EC,  $0EE,  $0F1,  $0F3,  $0F4,  $0F6,  $0F8,  $0F9
	dc.w	 $0FB,  $0FC,  $0FD,  $0FE,  $0FE,  $0FF,  $0FF,  $0FF
	dc.w	 $100,  $0FF,  $0FF,  $0FF,  $0FE,  $0FE,  $0FD,  $0FC
	dc.w	 $0FB,  $0F9,  $0F8,  $0F6,  $0F4,  $0F3,  $0F1,  $0EE
	dc.w	 $0EC,  $0EA,  $0E7,  $0E4,  $0E1,  $0DE,  $0DB,  $0D8
	dc.w	 $0D4,  $0D1,  $0CD,  $0C9,  $0C5,  $0C1,  $0BD,  $0B9
	dc.w	 $0B5,  $0B0,  $0AB,  $0A7,  $0A2,  $09D,  $098,  $093
	dc.w	 $08E,  $088,  $083,  $07E,  $078,  $073,  $06D,  $067
	dc.w	 $061,  $05C,  $056,  $050,  $04A,  $044,  $03E,  $038
	dc.w	 $031,  $02B,  $025,  $01F,  $019,  $012,  $00C,  $006
	dc.w	-$000, -$006, -$00C, -$012, -$019, -$01F, -$025, -$02B
	dc.w	-$031, -$038, -$03E, -$044, -$04A, -$050, -$056, -$05C
	dc.w	-$061, -$067, -$06D, -$073, -$078, -$07E, -$083, -$088
	dc.w	-$08E, -$093, -$098, -$09D, -$0A2, -$0A7, -$0AB, -$0B0
	dc.w	-$0B5, -$0B9, -$0BD, -$0C1, -$0C5, -$0C9, -$0CD, -$0D1
	dc.w	-$0D4, -$0D8, -$0DB, -$0DE, -$0E1, -$0E4, -$0E7, -$0EA
	dc.w	-$0EC, -$0EE, -$0F1, -$0F3, -$0F4, -$0F6, -$0F8, -$0F9
	dc.w	-$0FB, -$0FC, -$0FD, -$0FE, -$0FE, -$0FF, -$0FF, -$0FF
	dc.w	-$100, -$0FF, -$0FF, -$0FF, -$0FE, -$0FE, -$0FD, -$0FC
	dc.w	-$0FB, -$0F9, -$0F8, -$0F6, -$0F4, -$0F3, -$0F1, -$0EE
	dc.w	-$0EC, -$0EA, -$0E7, -$0E4, -$0E1, -$0DE, -$0DB, -$0D8
	dc.w	-$0D4, -$0D1, -$0CD, -$0C9, -$0C5, -$0C1, -$0BD, -$0B9
	dc.w	-$0B5, -$0B0, -$0AB, -$0A7, -$0A2, -$09D, -$098, -$093
	dc.w	-$08E, -$088, -$083, -$07E, -$078, -$073, -$06D, -$067
	dc.w	-$061, -$05C, -$056, -$050, -$04A, -$044, -$03E, -$038
	dc.w	-$031, -$02B, -$025, -$01F, -$019, -$012, -$00C, -$006
	; Extra values for cosine
	dc.w	 $000,  $006,  $00C,  $012,  $019,  $01F,  $025,  $02B
	dc.w	 $031,  $038,  $03E,  $044,  $04A,  $050,  $056,  $05C
	dc.w	 $061,  $067,  $06D,  $073,  $078,  $07E,  $083,  $088
	dc.w	 $08E,  $093,  $098,  $09D,  $0A2,  $0A7,  $0AB,  $0B0
	dc.w	 $0B5,  $0B9,  $0BD,  $0C1,  $0C5,  $0C9,  $0CD,  $0D1
	dc.w	 $0D4,  $0D8,  $0DB,  $0DE,  $0E1,  $0E4,  $0E7,  $0EA
	dc.w	 $0EC,  $0EE,  $0F1,  $0F3,  $0F4,  $0F6,  $0F8,  $0F9
	dc.w	 $0FB,  $0FC,  $0FD,  $0FE,  $0FE,  $0FF,  $0FF,  $0FF

; ------------------------------------------------------------------------------
; Reciprocal table
; ------------------------------------------------------------------------------

	cnop 0,4
ReciprocalTable:
	dc.w	$7FFF, $4000, $2000, $1555, $1000, $0CCC, $0AAA, $0924
	dc.w	$0800, $071C, $0666, $05D1, $0555, $04EC, $0492, $0444
	dc.w	$0400, $03C3, $038E, $035E, $0333, $030C, $02E8, $02C8
	dc.w	$02AA, $028F, $0276, $025E, $0249, $0234, $0222, $0210
	dc.w	$0200, $01F0, $01E1, $01D4, $01C7, $01BA, $01AF, $01A4
	dc.w	$0199, $018F, $0186, $017D, $0174, $016C, $0164, $015C
	dc.w	$0155, $014E, $0147, $0141, $013B, $0135, $012F, $0129
	dc.w	$0124, $011F, $011A, $0115, $0111, $010C, $0108, $0104
	dc.w	$0100, $00FC, $00F8, $00F4, $00F0, $00ED, $00EA, $00E6
	dc.w	$00E3, $00E0, $00DD, $00DA, $00D7, $00D4, $00D2, $00CF
	dc.w	$00CC, $00CA, $00C7, $00C5, $00C3, $00C0, $00BE, $00BC
	dc.w	$00BA, $00B8, $00B6, $00B4, $00B2, $00B0, $00AE, $00AC
	dc.w	$00AA, $00A8, $00A7, $00A5, $00A3, $00A2, $00A0, $009F
	dc.w	$009D, $009C, $009A, $0099, $0097, $0096, $0094, $0093
	dc.w	$0092, $0090, $008F, $008E, $008D, $008C, $008A, $0089
	dc.w	$0088, $0087, $0086, $0085, $0084, $0083, $0082, $0081
	dc.w	$0080, $007F, $007E, $007D, $007C, $007B, $007A, $0079
	dc.w	$0078, $0077, $0076, $0075, $0075, $0074, $0073, $0072
	dc.w	$0071, $0070, $0070, $006F, $006E, $006D, $006D, $006C
	dc.w	$006B, $006B, $006A, $0069, $0069, $0068, $0067, $0067
	dc.w	$0066, $0065, $0065, $0064, $0063, $0063, $0062, $0062
	dc.w	$0061, $0060, $0060, $005F, $005F, $005E, $005E, $005D
	dc.w	$005D, $005C, $005C, $005B, $005B, $005A, $005A, $0059
	dc.w	$0059, $0058, $0058, $0057, $0057, $0056, $0056, $0055
	dc.w	$0055, $0054, $0054, $0054, $0053, $0053, $0052, $0052
	dc.w	$0051, $0051, $0051, $0050, $0050, $004F, $004F, $004F
	dc.w	$004E, $004E, $004E, $004D, $004D, $004C, $004C, $004C
	dc.w	$004B, $004B, $004B, $004A, $004A, $004A, $0049, $0049
	dc.w	$0049, $0048, $0048, $0048, $0047, $0047, $0047, $0046
	dc.w	$0046, $0046, $0046, $0045, $0045, $0045, $0044, $0044
	dc.w	$0044, $0043, $0043, $0043, $0043, $0042, $0042, $0042
	dc.w	$0042, $0041, $0041, $0041, $0041, $0040, $0040, $0040
	dc.w	$FFFF, $FFFF, $FFFF, $FFFF

; ------------------------------------------------------------------------------
