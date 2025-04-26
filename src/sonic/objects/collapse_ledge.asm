; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Collapsing ledge object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjCollapseLedge:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer

	move.w	#48,obj.collide_width(a6)			; Set hitbox size
	move.w	#8,obj.collide_height(a6)

	move.w	#48,obj.draw_width(a6)				; Set draw size
	move.w	#64,obj.draw_height(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	movea.w	player_object,a1				; Player object
	
	cmpa.w	player.ride_object(a1),a6			; Is the player standing on us?
	bne.s	.NotStoodOn					; If not, branch
	
	bset	#2,obj.flags(a6)				; Set stood on flag
	bne.s	.NotStoodOn					; If it's already set, branch

	move.w	#8-1,ledge.timer(a6)				; Set delay timer

.NotStoodOn:
	move.w	obj.x(a1),d0					; Get height map index
	sub.w	obj.x(a6),d0
	cmpi.w	#-$30,d0					; Is it too small?
	bge.s	.CheckMax					; If not, branch
	moveq	#-$30,d0					; Cap at minimum

.CheckMax:
	cmpi.w	#$2F,d0						; Is it too large?
	ble.s	.SetHeight					; If not, branch
	moveq	#$2F,d0						; Cap at maximum

.SetHeight:
	lea	HeightMap(pc),a0				; Height map
	btst	#OBJ_FLIP_X,obj.flags(a6)			; Are we flipped horizontally?
	beq.s	.NotFlipped					; If not, branch
	lea	HeightMapFlipped(pc),a0				; Use flipped height map

.NotFlipped:
	add.w	d0,d0						; Set height
	move.w	(a0,d0.w),obj.collide_height(a6)

.CheckCollapse:
	btst	#2,obj.flags(a6)				; Are we about to collapse?
	beq.w	.Solid						; If not, branch
	
	btst	#3,obj.flags(a6)				; Are we collapsing?
	beq.s	.SpawnPieces					; If not, branch

	tst.w	ledge.timer(a6)					; Has the delay timer already run out?
	bmi.w	.Draw						; If so, branch
	subq.w	#1,ledge.timer(a6)				; Decrement delay timer
	bpl.w	.Solid						; If it hasn't run out, branch

	bra.w	DeleteObject					; Delete ourselves

.SpawnPieces:
	subq.w	#1,ledge.timer(a6)				; Decrement solidity timer
	bpl.w	.Solid						; If it hasn't run out, branch

	bset	#3,obj.flags(a6)				; Set stood on flag
	move.w	#$1C-1,ledge.timer(a6)				; Set solidity timer

	lea	Sfx_Collapse,a0					; Play collapse SFX
	bsr.w	PlaySfx

	lea	CollapseDelayTimes(pc),a3			; Delay times

	lea	Spr_CollapseLedge,a4				; Sprite data
	moveq	#0,d0
	move.b	obj.subtype(a6),d0
	add.w	d0,d0
	addq.w	#4,d0
	adda.w	(a4,d0.w),a4
	addq.w	#2,a4
	
	moveq	#0,d1						; Clear sprite offsets
	moveq	#0,d2

	move.b	obj.flags(a6),-(sp)				; Get tile flip
	move.w	(sp)+,d3
	andi.w	#$300,d3
	lsl.w	#3,d3

	moveq	#$19-1,d4					; Number of pieces

.InitPieces:
	lea	collapse_pieces,a0				; Spawn collapsing piece
	bsr.w	AddListItem
	
	move.b	(a3)+,collapse.delay(a1)			; Set delay time

	move.b	(a4)+,d0					; Get Y position
	ext.w	d0

	move.b	(a4)+,d1					; Get size
	move.b	d1,collapse.size(a1)

	btst	#OBJ_FLIP_Y,obj.flags(a6)			; Is this piece vertically flipped?
	beq.s	.SetPieceY					; If not, branch
	neg.w	d0						; Apply Y flip
	move.b	.YFlipOffsets(pc,d1.w),d2
	sub.w	d2,d0

