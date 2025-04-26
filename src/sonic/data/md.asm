; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sonic scene Mega Drive data
; ------------------------------------------------------------------------------

	section m68k_rom_fixed_data
	include	"src/sonic/data/md.inc"

; ------------------------------------------------------------------------------
; Art
; ------------------------------------------------------------------------------

Art_YugiohCard:
	incbin	"src/sonic/data/md/yugioh_art.kosm"
	even
Art_CollapseLedge:
	incbin	"src/sonic/data/md/collapse_ledge_art.kosm"
	even
Art_Wall:
	incbin	"src/sonic/data/md/wall_art.kosm"
	even
Art_GhzSunflower:
	incbin	"src/sonic/data/md/ghz_sunflower_art.bin"
	even
Art_GhzFlower:
	incbin	"src/sonic/data/md/ghz_flower_art.bin"
	even
Art_GhzWaterfall:
	incbin	"src/sonic/data/md/ghz_waterfall_art.bin"
	even
Art_GhzFlowerStalk:
	incbin	"src/sonic/data/md/ghz_flower_stalk_art.kosm"
	even
Art_SlendermanBg:
	incbin	"src/sonic/data/md/slenderman_bg_trunk_art.bin"
	even
	
; ------------------------------------------------------------------------------
; Sprites
; ------------------------------------------------------------------------------

Spr_CollapseLedge:
	include	"src/sonic/data/md/collapse_ledge_sprites.asm"
	even
Spr_Wall:
	include	"src/sonic/data/md/wall_sprites.asm"
	even

; ------------------------------------------------------------------------------
