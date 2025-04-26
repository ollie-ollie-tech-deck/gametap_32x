; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Player object header
; ------------------------------------------------------------------------------

	global ObjRpgPlayer
	global RpgPlayer7ElevenState
	global RpgPlayerLivingRoomState
	global RpgPlayerWardenState
	global RpgPlayerDragState
	global OllieIcon

; ------------------------------------------------------------------------------
; Flags
; ------------------------------------------------------------------------------

	rsset OBJ_USER_FLAGS
PLAYER_HIDDEN		rs.b 1					; Hidden flag
PLAYER_NO_SOLID		rs.b 1					; Ignore solid objects flag

; ------------------------------------------------------------------------------
; Player variables
; ------------------------------------------------------------------------------

	rsset rpg_obj.vars
player.shake_timer	rs.b 1					; Shake timer
player.timer		rs.b 1					; Timer
player.car		rs.w 1					; Car object
player.garage_door	rs.w 1					; Garage door object
player.crashing_car	rs.w 1					; Crashing car object
player.burglar		rs.w 1					; Burglar object
player.cultist		rs.w 1					; Cultist object
player.prison_door	rs.w 1					; Prison door object
player.warden		rs.w 1					; Warden object
player.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; Za Warudo variables
; ------------------------------------------------------------------------------

	rsset rpg_obj.vars
za_warudo.scale		rs.w 1					; Scale
za_warudo.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
