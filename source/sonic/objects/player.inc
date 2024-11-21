; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sonic player object header
; ------------------------------------------------------------------------------

	global ObjSonicPlayer
	global SetSonicPlayerAirborne
	global HurtSonicPlayer
	global KillSonicPlayer
	global CheckSonicSolidObjects
	
; ------------------------------------------------------------------------------
; Flags
; ------------------------------------------------------------------------------

	rsreset
SONIC_X_FLIP		rs.b 1					; Horizontal flip flag
SONIC_AIR		rs.b 1					; Air flag
SONIC_ROLL		rs.b 1					; Roll flag
SONIC_JUMP		rs.b 1					; Jump flag
SONIC_RIDE		rs.b 1					; Ride object flag
SONIC_PUSH		rs.b 1					; Push flag
SONIC_LOCK		rs.b 1					; Lock controls
SONIC_TAPE		rs.b 1					; Hold tape flag

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset obj.vars
player.ctrl_hold	rs.b 1					; Held controller data
player.ctrl_tap		rs.b 1					; Tapped controller data
player.ground_speed	rs.w 1					; Ground speed
player.frame		rs.w 1					; Animation frame
player.gametap		rs.w 1					; Gametap sound timer
player.width		rs.w 1					; Hitbox width
player.height		rs.w 1					; Hitbox height
player.angle		rs.b 1					; Angle
player.lock		rs.b 1					; Movement lock timer
player.death_timer	rs.w 1					; Death timer
player.ride_object	rs.w 1					; Object being ridden on
player.ride_width	rs.w 1					; Object ride width
player.collision_layer	rs.b 1					; Collision layer
player.recover_timer	rs.b 1					; Recovery timer
player.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
