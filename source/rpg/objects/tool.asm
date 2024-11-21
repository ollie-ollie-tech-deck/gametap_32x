; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Tool object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/rpg/shared.inc"

; ------------------------------------------------------------------------------
; Initialization data entry
; ------------------------------------------------------------------------------

TOOL_DATA macro update_routine, frame, col_w, col_h, draw_w, draw_h, script, angles
	dc.w	\col_w, \col_h, \draw_w, \draw_h
	dc.b	\frame, \angles
	dc.l	\script
	dc.l	\update_routine
	even
	endm

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjTool:
	CHECK_EVENT EVENT_STAGE_3				; Has stage 3 been beaten?
	beq.s	.NotBrokenInto					; If not, branch
	jmp	DeleteObject					; Delete ourselves

.NotBrokenInto:
	moveq	#0,d0						; Get initialization data
	move.b	obj.subtype(a6),d0
	add.w	d0,d0
	lea	.InitData(pc),a0
	adda.w	(a0,d0.w),a0
	
	move.w	(a0)+,obj.collide_width(a6)			; Set hitbox size
	move.w	(a0)+,obj.collide_height(a6)
	move.w	(a0)+,obj.draw_width(a6)			; Set draw size
	move.w	(a0)+,obj.draw_height(a6)
	move.b	(a0)+,tool.frame(a6)				; Set sprite frame ID
	move.b	(a0)+,tool.interact_angles(a6)			; Set allowed interaction angles
	move.l	(a0)+,tool.script(a6)				; Set script address
	
	move.l	#Draw,obj.draw(a6)				; Set draw routine
	movea.l	(a0)+,a0					; Set and run update routine
	move.l	a0,obj.update(a6)
	jmp	(a0)

; ------------------------------------------------------------------------------

.InitData:
	dc.w	.Filler-.InitData
	dc.w	.Glass-.InitData
	dc.w	.Toolbox-.InitData

.Filler:
	TOOL_DATA FillerState, 0, 16, 8, 16, 16, FillerScript, %11111111

.Glass:
	TOOL_DATA GlassState, 1, 16, 8, 16, 16, GlassScript, %11111111

.Toolbox:
	TOOL_DATA ToolboxState, 2, 16, 8, 16, 16, ToolboxScript, %11111111

; ------------------------------------------------------------------------------
; Filler state
; ------------------------------------------------------------------------------

FillerState:
	CHECK_EVENT EVENT_GOT_FILLER				; Have we been picked up?
	beq.s	UpdateState					; If not, branch
	jmp	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Glass state
; ------------------------------------------------------------------------------

GlassState:
	CHECK_EVENT EVENT_GOT_GLASS				; Have we been picked up?
	beq.s	UpdateState					; If not, branch
	jmp	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Toolbox state
; ------------------------------------------------------------------------------

ToolboxState:
	CHECK_EVENT EVENT_GOT_TOOLBOX				; Have we been picked up?
	beq.s	UpdateState					; If not, branch
	jmp	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	moveq	#OBJ_FULL_SOLID,d0				; Make solid
	jsr	SolidObject

	move.b	tool.interact_angles(a6),d0			; Can the player interact with us?
	jsr	InteractRpgObject
	bne.s	.NoInteract					; If not, branch

	move.l	tool.script(a6),d0				; Get script
	beq.s	.NoInteract					; If there is no script, branch
	movea.l	d0,a0						; Run script
	jsr	StartScript

.NoInteract:
	jsr	LayerRpgObject					; Layer object
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	#4,-(sp)					; Draw sprite
	move.b	tool.frame(a6),-(sp)
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

FillerScript:
	SCRIPT_CHECK_EVENT		EVENT_STAGE_1
	SCRIPT_JUMP_CLEAR		.NoPickUp
	SCRIPT_CHECK_EVENT		EVENT_STAGE_2
	SCRIPT_JUMP_SET			.NoPickUp
	SCRIPT_CHECK_EVENT		EVENT_WALL_SMASH
	SCRIPT_JUMP_CLEAR		.NoPickUp

	SCRIPT_SET_EVENT		EVENT_GOT_FILLER
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I can use this to patch the\n", &
					"cracks in the drywall in my\n", &
					"room."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

.NoPickUp:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I have this filler just in\n", &
					"case I break some drywall."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

GlassScript:
	SCRIPT_CHECK_EVENT		EVENT_STAGE_1
	SCRIPT_JUMP_CLEAR		.NoPickUp
	SCRIPT_CHECK_EVENT		EVENT_STAGE_2
	SCRIPT_JUMP_SET			.NoPickUp

	SCRIPT_SET_EVENT		EVENT_GOT_GLASS
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"Ahh... some fresh glass for\n", &
					"the broken windows."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

.NoPickUp:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I really need to get this glass\n", &
					"installed in the broken\n", &
					"windows."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END
	
; ------------------------------------------------------------------------------

ToolboxScript:
	SCRIPT_CHECK_EVENT		EVENT_STAGE_1
	SCRIPT_JUMP_CLEAR		.NoPickUp
	SCRIPT_CHECK_EVENT		EVENT_STAGE_2
	SCRIPT_JUMP_SET			.NoPickUp

	SCRIPT_SET_EVENT		EVENT_GOT_TOOLBOX
	
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0
	
	SCRIPT_TEXT			"I can use these tools to\n", &
					"install the glass for the\n", &
					"windows."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------

.NoPickUp:
	SCRIPT_SHOW_TEXTBOX
	SCRIPT_ICON			OllieIcon, 0

	SCRIPT_TEXT			"My handy toolbox, always here\n", &
					"to save the day when I need it."
	SCRIPT_WAIT_INPUT
	
	SCRIPT_END

; ------------------------------------------------------------------------------
