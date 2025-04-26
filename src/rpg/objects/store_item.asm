; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Store item object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/rpg/shared.inc"

; ------------------------------------------------------------------------------
; Initialization data entry
; ------------------------------------------------------------------------------

ITEM_DATA macro update_routine, frame, col_w, col_h, draw_w, draw_h, script, angles
	dc.w	\col_w, \col_h, \draw_w, \draw_h
	dc.b	\frame, \angles
	dc.l	\script
	dc.l	\update_routine
	even
	endm

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjStoreItem:
	moveq	#0,d0						; Get initialization data
	move.b	obj.subtype(a6),d0
	add.w	d0,d0
	lea	.InitData(pc),a0
	adda.w	(a0,d0.w),a0
	
	move.w	(a0)+,obj.collide_width(a6)			; Set hitbox size
	move.w	(a0)+,obj.collide_height(a6)
	move.w	(a0)+,obj.draw_width(a6)			; Set draw size
	move.w	(a0)+,obj.draw_height(a6)
	move.b	(a0)+,store.frame(a6)				; Set sprite frame ID
	move.b	(a0)+,store.interact_angles(a6)			; Set allowed interaction angles
	move.l	(a0)+,store.script(a6)				; Set script address
	
	move.l	#Draw,obj.draw(a6)				; Set draw routine
	movea.l	(a0)+,a0					; Set and run update routine
	move.l	a0,obj.update(a6)
	jmp	(a0)

; ------------------------------------------------------------------------------

.InitData:
	dc.w	.CupNoodles-.InitData
	dc.w	.AxeBodySpray-.InitData
	dc.w	.Cooler-.InitData
	dc.w	.Shampoo-.InitData
	dc.w	.Maruchan-.InitData
	dc.w	.Pocky-.InitData
	dc.w	.Toothpaste-.InitData
	dc.w	.Toothbrush-.InitData
	dc.w	.KitKat-.InitData
	dc.w	.Twix-.InitData
	dc.w	.Lays-.InitData
	dc.w	.Doritos-.InitData
	dc.w	.Ruffles-.InitData
	dc.w	.Taquitos-.InitData
	dc.w	.HotDog-.InitData

.CupNoodles:
	ITEM_DATA CupNoodlesState, 0, 16, 16, 16, 24, CupNoodlesScript, %00100010

.AxeBodySpray:
	ITEM_DATA AxeBodySprayState, 1, 16, 16, 16, 24, AxeBodySprayScript, %00111110

.Cooler:
	ITEM_DATA UpdateState, 2, 72, 28, 80, 40, CoolerScript, %11111111

.Shampoo:
	ITEM_DATA UpdateState, 3, 16, 16, 16, 24, ShampooScript, %11100011

.Maruchan:
	ITEM_DATA UpdateState, 4, 16, 16, 16, 24, MaruchanScript, %10111110

.Pocky:
	ITEM_DATA UpdateState, 5, 16, 16, 16, 24, PockyScript, %11100011

.Toothpaste:
	ITEM_DATA UpdateState, 6, 16, 16, 16, 24, ToothpasteScript, %00111110

.Toothbrush:
	ITEM_DATA UpdateState, 7, 16, 16, 16, 24, ToothbrushScript, %11100011

.KitKat:
	ITEM_DATA UpdateState, 8, 16, 16, 16, 24, KitKatScript, %00111110

.Twix:
	ITEM_DATA UpdateState, 9, 16, 16, 16, 24, TwixScript, %11100011

.Lays:
	ITEM_DATA UpdateState, $A, 16, 16, 16, 24, LaysScript, %10111110

.Doritos:
	ITEM_DATA UpdateState, $B, 16, 16, 16, 24, DoritosScript, %00100010

.Ruffles:
	ITEM_DATA UpdateState, $C, 16, 16, 16, 24, RufflesScript, %11100011

.Taquitos:
	ITEM_DATA UpdateState, $D, 16, 16, 16, 24, TaquitosScript, %00111110

.HotDog:
	ITEM_DATA UpdateState, $E, 16, 16, 16, 24, HotDogScript, %11100011

; ------------------------------------------------------------------------------
; Cup Noodles state
; ------------------------------------------------------------------------------

