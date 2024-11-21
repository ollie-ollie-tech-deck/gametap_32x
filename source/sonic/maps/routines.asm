; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sonic stage map routines
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Ring Girl initialization event
; ------------------------------------------------------------------------------

Init_RingGirl:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	move.b	#%01,map_bg_flags
	
	move.b	#6-1,pal_cycle_timer				; Reset palette cycle timer
	rts
	
; ------------------------------------------------------------------------------
; Ring Girl draw event
; ------------------------------------------------------------------------------

Draw_RingGirl:
	subq.b	#1,pal_cycle_timer				; Decrement palette cycle timer
	bpl.s	LoadAnimGhzTiles				; If it hasn't run out, branch
	move.b	#6-1,pal_cycle_timer				; Reset palette cycle timer

	lea	palette+$50+6,a1				; Cycle water palette
	move.w	(a1),d0
	move.w	-(a1),2(a1)
	move.w	-(a1),2(a1)
	move.w	-(a1),2(a1)
	move.w	d0,(a1)

; ------------------------------------------------------------------------------
; Load animated Green Hill Zone tiles
; ------------------------------------------------------------------------------

LoadAnimGhzTiles:
	lea	VDP_CTRL,a5					; VDP control port
	lea	-4(a5),a6					; VDP data port
	
	subq.b	#1,sunflower_anim_timer				; Decrement sunflower timer
	bpl.w	.Flower						; If it hasn't run out, branch
	move.b	#16-1,sunflower_anim_timer			; Reset sunflower timer

	lea	Art_GhzSunflower,a1				; Get sunflower frame art offset
	move.b	sunflower_anim_frame,d0
	addq.b	#1,sunflower_anim_frame
	andi.w	#1,d0
	beq.s	.LoadSunflower
	lea	16*$20(a1),a1

.LoadSunflower:
	VDP_CMD move.l,$6B80,VRAM,WRITE,(a5)			; Load sunflower frame art
	rept (16*$20)/4
		move.l	(a1)+,(a6)
	endr

.Flower:
	subq.b	#1,flower_anim_timer				; Decrement flower timer
	bpl.w	.Waterfall					; If it hasn't run out, branch
	move.b	#8-1,flower_anim_timer				; Reset flower timer

	lea	Art_GhzFlower,a1				; Get flower frame ID
	move.b	flower_anim_frame,d0
	addq.b	#1,flower_anim_frame
	andi.w	#3,d0
	lea	.FlowerSequence(pc),a0
	move.b	(a0,d0.w),d0

	btst	#0,d0						; Should we do a longer delay?
	bne.s	.LoadFlower					; If not, branch
	move.b	#128-1,flower_anim_timer			; Set longer delay

.LoadFlower:
	lsl.w	#7,d0						; Get flower frame art offset
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	lea	(a1,d0.w),a1

	VDP_CMD move.l,$6D80,VRAM,WRITE,(a5)			; Load flower frame art
	rept (12*$20)/4
		move.l	(a1)+,(a6)
	endr

.Waterfall:
	subq.b	#1,waterfall_anim_timer				; Decrement waterfall timer
	bpl.w	.End						; If it hasn't run out, branch
	move.b	#16-1,waterfall_anim_timer			; Reset waterfall timer

	lea	Art_GhzWaterfall,a1				; Get waterfall frame art offset
	move.b	waterfall_anim_frame,d0
	addq.b	#1,waterfall_anim_frame
	andi.w	#1,d0
	beq.s	.LoadWaterfall
	lea	8*$20(a1),a1

.LoadWaterfall:
	VDP_CMD move.l,$6F00,VRAM,WRITE,(a5)			; Load waterfall frame art
	rept (8*$20)/4
		move.l	(a1)+,(a6)
	endr

.End:
	rts

; ------------------------------------------------------------------------------

.FlowerSequence:
	dc.b	0, 1, 2, 1

; ------------------------------------------------------------------------------
; Ring Girl scrolling
; ------------------------------------------------------------------------------

Scroll_RingGirl:
	move.w	#$3E0,map_fg_target_bottom			; Set bottom boundary
	cmpi.w	#$1500,camera_fg_x
	blt.s	.GotBottomBound
	move.w	#$2E0,map_fg_target_bottom
	
