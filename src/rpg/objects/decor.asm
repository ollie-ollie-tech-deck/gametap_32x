; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG decor object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/rpg/shared.inc"

; ------------------------------------------------------------------------------
; Initialization data entry
; ------------------------------------------------------------------------------

DECOR_DATA macro update_routine, draw_routine, sprites, frame, layer, &
                 col_w, col_h, draw_w, draw_h, script, angles
	SET_OBJECT_LAYER dc.w,\layer
	dc.w	\col_w, \col_h, \draw_w, \draw_h
	dc.b	\sprites, \frame
	dc.l	\script
	dc.w	\angles
	dc.l	\draw_routine
	dc.l	\update_routine
	even
	endm

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjRpgDecor:
	move.w	obj.x(a6),decor.origin_x(a6)			; Set origin position
	move.w	obj.y(a6),decor.origin_y(a6)

	moveq	#0,d0						; Get initialization data
	move.b	obj.subtype(a6),d0
	add.w	d0,d0
	lea	.InitData(pc),a0
	adda.w	(a0,d0.w),a0

	move.w	(a0)+,obj.layer(a6)				; Set layer
	move.w	(a0)+,obj.collide_width(a6)			; Set hitbox size
	move.w	(a0)+,obj.collide_height(a6)
	move.w	(a0)+,obj.draw_width(a6)			; Set draw size
	move.w	(a0)+,obj.draw_height(a6)
	move.b	(a0)+,decor.sprites(a6)				; Set sprite set ID
	move.b	(a0)+,decor.frame(a6)				; Set sprite frame ID
	move.l	(a0)+,decor.script(a6)				; Set script address
	move.w	(a0)+,decor.interact_angles(a6)			; Set allowed interaction angles
	move.l	(a0)+,obj.draw(a6)				; Set draw routine
	
	movea.l	(a0)+,a0					; Set and run update routine
	move.l	a0,obj.update(a6)
	jmp	(a0)

; ------------------------------------------------------------------------------

.InitData:
	dc.w	.OllieBed-.InitData
	dc.w	.OlliePc-.InitData
	dc.w	.OllieTrash-.InitData
	dc.w	.OllieRug-.InitData
	dc.w	.OllieToilet-.InitData
	dc.w	.OllieBath-.InitData
	dc.w	.OllieSink-.InitData
	dc.w	.OllieLaundry-.InitData
	dc.w	.OllieTv-.InitData
	dc.w	.OllieCouch1-.InitData
	dc.w	.OllieCouch2-.InitData
	dc.w	.OllieGenesis-.InitData
	dc.w	.OllieFridge-.InitData
	dc.w	.OllieKitchenSink-.InitData
	dc.w	.OlliePlates-.InitData
	dc.w	.OllieTable-.InitData
	dc.w	.OllieGarageDoor-.InitData
	dc.w	.OllieCar-.InitData
	dc.w	.OllieBathroomWindow-.InitData
	dc.w	.OllieDiningRoomWindow-.InitData
	dc.w	.OllieWallCrack-.InitData
	dc.w	.CrashingCar-.InitData
	dc.w	.BrokenGlass-.InitData
	dc.w	.Candle-.InitData
	dc.w	.HospitalBed-.InitData
	dc.w	.HospitalBloodBag-.InitData
	dc.w	.HospitalSideTable-.InitData
	dc.w	.PrisonDoor-.InitData
	dc.w	.PrisonToilet-.InitData
	dc.w	.PrisonSink-.InitData
	dc.w	.PrisonBed-.InitData

.OllieBed:
	DECOR_DATA UpdateState, Draw, 2, 0, 1, 30, 8, 32, 32, OllieBedScript, %11111111

.OlliePc:
	DECOR_DATA LayeredUpdateState, Draw, 2, 1, 1, 14, 16, 32, 32, OlliePcScript, %11111111

.OllieTrash:
	DECOR_DATA UpdateState, Draw, 2, 2, 1, 16, 8, 32, 32, OllieTrashScript, %11111111

.OllieRug:
	DECOR_DATA InitStolenItem, Draw, 2, 3, 0, 0, 0, 24, 24, 0, %11111111

