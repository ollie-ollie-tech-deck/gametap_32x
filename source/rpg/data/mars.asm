; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG scene 32X data
; ------------------------------------------------------------------------------

	include	"source/rpg/data/mars.inc"

; ------------------------------------------------------------------------------	
; Sprites (section 1)
; ------------------------------------------------------------------------------
	
	section sh2_data_1
MarsSpr_RpgPlayer:
	incbin	"source/rpg/data/mars/player_sprites.spr"
	cnop	0,4
MarsSpr_RpgOverlay:
	incbin	"source/rpg/data/mars/overlay_sprites.spr"
	cnop	0,4
MarsSpr_RpgTextboxIcons:
	incbin	"source/rpg/data/mars/textbox_icon_sprites.spr"
	cnop	0,4
MarsSpr_OllieHouse:
	incbin	"source/rpg/data/mars/ollie_house_sprites.spr"
	cnop	0,4
MarsSpr_StoreItems:
	incbin	"source/rpg/data/mars/store_item_sprites.spr"
	cnop	0,4
MarsSpr_PhotoCutscene:
	incbin	"source/rpg/data/mars/photo_cutscene_sprites.spr"
	cnop	0,4
MarsSpr_Tools:
	incbin	"source/rpg/data/mars/tool_sprites.spr"
	cnop	0,4
MarsSpr_Hospital:
	incbin	"source/rpg/data/mars/hospital_sprites.spr"
	cnop	0,4
MarsSpr_SuspectChoose:
	incbin	"source/rpg/data/mars/suspect_choose_sprites.spr"
	cnop	0,4
MarsSpr_AoOni:
	incbin	"source/rpg/data/mars/ao_oni_sprites.spr"
	cnop	0,4
MarsSpr_SilentHill:
	incbin	"source/rpg/data/mars/silent_hill_sprites.spr"
	cnop	0,4
MarsSpr_CultFrontDoor:
	incbin	"source/rpg/data/mars/cult_front_door_sprites.spr"
	cnop	0,4
MarsSpr_Prison:
	incbin	"source/rpg/data/mars/prison_sprites.spr"
	cnop	0,4

; ------------------------------------------------------------------------------
; Palettes (section 1)
; ------------------------------------------------------------------------------

MarsPal_SuspectChoose:
	incbin	"source/rpg/data/mars/suspect_choose_palette.pal"
	cnop	0,4
MarsPal_SilentHill:
	incbin	"source/rpg/data/mars/silent_hill_palette.pal"
	cnop	0,4
MarsPal_CultFrontDoor:
	incbin	"source/rpg/data/mars/cult_front_door_palette.pal"
	cnop	0,4
MarsPal_GoodEnding:
	incbin	"source/rpg/data/mars/good_ending_palette.pal"
	cnop	0,4
MarsPal_RpgScaryMaze:
	incbin	"source/rpg/data/mars/scary_maze_palette.pal"
	cnop	0,4

; ------------------------------------------------------------------------------	
; Sprites (section 2)
; ------------------------------------------------------------------------------
	
	section sh2_data_2
MarsSpr_SonicCult:
	incbin	"source/rpg/data/mars/sonic_cult_sprites.spr"
	cnop	0,4
MarsSpr_SonicCultScreens:
	incbin	"source/rpg/data/mars/sonic_cult_screen_sprites.spr"
	cnop	0,4
MarsSpr_PaddedCell:
	incbin	"source/rpg/data/mars/padded_cell_sprites.spr"
	cnop	0,4
MarsSpr_GoodEnding:
	incbin	"source/rpg/data/mars/good_ending_sprites.spr"
	cnop	0,4
MarsSpr_RpgScaryMaze:
	incbin	"source/rpg/data/mars/scary_maze_sprites.spr"
	cnop	0,4
MarsSpr_Burglar:
	incbin	"source/rpg/data/mars/burglar_sprites.spr"
	cnop	0,4
MarsSpr_Doctor:
	incbin	"source/rpg/data/mars/doctor_sprites.spr"
	cnop	0,4
MarsSpr_Cop:
	incbin	"source/rpg/data/mars/cop_sprites.spr"
	cnop	0,4
MarsSpr_Cultist:
	incbin	"source/rpg/data/mars/cultist_sprites.spr"
	cnop	0,4
MarsSpr_Warden:
	incbin	"source/rpg/data/mars/warden_sprites.spr"
	cnop	0,4

; ------------------------------------------------------------------------------
