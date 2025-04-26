; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG player object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/rpg/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjRpgPlayer:
	SET_OBJECT_LAYER move.w,2,obj.layer(a6)			; Set layer
	
	move.w	#10,obj.collide_width(a6)			; Set hitbox size
	move.w	#14,obj.collide_height(a6)
	
	move.w	#20,obj.draw_width(a6)				; Set draw size
	move.w	#20,obj.draw_height(a6)
	
	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine
	
	moveq	#0,d0						; Run room specific initialization
	move.b	rpg_room_id,d0
	add.w	d0,d0
	add.w	d0,d0
	jmp	.RoomInit(pc,d0.w)
	
; ------------------------------------------------------------------------------

.RoomInit:
	bra.w	InitBedroom					; Bedroom
	bra.w	InitBathroom					; Bathroom
	bra.w	InitLivingRoom					; Living room
	bra.w	InitDiningRoom					; Dining room
	bra.w	InitOutsideHouse				; Outside of house
	bra.w	InitGarage					; Garage
	bra.w	UpdateState					; 7-Eleven street
	bra.w	Init7ElevenStore				; 7-Eleven store
	bra.w	InitHospitalRoom				; Hospital room
	bra.w	InitHospitalHallway				; Hospital hallway
	bra.w	InitOutsideHospital				; Outside of hospital
	bra.w	InitPrison					; Prison
	bra.w	InitScaryMaze					; Scary Maze 1
	bra.w	InitScaryMaze					; Scary Maze 2
	bra.w	InitScaryMaze					; Scary Maze 3

; ------------------------------------------------------------------------------
; Bedroom initialization
; ------------------------------------------------------------------------------

InitBedroom:
	CHECK_EVENT EVENT_STAGE_1				; Have we beaten stage 1?
	bne.w	CheckCultistCapture				; If so, branch
	CHECK_EVENT EVENT_MICROWAVE				; Should we spray some Axe Body Spray?
	bne.s	AxeBodySprayState				; If so, branch
	CHECK_EVENT EVENT_WAKE_UP				; Have we woken up?
	bne.w	UpdateState					; If so, branch
	
	move.b	#2,rpg_obj.angle(a6)				; Face down
	
	lea	WakeUpScript,a0					; Run wake up script
	jsr	StartScript
	
	move.l	#WalkToBathroomState,obj.update(a6)		; Prepare to walk to bathroom

; ------------------------------------------------------------------------------
; Walk to bathroom state
; ------------------------------------------------------------------------------

WalkToBathroomState:
	CHECK_EVENT EVENT_WAKE_UP				; Have we woken up?
	beq.w	Update						; If not, branch
	
	move.w	#$200,obj.y_speed(a6)				; Walk down
	move.l	#.WalkDown,obj.update(a6)
	
; ------------------------------------------------------------------------------

.WalkDown:
	cmpi.w	#$130,obj.y(a6)					; Have we walked all the way down?
	blt.w	Update						; If not, branch
	
	move.w	#$200,obj.x_speed(a6)				; Walk right
	clr.w	obj.y_speed(a6)
	move.l	#Update,obj.update(a6)
	bra.w	Update

; ------------------------------------------------------------------------------
; Axe Body Spray state
; ------------------------------------------------------------------------------

AxeBodySprayState:
	move.w	#-$200,obj.y_speed(a6)				; Walk up
	move.l	#.WalkUp,obj.update(a6)
	
; ------------------------------------------------------------------------------

.WalkUp:
	cmpi.w	#$E2,obj.y(a6)					; Have we walked all the way up?
	bgt.w	Update						; If not, branch
	
	move.w	#$E2,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)
	
	move.w	#-$200,obj.x_speed(a6)				; Walk left
	move.l	#.WalkLeft,obj.update(a6)
	
; ------------------------------------------------------------------------------

.WalkLeft:
	cmpi.w	#$1E8,obj.x(a6)					; Have we walked all the way left?
	bgt.w	Update						; If not, branch
	
	move.w	#$1E8,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)
	move.b	#2,rpg_obj.angle(a6)
	
	lea	AxeBodySprayScript,a0				; Run Axe Body Spray script
	jsr	StartScript
	move.l	#.WaitSpray,obj.update(a6)
	
; ------------------------------------------------------------------------------

.WaitSpray:
	CHECK_EVENT EVENT_AXE_KNOCKOUT				; Should we animate the knockout?
	beq.w	Update						; If not, branch
	
	lea	obj.anim(a6),a0					; Set spray animation
	lea	Anim_Player(pc),a1
	moveq	#6,d0
	jsr	SetAnimation
	
	move.l	#.WaitDizzy,obj.update(a6)			; Wait until dizzy
	
; ------------------------------------------------------------------------------

.WaitDizzy:
	bsr.w	.CheckSoundPlay					; Check if a sound should be played
	
	cmpi.w	#7,obj.anim+anim.id(a6)				; Are we dizzy?
	bne.s	.Update						; If not, branch

	lea	DizzyScript,a0					; Run dizzy script
	jsr	StartScript
	
	move.l	#.WaitKnockout,obj.update(a6)			; Wait until knocked out
	
; ------------------------------------------------------------------------------

.WaitKnockout:
	bsr.s	.CheckSoundPlay					; Check if a sound should be played
	
	tst.l	script_address					; Is the script running?
	bne.s	.Update						; If so, branch
	
	lea	obj.anim(a6),a0					; Set knockout animation
	lea	Anim_Player(pc),a1
	moveq	#8,d0
	jsr	SetAnimation
	
	move.l	#.WaitNextStage,obj.update(a6)			; Wait until next stage
	move.b	#120,player.timer(a6)
	
; ------------------------------------------------------------------------------

.WaitNextStage:
	subq.b	#1,player.timer(a6)				; Decrement timer
	bne.s	.NoNextStage					; If not, branch
	
	SET_EVENT EVENT_STAGE_1					; Stage 1 finished
	move.b	#1,next_sonic_stage				; Go to Ring Girl boss
	rts

.NoNextStage:
	bsr.s	.CheckSoundPlay					; Check if a sound should be played
	
	tst.b	player.shake_timer(a6)				; Is the shake timer active?
	beq.s	.NoShake					; If not, branch
	subq.b	#1,player.shake_timer(a6)			; Decrement shake timer
	
	btst	#0,player.shake_timer(a6)			; Should we perform the shake?
	bne.s	.Update						; If not, branch
	
	eori.w	#2,camera_fg_y_shake				; Shake screen
	eori.w	#2,camera_bg_y_shake
	bra.s	.Update

.NoShake:
	clr.w	camera_fg_y_shake				; Stop shaking screen
	clr.w	camera_bg_y_shake

.Update:
	jsr	UpdateRpgObject					; Update
	jsr	RpgObjectMapCollide				; Check map collision
	
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------

.CheckSoundPlay:
	move.w	#$FF00,d0					; Get sound play command
	move.b	obj.anim+anim.frame(a6),d0		
	clr.b	obj.anim+anim.frame(a6)
	
	tst.b	d0						; Is there a sound to play?
	beq.s	.NoSound					; If there is no sound, branch
	move.w	d0,MARS_COMM_10+MARS_SYS			; Play sound
	
	cmpi.b	#$19,d0						; Was it the wall smash sound?
	bne.s	.NoSound					; If not, branch
	
	SET_EVENT EVENT_WALL_SMASH				; Mark wall as smashed
	move.b	#12,player.shake_timer(a6)			; Set shake timer

.NoSound:
	rts

; ------------------------------------------------------------------------------
; Check cultist capture
; ------------------------------------------------------------------------------

CheckCultistCapture:
	CHECK_EVENT EVENT_STAGE_3				; Have we beaten stage 3?
	beq.w	UpdateState					; If not, branch
	CHECK_EVENT EVENT_STAGE_4				; Have we beaten stage 4?
	bne.s	CheckCultEscape					; If so, branch
	
	lea	CultistCaptureScript,a0				; Run cultist capture script
	jsr	StartScript

	move.l	#Update,obj.update(a6)				; Set state
	bra.w	Update

