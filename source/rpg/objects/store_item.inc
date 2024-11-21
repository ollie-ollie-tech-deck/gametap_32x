; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Store item object header
; ------------------------------------------------------------------------------

	global ObjStoreItem

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset rpg_obj.vars
store.frame		rs.b 1					; Sprite frame ID
store.interact_angles	rs.b 1					; Allowed interaction angles
store.script		rs.l 1					; Script address
store.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
