; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; 32X functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/framework/md.inc"
	
; ------------------------------------------------------------------------------
; Initialize 32X graphics
; ------------------------------------------------------------------------------

InitMarsGraphics:
	bsr.w	UnloadMarsSprites				; Unload 32X sprites
	
	move.w	#0,-(sp)					; Clear 32X palette
	move.b	#0,-(sp)
	move.w	#$100,-(sp)
	bsr.w	FillMarsPalette

	bsr.w	ClearMarsScreen					; Clear 32X screen (buffer 1)
	bsr.s	SendMarsGraphicsCmds
	bsr.s	WaitMars

	bsr.w	ClearMarsScreen					; Clear 32X screen (buffer 2)
	bsr.s	SendMarsGraphicsCmds

; ------------------------------------------------------------------------------
; Wait for the 32X to not be busy
; ------------------------------------------------------------------------------

WaitMars:
	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr

.Wait:
	jsr	CheckSh2Error					; Check for errors
	tst.w	MARS_COMM_4+MARS_SYS				; Are the commands finished being processed?
	bne.s	.Wait						; If not, wait

	move	(sp)+,sr					; Restore interrupt settings
	rts

; ------------------------------------------------------------------------------
; Send graphics commands
; ------------------------------------------------------------------------------

SendMarsGraphicsCmds:
	lea	mars_draw_buffer,a1				; Get draw commands
	movea.w	mars_draw_slot,a2
	move.w	a1,mars_draw_slot

	cmpa.w	a1,a2						; Are there any commands to send?
	beq.s	.GfxDataCmds					; If not, branch
	tst.b	MARS_COMM_4+MARS_SYS				; Are the draw commands finished being processed?
	bne.s	.GfxDataCmds					; If so, branch
	
	moveq	#0,d2						; Send commands
	bsr.s	SendMarsData
	
.GfxDataCmds:
	tst.b	MARS_COMM_5+MARS_SYS				; Are the graphics data commands finished being processed?
	bne.s	.End						; If so, branch

	lea	mars_gfx_buffer,a1				; Get graphics data commands
	movea.w	mars_gfx_slot,a2
	move.w	a1,mars_gfx_slot

	cmpa.w	a1,a2						; Are there any commands to send?
	beq.s	.End						; If not, branch
	
	moveq	#2,d2						; Send commands
	bsr.s	SendMarsData
	
.End:
	rts

; ------------------------------------------------------------------------------
; Send data to the 32X
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.b - DMA command ID
;	a1.l - Data buffer
;	a2.l - End of data buffer
; ------------------------------------------------------------------------------

SendMarsData:
	clr.w	(a2)+						; Set terminator
	move.w	a2,d1						; Get length of graphics command data
	sub.w	a1,d1

	addq.w	#7,d1						; Get DREQ length
	andi.w	#$FFF8,d1
	beq.s	.End
	lsr.w	#1,d1

	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr

	lea	MARS_SYS+MARS_DREQ_FIFO,a2			; Start DREQ and DMA
	move.w	d1,MARS_DREQ_LENGTH-MARS_DREQ_FIFO(a2)
	move.b	#1<<BIT_D68S,MARS_DREQ_CTRL-MARS_DREQ_FIFO(a2)
	move.b	d2,MARS_COMM_6-MARS_DREQ_FIFO(a2)
	CMD_INT 1,0

	lsr.w	#2,d1						; Get loop count
	subq.w	#1,d1

.Send:
	move.w	(a1)+,(a2)					; Send data
	move.w	(a1)+,(a2)
	move.w	(a1)+,(a2)
	move.w	(a1)+,(a2)
	WAIT_DREQ
	dbf	d1,.Send					; Loop until all data is sent

	addq.b	#1,d2						; Finish DMA
	move.b	d2,MARS_COMM_6-MARS_DREQ_FIFO(a2)
	CMD_INT 1,0

	move	(sp)+,sr					; Restore interrupt settings

.End:
	rts

