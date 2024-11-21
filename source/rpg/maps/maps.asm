; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG scene map data
; ------------------------------------------------------------------------------

	section m68k_rom_bank_3
	include	"source/rpg/shared.inc"

; ------------------------------------------------------------------------------
; Common data
; ------------------------------------------------------------------------------

MapBackground:
	incbin	"source/rpg/maps/background.bin"
	even
CollisionHeights:	
	incbin	"source/rpg/maps/collision_heights.bin"
	even
CollisionWidths:	
	incbin	"source/rpg/maps/collision_widths.bin"
	even
CollisionAngles:	
	incbin	"source/rpg/maps/collision_angles.bin"
	even

; ------------------------------------------------------------------------------
; Map metadata index
; ------------------------------------------------------------------------------

RpgMapData:
	dc.l	.OllieBedroom					; Ollie's bedroom
	dc.l	.OllieBathroom					; Ollie's bathroom
	dc.l	.OllieLivingRoom				; Ollie's living room
	dc.l	.OllieDiningRoom				; Ollie's dining room
	dc.l	.OllieOutside					; Outside of Ollie's house
	dc.l	.OllieGarage					; Ollie's garage
	dc.l	.7ElevenStreet					; 7-Eleven street
	dc.l	.7ElevenStore					; 7-Eleven store
	dc.l	.HospitalRoom					; Hospital room
	dc.l	.HospitalHallway				; Hospital hallway
	dc.l	.HospitalOutside				; Outside of hospital
	dc.l	.Prison						; Prison
	dc.l	.ScaryMaze1					; Scary Maze 1
	dc.l	.ScaryMaze2					; Scary Maze 2
	dc.l	.ScaryMaze3					; Scary Maze 3

; ------------------------------------------------------------------------------

.OllieBedroom:
	MAP_DATA &
		Art_OllieHouse,			&
		Pal_OllieHouse,			&
		ArtList_OllieHouse,		&
		MarsSprList_OllieHouse,		&
		MarsPalList_OllieHouse,		&
		Blocks_OllieHouse,		&
		Chunks_OllieHouse,		&
		MapFg_OllieBedroom,		&
		MapBackground,			&
		Collision_OllieHouse,		&
		Collision_OllieHouse,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_OllieBedroom,		&
		0, $300, 0, $300,		&
		0, $200, 0, $100,		&
		Init_OllieBedroom,		&
		Draw_OllieBedroom,		&
		Scroll_OllieBedroom

	incbin	"source/rpg/maps/ollie_house/bedroom_entry_1.bin"
	incbin	"source/rpg/maps/ollie_house/bedroom_entry_2.bin"
	incbin	"source/rpg/maps/ollie_house/bedroom_entry_3.bin"
	incbin	"source/rpg/maps/ollie_house/bedroom_entry_4.bin"
	incbin	"source/rpg/maps/ollie_house/bedroom_entry_5.bin"

; ------------------------------------------------------------------------------

.OllieBathroom:
	MAP_DATA &
		Art_OllieHouse,			&
		Pal_OllieHouse,			&
		ArtList_OllieHouse,		&
		MarsSprList_OllieHouse,		&
		MarsPalList_OllieHouse,		&
		Blocks_OllieHouse,		&
		Chunks_OllieHouse,		&
		MapFg_OllieBathroom,		&
		MapBackground,			&
		Collision_OllieHouse,		&
		Collision_OllieHouse,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_OllieBathroom,		&
		0, $300, 0, $300,		&
		0, $200, 0, $100,		&
		Init_OllieBathroom,		&
		Draw_OllieBathroom,		&
		Scroll_OllieBathroom
	
	incbin	"source/rpg/maps/ollie_house/bathroom_entry_1.bin"

; ------------------------------------------------------------------------------

.OllieLivingRoom:
	MAP_DATA &
		Art_OllieHouse,			&
		Pal_OllieHouse,			&
		ArtList_OllieHouse,		&
		MarsSprList_OllieHouse,		&
		MarsPalList_OllieHouse,		&
		Blocks_OllieHouse,		&
		Chunks_OllieHouse,		&
		MapFg_OllieLivingRoom,		&
		MapBackground,			&
		Collision_OllieHouse,		&
		Collision_OllieHouse,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_OllieLivingRoom,	&
		0, $300, 0, $300,		&
		0, $200, 0, $100,		&
		Init_OllieLivingRoom,		&
		Draw_OllieLivingRoom,		&
		Scroll_OllieLivingRoom
	
	incbin	"source/rpg/maps/ollie_house/living_room_entry_1.bin"
	incbin	"source/rpg/maps/ollie_house/living_room_entry_2.bin"
	incbin	"source/rpg/maps/ollie_house/living_room_entry_3.bin"
	incbin	"source/rpg/maps/ollie_house/living_room_entry_4.bin"