.OllieToilet:
	DECOR_DATA UpdateState, Draw, 2, 4, 1, 12, 12, 16, 32, OllieToiletScript, %00000010

.OllieBath:
	DECOR_DATA UpdateState, Draw, 2, 5, 1, 16, 16, 16, 32, OllieBathScript, %00001111

.OllieSink:
	DECOR_DATA UpdateState, Draw, 2, 6, 1, 12, 8, 16, 32, OllieSinkScript, %00000011

.OllieLaundry:
	DECOR_DATA LayeredUpdateState, Draw, 2, 7, 1, 12, 8, 16, 32, OllieLaundryScript, %11111111

.OllieTv:
	DECOR_DATA InitStolenUpdatedItem, Draw, 2, 8, 1, 16, 16, 16, 32, OllieTvScript, %00111110

.OllieCouch1:
	DECOR_DATA Couch1, Draw, 2, 9, 1, 8, 20, 16, 32, OllieCouch1PushScript, %11111111

.OllieCouch2:
	DECOR_DATA InitStolenLayeredItem, Draw, 2, $A, 1, 30, 4, 32, 16, 0, %11111111

.OllieGenesis:
	DECOR_DATA InitStolenUpdatedItem, Draw, 2, $B, 1, 16, 4, 16, 16, OllieGenesisScript, %11100011

.OllieFridge:
	DECOR_DATA UpdateState, Draw, 2, $C, 1, 8, 19, 16, 32, OllieFridgeScript, %11111111

.OllieKitchenSink:
	DECOR_DATA DrawObject, Draw, 2, $D, 0, 0, 0, 16, 16, 0, %11111111

.OlliePlates:
	DECOR_DATA DrawObject, Draw, 2, $E, 0, 0, 0, 16, 16, 0, %11111111

.OllieTable:
	DECOR_DATA LayeredUpdateState, Draw, 2, $F, 1, 18, 16, 32, 32, 0, %11111111

.OllieGarageDoor:
	DECOR_DATA InitGarageDoor, Draw, 2, $10, 1, 0, 0, 48, 24, 0, %11111111

.OllieCar:
	DECOR_DATA InitCar, Draw, 2, $11, 1, 18, 26, 32, 48, 0, %11111111

.OllieBathroomWindow:
	DECOR_DATA BathroomWindow, Draw, 2, $12, 0, 16, 32, 16, 16, OllieBathroomWindowScript, %11111111

.OllieDiningRoomWindow:
	DECOR_DATA DiningRoomWindow, Draw, 2, $12, 0, 16, 32, 16, 16, OllieDiningRoomWindowScript, %11111111

.OllieWallCrack:
	DECOR_DATA WallCrack, Draw, 2, $14, 0, 16, 16, 16, 16, WallCrackScript, %11111111

.CrashingCar:
	DECOR_DATA InitCrashingCar, Draw, 2, $15, 0, 26, 18, 48, 32, 0, %11111111

.BrokenGlass:
	DECOR_DATA InitCultObject, Draw, 2, $16, 0, 0, 0, 32, 16, 0, %11111111

.Candle:
	DECOR_DATA InitLayeredCultObject, Draw, 2, $17, 0, 0, 0, 8, 16, 0, %11111111

.HospitalBed:
	DECOR_DATA LayeredUpdateState, Draw, 2, 0, 1, 14, 16, 16, 32, 16, %11111111

.HospitalBloodBag:
	DECOR_DATA UpdateState, Draw, 2, 1, 0, 8, 16, 16, 32, 0, %11111111

.HospitalSideTable:
	DECOR_DATA UpdateState, Draw, 2, 2, 0, 16, 4, 16, 16, 0, %11111111

.PrisonDoor:
	DECOR_DATA InitPrisonDoor, Draw, 2, 0, 1, 16, 8, 16, 32, 0, %11111111

.PrisonToilet:
	DECOR_DATA UpdateState, Draw, 2, 1, 1, 12, 12, 16, 32, PrisonToiletScript, %00001110

.PrisonSink:
	DECOR_DATA UpdateState, Draw, 2, 2, 1, 12, 8, 16, 32, PrisonSinkScript, %00000010

