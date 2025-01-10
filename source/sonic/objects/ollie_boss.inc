; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ollie boss object header
; ------------------------------------------------------------------------------

	global ObjOllieBoss

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset obj.vars
ollie_boss.timer	rs.w 1					; Timer
ollie_boss.hit_count	rs.b 1					; Hit count
ollie_boss.button	rs.b 1					; Button ID
ollie_boss.prev_button	rs.b 1					; Previous button ID
			rs.b 1
ollie_boss.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
