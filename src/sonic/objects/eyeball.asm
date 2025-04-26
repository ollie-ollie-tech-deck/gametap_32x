; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Eyeball object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjEyeball:
	SET_OBJECT_LAYER move.w,0,obj.layer(a6)			; Set layer
	
	move.w	#16,obj.draw_width(a6)				; Set draw size
	move.w	#16,obj.draw_height(a6)

	move.l	obj.x(a6),eyeball.iris_x(a6)			; Set iris position
	move.l	obj.y(a6),eyeball.iris_y(a6)
	
	bsr.s	PrepareIrisMovement				; Preparte iris movement
	
	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	move.w	eyeball.iris_timer(a6),d0			; Is the iris moving outwards?
	cmp.w	eyeball.iris_target(a6),d0
	blt.s	.MoveIrisOut					; If so, branch
	bgt.s	.MoveIrisIn					; If it's moving inwards, branch
	
	tst.w	d0						; Did we finish moving inwards?
	bmi.s	.RestartIrisMove				; If so, branch
	
	bsr.w	Random						; Set random iris target timer value
	andi.w	#$1F,d0
	neg.w	d0
	move.w	d0,eyeball.iris_target(a6)
	bra.s	.Draw

.RestartIrisMove:
	bsr.s	PrepareIrisMovement				; Preparte iris movement
	bra.s	.Draw

.MoveIrisOut:
	addq.w	#1,eyeball.iris_timer(a6)			; Move the iris outwards
	bmi.s	.Draw
	beq.s	.Draw
	cmpi.w	#4+1,eyeball.iris_timer(a6)			; Should we cap the movement?
	bge.s	.Draw						; If so, branch
	
	move.l	eyeball.iris_cosine(a6),d0			; Move the iris outwards
	add.l	d0,eyeball.iris_x(a6)
	move.l	eyeball.iris_sine(a6),d1
	add.l	d1,eyeball.iris_y(a6)
	bra.s	.Draw

.MoveIrisIn:
	subq.w	#1,eyeball.iris_timer(a6)			; Move the iris inwards
	bmi.s	.Draw						; If we should cap the movement, branch
	cmpi.w	#4,eyeball.iris_timer(a6)			; Should we cap the movement?
	bge.s	.Draw						; If so, branch
	
	move.l	eyeball.iris_cosine(a6),d0			; Move the iris inwards
	sub.l	d0,eyeball.iris_x(a6)
	move.l	eyeball.iris_sine(a6),d1
	sub.l	d1,eyeball.iris_y(a6)
	
.Draw:
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Preparte iris movement
; ------------------------------------------------------------------------------

PrepareIrisMovement:
	bsr.w	Random						; Set random iris target timer value
	andi.w	#$3F,d0
	addq.w	#5,d0
	move.w	d0,eyeball.iris_target(a6)
	
	bsr.w	Random						; Set random iris trajectory
	bsr.w	CalcSine
	ext.l	d0
	ext.l	d1
	asl.l	#8,d0
	asl.l	#8,d1
	move.l	d0,eyeball.iris_sine(a6)
	move.l	d1,eyeball.iris_cosine(a6)
	rts

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	lea	mars_sprite_chain,a0				; Sprite chain buffer
	move.w	#3,(a0)+					; Set sprite count
	
	move.w	#$100,(a0)+					; Set up whites
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,(a0)+
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,(a0)+
	
	move.w	#$200,(a0)+					; Set up iris
	move.w	eyeball.iris_x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,(a0)+
	move.w	eyeball.iris_y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,(a0)+
	
	clr.w	(a0)+						; Set up outline
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,(a0)+
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,(a0)+
	
	move.b	#$D,-(sp)					; Draw sprites
	pea	mars_sprite_chain
	bsr.w	DrawLoadedMarsSpriteChain
	rts

; ------------------------------------------------------------------------------