; ------------------------------------------------------------------------------
; Check cult capture
; ------------------------------------------------------------------------------

CheckCultEscape:
	CHECK_EVENT EVENT_STAGE_5				; Have we beaten stage 5?
	bne.s	CheckGoodEnding					; If so, branch
	CHECK_EVENT EVENT_ASSAULTED_CULT			; Did we assault the cultists at the front door?
	bne.w	UpdateState					; If so, branch
	
	move.b	#2,rpg_obj.angle(a6)				; Face down
	
	lea	CultEscapeScript,a0				; Run cult escape script
	jsr	StartScript

	move.l	#Update,obj.update(a6)				; Set state
	bra.w	Update

; ------------------------------------------------------------------------------
; Check good ending
; ------------------------------------------------------------------------------

CheckGoodEnding:
	CHECK_EVENT EVENT_CULT_KILLED				; Was the cult killed?
	beq.w	UpdateState					; If not, branch
	
	move.b	#4,rpg_obj.angle(a6)				; Face left
	
	lea	GoodEndingScript,a0				; Run good ending script
	jsr	StartScript

	move.l	#Update,obj.update(a6)				; Set state
	bra.w	Update

; ------------------------------------------------------------------------------
; Bathroom initialization
; ------------------------------------------------------------------------------

InitBathroom:
	CHECK_EVENT EVENT_STAGE_1				; Have we beaten stage 1?
	bne.w	UpdateState					; If so, branch
	CHECK_EVENT EVENT_MIRROR				; Have we gone to the bathroom?
	bne.w	UpdateState					; If so, branch
	
	move.l	#WalkToMirrorState,obj.update(a6)		; Start walking to mirror

; ------------------------------------------------------------------------------
; Walk to mirror state
; ------------------------------------------------------------------------------

WalkToMirrorState:
	move.w	#$200,obj.x_speed(a6)				; Walk right
	move.l	#.WalkRight,obj.update(a6)
	
; ------------------------------------------------------------------------------

.WalkRight:
	cmpi.w	#$12C,obj.x(a6)					; Have we walked all the way right?
	blt.w	Update						; If not, branch
	
	move.w	#$12C,obj.x(a6)					; Walk up
	clr.w	obj.x_speed(a6)
	move.w	#-$200,obj.y_speed(a6)
	move.l	#.WalkUp,obj.update(a6)

; ------------------------------------------------------------------------------

.WalkUp:
	cmpi.w	#$160,obj.y(a6)					; Have we walked all the way up?
	bgt.w	Update						; If not, branch

	move.w	#$160,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)
	
	lea	MirrorScript,a0					; Run mirror script
	jsr	StartScript
	move.l	#.WaitScript,obj.update(a6)
	
; ------------------------------------------------------------------------------

.WaitScript:
	tst.l	script_address					; Is the script running?
	bne.w	Update						; If so, branch
	
	move.l	#UpdateState,obj.update(a6)			; Give control to the player
	move.b	#2,rpg_obj.angle(a6)
	bra.w	UpdateState

; ------------------------------------------------------------------------------
; Living room initialization
; ------------------------------------------------------------------------------

InitLivingRoom:
	CHECK_EVENT EVENT_STAGE_1				; Have we beaten stage 1?
	bne.s	CheckBreakIn					; If so, branch
	CHECK_EVENT EVENT_MICROWAVE				; Have we started the microwave?
	bne.s	WalkToBedroomState				; If so, branch
	CHECK_EVENT EVENT_7ELEVEN_HOME				; Have we already run the script?
	bne.w	UpdateState					; If so, branch
	CHECK_EVENT EVENT_7ELEVEN				; Did we get our items?
	beq.w	UpdateState					; If not, branch
	
	lea	CupNoodlesScript,a0				; Run Cup Noodles script
	jsr	StartScript
	bra.w	UpdateState

; ------------------------------------------------------------------------------
; Walk to bedroom state
; ------------------------------------------------------------------------------

WalkToBedroomState:
	move.l	#.WalkLeft,obj.update(a6)			; Walk left
	move.w	#-$200,obj.x_speed(a6)
	
; ------------------------------------------------------------------------------

.WalkLeft:
	cmpi.w	#$150,obj.x(a6)					; Have we walked all the way left?
	bgt.w	Update						; If not, branch
	
	move.w	#$150,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)
	
	move.w	#-$200,obj.y_speed(a6)				; Walk up
	move.l	#Update,obj.update(a6)
	bra.w	Update

; ------------------------------------------------------------------------------
; Check break in
; ------------------------------------------------------------------------------

CheckBreakIn:
	CHECK_EVENT EVENT_STAGE_2				; Have we beaten stage 2?
	bne.w	CheckReturnHome					; If so, branch
	CHECK_EVENT EVENT_BREAK_IN				; Has there been a break-in?
	beq.w	UpdateState					; If not, branch

	move.l	#WalkToBurglarState,obj.update(a6)		; Walk left
	move.w	#-$200,obj.x_speed(a6)

; ------------------------------------------------------------------------------
; Walk to burglar state
; ------------------------------------------------------------------------------

WalkToBurglarState:
	cmpi.w	#$150,obj.x(a6)					; Have we walked all the way left?
	bgt.w	Update						; If not, branch
	
	move.w	#$150,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)
	
	move.w	#$200,obj.y_speed(a6)				; Walk down
	move.l	#.WalkDown,obj.update(a6)
	
	cmpi.w	#$D8,obj.y(a6)					; Are we above the burglar?
	blt.s	.WalkDown					; If so, branch
	
	neg.w	obj.y_speed(a6)					; Walk up
	move.l	#.WalkUp,obj.update(a6)

; ------------------------------------------------------------------------------

.WalkUp:
	cmpi.w	#$D8,obj.y(a6)					; Are we close to the burglar?
	bgt.w	Update						; If not, branch
	
	move.w	#$D8,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)
	bra.s	.StartScript

; ------------------------------------------------------------------------------

.WalkDown:
	cmpi.w	#$D8,obj.y(a6)					; Are we close to the burglar?
	blt.w	Update						; If not, branch
	
	move.w	#$D8,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

; ------------------------------------------------------------------------------

.StartScript:
	move.b	#4,rpg_obj.angle(a6)				; Face left

	lea	BurglarScript,a0				; Run burglar script
	jsr	StartScript

	move.l	#Update,obj.update(a6)				; Set state
	bra.w	Update

; ------------------------------------------------------------------------------
; Check return home
; ------------------------------------------------------------------------------

CheckReturnHome:
	CHECK_EVENT EVENT_STAGE_4				; Have we beaten stage 4?
	bne.w	UpdateState					; If so, branch
	CHECK_EVENT EVENT_RETURNED_HOME				; Have we already run the script?
	bne.w	UpdateState					; If so, branch

	move.w	#$FF0F,MARS_COMM_10+MARS_SYS			; Play door close sound
	
	move.l	#.MoveUp,obj.update(a6)				; Move up
	move.w	#-$200,obj.y_speed(a6)
	move.b	#6,rpg_obj.angle(a6)

; ------------------------------------------------------------------------------

.MoveUp:
	cmpi.w	#$100,obj.y(a6)					; Have we moved up enough?
	bne.w	Update						; If not, branch

	move.w	#$100,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

	lea	ReturnHomeScript,a0				; Run return home script
	jsr	StartScript

	move.l	#Update,obj.update(a6)				; Set state
	bra.w	Update

; ------------------------------------------------------------------------------
; Ollie's dining room initialization
; ------------------------------------------------------------------------------

InitDiningRoom:
	CHECK_EVENT EVENT_STAGE_5				; Have we beaten stage 5?
	beq.w	UpdateState					; If not, branch
	
	clr.b	rpg_obj.angle(a6)				; Face right
	
	lea	NeutralEndingScript,a0				; Run neutral ending script
	jsr	StartScript

	move.l	#Update,obj.update(a6)				; Set state
	bra.w	Update

