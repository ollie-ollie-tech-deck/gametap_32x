; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Newtron object header
; ------------------------------------------------------------------------------

	global ObjNewtron

; ------------------------------------------------------------------------------
; Newtron variables
; ------------------------------------------------------------------------------

	rsset obj.vars
newtron.timer		rs.w 1					; Timer
newtron.fire_anim	rs.b anim.struct_len			; Fire animation
newtron.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; Newtron missile variables
; ------------------------------------------------------------------------------

	rsset obj.vars
newt_missile.timer	rs.w 1					; Timer
newt_missile.parent	rs.w 1					; Parent object
newt_missile.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
