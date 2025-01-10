; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG stage scene
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/rpg/shared.inc"

; ------------------------------------------------------------------------------

RpgStageScene:
	bsr.w	GetStageId					; Set entry room
	lea	EntryRooms,a0
	add.w	d0,d0
	move.b	(a0,d0.w),rpg_room_id
	move.b	1(a0,d0.w),rpg_warp_entry_id

	bra.s	StartRpgStageScene

ResumeRpgStageScene:
	clr.b	rpg_warp_entry_id				; Reset warp entry ID

StartRpgStageScene:
	move.b	#-1,rpg_warp_room_id				; Reset warp room ID

	jsr	DisableAtGamesSound				; Disable AtGames sound mode
	jsr	WaitSoundCommand

RestartAoiOniChase:
	lea	Song_Drone,a0					; Play droning sound
	jsr	PlayMusic

RestartRpgStageScene:
	jsr	FadePaletteToBlack				; Fade to black
	jsr	DisableDisplay					; Disable display
	
	move	#$2700,sr					; Setup V-BLANK
	lea	VBlankRoutine,a0
	jsr	SetVBlankRoutine
	move.w	#$8004,VDP_CTRL					; Disable H-BLANK

	jsr	InitScene					; Initialize scene
	jsr	InitScript					; Initialize scripting
	clr.w	stage_frame_count				; Reset frame count
	
	move.w	#$8B03,VDP_CTRL					; Line horizontal scroll, screen vertical scroll

	moveq	#PLANE_SIZE_64_32,d0				; Set plane size to 64x32
	jsr	SetPlaneSize

	moveq	#CHUNK_SIZE_32,d0				; Set chunk size to 32x32
	jsr	SetMapChunkSize

	move.w	#$542-(' '*2),script_text_tile			; Set script text tile properties
	
	pea	MarsPal_Global					; Load global 32X palette
	move.b	#2,-(sp)
	clr.b	-(sp)
	jsr	LoadMarsPalette
	
	pea	MarsPal_Textbox					; Load textbox 32X palette
	move.b	#$F4,-(sp)
	move.b	#1,-(sp)
	jsr	LoadMarsPalette

	pea	MarsSpr_Textbox					; Load textbox 32X sprites
	clr.b	-(sp)
	move.b	#$F4,-(sp)
	jsr	LoadMarsSprites

	lea	Art_TextboxFont,a1				; Load font
	move.w	#$A840,d2
	jsr	QueueKosmData
	jsr	FlushKosmQueue

	CHECK_EVENT EVENT_STAGE_5				; Has stage 5 been beaten?
	beq.s	.NoStage5					; If not, branch
	CHECK_EVENT EVENT_ASSAULTED_WARDEN			; Did the player assault the warden?
	bne.w	PaddedCellCutscene				; If so, branch

.NoStage5:
	lea	RpgMapData,a0					; Load map data
	moveq	#0,d0
	move.b	rpg_room_id,d0
	jsr	LoadMapData

	jsr	FlushKosmQueue					; Flush Kosinski Moduled queue
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMarsGraphicsData
	
	cmpi.b	#-1,rpg_warp_entry_id				; Should we retrieve the player position?
	beq.s	.NoPlayerPos					; If not, branch

	movea.l	map_user_data,a0				; Get player position
	move.b	rpg_warp_entry_id,d0
	andi.w	#$7F,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a0,d0.w),rpg_warp_x
	move.w	2(a0,d0.w),rpg_warp_y

.NoPlayerPos:
	jsr	SpawnObject					; Spawn player
	move.w	a1,player_object
	move.l	#ObjRpgPlayer,obj.update(a1)
	move.w	rpg_warp_x,obj.x(a1)
	move.w	rpg_warp_y,obj.y(a1)
	move.b	rpg_warp_angle,rpg_obj.angle(a1)

	jsr	MapInitEvent					; Run map initialization event
	jsr	InitRpgCamera					; Initialize camera
	
	lea	ObjectIndex,a0					; Initialize map objects
	jsr	InitMapObjectSpawn

	jsr	UpdateFrame					; Update frame
	jsr	DrawFrame					; Draw frame
	jsr	WaitMars

	jsr	RefreshMap					; Refresh map
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMars
	
	cmpi.b	#-1,rpg_warp_room_id				; Were we warping?
	beq.s	.NoWarp						; If not, branch
	move.b	#-1,rpg_warp_room_id				; Reset warp room ID
	
	tst.b	rpg_warp_entry_id				; Did we enter a door?
	bpl.s	.NotDoor					; If not, branch
	cmpi.b	#-1,rpg_warp_entry_id				
	beq.s	.NotDoor					; If not, branch
	
	move.w	#$FF0F,MARS_COMM_12+MARS_SYS			; Play door close sound
	bra.s	.NoWarp

.NotDoor:
	move.w	#$FF00,MARS_COMM_10+MARS_SYS			; Stop PWM sample
	