CupNoodlesState:
	cmpi.b	#3,rpg_room_id					; Are we in the dining room?
	bne.s	.NotDiningRoom					; If not, branch
	CHECK_EVENT EVENT_STAGE_5				; Have we reached beaten stage 5?
	beq.s	.Delete						; If not, branch
	
	move.l	#UpdateState,obj.update(a6)			; Set state
	bra.s	UpdateState

.NotDiningRoom:
	CHECK_EVENT EVENT_CUP_NOODLES				; Have we been purchased?
	beq.s	UpdateState					; If not, branch

.Delete:
	jmp	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Axe Body Spray state
; ------------------------------------------------------------------------------

AxeBodySprayState:
	CHECK_EVENT EVENT_AXE_BODY_SPRAY			; Have we been purchased?
	beq.s	UpdateState					; If not, branch
	jmp	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	move.b	store.interact_angles(a6),d0			; Can the player interact with us?
	jsr	InteractRpgObject
	bne.s	.NoInteract					; If not, branch

	move.l	store.script(a6),d0				; Get script
	beq.s	.NoInteract					; If there is no script, branch
	movea.l	d0,a0						; Run script
	jsr	StartScript

.NoInteract:
	movea.w	player_object,a1				; Get player's Y position
	move.w	obj.y(a1),d0

	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set to lower layer
	cmp.w	obj.y(a6),d0					; Is the player behind us?
	bgt.s	.Draw						; If not, branch
	SET_OBJECT_LAYER move.w,5,obj.layer(a6)			; Set to upper layer

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	#3,-(sp)					; Draw sprite
	move.b	store.frame(a6),-(sp)
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

CupNoodlesScript:
	SCRIPT_SET_EVENT		EVENT_CUP_NOODLES
	SCRIPT_PLAY_PWM			$FF10
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Ah, some good ol' Cup Noodles!\n", &
					"I can't wait to heat this up\n", &
					"when I get home."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

AxeBodySprayScript:
	SCRIPT_SET_EVENT		EVENT_AXE_BODY_SPRAY
	SCRIPT_PLAY_PWM			$FF10
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"This is cheaper than bathing,\n", &
					"and is supposed to make me more\n", &
					"alluring according to the ads."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"If anything, this will help\n", &
					"speed up my morning routine."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

CoolerScript:
	SCRIPT_CHECK_EVENT		EVENT_SODA
	SCRIPT_JUMP_SET			.Purchased
	
	SCRIPT_SET_EVENT		EVENT_SODA
	SCRIPT_PLAY_PWM			$FF10
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Mmmm... a nice refreshing soda\n", &
					"pop to go with my Cup Noodles."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

.Purchased:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I already bought a soda."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------
	
ShampooScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I don't even have any hair to\n", &
					"use shampoo with."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

MaruchanScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Eating Maruchan noodles is the\n", &
					"equivalent of eating shit."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

PockyScript:
	SCRIPT_SHOW_TEXTBOX
	
	SCRIPT_ICON			OllieIcon, 0
	SCRIPT_TEXT			"I don't want this weeaboo\n", &
					"garbage."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

ToothpasteScript:
	SCRIPT_SHOW_TEXTBOX
	
	SCRIPT_ICON			OllieIcon, 0
	SCRIPT_TEXT			"I already have toothpaste at\n", &
					"home."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_CLEAR_TEXTBOX
	SCRIPT_TEXT			"I only use Sensodyne for my\n", &
					"tooth sensitivity, anyways."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

ToothbrushScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I already have toothbrush at\n", &
					"home."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

KitKatScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Kit Kat is my favorite candy,\n", &
					"but I'm not here to get that."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

TwixScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I don't like Twix, because I\n", &
					"can't the distinguish the left\n", &
					"Twix from the right."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

LaysScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Bleh, Lays are so bland."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

DoritosScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Doritos taste like sweaty gym\n", &
					"socks. Yuck."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

RufflesScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I like Ruffles, but not today."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

TaquitosScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I love 7-Eleven taquitos, but\n", &
					"I'm not here for those right\n", &
					"now."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

HotDogScript:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Mmmm... 7-Eleven hot dogs...\n", &
					"but not this time."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------
