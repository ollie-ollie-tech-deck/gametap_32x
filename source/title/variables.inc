; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Title screen scene variables
; ------------------------------------------------------------------------------

	rsset scene_variables
gametap_scale		rs.w 1					; GameTap logo scale
cup_noodles_scale	rs.w 1					; Cup Noodles logo scale
bitter_tears_scale	rs.w 1					; Bitter Tears logo scale
cur_logo_scale		rs.w 1					; Current logo scale value address
pal_cycle_timer		rs.b 1					; Palette cycle timer

SCENE_VARS_LENGTH	equ __rs-scene_variables

; ------------------------------------------------------------------------------
