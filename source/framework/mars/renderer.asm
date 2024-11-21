; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Graphics renderer
; ------------------------------------------------------------------------------

	section sh2_code
	include	"source/framework/mars.inc"

; ------------------------------------------------------------------------------

GraphicsRenderer:
	mov.l	#SYS_REGS+COMM_8,r0				; Has the Slave CPU crashed?
	mov.l	@r0,r0
	mov.l	#"MDER",r1
	cmp/eq	r0,r1
	bf	.NoError					; If not, branch	

	mov.l	#SYS_REGS+INT_MASK,r0				; Disable interrupts
	xor	r1,r1
	mov.b	r1,@r0

	mov.l	#InitScreen,r0					; Clear screen
	jsr	@r0
	nop

.WaitErrorPalAccess:
	mov.l	#VDP_REGS+VDP_STATUS,r0				; Do we have palette access?
	mov.b	@r0,r0
	tst	#BIT_PEN,r0
	bt	.WaitErrorPalAccess				; If not, wait

	mov.w	#$8000,r0					; Set background color
	mov.l	#CRAM,r1
	mov.w	r0,@r1

.ErrorLoop:
	bra	.ErrorLoop					; Loop here indefinitely
	nop

; ------------------------------------------------------------------------------

.NoError:
	mov.l	#SYS_REGS+COMM_5,r0				; Wait for graphics data commands to be sent
	mov.b	@r0,r0
	tst	r0,r0
	bt	.NoGfxDataCommands

	mov.l	#gfx_data_cmd_buffer,r14			; Run graphics data commands
	mov.l	#RunGfxDataCmds,r0
	jsr	@r0
	nop
	
	mov.l	#UpdateMarsCram,r0				; Update CRAM
	jsr	@r0
	nop

	mov.l	#SYS_REGS+COMM_5,r1				; Graphics data commands processing finished
	xor	r0,r0
	mov.b	r0,@r1

; ------------------------------------------------------------------------------

.NoGfxDataCommands:
	mov.l	#SYS_REGS+COMM_4,r0				; Wait for draw commands to be sent
	mov.b	@r0,r0
	tst	r0,r0
	bt	GraphicsRenderer

	mov.l	#draw_cmd_buffer,r14				; Draw graphics
	mov.l	#DrawGraphics,r0
	jsr	@r0
	nop

	mov.b	#1,r0						; Set screen drawn flag
	mov.l	#screen_drawn,r1
	mov.l	r0,@r1

.Wait:
	mov.l	@r1,r0						; Has the frame buffer been swapped?
	tst	r0,r0
	bf	.Wait						; If not, wait

; ------------------------------------------------------------------------------

	bra	GraphicsRenderer				; Loop
	nop

	lits
	cnop 0,4

; ------------------------------------------------------------------------------
; Draw graphics
; ------------------------------------------------------------------------------

DrawGraphics:
	sts.l	pr,@-r15					; Save return address

.Loop:
	mova	.Commands,r0					; Get draw command function
	mov.b	@r14+,r1
	shll2	r1
	mov.l	@(r0,r1),r0

	mov.l	#.Loop,r1					; Run command
	jmp	@r0
	lds.l	r1,pr
	
	lits
	cnop 0,4
	
; ------------------------------------------------------------------------------

.Commands:
	dc.l	DrawCmd_Done					; End of list
	dc.l	DrawCmd_ClearScreen				; Clear screen
	dc.l	DrawCmd_DrawSprite				; Draw sprite
	dc.l	DrawCmd_DrawLine				; Draw line
	dc.l	DrawCmd_DrawShape2d				; Draw 2D shape
	dc.l	DrawCmd_DrawShape3d				; Draw 3D shape
	dc.l	DrawCmd_DrawDistortedSprite			; Draw distorted sprite
	dc.l	DrawCmd_DrawSpriteChain				; Draw sprite chain

; ------------------------------------------------------------------------------
; End of draw command list
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
; ------------------------------------------------------------------------------

DrawCmd_Done:
	lds.l	@r15+,pr					; Restore registers

	rts
	nop

	lits
	
; ------------------------------------------------------------------------------
; Clear screen
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - $00
; ------------------------------------------------------------------------------

