; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Map functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/framework/md.inc"

; ------------------------------------------------------------------------------
; Load map data
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Map ID
;	a0.l - Pointer to map metadata index
; RETURNS:
;	a0.l - Start of custom map metadata
; ------------------------------------------------------------------------------

LoadMapData:
	add.w	d0,d0						; Get map metadata
	add.w	d0,d0
	movea.l	(a0,d0.w),a0
	
	move.l	(a0)+,d0					; Get map art
	beq.s	.NoArt						; If it's not set, branch
	
	movea.l	d0,a1						; Queue map art for decompression
	moveq	#0,d2
	bsr.w	QueueKosmData

.NoArt:
	move.l	(a0)+,d0
	beq.s	.NoPalette					; If it's not set, branch
	
	move.l	a0,-(sp)					; Load palette
	movea.l	d0,a0
	moveq	#0,d0
	moveq	#$40,d1
	bsr.w	LoadPalette
	movea.l	(sp)+,a0

.NoPalette:
	move.l	(a0)+,d0					; Get art list
	beq.s	.NoArtList					; If it's not set, branch
	
	movea.l	d0,a3						; Queue art list for decompression
	bsr.w	QueueKosmList

.NoArtList:
	move.l	(a0)+,d0					; Get 32X sprite list
	beq.s	.NoMarsSprites
	
	move.l	d0,-(sp)					; Load 32X sprites
	bsr.w	LoadMarsSpriteList

.NoMarsSprites:
	move.l	(a0)+,d0					; Get 32X palette list
	beq.s	.NoMarsPalette					; If it's not set, branch
	
	move.l	d0,-(sp)					; Load 32X palettes
	bsr.w	LoadMarsPaletteList

.NoMarsPalette:
	move.w	palette+$40,d0					; Set 32X background color
	bsr.w	ConvMdColorToMars
	ori.w	#$8000,d0
	move.w	d0,-(sp)
	move.w	d0,-(sp)
	clr.b	-(sp)
	bsr.w	SetMarsColor
	move.b	#1,-(sp)
	bsr.w	SetMarsColor

	move.l	(a0)+,map_blocks				; Set block data address
	move.l	(a0)+,map_chunks				; Set chunk data address
	move.l	(a0)+,map_fg_data				; Set foreground map data address
	addq.l	#4,map_fg_data
	move.l	(a0)+,map_bg_data				; Set background map data address
	addq.l	#4,map_bg_data
	move.l	(a0)+,map_collision_1				; Set collision data address (layer 1)
	move.l	(a0)+,map_collision_2				; Set collision data address (layer 2)
	move.l	(a0)+,map_collision_heights			; Set collision height array data address
	move.l	(a0)+,map_collision_widths			; Set collision width array data address
	move.l	(a0)+,map_collision_angles			; Set collision angle data address
	move.l	(a0)+,map_objects				; Set object data address
	move.l	(a0)+,map_fg_bound_left				; Set foreground boundaries
	move.l	(a0)+,map_fg_bound_top
	move.l	(a0)+,map_bg_bound_left				; Set background boundaries
	move.l	(a0)+,map_bg_bound_top
	move.l	(a0)+,map_initialize				; Get initialization routine address
	move.l	(a0)+,map_events				; Set events routine address
	move.l	(a0)+,map_scroll				; Set scroll routine address
	move.l	a0,map_user_data				; Set user data address
	
	move.l	map_collision_1,map_collision_layer		; Reset colllision layer
	clr.b	map_collision_bit

	bsr.w	FlushKosmQueue					; Flush Kosinski Moduled queue
	bsr.w	UpdateMarsPaletteFade				; Update 32X palette fade
	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bsr.w	WaitMarsGraphicsData
	bra.w	UpdateCram					; Update CRAM

; ------------------------------------------------------------------------------
; Set map chunk size
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Chunk size
;	       0: 32x32
;	       1: 64x64
;	       2: 128x128
;	       3: 256x256
; ------------------------------------------------------------------------------

SetMapChunkSize:
	add.w	d0,d0						; Get chunk size data
	move.w	d0,d1
	add.w	d0,d0
	add.w	d0,d0
	add.w	d1,d0
	move.l	.ChunkSizes(pc,d0.w),map_chunk_stride
	move.l	.ChunkSizes+4(pc,d0.w),map_chunk_y_mask
	move.b	.ChunkSizes+8(pc,d0.w),map_chunk_y_shift
	rts
	
; ------------------------------------------------------------------------------

CHUNK_SIZE macro size
	local c
	c: = 0
	rept (\size)+1
		c: = (c<<1)|1
	endr
	dc.w	4<<(\size)					; Chunk stride
	dc.w	c<<1, c<<(2+(\size))				; Masks
	dc.b	5+(\size), 3+((\size)*2), 3-(\size), 0		; Shifts
	endm

; ------------------------------------------------------------------------------

.ChunkSizes:
	CHUNK_SIZE 0						; 32x32
	CHUNK_SIZE 1						; 64x64
	CHUNK_SIZE 2						; 128x128
	CHUNK_SIZE 3						; 256x256

; ------------------------------------------------------------------------------
; Flush tile buffers
; ------------------------------------------------------------------------------

FlushMapBlocks:
	lea	VDP_CTRL,a5					; VDP control port
	lea	VDP_DATA-VDP_CTRL(a5),a6			; VDP data port
	
	move.w	#$8F80,(a5)					; Stream vertically
	
	lea	map_foreground+map.column_1,a0			; Foreground column
	lea	map_foreground+map.column_2,a1
	bsr.s	FlushMapColumn
	
	lea	map_background+map.column_1,a0			; Background column
	lea	map_background+map.column_2,a1
	bsr.s	FlushMapColumn

	move.w	#$8F02,(a5)					; Stream horizontally

	lea	map_foreground+map.row_1,a0			; Foreground row
	lea	map_foreground+map.row_2,a1
	bsr.s	FlushMapRow
	
	lea	map_background+map.row_1,a0			; Background row
	lea	map_background+map.row_2,a1

; ------------------------------------------------------------------------------

FlushMapRow:
	move.w	(a0)+,d1					; Get first tile count
	
	move.l	(a0),d0						; Get VDP command
	beq.s	.End						; If it's not set, branch
	clr.l	(a0)+						; Mark as flushed
	
	move.w	d1,d2						; Get other tile counts
	moveq	#(512/16)-1-1,d3
	sub.w	d1,d3
	
	move.l	d0,(a5)						; Draw top tiles part 1
	
.DrawTop1:
	move.l	(a0)+,(a6)
	dbf	d1,.DrawTop1
	
	move.l	d0,d1						; Draw bottom tiles part 1
	addi.l	#$800000,d1
	move.l	d1,(a5)
	
.DrawBottom1:
	move.l	(a1)+,(a6)
	dbf	d2,.DrawBottom1
	
	tst.w	d3						; Are there any more tiles to draw?
	bmi.s	.End						; If not, branch
	move.w	d3,d4						; Copy remaining tile count
	
	move.l	#$FF80FFFF,d2					; Draw top tiles part 2
	and.l	d2,d0
	move.l	d0,(a5)
	
