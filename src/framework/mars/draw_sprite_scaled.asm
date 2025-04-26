; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Scaled sprite drawing function
; ------------------------------------------------------------------------------

	section sh2_code
	include	"src/framework/mars.inc"

; ------------------------------------------------------------------------------
; Draw scaled sprite
; ------------------------------------------------------------------------------

DrawScaledSprite:
	mov.l	#DIV,r10
	mov.l	#$1000000,r0
	mov.l	r5,@(DVSR,r10)
	mov.l	r0,@(DVDNT,r10)
	mov.w	@r4+,r7
	mov.w	@r4+,r8
	add	#1,r8
	lds	r8,mach
	sub	r7,r8
	mov.l	r8,r0
	shll2	r0
	sub	r0,r15
	mov.l	r15,r11
	mov.l	r15,r12
	mov.l	r0,@-r15
	shlr	r0
	add	r0,r12
	mov.l	#Sprite2dBounds,r0
	mov.w	@r0+,r13
	mov.w	@r0+,r14
	shll16	r13
	shll16	r14
	mov.l	@(DVDNT,r10),r9
	shll16	r1
	mul.l	r9,r7
	mov.l	#$1000000,r0
	mov.l	r6,@(DVSR,r10)
	rotr	r3
	sts	macl,r7
	mov.l	r0,@(DVDNT,r10)
	bt/s	DrawScaledSprite_InitFlippedX
	mul.l	r9,r8
	
; ------------------------------------------------------------------------------

DrawScaledSprite_InitNotFlippedX:
	add	r1,r7
	cmp/ge	r14,r7
	bt	loc_6001FC4
	sts	macl,r0
	add	r7,r0
	cmp/ge	r13,r0
	bf	loc_6001FC4
	cmp/ge	r13,r7
	bt	loc_6001F96
	swap.w	r13,r5
	xor	r0,r0

loc_6001F84:
	add	r9,r7
	cmp/ge	r13,r7
	bt	loc_6001F9A
	mov.w	r5,@r11
	add	#2,r11
	mov.w	r0,@r12
	dt	r8
	bf/s	loc_6001F84
	add	#2,r12

loc_6001F96:
	swap.w	r7,r5
	add	r9,r7

loc_6001F9A:
	cmp/ge	r14,r7
	bt	loc_6001FB0
	swap.w	r7,r0
	sub	r5,r0
	mov.w	r5,@r11
	add	#2,r11
	mov.w	r0,@r12
	dt	r8
	bf/s	loc_6001F96
	add	#2,r12
	bt	DrawScaledSprite_InitY

loc_6001FB0:
	swap.w	r14,r0
	sub	r5,r0

loc_6001FB4:
	mov.w	r5,@r11
	add	#2,r11
	mov.w	r0,@r12
	add	#2,r12
	dt	r8
	bf/s	loc_6001FB4
	xor	r0,r0
	bt	DrawScaledSprite_InitY

loc_6001FC4:
	mov.l	@r15+,r0
	rts
	add	r0,r15
	
	lits

; ------------------------------------------------------------------------------

DrawScaledSprite_InitFlippedX:
	mov.b	#$FF,r0
	xor	r0,r7
	add	#-1,r13
	add	#-1,r14
	add	r1,r7
	cmp/gt	r13,r7
	bf	loc_6001FC4
	sts	macl,r0
	neg	r0,r0
	add	r7,r0
	cmp/ge	r14,r0
	bt	loc_6001FC4
	cmp/gt	r14,r7
	bf	loc_600200E
	swap.w	r14,r5
	xor	r0,r0

loc_6001FFC:
	sub	r9,r7
	cmp/gt	r14,r7
	bf	loc_6002012
	mov.w	r5,@r11
	add	#2,r11
	mov.w	r0,@r12
	dt	r8
	bf/s	loc_6001FFC
	add	#2,r12

loc_600200E:
	swap.w	r7,r5
	sub	r9,r7

loc_6002012:
	cmp/gt	r13,r7
	bf	loc_6002028
	mov.w	r5,@r11
	add	#2,r11
	swap.w	r7,r0
	sub	r0,r5
	mov.w	r5,@r12
	dt	r8
	bf/s	loc_600200E
	add	#2,r12
	bt	DrawScaledSprite_InitY

loc_6002028:
	mov.l	r5,r0
	swap.w	r13,r13
	sub	r13,r0

loc_600202E:
	mov.w	r5,@r11
	add	#2,r11
	mov.w	r0,@r12
	add	#2,r12
	dt	r8
	bf/s	loc_600202E
	xor	r0,r0

; ------------------------------------------------------------------------------