.GotBottomBound:
	cmpi.w	#$1500,camera_fg_x				; Are we at Blockbuster?
	blt.s	.GotLeftBound					; If not, branch
	
	move.w	camera_fg_x,map_fg_bound_left			; Prevent backtracking
	move.w	camera_fg_x,map_fg_target_left
	move.w	#$1A00,d0					; Darken as you progress
	sub.w	camera_fg_x,d0
	bpl.s	.GotLeftBound
	asr.w	#7,d0

	cmpi.w	#-8,d0						; Have we faded enough?
	bgt.s	.SetFade					; If not, branch
	
	st	ring_girl_transition				; Go to Ring Girl transition
	bra.s	.GotLeftBound

.SetFade:
	jsr	SetPaletteFadeIntensity				; Set palette fade intensity
	
.GotLeftBound:
	lea	GhzDeformation,a0				; Scroll map
	jmp	ScrollDeformed

; ------------------------------------------------------------------------------
; Ring Girl boss initialization event
; ------------------------------------------------------------------------------

Init_RingGirlBoss:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y

	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	
	jsr	SpawnObject					; Spawn boss
	move.l	#ObjRingGirlBoss,obj.update(a1)
	rts

; ------------------------------------------------------------------------------
; Ring Girl boss draw event
; ------------------------------------------------------------------------------

Draw_RingGirlBoss:
	move.b	#1,-(sp)					; Draw couch (left)
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	#80,-(sp)
	move.w	#96,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	
	move.b	#1,-(sp)					; Draw couch (right)
	move.b	#1,-(sp)
	clr.b	-(sp)
	move.w	#240,-(sp)
	move.w	#96,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Ring Girl boss scrolling
; ------------------------------------------------------------------------------

Scroll_RingGirlBoss:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Ben Drowned initialization event
; ------------------------------------------------------------------------------

Init_BenDrowned:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y

	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	
	jsr	Random						; Start decreasing the offset
	andi.w	#$3F,d0
	addi.w	#$30,d0
	neg.w	d0
	move.w	d0,ben_bg_pal_target
	rts

; ------------------------------------------------------------------------------
; Ben Drowned draw event
; ------------------------------------------------------------------------------

Draw_BenDrowned:
	tst.w	ben_appear					; Is Ben appearing?
	bne.s	.DrawBgSprites					; If not, branch

	lea	.BgPalettes(pc),a0				; Load background palette
	move.w	ben_bg_pal_offset,d0
	bmi.s	.NoBgPalette
	cmpi.w	#(.BgPalettesEnd-.BgPalettes)/4,d0
	bcc.s	.NoBgPalette
	add.w	d0,d0
	add.w	d0,d0
	move.l	(a0,d0.w),-(sp)
	move.b	#$C0,-(sp)
	move.b	#1,-(sp)
	jsr	LoadMarsPalette
	
.NoBgPalette:
	move.w	ben_bg_pal_offset,d0				; Are we at the target offset?
	cmp.w	ben_bg_pal_target,d0
	blt.s	.IncBgPalOffset					; If we are below it, branch
	bgt.s	.DecBgPalOffset					; If we are above it, branch
	
	tst.w	d0						; Were we decreasing it?
	bmi.s	.StartBgOffsetInc				; If so, branch
	
	jsr	Random						; Start decreasing the offset
	andi.w	#$3F,d0
	addi.w	#$30,d0
	neg.w	d0
	move.w	d0,ben_bg_pal_target
	bra.w	.DrawBgSprites

.StartBgOffsetInc:
	jsr	Random						; Start increasing the offset
	andi.w	#$1F,d0
	addi.w	#((.BgPalettesEnd-.BgPalettes)/4)+$10,d0
	move.w	d0,ben_bg_pal_target
	bra.w	.DrawBgSprites

.IncBgPalOffset:
	addq.w	#1,ben_bg_pal_offset				; Increase offset
	bra.s	.DrawBgSprites

.DecBgPalOffset:
	subq.w	#1,ben_bg_pal_offset				; Decrease offset

.DrawBgSprites:
	move.b	#$E,-(sp)					; Draw background sprites
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	#160,-(sp)
	move.w	#112,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------