.PrisonBed:
	DECOR_DATA LayeredUpdateState, Draw, 2, 3, 1, 16, 8, 16, 32, PrisonBedScript, %11000111

; ------------------------------------------------------------------------------
; Initialize stolen item
; ------------------------------------------------------------------------------

InitStolenItem:
	CHECK_EVENT EVENT_STAGE_3				; Has stage 3 been beaten?
	beq.s	.SetState					; If not, branch
	jmp	DeleteObject					; Delete ourselves

.SetState:
	move.l	#DrawObject,obj.update(a6)			; Set state
	jmp	DrawObject

; ------------------------------------------------------------------------------
; Initialize stolen updated item
; ------------------------------------------------------------------------------

InitStolenUpdatedItem:
	CHECK_EVENT EVENT_STAGE_3				; Has stage 3 been beaten?
	beq.s	.SetState					; If not, branch
	jmp	DeleteObject					; Delete ourselves

.SetState:
	move.l	#UpdateState,obj.update(a6)			; Set state
	bra.w	UpdateState
	
; ------------------------------------------------------------------------------
; Initialize stolen layered item
; ------------------------------------------------------------------------------

InitStolenLayeredItem:
	CHECK_EVENT EVENT_STAGE_3				; Has stage 3 been beaten?
	beq.s	.SetState					; If not, branch
	jmp	DeleteObject					; Delete ourselves

.SetState:
	move.l	#LayeredUpdateState,obj.update(a6)		; Set state
	bra.w	LayeredUpdateState

; ------------------------------------------------------------------------------
; Initialize cult object
; ------------------------------------------------------------------------------

InitCultObject:
	CHECK_EVENT EVENT_STAGE_3				; Has stage 3 been beaten?
	bne.s	.SetState					; If so, branch
	jmp	DeleteObject					; Delete ourselves

.SetState:
	move.l	#DrawObject,obj.update(a6)			; Set state
	jmp	DrawObject

; ------------------------------------------------------------------------------
; Initialize layered cult object
; ------------------------------------------------------------------------------

InitLayeredCultObject:
	CHECK_EVENT EVENT_STAGE_5				; Has stage 5 been beaten?
	bne.s	.Delete						; If so, branch
	CHECK_EVENT EVENT_STAGE_3				; Has stage 3 been beaten?
	bne.s	.SetState					; If so, branch

.Delete:
	jmp	DeleteObject					; Delete ourselves

.SetState:
	move.l	#NonSolidLayeredUpdateState,obj.update(a6)	; Set state
	jmp	NonSolidLayeredUpdateState

; ------------------------------------------------------------------------------
; Garage door initialization state
; ------------------------------------------------------------------------------

InitGarageDoor:
	CHECK_EVENT EVENT_LEFT_CAR				; Has Ollie gotten out of the car?
	bne.s	.SetState					; If so, branch
	CHECK_EVENT EVENT_STAGE_1				; Have we beaten stage 1?
	beq.s	.SetState					; If not, branch
	CHECK_EVENT EVENT_STAGE_2				; Have we beaten stage 2?
	bne.s	.SetState					; If so, branch

	movea.w	player_object,a1				; Set player's garage door object
	move.w	a6,player.garage_door(a1)
	
	SET_OBJECT_LAYER move.w,3,obj.layer(a6)			; Set layer
	
.SetState:
	move.l	#DrawObject,obj.update(a6)			; Set state
	jmp	DrawObject

; ------------------------------------------------------------------------------
; Car initialization state
; ------------------------------------------------------------------------------

InitCar:
	CHECK_EVENT EVENT_LEFT_CAR				; Have we been left?
	bne.s	.SetState					; If so, branch
	CHECK_EVENT EVENT_STAGE_1				; Have we beaten stage 1?
	beq.s	.SetState					; If not, branch
	CHECK_EVENT EVENT_STAGE_2				; Have we beaten stage 2?
	bne.s	.SetState					; If so, branch

	movea.w	player_object,a1				; Set player's car object
	move.w	a6,player.car(a1)

	move.w	a6,cam_focus_object				; Focus on us
	
	move.w	obj.x(a6),d0					; Set camera position
	subi.w	#160,d0
	move.w	d0,camera_fg_x
	move.w	obj.y(a6),d0
	subi.w	#112,d0
	move.w	d0,camera_fg_y
	
	SET_OBJECT_LAYER move.w,0,obj.layer(a6)			; Set layer

