; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Spin tunnel object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjSpinTunnel:
	move.w	#16,obj.collide_width(a6)			; Set hitbox size
	move.w	#16,obj.collide_height(a6)
	
	move.l	#.Update,obj.update(a6)				; Set state

; ------------------------------------------------------------------------------

.Update:
	movea.w	player_object,a1				; Check collision with player
	jsr	CheckObjectCollide
	bne.s	.End						; If there was none, branch

	move.w	obj.x(a1),d0					; Get which side the player touched us from
	sub.w	obj.x(a6),d0
	ext.l	d0
	swap	d0						; 0 = right, $FF = left

	cmp.b	obj.subtype(a6),d0				; Should we make the player roll?
	beq.s	.Roll						; If so, branch
	clr.b	player.spin_tunnel(a1)				; Clear spin tunnel flag
	rts

.Roll:
	st	player.spin_tunnel(a1)				; Set spin tunnel flag
	btst	#SONIC_ROLL,obj.flags(a1)			; Is the player already rolling?
	bne.s	.End						; If so, branch

	move.w	a6,-(sp)					; Make the player roll
	movea.w	a1,a6
	jsr	SetSonicPlayerRoll
	movea.w	(sp)+,a6

.End:
	rts

; ------------------------------------------------------------------------------
