; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Unscaled sprite drawing function
; ------------------------------------------------------------------------------

	section sh2_code
	include	"src/framework/mars.inc"

; ------------------------------------------------------------------------------
; Draw unscaled sprite
; ------------------------------------------------------------------------------

DrawUnscaledSprite:
	mov.l	#OVER_WRITE+$200,r9
	shll8	r2
	mov.l	#Sprite2dBounds,r0
	add	r1,r9
	add	r2,r9
	add	r2,r9
	mov.w	@r0+,r10
	shll2	r3
	mov.w	@r0+,r11
	sub	r1,r10
	mov.l	@r0+,r12
	sub	r1,r11
	mov.l	@r0+,r13
	mova	DrawSpriteModes,r0
	mov.l	@(r0,r3),r8
	sub	r2,r12
	mov.w	@r4+,r0
	sub	r2,r13
	mov.w	@r4+,r3
	mov.w	@r4+,r5
	jmp	@r8
	mov.w	@r4+,r6

	lits

; ------------------------------------------------------------------------------

	cnop 0,4

DrawSpriteModes:
	dc.l	DrawSprite_NoFlip
	dc.l	DrawSprite_FlipX
	dc.l	DrawSprite_FlipY
	dc.l	DrawSprite_FlipXY

; ------------------------------------------------------------------------------
; Draw unscaled unflipped sprite
; ------------------------------------------------------------------------------

DrawSprite_NoFlip:
	cmp/ge	r11,r0
	bt	locret_60013F4
	cmp/gt	r10,r3
	bf	locret_60013F4
	cmp/gt	r13,r5
	bt	locret_60013F4
	cmp/ge	r12,r6
	bf	locret_60013F4
	cmp/ge	r10,r0
	bf	loc_6001444
	cmp/gt	r11,r3
	bt	loc_6001444
	cmp/ge	r12,r5
	bf	loc_6001444
	cmp/gt	r13,r6
	bt	loc_6001444
	
	rotr	r1
	bf	loc_600140A
	bra	loc_6001434
	add	#-1,r9

loc_6001444:
	rotr	r1
	bf	loc_6001484
	bra	loc_60014E0
	add	#-1,r9

locret_60013F4:
	rts
	nop

	lits

; ------------------------------------------------------------------------------

loc_60013F8:
	sub	r0,r1
	shll	r8
	add	r9,r8
	shlr	r1

loc_6001400:
	mov.w	@r4+,r2
	extu.w	r2,r2
	dt	r1
	mov.w	r2,@(r0,r8)
	bf/s	loc_6001400
	add	#2,r0

loc_600140A:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	cmp/eq	r0,r1
	bf/s	loc_60013F8
	mov.w	@r4+,r8
	rts
	nop

	lits
	
; ------------------------------------------------------------------------------

loc_6001418:
	sub	r0,r1
	shll	r8
	add	r9,r8
	shlr	r1

loc_6001420:
	mov.w	@r4+,r2
	extu.w	r2,r2
	dt	r1
	or	r2,r5
	shlr8	r5
	mov.w	r5,@(r0,r8)
	swap.w	r2,r5
	bf/s	loc_6001420
	add	#2,r0
	shlr8	r5
	mov.w	r5,@(r0,r8)

loc_6001434:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_6001418
	mov.w	@r4+,r8
	rts
	nop

	lits
	
; ------------------------------------------------------------------------------

loc_600144C:
	cmp/ge	r11,r0
	bt	loc_6001494
	cmp/gt	r10,r1
	bf	loc_6001494
	cmp/gt	r13,r8
	bt	loc_6001494
	cmp/ge	r12,r8
	bf	loc_6001494
	cmp/ge	r10,r0
	bt/s	loc_6001468
	shll	r8
	sub	r10,r0
	sub	r0,r4
	mov.l	r10,r0

loc_6001468:
	cmp/gt	r11,r1
	bf/s	loc_6001474
	add	r9,r8
	mov.l	r1,r5
	sub	r11,r5
	mov.l	r11,r1

loc_6001474:
	sub	r0,r1
	shlr	r1

loc_6001478:
	mov.w	@r4+,r2
	extu.w	r2,r2
	dt	r1
	mov.w	r2,@(r0,r8)
	bf/s	loc_6001478
	add	#2,r0
	add	r5,r4

loc_6001484:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_600144C
	mov.w	@r4+,r8
	rts
	nop

loc_6001494:
	sub	r0,r1
	bra	loc_6001484
	add	r1,r4

	lits

; ------------------------------------------------------------------------------

