; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sonic object functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Handle hazard object
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l  - Object slot
; RETURNS:
;	eq/ne - Hit/Not hit
; ------------------------------------------------------------------------------

HazardObject:
	movea.w	player_object,a1				; Check collision with player
	bsr.w	CheckObjectCollide
	bne.s	.End						; If there was none, branch
	
	move.w	obj.x(a6),d0					; Hurt the player
	bsr.w	HurtSonicPlayer
	ori	#4,sr
	
.End:
	rts

; ------------------------------------------------------------------------------
; Handle insta-kill object
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l  - Object slot
; RETURNS:
;	eq/ne - Hit/Not hit
; ------------------------------------------------------------------------------

InstaKillObject:
	movea.w	player_object,a1				; Check collision with player
	bsr.w	CheckObjectCollide
	bne.s	.End						; If there was none, branch
	
	bsr.w	KillSonicPlayer					; Kill the player
	ori	#4,sr
	
.End:
	rts

; ------------------------------------------------------------------------------
; Handle badnik object
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l  - Object slot
; ------------------------------------------------------------------------------

BadnikObject:
	movea.w	player_object,a1				; Check collision with player
	bsr.w	CheckObjectCollide
	bne.s	.End						; If there was none, branch

	btst	#SONIC_ROLL,obj.flags(a1)			; Is the player rolling?
	beq.s	.Hurt						; If not, branch

	move.l	#ObjExplosion,obj.update(a6)			; Turn into an explosion
	move.l	#ObjExplosion,(sp)

	tst.w	obj.y_speed(a1)					; Is the player moving up?
	bmi.s	.BounceDown					

	move.w	obj.y(a1),d0					; Is the player below us?
	cmp.w	obj.y(a6),d0
	bge.s	.BounceUp					; If so, branch

	neg.w	obj.y_speed(a1)					; Bounce the player off of us
	rts

.BounceDown:
	addi.w	#$100,obj.y_speed(a1)				; Bound downwards
	rts

.BounceUp:
	subi.w	#$100,obj.y_speed(a1)				; Bound upwards

.End:
	rts

.Hurt:
	move.w	obj.x(a6),d0					; Hurt the player
	bra.w	HurtSonicPlayer

; ------------------------------------------------------------------------------
; Handle boss object
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l  - Object slot
; RETURNS:
;	eq/ne - Hit/Not hit
; ------------------------------------------------------------------------------

BossObject:
	movea.w	player_object,a1				; Check collision with player
	bsr.w	CheckObjectCollide
	bne.s	.NotHit						; If there was none, branch

	btst	#SONIC_ROLL,obj.flags(a1)			; Is the player rolling?
	beq.s	.Hurt						; If not, branch

	neg.w	obj.x_speed(a1)					; Repel the player
	neg.w	obj.y_speed(a1)
	neg.w	player.ground_speed(a1)

	ori	#4,sr						; Hit
	rts

.Hurt:
	move.w	obj.x(a6),d0					; Hurt the player
	bsr.w	HurtSonicPlayer

.NotHit:
	andi	#~4,sr						; Not hit
	rts

; ------------------------------------------------------------------------------
; Handle boss object (without hazard)
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l  - Object slot
; RETURNS:
;	eq/ne - Hit/Not hit
; ------------------------------------------------------------------------------

BossObjectNoHazard:
	movea.w	player_object,a1				; Check collision with player
	bsr.w	CheckObjectCollide
	bne.s	.NotHit						; If there was none, branch

	btst	#SONIC_ROLL,obj.flags(a1)			; Is the player rolling?
	beq.s	.NotHit						; If not, branch

	neg.w	obj.x_speed(a1)					; Repel the player
	neg.w	obj.y_speed(a1)
	neg.w	player.ground_speed(a1)

	ori	#4,sr						; Hit
	rts

.NotHit:
	andi	#~4,sr						; Not hit
	rts

; ------------------------------------------------------------------------------