.DrawTop2:
	move.l	(a0)+,(a6)
	dbf	d3,.DrawTop2
	
	and.l	d2,d1						; Draw bottom tiles part 2
	move.l	d1,(a5)
	
.DrawBottom2:
	move.l	(a1)+,(a6)
	dbf	d4,.DrawBottom2
	
.End:
	rts

; ------------------------------------------------------------------------------

FlushMapColumn:
	move.w	(a0)+,d1					; Get first tile count
	
	move.l	(a0),d0						; Get VDP command
	beq.s	.End						; If it's not set, branch
	clr.l	(a0)+						; Mark as flushed
	
	move.w	d1,d2						; Get other tile counts
	moveq	#(256/16)-1-1,d3
	sub.w	d1,d3
	
	move.l	d0,(a5)						; Draw left tiles part 1
	
.DrawLeft1:
	move.l	(a0)+,(a6)
	dbf	d1,.DrawLeft1
	
	move.l	d0,d1						; Draw right tiles part 1
	addi.l	#$20000,d1
	move.l	d1,(a5)
	
.DrawRight1:
	move.l	(a1)+,(a6)
	dbf	d2,.DrawRight1
	
	tst.w	d3						; Are there any more tiles to draw?
	bmi.s	.End						; If not, branch
	move.w	d3,d4						; Copy remaining tile count
	
	move.l	#$F07FFFFF,d2					; Draw left tiles part 2
	and.l	d2,d0
	move.l	d0,(a5)
	
.DrawLeft2:
	move.l	(a0)+,(a6)
	dbf	d3,.DrawLeft2
	
	and.l	d2,d1						; Draw right tiles part 2
	move.l	d1,(a5)
	
.DrawRight2:
	move.l	(a1)+,(a6)
	dbf	d4,.DrawRight2
	
.End:
	rts

; ------------------------------------------------------------------------------
; Draw a row of blocks
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d4.w - Y position
;	d5.w - X position
;	a3.l - Map layer variables
; ------------------------------------------------------------------------------

DrawMapRow:
	movea.l	map.data(a3),a4					; Map data

	add.w	map.x_draw(a3),d5				; Add camera position
	add.w	map.y_draw(a3),d4
	movem.l	d4-d5,-(sp)

	lea	map.row_1(a3),a5				; Get row buffers
	lea	map.row_2(a3),a6

	andi.w	#$1F0,d5					; Get number of blocks in first set
	lsr.w	#2,d5
	move.w	d5,d0
	lsr.w	#2,d0
	subi.w	#(512/16)-1,d0
	neg.w	d0
	move.w	d0,(a5)+

	andi.w	#$F0,d4						; Calculate VDP command
	lsl.w	#4,d4
	add.w	d5,d4
	move.w	d4,d0
	or.w	map.vdp_command(a3),d0
	swap	d0
	move.w	#3,d0
	move.l	d0,(a5)+
	
	movem.l	(sp)+,d4-d5					; Get map row
	move.b	map_pos_shift,d1
	move.w	d4,d3
	lsr.w	d1,d3
	add.w	d3,d3
	movea.w	(a4,d3.w),a2
	adda.l	map.data(a3),a2

	move.w	d5,d0						; Get map row offset
	lsr.w	d1,d0
	add.w	d0,d0
	adda.w	d0,a2

	move.b	map_chunk_y_shift,d1				; Get chunk data Y offset
	add.w	d4,d4
	lsr.w	d1,d4

	move.b	map_chunk_id_shift,d1				; Get chunk data offset
	and.w	map_chunk_y_mask,d4
	lsr.w	#3,d5
	and.w	map_chunk_x_mask,d5

	moveq	#(512/16)-1,d6					; 32 blocks in a row

; ------------------------------------------------------------------------------

.ChunkLoop:
	moveq	#0,d3						; Get block metadata in chunk
	move.w	(a2)+,d3
	lsl.w	d1,d3
	add.w	d4,d3
	add.w	d5,d3
	add.l	map_chunks,d3
	movea.l	d3,a0

.BlockLoop:
	movem.l	d4-d5,-(sp)					; Save registers

	movea.l	map_blocks,a1					; Get pointer to block data
	move.w	(a0),d2
	move.w	d2,d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	adda.w	d3,a1
	
	move.l	(a1)+,d4					; Get block data
	move.l	(a1)+,d5

	btst	#10,d2						; Is this block flipped horizontally?
	beq.s	.ChkFlipY					; If not, branch
	swap	d4						; If so, flip the data
	swap	d5
	eori.l	#$8000800,d4
	eori.l	#$8000800,d5

.ChkFlipY:
	btst	#11,d2						; Is this block flipped vertically?
	beq.s	.Draw						; If not, branch
	exg.l	d4,d5						; If so, flip the data
	eori.l	#$10001000,d4
	eori.l	#$10001000,d5

.Draw:
	move.l	d4,(a5)+					; Queue block for drawing
	move.l	d5,(a6)+

	movem.l	(sp)+,d4-d5					; Restore registers

	addq.w	#2,a0						; Next block right
	addq.w	#2,d5
	and.w	map_chunk_x_mask,d5
	beq.s	.NextChunk					; If we are outside the chunk now, branch

	dbf	d6,.BlockLoop					; Loop until finished
	rts

.NextChunk:
	dbf	d6,.ChunkLoop					; Loop until finished
	rts

; ------------------------------------------------------------------------------
; Draw a column of blocks
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d4.w - Y position
;	d5.w - X position
;	a3.l - Map layer variables
; ------------------------------------------------------------------------------

DrawMapColumn:
	movea.l	map.data(a3),a4					; Map data

	add.w	map.x_draw(a3),d5				; Add camera position
	add.w	map.y_draw(a3),d4
	movem.l	d4-d5,-(sp)

	lea	map.column_1(a3),a5				; Get column buffers
	lea	map.column_2(a3),a6

	andi.w	#$F0,d4						; Get number of blocks in first set
	move.w	d4,d0
	lsr.w	#4,d0
	subi.w	#(256/16)-1,d0
	neg.w	d0
	move.w	d0,(a5)+
	
	andi.w	#$1F0,d5					; Calculate VDP command
	lsl.w	#4,d4
	lsr.w	#2,d5
	add.w	d5,d4
	move.w	d4,d0
	or.w	map.vdp_command(a3),d0
	swap	d0
	move.w	#3,d0
	move.l	d0,(a5)+

	movem.l	(sp)+,d4-d5					; Get map row
	move.b	map_pos_shift,d1
	move.w	d4,d3
	lsr.w	d1,d3
	add.w	d3,d3
	lea	(a4,d3.w),a1

	move.w	d5,d0						; Get map row offset
	lsr.w	d1,d0
	add.w	d0,d0

	move.b	map_chunk_y_shift,d1				; Get chunk data Y offset
	add.w	d4,d4
	lsr.w	d1,d4
	
	move.b	map_chunk_id_shift,d1				; Get chunk data offset
	and.w	map_chunk_y_mask,d4
	lsr.w	#3,d5
	and.w	map_chunk_x_mask,d5

	moveq	#(256/16)-1,d6					; 16 blocks in a column

; ------------------------------------------------------------------------------

