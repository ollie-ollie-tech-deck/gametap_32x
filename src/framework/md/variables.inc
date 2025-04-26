; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Mega Drive variables
; ------------------------------------------------------------------------------

	rsset WORK_RAM
scratch_buffer		rs.b $8000				; Scratch buffer

framework_variables	rs.b 0					; Start of framework variables

p1_ctrl_data		rs.b 0					; Player 1 controller data
p1_ctrl_hold 		rs.b 1					; Player 1 held controller data
p1_ctrl_tap		rs.b 1					; Player 1 tapped controller data
p2_ctrl_data		rs.b 0					; Player 2 controller data
p2_ctrl_hold 		rs.b 1					; Player 2 held controller data
p2_ctrl_tap		rs.b 1					; Player 2 tapped controller data

vblank_routine		rs.l 1					; V-BLANK routine
vblank_return		rs.l 1					; V-BLANK return stack address
hblank_int		rs.b $100				; H-BLANK interrupt
frame_count		rs.l 1					; Frame count
vsync_flag		rs.b 1					; VSync flag

hardware_version	rs.b 1					; Hardware version

rng_seed		rs.l 1					; RNG seed

palette			rs.w $40				; Palette buffer
cram_buffer		rs.w $40				; CRAM buffer
pal_fade_intensity	rs.w 1					; Palette fade intensity

hscroll			rs.l $E0				; Horizontal scroll table
auto_scroll		rs.l $40				; Auto-scroll table

kos_buffer		rs.b $1000				; Kosinski decompression buffer

kos_queue_vars		rs.b 0					; Kosinski decompression queue variables
kos_queue_count		rs.w 1					; Kosinski decompression queue count
kos_decomp_regs		rs.b (7*2)+(3*4)			; Kosinski decompression stored registers
kos_decomp_sr		rs.w 1					; Kosinski decompression stored SR
kos_bookmark		rs.l 1					; Kosinski decompression bookmark
kos_queue		rs.b 4*8				; Kosinski decompression queue
kos_decomp_src		equ kos_queue
kos_decomp_dest		equ kos_queue+4
kos_queue_end		rs.b 0
kosm_mods_left		rs.w 1					; Kosinski moduled decompression modules left
kosm_last_mod_size	rs.w 1					; Kosinski moduled decompression last module size
kosm_queue		rs.b $30*6				; Kosinski moduled decompression queue
kosm_decomp_src		equ kosm_queue
kosm_decomp_dest	equ kosm_queue+4
kosm_queue_end		rs.b 0
kos_queue_vars_end	rs.b 0					; End of Kosinski decompression queue variables

plane_width		rs.w 1					; Plane width
plane_height		rs.w 1					; Plane height
plane_stride		rs.l 1					; Plane stride

sprites			rs.b $280				; Sprite table
sprite_slot		rs.w 1					; Sprite table slot
sprite_slots_left	rs.w 1					; Number of sprite slots left in table

dma_queue		rs.b DMA_QUEUE_SIZE			; DMA queue
dma_slot		rs.w 1					; DMA queue slot

objects			rs.b 0					; Object pool
			LIST_POOL obj.struct_len,OBJECT_COUNT
object_draw_queue	rs.w OBJECT_LAYERS*(OBJ_DRAW_SLOTS+1)	; Object draw queue
solid_objects		rs.w (OBJECT_COUNT+1)*2			; Solid object list
solid_object_top	rs.w 1					; Touched solid object (top)
solid_width_top		rs.w 1					; Touched solid object collision width (top)
solid_height_top	rs.w 1					; Touched solid object collision height (top)
solid_object_bottom	rs.w 1					; Touched solid object (bottom)
solid_width_bottom	rs.w 1					; Touched solid object collision width (bottom)
solid_height_bottom	rs.w 1					; Touched solid object collision height (bottom)
solid_object_left	rs.w 1					; Touched solid object (left)
solid_width_left	rs.w 1					; Touched solid object collision width (left)
solid_height_left	rs.w 1					; Touched solid object collision height (left)
solid_object_right	rs.w 1					; Touched solid object (right)
solid_width_right	rs.w 1					; Touched solid object collision width (right)
solid_height_right	rs.w 1					; Touched solid object collision height (right)

obj_angle_buffer	rs.b 2					; Map angle buffer

map_foreground		rs.b map.struct_len			; Foreground layer
map_background		rs.b map.struct_len			; Background layer

camera_fg_x 		equ map_foreground+map.x_current	; Foreground camera X position
camera_fg_y 		equ map_foreground+map.y_current	; Foreground camera Y position
camera_fg_x_block	equ map_foreground+map.x_block		; Foreground camera block X position
camera_fg_y_block	equ map_foreground+map.y_block		; Foreground camera block Y position
camera_fg_x_previous	equ map_foreground+map.x_previous	; Foreground camera previous X position
camera_fg_y_previous	equ map_foreground+map.y_previous	; Foreground camera previous Y position
camera_fg_x_scroll 	equ map_foreground+map.x_scroll		; Foreground camera scroll X position
camera_fg_y_scroll 	equ map_foreground+map.y_scroll		; Foreground camera scroll Y position
camera_fg_x_speed 	equ map_foreground+map.x_speed		; Foreground camera X scroll speed
camera_fg_y_speed	equ map_foreground+map.y_speed		; Foreground camera Y scroll speed
camera_fg_x_shake	equ map_foreground+map.x_shake		; Foreground camera X shake offset
camera_fg_y_shake	equ map_foreground+map.y_shake		; Foreground camera Y shake offset
camera_fg_x_draw	equ map_foreground+map.x_draw		; Foreground camera X draw offset
camera_fg_y_draw	equ map_foreground+map.y_draw		; Foreground camera Y draw offset
map_fg_bound_left	equ map_foreground+map.bound_left	; Foreground camera left boundary
map_fg_bound_right	equ map_foreground+map.bound_right	; Foreground camera right boundary
map_fg_bound_top	equ map_foreground+map.bound_top	; Foreground camera top boundary
map_fg_bound_bottom	equ map_foreground+map.bound_bottom	; Foreground camera bottom boundary
map_fg_target_left	equ map_foreground+map.target_left	; Foreground camera target left boundary
map_fg_target_right	equ map_foreground+map.target_right	; Foreground camera target right boundary
map_fg_target_top	equ map_foreground+map.target_top	; Foreground camera target top boundary
map_fg_target_bottom	equ map_foreground+map.target_bottom	; Foreground camera target bottom boundary
map_fg_flags		equ map_foreground+map.flags		; Foreground layer flags
map_fg_data		equ map_foreground+map.data		; Foreground layer map data