DrawScaledSprite_InitY:
	sts	mach,r0
	shll	r0
	sub	r0,r11
	sub	r0,r12
	mov.b	@r4+,r7
	add	#1,r4
	mov.b	@r4+,r8
	add	#1,r4
	add	#1,r8
	lds	r8,mach
	sub	r7,r8
	mov.l	r8,r0
	shll2	r0
	sub	r0,r15
	mov.l	r15,r13
	sub	r0,r15
	mov.l	r15,r14
	shll	r0
	mov.l	r0,@-r15
	mov.l	@(DVDNT,r10),r9
	mov.l	#Sprite2dBounds+4,r0
	mul.l	r9,r7
	mov.l	@r0+,r6
	mov.l	@r0+,r7
	shll8	r6
	shlr8	r7
	add	#1,r7
	shll16	r7
	sts	macl,r10
	mov.l	#OVER_WRITE+$200,r1
	shll16	r2
	rotr	r3
	bt/s	DrawScaledSprite_InitFlippedY
	mul.l	r9,r8
	
; ------------------------------------------------------------------------------

DrawScaledSprite_InitNotFlippedY:
	add	r2,r10
	cmp/ge	r7,r10
	bt	DrawScaledSprite_End
	sts	macl,r0
	add	r10,r0
	cmp/gt	r6,r0
	bf	DrawScaledSprite_End
	cmp/ge	r6,r10
	bt	loc_60020A6
	swap.w	r6,r5
	xor	r0,r0

loc_6002096:
	add	r9,r10
	cmp/gt	r6,r10
	bt	loc_60020AA
	add	#4,r13
	mov.l	r0,@r14
	dt	r8
	bf/s	loc_6002096
	add	#4,r14

loc_60020A6:
	swap.w	r10,r5
	add	r9,r10

loc_60020AA:
	cmp/ge	r7,r10
	bt/s	loc_60020CA
	exts.w	r5,r5
	swap.w	r10,r0
	exts.w	r0,r0
	sub	r5,r0
	mov.l	r0,@r14
	add	#4,r14
	shll8	r5
	shll	r5
	add	r1,r5
	mov.l	r5,@r13
	dt	r8
	bf/s	loc_60020A6
	add	#4,r13
	bt	DrawScaledSprite_InitDone

loc_60020CA:
	shlr16	r7
	sub	r5,r7
	shll8	r5
	shll	r5
	add	r1,r5

loc_60020D4:
	mov.l	r5,@r13
	add	#4,r13
	mov.l	r7,@r14
	add	#4,r14
	dt	r8
	bf/s	loc_60020D4
	xor	r7,r7
	bt	DrawScaledSprite_InitDone

; ------------------------------------------------------------------------------

DrawScaledSprite_End:
	mov.l	@r15+,r0
	add	r0,r15
	mov.l	@r15+,r0
	rts
	add	r0,r15
	
	lits

; ------------------------------------------------------------------------------

DrawScaledSprite_InitFlippedY:
	neg	r10,r10
	add	r2,r10
	cmp/gt	r6,r10
	bf	DrawScaledSprite_End
	sts	macl,r0
	neg	r0,r0
	add	r10,r0
	cmp/ge	r7,r0
	bt	DrawScaledSprite_End
	cmp/ge	r7,r10
	bf	loc_6002122
	swap.w	r7,r5
	xor	r0,r0

loc_6002112:
	sub	r9,r10
	cmp/ge	r7,r10
	bf	loc_6002126
	add	#4,r13
	mov.l	r0,@r14
	dt	r8
	bf/s	loc_6002112
	add	#4,r14

loc_6002122:
	swap.w	r10,r5
	sub	r9,r10

loc_6002126:
	cmp/ge	r6,r10
	bf/s	loc_6002146
	exts.w	r5,r5
	swap.w	r10,r0
	exts.w	r0,r0
	sub	r0,r5
	mov.l	r5,@r14
	add	#4,r14
	shll8	r0
	shll	r0
	add	r1,r0
	mov.l	r0,@r13
	dt	r8
	bf/s	loc_6002122
	add	#4,r13
	bt	DrawScaledSprite_InitDone

loc_6002146:
	shlr16	r6
	sub	r6,r5
	shll8	r6
	shll	r6
	add	r1,r6

loc_6002150:
	mov.l	r6,@r13
	add	#4,r13
	mov.l	r5,@r14
	add	#4,r14
	dt	r8
	bf/s	loc_6002150
	xor	r5,r5

; ------------------------------------------------------------------------------

DrawScaledSprite_InitDone:
	sts	mach,r0
	shll2	r0
	sub	r0,r13
	sub	r0,r14
	
; ------------------------------------------------------------------------------

DrawScaledSprite_StartDraw:
	mov.w	#$200,r9
	rotr	r3
	shll2	r3
	rotl	r3
	bf	DrawScaledSprite_CheckRow
	bra	DrawScaledSprite_CheckRowFlipX
	nop
	
	lits
	
; ------------------------------------------------------------------------------

DrawScaledSprite_Draw:
	shll2	r0
	mov.l	@(r0,r14),r8
	add	#1,r4
	tst	r8,r8
	bt/s	loc_6002210
	sub	r6,r2
	mov.l	@(r0,r13),r7
	mov.l	r8,r10
	shll8	r10
	shll	r10
	shll	r6
	mov.l	r6,r0
	mov.w	@(r0,r11),r0
	add	r12,r6
	add	r0,r7
	rotr	r0
	bf/s	loc_60021D8
	add	#-2,r10
	xor	r3,r3
	add	#-1,r7

