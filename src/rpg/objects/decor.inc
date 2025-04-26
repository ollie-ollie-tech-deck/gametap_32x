; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG decor object header
; ------------------------------------------------------------------------------

	global ObjRpgDecor

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset rpg_obj.vars
decor.sprites		rs.b 1					; Sprite set ID
decor.frame		rs.b 1					; Sprite frame ID
decor.script		rs.l 1					; Script address
decor.origin_x		rs.w 1					; Origin X position
decor.origin_y		rs.w 1					; Origin Y position
decor.interact_angles	rs.w 1					; Allowed interaction angles
decor.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
