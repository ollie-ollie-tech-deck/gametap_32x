; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Eyeball object header
; ------------------------------------------------------------------------------

	global ObjEyeball

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset obj.vars
eyeball.iris_x		rs.l 1					; Iris X position
eyeball.iris_y		rs.l 1					; Iris Y position
eyeball.iris_timer	rs.w 1					; Iris movement timer
eyeball.iris_target	rs.w 1					; Iris target timer value
eyeball.iris_sine	rs.l 1					; Iris movement sine
eyeball.iris_cosine	rs.l 1					; Iris movement cosine
eyeball.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
