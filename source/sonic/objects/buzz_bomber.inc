; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Buzz Bomber object header
; ------------------------------------------------------------------------------

	global ObjBuzzBomber

; ------------------------------------------------------------------------------
; Buzz Bomber variables
; ------------------------------------------------------------------------------

	rsset obj.vars
buzz_bomber.timer	rs.w 1					; Timer
buzz_bomber.wing_anim	rs.b anim.struct_len			; Wing animation
buzz_bomber.fire_anim	rs.b anim.struct_len			; Fire animation
buzz_bomber.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; Buzz Bomber missile variables
; ------------------------------------------------------------------------------

	rsset obj.vars
buzz_missile.timer	rs.w 1					; Timer
buzz_missile.parent	rs.w 1					; Parent object
buzz_missile.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