; ------------------------------------------------------------------------------
; Outside of Ollie's house initialization
; ------------------------------------------------------------------------------

InitOutsideHouse:
	CHECK_EVENT EVENT_STAGE_1				; Have we beaten stage 1?
	beq.w	UpdateState					; If not, branch
	CHECK_EVENT EVENT_STAGE_2				; Have we beaten stage 2?
	bne.w	UpdateState					; If so, branch
	CHECK_EVENT EVENT_LEFT_CAR				; Have we left the car?
	bne.w	UpdateState					; If so, branch

	bset	#PLAYER_HIDDEN,obj.flags(a6)			; Hide ourselves

	jsr	SpawnObject					; Spawn car
	move.l	#ObjRpgDecor,obj.update(a1)
	move.w	#240,obj.x(a1)
	move.w	#224,obj.y(a1)
	move.b	#$11,obj.subtype(a1)
	move.w	a1,player.car(a6)

	move.l	#BackOutGarageState,obj.update(a6)		; Wait to open door
	move.b	#60,player.timer(a6)

; ------------------------------------------------------------------------------
; Back out of garage state
; ------------------------------------------------------------------------------

BackOutGarageState:
	subq.b	#1,player.timer(a6)				; Decrement timer
	beq.s	.OpenDoor					; If it hasn't run out, branch
	rts

.OpenDoor:
	move.l	#.MoveDoorUp,obj.update(a6)			; Open door
	move.w	#$FF20,MARS_COMM_10+MARS_SYS

; ------------------------------------------------------------------------------

.MoveDoorUp:
	movea.w	player.garage_door(a6),a1			; Move garage door up
	subi.l	#$4000,obj.y(a1)
	cmpi.w	#216,obj.y(a1)					; Has it moved up enough?
	ble.s	.StopDoor					; If so, branch
	rts

.StopDoor:
	move.l	#.WaitBackOut,obj.update(a6)			; Wait to back car out
	move.b	#30,player.timer(a6)

; ------------------------------------------------------------------------------

.WaitBackOut:
	subq.b	#1,player.timer(a6)				; Decrement timer
	beq.s	.StartBackOut					; If it hasn't run out, branch
	rts

.StartBackOut:
	move.l	#.BackCarOut,obj.update(a6)			; Back car out
	move.w	#$FF21,MARS_COMM_10+MARS_SYS

; ------------------------------------------------------------------------------

.BackCarOut:
	movea.w	player.car(a6),a1				; Move car down
	addq.w	#1,obj.y(a1)
	cmpi.w	#448,obj.y(a1)					; Has the car moved down enough?
	blt.s	.End						; If not, branch

	movea.w	player.crashing_car(a6),a1			; Move crashing car left
	subq.w	#6,obj.x(a1)
	cmpi.w	#288,obj.x(a1)					; Has the crashing car moved left enough?
	bgt.s	.End						; If not, branch

	st	cut_to_black					; Cut to black

.End:
	rts

; ------------------------------------------------------------------------------
; Garage initialization
; ------------------------------------------------------------------------------

InitGarage:
	CHECK_EVENT EVENT_STAGE_1				; Have we beaten stage 1?
	beq.w	UpdateState					; If so, branch
	CHECK_EVENT EVENT_STAGE_2				; Have we beaten stage 2?
	bne.w	UpdateState					; If so, branch
	CHECK_EVENT EVENT_LEFT_CAR				; Have we left the car?
	bne.w	UpdateState					; If so, branch
	
	bset	#PLAYER_HIDDEN,obj.flags(a6)			; Hide ourselves
	move.b	#4,rpg_obj.angle(a6)				; Face left
	
	lea	GarageScript,a0					; Run garage script
	jsr	StartScript
	bra.w	UpdateState

; ------------------------------------------------------------------------------
; 7-Eleven store initialization
; ------------------------------------------------------------------------------

Init7ElevenStore:
	CHECK_EVENT EVENT_7ELEVEN				; Have we started shopping?
	bne.w	UpdateState					; If so, branch
	
	lea	Start7ElevenScript,a0				; Run 7-Eleven start script
	jsr	StartScript
	bra.w	UpdateState

; ------------------------------------------------------------------------------
; Hospital room initialization
; ------------------------------------------------------------------------------

InitHospitalRoom:
	bset	#PLAYER_NO_SOLID,obj.flags(a6)			; Ignore solid objects

	lea	obj.anim(a6),a0					; Set hospital bed animation
	lea	Anim_Player(pc),a1
	moveq	#9,d0
	jsr	SetAnimation

	CHECK_EVENT EVENT_SUSPECT_CHOOSE			; Have we chosen a suspect?
	bne.s	.SuspectChosen					; If so, branch

	lea	HospitalRoomScript,a0				; Run hospital room
	jsr	StartScript
	
	move.l	#DrawObject,obj.update(a6)			; Set state
	jmp	DrawObject

; ------------------------------------------------------------------------------

.SuspectChosen:
	jsr	SpawnObject					; Spawn cop
	move.l	#ObjRpgNpc,obj.update(a1)
	move.b	#2,obj.subtype(a1)
	move.w	#$134,obj.x(a1)
	move.w	#$130,obj.y(a1)
	move.b	#6,rpg_obj.angle(a1)

	lea	HospitalRoomScript2,a0				; Run second hospital room
	jsr	StartScript
	
	move.l	#DrawObject,obj.update(a6)			; Set state
	jmp	DrawObject

; ------------------------------------------------------------------------------
; Hospital hallway initialization
; ------------------------------------------------------------------------------

InitHospitalHallway:
	move.l	#.MoveDown,obj.update(a6)			; Move down
	move.w	#$400,obj.y_speed(a6)

; ------------------------------------------------------------------------------

.MoveDown:
	cmpi.w	#$250,obj.y(a6)					; Have we moved far enough?
	blt.w	Update						; If not, branch

	lea	HospitalHallwayScript,a0			; Run second hospital room
	jsr	StartScript

	move.l	#.WaitPause,obj.update(a6)			; Wait for script pause

; ------------------------------------------------------------------------------

.WaitPause:
	btst	#SCRIPT_PAUSE_FLAG,script_flags			; Is the script paused?
	beq.w	Update						; If not, branch

	jsr	UnpauseScript					; Unpause script

	move.l	#UpdateState,obj.update(a6)			; Set state
	bra.w	UpdateState

; ------------------------------------------------------------------------------
; Outside of hospital initialization
; ------------------------------------------------------------------------------

InitOutsideHospital:
	lea	OutsideHospitalScript,a0			; Run outside of hospital room script
	jsr	StartScript
	bra.w	UpdateState

; ------------------------------------------------------------------------------
; Prison initialization
; ------------------------------------------------------------------------------

InitPrison:
	move.b	#2,rpg_obj.angle(a6)				; Face down
	
	lea	PrisonStartScript,a0				; Run prison start script
	jsr	StartScript
	bra.w	UpdateState

; ------------------------------------------------------------------------------
; Scary Maze initialization
; ------------------------------------------------------------------------------

InitScaryMaze:
	move.w	#1,obj.collide_width(a6)			; Set hitbox size
	move.w	#1,obj.collide_height(a6)
	
	move.w	#4,obj.draw_width(a6)				; Set draw size
	move.w	#4,obj.draw_height(a6)
	
	move.l	#ScaryMazeState,obj.update(a6)			; Set state
	move.l	#DrawScaryMaze,obj.draw(a6)			; Set draw routine
	bra.w	ScaryMazeState

; ------------------------------------------------------------------------------
; 7-Eleven not done state
; ------------------------------------------------------------------------------

RpgPlayer7ElevenState:
	lea	Not7ElevenDoneScript,a0				; Run 7-Eleven not done script
	jsr	StartScript
	
	move.l	#Update,obj.update(a6)				; Set state
	bra.w	Update

; ------------------------------------------------------------------------------
; Walk up from 7-Eleven door
; ------------------------------------------------------------------------------