.BgPalettes:
	.c: = 0
	rept $E
		dc.l	MarsPal_BenBackground+.c
		.c: = .c+(($30)+1)*2
	endr
.BgPalettesEnd:

; ------------------------------------------------------------------------------
; Ben Drowned scrolling
; ------------------------------------------------------------------------------

Scroll_BenDrowned:
	move.w	#$3E0,map_fg_target_bottom			; Set bottom boundary
	cmpi.w	#$1780,camera_fg_x
	blt.s	.GotBottomBound
	move.w	#$4E0,map_fg_target_bottom
	
.GotBottomBound:
	cmpi.w	#$24C0,camera_fg_x				; Are we at the end of the stage?
	bcs.s	.NoStageEnd					; If not, branch

	st	go_to_rpg					; Go to RPG stage

.NoStageEnd:
	jsr	ScrollStatic					; Scroll map

	lea	SineTable,a0					; Sine table
	move.w	stage_frame_count,d0
	andi.w	#$FF,d0
	add.w	d0,d0
	lea	(a0,d0.w),a0
	
	lea	hscroll+2,a1					; Horizontal scroll table
	move.w	#224-1,d0					; Number of scanlines
	btst	#0,frame_count+3				; Negation flag
	sne	d1

.DeformLoop:
	move.w	(a0)+,d2					; Get sine value
	asr.w	#5,d2

	not.b	d1						; Swap negation flag
	beq.s	.SetHScroll					; If we shouldn't negate, branch
	neg.w	d2						; Negate sine value

.SetHScroll:
	add.w	d2,(a1)+					; Set background value
	addq.w	#2,a1						; Skip foreground value
	dbf	d0,.DeformLoop					; Loop until finished
	rts

; ------------------------------------------------------------------------------
; Ben Drowned boss initialization event
; ------------------------------------------------------------------------------

Init_BenDrownedBoss:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y

	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	
	jsr	SpawnObject					; Spawn boss
	move.l	#ObjBenBoss,obj.update(a1)
	rts

; ------------------------------------------------------------------------------
; Ben Drowned boss draw event
; ------------------------------------------------------------------------------

Draw_BenDrownedBoss:
	rts

; ------------------------------------------------------------------------------
; Ben Drowned boss scrolling
; ------------------------------------------------------------------------------

Scroll_BenDrownedBoss:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Slenderman initialization event
; ------------------------------------------------------------------------------

Init_Slenderman:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	move.b	#%01,map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Slenderman draw event
; ------------------------------------------------------------------------------

Draw_Slenderman:
	rts

; ------------------------------------------------------------------------------
; Slenderman scrolling
; ------------------------------------------------------------------------------

Scroll_Slenderman:
	moveq	#0,d0						; Set background X position
	move.w	camera_fg_x,d0
	asr.w	#1,d0
	move.w	d0,camera_bg_x
	move.w	d0,camera_bg_x_draw

	lea	Art_SlendermanBg,a0				; Get trunk art
	asr.w	#2,d0
	divu.w	#$28,d0
	swap	d0
	subi.w	#$27,d0
	neg.w	d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d0,d0
	add.w	d1,d0
	lsl.w	#6,d0
	adda.w	d0,a0
	
	lea	scratch_buffer,a1				; Load trunk art into scratch RAM
	moveq	#$140/$20-1,d0
	
.LoadTrunkArt:
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	dbf	d0,.LoadTrunkArt
	
	move.l	#scratch_buffer,d1				; Load trunk art into VRAM
	move.w	#$2D00,d2
	move.w	#$140,d3
	jsr	QueueDma
	
	move.w	#$3E0,map_fg_target_bottom			; Set bottom boundary
	cmpi.w	#$1780,camera_fg_x
	blt.s	.GotBottomBound
	move.w	#$4E0,map_fg_target_bottom
	
.GotBottomBound:
	cmpi.w	#$24C0,camera_fg_x				; Are we at the end of the stage?
	bcs.s	.NoStageEnd					; If not, branch

	st	go_to_rpg					; Go to RPG stage

.NoStageEnd:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Slenderman boss initialization event
; ------------------------------------------------------------------------------

Init_SlendermanBoss:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	
	jsr	SpawnObject					; Spawn boss
	move.l	#ObjSlendermanBoss,obj.update(a1)
	rts