.ChunkLoop:
	movea.w	(a1)+,a2					; Get block metadata in chunk
	adda.l	map.data(a3),a2
	moveq	#0,d3
	move.w	(a2,d0.w),d3
	lsl.w	d1,d3
	add.w	d4,d3
	add.w	d5,d3
	add.l	map_chunks,d3
	movea.l	d3,a0

.BlockLoop:
	movem.l	d4-d5/a1,-(sp)					; Save registers

	movea.l	map_blocks,a1					; Get pointer to block data
	move.w	(a0),d2
	move.w	d2,d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	adda.w	d3,a1

	move.w	(a1)+,d4					; Get block data
	swap	d4
	move.w	(a1)+,d5
	swap	d5
	move.w	(a1)+,d4
	move.w	(a1)+,d5
	
	btst	#10,d2						; Is this block flipped horizontally?
	beq.s	.ChkFlipY					; If not, branch
	exg.l	d4,d5						; If so, flip the data
	eori.l	#$8000800,d4
	eori.l	#$8000800,d5

.ChkFlipY:
	btst	#11,d2						; Is this block flipped vertically?
	beq.s	.Draw						; If not, branch
	swap	d4						; If so, flip the data
	swap	d5
	eori.l	#$10001000,d4
	eori.l	#$10001000,d5

.Draw:
	move.l	d4,(a5)+					; Queue block for drawing
	move.l	d5,(a6)+

	movem.l	(sp)+,d4-d5/a1					; Restore registers

	adda.w	map_chunk_stride,a0				; Next block down
	add.w	map_chunk_stride,d4
	and.w	map_chunk_y_mask,d4
	beq.s	.NextChunk					; If we are outside the chunk now, branch

	dbf	d6,.BlockLoop					; Loop until finished
	rts

.NextChunk:
	dbf	d6,.ChunkLoop					; Loop until finished
	rts

; ------------------------------------------------------------------------------
; Draw map foreground
; ------------------------------------------------------------------------------

DrawMapFg:
	lea	map_foreground,a3				; Update foreground
	bra.w	DrawMapLayer

; ------------------------------------------------------------------------------
; Draw map
; ------------------------------------------------------------------------------

DrawMap:
	lea	map_foreground,a3				; Update foreground
	bsr.w	DrawMapLayer

; ------------------------------------------------------------------------------
; Draw map background
; ------------------------------------------------------------------------------

DrawMapBg:
	lea	map_background,a3				; Update background

; ------------------------------------------------------------------------------
; Draw map layer
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a3.l - Map layer variables
; ------------------------------------------------------------------------------

DrawMapLayer:
	move.w	map.y_block(a3),d0				; Get block offsets
	move.w	map.y_draw(a3),d1
	move.w	d1,map.y_block(a3)
	
	btst	#0,map.flags(a3)				; Should we draw rows?
	beq.s	.CheckHorizDraw					; If not, branch
	
	andi.w	#$FFF0,d0					; Get distance traveled in blocks
	andi.w	#$FFF0,d1
	sub.w	d1,d0
	beq.s	.CheckHorizDraw					; If a block boundary hasn't been crossed, branch
	bmi.s	.DrawBottomRow					; If the camera moved down, branch
	
.DrawTopRow:
	moveq	#0,d4						; Draw a row at (0, 0)
	moveq	#0,d5
	bsr.w	DrawMapRow
	bra.s	.CheckHorizDraw

.DrawBottomRow:
	move.w	#224,d4						; Draw a row at (0, 224)
	moveq	#0,d5
	bsr.w	DrawMapRow

; ------------------------------------------------------------------------------

.CheckHorizDraw:
	move.w	map.x_block(a3),d0				; Get block offsets
	move.w	map.x_draw(a3),d1
	move.w	d1,map.x_block(a3)
	
	btst	#1,map.flags(a3)				; Should we draw rows?
	beq.s	.End						; If not, branch
	
	andi.w	#$FFF0,d0					; Get distance traveled in blocks
	andi.w	#$FFF0,d1
	sub.w	d1,d0
	beq.s	.End						; If a block boundary hasn't been crossed, branch
	bmi.s	.DrawRightColumn				; If the camera moved right, branch

.DrawLeftColumn:
	moveq	#0,d4						; Draw a column at (0, 0)
	moveq	#0,d5
	bra.w	DrawMapColumn

.DrawRightColumn:
	moveq	#0,d4						; Draw a column at (320, 0)
	move.w	#320,d5
	bra.w	DrawMapColumn

.End:
	rts

; ------------------------------------------------------------------------------
; Refresh map
; ------------------------------------------------------------------------------

RefreshMap:
	bsr.s	RefreshMapBg					; Refresh background

; ------------------------------------------------------------------------------
; Refresh foreground
; ------------------------------------------------------------------------------

RefreshMapFg:
	lea	map_foreground,a3				; Refresh foreground
	VDP_CMD_HI move.w,$C000,VRAM,WRITE,map.vdp_command(a3)
	bra.s	RefreshMapLayer

; ------------------------------------------------------------------------------
; Refresh foreground
; ------------------------------------------------------------------------------

RefreshMapBg:
	lea	map_background,a3				; Refresh background
	VDP_CMD_HI move.w,$E000,VRAM,WRITE,map.vdp_command(a3)

; ------------------------------------------------------------------------------
; Refresh map layer
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a3.l - Map layer variables
; ------------------------------------------------------------------------------

RefreshMapLayer:
	lea	VDP_CTRL,a5					; VDP control port
	lea	VDP_DATA-VDP_CTRL(a5),a6			; VDP data port

	moveq	#0,d4						; Start drawing at the top of the screen
	moveq	#(256/16)-1,d6					; 16 rows

.Draw:
	movem.l	d4/d6,-(sp)					; Draw a full row of blocks
	moveq	#0,d5
	bsr.w	DrawMapRow
	
	lea	map.row_1(a3),a0				; Flush and draw row of blocks
	lea	map.row_2(a3),a1
	lea	VDP_CTRL,a5
	lea	VDP_DATA-VDP_CTRL(a5),a6
	bsr.w	FlushMapRow
	movem.l	(sp)+,d4/d6

	addi.w	#16,d4						; Move down
	dbf	d6,.Draw					; Loop until finished
	
	move.w	map.x_draw(a3),map.x_block(a3)			; Set camera position
	move.w	map.y_draw(a3),map.y_block(a3)
	rts

; ------------------------------------------------------------------------------
; Get map block at position for distance checking
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Y position
;	d3.w - X position
; RETURNS:
;	d2.w - Chunk Y offset
;	d3.w - Chunk X offset
;	d7.w - Map row offset
;	a1.l - Block metadata pointer
;	a2.l - Map row
;	a3.l - Map row table offset
; ------------------------------------------------------------------------------

GET_BLOCK macro
	movea.l	map_fg_data,a3					; Map data
	
	move.b	map_pos_shift,d1				; Get map row
	movea.l	a3,a2
	move.w	d2,d0
	lsr.w	d1,d0
	add.w	d0,d0
	adda.w	d0,a3
	adda.w	(a3),a2

	move.w	d3,d7						; Get map row offset
	lsr.w	d1,d7
	add.w	d7,d7

	move.b	map_chunk_y_shift,d1				; Get chunk data Y offset
	add.w	d2,d2
	lsr.w	d1,d2
	
	and.w	map_chunk_y_mask,d2				; Get chunk data offset
	lsr.w	#3,d3
	and.w	map_chunk_x_mask,d3

	moveq	#0,d0						; Get block metadata in chunk
	move.w	(a2,d7.w),d0
	move.b	map_chunk_id_shift,d1
	lsl.w	d1,d0
	add.w	d2,d0
	add.w	d3,d0
	add.l	map_chunks,d0
	movea.l	d0,a1
	endm

