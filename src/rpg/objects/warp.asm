; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG warp object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/rpg/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjRpgWarp:
	move.w	#8,obj.collide_width(a6)			; Set hitbox size
	move.w	#8,obj.collide_height(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	bsr.w	TriggerRpgObject				; Check trigger by player
	bne.s	.End						; If there's no trigger, branch

	cmpi.b	#7,rpg_room_id					; Are we at 7-Eleven?
	bne.s	.DoWarp						; If not, branch
	
	CHECK_EVENT EVENT_CUP_NOODLES				; Did the player pick up Cup Noodles?
	beq.s	.No7ElevenWarp					; If not, branch
	CHECK_EVENT EVENT_SODA					; Did the player pick up soda?
	beq.s	.No7ElevenWarp					; If not, branch
	CHECK_EVENT EVENT_AXE_BODY_SPRAY			; Did the player pick up Axe Body Spray?
	bne.s	.DoWarp						; If so, branch

.No7ElevenWarp:
	tst.l	script_address					; Is the script running?
	bne.s	.End						; If so, branch

	movea.w	player_object,a1				; Alert the player that not all items have been picked up
	move.l	#RpgPlayer7ElevenState,obj.update(a1)
	rts

.DoWarp:
	cmpi.b	#-1,rpg_warp_room_id				; Is there a warp already set?
	bne.s	.End						; If so, branch
	
	move.w	obj.subtype(a6),rpg_warp_room_id		; Set up warp
	movea.w	player_object,a1
	move.b	rpg_obj.angle(a1),rpg_warp_angle
	
	tst.b	obj.subtype_2(a6)				; Did we enter a door?
	bpl.s	.End						; If not, branch
	move.w	#$FF0E,MARS_COMM_10+MARS_SYS			; Play door open sound

.End:
	rts

; ------------------------------------------------------------------------------