WalkUp7ElevenState:
	cmpi.w	#$1B0,obj.y(a6)					; Have we walked all the way up?
	bgt.w	Update						; If not, branch

	move.w	#$1B0,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)
	
	move.l	#UpdateState,obj.update(a6)			; Give control to the player
	jsr	UnpauseScript
	bra.w	Update

; ------------------------------------------------------------------------------
; Walk to living room state
; ------------------------------------------------------------------------------

RpgPlayerLivingRoomState:
	cmpi.w	#$110,obj.y(a6)					; Have we walked all the way down?
	blt.w	Update						; If not, branch
	
	move.w	#$110,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)
	
	move.w	#-$200,obj.x_speed(a6)				; Walk left
	move.l	#Update,obj.update(a6)
	bra.w	Update

; ------------------------------------------------------------------------------
; Jump out of hospital bed state
; ------------------------------------------------------------------------------

JumpOutHospitalBedState:
	move.l	#.MoveDown,obj.update(a6)			; Move down
	move.w	#$400,obj.y_speed(a6)

; ------------------------------------------------------------------------------

.MoveDown:
	cmpi.w	#$150,obj.y(a6)					; Have we moved enough?
	blt.w	Update						; If not, branch

	move.w	#$150,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

	move.l	#.MoveRight,obj.update(a6)			; Move right
	move.w	#$400,obj.x_speed(a6)

; ------------------------------------------------------------------------------

.MoveRight:
	cmpi.w	#$150,obj.x(a6)					; Have we moved enough?
	blt.w	Update						; If not, branch

	move.w	#$150,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)
	
	move.l	#Update,obj.update(a6)				; Move down
	move.w	#$400,obj.y_speed(a6)
	bra.w	Update

; ------------------------------------------------------------------------------
; Answer door state
; ------------------------------------------------------------------------------

AnswerDoorState:
	move.l	#.MoveDown,obj.update(a6)			; Move down
	move.w	#$200,obj.y_speed(a6)

; ------------------------------------------------------------------------------

.MoveDown:
	cmpi.w	#$130,obj.y(a6)					; Have we moved enough?
	blt.w	Update						; If not, branch

	move.w	#$130,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

	jsr	UnpauseScript					; Unpause script

	move.l	#Update,obj.update(a6)				; Set state
	bra.w	Update

; ------------------------------------------------------------------------------
; Walk to warden state
; ------------------------------------------------------------------------------

RpgPlayerWardenState:
	cmpi.w	#$150,obj.x(a6)					; Are we left of the warden?
	blt.s	.StartMoveRight					; If so, branch
	
	move.l	#.MoveLeft,obj.update(a6)			; Move left
	move.w	#-$200,obj.x_speed(a6)
	
; ------------------------------------------------------------------------------

.MoveLeft:
	cmpi.w	#$150,obj.x(a6)					; Have we moved enough?
	bgt.w	Update						; If not, branch

	move.w	#$150,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)
	bra.s	.StartMoveDown

; ------------------------------------------------------------------------------

.StartMoveRight:
	move.l	#.MoveRight,obj.update(a6)			; Move right
	move.w	#$200,obj.x_speed(a6)
	
; ------------------------------------------------------------------------------

.MoveRight:
	cmpi.w	#$150,obj.x(a6)					; Have we moved enough?
	blt.w	Update						; If not, branch

	move.w	#$150,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)

; ------------------------------------------------------------------------------

.StartMoveDown:
	move.l	#.MoveDown,obj.update(a6)			; Move down
	move.w	#$200,obj.y_speed(a6)

; ------------------------------------------------------------------------------

.MoveDown:
	cmpi.w	#$180,obj.y(a6)					; Have we moved enough?
	blt.s	Update						; If not, branch

	move.w	#$180,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

	jsr	UnpauseScript					; Unpause script

	move.l	#Update,obj.update(a6)				; Set state
	bra.s	Update

; ------------------------------------------------------------------------------
; Drag state
; ------------------------------------------------------------------------------

RpgPlayerDragState:
	cmpi.w	#$1D0,obj.y(a6)					; Have we moved enough?
	blt.s	Update						; If not, branch

	move.w	#$1D0,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

	move.l	#.MoveLeft,obj.update(a6)			; Move left
	move.w	#-$200,obj.x_speed(a6)

; ------------------------------------------------------------------------------

.MoveLeft:
	cmpi.w	#-48,obj.x(a6)					; Have we moved enough?
	bgt.s	.Update						; If not, branch

	move.w	#-48,obj.x(a6)					; Stop moving
	clr.w	obj.x_speed(a6)

	move.l	#.WaitScript,obj.update(a6)			; Wait for script to finish

; ------------------------------------------------------------------------------

.WaitScript:
	tst.l	script_address					; Is a script running?
	bne.s	.Update						; If so, branch

	st	cut_to_black					; Cut to black

; ------------------------------------------------------------------------------

.Update:
	jsr	UpdateRpgObject					; Update
	bra.s	UpdateDraw					; Draw sprite

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	bsr.w	Movement					; Handle movement
	
; ------------------------------------------------------------------------------
; Do updates
; ------------------------------------------------------------------------------

Update:
	jsr	UpdateRpgObject					; Update
	jsr	RpgObjectMapCollide				; Check map collision
	bsr.w	CheckMapBoundaries				; Check map boundaries

UpdateDraw:
	moveq	#0,d0						; Animate sprite
	CHECK_EVENT EVENT_STAGE_5
	bne.s	.Animate
	CHECK_EVENT EVENT_ASSAULTED_CULT
	beq.s	.Animate
	moveq	#$A,d0

.Animate:
	lea	Anim_Player(pc),a1
	jsr	AnimateRpgObject
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Scary Maze state
; ------------------------------------------------------------------------------

ScaryMazeState:
	bsr.w	Movement					; Handle movement
	jsr	UpdateRpgObject					; Update
	jsr	RpgObjectMapCollide				; Check map collision
	bne.s	.Draw						; If there was no collision, branch

	cmpi.b	#$E,rpg_room_id					; Are we in the last maze?
	bne.s	.Restart					; If not, branch

	st	scary_maze_jumpscare				; Go to jumpscare
	bra.s	.Draw

.Restart:
	move.b	rpg_room_id,rpg_warp_room_id			; Restart maze

.Draw
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Movement
; ------------------------------------------------------------------------------

Movement:
	move.w	#$200,d0					; Speed
	
	cmpi.b	#$C,rpg_room_id					; Are we in the Scary Maze?
	bcs.s	.NoScaryMaze					; If not, branch
	cmpi.b	#$E,rpg_room_id
	bhi.s	.NoScaryMaze					; If not, branch

	move.w	#$100,d0					; Scary Maze speed

.NoScaryMaze:
	moveq	#0,d1						; Clear speed
	moveq	#0,d2
	
	tst.l	script_address					; Is a script running?
	bne.s	.SetXSpeed					; If so, branch
	
	btst	#BUTTON_LEFT_BIT,p1_ctrl_hold			; Is left being held?
	beq.s	.NotLeft					; If not, branch
	sub.w	d0,d1						; Move left

.NotLeft:
	btst	#BUTTON_RIGHT_BIT,p1_ctrl_hold			; Is right being held?
	beq.s	.SetXSpeed					; If not, branch
	add.w	d0,d1						; Move right

.SetXSpeed:
	move.w	d1,obj.x_speed(a6)				; Set X speed

	tst.l	script_address					; Is a script running?
	bne.s	.SetYSpeed					; If so, branch
	
	btst	#BUTTON_UP_BIT,p1_ctrl_hold			; Is up being held?
	beq.s	.NotUp						; If not, branch
	sub.w	d0,d2						; Move up

.NotUp:
	btst	#BUTTON_DOWN_BIT,p1_ctrl_hold			; Is down being held?
	beq.s	.SetYSpeed					; If not, branch
	add.w	d0,d2						; Move down

.SetYSpeed:
	move.w	d2,obj.y_speed(a6)				; Set Y speed
	rts

; ------------------------------------------------------------------------------
; Check the map boundaries
; ------------------------------------------------------------------------------