DrawCmd_ClearScreen:
	add	#1,r14						; Clear screen
	mov.l	#ClearScreen,r0
	jmp	@r0
	nop

	lits

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - ID number (for pre-loaded sprite)
;	$02.b - Pre-load mode (0 = Pre-loaded, 1 = Not pre-loaded)
;	$03.b - CRAM index (Only when not pre-loaded)
;	IF PRE-LOADED:
;		$04.b - Sprite frame ID
;		$05.b - Flip flags (bit 0 = X flip, bit 1 = Y flip)
;		$06.w - X position
;		$08.w - Y position
;		$0A.w - X scale
;		$0C.w - Y scale
;	IF NOT PRE-LOADED:
;		$04.l - Sprite data address
;		$08.b - Sprite frame ID
;		$09.b - Flip flags (bit 0 = X flip, bit 1 = Y flip)
;		$0A.w - X position
;		$0C.w - Y position
;		$0E.w - X scale
;		$10.w - Y scale
; ------------------------------------------------------------------------------

DrawCmd_DrawSprite:
	mov.b	@r14+,r0					; Get ID number
	extu.b	r0,r0
	shll2	r0

	mov.b	@r14+,r1					; Should this sprite be dynamically loaded?
	tst	r1,r1
	bf	.DynamicLoad					; If so, branch
	
	add	#1,r14						; Skip CRAM index

	mov.l	#loaded_sprites,r4				; Get sprite frame data
	mov.l	@(r0,r4),r4
	mov.b	@r14+,r0
	shll2	r0
	mov.l	@(r0,r4),r4

; ------------------------------------------------------------------------------

.GetParams:
	mov.b	@r14+,r3					; Get flags
	mov.b	#%11,r1
	and	r1,r3
	mov.w	@r14+,r1					; Get X
	mov.w	@r14+,r2					; Get Y
	mov.w	@r14+,r5					; Get X scale
	mov.w	@r14+,r6					; Get Y scale

	tst	r5,r5						; Is the X scale 0?
	bt	.End						; If so, don't draw the sprite
	tst	r6,r6						; Is the Y scale 0?
	bt	.End						; If so, don't draw the sprite

	mov.l	#DrawScaledSprite,r0				; Scaled sprite draw routine

	mov.w	#$100,r7					; Is the sprite unscaled?
	cmp/eq	r7,r5
	bf	.Draw						; If not, branch
	cmp/eq	r7,r6
	bf	.Draw						; If not, branch

	mov.l	#DrawUnscaledSprite,r0				; Unscaled sprite draw routine

.Draw:
	mov.l	r14,@-r15					; Draw sprite
	sts.l	pr,@-r15
	jsr	@r0
	nop
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14

.End:
	rts
	nop

; ------------------------------------------------------------------------------

.DynamicLoad:
	mov.b	@r14+,r3					; Get CRAM index
	add	#-1,r3

	mov.w	@r14+,r2					; Get sprite data address
	mov.w	r2,@-r15
	mov.w	@r14+,r2
	mov.w	r2,@-r15
	mov.l	@r15+,r2

	mov.b	@r14+,r0					; Get sprite frame data
	add	#1,r0
	shll2	r0
	mov.l	@(r0,r2),r1
	add	r2,r1

	sts.l	pr,@-r15					; Load sprite frame data
	mov.l	#dynamic_sprite_data,r2
	mov.l	#LoadUncSpriteFrame,r0
	jsr	@r0
	mov.l	r2,r4
	lds.l	@r15+,pr

	bra	.GetParams					; Get sprite draw parameters
	nop

	lits

; ------------------------------------------------------------------------------
; Draw line
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - CRAM index
;	$02.w - X position 1
;	$04.w - Y position 1
;	$06.w - X position 2
;	$08.w - Y position 2
; ------------------------------------------------------------------------------

DrawCmd_DrawLine:
	mov.b	@r14+,r4					; Get CRAM index
	mov.w	@r14+,r0					; Get X1
	mov.w	@r14+,r1					; Get Y1
	mov.w	@r14+,r2					; Get X2
	mov.l	#DrawLine,r5					; Draw line
	jmp	@r5
	mov.w	@r14+,r3					; Get Y2

	lits

; ------------------------------------------------------------------------------
; Draw 2D shape
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - CRAM index
;	$02.b - Draw mode (0 = Corners, 1 = Wireframe, 2 = Solid)
;	$03.b - Number of vertices
;	For each vertex
;		$XX.w - X position
;		$XX.w - Y position
; ------------------------------------------------------------------------------

DrawCmd_DrawShape2d:
	mov.l	#DrawShape,r0					; Draw shape
	mov.l	r14,r1
	sts.l	pr,@-r15
	jsr	@r0
	mov.l	r14,@-r15
	mov.l	@r15+,r14
	lds.l	@r15+,pr
	
	add	#2,r14						; Get number of vertices
	mov.b	@r14+,r1

	extu.b  r1,r1						; Advance command list
	shll2	r1
	rts
	add	r1,r14

	lits

