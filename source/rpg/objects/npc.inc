; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; NPC object header
; ------------------------------------------------------------------------------

	global ObjRpgNpc
	global BurglarAggressionState
	global CultistAggressionState
	global DoctorIcon
	global CopIcon
	global CultistFrontDoorIcon
	global CultistIcon
	global WardenIcon

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset rpg_obj.vars
npc.timer		rs.w 1					; Timer
npc.sprites		rs.l 1					; Sprite data address
npc.struct_len		rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