; ------------------------------------------------------------------------------
; Wait for the draw commands to be processed
; ------------------------------------------------------------------------------

WaitMarsDraw:
	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr

.Wait:
	jsr	CheckSh2Error					; Check for errors
	tst.b	MARS_COMM_4+MARS_SYS				; Are the graphics data commands finished being processed?
	bne.s	.Wait						; If not, wait

	move	(sp)+,sr					; Restore interrupt settings
	rts

; ------------------------------------------------------------------------------
; Wait for the graphics data commands to be processed
; ------------------------------------------------------------------------------

WaitMarsGraphicsData:
	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr

.Wait:
	jsr	CheckSh2Error					; Check for errors
	tst.b	MARS_COMM_5+MARS_SYS				; Are the graphics data commands finished being processed?
	bne.s	.Wait						; If not, 
	
	move	(sp)+,sr					; Restore interrupt settings
	rts

; ------------------------------------------------------------------------------
; Prepare draw command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w  - Length of draw command
; RETURNS:
;	cc/cs - Draw command buffer full/Success
;	a1.l  - Draw command buffer slot
; ------------------------------------------------------------------------------

PrepareMarsDrawCmd:
	movea.w	mars_draw_slot,a1				; Get draw command buffer slot
	add.w	d0,a1						; Add command length
	cmpa.w	#mars_draw_slot-2,a1				; Is the buffer too full?
	bcc.s	.End						; If so, branch
	
	move.w	a1,mars_draw_slot				; Advance slot
	sub.w	d0,a1						; Get start of slot
	ori	#1,sr						; Success

.End:
	rts

; ------------------------------------------------------------------------------
; Prepare graphics data command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w  - Length of graphics data command
; RETURNS:
;	cc/cs - Graphics data command buffer full/Success
;	a1.l  - Graphics data command buffer slot
; ------------------------------------------------------------------------------

PrepareMarsGfxDataCmd:
	movea.w	mars_gfx_slot,a1				; Get graphics data command buffer slot
	add.w	d0,a1						; Add command length
	cmpa.w	#mars_gfx_slot-2,a1				; Is the buffer too full?
	bcc.s	.End						; If so, branch
	
	move.w	a1,mars_gfx_slot				; Advance slot
	sub.w	d0,a1						; Get start of slot
	ori	#1,sr						; Success

.End:
	rts

; ------------------------------------------------------------------------------
; Clear screen
; ------------------------------------------------------------------------------

ClearMarsScreen:
	moveq	#2,d0						; Prepare draw command slot
	bsr.s	PrepareMarsDrawCmd
	bcc.s	.End						; If the draw command buffer is too full, branch
	move.w	#$100,(a1)					; Command ID

.End:
	rts

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).w  - Y scale
;	2(sp).w  - X scale
;	4(sp).w  - Y position
;	6(sp).w  - X position
;	8(sp).b  - Flip flags (bit 0 = X flip, bit 1 = Y flip)
;	$A(sp).b - CRAM index
;	$C(sp).b - Sprite frame ID
;	$E(sp).l - Sprite data address in SH-2 space
; ------------------------------------------------------------------------------

DrawMarsSprite:
	moveq	#$12,d0						; Prepare draw command slot
	bsr.s	PrepareMarsDrawCmd
	bcc.s	.End						; If the draw command buffer is too full, branch
	
	move.w	#$200,(a1)+					; Command ID
	move.b	#1,(a1)+					; Draw sprite dynamically
	move.b	$A+4(sp),(a1)+					; CRAM index
	move.w	$E+2+4(sp),(a1)+				; Sprite data address
	move.w	$E+4(sp),(a1)+
	move.b	$C+4(sp),(a1)+					; Sprite frame ID
	move.b	8+4(sp),(a1)+					; Flip flags
	move.w	6+4(sp),(a1)+					; X position
	move.w	4+4(sp),(a1)+					; Y position
	move.w	2+4(sp),(a1)+					; X scale
	move.w	0+4(sp),(a1)+					; Y scale