; ------------------------------------------------------------------------------
; Draw 3D shape
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - $00
;	$02.b - CRAM index
;	$03.b - Draw mode (0 = Corners, 1 = Wireframe, 2 = Solid)
;	$04.l - Shape data address
;	$08.b - $00
;	$09.b - Pitch rotation
;	$0A.b - Yaw rotation
;	$0B.b - Roll rotation
;	$0C.w - X position
;	$0E.w - Y position
;	$10.w - Z position
; ------------------------------------------------------------------------------

DrawCmd_DrawShape3d:
	add	#1,r14						; Draw 3D shape
	mov.l	#DrawShape3d,r0
	sts.l	pr,@-r15
	jsr	@r0
	mov.l	r14,r1
	lds.l	@r15+,pr
	
	rts							; Advance command list
	add	#$10,r14

	lits
	
; ------------------------------------------------------------------------------
; Draw distorted sprite
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - ID number (for pre-loaded sprite)
;	$02.b - Pre-load mode (0 = Pre-loaded, 1 = Not pre-loaded)
;	$03.b - CRAM index (Only when not pre-loaded)
;	IF PRE-LOADED:
;		$04.b - Sprite frame ID
;		$05.b - Flip flags (bit 0 = X flip, bit 1 = Y flip)
;		$06.w - X position
;		$08.w - Y position
;		$0A.w - X scale
;		$0C.w - Left distortion
;		$0E.w - Right distortion
;		$10.w - X distortion intensity
;		$12.w - Y scale
;		$14.w - Top distortion
;		$16.w - Bottom distortion
;		$18.w - Y distortion intensity
;	IF NOT PRE-LOADED:
;		$04.l - Sprite data address
;		$08.b - Sprite frame ID
;		$09.b - Flip flags (bit 0 = X flip, bit 1 = Y flip)
;		$0A.w - X position
;		$0C.w - Y position
;		$0E.w - X scale
;		$10.w - Left distortion
;		$12.w - Right distortion
;		$14.w - X distortion intensity
;		$16.w - Y scale
;		$18.w - Top distortion
;		$1A.w - Bottom distortion
;		$1C.w - Y distortion intensity
; ------------------------------------------------------------------------------

DrawCmd_DrawDistortedSprite:
	mov.b	@r14+,r0					; Get ID number
	extu.b	r0,r0
	shll2	r0

	mov.b	@r14+,r1					; Should this sprite be dynamically loaded?
	tst	r1,r1
	bf	.DynamicLoad					; If so, branch
	
	add	#1,r14						; Skip CRAM index

	mov.l	#loaded_sprites,r4				; Get sprite frame data
	mov.l	@(r0,r4),r4
	mov.b	@r14+,r0
	shll2	r0
	mov.l	@(r0,r4),r4

; ------------------------------------------------------------------------------

.GetParams:
	mov.b	@r14+,r3					; Get flags
	mov.b	#%11,r1
	and	r1,r3
	mov.w	@r14+,r1					; Get X
	mov.w	@r14+,r2					; Get Y

	mov.l	r14,r5						; Get distortion parameters
	
	mov.w	@r14+,r0					; Get X scale
	add	#6,r14
	mov.w	@r14+,r6					; Get Y scale
	add	#6,r14

	tst	r0,r0						; Is the X scale 0?
	bt	.End						; If so, don't draw the sprite
	tst	r6,r6						; Is the Y scale 0?
	bt	.End						; If so, don't draw the sprite

	mov.l	r14,@-r15
	sts.l	pr,@-r15
	mov.l	#DrawDistortedSprite,r0
	jsr	@r0
	nop
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14

.End:
	rts
	nop

; ------------------------------------------------------------------------------

.DynamicLoad:
	mov.b	@r14+,r3					; Get CRAM index
	add	#-1,r3

	mov.w	@r14+,r2					; Get sprite data address
	mov.w	r2,@-r15
	mov.w	@r14+,r2
	mov.w	r2,@-r15
	mov.l	@r15+,r2

	mov.b	@r14+,r0					; Get sprite frame data
	add	#1,r0
	shll2	r0
	mov.l	@(r0,r2),r1
	add	r2,r1

	sts.l	pr,@-r15					; Load sprite frame data
	mov.l	#dynamic_sprite_data,r2
	mov.l	#LoadUncSpriteFrame,r0
	jsr	@r0
	mov.l	r2,r4
	lds.l	@r15+,pr

	bra	.GetParams					; Get sprite draw parameters
	nop

	lits

