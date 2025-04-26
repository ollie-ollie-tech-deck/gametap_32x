; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Blockbuster object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjBlockbuster:
	SET_OBJECT_LAYER move.w,7,obj.layer(a6)			; Set layer
	
	move.w	#64,obj.draw_width(a6)				; Set draw size
	move.w	#64,obj.draw_height(a6)

	move.l	#CheckPlayerState,obj.update(a6)		; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Check player state
; ------------------------------------------------------------------------------

CheckPlayerState:
	movea.w	player_object,a1				; Has the player entered us?
	move.w	obj.x(a6),d0
	subi.w	#32,d0
	cmp.w	obj.x(a1),d0
	bgt.s	.Update						; If not, branch

	bset	#SONIC_LOCK,obj.flags(a1)			; Lock the player in place
	clr.w	obj.x_speed(a1)
	clr.w	player.ground_speed(a1)
	clr.w	player.ctrl_hold(a1)

	move.l	#.Wait,obj.update(a6)				; Wait for a bit
	move.w	#60,blockbuster.timer(a6)

; ------------------------------------------------------------------------------

.Wait:
	subq.w	#1,blockbuster.timer(a6)			; Decrement timer
	bne.s	.Update						; It it hasn't run out, branch

	movea.w	player_object,a1				; Make the player move right
	move.b	#BUTTON_RIGHT,player.ctrl_hold(a1)

	bset	#SONIC_TAPE,obj.flags(a1)			; Mark the tape as bought
	move.w	#$FF10,MARS_COMM_12+MARS_SYS

	move.l	#.Update,obj.update(a6)				; Set state

; ------------------------------------------------------------------------------

.Update:
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	#$C,-(sp)					; Draw sprite 1
	clr.b	-(sp)
	clr.b	-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