loc_60021AA:
	mov.w	@r6+,r1
	mov.b	@r4+,r0
	extu.b	r0,r0
	tst	r1,r1
	bt	loc_60021CA

loc_60021B2:
	or	r0,r3
	mov.l	r8,r5

loc_60021B6:
	mov.w	r3,@r7
	dt	r5
	bf/s	loc_60021B6
	add	r9,r7
	dt	r1
	bt/s	loc_60021F8
	sub	r10,r7
	dt	r1
	bf/s	loc_60021B2
	swap.b	r0,r3

loc_60021CA:
	dt	r2
	bf	loc_60021AA

loc_60021CE:
	mov.w	r3,@r7
	dt	r8
	bf/s	loc_60021CE
	add	r9,r7
	bt	DrawScaledSprite_CheckRow

loc_60021D8:
	mov.w	@r6+,r1
	mov.b	@r4+,r0
	extu.b	r0,r0
	tst	r1,r1
	bt	loc_60021F8

loc_60021E0:
	dt	r1
	bt/s	loc_60021CA
	swap.b	r0,r3
	or	r0,r3
	mov.l	r8,r5

loc_60021EA:
	mov.w	r3,@r7
	dt	r5
	bf/s	loc_60021EA
	add	r9,r7
	dt	r1
	bf/s	loc_60021E0
	sub	r10,r7

loc_60021F8:
	dt	r2
	bf	loc_60021D8

DrawScaledSprite_CheckRow:
	mov.b	@r4+,r6
	mov.b	@r4+,r2
	cmp/eq	r6,r2
	bf/s	DrawScaledSprite_Draw
	mov.b	@r4+,r0
	
	mov.l	@r15+,r0
	add	r0,r15
	mov.l	@r15+,r0
	rts
	add	r0,r15

loc_6002210:
	bra	DrawScaledSprite_CheckRow
	add	r2,r4
	
	lits

; ------------------------------------------------------------------------------

DrawScaledSprite_DrawFlipX:
	shll2	r0
	mov.l	@(r0,r14),r8
	add	#1,r4
	tst	r8,r8
	bt/s	loc_60022A6
	sub	r6,r2
	mov.l	@(r0,r13),r7
	mov.l	r8,r10
	shll8	r10
	shll	r10
	add	#2,r10
	shll	r6
	mov.l	r6,r0
	mov.w	@(r0,r11),r0
	add	r12,r6
	add	r0,r7
	rotr	r0
	bf/s	loc_6002264
	xor	r3,r3
	add	#-1,r7

loc_600223C:
	mov.w	@r6+,r1
	mov.b	@r4+,r0
	extu.b	r0,r0
	tst	r1,r1
	bt	loc_600225E

loc_6002244:
	dt	r1
	bt/s	loc_6002286
	mov.l	r0,r3
	swap.b	r0,r5
	or	r5,r3
	mov.l	r8,r5

loc_6002250:
	mov.w	r3,@r7
	dt	r5
	bf/s	loc_6002250
	add	r9,r7
	dt	r1
	bf/s	loc_6002244
	sub	r10,r7

loc_600225E:
	dt	r2
	bf	loc_600223C
	bt	DrawScaledSprite_CheckRowFlipX

loc_6002264:
	mov.w	@r6+,r1
	mov.b	@r4+,r0
	extu.b	r0,r0
	tst	r1,r1
	bt	loc_6002286

loc_600226C:
	swap.b	r0,r5
	or	r5,r3
	mov.l	r8,r5

loc_6002272:
	mov.w	r3,@r7
	dt	r5
	bf/s	loc_6002272
	add	r9,r7
	dt	r1
	bt/s	loc_600225E
	sub	r10,r7
	dt	r1
	bf/s	loc_600226C
	mov.l	r0,r3

loc_6002286:
	dt	r2
	bf	loc_6002264

loc_600228A:
	mov.w	r3,@r7
	dt	r8
	bf/s	loc_600228A
	add	r9,r7

DrawScaledSprite_CheckRowFlipX:
	mov.b	@r4+,r6
	mov.b	@r4+,r2
	cmp/eq	r6,r2
	bf/s	DrawScaledSprite_DrawFlipX
	mov.b	@r4+,r0
	
	mov.l	@r15+,r0
	add	r0,r15
	mov.l	@r15+,r0
	rts
	add	r0,r15

loc_60022A6:
	bra	DrawScaledSprite_CheckRowFlipX
	add	r2,r4
	
	lits
	
; ------------------------------------------------------------------------------

	cnop 0,4
Sprite2dBounds:	
	dc.w	0, 320						; 2D sprite horizontal boundaries
	dc.l	0<<8, (224-1)<<8				; 2D sprite vertical boundaries

; ------------------------------------------------------------------------------