; ------------------------------------------------------------------------------
; Slenderman boss draw event
; ------------------------------------------------------------------------------

Draw_SlendermanBoss:
	rts

; ------------------------------------------------------------------------------
; Slenderman boss scrolling
; ------------------------------------------------------------------------------

Scroll_SlendermanBoss:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Hellscape initialization event
; ------------------------------------------------------------------------------

Init_Hellscape:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Hellscape draw event
; ------------------------------------------------------------------------------

Draw_Hellscape:
	rts

; ------------------------------------------------------------------------------
; Hellscape scrolling
; ------------------------------------------------------------------------------

Scroll_Hellscape:
	move.w	#$3E0,map_fg_target_bottom			; Set bottom boundary
	cmpi.w	#$1780,camera_fg_x
	blt.s	.GotBottomBound
	move.w	#$4E0,map_fg_target_bottom
	
.GotBottomBound:
	cmpi.w	#$24C0,camera_fg_x				; Are we at the end of the stage?
	bcs.s	.NoStageEnd					; If not, branch

	st	go_to_rpg					; Go to RPG stage

.NoStageEnd:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Hellscape boss initialization event
; ------------------------------------------------------------------------------

Init_HellscapeBoss:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags

	jsr	SpawnObject					; Spawn boss
	move.l	#ObjToadBoss,obj.update(a1)
	rts

; ------------------------------------------------------------------------------
; Hellscape boss draw event
; ------------------------------------------------------------------------------

Draw_HellscapeBoss:
	rts

; ------------------------------------------------------------------------------
; Hellscape boss scrolling
; ------------------------------------------------------------------------------

Scroll_HellscapeBoss:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Scary Maze initialization event
; ------------------------------------------------------------------------------

Init_ScaryMaze:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	move.b	#%01,map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Scary Maze draw event
; ------------------------------------------------------------------------------

Draw_ScaryMaze:
	rts

; ------------------------------------------------------------------------------
; Scary Maze scrolling
; ------------------------------------------------------------------------------

Scroll_ScaryMaze:
	move.w	#$3E0,map_fg_target_bottom			; Set bottom boundary
	cmpi.w	#$1780,camera_fg_x
	blt.s	.GotBottomBound
	move.w	#$4E0,map_fg_target_bottom
	
.GotBottomBound:
	cmpi.w	#$24C0,camera_fg_x				; Are we at the end of the stage?
	bcs.s	.NoStageEnd					; If not, branch

	st	go_to_scary_maze				; Go to Scary Maze

.NoStageEnd:
	lea	ScaryMazeDeformation,a0				; Scroll map
	jmp	ScrollDeformed

; ------------------------------------------------------------------------------
; Final (normal) initialization event
; ------------------------------------------------------------------------------

Init_FinalNormal:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	move.b	#%01,map_bg_flags

	move.b	#6-1,pal_cycle_timer				; Reset palette cycle timer
	rts

; ------------------------------------------------------------------------------
; Final (normal) draw event
; ------------------------------------------------------------------------------

Draw_FinalNormal:
	subq.b	#1,pal_cycle_timer				; Decrement palette cycle timer
	bpl.s	.NoPalCycle					; If it hasn't run out, branch
	move.b	#6-1,pal_cycle_timer				; Reset palette cycle timer

	lea	palette+$50+6,a1				; Cycle water palette
	move.w	(a1),d0
	move.w	-(a1),2(a1)
	move.w	-(a1),2(a1)
	move.w	-(a1),2(a1)
	move.w	d0,(a1)

.NoPalCycle:
	bra.w	LoadAnimGhzTiles				; Load animated tiles

; ------------------------------------------------------------------------------
; Final (normal) scrolling
; ------------------------------------------------------------------------------

Scroll_FinalNormal:
	move.w	#$3E0,map_fg_target_bottom			; Set bottom boundary
	cmpi.w	#$1780,camera_fg_x
	blt.s	.GotBottomBound
	move.w	#$4E0,map_fg_target_bottom
	
.GotBottomBound:
	cmpi.w	#$24C0,camera_fg_x				; Are we at the end of the stage?
	bcs.s	.NoStageEnd					; If not, branch

	st	go_to_rpg					; Go to RPG stage