.End:
	move.l	(sp),$12(sp)					; Deallocate variables and exit
	lea	$12(sp),sp
	rts

; ------------------------------------------------------------------------------
; Draw loaded sprite
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).w  - Y scale
;	2(sp).w  - X scale
;	4(sp).w  - Y position
;	6(sp).w  - X position
;	8(sp).b  - Flip flags (bit 0 = X flip, bit 1 = Y flip)
;	$A(sp).b - Sprite frame ID
;	$C(sp).b - ID number
; ------------------------------------------------------------------------------

DrawLoadedMarsSprite:
	moveq	#$E,d0						; Prepare draw command slot
	bsr.w	PrepareMarsDrawCmd
	bcc.s	.End						; If the draw command buffer is too full, branch
	
	move.b	#2,(a1)+					; Command ID
	move.b	$C+4(sp),(a1)+					; ID number
	clr.w	(a1)+						; Draw loaded sprite
	move.b	$A+4(sp),(a1)+					; Sprite frame ID
	move.b	8+4(sp),(a1)+					; Flip flags
	move.w	6+4(sp),(a1)+					; X position
	move.w	4+4(sp),(a1)+					; Y position
	move.w	2+4(sp),(a1)+					; X scale
	move.w	0+4(sp),(a1)+					; Y scale
	
.End:
	move.l	(sp),$E(sp)					; Deallocate variables and exit
	lea	$E(sp),sp
	rts

; ------------------------------------------------------------------------------
; Draw line
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).w - Y position 2
;	2(sp).w - X position 2
;	4(sp).w - Y position 1
;	6(sp).w - X position 1
;	8(sp).b - CRAM index
; ------------------------------------------------------------------------------

DrawMarsLine:
	moveq	#$A,d0						; Prepare draw command slot
	bsr.w	PrepareMarsDrawCmd
	bcc.s	.End						; If the draw command buffer is too full, branch
	
	move.b	#3,(a1)+					; Command ID
	move.b	8+4(sp),(a1)+					; CRAM index
	move.w	6+4(sp),(a1)+					; X position 1
	move.w	4+4(sp),(a1)+					; Y position 1
	move.w	2+4(sp),(a1)+					; X position 2
	move.w	0+4(sp),(a1)+					; Y position 2
	
.End:
	move.l	(sp),$A(sp)					; Deallocate variables and exit
	lea	$A(sp),sp
	rts

; ------------------------------------------------------------------------------
; Draw 2D shape
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).b - Draw mode (0 = Corners, 1 = Wireframe, 2 = Solid)
;	2(sp).b - CRAM index
;	4(sp).l - Shape data address
; ------------------------------------------------------------------------------

DrawMarsShape2d:
	movea.l	4+4(sp),a2					; Get shape data
	
	move.w	(a2)+,d0					; Get number of vertices
	move.w	d0,d1
	beq.s	.End						; If there are no vertices, branch
	bmi.s	.End						; If there are no vertices, branch

	add.w	d0,d0						; Prepare draw command slot
	add.w	d0,d0
	addq.w	#4,d0
	bsr.w	PrepareMarsDrawCmd
	bcc.s	.End						; If the draw command buffer is too full, branch
	
	move.b	#4,(a1)+					; Command ID
	move.b	2+4(sp),(a1)+					; CRAM index
	move.b	0+4(sp),(a1)+					; Draw mode
	move.b	d1,(a1)+					; Vertex count
	
	subq.w	#1,d1						; Set loop count

.Vertices:
	move.l	(a2)+,(a1)+					; Set vertex
	dbf	d1,.Vertices					; Loop until all vertices are set

.End:
	move.l	(sp),8(sp)					; Deallocate variables and exit
	addq.w	#8,sp
	rts

; ------------------------------------------------------------------------------
; Draw 3D shape
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).w   - Z position
;	2(sp).w   - Y position
;	4(sp).w   - X position
;	6(sp).b   - Roll rotation
;	8(sp).b   - Yaw rotation
;	$A(sp).b  - Pitch rotation
;	$C(sp).b  - Draw mode (0 = Corners, 1 = Wireframe, 2 = Solid)
;	$E(sp).b  - CRAM index
;	$10(sp).l - Shape data address in SH-2 space
; ------------------------------------------------------------------------------

