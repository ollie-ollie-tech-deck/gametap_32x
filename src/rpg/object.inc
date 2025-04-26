; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG object functions header
; ------------------------------------------------------------------------------

	global InteractRpgObject
	global TriggerRpgObject
	global LayerRpgObject
	global AnimateRpgObject
	global UpdateRpgObject
	global RpgObjectMapCollide

; ------------------------------------------------------------------------------
; Object variables
; ------------------------------------------------------------------------------

	rsset obj.vars
rpg_obj.angle		rs.b 1					; Angle
			rs.b 1
rpg_obj.vars		rs.b 0					; Object specific variables

; ------------------------------------------------------------------------------