; ------------------------------------------------------------------------------
; Get block distance below the current block
; ------------------------------------------------------------------------------
; PARAMETERS:
;	func - Block get function
;	off  - Height offset
; ------------------------------------------------------------------------------

GET_BLOCK_DIST_DOWN macro func, off
	adda.w	map_chunk_stride,a1				; Next block down
	add.w	map_chunk_stride,d2
	and.w	map_chunk_y_mask,d2
	bne.s	.CheckDown\@					; Is we are still in the current chunk, branch

	movea.w	2(a3),a2					; Next chunk down
	adda.l	map_fg_data,a2
	moveq	#0,d0
	move.w	(a2,d7.w),d0
	move.b	map_chunk_id_shift,d1
	lsl.w	d1,d0
	add.w	d3,d0
	add.l	map_chunks,d0
	movea.l	d0,a1

.CheckDown\@:
	bsr.w	\func						; Check block
	addi.w	#\off,d1					; Offset height
	rts
	endm

; ------------------------------------------------------------------------------
; Get block distance above the current block
; ------------------------------------------------------------------------------
; PARAMETERS:
;	func - Block get function
;	off  - Height offset
; ------------------------------------------------------------------------------

GET_BLOCK_DIST_UP macro func, off
	tst.w	d2						; Are we at the top of the chunk?
	bne.s	.CheckUp\@					; If not, branch

	movea.w	-(a3),a2					; Next chunk up
	adda.l	map_fg_data,a2
	moveq	#0,d0
	move.w	(a2,d7.w),d0
	move.b	map_chunk_id_shift,d1
	lsl.w	d1,d0
	add.w	d3,d0
	add.w	map_chunk_y_mask,d0
	add.l	map_chunks,d0
	movea.l	d0,a1
	
	bsr.w	\func						; Check block
	addi.w	#\off,d1					; Offset height
	rts

.CheckUp\@:
	suba.w	map_chunk_stride,a1				; Next block up

	bsr.w	\func						; Check block
	addi.w	#\off,d1					; Offset height
	rts
	endm

; ------------------------------------------------------------------------------
; Get block distance to the right from the current block
; ------------------------------------------------------------------------------
; PARAMETERS:
;	func - Block get function
;	off  - Width offset
; ------------------------------------------------------------------------------

GET_BLOCK_DIST_RIGHT macro func, off
	addq.w	#2,a1						; Next block right
	addq.w	#2,d3
	and.w	map_chunk_x_mask,d3
	bne.s	.CheckRight\@					; Is we are still in the current chunk, branch

	moveq	#0,d0						; Next chunk right
	move.w	2(a2,d7.w),d0
	move.b	map_chunk_id_shift,d1
	lsl.w	d1,d0
	add.w	d2,d0
	add.l	map_chunks,d0
	movea.l	d0,a1

.CheckRight\@:
	bsr.w	\func						; Check block
	addi.w	#\off,d1					; Offset width
	rts
	endm

; ------------------------------------------------------------------------------
; Get block distance to the left from the current block
; ------------------------------------------------------------------------------
; PARAMETERS:
;	func - Block get function
;	off  - Width offset
; ------------------------------------------------------------------------------

GET_BLOCK_DIST_LEFT macro func, off
	tst.w	d3						; Are we at the left side of the chunk?
	bne.s	.CheckLeft\@					; If not, branch
	
	moveq	#0,d0						; Next chunk left
	move.w	-2(a2,d7.w),d0
	move.b	map_chunk_id_shift,d1
	lsl.w	d1,d0
	add.w	d2,d0
	add.w	map_chunk_x_mask,d0
	add.l	map_chunks,d0
	movea.l	d0,a1
	
	bsr.w	\func						; Check block
	addi.w	#\off,d1					; Offset width
	rts
	
.CheckLeft\@:
	subq.w	#2,a1						; Next block left
	bsr.w	\func						; Check block
	addi.w	#\off,d1					; Offset width
	rts
	endm

; ------------------------------------------------------------------------------
; Get the distance to the nearest block down
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Y position
;	d3.w - X position
;	a4.l - Angle buffer
; RETURNS:
;	d1.w - Distance from the block
; ------------------------------------------------------------------------------

GetMapBlockDistDown:
	move.w	d2,d5						; Save position
	move.w	d3,d6

	GET_BLOCK						; Get map block
	move.w	(a1),d1
	move.w	d1,d4
	andi.w	#$3FF,d1
	beq.s	.IsBlank					; If it's blank, branch

	moveq	#$C,d0						; Get solidity bit to check
	add.b	map_collision_bit,d0

	btst	d0,d4						; Is the block solid?
	bne.s	.IsSolid					; If so, branch

.IsBlank:
	GET_BLOCK_DIST_DOWN GetMapBlockDistDown2, 16		; Check block down

.IsSolid:
	movea.l	map_collision_layer,a0				; Get collision block ID
	moveq	#0,d0
	move.b	(a0,d1.w),d0
	beq.s	.IsBlank					; If it's blank, branch

	movea.l	map_collision_angles,a0				; Get collision angle
	move.b	(a0,d0.w),d1
	btst	#0,d1						; Is it a flat surface block?
	beq.s	.CheckAngleFlipX				; If not, branch
	moveq	#0,d1						; Set flat surface angle
	bra.s	.SetAngle

.CheckAngleFlipX:
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.CheckAngleFlipY				; If not, branch
	neg.b	d1						; Flip the angle

.CheckAngleFlipY:
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.SetAngle					; If not, branch
	addi.b	#$40,d1						; Flip the angle
	neg.b	d1
	subi.b	#$40,d1

.SetAngle:
	move.b	d1,(a4)						; Set the angle

	lsl.w	#4,d0						; Get collision block data index
	move.w	d6,d1						; Get X position
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.NoFlipX					; If not, branch
	not.w	d1						; Invert the X position
	
.NoFlipX:
	andi.w	#$F,d1						; Get block column height
	add.w	d0,d1
	movea.l	map_collision_heights,a0
	move.b	(a0,d1.w),d0
	ext.w	d0

	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.NoFlipY					; If so, branch
	neg.w	d0						; Flip the height

.NoFlipY:
	tst.w	d0						; Check the height
	beq.w	.IsBlank					; If it's 0, branch
	bmi.s	.NegHeight					; If it's negative, branch
	cmpi.b	#$10,d0						; Is this a full height?
	beq.s	.MaxHeight					; If so, branch
	
	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d5,d4
	and.w	d1,d4
	add.w	d4,d0
	sub.w	d0,d1
	rts

.NegHeight:
	move.w	d5,d1						; Get how deep the object is into the block
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	.IsBlank					; If the object is outside of the block, branch

; ------------------------------------------------------------------------------

.MaxHeight:
	GET_BLOCK_DIST_UP GetMapBlockDistDown2, -16		; Check block up