.NoStageEnd:
	lea	GhzDeformation,a0				; Scroll map
	jmp	ScrollDeformed

; ------------------------------------------------------------------------------
; Final (prison) initialization event
; ------------------------------------------------------------------------------

Init_FinalPrison:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Final (prison) draw event
; ------------------------------------------------------------------------------

Draw_FinalPrison:
	rts

; ------------------------------------------------------------------------------
; Final (prison) scrolling
; ------------------------------------------------------------------------------

Scroll_FinalPrison:
	move.w	#$3E0,map_fg_target_bottom			; Set bottom boundary
	cmpi.w	#$1780,camera_fg_x
	blt.s	.GotBottomBound
	move.w	#$4E0,map_fg_target_bottom
	
.GotBottomBound:
	cmpi.w	#$24C0,camera_fg_x				; Are we at the end of the stage?
	bcs.s	.NoStageEnd					; If not, branch

	st	go_to_rpg					; Go to RPG stage

.NoStageEnd:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Final (computer) initialization event
; ------------------------------------------------------------------------------

Init_FinalComputer:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Final (computer) draw event
; ------------------------------------------------------------------------------

Draw_FinalComputer:
	move.b	#$D,-(sp)					; Draw Ollie
	move.b	ollie_boss_frame,-(sp)
	clr.b	-(sp)
	move.w	#160,-(sp)
	move.w	#88,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Final (computer) scrolling
; ------------------------------------------------------------------------------

Scroll_FinalComputer:
	move.w	#$3E0,map_fg_target_bottom			; Set bottom boundary
	cmpi.w	#$1780,camera_fg_x
	blt.s	.GotBottomBound
	move.w	#$4E0,map_fg_target_bottom
	
.GotBottomBound:
	cmpi.w	#$2440,camera_fg_x				; Are we approaching the boss?
	blt.s	.GotLeftBound					; If not, branch
	
	move.w	camera_fg_x,map_fg_bound_left			; Prevent backtracking
	move.w	camera_fg_x,map_fg_target_left

	cmpi.w	#$25C0,camera_fg_x				; Are we at the boss?
	blt.s	.GotLeftBound					; If not, branch

	clr.w	cam_focus_object				; Stop focusing camera on player
	jsr	FadeSound					; Fade sound out

	jsr	SpawnObject					; Spawn boss
	move.l	#ObjOllieBoss,obj.update(a1)
	move.w	camera_fg_x,d0
	addi.w	#160,d0
	move.w	d0,obj.x(a1)
	move.w	camera_fg_y,d0
	addi.w	#112,d0
	move.w	d0,obj.y(a1)

	move.l	#.Boss,map_scroll				; Update scroll routine
	
.GotLeftBound:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------

.Boss:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Green Hill Zone (Ring Girl/Final (normal)) deformation table
; ------------------------------------------------------------------------------

	section m68k_rom_fixed_data
	
GhzDeformation:
	; Clouds
	DEFORM 32, camera_fg_x, $0060, -$0002AA00, $0000, 0
	DEFORM 16, camera_fg_x, $0060, -$00020000, $0000, 0
	DEFORM 16, camera_fg_x, $0060, -$00015500, $0000, 0

	; Mountains
	DEFORM 48, camera_fg_x, $0060,  $00000000, $0000, 0
	DEFORM 40, camera_fg_x, $0080,  $00000000, $0000, 0

	; Water
	DEFORM 72, camera_fg_x, $0080,  $00000000, $013B, 1

	DEFORM_END

; ------------------------------------------------------------------------------
; Scary Maze deformation table
; ------------------------------------------------------------------------------

	section m68k_rom_fixed_data
	
ScaryMazeDeformation:
	; Clouds
	DEFORM  48, camera_fg_x, $0000, -$0000FFC0, $0000, 0
	DEFORM  16, camera_fg_x, $0000, -$0000C000, $0000, 0
	DEFORM  16, camera_fg_x, $0000, -$00007FE0, $0000, 0

	; Hill
	DEFORM 144, camera_fg_x, $0000,  $00000000, $0000, 0

	DEFORM_END
	
; ------------------------------------------------------------------------------
