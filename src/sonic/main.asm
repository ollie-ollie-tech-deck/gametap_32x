; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sonic stage scene
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------

SonicStageScene:
	move.b	#5,player_health				; Reset player health

	bsr.w	VSync						; Cut to black
	bsr.w	ClearMarsScreen
	moveq	#-7,d0
	bsr.w	SetPaletteFadeIntensity
	bsr.w	DisableDisplay
	
	jsr	SendMarsGraphicsCmds				; Send 32X graphics commands
	jsr	WaitMars

	move	#$2700,sr					; Setup V-BLANK
	bsr.w	ClearVBlankRoutine
	
	bsr.w	InitScene					; Initialize scene
	clr.w	stage_frame_count				; Reset frame count

	move.w	#$8B03,VDP_CTRL					; Line horizontal scroll, screen vertical scroll

	moveq	#PLANE_SIZE_64_32,d0				; Set plane size to 64x32
	bsr.w	SetPlaneSize

	moveq	#CHUNK_SIZE_128,d0				; Set chunk size to 128x128
	bsr.w	SetMapChunkSize

	pea	MarsPal_Global					; Load global 32X palette
	move.b	#2,-(sp)
	clr.b	-(sp)
	bsr.w	LoadMarsPalette

	pea	MarsSpr_SonicHealth				; Load health 32X sprites
	move.b	#$FF,-(sp)
	move.b	#2,-(sp)
	bsr.w	LoadMarsSprites

	lea	SonicMapData,a0					; Load map data
	moveq	#0,d0
	move.b	sonic_stage_id,d0
	bsr.w	LoadMapData
	
	movea.l	map_user_data,a0				; Set Yu-Gi-Oh cards address
	move.l	4(a0),map_yugioh_cards
	
	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	bsr.w	WaitMarsGraphicsData
	
	bsr.w	SpawnObject					; Spawn player
	move.w	a1,player_object
	move.l	#ObjSonicPlayer,obj.update(a1)
	
	movea.l	map_user_data,a0				; Set player position
	move.w	(a0)+,obj.x(a1)
	move.w	(a0)+,obj.y(a1)

	jsr	MapInitEvent					; Run map initialization event
	bsr.w	InitSonicCamera					; Initialize camera

	lea	ObjectIndex,a0					; Initialize map objects
	bsr.w	InitMapObjectSpawn
	bsr.w	InitYugiohCards					; Initialize Yu-Gi-Oh cards
	bsr.w	InitCollapsePieces				; Initialize collapsing pieces

	bsr.w	UpdateFrame					; Update frame
	bsr.w	DrawFrame					; Draw frame
	bsr.w	WaitMars

	jsr	RefreshMap					; Refresh map
	
	move.b	#4-1,yugioh_anim_timer				; Reset Yu-Gi-Oh card animation timer

	bsr.w	DisableAtGamesSound				; Disable AtGames sound mode
	bsr.w	WaitSoundCommand

	cmpi.b	#2,sonic_stage_id				; Are we in the Ben Drowned stage?
	bne.s	.PlayMusic					; If not, branch

	bsr.w	EnableAtGamesSound				; Enable AtGames sound mode
	bsr.w	WaitSoundCommand

.PlayMusic:
	movea.l	map_user_data,a0				; Play music
	movea.l	8(a0),a0
	bsr.w	PlayMusic

	bsr.w	VSync						; Enable display
	moveq	#0,d0
	bsr.w	SetPaletteFadeIntensity
	bsr.w	EnableDisplay
	
	move.w	#$D000,d0
	move.l	#$1000,d1
	moveq	#1,d2
	bsr.w	FillVramRegion

	bra.s	StartUpdateLoop					; Start update loop

; ------------------------------------------------------------------------------

UpdateLoop:
	bsr.w	VSync						; VSync

	tst.w	ben_appear					; Is there a Ben object that's appearing?
	bne.s	.Draw						; If so, branch
	addq.w	#1,stage_frame_count				; Increment frame counter

.NoFrameCountInc:
	tst.b	p1_ctrl_tap					; Was the start button pressed?
	bpl.s	.Draw						; If so, branch
	bsr.w	PauseSound					; Pause sound

.PauseLoop:
	bsr.w	VSync						; VSync
	tst.b	p1_ctrl_tap					; Was the start button pressed?
	bpl.s	.PauseLoop					; If so, branch
	bsr.w	UnpauseSound					; Unpause sound

.Draw:
	bsr.w	DrawFrame					; Draw frame