; ------------------------------------------------------------------------------

.OllieDiningRoom:
	MAP_DATA &
		Art_OllieHouse,			&
		Pal_OllieHouse,			&
		ArtList_OllieHouse,		&
		MarsSprList_OllieHouse,		&
		MarsPalList_OllieHouse,		&
		Blocks_OllieHouse,		&
		Chunks_OllieHouse,		&
		MapFg_OllieDiningRoom,		&
		MapBackground,			&
		Collision_OllieHouse,		&
		Collision_OllieHouse,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_OllieDiningRoom,	&
		0, $300, 0, $300,		&
		0, $200, 0, $100,		&
		Init_OllieDiningRoom,		&
		Draw_OllieDiningRoom,		&
		Scroll_OllieDiningRoom
	
	incbin	"source/rpg/maps/ollie_house/dining_room_entry_1.bin"
	incbin	"source/rpg/maps/ollie_house/dining_room_entry_2.bin"
	incbin	"source/rpg/maps/ollie_house/dining_room_entry_3.bin"

; ------------------------------------------------------------------------------

.OllieOutside:
	MAP_DATA &
		Art_OllieHouse,			&
		Pal_OllieHouse,			&
		ArtList_OllieHouse,		&
		MarsSprList_OllieHouse,		&
		MarsPalList_OllieHouse,		&
		Blocks_OllieHouse,		&
		Chunks_OllieHouse,		&
		MapFg_OllieOutside,		&
		MapBackground,			&
		Collision_OllieHouse,		&
		Collision_OllieHouse,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_OllieOutside,		&
		0, $380, 0, $2A0,		&
		0, $200, 0, $100,		&
		Init_OllieOutside,		&
		Draw_OllieOutside,		&
		Scroll_OllieOutside
	
	incbin	"source/rpg/maps/ollie_house/outside_entry_1.bin"
	incbin	"source/rpg/maps/ollie_house/outside_entry_2.bin"

; ------------------------------------------------------------------------------

.OllieGarage:
	MAP_DATA &
		Art_OllieHouse,			&
		Pal_OllieHouse,			&
		ArtList_OllieHouse,		&
		MarsSprList_OllieHouse,		&
		MarsPalList_OllieHouse,		&
		Blocks_OllieHouse,		&
		Chunks_OllieHouse,		&
		MapFg_OllieGarage,		&
		MapBackground,			&
		Collision_OllieHouse,		&
		Collision_OllieHouse,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_OllieGarage,		&
		0, $300, 0, $300,		&
		0, $200, 0, $100,		&
		Init_OllieGarage,		&
		Draw_OllieGarage,		&
		Scroll_OllieGarage
	
	incbin	"source/rpg/maps/ollie_house/garage_entry_1.bin"
	incbin	"source/rpg/maps/ollie_house/garage_entry_2.bin"

; ------------------------------------------------------------------------------

.7ElevenStreet:
	MAP_DATA &
		Art_OllieHouse,			&
		Pal_OllieHouse,			&
		ArtList_OllieHouse,		&
		MarsSprList_OllieHouse,		&
		MarsPalList_OllieHouse,		&
		Blocks_OllieHouse,		&
		Chunks_OllieHouse,		&
		MapFg_7ElevenStreet,		&
		MapBackground,			&
		Collision_OllieHouse,		&
		Collision_OllieHouse,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_7ElevenStreet,		&
		0, $2E0, 0, $2A0,		&
		0, $200, 0, $100,		&
		Init_7ElevenStreet,		&
		Draw_7ElevenStreet,		&
		Scroll_7ElevenStreet

	incbin	"source/rpg/maps/ollie_house/street_entry_1.bin"

; ------------------------------------------------------------------------------

.7ElevenStore:
	MAP_DATA &
		Art_OllieHouse,			&
		Pal_OllieHouse,			&
		ArtList_OllieHouse,		&
		MarsSprList_OllieHouse,		&
		MarsPalList_OllieHouse,		&
		Blocks_OllieHouse,		&
		Chunks_OllieHouse,		&
		MapFg_7ElevenStore,		&
		MapBackground,			&
		Collision_OllieHouse,		&
		Collision_OllieHouse,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_7ElevenStore,		&
		0, $300, 0, $300,		&
		0, $200, 0, $100,		&
		Init_7ElevenStore,		&
		Draw_7ElevenStore,		&
		Scroll_7ElevenStore
	
	incbin	"source/rpg/maps/ollie_house/store_entry_1.bin"