loc_600149C:
	cmp/ge	r11,r0
	bt	loc_60014F0
	cmp/gt	r10,r1
	bf	loc_60014F0
	cmp/gt	r13,r8
	bt	loc_60014F0
	cmp/ge	r12,r8
	bf	loc_60014F0
	cmp/ge	r10,r0
	bt/s	loc_60014C2
	shll	r8
	sub	r10,r0
	sub	r0,r4
	mov.l	r10,r0
	mov.b	@r4+,r5
	extu.b	r5,r5
	add	#1,r0
	cmp/eq	r0,r1
	bt	loc_6001518
	shll16	r5

loc_60014C2:
	cmp/gt	r11,r1
	bt/s	loc_60014F8
	add	r9,r8
	sub	r0,r1
	shlr	r1

loc_60014CC:
	mov.w	@r4+,r2
	extu.w	r2,r2
	dt	r1
	or	r2,r5
	shlr8	r5
	mov.w	r5,@(r0,r8)
	swap.w	r2,r5
	bf/s	loc_60014CC
	add	#2,r0
	shlr8	r5
	mov.w	r5,@(r0,r8)

loc_60014E0:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_600149C
	mov.w	@r4+,r8
	rts
	nop

loc_60014F0:
	sub	r0,r1
	bra	loc_60014E0
	add	r1,r4

loc_60014F8:
	mov.l	r1,r6
	sub	r11,r6
	add	#-1,r6
	sub	r6,r1
	sub	r0,r1
	shlr	r1

loc_6001504:
	mov.w	@r4+,r2
	extu.w	r2,r2
	dt	r1
	or	r2,r5
	shlr8	r5
	mov.w	r5,@(r0,r8)
	swap.w	r2,r5
	bf/s	loc_6001504
	add	#2,r0
	bra	loc_60014E0
	add	r6,r4

loc_6001518:
	shll8	r5
	add	r9,r8
	bra	loc_60014E0
	mov.w	r5,@(r0,r8)

	lits

; ------------------------------------------------------------------------------
; Draw unscaled X flipped sprite
; ------------------------------------------------------------------------------

DrawSprite_FlipX:
	neg	r10,r10
	cmp/ge	r10,r0
	bt	locret_600154C
	neg	r11,r11
	cmp/gt	r11,r3
	bf	locret_600154C
	cmp/gt	r13,r5
	bt	locret_600154C
	cmp/ge	r12,r6
	bf	locret_600154C
	cmp/ge	r11,r0
	bf	loc_60015A2
	cmp/gt	r10,r3
	bt	loc_60015A2
	cmp/ge	r12,r5
	bf	loc_60015A2
	cmp/gt	r13,r6
	bt	loc_60015A2
	
	rotr	r1
	bf	loc_6001566
	bra	loc_6001592
	add	#1,r9

loc_60015A2:
	rotr	r1
	bf	loc_60015E8
	bra	loc_6001644
	add	#1,r9

locret_600154C:
	rts
	nop
	
	lits

; ------------------------------------------------------------------------------

loc_6001552:
	shll	r8
	sub	r0,r8
	add	r9,r8
	sub	r0,r1
	shlr	r1

loc_600155C:
	mov.w	@r4+,r0
	extu.w	r0,r0
	dt	r1
	swap.b	r0,r0
	bf/s	loc_600155C
	mov.w	r0,@-r8

loc_6001566:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	cmp/eq	r0,r1
	bf/s	loc_6001552
	mov.w	@r4+,r8
	rts
	nop

	lits

; ------------------------------------------------------------------------------

loc_6001576:
	shll	r8
	sub	r0,r8
	add	r9,r8
	sub	r0,r1
	shlr	r1

loc_6001580:
	mov.w	@r4+,r2
	extu.w	r2,r2
	swap.b	r2,r2
	shll8	r2
	or	r2,r5
	mov.w	r5,@-r8
	dt	r1
	bf/s	loc_6001580
	swap.w	r2,r5
	mov.w	r5,@-r8

loc_6001592:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_6001576
	mov.w	@r4+,r8
	rts
	nop

	lits

; ------------------------------------------------------------------------------

loc_60015AE:
	cmp/ge	r10,r0
	bt	loc_60015F8
	cmp/gt	r11,r1
	bf	loc_60015F8
	cmp/gt	r13,r8
	bt	loc_60015F8
	cmp/ge	r12,r8
	bf	loc_60015F8
	shll	r8
	cmp/ge	r11,r0
	bt/s	loc_60015CC
	add	r9,r8
	sub	r11,r0
	sub	r0,r4
	mov.l	r11,r0

