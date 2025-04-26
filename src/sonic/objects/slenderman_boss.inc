; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Slenderman boss header
; ------------------------------------------------------------------------------

	global ObjSlendermanBoss

; ------------------------------------------------------------------------------
; Slenderman variables
; ------------------------------------------------------------------------------

	rsset obj.vars
slenderman.scale	rs.w 1					; Scale
slenderman.timer	rs.w 1					; Timer
slenderman.hit_count	rs.b 1					; Hit count
slenderman.flash	rs.b 1					; Flash timer
slenderman.fist		rs.w 1					; Fist object
slenderman.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; Fist variables
; ------------------------------------------------------------------------------

	rsset obj.vars
slender_fist.timer	rs.w 1					; Timer
slender_fist.parent	rs.w 1					; Parent object
slender_fist.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
