; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ben object header
; ------------------------------------------------------------------------------

	global ObjBen

; ------------------------------------------------------------------------------
; Ben variables
; ------------------------------------------------------------------------------

	rsset obj.vars
ben.portal		rs.w 1					; Portal
ben.struct_len		rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; Portal variables
; ------------------------------------------------------------------------------

	rsset obj.vars
ben_portal.parent	rs.w 1					; Parent
ben_portal.scale	rs.w 1					; Scale
ben_portal.frame	rs.b 1					; Frame ID
ben_portal.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------