; ------------------------------------------------------------------------------

GetMapBlockDistDown2:
	move.w	(a1),d1						; Get block ID
	move.w	d1,d4
	andi.w	#$3FF,d1
	beq.s	.IsBlank					; If it's blank, branch

	moveq	#$C,d0						; Get solidity bit to check
	add.b	map_collision_bit,d0

	btst	d0,d4						; Is the block solid?
	bne.s	.IsSolid					; If so, branch

.IsBlank:
	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d5,d0
	and.w	d1,d0
	sub.w	d0,d1
	rts

.IsSolid:
	movea.l	map_collision_layer,a0				; Get collision block ID
	moveq	#0,d0
	move.b	(a0,d1.w),d0
	beq.s	.IsBlank					; If it's blank, branch

	movea.l	map_collision_angles,a0				; Get collision angle
	move.b	(a0,d0.w),d1
	btst	#0,d1						; Is it a flat surface block?
	beq.s	.CheckAngleFlipX				; If not, branch
	moveq	#0,d1						; Set flat surface angle
	bra.s	.SetAngle

.CheckAngleFlipX:
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.CheckAngleFlipY				; If not, branch
	neg.b	d1						; Flip the angle

.CheckAngleFlipY:
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.SetAngle					; If not, branch
	addi.b	#$40,d1						; Flip the angle
	neg.b	d1
	subi.b	#$40,d1

.SetAngle:
	move.b	d1,(a4)						; Set the angle

	lsl.w	#4,d0						; Get collision block data index
	move.w	d6,d1						; Get X position
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.NoFlipX					; If not, branch
	not.w	d1						; Invert the X position
	
.NoFlipX:
	andi.w	#$F,d1						; Get block column height
	add.w	d0,d1
	movea.l	map_collision_heights,a0
	move.b	(a0,d1.w),d0
	ext.w	d0

	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.NoFlipY					; If so, branch
	neg.w	d0						; Flip the height

.NoFlipY:
	tst.w	d0						; Check the height
	beq.s	.IsBlank					; If it's 0, branch
	bmi.s	.NegHeight					; If it's negative, branch
	
	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d5,d4
	and.w	d1,d4
	add.w	d4,d0
	sub.w	d0,d1
	rts

.NegHeight:
	move.w	d5,d1						; Get how deep the object is into the block
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	.IsBlank					; If the object is outside of the block, branch
	not.w	d1						; Flip the height
	rts

; ------------------------------------------------------------------------------
; Get the distance to the nearest block up
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Y position
;	d3.w - X position
;	a4.l - Angle buffer
; RETURNS:
;	d1.w - Distance from the block
; ------------------------------------------------------------------------------

GetMapBlockDistUp:
	eori.w	#$F,d2						; Invert Y position
	move.w	d2,d5						; Save position
	move.w	d3,d6

	GET_BLOCK						; Get map block
	move.w	(a1),d1
	move.w	d1,d4
	andi.w	#$3FF,d1
	beq.s	.IsBlank					; If it's blank, branch

	moveq	#$D,d0						; Get solidity bit to check
	add.b	map_collision_bit,d0
	
	btst	d0,d4						; Is the block solid?
	bne.s	.IsSolid					; If so, branch

.IsBlank:
	GET_BLOCK_DIST_UP GetMapBlockDistUp2, 16		; Check block up

.IsSolid:
	movea.l	map_collision_layer,a0				; Get collision block ID
	moveq	#0,d0
	move.b	(a0,d1.w),d0
	beq.s	.IsBlank					; If it's blank, branch

	movea.l	map_collision_angles,a0				; Get collision angle
	move.b	(a0,d0.w),d1
	btst	#0,d1						; Is it a flat surface block?
	beq.s	.CheckAngleFlipX				; If not, branch
	moveq	#$FFFFFF80,d1					; Set flat surface angle
	bra.s	.SetAngle

.CheckAngleFlipX:
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.CheckAngleFlipY				; If not, branch
	neg.b	d1						; Flip the angle

.CheckAngleFlipY:
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.SetAngle					; If not, branch
	addi.b	#$40,d1						; Flip the angle
	neg.b	d1
	subi.b	#$40,d1

.SetAngle:
	move.b	d1,(a4)						; Set the angle

	lsl.w	#4,d0						; Get collision block data index
	move.w	d6,d1						; Get X position
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.NoFlipX					; If not, branch
	not.w	d1						; Invert the X position
	
.NoFlipX:
	andi.w	#$F,d1						; Get block column height
	add.w	d0,d1
	movea.l	map_collision_heights,a0
	move.b	(a0,d1.w),d0
	ext.w	d0

	btst	#$B,d4						; Is this block vertically flipped?
	bne.s	.FlipY						; If so, branch
	neg.w	d0						; Flip the height

.FlipY:
	tst.w	d0						; Check the height
	beq.w	.IsBlank					; If it's 0, branch
	bmi.s	.NegHeight					; If it's negative, branch
	cmpi.b	#$10,d0						; Is this a full height?
	beq.s	.MaxHeight					; If so, branch
	
	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d5,d4
	and.w	d1,d4
	add.w	d4,d0
	sub.w	d0,d1
	rts

.NegHeight:
	move.w	d5,d1						; Get how deep the object is into the block
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	.IsBlank					; If the object is outside of the block, branch

; ------------------------------------------------------------------------------

.MaxHeight:
	GET_BLOCK_DIST_DOWN GetMapBlockDistUp2, -16		; Check block down

; ------------------------------------------------------------------------------

GetMapBlockDistUp2:
	move.w	(a1),d1						; Get block ID
	move.w	d1,d4
	andi.w	#$3FF,d1
	beq.s	.IsBlank					; If it's blank, branch
	
	moveq	#$D,d0						; Get solidity bit to check
	add.b	map_collision_bit,d0
	
	btst	d0,d4						; Is the block solid?
	bne.s	.IsSolid					; If so, branch

.IsBlank:
	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d5,d0
	and.w	d1,d0
	sub.w	d0,d1
	rts

.IsSolid:
	movea.l	map_collision_layer,a0				; Get collision block ID
	moveq	#0,d0
	move.b	(a0,d1.w),d0
	beq.s	.IsBlank					; If it's blank, branch

	movea.l	map_collision_angles,a0				; Get collision angle
	move.b	(a0,d0.w),d1
	btst	#0,d1						; Is it a flat surface block?
	beq.s	.CheckAngleFlipX				; If not, branch
	moveq	#$FFFFFF80,d1					; Set flat surface angle
	bra.s	.SetAngle

.CheckAngleFlipX:
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.CheckAngleFlipY				; If not, branch
	neg.b	d1						; Flip the angle

.CheckAngleFlipY:
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.SetAngle					; If not, branch
	addi.b	#$40,d1						; Flip the angle
	neg.b	d1
	subi.b	#$40,d1

.SetAngle:
	move.b	d1,(a4)						; Set the angle

	lsl.w	#4,d0						; Get collision block data index
	move.w	d6,d1						; Get X position
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.NoFlipX					; If not, branch
	not.w	d1						; Invert the X position
	