CheckMapBoundaries:
	move.w	obj.x(a6),d0					; Are we past the left boundary?
	move.w	map_fg_bound_left,d1
	add.w	obj.collide_width(a6),d1
	cmp.w	d1,d0
	ble.s	.StopLeft					; If so, branch
	
	move.w	map_fg_bound_right,d1				; Are we past the right boundary?
	sub.w	obj.collide_width(a6),d1
	cmp.w	d1,d0
	blt.s	.CheckTop					; If not, branch
	
	move.w	d1,obj.x(a6)					; Stop at boundary
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving

	move.w	obj.x(a6),d0					; Have we changed X positions?
	cmp.w	obj.previous_x(a6),d0
	beq.s	.CheckTop					; If not, branch

	lea	RightBoundScript,a0				; Run script
	jsr	StartScript
	bra.s	.CheckTop

.StopLeft:
	move.w	d1,obj.x(a6)					; Stop at boundary
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving

	move.w	obj.x(a6),d0					; Have we changed X positions?
	cmp.w	obj.previous_x(a6),d0
	beq.s	.CheckTop					; If not, branch

	lea	LeftBoundScript,a0				; Run script
	jsr	StartScript

.CheckTop:
	move.w	obj.y(a6),d0					; Are we past the top boundary?
	move.w	map_fg_bound_top,d1
	add.w	obj.collide_height(a6),d1
	cmp.w	d1,d0
	ble.s	.StopY						; If so, branch
	
	move.w	map_fg_bound_bottom,d1				; Are we past the bottom boundary?
	sub.w	obj.collide_height(a6),d1
	cmp.w	d1,d0
	blt.s	.End						; If not, branch

.StopY:
	move.w	d1,obj.y(a6)					; Stop at boundary
	clr.w	obj.y+2(a6)
	clr.w	obj.y_speed(a6)					; Stop moving

.End:
	rts

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	btst	#PLAYER_HIDDEN,obj.flags(a6)			; Are we hidden?
	bne.s	.End						; If so, branch

	pea	MarsSpr_RpgPlayer				; Draw sprite
	move.b	obj.anim+anim.frame+1(a6),-(sp)
	move.b	#2,-(sp)
	move.b	obj.flags(a6),-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite

.End:
	rts


; ------------------------------------------------------------------------------
; Draw sprite (Scary Maze)
; ------------------------------------------------------------------------------

DrawScaryMaze:
	pea	MarsSpr_RpgPlayer				; Draw sprite
	move.b	#29,-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite
	rts

; ------------------------------------------------------------------------------
; Za Warudo initialization state
; ------------------------------------------------------------------------------

ObjZaWarudo:
	SET_OBJECT_LAYER move.w,7,obj.layer(a6)			; Set layer

	move.w	#256,obj.draw_width(a6)				; Set draw size
	move.w	#256,obj.draw_height(a6)

	movea.w	player_object,a1				; Set position
	move.w	obj.x(a1),obj.x(a6)
	move.w	obj.y(a1),obj.y(a6)
	
	move.w	#$FF27,MARS_SYS+MARS_COMM_10			; Play scream sound

	move.l	#DrawObject,obj.update(a6)			; Set state
	move.l	#DrawZaWarudo,obj.draw(a6)			; Set draw routine

	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Draw Za Warudo sprite
; ------------------------------------------------------------------------------

DrawZaWarudo:
	lea	ZaWarudoScales,a0				; Get scale value
	move.w	za_warudo.scale(a6),d1
	add.w	d1,d1
	move.w	(a0,d1.w),d1
	
	addq.w	#1,za_warudo.scale(a6)				; Scale up
	move.w	#(ZaWarudoScalesEnd-ZaWarudoScales)/2-1,d0	; Have we scaled up all the way?
	cmp.w	za_warudo.scale(a6),d0	
	bcc.s	.Draw						; If not, branch
	move.w	d0,za_warudo.scale(a6)				; Cap scale value

.Draw:
	move.b	#2,-(sp)					; Draw sprite
	move.b	#$18,-(sp)
	clr.b	-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	d1,-(sp)
	move.w	d1,-(sp)
	jsr	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Scripts
; ------------------------------------------------------------------------------

WakeUpScript:
	SCRIPT_DELAY			30
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"What a horrible night to have a\n", &
					"curse of a nightmare."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_SET_EVENT		EVENT_WAKE_UP
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_PAUSE
	SCRIPT_END

; ------------------------------------------------------------------------------

MirrorScript:
	SCRIPT_DELAY			30
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Hey, looking good, good\n", &
					"looking."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"If you were a woman, I would\n", &
					"kiss you right now."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_PLAY_PWM			$FF11
	SCRIPT_DELAY			150
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"Oh my, it seems that it's time\n", &
					"for breakfast."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I do also need to take a\n", &
					"bath... but food comes first."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_SET_EVENT		EVENT_MIRROR
	SCRIPT_END

; ------------------------------------------------------------------------------

LeftBoundScript:
	SCRIPT_COMPARE_BYTE		rpg_room_id, 4
	SCRIPT_JUMP_NOT_EQUAL		.NotHouse

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"There's nothing for me past\n", &
					"this point."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX

; ------------------------------------------------------------------------------

.NotHouse:
	SCRIPT_COMPARE_BYTE		rpg_room_id, 6
	SCRIPT_JUMP_NOT_EQUAL		.Not7Eleven
	
	SCRIPT_CALL_M68K		.SetHouseWarp

; ------------------------------------------------------------------------------

.Not7Eleven:
	SCRIPT_END

; ------------------------------------------------------------------------------

.SetHouseWarp:
	st	rpg_warp_entry_id				; Warp to house
	move.b	#4,rpg_warp_room_id

	movea.w	player_object,a1
	move.w	#$370,rpg_warp_x
	move.w	obj.y(a1),rpg_warp_y
	move.b	rpg_obj.angle(a1),rpg_warp_angle
	rts

; ------------------------------------------------------------------------------

RightBoundScript:
	SCRIPT_COMPARE_BYTE		rpg_room_id, 4
	SCRIPT_JUMP_NOT_EQUAL		.NotHouse
	
	SCRIPT_CHECK_EVENT		EVENT_STAGE_1
	SCRIPT_JUMP_SET			.Message
	
	SCRIPT_CALL_M68K		.Set7ElevenWarp
	SCRIPT_END

; ------------------------------------------------------------------------------

.NotHouse:
	SCRIPT_COMPARE_BYTE		rpg_room_id, 6
	SCRIPT_JUMP_NOT_EQUAL		.Not7Eleven

.Message:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"There's nothing for me past\n", &
					"this point."
	SCRIPT_WAIT_INPUT

; ------------------------------------------------------------------------------

.Not7Eleven:
	SCRIPT_END

; ------------------------------------------------------------------------------

.Set7ElevenWarp:
	st	rpg_warp_entry_id				; Warp to 7-Eleven
	move.b	#6,rpg_warp_room_id

	movea.w	player_object,a1
	move.w	#$10,rpg_warp_x
	move.w	obj.y(a1),rpg_warp_y
	move.b	rpg_obj.angle(a1),rpg_warp_angle
	rts

; ------------------------------------------------------------------------------

Start7ElevenScript:
	SCRIPT_DELAY			15

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Okay, so I need to pick up\n", &
					"some Cup Noodles and a soda."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"While I'm here, I could get\n", &
					"some Axe Body Spray and not\n", &
					"have to take a bath."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_SET_EVENT		EVENT_7ELEVEN
	SCRIPT_END

; ------------------------------------------------------------------------------

Not7ElevenDoneScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I still haven't picked up all\n", &
					"of my stuff yet."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CALL_M68K		.MovePlayerUp
	SCRIPT_PAUSE
	SCRIPT_END

; ------------------------------------------------------------------------------

.MovePlayerUp:
	movea.w	player_object,a1				; Move player up
	move.w	#-$200,obj.y_speed(a1)
	move.l	#WalkUp7ElevenState,obj.update(a1)
	rts