camera_bg_x 		equ map_background+map.x_current	; Background camera X position
camera_bg_y 		equ map_background+map.y_current	; Background camera Y position
camera_bg_x_block	equ map_background+map.x_block		; Background camera block X position
camera_bg_y_block	equ map_background+map.y_block		; Background camera block Y position
camera_bg_x_previous	equ map_background+map.x_previous	; Background camera previous X position
camera_bg_y_previous	equ map_background+map.y_previous	; Background camera previous Y position
camera_bg_x_scroll 	equ map_background+map.x_scroll		; Background camera scroll X position
camera_bg_y_scroll 	equ map_background+map.y_scroll		; Background camera scroll Y position
camera_bg_x_speed 	equ map_background+map.x_speed		; Background camera X scroll speed
camera_bg_y_speed	equ map_background+map.y_speed		; Background camera Y scroll speed
camera_bg_x_shake	equ map_background+map.x_shake		; Background camera X shake offset
camera_bg_y_shake	equ map_background+map.y_shake		; Background camera Y shake offset
camera_bg_x_draw	equ map_background+map.x_draw		; Background camera X draw offset
camera_bg_y_draw	equ map_background+map.y_draw		; Background camera Y draw offset
map_bg_bound_left	equ map_background+map.bound_left	; Background camera left boundary
map_bg_bound_right	equ map_background+map.bound_right	; Background camera right boundary
map_bg_bound_top	equ map_background+map.bound_top	; Background camera top boundary
map_bg_bound_bottom	equ map_background+map.bound_bottom	; Background camera bottom boundary
map_bg_target_left	equ map_background+map.target_left	; Background camera target left boundary
map_bg_target_right	equ map_background+map.target_right	; Background camera target right boundary
map_bg_target_top	equ map_background+map.target_top	; Background camera target top boundary
map_bg_target_bottom	equ map_background+map.target_bottom	; Background camera target bottom boundary
map_bg_flags		equ map_background+map.flags		; Background layer flags
map_bg_data		equ map_background+map.data		; Background layer map data

cam_focus_object	rs.w 1					; Camera focus object
cam_focus_left		rs.w 1					; Camera focus left
cam_focus_right		rs.w 1					; Camera focus right
cam_focus_top		rs.w 1					; Camera focus top
cam_focus_bottom	rs.w 1					; Camera focus bottom

map_chunks		rs.l 1					; Map chunk data address
map_blocks		rs.l 1					; Map block data address
map_collision_1		rs.l 1					; Map collision block IDs address (layer 1)
map_collision_2		rs.l 1					; Map collision block IDs address (layer 2)
map_collision_heights	rs.l 1					; Map collision block heights address
map_collision_widths	rs.l 1					; Map collision block widths address
map_collision_angles	rs.l 1					; Map collision block angles address
map_objects		rs.l 1					; Map object data address
map_object_index	rs.l 1					; Map object index address
map_initialize		rs.l 1					; Map initialization routine
map_events		rs.l 1					; Map events routine
map_scroll		rs.l 1					; Map scroll routine
map_user_data		rs.l 1					; Map user data address

map_chunk_stride	rs.w 1					; Chunk data stride
map_chunk_x_mask	rs.w 1					; Map chunk data X mask
map_chunk_y_mask	rs.w 1					; Map chunk data Y mask
map_pos_shift		rs.b 1					; Position to map row shift
map_chunk_id_shift	rs.b 1					; Chunk ID to offset shift
map_chunk_y_shift	rs.b 1					; Chunk Y offset shift

map_collision_bit	rs.b 1					; Map collision test bit
map_collision_layer	rs.l 1					; Map collision layer block IDs

map_obj_chunk_x		rs.w 1					; Map object chunk X
map_obj_chunk_y		rs.w 1					; Map object chunk Y

map_obj_states		rs.w OBJ_STATE_SLOTS			; Map object states

mars_draw_buffer	rs.b $400				; 32X draw command buffer
mars_draw_slot		rs.w 1					; 32X draw command buffer slot
mars_gfx_buffer		rs.b $400				; 32X graphics data command buffer
mars_gfx_slot		rs.w 1					; 32X graphics data command buffer slot

mars_sprite_chain	rs.w ($100*3)+2				; 32X sprite chain buffer

framework_variables_end	rs.b 0					; End of framework variables

variables		rs.b	0				; Game variables
	include	"src/variables.inc"
			rs.b __rs&1
variables_end		rs.b 0

scene_variables		rs.b 0					; Start of scene variables
			rs.b (WORK_RAM_END-$200)-__rs
scene_variables_end	rs.b 0					; End of scene variables

			rs.b $200				; Stack space
stack			rs.b 0					; Stack base

; ------------------------------------------------------------------------------