loc_60015CC:
	cmp/gt	r10,r1
	bf/s	loc_60015D8
	sub	r0,r8
	mov.l	r1,r5
	sub	r10,r5
	mov.l	r10,r1

loc_60015D8:
	sub	r0,r1
	shlr	r1

loc_60015DC:
	mov.w	@r4+,r0
	extu.w	r0,r0
	dt	r1
	swap.b	r0,r0
	bf/s	loc_60015DC
	mov.w	r0,@-r8
	add	r5,r4

loc_60015E8:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_60015AE
	mov.w	@r4+,r8
	rts
	nop

loc_60015F8:
	sub	r0,r1
	bra	loc_60015E8
	add	r1,r4

	lits

; ------------------------------------------------------------------------------

loc_6001602:
	cmp/ge	r10,r0
	bt	loc_6001654
	cmp/gt	r11,r1
	bf	loc_6001654
	cmp/gt	r13,r8
	bt	loc_6001654
	cmp/ge	r12,r8
	bf	loc_6001654
	shll	r8
	cmp/ge	r11,r0
	bt/s	loc_6001628
	add	r9,r8
	sub	r11,r0
	sub	r0,r4
	mov.l	r11,r0
	add	#1,r0
	cmp/eq	r0,r1
	bt/s	loc_600167C
	mov.b	@r4+,r5
	extu.b	r5,r5

loc_6001628:
	cmp/gt	r10,r1
	bt/s	loc_600165C
	sub	r0,r8
	sub	r0,r1
	shlr	r1

loc_6001632:
	mov.w	@r4+,r2
	extu.w	r2,r2
	swap.b	r2,r2
	shll8	r2
	or	r2,r5
	mov.w	r5,@-r8
	dt	r1
	bf/s	loc_6001632
	swap.w	r2,r5
	mov.w	r5,@-r8

loc_6001644:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_6001602
	mov.w	@r4+,r8
	rts
	nop

loc_6001654:
	sub	r0,r1
	bra	loc_6001644
	add	r1,r4

loc_600165C:
	mov.l	r1,r6
	sub	r10,r6
	add	#-1,r6
	sub	r6,r1
	sub	r0,r1
	shlr	r1

loc_6001668:
	mov.w	@r4+,r2
	extu.w	r2,r2
	swap.b	r2,r2
	shll8	r2
	or	r2,r5
	mov.w	r5,@-r8
	dt	r1
	bf/s	loc_6001668
	swap.w	r2,r5
	bra	loc_6001644
	add	r6,r4

loc_600167C:
	sub	r0,r8
	bra	loc_6001644
	mov.w	r5,@-r8

	lits

; ------------------------------------------------------------------------------
; Draw unscaled Y flipped sprite
; ------------------------------------------------------------------------------

DrawSprite_FlipY:
	cmp/ge	r11,r0
	bt	locret_60016B8
	cmp/gt	r10,r3
	bf	locret_60016B8
	neg	r12,r12
	cmp/ge	r12,r5
	bt	locret_60016B8
	mov.w	#DIV,r2
	neg	r13,r13
	add	r2,r13
	cmp/ge	r13,r6
	bf	locret_60016B8
	shll	r2
	add	r2,r9
	cmp/ge	r10,r0
	bf	loc_6001708
	cmp/gt	r11,r3
	bt	loc_6001708
	cmp/ge	r13,r5
	bf	loc_6001708
	cmp/ge	r12,r6
	bt	loc_6001708
	
	rotr	r1
	bf	loc_60016CE
	bra	loc_60016F8
	add	#-1,r9

loc_6001708:
	rotr	r1
	bf	loc_600174C
	bra	loc_60017AC
	add	#-1,r9

locret_60016B8:
	rts
	nop
	
	lits

; ------------------------------------------------------------------------------

loc_60016BC:
	sub	r0,r1
	shll	r8
	sub	r8,r0
	shlr	r1

loc_60016C4:
	mov.w	@r4+,r2
	extu.w	r2,r2
	dt	r1
	mov.w	r2,@(r0,r9)
	bf/s	loc_60016C4
	add	#2,r0

loc_60016CE:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	cmp/eq	r0,r1
	bf/s	loc_60016BC
	mov.w	@r4+,r8
	rts
	nop
	
	lits

; ------------------------------------------------------------------------------

loc_60016DC:
	sub	r0,r1
	shll	r8
	sub	r8,r0
	shlr	r1

loc_60016E4:
	mov.w	@r4+,r2
	extu.w	r2,r2
	dt	r1
	or	r2,r5
	shlr8	r5
	mov.w	r5,@(r0,r9)
	swap.w	r2,r5
	bf/s	loc_60016E4
	add	#2,r0
	shlr8	r5
	mov.w	r5,@(r0,r9)