; ------------------------------------------------------------------------------

CupNoodlesScript:
	SCRIPT_DELAY			15

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Alrighty, let's get these\n", &
					"Cup Noodles heated up in the\n", &
					"microwave."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_SET_EVENT		EVENT_7ELEVEN_HOME
	SCRIPT_END

; ------------------------------------------------------------------------------

AxeBodySprayScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Nothing better than freshening\n", &
					"up before a nice meal."
	SCRIPT_WAIT_INPUT
	
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I should go into town later\n", &
					"and woo the ladies with my\n", &
					"irresistible musky scent!"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_SET_EVENT		EVENT_AXE_KNOCKOUT
	SCRIPT_END

; ------------------------------------------------------------------------------

DizzyScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"*cough* *cough* *cough*\n"
	SCRIPT_DELAY			90
	SCRIPT_TEXT			"Oh man, that's FOUL!"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

GarageScript:
	SCRIPT_DELAY			15

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Oh man... "
	SCRIPT_DELAY			45
	SCRIPT_TEXT			"where am I?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			60

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"How did I end up in my car?"
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Should I get out?"
	SCRIPT_SELECTION		"Get out of the car", .GetOut, &
					"Stay in the car", .StayIn

; ------------------------------------------------------------------------------

.GetOut:
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Yeah, I should be okay to get\n", &
					"out and move around."
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"May as well go ahead and get\n", &
					"those windows repaired while\n", &
					"I'm up."
	SCRIPT_WAIT_INPUT

	SCRIPT_CHECK_EVENT		EVENT_WALL_SMASH
	SCRIPT_JUMP_CLEAR		.NoWallSmash

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Oh yeah, and also the drywall\n", &
					"in my room. That got damaged\n", &
					"when I took that fall."
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"God, my head is still killing\n", &
					"me, but I gotta take care of\n", &
					"it."
	SCRIPT_WAIT_INPUT

.NoWallSmash:
	SCRIPT_CALL_M68K		.GetPlayerOut
	SCRIPT_SET_EVENT		EVENT_LEFT_CAR
	SCRIPT_END

; ------------------------------------------------------------------------------

.StayIn:
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I really don't feel well enough\n", &
					"to get out right now. I'll just\n", &
					"stay in here for a few minutes."
	SCRIPT_WAIT_INPUT
					
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I'll go ahead and put on some\n", &
					"music, too."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			2
	SCRIPT_SET_NUMBER_BYTE		photo_cutscene, 1
	SCRIPT_END

; ------------------------------------------------------------------------------

.GetPlayerOut:
	movea.w	player_object,a1				; Get player out
	move.w	a1,cam_focus_object
	bclr	#PLAYER_HIDDEN,obj.flags(a1)
	rts

; ------------------------------------------------------------------------------

BurglarScript:
	SCRIPT_DELAY			15

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"What the hell is going on here?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			30
	SCRIPT_CALL_M68K		.BeatPlayer
	SCRIPT_END

; ------------------------------------------------------------------------------

.BeatPlayer:
	movea.w	player_object,a1				; Make the burglar aggressive
	movea.w	player.burglar(a1),a1
	move.l	#BurglarAggressionState,obj.update(a1)
	rts

; ------------------------------------------------------------------------------

HospitalRoomScript:
	SCRIPT_DELAY			45

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT_SPEED		$40
	SCRIPT_TEXT			"Ugh... "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"where am I? "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"The light is\nso... "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"bright. "
	SCRIPT_DELAY			60
	SCRIPT_TEXT_SPEED		$80
	SCRIPT_TEXT			"It's burning\nright into my retinas."
	SCRIPT_WAIT_INPUT

	SCRIPT_RESET_TEXT_SPEED
	SCRIPT_ICON			DoctorIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"So, "
	SCRIPT_DELAY			30
	SCRIPT_TEXT			"you're finally awake."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I feel like I took an arrow\n", &
					"to the head."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			DoctorIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I'm Dr. Alfonzo Roda"
	SCRIPT_DELAY			30
	SCRIPT_TEXT			", but you\n", &
					"can call me Dr. Foos Roda."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			30

	SCRIPT_CALL_M68K		.SpawnCop
	SCRIPT_PAUSE

	SCRIPT_DELAY			30
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			CopIcon, 0
	
	SCRIPT_TEXT			"Mr. TechDeck, have you heard\n", &
					"of the high elves gang?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"... "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"I can't say that I have...\n"
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"Why do you ask?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			CopIcon, 0
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"One of their members is\n", &
					"suspected to have been the\n", &
					"person that assaulted you."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			2
	SCRIPT_SET_NUMBER_BYTE		suspect_choose, 1
	
	SCRIPT_END

; ------------------------------------------------------------------------------

.SpawnCop:
	jsr	SpawnObject					; Spawn cop
	move.l	#ObjRpgNpc,obj.update(a1)
	move.b	#2,obj.subtype(a1)
	move.w	#$150,obj.x(a1)
	move.w	#$160,obj.y(a1)
	move.w	#45,npc.timer(a1)
	
	move.w	#$FF0F,MARS_COMM_12+MARS_SYS			; Play door close sound
	rts

; ------------------------------------------------------------------------------

HospitalRoomScript2:
	SCRIPT_DELAY			45

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			CopIcon, 0

	SCRIPT_TEXT			"Thank you for your time,\n", &
					"citizen. "
	SCRIPT_DELAY			45
	SCRIPT_TEXT			"(Great, now I can\n", &
					"execute one of these prisoners)"
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			45
	SCRIPT_PAUSE
	
	SCRIPT_DELAY			45

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			DoctorIcon, 0
	
	SCRIPT_TEXT			"Mr. TechDeck, do you have any\n", &
					"insurance provider that we can\n", &
					"use for your hospital stay?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I wouldn't know, I don't have\n", &
					"my wallet with me."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			DoctorIcon, 0
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"What do you mean you wouldn't\n", &
					"know?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"..."
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Alright, you got me. I don't\n", &
					"have health insurance."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			DoctorIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Well, in that case, you are\n", &
					"going to have to pay out of\n", &
					"pocket."
	SCRIPT_WAIT_INPUT

	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"How much do I owe?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			DoctorIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"$89,649"
	SCRIPT_WAIT_INPUT

	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"What the fuck!? What kind of\n", &
					"treatment did you give me? I\n", &
					"was only here for a day!"
	SCRIPT_WAIT_INPUT

	SCRIPT_ICON			DoctorIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"No, Mr. TechDeck... "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"you've been\n", &
					"in a coma for the past 2 years."
	SCRIPT_WAIT_INPUT

	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"...that can't be possible! "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"How\n", &
					"could that have happened?!"
	SCRIPT_WAIT_INPUT

	SCRIPT_ICON			DoctorIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"You did sustain moderate\n", &
					"brain damage. It's impressive\n", &
					"that you even survived."
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"You should be grateful on\n", &
					"that merit alone, Mr. TechDeck."

	SCRIPT_WAIT_INPUT

	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Proud of it, my ass! I am NOT\n", &
					"paying for something that I\n", &
					"didn't cause!" 
	SCRIPT_WAIT_INPUT

	SCRIPT_CHECK_EVENT		EVENT_BREAK_IN
	SCRIPT_JUMP_SET			.BrokenIn
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"It's not my fault that I didn't\n", &
					"see anyone when backing out of\n", &
					"my driveway."
	SCRIPT_WAIT_INPUT

	SCRIPT_JUMP			.FreakyShit

.BrokenIn:
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"It's not my fault they broke\n", &
					"into my house and bludgeoned\n", &
					"me!"
	SCRIPT_WAIT_INPUT

.FreakyShit:
	SCRIPT_ICON			DoctorIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I'm sorry, Mr. TechDeck, but\n", &
					"the truth of the matter is that\n", &
					"I have to let you go... "
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"...let you go."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Let's not play the game of\n", &
					"martyrdom. You're nothing\n", &
					"like Holy Mary on a cross."
	SCRIPT_WAIT_INPUT

	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"(I've got to make a run for\n", &
					"it.)"
	SCRIPT_WAIT_INPUT

	SCRIPT_CALL_M68K		.GetPlayerOut
	SCRIPT_END