; ------------------------------------------------------------------------------

.HospitalRoom:
	MAP_DATA &
		Art_Hospital,			&
		Pal_HospitalRoom,		&
		ArtList_Hospital,		&
		MarsSprList_Hospital,		&
		MarsPalList_Hospital,		&
		Blocks_Hospital,		&
		Chunks_Hospital,		&
		MapFg_HospitalRoom,		&
		MapBackground,			&
		Collision_Hospital,		&
		Collision_Hospital,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_HospitalRoom,		&
		0, $300, 0, $300,		&
		0, $200, 0, $100,		&
		Init_HospitalRoom,		&
		Draw_HospitalRoom,		&
		Scroll_HospitalRoom
	
	incbin	"source/rpg/maps/hospital/room_entry_1.bin"

; ------------------------------------------------------------------------------

.HospitalHallway:
	MAP_DATA &
		Art_Hospital,			&
		Pal_HospitalHallway,		&
		ArtList_Hospital,		&
		MarsSprList_Hospital,		&
		MarsPalList_Hospital,		&
		Blocks_Hospital,		&
		Chunks_Hospital,		&
		MapFg_HospitalHallway,		&
		MapBackground,			&
		Collision_Hospital,		&
		Collision_Hospital,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_HospitalHallway,	&
		0, $A80, 0, $9C0,		&
		0, $200, 0, $100,		&
		Init_HospitalHallway,		&
		Draw_HospitalHallway,		&
		Scroll_HospitalHallway
	
	incbin	"source/rpg/maps/hospital/hallway_entry_1.bin"

; ------------------------------------------------------------------------------

.HospitalOutside:
	MAP_DATA &
		Art_Hospital,			&
		Pal_HospitalOutside,		&
		ArtList_Hospital,		&
		MarsSprList_Hospital,		&
		MarsPalList_Hospital,		&
		Blocks_Hospital,		&
		Chunks_Hospital,		&
		MapFg_HospitalOutside,		&
		MapBackground,			&
		Collision_Hospital,		&
		Collision_Hospital,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_HospitalOutside,	&
		0, $300, 0, $300,		&
		0, $200, 0, $100,		&
		Init_HospitalOutside,		&
		Draw_HospitalOutside,		&
		Scroll_HospitalOutside
	
	incbin	"source/rpg/maps/hospital/outside_entry_1.bin"

; ------------------------------------------------------------------------------

.Prison:
	MAP_DATA &
		Art_Prison,			&
		Pal_Prison,			&
		ArtList_Prison,			&
		MarsSprList_Prison,		&
		MarsPalList_Prison,		&
		Blocks_Prison,			&
		Chunks_Prison,			&
		MapFg_Prison,			&
		MapBackground,			&
		Collision_Prison,		&
		Collision_Prison,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_Prison,			&
		0, $300, 0, $300,		&
		0, $200, 0, $100,		&
		Init_Prison,			&
		Draw_Prison,			&
		Scroll_Prison
	
	incbin	"source/rpg/maps/prison/entry_1.bin"

; ------------------------------------------------------------------------------

.ScaryMaze1:
	MAP_DATA &
		Art_ScaryMaze,			&
		Pal_ScaryMaze,			&
		ArtList_ScaryMaze,		&
		MarsSprList_ScaryMaze,		&
		MarsPalList_ScaryMaze,		&
		Blocks_ScaryMaze,		&
		Chunks_ScaryMaze,		&
		MapFg_ScaryMaze1,		&
		MapBackground,			&
		Collision_ScaryMaze,		&
		Collision_ScaryMaze,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_ScaryMaze1,		&
		0, $140, 0, $0E0,		&
		0, $200, 0, $100,		&
		Init_RpgScaryMaze,		&
		Draw_RpgScaryMaze,		&
		Scroll_RpgScaryMaze
	
	incbin	"source/rpg/maps/scary_maze/entry_1.bin"

; ------------------------------------------------------------------------------

.ScaryMaze2:
	MAP_DATA &
		Art_ScaryMaze,			&
		Pal_ScaryMaze,			&
		ArtList_ScaryMaze,		&
		MarsSprList_ScaryMaze,		&
		MarsPalList_ScaryMaze,		&
		Blocks_ScaryMaze,		&
		Chunks_ScaryMaze,		&
		MapFg_ScaryMaze2,		&
		MapBackground,			&
		Collision_ScaryMaze,		&
		Collision_ScaryMaze,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_ScaryMaze2,		&
		0, $140, 0, $0E0,		&
		0, $200, 0, $100,		&
		Init_RpgScaryMaze,		&
		Draw_RpgScaryMaze,		&
		Scroll_RpgScaryMaze
	
	incbin	"source/rpg/maps/scary_maze/entry_2.bin"