.SetState:
	move.l	#LayeredUpdateState,obj.update(a6)		; Set state
	bra.w	LayeredUpdateState

; ------------------------------------------------------------------------------
; Crashing car initialization state
; ------------------------------------------------------------------------------

InitCrashingCar:
	CHECK_EVENT EVENT_LEFT_CAR				; Has Ollie left their car?
	bne.s	.Delete						; If so, branch
	CHECK_EVENT EVENT_STAGE_1				; Have we beaten stage 1?
	beq.s	.Delete						; If not, branch
	CHECK_EVENT EVENT_STAGE_2				; Have we beaten stage 2?
	bne.s	.Delete						; If so, branch

	movea.w	player_object,a1				; Set player's crashing car object
	move.w	a6,player.crashing_car(a1)

	move.l	#DrawObject,obj.update(a6)			; Set state
	jmp	DrawObject

.Delete:
	jmp	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Prison door initialization state
; ------------------------------------------------------------------------------

InitPrisonDoor:
	movea.w	player_object,a1				; Set player's prison door object
	move.w	a6,player.prison_door(a1)
	
	move.l	#LayeredUpdateState,obj.update(a6)		; Set state
	bra.s	LayeredUpdateState

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

NonSolidLayeredUpdateState:
	jsr	LayerRpgObject					; Layer object
	bra.s	NonSolidUpdateState

; ------------------------------------------------------------------------------

LayeredUpdateState:
	jsr	LayerRpgObject					; Layer object

; ------------------------------------------------------------------------------

UpdateState:
	moveq	#OBJ_FULL_SOLID,d0				; Make solid
	jsr	SolidObject

NonSolidUpdateState:
	move.w	decor.interact_angles(a6),d0			; Can the player interact with us?
	jsr	InteractRpgObject
	bne.s	.NoInteract					; If not, branch

	move.l	decor.script(a6),d0				; Get script
	beq.s	.NoInteract					; If there is no script, branch
	movea.l	d0,a0						; Run script
	jsr	StartScript

.NoInteract:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Couch 1 state
; ------------------------------------------------------------------------------

Couch1:
	CHECK_EVENT EVENT_STAGE_3				; Has stage 3 been beaten?
	beq.s	.NotBrokenInto					; If not, branch
	jmp	DeleteObject					; Delete ourselves

.NotBrokenInto:
	CHECK_EVENT EVENT_COUCH_PUSH				; Have we been pushed?
	beq.s	.NotPushed					; If not, branch

	move.w	decor.origin_y(a6),d0				; Move to wall by default
	addi.w	#43,d0
	move.w	d0,obj.y(a6)
	move.l	#.Update,obj.update(a6)
	bra.s	.Update

; ------------------------------------------------------------------------------

.NotPushed:
	move.w	solid_object_top,a0				; Are we being pushed?
	cmpa.w	a6,a0
	bne.s	.Update						; If not, branch

	move.l	decor.script(a6),d0				; Get script
	beq.s	.Update						; If there is no script, branch
	movea.l	d0,a0						; Run script
	jsr	StartScript

	move.l	#.Pushing,obj.update(a6)			; Start moving
	move.w	#$FF1A,MARS_COMM_10+MARS_SYS

; ------------------------------------------------------------------------------

.Pushing:
	addq.w	#1,obj.y(a6)					; Move
	
	move.w	decor.origin_y(a6),d0				; Have we moved towards the wall?
	addi.w	#43,d0
	cmp.w	obj.y(a6),d0
	bgt.s	.Update						; If not, branch

	move.w	d0,obj.y(a6)					; Align with wall
	move.l	#.Update,obj.update(a6)				; Stop moving
	
	jsr	UnpauseScript					; Unpause script

; ------------------------------------------------------------------------------