; ------------------------------------------------------------------------------

.GetPlayerOut:
	movea.w	player_object,a1				; Get player out of hospital bed
	move.l	#JumpOutHospitalBedState,obj.update(a1)
	rts

; ------------------------------------------------------------------------------

HospitalHallwayScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"Oh god, I feel like\n", &
					"everything's going on manual\n", &
					"mode."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			DoctorIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Get back here, you're not\n", &
					"leaving without paying!"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_SET_EVENT		EVENT_HOSPITAL_HALLWAY
	SCRIPT_PAUSE
	SCRIPT_END

; ------------------------------------------------------------------------------

OutsideHospitalScript:
	SCRIPT_DELAY			45
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"Woah... "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"who turned out the\n", &
					"lights?"
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			2

	SCRIPT_SET_NUMBER_BYTE		silent_hill_cutscene, 1
	SCRIPT_END

; ------------------------------------------------------------------------------

ReturnHomeScript:
	SCRIPT_SET_EVENT		EVENT_RETURNED_HOME
	SCRIPT_DELAY			45
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"Finally, I have returned home."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			60

	SCRIPT_CHECK_EVENT		EVENT_BREAK_IN
	SCRIPT_JUMP_SET			.BrokenInto

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"Dear God... first, my car...\n", &
					"and now, my stuff, gone."
	SCRIPT_WAIT_INPUT

	SCRIPT_JUMP			.CultArrives

.BrokenInto:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"What have they done to all my\n", &
					"stuff? It's all gone!"
	SCRIPT_WAIT_INPUT

.CultArrives:
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"What has this godforsaken world\n", &
					"come to? Why me, when I already\n", &
					"have nothing to lose?"
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			15
	SCRIPT_PLAY_PWM			$FF23
	SCRIPT_DELAY			45
	SCRIPT_CALL_M68K		.FacePlayerDown
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"I wonder who that could be..."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Should I answer the door?"
	SCRIPT_SELECTION		"Answer", .Answer, &
					"Don't answer", .StayIn

.Answer:
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_CALL_M68K		.AnswerDoor
	SCRIPT_PAUSE

	SCRIPT_PLAY_PWM			$FF0E
	SCRIPT_SET_NUMBER_BYTE		cult_front_door, 1
	SCRIPT_END

.StayIn:
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Ah, fuck them."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX

	SCRIPT_DELAY			30
	SCRIPT_PLAY_PWM			$FF22
	SCRIPT_DELAY			90

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"What the fuck?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CALL_M68K		.GoToBedroom
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_END

; ------------------------------------------------------------------------------

.FacePlayerDown:
	movea.w	player_object,a1				; Face player down
	move.b	#2,rpg_obj.angle(a1)
	rts

; ------------------------------------------------------------------------------

.AnswerDoor:
	movea.w	player_object,a1				; Set answer door state
	move.l	#AnswerDoorState,obj.update(a1)
	rts

; ------------------------------------------------------------------------------

.GoToBedroom:
	movea.w	player_object,a1				; Go to bedroom
	move.l	#WalkToBedroomState,obj.update(a1)
	rts

; ------------------------------------------------------------------------------

CultistCaptureScript:
	SCRIPT_DELAY			45
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"Who are you people?! "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"What the\n", &
					"hell do you want from me?!?!"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			CultistIcon, 0
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"We want your body. "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"We want your\n", &
					"blood. "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"We want your soul. "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"We\nwant the amalgam of you."
	SCRIPT_WAIT_INPUT

	SCRIPT_CALL_M68K		.CapturePlayer
	SCRIPT_END

; ------------------------------------------------------------------------------

.CapturePlayer:
	movea.w	player_object,a1				; Make the cultist aggressive
	movea.w	player.cultist(a1),a1
	move.l	#CultistAggressionState,obj.update(a1)
	rts

; ------------------------------------------------------------------------------

PrisonStartScript:
	SCRIPT_DELAY			45
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"Fuck, I got myself arrested\n", &
					"for assaulting those guys at\n", &
					"my front door."
	SCRIPT_WAIT_INPUT

	SCRIPT_END

; ------------------------------------------------------------------------------

CultEscapeScript:
	SCRIPT_DELAY			45
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"Please let me go. I have work\n", &
					"to finish. It can't be brought\n", &
					"to an end here."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			CultistIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"ALL OUR TIMES HAVE COME HERE,\n", &
					"BUT NOW THEY'RE GONE."
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"SEASONS DON'T FEAR THE REAPER,\n", &
					"NOR DO THE WIND, THE SUN, OR\n", &
					"THE RAIN."
	SCRIPT_WAIT_INPUT

	SCRIPT_CHECK_EVENT		EVENT_SONIC_CULT
	SCRIPT_JUMP_CLEAR		.Fail2
	SCRIPT_CHECK_EVENT		EVENT_LEFT_CAR
	SCRIPT_JUMP_SET			.Fail2
	
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I gotta find a way out..."
	SCRIPT_SELECTION		"I know what you did to him.", .KnowDid, &
					"PLEASE JUST LET ME GO.", .Fail1

; ------------------------------------------------------------------------------

.KnowDid:
	SCRIPT_ICON			CultistIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"HE'S BURNING. HE'S BURNING.\n", &
					"HE'S BURNING. FOR YOU."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Hmmm..."
	SCRIPT_SELECTION		"What about his money?", .Money, &
					"PLEASE PLEASE LET ME GO.", .Fail2

; ------------------------------------------------------------------------------

.Money:
	SCRIPT_ICON			CultistIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"WITH A PURPOSEFUL GRIMACE AND\n", &
					"A TERRIBLE SOUND...\n"
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"HE PULLS THE SPITTING HIGH\n", &
					"TENSION WIRES DOWN.\n"
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"HELPLESS PEOPLE ON SUBWAY\n", &
					"TRAINS SCREAM BUG-EYED AS HE\n", &
					"LOOKS IN ON THEM.\n"
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"HE PICKS UP A BUS AND HE\n", &
					"THROWS IT BACK DOWN..."
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"AS HE WADES THROUGH THE\n", &
					"BUILDINGS TOWARDS THE CENTER\n", &
					"OF TOWN.\n"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I call upon him. "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"Clear your\n", &
					"name... "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"Ollie."
	SCRIPT_WAIT_INPUT

	SCRIPT_CALL_M68K		.SpawnZaWarudo

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			180

	SCRIPT_SET_EVENT		EVENT_CULT_KILLED
	SCRIPT_SET_NUMBER_BYTE		cut_to_black, 1
	SCRIPT_END

; ------------------------------------------------------------------------------

.SpawnZaWarudo:
	jsr	SpawnObject					; Spawn Za Warudo glow
	move.l	#ObjZaWarudo,obj.update(a1)
	rts

; ------------------------------------------------------------------------------

.Fail1:
	SCRIPT_ICON			CultistIcon, 0

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"VALENTINE IS DONE HERE, BUT,\n", &
					"NOW THEY'RE GONE."
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"ROMEO AND JULIET ARE TOGETHER\n", &
					"IN ETERNITY. ROMEO AND JULIET."
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"40,000 MEN AND WOMEN EVERYDAY\n", &
					"LIKE ROMEO AND JULIET."
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"40,000 MEN AND WOMEN EVERYDAY\n", &
					"REDEFINE HAPPINESS."
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"ANOTHER 40,000 COMING EVERY\n", &
					"DAY."
	SCRIPT_WAIT_INPUT

.Fail2:
	SCRIPT_SET_EVENT		EVENT_CULT_ESCAPE_FAIL
	SCRIPT_SET_NUMBER_BYTE		cut_to_black, 1
	SCRIPT_END

; ------------------------------------------------------------------------------

