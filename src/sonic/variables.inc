; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sonic stage scene variables
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; Constants
; ------------------------------------------------------------------------------

YUGIOH_STATE_SLOTS	equ 512					; Number of Yu-Gi-Oh card state slots slots
COLLAPSE_COUNT		equ 64					; Collapsing piece count
BLOOD_PARTICLE_COUNT	equ 64					; Blood particle count

; ------------------------------------------------------------------------------
; Collapsing piece structure
; ------------------------------------------------------------------------------

	rsreset
			rs.b item.struct_len			; List item header
collapse.delay		rs.b 1					; Delay time
collapse.size		rs.b 1					; Sprite size
collapse.tile		rs.w 1					; Base tile ID
collapse.x		rs.w 1					; X position
collapse.y		rs.l 1					; Y position
collapse.y_speed	rs.w 1					; Y speed
collapse.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; Particle structure
; ------------------------------------------------------------------------------

	rsreset
			rs.b item.struct_len			; List item header
particle.x		rs.l 1					; X position
particle.y		rs.l 1					; Y position
particle.x_speed	rs.w 1					; X speed
particle.y_speed	rs.w 1					; Y speed
particle.x_accel	rs.w 1					; X acceleration
particle.y_accel	rs.w 1					; Y acceleration
particle.struct_len	rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset scene_variables
player_object		rs.w 1					; Player object
ben_appear		rs.w 1					; Appearing Ben object
cur_ben_object		rs.w 1					; Current Ben object

pal_cycle_timer		rs.b 1					; Palette cycle timer
button_flags		rs.b 1					; Button flags
ring_girl_transition	rs.b 1					; Ring Girl transition flag
ring_girl_trns_frame	rs.b 1					; Ring Girl transition frame

sunflower_anim_timer	rs.b 1					; Sunflower animation timer
sunflower_anim_frame	rs.b 1					; Sunflower animation frame
flower_anim_timer	rs.b 1					; Flower animation timer
flower_anim_frame	rs.b 1					; Flower animation frame
waterfall_anim_timer	rs.b 1					; Waterfall animation timer
waterfall_anim_frame	rs.b 1					; Waterfall animation frame

ben_bg_pal_offset	rs.w 1					; Ben Drowned background palette offset
ben_bg_pal_target	rs.w 1					; Ben Drowned background palette target offset

restart_stage		rs.b 1					; Restart stage flag
ben_tear_screen		rs.b 1					; Ben tear screen flag
go_to_rpg		rs.b 1					; Go to RPG stage flag
boss_end		rs.b 1					; Boss end flag
go_to_scary_maze	rs.b 1					; Go to Scary Maze flag
			rs.b 1

ollie_boss_frame	rs.b 1					; Ollie boss frame
ollie_boss_restart	rs.b 1					; Ollie boss restart flag

map_yugioh_cards	rs.l 1					; Map Yu-Gi-Oh card data address
yugioh_anim_frame	rs.b 1					; Yu-Gi-Oh card animation frame
yugioh_anim_timer	rs.b 1					; Yu-Gi-Oh card animation timer
yugioh_card_states	rs.b YUGIOH_STATE_SLOTS			; Map Yu-Gi-Oh card states

collapse_pieces		rs.b 0					; Collapsing pieces pool
			LIST_POOL collapse.struct_len,COLLAPSE_COUNT

blood_particles		rs.b 0					; Blood particles pool
			LIST_POOL particle.struct_len,BLOOD_PARTICLE_COUNT

SCENE_VARS_LENGTH	equ __rs-scene_variables		; Length of variables

; ------------------------------------------------------------------------------