.Update:
	moveq	#OBJ_FULL_SOLID,d0				; Make solid
	jsr	SolidObject
	
	jsr	LayerRpgObject					; Layer object
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Bathroom window state
; ------------------------------------------------------------------------------

BathroomWindow:
	move.b	#$12,decor.frame(a6)				; Broken frame
	CHECK_EVENT EVENT_WINDOW_REPAIR_1			; Have we been repaired?
	beq.s	.Update						; If not, branch
	move.b	#$13,decor.frame(a6)				; Repaired frame

.Update:
	bra.w	NonSolidUpdateState				; Update

; ------------------------------------------------------------------------------
; Dining room window state
; ------------------------------------------------------------------------------

DiningRoomWindow:
	move.b	#$12,decor.frame(a6)				; Broken frame
	CHECK_EVENT EVENT_WINDOW_REPAIR_2			; Have we been repaired?
	beq.s	.Update						; If not, branch
	move.b	#$13,decor.frame(a6)				; Repaired frame

.Update:
	bra.w	NonSolidUpdateState				; Update

; ------------------------------------------------------------------------------
; Wall crack state
; ------------------------------------------------------------------------------

WallCrack:
	CHECK_EVENT EVENT_WALL_SMASH				; Did the wall get smashed?
	beq.s	.End						; If not, branch
	CHECK_EVENT EVENT_WALL_REPAIR				; Have we been repaired?
	bne.s	.End						; If so, branch
	
	bra.w	NonSolidUpdateState				; Update

.End:
	rts

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	decor.sprites(a6),-(sp)				; Draw sprite
	move.b	decor.frame(a6),-(sp)
	clr.b	-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Scripts
; ------------------------------------------------------------------------------

OllieBedScript:
	SCRIPT_CHECK_EVENT		EVENT_STAGE_1
	SCRIPT_JUMP_SET			.NotStage1

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I don't really want to go back\n", &
					"to sleep."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

.NotStage1:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I can't sleep now. I have some\n", &
					"stuff to do first."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

OlliePcScript:
	SCRIPT_CHECK_EVENT		EVENT_SONIC_CULT
	SCRIPT_JUMP_SET			.Disdain

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I love my computer. It's what\n", &
					"I use to create my wonderful\n", &
					"works of art."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CHECK_EVENT		EVENT_STAGE_1
	SCRIPT_JUMP_SET			.NotStage1
	SCRIPT_CHECK_EVENT		EVENT_PC_INTERACT
	SCRIPT_JUMP_SET			.Interacted

.NotStage1:
	SCRIPT_SET_EVENT		EVENT_PC_INTERACT
	SCRIPT_END

; ------------------------------------------------------------------------------

.Interacted:
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"Too bad people don't seem to\n", &
					"appreciate my hard work..."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			2
	SCRIPT_SET_NUMBER_BYTE		sonic_cult_flashback, 1
	SCRIPT_SET_EVENT		EVENT_SONIC_CULT
	SCRIPT_END

; ------------------------------------------------------------------------------

.Disdain:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Mm."
	SCRIPT_WAIT_INPUT
	SCRIPT_END

; ------------------------------------------------------------------------------

OllieTrashScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"God, I really need to find the\n", &
					"time to clean this up. But, I\n", &
					"can't bring myself to do it."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"It really stinks up the whole\n", &
					"place and makes it that much\n", &
					"less inhabitable."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

OllieToiletScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I don't need to piss right now."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

OllieBathScript:
	SCRIPT_CHECK_EVENT		EVENT_STAGE_1
	SCRIPT_JUMP_SET			.NotStage1

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I really should get something\n", &
					"to eat first before I wash up."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

.NotStage1:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I don't feel like bathing\n", &
					"right now."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

OllieSinkScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Hey, looking good, good\n", &
					"looking."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"If you were a woman, I would\n", &
					"kiss you right now."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

OllieLaundryScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"These clothes really stink.\n", &
					"Too bad I don't own a washing\n", &
					"machine."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

