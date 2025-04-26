; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Spikes object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjSpikes:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer

	move.b	obj.subtype(a6),d0				; Set width
	andi.w	#$F0,d0
	lsr.b	#3,d0
	move.w	.Sizes(pc,d0.w),d0
	move.w	d0,obj.collide_width(a6)
	move.w	d0,obj.draw_width(a6)

	move.w	#16,obj.collide_height(a6)			; Set height
	move.w	#16,obj.draw_height(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine
	bra.s	UpdateState

; ------------------------------------------------------------------------------

.Sizes:
	dc.w	8, 16, 24, 32, 40, 48, 56, 64

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	movea.w	player_object,a1				; Player object
	
	cmpa.w	player.ride_object(a1),a6			; Is the player standing on us?
	bne.s	.NotStoodOn					; If not, branch
	
	move.w	obj.x(a6),d0					; Hurt the player
	jsr	HurtSonicPlayer

	cmpi.b	#120,player.recover_timer(a1)			; Did the player just get hurt?
	bne.s	.NotStoodOn					; If not, branch
	
	lea	Sfx_Spikes,a0					; Play damage sound
	jsr	PlaySfx

.NotStoodOn:
	moveq	#OBJ_FULL_SOLID,d0				; Make solid
	jsr	SolidObject

	jsr	DrawObject					; Draw sprite
	jmp	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	move.b	obj.subtype(a6),d0				; Get number of pieces
	andi.w	#$F0,d0
	lsr.b	#4,d0
	move.w	d0,d1
	addq.w	#1,d1
	
	move.w	obj.x(a6),d2					; Get starting X position with camera X offset
	sub.w	obj.collide_width(a6),d2
	addq.w	#8,d2
	sub.w	camera_fg_x_draw,d2
	
	move.w	obj.y(a6),d3					; Get Y position with camera Y offset
	sub.w	camera_fg_y_draw,d3
	
	lea	mars_sprite_chain,a0				; Sprite chain buffer
	move.w	d1,(a0)+					; Set sprite count

.SetSpikePieces:
	clr.w	(a0)+						; Set sprite flip flags and frame ID
	move.w	d2,(a0)+					; Set sprite position
	move.w	d3,(a0)+

	addi.w	#16,d2						; Next set of spikes
	dbf	d0,.SetSpikePieces				; Loop until finished

	move.b	#5,-(sp)					; Draw sprites
	pea	mars_sprite_chain
	jsr	DrawLoadedMarsSpriteChain
	rts

; ------------------------------------------------------------------------------
