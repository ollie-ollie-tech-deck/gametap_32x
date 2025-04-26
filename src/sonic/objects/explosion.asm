; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Explosion object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state (normal)
; ------------------------------------------------------------------------------

ObjExplosion:
	SET_OBJECT_LAYER move.w,5,obj.layer(a6)			; Set layer
	
	move.w	#32,obj.draw_width(a6)				; Set draw size
	move.w	#48,obj.draw_height(a6)

	move.b	#14,explosion.frame(a6)				; Set up animation
	move.b	#27,explosion.last_frame(a6)
	move.w	#EXPLOSION_ANIM_TIME,explosion.anim_timer(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine
	
	lea	Sfx_Explosion,a0				; Play sound
	bsr.w	PlaySfx
	
	bra.s	UpdateState					; Start animating

; ------------------------------------------------------------------------------
; Initialization state (monitor)
; ------------------------------------------------------------------------------

ObjMonitorExplosion:
	SET_OBJECT_LAYER move.w,3,obj.layer(a6)			; Set layer
	
	move.w	#32,obj.draw_width(a6)				; Set draw size
	move.w	#48,obj.draw_height(a6)

	clr.b	explosion.frame(a6)				; Set up animation
	move.b	#13,explosion.last_frame(a6)
	move.w	#EXPLOSION_ANIM_TIME,explosion.anim_timer(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine
	
	lea	Sfx_Explosion,a0				; Play sound
	bsr.w	PlaySfx
	
	bra.s	UpdateState					; Start animating

; ------------------------------------------------------------------------------
; Initialization state (fire)
; ------------------------------------------------------------------------------

ObjFireExplosion:
	SET_OBJECT_LAYER move.w,5,obj.layer(a6)			; Set layer
	
	move.w	#32,obj.draw_width(a6)				; Set draw size
	move.w	#48,obj.draw_height(a6)

	move.b	#28,explosion.frame(a6)				; Set up animation
	move.b	#43,explosion.last_frame(a6)
	move.w	#EXPLOSION_ANIM_TIME,explosion.anim_timer(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine
	
	lea	Sfx_FireExplosion,a0				; Play sound
	bsr.w	PlaySfx

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	tst.w	obj.y_speed(a6)					; Should we be moving?
	bpl.s	.Animate					; If not, branch

	bsr.w	MoveObject					; Apply speed
	addi.w	#$38,obj.y_speed(a6)

.Animate:
	subq.w	#1,explosion.anim_timer(a6)			; Decrement animation timer
	bne.s	.NoAnimate					; If it hasn't run out, branch
	move.w	#EXPLOSION_ANIM_TIME,explosion.anim_timer(a6)	; Reset animation timer

	addq.b	#1,explosion.frame(a6)				; Next frame
	
	move.b	explosion.frame(a6),d0				; Are we done animating?
	cmp.b	explosion.last_frame(a6),d0
	bls.s	.NoAnimate					; If not, branch
	
	bra.w	DeleteObject					; Delete ourselves

.NoAnimate:
	bra.w	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	pea	MarsSpr_SonicExplosion				; Draw sprite
	move.b	explosion.frame(a6),-(sp)
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
	bsr.w	DrawMarsSprite
	rts

; ------------------------------------------------------------------------------