.NoFlipX:
	andi.w	#$F,d1						; Get block column height
	add.w	d0,d1
	movea.l	map_collision_heights,a0
	move.b	(a0,d1.w),d0
	ext.w	d0

	btst	#$B,d4						; Is this block vertically flipped?
	bne.s	.FlipY						; If so, branch
	neg.w	d0						; Flip the height

.FlipY:
	tst.w	d0						; Check the height
	beq.s	.IsBlank					; If it's 0, branch
	bmi.s	.NegHeight					; If it's negative, branch
	
	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d5,d4
	and.w	d1,d4
	add.w	d4,d0
	sub.w	d0,d1
	rts

.NegHeight:
	move.w	d5,d1						; Get how deep the object is into the block
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	.IsBlank					; If the object is outside of the block, branch
	not.w	d1						; Flip the height
	rts

; ------------------------------------------------------------------------------
; Get the distance to the nearest block down
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Y position
;	d3.w - X position
;	a4.l - Angle buffer
; RETURNS:
;	d1.w - Distance from the block
; ------------------------------------------------------------------------------

GetMapBlockDistRight:
	move.w	d2,d5						; Save position
	move.w	d3,d6

	GET_BLOCK						; Get map block
	move.w	(a1),d1
	move.w	d1,d4
	andi.w	#$3FF,d1
	beq.s	.IsBlank					; If it's blank, branch

	moveq	#$D,d0						; Get solidity bit to check
	add.b	map_collision_bit,d0
	
	btst	d0,d4						; Is the block solid?
	bne.s	.IsSolid					; If so, branch

.IsBlank:
	GET_BLOCK_DIST_RIGHT GetMapBlockDistRight2, 16		; Check block to the right

.IsSolid:
	movea.l	map_collision_layer,a0				; Get collision block ID
	moveq	#0,d0
	move.b	(a0,d1.w),d0
	beq.s	.IsBlank					; If it's blank, branch

	movea.l	map_collision_angles,a0				; Get collision angle
	move.b	(a0,d0.w),d1
	btst	#0,d1						; Is it a flat surface block?
	beq.s	.CheckAngleFlipX				; If not, branch
	moveq	#$FFFFFFC0,d1					; Set flat surface angle
	bra.s	.SetAngle

.CheckAngleFlipX:
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.CheckAngleFlipY				; If not, branch
	neg.b	d1						; Flip the angle

.CheckAngleFlipY:
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.SetAngle					; If not, branch
	addi.b	#$40,d1						; Flip the angle
	neg.b	d1
	subi.b	#$40,d1

.SetAngle:
	move.b	d1,(a4)						; Set the angle

	lsl.w	#4,d0						; Get collision block data index
	move.w	d5,d1						; Get Y position
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.NoFlipY					; If not, branch
	not.w	d1						; Invert the Y position

.NoFlipY:
	andi.w	#$F,d1						; Get block row width
	add.w	d0,d1
	movea.l	map_collision_widths,a0
	move.b	(a0,d1.w),d0
	ext.w	d0

	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.NoFlipX					; If not, branch
	neg.w	d0						; Flip the width

.NoFlipX:
	tst.w	d0						; Check the width
	beq.w	.IsBlank					; If it's 0, branch
	bmi.s	.NegWidth					; If it's negative, branch
	cmpi.b	#$10,d0						; Is this a full width?
	beq.s	.MaxWidth					; If so, branch
	
	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d6,d4
	and.w	d1,d4
	add.w	d4,d0
	sub.w	d0,d1
	rts

.NegWidth:
	move.w	d6,d1						; Get how deep the object is into the block
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	.IsBlank					; If the object is outside of the block, branch

; ------------------------------------------------------------------------------

.MaxWidth:
	GET_BLOCK_DIST_LEFT GetMapBlockDistRight2, -16		; Check block to the left

; ------------------------------------------------------------------------------

GetMapBlockDistRight2:
	move.w	(a1),d1						; Get block ID
	move.w	d1,d4
	andi.w	#$3FF,d1
	beq.s	.IsBlank					; If it's blank, branch

	moveq	#$D,d0						; Get solidity bit to check
	add.b	map_collision_bit,d0
	
	btst	d0,d4						; Is the block solid?
	bne.s	.IsSolid					; If so, branch

.IsBlank:
	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d6,d0
	and.w	d1,d0
	sub.w	d0,d1
	rts

.IsSolid:
	movea.l	map_collision_layer,a0				; Get collision block ID
	moveq	#0,d0
	move.b	(a0,d1.w),d0
	beq.s	.IsBlank					; If it's blank, branch

	movea.l	map_collision_angles,a0				; Get collision angle
	move.b	(a0,d0.w),d1
	btst	#0,d1						; Is it a flat surface block?
	beq.s	.CheckAngleFlipX				; If not, branch
	moveq	#$FFFFFFC0,d1					; Set flat surface angle
	bra.s	.SetAngle

.CheckAngleFlipX:
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.CheckAngleFlipY				; If not, branch
	neg.b	d1						; Flip the angle

.CheckAngleFlipY:
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.SetAngle					; If not, branch
	addi.b	#$40,d1						; Flip the angle
	neg.b	d1
	subi.b	#$40,d1

.SetAngle:
	move.b	d1,(a4)						; Set the angle

	lsl.w	#4,d0						; Get collision block data index
	move.w	d5,d1						; Get Y position
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.NoFlipY					; If not, branch
	not.w	d1						; Invert the Y position
	
.NoFlipY:
	andi.w	#$F,d1						; Get block row width
	add.w	d0,d1
	movea.l	map_collision_widths,a0
	move.b	(a0,d1.w),d0
	ext.w	d0

	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.NoFlipX					; If not, branch
	neg.w	d0						; Flip the width

.NoFlipX:
	tst.w	d0						; Check the width
	beq.s	.IsBlank					; If it's 0, branch
	bmi.s	.NegWidth					; If it's negative, branch

	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d6,d4
	and.w	d1,d4
	add.w	d4,d0
	sub.w	d0,d1
	rts

.NegWidth:
	move.w	d6,d1						; Get how deep the object is into the block
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	.IsBlank					; If the object is outside of the block, branch
	not.w	d1						; Flip the width
	rts

; ------------------------------------------------------------------------------
; Get the distance to the nearest block up
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Y position
;	d3.w - X position
;	a4.l - Angle buffer
; RETURNS:
;	d1.w - Distance from the block
; ------------------------------------------------------------------------------

GetMapBlockDistLeft:
	eori.w	#$F,d3						; Invert X position
	move.w	d2,d5						; Save position
	move.w	d3,d6

	GET_BLOCK						; Get map block
	move.w	(a1),d1
	move.w	d1,d4
	andi.w	#$3FF,d1
	beq.s	.IsBlank					; If it's blank, branch
	
	moveq	#$D,d0						; Get solidity bit to check
	add.b	map_collision_bit,d0
	
	btst	d0,d4						; Is the block solid?
	bne.s	.IsSolid					; If so, branch

.IsBlank:
	GET_BLOCK_DIST_LEFT GetMapBlockDistLeft2, 16		; Check block to the left