; ------------------------------------------------------------------------------
; Draw chain of sprite
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - ID number (for pre-loaded sprite)
;	$02.w - Sprite count
;	For each sprite
;		$XX.b - Sprite frame ID
;		$XX.b - Flip flags (bit 0 = X flip, bit 1 = Y flip)
;		$XX.w - X position
;		$XX.w - Y position
; ------------------------------------------------------------------------------

DrawCmd_DrawSpriteChain:
	mov.b	@r14+,r0					; Get sprite data
	extu.b	r0,r0
	shll2	r0
	mov.l	#loaded_sprites,r4
	mov.l	@(r0,r4),r4

; ------------------------------------------------------------------------------

.GetParams:
	mov.w	@r14+,r7					; Get sprite count

.DrawSprites:
	mov.b	@r14+,r0					; Get frame ID
	mov.b	@r14+,r3					; Get flags
	mov.b	#%11,r1
	and	r1,r3
	mov.w	@r14+,r1					; Get X
	mov.w	@r14+,r2					; Get Y
	mov.w	#$100,r5					; Get X scale
	mov.w	#$100,r6					; Get Y scale

	mov.l	r4,@-r15					; Get sprite frame data
	shll2	r0
	mov.l	@(r0,r4),r4

	mov.l	r14,@-r15					; Draw sprite
	sts.l	pr,@-r15
	mov.l	#DrawUnscaledSprite,r0
	jsr	@r0
	nop
	lds.l	@r15+,pr
	mov.l	@r15+,r14
	mov.l	@r15+,r4

	dt	r7						; Decrement number of sprites to draw
	bf	.DrawSprites					; If there still sprites to draw, branch

	rts
	nop

	lits

; ------------------------------------------------------------------------------
; Run graphics data commands
; ------------------------------------------------------------------------------

RunGfxDataCmds:
	sts.l	pr,@-r15					; Save return address

.Loop:
	mova	.Commands,r0					; Get graphics data command function
	mov.b	@r14+,r1
	shll2	r1
	mov.l	@(r0,r1),r0

	mov.l	#.Loop,r1					; Run command
	jmp	@r0
	lds.l	r1,pr
	
	lits
	cnop 0,4
	
; ------------------------------------------------------------------------------

.Commands:
	dc.l	GfxDataCmd_Done					; End of list
	dc.l	GfxDataCmd_LoadSprites				; Load sprites
	dc.l	GfxDataCmd_UnloadSprites			; Unload sprites
	dc.l	GfxDataCmd_LoadPalette				; Load palette
	dc.l	GfxDataCmd_FillPalette				; Fill palette
	dc.l	GfxDataCmd_LoadRotoscopePalette			; Load rotoscope palette
	dc.l	GfxDataCmd_PaletteFade				; Set palette fade intensity
	
; ------------------------------------------------------------------------------
; End of graphics data command list
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
; ------------------------------------------------------------------------------

GfxDataCmd_Done:
	lds.l	@r15+,pr
	rts
	nop

	lits

; ------------------------------------------------------------------------------
; Load sprites
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - $00
;	$02.b - ID number
;	$03.b - CRAM index
;	$04.l - Sprite data address
; ------------------------------------------------------------------------------

GfxDataCmd_LoadSprites:
	mov.l	#sprite_data_slot,r2				; Get sprite data slot
	mov.l	@r2,r2
	mov.l	#loaded_sprites,r6				; Get loaded sprites

	add	#1,r14						; Skip past padding

.LoadSprites:
	mov.b	@r14+,r0					; Get ID number
	extu.b	r0,r0
	mov.b	@r14+,r3					; Get CRAM index
	add	#-1,r3

	sts.l	pr,@-r15					; Get loaded sprite table offset
	shll2	r0

	mov.w	@r14+,r1					; Get sprite data address
	mov.w	r1,@-r15
	mov.w	@r14+,r1
	mov.w	r1,@-r15
	mov.l	@r15+,r1

	bsr	LoadSprites					; Load sprites
	mov.l	r2,@(r0,r6)
	lds.l	@r15+,pr

	add	r0,r2						; Update sprite data slot
	mov.l	#sprite_data_slot,r0
	rts
	mov.l	r2,@r0

	lits

; ------------------------------------------------------------------------------
; Unload sprites
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - $00
; ------------------------------------------------------------------------------

