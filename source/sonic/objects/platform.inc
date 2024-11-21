; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Platform object header
; ------------------------------------------------------------------------------

	global ObjPlatform

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset obj.vars
platform.x_origin	rs.w 1					; X origin
platform.y_origin	rs.w 1					; Y origin
platform.y		rs.w 1					; Y position
platform.delay		rs.b 1					; Delay timer
platform.dip		rs.b 1					; Dip offset
platform.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