OllieTvScript:
	SCRIPT_CHECK_EVENT		EVENT_TV_INTERACT
	SCRIPT_JUMP_SET			.Interacted

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Man, the political climate of\n", &
					"the 2000s is crazy."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"A few years ago, we had a\n", &
					"terrorist attack on our soils,\n", &
					"and now the swine flu."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"This world truly is fucked."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_SET_EVENT		EVENT_TV_INTERACT
	SCRIPT_END

; ------------------------------------------------------------------------------

.Interacted:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I don't want to watch the news\n", &
					"right now. One nightmare in a\n", &
					"day is more than enough."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

OllieCouch1PushScript:
	SCRIPT_SET_EVENT		EVENT_COUCH_PUSH
	SCRIPT_PAUSE
	SCRIPT_END

; ------------------------------------------------------------------------------

OllieGenesisScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Genesis does what Nintendon't!\n", &
					"My favorite game is Corpse\n", &
					"Killer for the Sega CD 32X."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

OllieFridgeScript:
	SCRIPT_CHECK_EVENT		EVENT_STAGE_1
	SCRIPT_JUMP_SET			.NotHungry
	SCRIPT_CHECK_EVENT		EVENT_7ELEVEN_HOME
	SCRIPT_JUMP_SET			.Microwave

	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Shoot, I'm out of food."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I should run to 7-Eleven and\n", &
					"grab some Cup Noodles and a\n", &
					"soda."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

.Microwave:
	SCRIPT_SET_EVENT		EVENT_MICROWAVE
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Let's get these noodles cooked\n", &
					"up and ready to eat!"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_PLAY_PWM			$FF15
	SCRIPT_DELAY			150
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_TEXT			"While the noodles are cooking,\n", &
					"I'm going to freshen myself up."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_CALL_M68K		.MovePlayer
	SCRIPT_END

; ------------------------------------------------------------------------------

.NotHungry:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I'm not feeling hungry right\n", &
					"now. Maybe later."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

.MovePlayer:
	movea.w	player_object,a1				; Move the player to the living room
	move.w	#$200,obj.y_speed(a1)
	move.l	#RpgPlayerLivingRoomState,obj.update(a1)
	rts

; ------------------------------------------------------------------------------

OllieBathroomWindowScript:
	SCRIPT_CHECK_EVENT		EVENT_STAGE_1
	SCRIPT_JUMP_SET			CheckBathroomWindowRepair

; ------------------------------------------------------------------------------

WindowStage1Script:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"I need to get this window\n", &
					"repaired sometime.\n"
	SCRIPT_WAIT_INPUT

WindowStage1ScriptEnd:
	SCRIPT_END

; ------------------------------------------------------------------------------

CheckBathroomWindowRepair:
	SCRIPT_CHECK_EVENT		EVENT_STAGE_2
	SCRIPT_JUMP_SET			WindowStage1ScriptEnd
	SCRIPT_CHECK_EVENT		EVENT_WINDOW_REPAIR_1
	SCRIPT_JUMP_SET			WindowStage1ScriptEnd
	SCRIPT_CHECK_EVENT		EVENT_GOT_GLASS
	SCRIPT_JUMP_CLEAR		WindowNotReadyScript
	SCRIPT_CHECK_EVENT		EVENT_GOT_TOOLBOX
	SCRIPT_JUMP_CLEAR		WindowNotReadyScript
	
	SCRIPT_SET_EVENT		EVENT_WINDOW_REPAIR_1

; ------------------------------------------------------------------------------

RepairedScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_PLAY_PWM			$FF24

	SCRIPT_TEXT			"That takes care of that!"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CHECK_EVENT		EVENT_WINDOW_REPAIR_1
	SCRIPT_JUMP_CLEAR		.End
	SCRIPT_CHECK_EVENT		EVENT_WINDOW_REPAIR_2
	SCRIPT_JUMP_CLEAR		.End
	SCRIPT_CHECK_EVENT		EVENT_WALL_SMASH
	SCRIPT_JUMP_CLEAR		.BreakIn
	SCRIPT_CHECK_EVENT		EVENT_WALL_REPAIR
	SCRIPT_JUMP_CLEAR		.End