loc_60016F8:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_60016DC
	mov.w	@r4+,r8
	rts
	nop

	lits

; ------------------------------------------------------------------------------

loc_6001712:
	cmp/ge	r11,r0
	bt	loc_600175C
	cmp/gt	r10,r1
	bf	loc_600175C
	cmp/ge	r12,r8
	bt	loc_600175C
	cmp/ge	r13,r8
	bf	loc_600175C
	cmp/ge	r10,r0
	bt/s	loc_600172E
	shll	r8
	sub	r10,r0
	sub	r0,r4
	mov.l	r10,r0

loc_600172E:
	cmp/gt	r11,r1
	bf/s	loc_600173A
	sub	r9,r8
	mov.l	r1,r5
	sub	r11,r5
	mov.l	r11,r1

loc_600173A:
	sub	r0,r1
	sub	r8,r0
	shlr	r1

loc_6001740:
	mov.w	@r4+,r8
	extu.w	r8,r8
	dt	r1
	mov.w	r8,@r0
	bf/s	loc_6001740
	add	#2,r0
	add	r5,r4

loc_600174C:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_6001712
	mov.w	@r4+,r8
	rts
	nop

loc_600175C:
	sub	r0,r1
	bra	loc_600174C
	add	r1,r4

	lits

; ------------------------------------------------------------------------------

loc_6001766:
	cmp/ge	r11,r0
	bt	loc_60017BC
	cmp/gt	r10,r1
	bf	loc_60017BC
	cmp/ge	r12,r8
	bt	loc_60017BC
	cmp/ge	r13,r8
	bf	loc_60017BC
	shll	r8
	cmp/ge	r10,r0
	bt/s	loc_600178E
	sub	r9,r8
	sub	r10,r0
	sub	r0,r4
	mov.l	r10,r0
	add	#1,r0
	mov.b	@r4+,r5
	extu.b	r5,r5
	cmp/eq	r0,r1
	bt	loc_60017E8
	shll16	r5

loc_600178E:
	cmp/gt	r11,r1
	bt	loc_60017C6
	sub	r0,r1
	sub	r8,r0
	shlr	r1

loc_6001798:
	mov.w	@r4+,r2
	extu.w	r2,r2
	dt	r1
	or	r2,r5
	shlr8	r5
	mov.w	r5,@r0
	swap.w	r2,r5
	bf/s	loc_6001798
	add	#2,r0
	shlr8	r5
	mov.w	r5,@r0

loc_60017AC:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_6001766
	mov.w	@r4+,r8
	rts
	nop
	
loc_60017BC:
	sub	r0,r1
	bra	loc_60017AC
	add	r1,r4

loc_60017C6:
	mov.l	r1,r6
	sub	r11,r6
	add	#-1,r6
	sub	r6,r1
	sub	r0,r1
	sub	r8,r0
	shlr	r1

loc_60017D4:
	mov.w	@r4+,r2
	extu.w	r2,r2
	dt	r1
	or	r2,r5
	shlr8	r5
	mov.w	r5,@r0
	swap.w	r2,r5
	bf/s	loc_60017D4
	add	#2,r0
	bra	loc_60017AC
	add	r6,r4

loc_60017E8:
	sub	r8,r0
	shll8	r5
	bra	loc_60017AC
	mov.w	r5,@r0

	lits

; ------------------------------------------------------------------------------
; Draw unscaled X/Y flipped sprite
; ------------------------------------------------------------------------------

DrawSprite_FlipXY:
	neg	r10,r10
	cmp/ge	r10,r0
	bt	locret_600182A
	neg	r11,r11
	cmp/gt	r11,r3
	bf	locret_600182A
	neg	r12,r12
	cmp/ge	r12,r5
	bt	locret_600182A
	mov.w	#-$100,r2
	neg	r13,r13
	add	r2,r13
	cmp/ge	r13,r6
	bf	locret_600182A
	shll	r2
	add	r2,r9
	cmp/ge	r11,r0
	bf	loc_6001882
	cmp/gt	r10,r3
	bt	loc_6001882
	cmp/ge	r13,r5
	bf	loc_6001882
	cmp/ge	r12,r6
	bt	loc_6001882
	
	rotr	r1
	bf	loc_6001846
	bra	loc_6001872
	add	#1,r9

loc_6001882:
	rotr	r1
	bf	loc_60018C8
	bra	loc_6001926
	add	#1,r9

locret_600182A:
	rts
	nop

	lits