; ------------------------------------------------------------------------------

.ScaryMaze3:
	MAP_DATA &
		Art_ScaryMaze,			&
		Pal_ScaryMaze,			&
		ArtList_ScaryMaze,		&
		MarsSprList_ScaryMaze,		&
		MarsPalList_ScaryMaze,		&
		Blocks_ScaryMaze,		&
		Chunks_ScaryMaze,		&
		MapFg_ScaryMaze3,		&
		MapBackground,			&
		Collision_ScaryMaze,		&
		Collision_ScaryMaze,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_ScaryMaze3,		&
		0, $140, 0, $0E0,		&
		0, $200, 0, $100,		&
		Init_RpgScaryMaze,		&
		Draw_RpgScaryMaze,		&
		Scroll_RpgScaryMaze
	
	incbin	"source/rpg/maps/scary_maze/entry_3.bin"

; ------------------------------------------------------------------------------
; Ollie's house map data lists
; ------------------------------------------------------------------------------

ArtList_OllieHouse:
	KOSM_LIST_START
	KOSM_LIST_END

MarsSprList_OllieHouse:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_RpgOverlay, 1, 1
	MARS_SPR_LIST_ENTRY MarsSpr_OllieHouse, 2, 2
	MARS_SPR_LIST_ENTRY MarsSpr_StoreItems, 3, 2
	MARS_SPR_LIST_ENTRY MarsSpr_Tools, 4, 2
	MARS_SPR_LIST_END

MarsPalList_OllieHouse:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Hospital map data lists
; ------------------------------------------------------------------------------

ArtList_Hospital:
	KOSM_LIST_START
	KOSM_LIST_END

MarsSprList_Hospital:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_RpgOverlay, 1, 1
	MARS_SPR_LIST_ENTRY MarsSpr_Hospital, 2, 2
	MARS_SPR_LIST_ENTRY MarsSpr_AoOni, 3, 2
	MARS_SPR_LIST_END

MarsPalList_Hospital:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Prison map data lists
; ------------------------------------------------------------------------------

ArtList_Prison:
	KOSM_LIST_START
	KOSM_LIST_END

MarsSprList_Prison:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_RpgOverlay, 1, 1
	MARS_SPR_LIST_ENTRY MarsSpr_Prison, 2, 2
	MARS_SPR_LIST_END

MarsPalList_Prison:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Scary Maze map data lists
; ------------------------------------------------------------------------------

ArtList_ScaryMaze:
	KOSM_LIST_START
	KOSM_LIST_END

MarsSprList_ScaryMaze:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_RpgScaryMaze, 1, $80
	MARS_SPR_LIST_END

MarsPalList_ScaryMaze:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_RpgScaryMaze, $80, 0
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Ollie's house map data
; ------------------------------------------------------------------------------

Art_OllieHouse:
	incbin	"source/rpg/maps/ollie_house/art.kosm"
	even
Pal_OllieHouse:
	incbin	"source/rpg/maps/ollie_house/palette.bin"
	even
Blocks_OllieHouse:
	incbin	"source/rpg/maps/ollie_house/blocks.bin"
	even
Chunks_OllieHouse:
	incbin	"source/rpg/maps/ollie_house/chunks.bin"
	even
Collision_OllieHouse:
	incbin	"source/rpg/maps/ollie_house/collision.bin"
	even
MapFg_OllieBedroom:
	incbin	"source/rpg/maps/ollie_house/bedroom_map.bin"
	even
MapFg_OllieBathroom:
	incbin	"source/rpg/maps/ollie_house/bathroom_map.bin"
	even
MapFg_OllieLivingRoom:
	incbin	"source/rpg/maps/ollie_house/living_room_map.bin"
	even
MapFg_OllieDiningRoom:
	incbin	"source/rpg/maps/ollie_house/dining_room_map.bin"
	even
MapFg_OllieOutside:
	incbin	"source/rpg/maps/ollie_house/outside_map.bin"
	even
MapFg_OllieGarage:
	incbin	"source/rpg/maps/ollie_house/garage_map.bin"
	even
MapFg_7ElevenStreet:
	incbin	"source/rpg/maps/ollie_house/street_map.bin"
	even
MapFg_7ElevenStore:
	incbin	"source/rpg/maps/ollie_house/store_map.bin"
	even
Objects_OllieBedroom:
	incbin	"source/rpg/maps/ollie_house/bedroom_objects.bin"
	even
