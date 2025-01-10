; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG stage scene variables
; ------------------------------------------------------------------------------

	rsset scene_variables
player_object		rs.w 1					; Player object
ao_oni_object		rs.w 1					; Ao Oni object

next_sonic_stage	rs.b 1					; Next Sonic stage ID
sonic_cult_flashback	rs.b 1					; Sonic CulT flashback flag
photo_cutscene		rs.b 1					; Photo cutscene flag
cut_to_black		rs.b 1					; Cut to black flag
suspect_choose		rs.b 1					; Suspect choose flag
ao_oni_chase_music	rs.b 1					; Ao Oni chase music timer
ao_oni_touched		rs.b 1					; Ao Oni touched flag
silent_hill_cutscene	rs.b 1					; Silent Hill cutscene flag
cult_front_door		rs.b 1					; Cult at front door cutscene flag
good_ending		rs.b 1					; Good ending flag
scary_maze_jumpscare	rs.b 1					; Scary Maze jumpscare flag

sonic_cult_screen	rs.b 1					; Sonic CulT screen ID
prev_sonic_cult_screen	rs.b 1					; Previous Sonic CulT flashback screen ID
sonic_cult_fist_frame	rs.b 1					; Sonic CulT flashback fist frame

photo_x			rs.w 1					; Photo X position
photo_y			rs.w 1					; Photo Y position

SCENE_VARS_LENGTH	equ __rs-scene_variables

; ------------------------------------------------------------------------------