.NoWarp:
	jsr	EnableDisplay					; Enable display
	jsr	FadePaletteIn					; Fade palette in
	
	bra.s	StartUpdateLoop					; Start update loop

; ------------------------------------------------------------------------------

UpdateLoop:
	jsr	VSync						; VSync
	addq.w	#1,stage_frame_count				; Increment frame counter
	bsr.w	DrawFrame					; Draw frame

StartUpdateLoop:
	move.b	next_sonic_stage,d0				; Should we go to a Sonic stage?
	beq.s	.NoSonicStage					; If not, branch
	
	move.b	d0,sonic_stage_id				; Go to Sonic stage
	jmp	SonicStageScene

.NoSonicStage:
	tst.b	sonic_cult_flashback				; Should we go to the Sonic CulT flashback?
	beq.s	.NoSonicCult					; If not, branch
	
	clr.b	sonic_cult_flashback				; Go to Sonic CulT flashback
	jmp	SonicCultFlashback

.NoSonicCult:
	tst.b	photo_cutscene					; Should we go to the photo cutscene?
	beq.s	.NoPhotoCutscene				; If not, branch

	clr.b	photo_cutscene					; Go to photo cutscene
	jmp	PhotoCutscene

.NoPhotoCutscene:
	tst.b	cut_to_black					; Should we cut to black?
	beq.s	.NoCutToBlack					; If not, branch

	clr.b	cut_to_black					; Cut to black
	jmp	RpgCutToBlack

.NoCutToBlack:
	tst.b	suspect_choose					; Should we go to the suspect choose screen?
	beq.s	.NoSuspectChoose				; If not, branch

	clr.b	suspect_choose					; Go to suspect choose screen
	jmp	SuspectChoose

.NoSuspectChoose:
	tst.b	ao_oni_touched					; Was Ao Oni touched?
	beq.s	.NoAoOni					; If not, branch

	jsr	StopSound					; Stop sound

	jsr	VSync						; Cut to black
	jsr	ClearMarsScreen
	moveq	#-7,d0
	jsr	SetPaletteFadeIntensity

	move.w	#$FF25,MARS_COMM_10+MARS_SYS			; Play crash sound

	moveq	#120,d0						; Delay for a bit
	jsr	Delay

	move.w	#$FF00,MARS_COMM_10+MARS_SYS			; Stop crash sound

	CLEAR_EVENT EVENT_HOSPITAL_HALLWAY			; Clear hospital hallway event flag
	bra.w	RestartAoiOniChase				; Restart stage

.NoAoOni:
	tst.b	silent_hill_cutscene				; Should we go to the Silent Hill cutscene?
	beq.s	.NoSilentHill					; If not, branch

	clr.b	silent_hill_cutscene				; Go to Silent Hill cutscene
	jmp	SilentHillCutscene

.NoSilentHill:
	tst.b	cult_front_door					; Should we go to the cult at front door cutscene?
	beq.s	.NoCultFrontDoor				; If not, branch

	clr.b	cult_front_door					; Go to cult at front door cutscene
	jmp	CultFrontDoorCutscene

.NoCultFrontDoor:
	tst.b	good_ending					; Should we go to the good ending cutscene?
	beq.s	.NoGoodEnding					; If not, branch

	clr.b	good_ending					; Go to good ending cutscene
	jmp	GoodEndingCutscene

.NoGoodEnding:
	tst.b	scary_maze_jumpscare				; Should we go to the Scary Maze jumpscare?
	beq.s	.NoScaryMaze					; If not, branch

	clr.b	scary_maze_jumpscare				; Go to Scary Maze jumpscare
	jmp	ScaryMazeJumpscare

.NoScaryMaze:
	move.b	rpg_warp_room_id,d0				; Are we warping to a new room?
	cmpi.b	#-1,d0
	beq.s	.NoWarp						; If not, branch
	
	move.b	d0,rpg_room_id					; Warp to new room
	bra.w	RestartRpgStageScene

.NoWarp:
	bsr.w	UpdateFrame					; Update frame
	bra.w	UpdateLoop					; Loop

; ------------------------------------------------------------------------------
; Get stage ID
; ------------------------------------------------------------------------------

GetStageId:
	CHECK_EVENT EVENT_STAGE_1				; Has stage 1 been completed?
	bne.s	.CheckStage2					; If so, branch
	moveq	#0,d0						; Stage 1
	rts

.CheckStage2:
	CHECK_EVENT EVENT_STAGE_2				; Has stage 2 been completed?
	bne.s	.CheckStage3					; If so, branch
	moveq	#1,d0						; Stage 2
	rts

.CheckStage3:
	CHECK_EVENT EVENT_STAGE_3				; Has stage 3 been completed?
	bne.s	.CheckStage4					; If so, branch
	moveq	#2,d0						; Stage 3
	rts