DrawMarsShape3d:
	moveq	#$12,d0						; Prepare draw command slot
	bsr.w	PrepareMarsDrawCmd
	bcc.s	.End						; If the draw command buffer is too full, branch
	
	move.w	#$500,(a1)+					; Command ID
	move.b	$E+4(sp),(a1)+					; CRAM index
	move.b	$C+4(sp),(a1)+					; Draw mode
	move.w	$10+2+4(sp),(a1)+				; Shape data address
	move.w	$10+4(sp),(a1)+
	move.b	$A+4(sp),(a1)+					; Pitch rotation
	move.b	8+4(sp),(a1)+					; Yaw rotation
	move.b	6+4(sp),(a1)+					; Roll rotation
	clr.b	(a1)+
	move.w	4+4(sp),(a1)+					; X position
	move.w	2+4(sp),(a1)+					; Y position
	move.w	0+4(sp),(a1)+					; Z position
	
.End:
	move.l	(sp),$14(sp)					; Deallocate variables and exit
	lea	$14(sp),sp
	rts

; ------------------------------------------------------------------------------
; Draw distorted sprite
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).w   - Y distortion intensity
;	2(sp).w   - Bottom distortion
;	4(sp).w   - Top distortion
;	6(sp).w   - Y scale
;	8(sp).w   - X distortion intensity
;	$A(sp).w  - Right distortion
;	$C(sp).w  - Left distortion
;	$E(sp).w  - X scale
;	$10(sp).w - Y position
;	$12(sp).w - X position
;	$14(sp).b - Flip flags (bit 0 = X flip, bit 1 = Y flip)
;	$16(sp).b - CRAM index
;	$18(sp).b - Sprite frame ID
;	$1A(sp).l - Sprite data address in SH-2 space
; ------------------------------------------------------------------------------

DrawDistortedMarsSprite:
	moveq	#$1E,d0						; Prepare draw command slot
	bsr.w	PrepareMarsDrawCmd
	bcc.s	.End						; If the draw command buffer is too full, branch

	move.w	#$600,(a1)+					; Command ID
	move.b	#1,(a1)+					; Draw sprite dynamically
	move.b	$16+4(sp),(a1)+					; CRAM index
	move.w	$1A+2+4(sp),(a1)+				; Sprite data address
	move.w	$1A+4(sp),(a1)+
	move.b	$18+4(sp),(a1)+					; Sprite frame ID
	move.b	$14+4(sp),(a1)+					; Flip flags
	move.w	$12+4(sp),(a1)+					; X position
	move.w	$10+4(sp),(a1)+					; Y position
	move.w	$E+4(sp),(a1)+					; X scale
	move.w	$C+4(sp),(a1)+					; Left distortion
	move.w	$A+4(sp),(a1)+					; Right distortion
	move.w	8+4(sp),(a1)+					; X distortion intensity
	move.w	6+4(sp),(a1)+					; Y scale
	move.w	4+4(sp),(a1)+					; Top distortion
	move.w	2+4(sp),(a1)+					; Bottom distortion
	move.w	0+4(sp),(a1)+					; Y distortion intensity

.End:
	move.l	(sp),$1E(sp)					; Deallocate variables and exit
	lea	$1E(sp),sp
	rts

; ------------------------------------------------------------------------------
; Draw distorted loaded sprite
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).w   - Y distortion intensity
;	2(sp).w   - Bottom distortion
;	4(sp).w   - Top distortion
;	6(sp).w   - Y scale
;	8(sp).w   - X distortion intensity
;	$A(sp).w  - Right distortion
;	$C(sp).w  - Left distortion
;	$E(sp).w  - X scale
;	$10(sp).w - Y position
;	$12(sp).w - X position
;	$14(sp).b - Flip flags (bit 0 = X flip, bit 1 = Y flip)
;	$16(sp).b - Sprite frame ID
;	$18(sp).b - ID number
; ------------------------------------------------------------------------------

