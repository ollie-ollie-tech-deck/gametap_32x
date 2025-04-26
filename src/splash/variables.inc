; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Splash screen scene variables
; ------------------------------------------------------------------------------

logo_text_art		equ scratch_buffer			; Text art
logo_text_art_dither	equ scratch_buffer+$2000		; Dithered text art
logo_text_map		equ scratch_buffer+$4000		; Text map

	rsset scene_variables
logo_state		rs.l 1					; Logo state
logo_draw		rs.l 1					; Logo draw routine
logo_scale		rs.w 1					; Logo scale
logo_left_distort	rs.w 1					; Logo left distortion
logo_right_distort	rs.w 1					; Logo right distortion
logo_x_intensity	rs.w 1					; Logo X distortion intensity
logo_top_distort	rs.w 1					; Logo top distortion
logo_bottom_distort	rs.w 1					; Logo bottom distortion
logo_y_intensity	rs.w 1					; Logo Y distortion intensity
gametap_scale		rs.w 1					; GameTap logo scale table index
wait_timer		rs.w 1					; Wait timer
text_dither_offset	rs.w 1					; Text dither offset
text_art_length		rs.w 1					; Text art lengtht
sample_command		rs.w 1					; Sample playback command
logo_frame		rs.b 1					; Logo frame

SCENE_VARS_LENGTH	equ __rs-scene_variables

; ------------------------------------------------------------------------------