GfxDataCmd_UnloadSprites:
	add	#1,r14						; Get loaded sprites
	mov.l	#loaded_sprites,r0

	mov.w	#$100,r2					; Get number of sprite sets
	mov.b	#-1,r1						; Get unload value

.UnloadSprites:
	mov.l	r1,@r0						; Unload sprite set
	dt	r2						; Decrement number of sprites to unload
	bf/s	.UnloadSprites					; If there still sprites to unload, branch
	add	#4,r0						; Next sprite set

	mov.l	#sprite_data,r0					; Reset sprite data buffer slot
	mov.l	#sprite_data_slot,r1
	rts
	mov.l	r0,@r1

	lits

; ------------------------------------------------------------------------------
; Load palette
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - $00
;	$02.l - Palette data address
;	$06.b - Starting CRAM index
;	$07.b - Swap priority (0 = no, 1 = yes)
; ------------------------------------------------------------------------------

GfxDataCmd_LoadPalette:
	mov.l	#palette,r1					; Palette buffer

	add	#1,r14						; Get palette data address
	mov.w	@r14+,r2
	mov.w	r2,@-r15
	mov.w	@r14+,r2
	mov.w	r2,@-r15
	mov.l	@r15+,r2

	mov.w	@r2+,r3						; Get number of colors

	mov.b	@r14+,r4					; Get CRAM index
	extu.b	r4,r4
	shll	r4

	xor	r5,r5						; No priority swap
	mov.b	@r14+,r0					; Should we swap priority?
	tst	r0,r0
	bt	.LoadStart					; If not, branch
	mov.w	#$8000,r5					; Priority swap

.LoadStart:
	mov.l	r4,r0						; Get CRAM index

.LoadColors:
	mov.w	@r2+,r4						; Load color
	xor	r5,r4
	mov.w	r4,@(r0,r1)
	dt	r3						; Decrement colors left
	bf/s	.LoadColors					; If there are more to load, loop
	add	#2,r0
	
	rts
	nop

	lits

; ------------------------------------------------------------------------------
; Fill palette
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - $00
;	$02.b - CRAM selection length (minus 1)
;	$03.b - Starting CRAM index
;	$04.w - Color value
; ------------------------------------------------------------------------------

GfxDataCmd_FillPalette:
	mov.l	#palette,r1					; Palette buffer
	
	add	#1,r14						; Get CRAM selection length
	mov.b	@r14+,r2
	extu.b	r2,r2
	add	#1,r2

	mov.b	@r14+,r0					; Get CRAM index
	extu.b	r0,r0
	shll	r0

	mov.w	@r14+,r4					; Get color value

.FillLoop:
	mov.w	r4,@(r0,r1)					; Load color
	dt	r2						; Decrement CRAM entries left to fill
	bf/s	.FillLoop					; If there are more to fill, loop
	add	#2,r0

	rts
	nop

	lits

; ------------------------------------------------------------------------------
; Load rotoscope palette
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - $00
;	$02.w - Off color value
;	$04.w - On color value
;	$06.w - Frame offset
; ------------------------------------------------------------------------------

GfxDataCmd_LoadRotoscopePalette:
	add	#1,r14						; Get colors
	mov.w	@r14+,r3
	mov.w	@r14+,r4

	mov.w	@r14+,r0					; Get frame bit mask
	mov.l	#.BitMasks,r1					; Get bit mask
	and	#7,r0
	add	r0,r1
	mov.b	@r1,r2

	mov.w	#256-1,r0					; Number of colors
	mov.l	#palette,r1					; Palette buffer

.LoadColors:
	mov.w	r3,@r1						; Load off color
	tst	r2,r0
	bf	.NextColor					; If we should use it, branch
	mov.w	r4,@r1						; Load on color

.NextColor:
	dt	r0						; Decrement colors left
	cmp/eq	#-1,r0						; Are we done?
	bf/s	.LoadColors					; If not, loop
	add	#2,r1						; Next palette entry
	
	rts
	nop

	lits

; ------------------------------------------------------------------------------

.BitMasks:
	dc.b	$01, $02, $04, $08, $10, $20, $40, $80

; ------------------------------------------------------------------------------
; Set palette fade intensity
; ------------------------------------------------------------------------------
; PARAMETERS:
;	$00.b - Command ID
;	$01.b - Palette fade intensity
; ------------------------------------------------------------------------------

GfxDataCmd_PaletteFade:
	mov.l	#pal_fade_intensity,r1				; Set palette fade intensity
	mov.b	@r14+,r0
	rts
	mov.l	r0,@r1

	lits

; ------------------------------------------------------------------------------
