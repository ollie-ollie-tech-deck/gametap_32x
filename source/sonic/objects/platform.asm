; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Platform object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjPlatform:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer

	move.w	#32,obj.collide_width(a6)			; Set hitbox size
	move.w	#12,obj.collide_height(a6)
	
	move.w	#32,obj.draw_width(a6)				; Set draw size
	move.w	#16,obj.draw_height(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine
	
	move.w	obj.x(a6),platform.x_origin(a6)			; Set origin position
	move.w	obj.y(a6),platform.y_origin(a6)

	move.w	obj.y(a6),platform.y(a6)			; Set Y position

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	moveq	#$F,d0						; Handle subtype
	and.b	obj.subtype(a6),d0
	add.w	d0,d0
	move.w	.Subtypes(pc,d0.w),d0
	jsr	.Subtypes(pc,d0.w)

	movea.w	player_object,a1				; Is the player standing on us?
	cmpa.w	player.ride_object(a1),a6
	bne.s	.NotStoodOn					; If not, branch

	cmpi.b	#$40,platform.dip(a6)				; Have undipped?
	beq.s	.UpdateY					; If so, branch
	addq.b	#4,platform.dip(a6)				; Dip
	bra.s	.UpdateY

.NotStoodOn:
	tst.b	platform.dip(a6)				; Have we undipped?
	beq.s	.UpdateY					; If so, branch
	subq.b	#4,platform.dip(a6)				; Undip

.UpdateY:
	move.b	platform.dip(a6),d0				; Set Y position
	bsr.w	CalcSine
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,-(sp)
	move.b	(sp)+,d0
	ext.w	d0
	add.w	platform.y(a6),d0
	move.w	d0,obj.y(a6)

	moveq	#OBJ_TOP_SOLID,d0				; Make top solid
	bsr.w	SolidObject

	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------

.Subtypes:
	dc.w	NoMovement-.Subtypes
	dc.w	MoveRightToLeft-.Subtypes
	dc.w	MoveDownToUp-.Subtypes
	dc.w	WaitFall-.Subtypes
	dc.w	MoveFall-.Subtypes
	dc.w	MoveLeftToRight-.Subtypes
	dc.w	MoveUpToDown-.Subtypes
	dc.w	NoMovement-.Subtypes
	dc.w	NoMovement-.Subtypes
	dc.w	NoMovement-.Subtypes

; ------------------------------------------------------------------------------
; Move left to right
; ------------------------------------------------------------------------------

MoveLeftToRight:
	move.w	stage_frame_count,d0				; Left to right movement
	bsr.w	CalcSine
	asr.w	#2,d1
	bra.s	MoveHorizontal

; ------------------------------------------------------------------------------
; Move right to left
; ------------------------------------------------------------------------------

MoveRightToLeft:
	move.w	stage_frame_count,d0				; Right to left movement
	bsr.w	CalcSine
	asr.w	#2,d1
	neg.w	d1

; ------------------------------------------------------------------------------
; Move horizontally
; ------------------------------------------------------------------------------

MoveHorizontal:
	move.w	platform.x_origin(a6),d0			; Set X position
	add.w	d1,d0
	move.w	d0,obj.x(a6)

NoMovement:
	rts

; ------------------------------------------------------------------------------
; Move up to down
; ------------------------------------------------------------------------------

MoveUpToDown:
	move.w	stage_frame_count,d0				; Left to right movement
	bsr.w	CalcSine
	asr.w	#4,d1
	bra.s	MoveVertical

; ------------------------------------------------------------------------------
; Move down to up
; ------------------------------------------------------------------------------

MoveDownToUp:
	move.w	stage_frame_count,d0				; Right to left movement
	bsr.w	CalcSine
	asr.w	#2,d1
	neg.w	d1

; ------------------------------------------------------------------------------
; Move vertically
; ------------------------------------------------------------------------------

MoveVertical:
	move.w	platform.y_origin(a6),d0			; Set Y position
	add.w	d1,d0
	move.w	d0,platform.y(a6)
	rts

; ------------------------------------------------------------------------------
; Wait to be stood on before falling
; ------------------------------------------------------------------------------

WaitFall:
	tst.b	platform.delay(a6)				; Is the delay timer active?
	bne.s	.Wait						; If so, branch

	movea.w	player_object,a1				; Is the player standing on us?t
	cmpa.w	player.ride_object(a1),a6
	bne.s	.End						; If not, branch

	move.b	#30,platform.delay(a6)				; Set delay time

.End:
	rts

.Wait:
	subq.b	#1,platform.delay(a6)				; Decrement delay timer
	bne.s	.End						; If is hasn't run out, branch
	addq.b	#1,obj.subtype(a6)				; Start falling
	rts

; ------------------------------------------------------------------------------
; Fall
; ------------------------------------------------------------------------------

MoveFall:
	cmpi.w	#$400,obj.y_speed(a6)				; Are we falling fast enough?
	bge.s	.Fall						; If so, branch
	addi.w	#$40,obj.y_speed(a6)				; Apply gravity

.Fall:
	move.w	obj.y_speed(a6),d0				; Fall down
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,platform.y(a6)

	move.w	map_fg_bound_bottom,d0				; Are we at the bottom of the stage?
	addi.w	#64,d0
	cmp.w	platform.y(a6),d0
	bge.s	.End						; If not, branch

	bsr.w	ClearObjectSpawnFlag				; Mark as despawned

	addq.w	#4,sp						; Delete ourselves
	bra.w	DeleteObject

.End:
	rts

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	#2,-(sp)					; Draw sprite
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	obj.x(a6),d1
	sub.w	camera_fg_x_draw,d1
	move.w	d1,-(sp)
	move.w	obj.y(a6),d1
	sub.w	camera_fg_y_draw,d1
	move.w	d1,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