.CheckStage4:
	CHECK_EVENT EVENT_STAGE_4				; Has stage 4 been completed?
	bne.s	.CheckStage5					; If so, branch
	moveq	#3,d0						; Stage 4
	rts

.CheckStage5:
	CHECK_EVENT EVENT_STAGE_5				; Has stage 5 been completed?
	bne.s	.Stage6						; If so, branch

	moveq	#4,d0						; Stage 5 (bedroom)
	CHECK_EVENT EVENT_ASSAULTED_CULT			; Were the cult members at the front door assaulted?
	beq.s	.End						; If not, branch
	moveq	#5,d0						; Stage 5 (prison)
	rts

.Stage6:
	moveq	#8,d0						; Stage 6 (bedroom)
	CHECK_EVENT EVENT_ASSAULTED_CULT			; Were the cult members at the front door assaulted?
	bne.s	.Stage6Prison					; If so, branch
	rts

.Stage6Prison:
	moveq	#7,d0						; Stage 6 (prison beat-em-up)
	CHECK_EVENT EVENT_ASSAULTED_WARDEN			; Was the warden assaulted?
	bne.s	.End						; If so, branch
	moveq	#6,d0						; Stage 6 (dining room)

.End:
	rts

; ------------------------------------------------------------------------------
; Stage entry rooms
; ------------------------------------------------------------------------------

EntryRooms:
	dc.b	0, 0						; Ollie's bedroom
	dc.b	5, 0						; Ollie's garage
	dc.b	8, 0						; Hospital room
	dc.b	2, 2						; Ollie's living room
	dc.b	0, 3						; Ollie's bedroom
	dc.b	$B, 0						; Prison
	dc.b	3, 2						; Ollie's dining room
	dc.b	0, 0						; Prison beat-em-up
	dc.b	0, 4						; Ollie's bedroom
	even

; ------------------------------------------------------------------------------
; Update a frame
; ------------------------------------------------------------------------------

UpdateFrame:
	jsr	HandleAoOniMusic				; Handle Ao Oni music
	
	jsr	SpawnMapObjects					; Spawn map objects
	jsr	UpdateObjects					; Update objects
	
	movea.w	player_object,a1				; Check player's collision with objects
	btst	#PLAYER_NO_SOLID,obj.flags(a1)
	bne.s	.NoSolid
	jsr	CheckSolidObjectCollide

.NoSolid:
	jsr	UpdateObjectsPrevPos				; Update objects' previous positions

	jsr	UpdateScript					; Update script
	
	jsr	ProcessKosmQueue				; Process Kosinski moduled queue
	jmp	ProcessKosQueue					; Process Kosinski queue

; ------------------------------------------------------------------------------
; Draw a frame
; ------------------------------------------------------------------------------

DrawFrame:
	jsr	ClearMarsScreen					; Clear 32X screen

	jsr	UpdateCamera					; Update camera
	
	jsr	StartSpriteDraw					; Start drawing sprites
	jsr	MapDrawEvent					; Run map draw event
	jsr	DrawObjects					; Draw objects
	jsr	FinishSpriteDraw				; Finish drawing sprites
	
	jsr	DrawScriptTextbox				; Draw textbox

	jsr	UpdateMarsPaletteFade				; Update 32X palette fade
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands

	jsr	UpdateCram					; Update CRAM
	
	jsr	ScrollMap					; Scroll map
	jmp	DrawMap						; Draw map

; ------------------------------------------------------------------------------
; V-BLANK routine
; ------------------------------------------------------------------------------

VBlankRoutine:
	jmp	UpdateScriptTextbox				; Update script textbox

; ------------------------------------------------------------------------------
; Initialize camera
; ------------------------------------------------------------------------------

InitRpgCamera:
	movea.w	player_object,a6				; Focus on the player
	move.w	a6,cam_focus_object
	
	move.w	#4,camera_fg_x_speed				; Set camera speeds
	move.w	#4,camera_fg_y_speed
	move.w	#4,camera_bg_x_speed
	move.w	#4,camera_bg_y_speed
	
	move.w	#160,cam_focus_left				; Set camera focus
	move.w	#160,cam_focus_right
	move.w	#112,cam_focus_top
	move.w	#112,cam_focus_bottom

	move.w	obj.x(a6),d0					; Set camera position
	subi.w	#160,d0
	move.w	d0,camera_fg_x
	move.w	obj.y(a6),d0
	subi.w	#112,d0
	move.w	d0,camera_fg_y

	jmp	InitCamera					; Initialize camera

; ------------------------------------------------------------------------------
; Object index
; ------------------------------------------------------------------------------

ObjectIndex:
	dc.l	ObjRpgWarp
	dc.l	ObjRpgNpc
	dc.l	ObjRpgDecor
	dc.l	ObjRpgOverlay
	dc.l	ObjStoreItem
	dc.l	ObjTool
	dc.l	ObjAoOni

; ------------------------------------------------------------------------------
