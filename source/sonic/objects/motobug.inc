; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Motobug object header
; ------------------------------------------------------------------------------

	global ObjMotobug

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset obj.vars
motobug.wait_timer	rs.w 1					; Wait timer
motobug.smoke_timer	rs.b 1					; Smoke timer
motobug.smoke_flags	rs.b 1					; Smoke flags
motobug.smoke_frame	rs.w 1					; Smoke frame
motobug.smoke_x		rs.w 1					; Smoke X position
motobug.smoke_y		rs.w 1					; Smoke Y position
motobug.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