NeutralEndingScript:
	SCRIPT_DELAY			45
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"My life is fucked."
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I've been robbed, I'm now\n", &
					"thousands of dollars in debt,\n", &
					"and I even went to prison."
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"And all I can do right now is\n", &
					"sit here and eat these\n", &
					"delicious Cup Noodles."
	SCRIPT_WAIT_INPUT

	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			120
			
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"*sigh*"
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Will it ever get better?"
	SCRIPT_WAIT_INPUT
			
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Will I ever find meaning in\n", &
					"my life? Will I ever make an\n", &
					"impact?"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			120
			
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"I hate living like this."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			45

	SCRIPT_SET_EVENT		EVENT_NEUTRAL_ENDING
	SCRIPT_SET_NUMBER_BYTE		cut_to_black, 1
	SCRIPT_END

; ------------------------------------------------------------------------------

GoodEndingScript:
	SCRIPT_DELAY			45
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"Why... "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"why can't I ever finish\n", &
					"this?"
	SCRIPT_WAIT_INPUT
		
	SCRIPT_CLEAR_TEXTBOX	
	SCRIPT_TEXT			"I could never fill your shoes.\n"
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"I'm a fraud! "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"I'm a phony! "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"I'm\n", &
					"not Ollie!"
	SCRIPT_WAIT_INPUT
		
	SCRIPT_CLEAR_TEXTBOX	
	SCRIPT_TEXT			"I've been living a lie! "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"IT'S\n", &
					"TRUE!!! "
	SCRIPT_DELAY			60
	SCRIPT_TEXT			"GOD, IT'S SO BRUTFULLY\n", &
					"TRUE!!"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_DELAY			45
	
	SCRIPT_SET_EVENT		EVENT_GOOD_ENDING
	SCRIPT_SET_NUMBER_BYTE		good_ending, 1
	SCRIPT_END

; ------------------------------------------------------------------------------
; Icons
; ------------------------------------------------------------------------------

OllieIcon:
	dc.l	MarsSpr_RpgTextboxIcons
	dc.w	2
	dc.l	0

.Anims:
	dc.w	.Static-.Anims

.Static:
	ANIM_START $100, ANIM_RESTART
	dc.w	0
	ANIM_END

; ------------------------------------------------------------------------------
; Animations
; ------------------------------------------------------------------------------

Anim_Player:
	dc.w	.IdleDown-Anim_Player
	dc.w	.MoveDown-Anim_Player
	dc.w	.IdleHoriz-Anim_Player
	dc.w	.MoveHoriz-Anim_Player
	dc.w	.IdleUp-Anim_Player
	dc.w	.MoveUp-Anim_Player
	dc.w	.AxeSpray-Anim_Player
	dc.w	.Dizzy-Anim_Player
	dc.w	.Knockout-Anim_Player
	dc.w	.HospitalBed-Anim_Player
	dc.w	.PrisonIdleDown-Anim_Player
	dc.w	.PrisonMoveDown-Anim_Player
	dc.w	.PrisonIdleHoriz-Anim_Player
	dc.w	.PrisonMoveHoriz-Anim_Player
	dc.w	.PrisonIdleUp-Anim_Player
	dc.w	.PrisonMoveUp-Anim_Player

.IdleDown:
	ANIM_START $100, ANIM_RESTART
	dc.w	0
	ANIM_END

.MoveDown:
	ANIM_START $30, ANIM_RESTART
	dc.w	1, 0, 2, 0
	ANIM_END

.IdleHoriz:
	ANIM_START $100, ANIM_RESTART
	dc.w	3
	ANIM_END

.MoveHoriz:
	ANIM_START $30, ANIM_RESTART
	dc.w	4, 3, 5, 3
	ANIM_END

.IdleUp:
	ANIM_START $100, ANIM_RESTART
	dc.w	6
	ANIM_END

.MoveUp:
	ANIM_START $30, ANIM_RESTART
	dc.w	7, 6, 8, 6
	ANIM_END

.AxeSpray:
	ANIM_START $100, ANIM_SWITCH, 7
	dc.w	9, 9, 9, 9, 9, 9, 9, 9
	dc.w	9, 9, 9, 9, 9, 9, 9, 9
	dc.w	9, 9, 9, 9, 9, 9, 9, 9
	dc.w	9, 9, 9, 9, 9, 9, 9, 9
	dc.w	10, 10, 10, 10, 10, 10, 10, 10
	dc.w	10, 10, 10, 10, 10, 10, 10, 10
	dc.w	10, 10, 10, 10, 10, 10, 10, 10
	dc.w	10, 10, 10, 10, 10, 10, 10, 10
	dc.w	10|$1600, 10, 10, 10, 11, 11, 11, 11
	dc.w	10, 10, 10, 10, 11, 11, 11, 11
	dc.w	10, 10, 10, 10, 11, 11, 11, 11
	dc.w	10, 10, 10, 10, 11, 11, 11, 11
	dc.w	10, 10, 10, 10, 11, 11, 11, 11
	dc.w	10, 10, 10, 10, 10, 10
	dc.w	10, 10, 10, 10, 10, 10
	dc.w	10, 10, 10, 10, 10, 10
	dc.w	10, 10, 10, 10, 10, 10
	dc.w	12|$1700, 12, 12, 12, 12, 12
	dc.w	12, 12, 12, 12, 12, 12
	dc.w	12, 12, 12, 12, 12, 12
	dc.w	10, 10, 10, 10
	dc.w	10, 10, 10, 10
	dc.w	10, 10, 10, 10
	dc.w	10, 10, 10, 10
	dc.w	13, 13, 13, 13
	dc.w	13, 13, 13, 13
	dc.w	13, 13, 13, 13
	dc.w	13, 13, 13, 13
	dc.w	14|$1700, 14, 14, 14, 14, 14
	dc.w	14, 14, 14, 14, 14, 14
	dc.w	14, 14, 14, 14, 14, 14
	dc.w	14, 14, 14, 14, 14, 14
	dc.w	13, 13, 13, 13
	dc.w	13, 13, 13, 13
	dc.w	13, 13, 13, 13
	dc.w	13, 13, 13, 13
	ANIM_END
	
.Dizzy:
	ANIM_START $100, ANIM_LOOP_POINT, $20
	dc.w	15|$1800, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	dc.w	16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
	dc.w	15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	dc.w	16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
	ANIM_END
	
.Knockout:
	ANIM_START $100, ANIM_LOOP_POINT, $14
	dc.w	15, 15, 15, 15
	dc.w	16, 16, 16, 16
	dc.w	15, 15, 15, 15
	dc.w	16, 16, 16, 16
	dc.w	17|$1900, 17, 17, 17
	dc.w	18, 18, 18, 18
	ANIM_END

.HospitalBed:
	ANIM_START $100, ANIM_RESTART
	dc.w	19
	ANIM_END

.PrisonIdleDown:
	ANIM_START $100, ANIM_RESTART
	dc.w	20
	ANIM_END

.PrisonMoveDown:
	ANIM_START $30, ANIM_RESTART
	dc.w	21, 20, 22, 20
	ANIM_END

.PrisonIdleHoriz:
	ANIM_START $100, ANIM_RESTART
	dc.w	23
	ANIM_END

.PrisonMoveHoriz:
	ANIM_START $30, ANIM_RESTART
	dc.w	24, 23, 25, 23
	ANIM_END

.PrisonIdleUp:
	ANIM_START $100, ANIM_RESTART
	dc.w	26
	ANIM_END

.PrisonMoveUp:
	ANIM_START $30, ANIM_RESTART
	dc.w	27, 26, 28, 26
	ANIM_END

; ------------------------------------------------------------------------------
; Za Warudo scale values
; ------------------------------------------------------------------------------

	section m68k_rom_fixed_data
ZaWarudoScales:
	.c: = 1
	while .c<=512
		if ((128*256)/.c)>=$8000
			dc.w	$7FFF
		else
			dc.w	(128*256)/.c
		endif
		.c: = .c+4
	endw
ZaWarudoScalesEnd:

; ------------------------------------------------------------------------------