DrawDistortedLoadedMarsSprite:
	moveq	#$1A,d0						; Prepare draw command slot
	bsr.w	PrepareMarsDrawCmd
	bcc.s	.End						; If the draw command buffer is too full, branch
	
	move.b	#6,(a1)+					; Command ID
	move.b	$18+4(sp),(a1)+					; ID number
	clr.w	(a1)+						; Draw loaded sprite
	move.b	$16+4(sp),(a1)+					; Sprite frame ID
	move.b	$14+4(sp),(a1)+					; Flip flags
	move.w	$12+4(sp),(a1)+					; X position
	move.w	$10+4(sp),(a1)+					; Y position
	move.w	$E+4(sp),(a1)+					; X scale
	move.w	$C+4(sp),(a1)+					; Left distortion
	move.w	$A+4(sp),(a1)+					; Right distortion
	move.w	8+4(sp),(a1)+					; X distortion intensity
	move.w	6+4(sp),(a1)+					; Y scale
	move.w	4+4(sp),(a1)+					; Top distortion
	move.w	2+4(sp),(a1)+					; Bottom distortion
	move.w	0+4(sp),(a1)+					; Y distortion intensity

.End:
	move.l	(sp),$1A(sp)					; Deallocate variables and exit
	lea	$1A(sp),sp
	rts

; ------------------------------------------------------------------------------
; Draw chain of loaded sprites
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).l - Chain data address
;	4(sp).b - ID number
; ------------------------------------------------------------------------------

DrawLoadedMarsSpriteChain:
	movea.l	0+4(sp),a2					; Get chain data

	move.w	(a2)+,d0					; Get number of sprites
	move.w	d0,d1
	beq.s	.End						; If there are no sprites, branch
	bmi.s	.End						; If there are no sprites, branch
	
	add.w	d0,d0						; Prepare draw command slot
	move.w	d0,d2
	add.w	d0,d0
	add.w	d2,d0
	addq.w	#4,d0
	bsr.w	PrepareMarsDrawCmd
	bcc.s	.End						; If the draw command buffer is too full, branch

	move.b	#7,(a1)+					; Command ID
	move.b	4+4(sp),(a1)+					; ID number
	move.w	d1,(a1)+					; Sprite count
	
	subq.w	#1,d1						; Set loop count

.Sprites:
	move.l	(a2)+,(a1)+					; Set sprite
	move.w	(a2)+,(a1)+
	dbf	d1,.Sprites					; Loop until all sprites are set

.End:
	move.l	(sp),6(sp)					; Deallocate variables and exit
	lea	6(sp),sp
	rts

; ------------------------------------------------------------------------------
; Load sprites
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).b - CRAM index
;	2(sp).b - ID number
;	4(sp).l - Sprite data address in SH-2 space
; ------------------------------------------------------------------------------

LoadMarsSprites:
	moveq	#8,d0						; Prepare graphics data command slot
	bsr.w	PrepareMarsGfxDataCmd
	bcc.s	.End						; If the graphics data command buffer is too full, branch
	
	move.w	#$100,(a1)+					; Command ID
	move.b	2+4(sp),(a1)+					; ID number
	move.b	0+4(sp),(a1)+					; CRAM index
	move.w	4+2+4(sp),(a1)+					; Sprite data address
	move.w	4+4(sp),(a1)+

.End:
	move.l	(sp),8(sp)					; Deallocate variables and exit
	addq.w	#8,sp
	rts

; ------------------------------------------------------------------------------
; Load sprite list
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).l - Sprite list address
; ------------------------------------------------------------------------------

LoadMarsSpriteList:
	movea.l	0+4(sp),a2					; Get sprite list

	move.w	(a2)+,d1					; Get number of sprites
	bmi.s	.End						; If there are none, branch