; ------------------------------------------------------------------------------

loc_6001830:
	shll	r8
	add	r0,r8
	neg	r8,r8
	add	r9,r8
	sub	r0,r1
	shlr	r1

loc_600183C:
	mov.w	@r4+,r0
	extu.w	r0,r0
	dt	r1
	swap.b	r0,r0
	bf/s	loc_600183C
	mov.w	r0,@-r8

loc_6001846:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	cmp/eq	r0,r1
	bf/s	loc_6001830
	mov.w	@r4+,r8
	rts
	nop

	lits

; ------------------------------------------------------------------------------

loc_6001854:
	shll	r8
	add	r0,r8
	neg	r8,r8
	add	r9,r8
	sub	r0,r1
	shlr	r1

loc_6001860:
	mov.w	@r4+,r2
	extu.w	r2,r2
	swap.b	r2,r2
	shll8	r2
	or	r2,r5
	mov.w	r5,@-r8
	dt	r1
	bf/s	loc_6001860
	swap.w	r2,r5
	mov.w	r5,@-r8

loc_6001872:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_6001854
	mov.w	@r4+,r8
	rts
	nop

	lits

; ------------------------------------------------------------------------------

loc_600188C:
	cmp/ge	r10,r0
	bt	loc_60018D8
	cmp/gt	r11,r1
	bf	loc_60018D8
	cmp/ge	r12,r8
	bt	loc_60018D8
	cmp/ge	r13,r8
	bf	loc_60018D8
	shll	r8
	cmp/ge	r11,r0
	bt/s	loc_60018AA
	sub	r9,r8
	sub	r11,r0
	sub	r0,r4
	mov.l	r11,r0

loc_60018AA:
	cmp/gt	r10,r1
	bf/s	loc_60018B6
	add	r0,r8
	mov.l	r1,r5
	sub	r10,r5
	mov.l	r10,r1

loc_60018B6:
	neg	r8,r8
	sub	r0,r1
	shlr	r1

loc_60018BC:
	mov.w	@r4+,r0
	extu.w	r0,r0
	dt	r1
	swap.b	r0,r0
	bf/s	loc_60018BC
	mov.w	r0,@-r8
	add	r5,r4

loc_60018C8:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_600188C
	mov.w	@r4+,r8
	rts
	nop

loc_60018D8:
	sub	r0,r1
	bra	loc_60018C8
	add	r1,r4

	lits

; ------------------------------------------------------------------------------

loc_60018E2:
	cmp/ge	r10,r0
	bt	loc_6001936
	cmp/gt	r11,r1
	bf	loc_6001936
	cmp/ge	r12,r8
	bt	loc_6001936
	cmp/ge	r13,r8
	bf	loc_6001936
	shll	r8
	cmp/ge	r11,r0
	bt/s	loc_6001908
	sub	r9,r8
	sub	r11,r0
	sub	r0,r4
	mov.l	r11,r0
	add	#1,r0
	cmp/eq	r0,r1
	bt/s	loc_6001960
	mov.b	@r4+,r5
	extu.b	r5,r5

loc_6001908:
	cmp/gt	r10,r1
	bt/s	loc_600193E
	add	r0,r8
	neg	r8,r8
	sub	r0,r1
	shlr	r1

loc_6001914:
	mov.w	@r4+,r2
	extu.w	r2,r2
	swap.b	r2,r2
	shll8	r2
	or	r2,r5
	mov.w	r5,@-r8
	dt	r1
	bf/s	loc_6001914
	swap.w	r2,r5
	mov.w	r5,@-r8

loc_6001926:
	mov.b	@r4+,r0
	mov.b	@r4+,r1
	xor	r5,r5
	cmp/eq	r0,r1
	bf/s	loc_60018E2
	mov.w	@r4+,r8
	rts
	nop

loc_6001936:
	sub	r0,r1
	bra	loc_6001926
	add	r1,r4
	
loc_600193E:
	mov.l	r1,r6
	sub	r10,r6
	add	#-1,r6
	sub	r6,r1
	neg	r8,r8
	sub	r0,r1
	shlr	r1

loc_600194C:
	mov.w	@r4+,r2
	extu.w	r2,r2
	swap.b	r2,r2
	shll8	r2
	or	r2,r5
	mov.w	r5,@-r8
	dt	r1
	bf/s	loc_600194C
	swap.w	r2,r5
	bra	loc_6001926
	add	r6,r4

loc_6001960:
	add	r0,r8
	neg	r8,r8
	bra	loc_6001926
	mov.w	r5,@-r8

	lits

; ------------------------------------------------------------------------------
