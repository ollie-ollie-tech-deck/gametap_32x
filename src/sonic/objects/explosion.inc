; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Explosion object header
; ------------------------------------------------------------------------------

	global ObjExplosion
	global ObjMonitorExplosion
	global ObjFireExplosion

; ------------------------------------------------------------------------------
; Constants
; ------------------------------------------------------------------------------

EXPLOSION_ANIM_TIME	equ 3					; Animation time

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset obj.vars
explosion.frame		rs.b 1					; Sprite frame
explosion.last_frame	rs.b 1					; Last sprite frame
explosion.anim_timer	rs.w 1					; Animation timer
explosion.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