.LoadSprites:
	moveq	#8,d0						; Prepare graphics data command slot
	bsr.w	PrepareMarsGfxDataCmd
	bcc.s	.End						; If the graphics data command buffer is too full, branch
	
	move.w	#$100,(a1)+					; Command ID
	move.w	4(a2),(a1)+					; ID number and CRAM index
	move.w	2(a2),(a1)+					; Sprite data address
	move.w	(a2),(a1)+

	addq.w	#6,a2						; Next set of sprites
	dbf	d1,.LoadSprites					; Loop until finished

.End:
	move.l	(sp),4(sp)					; Deallocate variables and exit
	addq.w	#4,sp
	rts

; ------------------------------------------------------------------------------
; Unload sprites
; ------------------------------------------------------------------------------

UnloadMarsSprites:
	moveq	#2,d0						; Prepare graphics data command slot
	bsr.w	PrepareMarsGfxDataCmd
	bcc.s	.End						; If the graphics data command buffer is too full, branch
	move.w	#$200,(a1)					; Command ID

.End:
	rts

; ------------------------------------------------------------------------------
; Load palette
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).b - Swap priority (0 = no, 1 = yes)
;	2(sp).b - Starting CRAM index
;	4(sp).l - Palette data address in SH-2 space
; ------------------------------------------------------------------------------

LoadMarsPalette:
	moveq	#8,d0						; Prepare graphics data command slot
	bsr.w	PrepareMarsGfxDataCmd
	bcc.s	.End						; If the graphics data command buffer is too full, branch
	
	move.w	#$300,(a1)+					; Command ID
	move.w	4+2+4(sp),(a1)+					; Palette data address
	move.w	4+4(sp),(a1)+
	move.b	2+4(sp),(a1)+					; Starting CRAM index
	move.b	0+4(sp),(a1)+					; Swap priority

.End:
	move.l	(sp),8(sp)					; Deallocate variables and exit
	addq.w	#8,sp
	rts

; ------------------------------------------------------------------------------
; Load palette list
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).l - Palette list address
; ------------------------------------------------------------------------------

LoadMarsPaletteList:
	movea.l	0+4(sp),a2					; Get palette list

	move.w	(a2)+,d1					; Get number of palettes
	bmi.s	.End						; If there are none, branch

.LoadPalettes:
	moveq	#8,d0						; Prepare graphics data command slot
	bsr.w	PrepareMarsGfxDataCmd
	bcc.s	.End						; If the graphics data command buffer is too full, branch
	
	move.w	#$300,(a1)+					; Command ID
	move.w	2(a2),(a1)+					; Palette data address
	move.w	(a2),(a1)+
	move.w	4(a2),(a1)+					; Starting CRAM index

	addq.w	#6,a2						; Next palette
	dbf	d1,.LoadPalettes				; Loop until finished

.End:
	move.l	(sp),4(sp)					; Deallocate variables and exit
	addq.w	#4,sp
	rts

; ------------------------------------------------------------------------------
; Set color
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).b - CRAM index
;	2(sp).w - Color value
; ------------------------------------------------------------------------------

SetMarsColor:
	moveq	#6,d0						; Prepare graphics data command slot
	bsr.w	PrepareMarsGfxDataCmd
	bcc.s	.End						; If the graphics data command buffer is too full, branch

	move.w	#$400,(a1)+					; Command ID
	clr.b	(a1)+						; CRAM selection length
	move.b	0+4(sp),(a1)+					; Starting CRAM index
	move.w	2+4(sp),(a1)+					; Color value

.End:
	move.l	(sp),4(sp)					; Deallocate variables and exit
	addq.w	#4,sp
	rts

; ------------------------------------------------------------------------------
; Fill palette
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).w - CRAM selection length
;	2(sp).b - Starting CRAM index
;	4(sp).w - Color value
; ------------------------------------------------------------------------------