.BreakIn:
	SCRIPT_HIDE_TEXTBOX
	SCRIPT_DELAY			15
	SCRIPT_PLAY_PWM			$FF22
	SCRIPT_DELAY			90

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_SHOW_TEXTBOX

	SCRIPT_TEXT			"What was that noise I heard\n", &
					"in the living room!?"
	SCRIPT_WAIT_INPUT

	SCRIPT_SET_EVENT		EVENT_BREAK_IN

.End:
	SCRIPT_END

; ------------------------------------------------------------------------------

WindowNotReadyScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_CHECK_EVENT		EVENT_GOT_GLASS
	SCRIPT_JUMP_CLEAR		.NoGlass

	SCRIPT_TEXT			"I need my toolbox to fix this\n", &
					"window. It should be in the\n", &
					"garage."
	SCRIPT_WAIT_INPUT

	SCRIPT_END

; ------------------------------------------------------------------------------

.NoGlass:
	SCRIPT_CHECK_EVENT		EVENT_GOT_TOOLBOX
	SCRIPT_JUMP_CLEAR		.NoGlassOrToolbox

	SCRIPT_TEXT			"I need glass to fix this\n", &
					"window. There should be some\n", &
					"in the backyard."
	SCRIPT_WAIT_INPUT

	SCRIPT_END

; ------------------------------------------------------------------------------

.NoGlassOrToolbox:
	SCRIPT_TEXT			"I need both glass and my\n", &
					"toolbox to fix this window."
	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"There should be some glass in\n", &
					"the backyard, and my toolbox\n", &
					"should be in the garage."
	SCRIPT_WAIT_INPUT

	SCRIPT_END

; ------------------------------------------------------------------------------

OllieDiningRoomWindowScript:
	SCRIPT_CHECK_EVENT		EVENT_STAGE_1
	SCRIPT_JUMP_CLEAR		WindowStage1Script
	SCRIPT_CHECK_EVENT		EVENT_STAGE_2
	SCRIPT_JUMP_SET			.End
	SCRIPT_CHECK_EVENT		EVENT_WINDOW_REPAIR_2
	SCRIPT_JUMP_SET			.End
	SCRIPT_CHECK_EVENT		EVENT_GOT_GLASS
	SCRIPT_JUMP_CLEAR		WindowNotReadyScript
	SCRIPT_CHECK_EVENT		EVENT_GOT_TOOLBOX
	SCRIPT_JUMP_CLEAR		WindowNotReadyScript

	SCRIPT_SET_EVENT		EVENT_WINDOW_REPAIR_2
	SCRIPT_JUMP			RepairedScript

.End:
	SCRIPT_END

; ------------------------------------------------------------------------------

WallCrackScript:
	SCRIPT_CHECK_EVENT		EVENT_STAGE_1
	SCRIPT_JUMP_CLEAR		.End
	SCRIPT_CHECK_EVENT		EVENT_STAGE_2
	SCRIPT_JUMP_SET			.End
	SCRIPT_CHECK_EVENT		EVENT_WALL_SMASH
	SCRIPT_JUMP_CLEAR		.End
	SCRIPT_CHECK_EVENT		EVENT_WALL_REPAIR
	SCRIPT_JUMP_SET			.End
	SCRIPT_CHECK_EVENT		EVENT_GOT_FILLER
	SCRIPT_JUMP_CLEAR		.NotReady

	SCRIPT_SET_EVENT		EVENT_WALL_REPAIR
	SCRIPT_JUMP			RepairedScript

.End:
	SCRIPT_END

; ------------------------------------------------------------------------------

.NotReady:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"I need some filler to fix the\n", &
					"drywall. There should be some\n", &
					"in the backyard."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

PrisonToiletScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"I do really need to pee... but\n", &
					"having everyone's eyes on me...\n"

	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"It prevents me from descending\n", &
					"my peehole with pee."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

PrisonSinkScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"We wash our hands to keep them\n", &
					"neat, before we have ourselves\n", &
					"a tasty treat!"
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

PrisonBedScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"This is harder than sleeping on\n", &
					"a bed of cinderblocks."

	SCRIPT_WAIT_INPUT

	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"A bed of nails would be\n", &
					"Tempur-Pedic compared to this\n", &
					"bed."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------