StartUpdateLoop:
	bsr.w	UpdateFrame					; Update frame

	tst.b	restart_stage					; Should we restart the stage?
	bne.w	SonicStageScene					; If so, branch

	tst.b	go_to_rpg					; Should we go to the RPG stage?
	bne.s	.GoToRpgStage					; If so, branch

	tst.b	boss_end					; Should we finish the boss fight?
	bne.s	.BossEnd					; If so, branch

	tst.b	ring_girl_transition				; Should we go to the Ring Girl transition?
	bne.w	.RingGirlTransition				; If so, branch

	tst.b	ben_tear_screen					; Should we go to the Ben tear screen?
	bne.w	.BenTearScreen					; If so, branch

	tst.b	go_to_scary_maze				; Should we go to the Scary Maze?
	bne.w	.ScaryMaze					; If so, branch

	tst.b	ollie_boss_restart				; Should we restart the Ollie boss?
	bne.w	.RestartOllieBoss				; If so, branch

	bra.w	UpdateLoop					; Loop

.GoToRpgStage:
	bsr.w	FadeSound					; Fade sound out
	bsr.w	FadePaletteToBlack				; Fade to black

	moveq	#60,d0						; Delay for a bit
	bsr.w	Delay

	jmp	RpgStageScene					; Go to RPG stage

.BossEnd:
	bsr.w	StopSound					; Stop sound
	bsr.w	WaitSoundCommand

	lea	Sfx_Warp,a0					; Play warp sound
	bsr.w	PlaySfx

	bsr.w	FadePaletteToWhite				; Fade to white
	
	moveq	#60,d0						; Delay for a bit
	bsr.w	Delay

	move	#$2700,sr					; Disable interrupts
	bsr.w	ClearVram					; Clear VRAM
	bsr.w	ClearVsram					; Clear VSRAM
	bsr.w	ClearMarsScreen					; Clear screen
	bsr.w	WaitMarsDraw

	bsr.w	FadePaletteToBlack				; Fade to black
	
	cmpi.b	#$B,sonic_stage_id				; Are we at the final boss?
	beq.s	.GoToRpgStage					; If so, branch

	addq.b	#1,sonic_stage_id				; Go to next stage
	bra.w	SonicStageScene

.RingGirlTransition:
	bra.w	RingGirlTransition				; Go to Ring Girl transition

.BenTearScreen:
	bra.w	BenTearScreen					; Go to Ben tear screen
	
.ScaryMaze:
	move.b	#$C,rpg_room_id					; Go to Scary Maze
	jmp	ResumeRpgStageScene

.RestartOllieBoss:
	bsr.w	StopSound					; Stop sound

	bsr.w	VSync						; Cut to black
	bsr.w	ClearMarsScreen
	moveq	#-7,d0
	bsr.w	SetPaletteFadeIntensity

	move.w	#$FF25,MARS_COMM_10+MARS_SYS			; Play crash sound

	moveq	#120,d0						; Delay for a bit
	bsr.w	Delay

	move.w	#$FF00,MARS_COMM_10+MARS_SYS			; Stop crash sound

	clr.b	player_health					; Restart Sonic stage
	bra.w	SonicStageScene

; ------------------------------------------------------------------------------
; Update a frame
; ------------------------------------------------------------------------------

UpdateFrame:
	move.w	ben_appear,d0					; Is there a Ben object that's appearing?
	beq.s	.NoBen						; If not, branch
	
	move.w	cur_ben_object,d1				; Set current Ben object 
	move.w	d0,cur_ben_object
	cmp.w	d0,d1
	bne.s	.NoBen						; If it changed, branch
	rts

.NoBen:
	bsr.w	SpawnMapObjects					; Spawn map objects
	bsr.w	UpdateObjects					; Update objects
	
	movea.w	player_object,a6				; Check player collision with objects
	bsr.w	CheckSonicSolidObjects
	bsr.w	CheckYugiohCardCollide
	
	bsr.w	UpdateObjectsPrevPos				; Update objects' previous positions
	bsr.w	UpdateCollapsePieces				; Update collapsing pieces

	subq.b	#1,yugioh_anim_timer				; Decrement Yu-Gi-Oh card animation timer
	bpl.s	.End						; If it hasn't run out, branch
	move.b	#4-1,yugioh_anim_timer				; Reset Yu-Gi-Oh card animation timer
	
	addq.b	#1,yugioh_anim_frame				; Animate Yu-Gi-Oh cards
	andi.b	#7,yugioh_anim_frame
	
