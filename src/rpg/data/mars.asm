; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG scene 32X data
; ------------------------------------------------------------------------------

	include	"src/rpg/data/mars.inc"

; ------------------------------------------------------------------------------	
; Sprites (section 1)
; ------------------------------------------------------------------------------
	
	section sh2_data_1
MarsSpr_RpgPlayer:
	incbin	"src/rpg/data/mars/player_sprites.spr"
	cnop	0,4
MarsSpr_RpgOverlay:
	incbin	"src/rpg/data/mars/overlay_sprites.spr"
	cnop	0,4
MarsSpr_RpgTextboxIcons:
	incbin	"src/rpg/data/mars/textbox_icon_sprites.spr"
	cnop	0,4
MarsSpr_OllieHouse:
	incbin	"src/rpg/data/mars/ollie_house_sprites.spr"
	cnop	0,4
MarsSpr_StoreItems:
	incbin	"src/rpg/data/mars/store_item_sprites.spr"
	cnop	0,4
MarsSpr_PhotoCutscene:
	incbin	"src/rpg/data/mars/photo_cutscene_sprites.spr"
	cnop	0,4
MarsSpr_Tools:
	incbin	"src/rpg/data/mars/tool_sprites.spr"
	cnop	0,4
MarsSpr_Hospital:
	incbin	"src/rpg/data/mars/hospital_sprites.spr"
	cnop	0,4
MarsSpr_SuspectChoose:
	incbin	"src/rpg/data/mars/suspect_choose_sprites.spr"
	cnop	0,4
MarsSpr_AoOni:
	incbin	"src/rpg/data/mars/ao_oni_sprites.spr"
	cnop	0,4
MarsSpr_SilentHill:
	incbin	"src/rpg/data/mars/silent_hill_sprites.spr"
	cnop	0,4
MarsSpr_CultFrontDoor:
	incbin	"src/rpg/data/mars/cult_front_door_sprites.spr"
	cnop	0,4
MarsSpr_Prison:
	incbin	"src/rpg/data/mars/prison_sprites.spr"
	cnop	0,4

; ------------------------------------------------------------------------------
; Palettes (section 1)
; ------------------------------------------------------------------------------

MarsPal_SuspectChoose:
	incbin	"src/rpg/data/mars/suspect_choose_palette.pal"
	cnop	0,4
MarsPal_SilentHill:
	incbin	"src/rpg/data/mars/silent_hill_palette.pal"
	cnop	0,4
MarsPal_CultFrontDoor:
	incbin	"src/rpg/data/mars/cult_front_door_palette.pal"
	cnop	0,4
MarsPal_GoodEnding:
	incbin	"src/rpg/data/mars/good_ending_palette.pal"
	cnop	0,4
MarsPal_RpgScaryMaze:
	incbin	"src/rpg/data/mars/scary_maze_palette.pal"
	cnop	0,4

; ------------------------------------------------------------------------------	
; Sprites (section 2)
; ------------------------------------------------------------------------------
	
	section sh2_data_2
MarsSpr_SonicCult:
	incbin	"src/rpg/data/mars/sonic_cult_sprites.spr"
	cnop	0,4
MarsSpr_SonicCultScreens:
	incbin	"src/rpg/data/mars/sonic_cult_screen_sprites.spr"
	cnop	0,4
MarsSpr_PaddedCell:
	incbin	"src/rpg/data/mars/padded_cell_sprites.spr"
	cnop	0,4
MarsSpr_GoodEnding:
	incbin	"src/rpg/data/mars/good_ending_sprites.spr"
	cnop	0,4
MarsSpr_RpgScaryMaze:
	incbin	"src/rpg/data/mars/scary_maze_sprites.spr"
	cnop	0,4
MarsSpr_Burglar:
	incbin	"src/rpg/data/mars/burglar_sprites.spr"
	cnop	0,4
MarsSpr_Doctor:
	incbin	"src/rpg/data/mars/doctor_sprites.spr"
	cnop	0,4
MarsSpr_Cop:
	incbin	"src/rpg/data/mars/cop_sprites.spr"
	cnop	0,4
MarsSpr_Cultist:
	incbin	"src/rpg/data/mars/cultist_sprites.spr"
	cnop	0,4
MarsSpr_Warden:
	incbin	"src/rpg/data/mars/warden_sprites.spr"
	cnop	0,4

; ------------------------------------------------------------------------------