.IsSolid:
	movea.l	map_collision_layer,a0				; Get collision block ID
	moveq	#0,d0
	move.b	(a0,d1.w),d0
	beq.s	.IsBlank					; If it's blank, branch

	movea.l	map_collision_angles,a0				; Get collision angle
	move.b	(a0,d0.w),d1
	btst	#0,d1						; Is it a flat surface block?
	beq.s	.CheckAngleFlipX				; If not, branch
	moveq	#$40,d1						; Set flat surface angle
	bra.s	.SetAngle

.CheckAngleFlipX:
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.CheckAngleFlipY				; If not, branch
	neg.b	d1						; Flip the angle

.CheckAngleFlipY:
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.SetAngle					; If not, branch
	addi.b	#$40,d1						; Flip the angle
	neg.b	d1
	subi.b	#$40,d1

.SetAngle:
	move.b	d1,(a4)						; Set the angle

	lsl.w	#4,d0						; Get collision block data index
	move.w	d5,d1						; Get Y position
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.NoFlipY					; If not, branch
	not.w	d1						; Invert the Y position

.NoFlipY:
	andi.w	#$F,d1						; Get block row width
	add.w	d0,d1
	movea.l	map_collision_widths,a0
	move.b	(a0,d1.w),d0
	ext.w	d0

	btst	#$A,d4						; Is this block horizontally flipped?
	bne.s	.FlipX						; If so, branch
	neg.w	d0						; Flip the width

.FlipX:
	tst.w	d0						; Check the width
	beq.w	.IsBlank					; If it's 0, branch
	bmi.s	.NegWidth					; If it's negative, branch
	cmpi.b	#$10,d0						; Is this a full width?
	beq.s	.MaxWidth					; If so, branch
	
	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d6,d4
	and.w	d1,d4
	add.w	d4,d0
	sub.w	d0,d1
	rts

.NegWidth:
	move.w	d6,d1						; Get how deep the object is into the block
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	.IsBlank					; If the object is outside of the block, branch

; ------------------------------------------------------------------------------

.MaxWidth:
	GET_BLOCK_DIST_RIGHT GetMapBlockDistLeft2, -16		; Check block to the right

; ------------------------------------------------------------------------------

GetMapBlockDistLeft2:
	move.w	(a1),d1						; Get block ID
	move.w	d1,d4
	andi.w	#$3FF,d1
	beq.s	.IsBlank					; If it's blank, branch
	
	moveq	#$D,d0						; Get solidity bit to check
	add.b	map_collision_bit,d0
	
	btst	d0,d4						; Is the block solid?
	bne.s	.IsSolid					; If so, branch

.IsBlank:
	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d6,d0
	and.w	d1,d0
	sub.w	d0,d1
	rts

.IsSolid:
	movea.l	map_collision_layer,a0				; Get collision block ID
	moveq	#0,d0
	move.b	(a0,d1.w),d0
	beq.s	.IsBlank					; If it's blank, branch

	movea.l	map_collision_angles,a0				; Get collision angle
	move.b	(a0,d0.w),d1
	btst	#0,d1						; Is it a flat surface block?
	beq.s	.CheckAngleFlipX				; If not, branch
	moveq	#$40,d1						; Set flat surface angle
	bra.s	.SetAngle

.CheckAngleFlipX:
	btst	#$A,d4						; Is this block horizontally flipped?
	beq.s	.CheckAngleFlipY				; If not, branch
	neg.b	d1						; Flip the angle

.CheckAngleFlipY:
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.SetAngle					; If not, branch
	addi.b	#$40,d1						; Flip the angle
	neg.b	d1
	subi.b	#$40,d1

.SetAngle:
	move.b	d1,(a4)						; Set the angle

	lsl.w	#4,d0						; Get collision block data index
	move.w	d5,d1						; Get Y position
	btst	#$B,d4						; Is this block vertically flipped?
	beq.s	.NoFlipY					; If not, branch
	not.w	d1						; Invert the Y position

.NoFlipY:
	andi.w	#$F,d1						; Get block row width
	add.w	d0,d1
	movea.l	map_collision_widths,a0
	move.b	(a0,d1.w),d0
	ext.w	d0

	btst	#$A,d4						; Is this block horizontally flipped?
	bne.s	.FlipX						; If so, branch
	neg.w	d0						; Flip the width

.FlipX:
	tst.w	d0						; Check the width
	beq.s	.IsBlank					; If it's 0, branch
	bmi.s	.NegWidth					; If it's negative, branch
	
	moveq	#$F,d1						; Get how deep the object is into the block
	move.w	d6,d4
	and.w	d1,d4
	add.w	d4,d0
	sub.w	d0,d1
	rts

.NegWidth:
	move.w	d6,d1						; Get how deep the object is into the block
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	.IsBlank					; If the object is outside of the block, branch
	not.w	d1						; Flip the width
	rts

; ------------------------------------------------------------------------------
; Initialize map object spawning
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Object index address
; ------------------------------------------------------------------------------

InitMapObjectSpawn:
	subq.l	#4,a0						; Set object index
	move.l	a0,map_object_index

	lea	map_obj_states,a0				; Clear object states
	move.w	#OBJ_STATE_SLOTS,d0
	bsr.w	ClearMemory

	movea.l	map_objects,a0					; Object data
	movea.l	map_object_index,a2				; Object index
	lea	map_obj_states,a3				; Object states

	move.b	camera_fg_x_draw,d0				; Get current chunk
	move.b	camera_fg_y_draw,d1
	ext.w	d0
	ext.w	d1

	subq.w	#1,d0						; (-256, -256)
	subq.w	#1,d1
	bsr.w	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (0, -256)
	bsr.w	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (256, -256)
	bsr.w	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (512, -256)
	bsr.w	SpawnMapObjectChunk

	subq.w	#3,d0						; (-256, 0)
	addq.w	#1,d1
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (0, 0)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (256, 0)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (512, 0)
	bsr.w	SpawnMapObjectChunk

	subq.w	#3,d0						; (-256, 256)
	addq.w	#1,d1
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (0, 256)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (256, 256)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (512, 256)
	bsr.w	SpawnMapObjectChunk

	subq.w	#3,d0						; (-256, 512)
	addq.w	#1,d1
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (0, 512)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (256, 512)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (512, 512)
	bra.w	SpawnMapObjectChunk

; ------------------------------------------------------------------------------
; Spawn map objects
; ------------------------------------------------------------------------------

SpawnMapObjects:
	movea.l	map_objects,a0					; Object data
	movea.l	map_object_index,a2				; Object index
	lea	map_obj_states,a3				; Object states

	move.b	camera_fg_x_draw,d0				; Get current chunk
	move.b	camera_fg_y_draw,d1
	ext.w	d0
	ext.w	d1

	move.b	map_obj_chunk_x,d2				; Get previous chunk
	move.b	map_obj_chunk_y,d3
	move.b	d0,map_obj_chunk_x
	move.b	d1,map_obj_chunk_y

	cmp.b	d2,d0						; Have we moved horizontally?
	blt.w	.Left						; If we moved left, branch
	bgt.w	.Right						; If we moved right, branch
	
	cmp.b	d3,d1						; Have we moved vertically?
	blt.s	.Up						; If we moved up, branch
	bgt.s	.Down						; If we moved down, branch
	rts

; ------------------------------------------------------------------------------

.Up:
	subq.w	#1,d0						; (-256, -256)
	subq.w	#1,d1
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (0, -256)
	bsr.w	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (256, -256)
	bsr.w	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (512, -256)
	bra.w	SpawnMapObjectChunk
	