.End:
	rts

; ------------------------------------------------------------------------------
; Draw a frame
; ------------------------------------------------------------------------------

DrawFrame:
	bsr.w	ClearMarsScreen					; Clear 32X screen
	
	bsr.w	UpdateCameraYFocus				; Update vertical camera focus
	bsr.w	UpdateCamera					; Update camera
	
	bsr.w	StartSpriteDraw					; Start drawing sprites

	jsr	MapDrawEvent					; Run map draw event
	bsr.w	DrawObjects					; Draw objects
	bsr.w	DrawCollapsePieces				; Draw collapsing pieces
	bsr.w	DrawYugiohCards					; Draw Yu-Gi-Oh cards

	st	-(sp)						; Draw health sprite
	move.b	player_health,-(sp)
	clr.b	-(sp)
	move.w	#261,-(sp)
	move.w	#24,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite
	
	bsr.w	FinishSpriteDraw				; Finish drawing sprites

	bsr.w	UpdateMarsPaletteFade				; Update 32X palette fade
	bsr.w	SendMarsGraphicsCmds				; Send 32X graphics commands
	
	bsr.w	UpdateCram					; Update CRAM
	
	bsr.w	ScrollMap					; Scroll map
	bsr.w	DrawMap						; Draw map
	
	bsr.w	ProcessKosmQueue				; Process Kosinski moduled queue
	bra.w	ProcessKosQueue					; Process Kosinski queue

; ------------------------------------------------------------------------------
; Initialize camera
; ------------------------------------------------------------------------------

InitSonicCamera:
	movea.w	player_object,a6				; Focus on the player
	move.w	a6,cam_focus_object
	
	move.w	#16,camera_fg_x_speed				; Set camera speeds
	move.w	#16,camera_bg_x_speed
	move.w	#16,camera_bg_y_speed
	
	move.w	#160,cam_focus_left				; Set horizontal camera focus
	move.w	#160,cam_focus_right

	move.w	obj.x(a6),d0					; Set camera position
	subi.w	#160,d0
	move.w	d0,camera_fg_x
	move.w	obj.y(a6),d0
	subi.w	#96,d0
	move.w	d0,camera_fg_y
	
	bsr.s	UpdateCameraYFocus				; Set vertical camera focus
	bra.w	InitCamera					; Initialize camera
	
; ------------------------------------------------------------------------------
; Set camera Y focus
; ------------------------------------------------------------------------------

UpdateCameraYFocus:
	tst.w	ben_appear					; Is Ben appearing?
	bne.s	.End						; If so, branch

	move.w	cam_focus_object,a6				; Get focus object (the player)

	move.w	#16,camera_fg_y_speed				; Set default foreground camera Y speed
	move.w	#64,cam_focus_top				; Set airborne vertical camera focus
	move.w	#128,cam_focus_bottom

	btst	#SONIC_AIR,obj.flags(a6)			; Is the player in the air?
	bne.s	.End						; If so, branch

	move.w	#96,cam_focus_top				; Set grounded vertical camera focus
	move.w	#96,cam_focus_bottom

	move.w	player.ground_speed(a6),d0			; Get the absolute value of the player's ground speed
	bpl.s	.CheckSpeed
	neg.w	d0

.CheckSpeed:
	cmpi.w	#$800,d0					; Is the player going >= 8 pixels/frame?
	bcc.s	.End						; If so, branch
	move.w	#6,camera_fg_y_speed				; If not, limit the foreground camera Y speed

.End:
	rts

; ------------------------------------------------------------------------------
; Object index
; ------------------------------------------------------------------------------

ObjectIndex:
	dc.l	ObjPathSwapper
	dc.l	ObjMonitor
	dc.l	ObjSonicOverlay
	dc.l	ObjPlatform
	dc.l	ObjBridge
	dc.l	ObjBridgeStump
	dc.l	ObjCollapseLedge
	dc.l	ObjWall
	dc.l	ObjMotobug
	dc.l	ObjBuzzBomber
	dc.l	ObjCrabmeat
	dc.l	ObjChopper
	dc.l	ObjNewtron
	dc.l	ObjRock
	dc.l	ObjSpikes
	dc.l	ObjSpring
	dc.l	ObjBen
	dc.l	ObjEyeball
	dc.l	ObjBlockbuster
	dc.l	ObjButton
	dc.l	ObjSpinTunnel

; ------------------------------------------------------------------------------
