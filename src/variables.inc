; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; Events flags
; ------------------------------------------------------------------------------

	rsreset
EVENT_WAKE_UP		rs.b 1					; Wake up event flag
EVENT_MIRROR		rs.b 1					; Mirror event flag
EVENT_PC_INTERACT	rs.b 1					; PC interact event flag
EVENT_TV_INTERACT	rs.b 1					; TV interact event flag
EVENT_COUCH_PUSH	rs.b 1					; Couch push event flag
EVENT_7ELEVEN		rs.b 1					; 7-Eleven event flag
EVENT_CUP_NOODLES	rs.b 1					; Cup Noodles purchased event flag
EVENT_AXE_BODY_SPRAY	rs.b 1					; Axe body spray purchased event flag
EVENT_SODA		rs.b 1					; Soda purchased event flag
EVENT_7ELEVEN_HOME	rs.b 1					; Returned home from 7-Eleven flag
EVENT_MICROWAVE		rs.b 1					; Microwave event flag
EVENT_AXE_KNOCKOUT	rs.b 1					; Knocked out from Axe Body Spray event flag
EVENT_WALL_SMASH	rs.b 1					; Wall smash event flag
EVENT_SONIC_CULT	rs.b 1					; Sonic CulT event flag
EVENT_STAGE_1		rs.b 1					; Stage 1 finished event flag
EVENT_LEFT_CAR		rs.b 1					; Left car event flag
EVENT_GOT_FILLER	rs.b 1					; Got filler event flag
EVENT_GOT_GLASS		rs.b 1					; Got glass event flag
EVENT_GOT_TOOLBOX	rs.b 1					; Got toolbox event flag
EVENT_WINDOW_REPAIR_1	rs.b 1					; Bathroom window repair event flag
EVENT_WINDOW_REPAIR_2	rs.b 1					; Dining room window repair event flag
EVENT_WALL_REPAIR	rs.b 1					; Wall repair event flag
EVENT_BREAK_IN		rs.b 1					; Break in event flag
EVENT_STAGE_2		rs.b 1					; Stage 2 finished event flag
EVENT_SUSPECT_CHOOSE	rs.b 1					; Suspect choose event flag
EVENT_HOSPITAL_HALLWAY	rs.b 1					; Hospital hallway event flag
EVENT_STAGE_3		rs.b 1					; Stage 3 finished event flag
EVENT_RETURNED_HOME	rs.b 1					; Returned home event flag
EVENT_ASSAULTED_CULT	rs.b 1					; Assaulted cultist event flag
EVENT_STAGE_4		rs.b 1					; Stage 4 finished event flag
EVENT_ASSAULTED_WARDEN	rs.b 1					; Assaulted warden event flag
EVENT_CULT_ESCAPE_FAIL	rs.b 1					; Cult escape fail event flag
EVENT_CULT_KILLED	rs.b 1					; Cult killed event flag
EVENT_STAGE_5		rs.b 1					; Stage 5 finished event flag
EVENT_NEUTRAL_ENDING	rs.b 1					; Neutral ending event flag
EVENT_GOOD_ENDING	rs.b 1					; Good ending event flag

EVENT_COUNT		rs.b (16-(__rs&15))&15			; Event flag count
EVENT_BYTES		equ __rs/8				; Event flag byte count

; ------------------------------------------------------------------------------
; Set event bit
; ------------------------------------------------------------------------------
; PARAMETERS:
;	bit - Event bit to set
; ------------------------------------------------------------------------------

SET_EVENT macro bit
	bset	#(\bit)&7,event_flags+((\bit)/8)
	endm

; ------------------------------------------------------------------------------
; Clear event bit
; ------------------------------------------------------------------------------
; PARAMETERS:
;	bit - Event bit to clear
; ------------------------------------------------------------------------------

CLEAR_EVENT macro bit
	bclr	#(\bit)&7,event_flags+((\bit)/8)
	endm

; ------------------------------------------------------------------------------
; Check event bit
; ------------------------------------------------------------------------------
; PARAMETERS:
;	bit - Event bit to check
; ------------------------------------------------------------------------------

CHECK_EVENT macro bit
	btst	#(\bit)&7,event_flags+((\bit)/8)
	endm

; ------------------------------------------------------------------------------
; Variables
; ------------------------------------------------------------------------------

	rsset variables
event_flags		rs.b EVENT_BYTES			; Event flags

stage_frame_count	rs.w 1					; Stage frame counter
	
sonic_stage_id		rs.b 1					; Sonic stage ID
rpg_room_id		rs.b 1					; RPG room ID
rpg_warp_room_id	rs.b 1					; RPG warp room ID
rpg_warp_entry_id	rs.b 1					; RPG warp room entry ID
rpg_warp_x		rs.w 1					; RPG warp X position
rpg_warp_y		rs.w 1					; RPG warp Y position
rpg_warp_angle		rs.b 1					; RPG warp angle

player_health		rs.b 1					; Player health

script_address		rs.l 1					; Script address
script_flags		rs.b 1					; Script flag array
script_text_char	rs.b 1					; Script text character
script_text_tile	rs.w 1					; Script text tile properties
script_text_speed_value	rs.w 1					; Script text speed value
script_text_speed_count	rs.w 1					; Script text speed counter
script_text_line_cmd	rs.l 1					; Script textbox line VDP command
script_text_cur_cmd	rs.l 1					; Script textbox current VDP command
script_text_draw_cmd	rs.l 1					; Script textbox draw VDP command
script_delay_time	rs.w 1					; Script delay time
script_text_sound_time	rs.b 1					; Script text sound time
script_text_sound_id	rs.b 1					; Script text sound ID
script_icon_sprites	rs.l 1					; Script textbox icon sprites address
script_icon_cram	rs.b 1					; Script textbox icon CRAM index
script_selection_id	rs.b 1					; Script textbox selection ID
script_icon_anim	rs.b anim.struct_len			; Script textbox icon animation
script_condition_flags	rs.b 1					; Script condition flags
script_textbox_switch	rs.b 1					; Script textbox switch flag
script_call_stack	rs.l 4					; Script call stack
script_call_stack_base	rs.b 0					; Script call stack base
script_call_stack_addr	rs.l 1					; Script call stack address

; ------------------------------------------------------------------------------