.SetPieceY:
	add.w	obj.y(a6),d0					; Set Y position
	move.w	d0,collapse.y(a1)

	move.w	(a4)+,d0					; Set tile ID
	addi.w	#$442E,d0
	eor.w	d3,d0
	move.w	d0,collapse.tile(a1)

	move.w	(a4)+,d0					; Get X position
	btst	#OBJ_FLIP_X,obj.flags(a6)			; Is this piece horizontally flipped?
	beq.s	.SetPieceX					; If not, branch
	neg.w	d0						; Apply Y flip
	move.b	.XFlipOffsets(pc,d1.w),d1
	sub.w	d1,d0

.SetPieceX:
	add.w	obj.x(a6),d0					; Set X position
	move.w	d0,collapse.x(a1)

	dbf	d4,.InitPieces					; Loop until finished

.Solid:
	moveq	#OBJ_TOP_SOLID,d0				; Make top solid
	bsr.w	SolidObject

.Draw:
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------

.XFlipOffsets:
	dc.b	$08, $08, $08, $08
	dc.b	$10, $10, $10, $10
	dc.b	$18, $18, $18, $18
	dc.b	$20, $20, $20, $20

.YFlipOffsets:
	dc.b	$08, $10, $18, $20
	dc.b	$08, $10, $18, $20
	dc.b	$08, $10, $18, $20
	dc.b	$08, $10, $18, $20

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	btst	#3,obj.flags(a6)				; Are we collapsing?
	bne.s	.End						; If so, branch

	pea	Spr_CollapseLedge				; Draw sprite
	moveq	#0,d0
	move.b	obj.subtype(a6),d0
	move.w	d0,-(sp)
	move.w	#$442E,-(sp)
	move.b	obj.flags(a6),d0
	andi.b	#%11,d0
	move.b	d0,-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	bsr.w	DrawSprite

.End:
	rts

; ------------------------------------------------------------------------------
; Collapse delay times
; ------------------------------------------------------------------------------

CollapseDelayTimes:
	dc.b	$1C, $18, $14, $10, $1A, $16, $12, $0E
	dc.b	$0A, $06, $18, $14, $10, $0C, $08, $04
	dc.b	$16, $12, $0E, $0A, $06, $02, $14, $10
	dc.b	$0C
	even

; ------------------------------------------------------------------------------
; Height maps
; ------------------------------------------------------------------------------

	dc.w	22, 22, 22, 22, 22, 22, 22, 22
	dc.w	22, 22, 22, 22, 22, 22, 22, 22
	dc.w	22, 22, 22, 22, 23, 23, 23, 23
	dc.w	24, 24, 24, 24, 25, 25, 25, 25
	dc.w	26, 26, 26, 26, 27, 27, 27, 27
	dc.w	28, 28, 28, 28, 29, 29, 29, 29
HeightMap:
	dc.w	30, 30, 30, 30, 31, 31, 31, 31
	dc.w	32, 32, 32, 32, 33, 33, 33, 33
	dc.w	34, 34, 34, 34, 35, 35, 35, 35
	dc.w	36, 36, 36, 36, 37, 37, 37, 37
	dc.w	38, 38, 38, 38, 38, 38, 38, 38
	dc.w	38, 38, 38, 38, 38, 38, 38, 38

	dc.w	38, 38, 38, 38, 38, 38, 38, 38
	dc.w	38, 38, 38, 38, 38, 38, 38, 38
	dc.w	37, 37, 37, 37, 36, 36, 36, 36
	dc.w	35, 35, 35, 35, 34, 34, 34, 34
	dc.w	33, 33, 33, 33, 32, 32, 32, 32
	dc.w 	31, 31, 31, 31, 30, 30, 30, 30
HeightMapFlipped:
	dc.w	29, 29, 29, 29, 28, 28, 28, 28
	dc.w	27, 27, 27, 27, 26, 26, 26, 26
	dc.w	25, 25, 25, 25, 24, 24, 24, 24
	dc.w	23, 23, 23, 23, 22, 22, 22, 22
	dc.w	22, 22, 22, 22, 22, 22, 22, 22
	dc.w	22, 22, 22, 22, 22, 22, 22, 22

; ------------------------------------------------------------------------------