Objects_OllieBathroom:
	incbin	"source/rpg/maps/ollie_house/bathroom_objects.bin"
	even
Objects_OllieLivingRoom:
	incbin	"source/rpg/maps/ollie_house/living_room_objects.bin"
	even
Objects_OllieDiningRoom:
	incbin	"source/rpg/maps/ollie_house/dining_room_objects.bin"
	even
Objects_OllieOutside:
	incbin	"source/rpg/maps/ollie_house/outside_objects.bin"
	even
Objects_OllieGarage:
	incbin	"source/rpg/maps/ollie_house/garage_objects.bin"
	even
Objects_7ElevenStreet:
	incbin	"source/rpg/maps/ollie_house/street_objects.bin"
	even
Objects_7ElevenStore:
	incbin	"source/rpg/maps/ollie_house/store_objects.bin"
	even

; ------------------------------------------------------------------------------
; Hospital map data
; ------------------------------------------------------------------------------

Art_Hospital:
	incbin	"source/rpg/maps/hospital/art.kosm"
	even
Pal_HospitalRoom:
	incbin	"source/rpg/maps/hospital/room_palette.bin"
	even
Pal_HospitalHallway:
	incbin	"source/rpg/maps/hospital/hallway_palette.bin"
	even
Pal_HospitalOutside:
	incbin	"source/rpg/maps/hospital/outside_palette.bin"
	even
Blocks_Hospital:
	incbin	"source/rpg/maps/hospital/blocks.bin"
	even
Chunks_Hospital:
	incbin	"source/rpg/maps/hospital/chunks.bin"
	even
Collision_Hospital:
	incbin	"source/rpg/maps/hospital/collision.bin"
	even
MapFg_HospitalRoom:
	incbin	"source/rpg/maps/hospital/room_map.bin"
	even
MapFg_HospitalHallway:
	incbin	"source/rpg/maps/hospital/hallway_map.bin"
	even
MapFg_HospitalOutside:
	incbin	"source/rpg/maps/hospital/outside_map.bin"
	even
Objects_HospitalRoom:
	incbin	"source/rpg/maps/hospital/room_objects.bin"
	even
Objects_HospitalHallway:
	incbin	"source/rpg/maps/hospital/hallway_objects.bin"
	even
Objects_HospitalOutside:
	incbin	"source/rpg/maps/hospital/outside_objects.bin"
	even

; ------------------------------------------------------------------------------
; Prison map data
; ------------------------------------------------------------------------------

Art_Prison:
	incbin	"source/rpg/maps/prison/art.kosm"
	even
Pal_Prison:
	incbin	"source/rpg/maps/prison/palette.bin"
	even
Blocks_Prison:
	incbin	"source/rpg/maps/prison/blocks.bin"
	even
Chunks_Prison:
	incbin	"source/rpg/maps/prison/chunks.bin"
	even
Collision_Prison:
	incbin	"source/rpg/maps/prison/collision.bin"
	even
MapFg_Prison:
	incbin	"source/rpg/maps/prison/map.bin"
	even
Objects_Prison:
	incbin	"source/rpg/maps/prison/objects.bin"
	even

; ------------------------------------------------------------------------------
; Scary Maze map data
; ------------------------------------------------------------------------------

Art_ScaryMaze:
	incbin	"source/rpg/maps/scary_maze/art.kosm"
	even
Pal_ScaryMaze:
	incbin	"source/rpg/maps/scary_maze/palette.bin"
	even
Blocks_ScaryMaze:
	incbin	"source/rpg/maps/scary_maze/blocks.bin"
	even
Chunks_ScaryMaze:
	incbin	"source/rpg/maps/scary_maze/chunks.bin"
	even
Collision_ScaryMaze:
	incbin	"source/rpg/maps/scary_maze/collision.bin"
	even
MapFg_ScaryMaze1:
	incbin	"source/rpg/maps/scary_maze/map_1.bin"
	even
MapFg_ScaryMaze2:
	incbin	"source/rpg/maps/scary_maze/map_2.bin"
	even
MapFg_ScaryMaze3:
	incbin	"source/rpg/maps/scary_maze/map_3.bin"
	even
Objects_ScaryMaze1:
	incbin	"source/rpg/maps/scary_maze/objects_1.bin"
	even
Objects_ScaryMaze2:
	incbin	"source/rpg/maps/scary_maze/objects_2.bin"
	even
Objects_ScaryMaze3:
	incbin	"source/rpg/maps/scary_maze/objects_3.bin"
	even

; ------------------------------------------------------------------------------