; ------------------------------------------------------------------------------

.Down:
	subq.w	#1,d0						; (-256, 512)
	addq.w	#2,d1
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (0, 512)
	bsr.w	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (256, 512)
	bsr.w	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (512, 512)
	bra.w	SpawnMapObjectChunk

; ------------------------------------------------------------------------------

.Left:
	cmp.w	d3,d1						; Have we moved vertically?
	blt.s	.LeftUp						; If we moved up, branch
	bgt.w	.LeftDown					; If we moved down, branch
	
	subq.w	#1,d0						; (-256, -256)
	subq.w	#1,d1
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d1						; (-256, 0)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d1						; (-256, 256)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d1						; (-256, 512)
	bra.w	SpawnMapObjectChunk

; ------------------------------------------------------------------------------

.Right:
	cmp.w	d3,d1						; Have we moved vertically?
	blt.w	.RightUp					; If we moved up, branch
	bgt.w	.RightDown					; If we moved down, branch
	
	addq.w	#2,d0						; (512, -256)
	subq.w	#1,d1
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d1						; (512, 0)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d1						; (512, 256)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d1						; (512, 512)
	bra.w	SpawnMapObjectChunk
	
; ------------------------------------------------------------------------------

.LeftUp:
	subq.w	#1,d0						; (-256, 512)
	addq.w	#2,d1
	bsr.w	SpawnMapObjectChunk

	subq.w	#1,d1						; (-256, 256)
	bsr.w	SpawnMapObjectChunk 

	subq.w	#1,d1						; (-256, 0)
	bsr.w	SpawnMapObjectChunk 

	subq.w	#1,d1						; (-256, -256)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (0, -256)
	bsr.w	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (256, -256)
	bsr.w	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (512, -256)
	bra.w	SpawnMapObjectChunk
	
; ------------------------------------------------------------------------------

.LeftDown:
	subq.w	#1,d0						; (-256, -256)
	subq.w	#1,d1
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d1						; (-256, 0)
	bsr.w	SpawnMapObjectChunk 

	addq.w	#1,d1						; (-256, 256)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d1						; (-256, 512)
	bsr.w	SpawnMapObjectChunk

	addq.w	#1,d0						; (0, 512)
	bsr.w	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (256, 512)
	bsr.w	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (512, 512)
	bra.w	SpawnMapObjectChunk
	
; ------------------------------------------------------------------------------

.RightUp:
	subq.w	#1,d0						; (-256, -256)
	subq.w	#1,d1
	bsr.s	SpawnMapObjectChunk

	addq.w	#1,d0						; (0, -256)
	bsr.s	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (256, -256)
	bsr.s	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (512, -256)
	bsr.s	SpawnMapObjectChunk

	addq.w	#1,d1						; (512, 0)
	bsr.s	SpawnMapObjectChunk

	addq.w	#1,d1						; (512, 256)
	bsr.s	SpawnMapObjectChunk

	addq.w	#1,d1						; (512, 512)
	bra.s	SpawnMapObjectChunk
	
; ------------------------------------------------------------------------------

.RightDown:
	subq.w	#1,d0						; (-256, 512)
	addq.w	#2,d1
	bsr.s	SpawnMapObjectChunk

	addq.w	#1,d0						; (0, 512)
	bsr.s	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (256, 512)
	bsr.s	SpawnMapObjectChunk
	
	addq.w	#1,d0						; (512, 512)
	bsr.s	SpawnMapObjectChunk

	subq.w	#1,d1						; (512, 256)
	bsr.s	SpawnMapObjectChunk

	subq.w	#1,d1						; (512, 0)
	bsr.s	SpawnMapObjectChunk

	subq.w	#1,d1						; (512, -256)

; ------------------------------------------------------------------------------
; Spawn objects map object chunk
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Chunk X index
;	d1.w - Chunk Y index
;	a0.l - Object layout address
; ------------------------------------------------------------------------------

SpawnMapObjectChunk:
	movem.l	d0-d1,-(sp)					; Save registers

	cmp.w	(a0),d0						; Is the X index too large?
	bcc.s	.End						; If so, branch
	cmp.w	2(a0),d1					; Is the Y index too large?
	bcc.s	.End						; If so, branch

	add.w	d1,d1						; Get row address
	move.w	4(a0,d1.w),d1
	bmi.s	.End
	lea	(a0,d1.w),a4

	add.w	d0,d0						; Get chunk address
	move.w	(a4,d0.w),d0
	bmi.s	.End						; If it's null, branch
	lea	(a0,d0.w),a4

	move.w	(a4)+,d1					; Get number of objects to spawn
	subq.w	#1,d1
	bmi.s	.End						; If there are none, branch

.Spawn:
	move.w	(a4)+,d3					; Get state entry
	add.w	d3,d3

	movem.l	d1/a0/a2,-(sp)					; Save registers

	tst.b	(a3,d3.w)					; Has this object already been spawned?
	bmi.s	.Skip						; If so, branch
	
	bsr.w	SpawnObject					; Spawn object
	bne.s	.Skip						; If it failed, branch
	bset	#7,(a3,d3.w)					; Mark object as spawned
	
	movem.l	(sp)+,d1/a0/a2					; Restore registers

	add.w	a3,d3						; Set state entry address
	move.w	d3,obj.state(a1)

	moveq	#0,d0						; Set update routine
	move.b	(a4)+,d0
	add.w	d0,d0
	add.w	d0,d0
	move.l	(a2,d0.w),obj.update(a1)

	move.b	(a4)+,obj.flags(a1)				; Set flags

	move.w	(a4)+,obj.x(a1)					; Set position
	move.w	(a4)+,obj.y(a1)

	move.w	(a4)+,obj.subtype(a1)				; Set subtypes

	dbf	d1,.Spawn					; Loop until objects are spawned
	movem.l	(sp)+,d0-d1					; Restore registers
	rts

.Skip:
	movem.l	(sp)+,d1/a0/a2					; Restore registers

	addq.w	#8,a4						; Skip object
	dbf	d1,.Spawn					; Loop until objects are spawned

.End:
	movem.l	(sp)+,d0-d1					; Restore registers
	rts

; ------------------------------------------------------------------------------
; Map initialization event
; ------------------------------------------------------------------------------

MapInitEvent:
	move.l	map_initialize,d0				; Get events routine
	beq.s	.End						; If it's not set, branch
	
	movea.l	d0,a0						; Run events routine
	jmp	(a0)
	
.End:
	rts

; ------------------------------------------------------------------------------
; Map draw event
; ------------------------------------------------------------------------------

MapDrawEvent:
	move.l	map_events,d0					; Get events routine
	beq.s	.End						; If it's not set, branch
	
	movea.l	d0,a0						; Run events routine
	jmp	(a0)
	
.End:
	rts

; ------------------------------------------------------------------------------
; Scroll map
; ------------------------------------------------------------------------------

ScrollMap:
	move.l	map_scroll,d0					; Get scroll routine
	beq.s	.End						; If it's not set, branch
	
	movea.l	d0,a0						; Run scroll routine
	jmp	(a0)
	
.End:
	rts

; ------------------------------------------------------------------------------
