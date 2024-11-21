; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Map functions header
; ------------------------------------------------------------------------------

	global LoadMapData
	global SetMapChunkSize
	global FlushMapBlocks
	global DrawMapFg
	global DrawMap
	global DrawMapBg
	global RefreshMap
	global RefreshMapFg
	global RefreshMapBg
	global GetMapBlockDistDown
	global GetMapBlockDistUp
	global GetMapBlockDistRight
	global GetMapBlockDistLeft
	global InitMapObjectSpawn
	global SpawnMapObjects
	global MapInitEvent
	global MapDrawEvent
	global ScrollMap

; ------------------------------------------------------------------------------
; Constants
; ------------------------------------------------------------------------------

OBJ_STATE_SLOTS		equ $200				; Number of object state slots

; ------------------------------------------------------------------------------
; Map chunk size configurations
; ------------------------------------------------------------------------------

	rsreset
CHUNK_SIZE_32		rs.b 1					; 32x32
CHUNK_SIZE_64		rs.b 1					; 64x64
CHUNK_SIZE_128		rs.b 1					; 128x128
CHUNK_SIZE_256		rs.b 1					; 256x256

; ------------------------------------------------------------------------------
; Map layer structure
; ------------------------------------------------------------------------------

	rsreset
map.x_current		rs.l 1					; Current X position
map.y_current		rs.l 1					; Current Y position
map.x_block		rs.w 1					; X block position
map.y_block		rs.w 1					; Y block position
map.x_previous		rs.w 1					; Previous X position
map.y_previous		rs.w 1					; Previous Y position
map.x_scroll		rs.w 1					; Scroll X position
map.y_scroll		rs.w 1					; Scroll Y position
map.x_speed		rs.w 1					; Scroll X speed
map.y_speed		rs.w 1					; Scroll Y speed
map.x_shake		rs.w 1					; X shake offset
map.y_shake		rs.w 1					; Y shake offset
map.x_draw		rs.l 1					; X draw offset
map.y_draw		rs.l 1					; Y draw offset
map.bound_left		rs.w 1					; Left boundary
map.bound_right		rs.w 1					; Right boundary
map.bound_top		rs.w 1					; Top boundary
map.bound_bottom	rs.w 1					; Bottom boundary
map.target_left		rs.w 1					; Target left boundary
map.target_right	rs.w 1					; Target right boundary
map.target_top		rs.w 1					; Target top boundary
map.target_bottom	rs.w 1					; Target bottom boundary
map.flags		rs.b 1					; Camera flags
			rs.b 1
map.vdp_command		rs.w 1					; VDP command (high)
map.row_1		rs.w (512/8)+3				; Row buffer 1
map.row_2		rs.w (512/8)				; Row buffer 2
map.column_1		rs.w (256/8)+3				; Column buffer 1
map.column_2		rs.w (256/8)				; Column buffer 2
map.data		rs.l 1					; Map data
map.struct_len		rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; Define map data
; ------------------------------------------------------------------------------
; PARAMETERS:
;	art           - Art
;	art_list      - Art list
;	mars_spr_list - 32X sprite list
;	palette       - Palette
;	mars_pal_list - 32X palette list
;	mars_pal_cram - 32X palette CRAM index
;	blocks        - Blocks
;	chunks        - Chunks
;	map_fg        - Foreground map
;	map_bg        - Background map
;	collision_1   - Collision data (layer 1)
;	collision_2   - Collision data (layer 2)
;	heights       - Collision heights
;	widths        - Collision widths
;	angles        - Collision angles
;	objects       - Object layout
;	initialize    - Initialization routine
;	events        - Events routine
;	scroll        - Scroll routine
; ------------------------------------------------------------------------------

MAP_DATA macro art, art_list, mars_spr_list, palette, mars_pal_list, blocks, chunks, &
               map_fg, map_bg, collision_1, collision_2, heights, widths, angles, objects, &
               fg_left, fg_right, fg_top, fg_bottom, bg_left, bg_right, bg_top, bg_bottom, &
               initialize, events, scroll
	dc.l	\art, \art_list, \mars_spr_list
	dc.l	\palette, \mars_pal_list
	dc.l	\blocks, \chunks, \map_fg, \map_bg
	dc.l	\collision_1, \collision_2
	dc.l	\heights, \widths, \angles
	dc.l	\objects
	dc.w	\fg_left, \fg_right, \fg_top, \fg_bottom
	dc.w	\bg_left, \bg_right, \bg_top, \bg_bottom
	dc.l	\initialize, \events, \scroll
	endm

; ------------------------------------------------------------------------------