FillMarsPalette:
	tst.w	0+4(sp)						; Is the CRAM selection length valid?
	beq.s	.End						; If not, branch
	bmi.s	.End						; If not, branch
	
	moveq	#6,d0						; Prepare graphics data command slot
	bsr.w	PrepareMarsGfxDataCmd
	bcc.s	.End						; If the graphics data command buffer is too full, branch
	
	move.w	#$400,(a1)+					; Command ID
	subq.w	#1,0+4(sp)					; CRAM selection length
	move.b	1+4(sp),(a1)+
	move.b	2+4(sp),(a1)+					; Starting CRAM index
	move.w	4+4(sp),(a1)+					; Color value

.End:
	move.l	(sp),6(sp)					; Deallocate variables and exit
	addq.w	#6,sp
	rts

; ------------------------------------------------------------------------------
; Load rotoscope palette
; ------------------------------------------------------------------------------
; PARAMETERS:
;	0(sp).w - Frame offset
;	2(sp).w - On color value
;	4(sp).w - Off color value
; ------------------------------------------------------------------------------

LoadMarsRotoscopePalette:
	moveq	#8,d0						; Prepare graphics data command slot
	bsr.w	PrepareMarsGfxDataCmd
	bcc.s	.End						; If the graphics data command buffer is too full, branch

	move.w	#$500,(a1)+					; Command ID
	move.w	4+4(sp),(a1)+					; Off color value
	move.w	2+4(sp),(a1)+					; On color value
	move.w	0+4(sp),(a1)+					; Frame offset

.End:
	move.l	(sp),6(sp)					; Deallocate variables and exit
	addq.w	#6,sp
	rts

; ------------------------------------------------------------------------------
; Update palette fade
; ------------------------------------------------------------------------------

UpdateMarsPaletteFade:
	moveq	#2,d0						; Prepare graphics data command slot
	bsr.w	PrepareMarsGfxDataCmd
	bcc.s	.End						; If the graphics data command buffer is too full, branch

	move.b	#6,(a1)+					; Command ID
	move.w	pal_fade_intensity,d0				; Palette fade intensity
	move.b	.ConvTable(pc,d0.w),(a1)+

.End:
	rts
	
; ------------------------------------------------------------------------------

	dc.b	-$3E, -$3E, -$36, -$36, -$2C, -$2C, -$24, -$24, -$1A, -$1A, -$12, -$12, -$08, -$08
.ConvTable:
	dc.b	 $00,  $00,  $08,  $08,  $12,  $12,  $1A,  $1A,  $24,  $24,  $2C,  $2C,  $36,  $36
	dc.b	 $3E,  $3E

; ------------------------------------------------------------------------------
; Convert Mega Drive color to 32X color
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Mega Drive color
; RETURNS:
;	d0.w - 32X color
; ------------------------------------------------------------------------------

ConvMdColorToMars:
	move.w	d0,d1						; Split channels
	move.w	d0,d2
	andi.w	#$E00,d0
	andi.w	#$E0,d1
	andi.w	#$E,d2
	lsr.w	#8,d0
	lsr.w	#4,d1
	
	move.w	.ConvTable(pc,d0.w),d0				; Convert channel values
	move.w	.ConvTable(pc,d1.w),d1
	move.w	.ConvTable(pc,d2.w),d2

	ror.w	#6,d0						; Combine channels
	lsl.w	#5,d1
	or.w	d1,d0
	or.w	d2,d0
	rts

; ------------------------------------------------------------------------------

.ConvTable:
	dc.w	0, 4, 9, $D, $12, $16, $1B, $1F

; ------------------------------------------------------------------------------
; Convert 32X color to Mega Drive color
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - 32X color
; RETURNS:
;	d0.w - Mega Drive color
; ------------------------------------------------------------------------------

ConvMarsColorToMd:
	move.w	d0,d1						; Split channels
	move.w	d0,d2
	andi.w  #$7000,d0
	andi.w  #$380,d1
	andi.w  #$1C,d2

	lsr.w   #3,d0						; Convert channels values
	lsr.w   #2,d1
	lsr.w   #1,d2

	or.w    d1,d0						; Combine channels
	or.w    d2,d0
	rts

; ------------------------------------------------------------------------------
