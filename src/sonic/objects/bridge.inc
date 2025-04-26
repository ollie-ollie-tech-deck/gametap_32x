; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Bridge object header
; ------------------------------------------------------------------------------

	global ObjBridge
	global ObjBridgeStump

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset obj.vars
bridge.y		rs.w 1					; Saved Y position
bridge.log_count	rs.w 1					; Log count
bridge.bend_center	rs.b 1					; Bend center
bridge.bend_angle	rs.b 1					; Bend angle
bridge.blink		rs.b $10				; Blink frames
bridge.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
