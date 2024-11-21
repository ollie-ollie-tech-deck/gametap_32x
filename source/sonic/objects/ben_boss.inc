; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ben Drowned boss object header
; ------------------------------------------------------------------------------

	global ObjBenBoss

; ------------------------------------------------------------------------------
; Boss variables
; ------------------------------------------------------------------------------

	rsset obj.vars
ben_boss.timer		rs.w 1					; Timer
ben_boss.hit_count	rs.b 1					; Hit count
ben_boss.attack_count	rs.b 1					; Attack count
ben_boss.defeat_shake	rs.w 1					; Defeat shake intensity
ben_boss.attack_vein	rs.w 1					; Attacking vein object
ben_boss.defend_vein	rs.w 1					; Defensive vein object
ben_boss.hurt_box	rs.w 1					; Hurt box object
ben_boss.vein_x		rs.w 1					; Vein spawn X position
ben_boss.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; Vein variables
; ------------------------------------------------------------------------------

	rsset obj.vars
vein.timer		rs.w 1					; Timer
vein.wiggle_count	rs.b 0					; Wiggle count
vein.target_y		rs.w 1					; Target Y position
vein.parent		rs.w 1					; Parent object
vein.struct_len		rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
