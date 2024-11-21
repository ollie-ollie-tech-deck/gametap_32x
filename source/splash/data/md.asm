; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Splash screen scene Mega Drive data
; ------------------------------------------------------------------------------

	section m68k_rom_fixed_data
	include	"source/splash/data/md.inc"

; ------------------------------------------------------------------------------
; Art
; ------------------------------------------------------------------------------

Art_SplashGameTapText:
	incbin	"source/splash/data/md/gametap_text_art.kos"
	even
Art_SplashClownancyText:
	incbin	"source/splash/data/md/clownancy_text_art.kos"
	even
Art_SplashOllieText:
	incbin	"source/splash/data/md/ollie_text_art.kos"
	even

; ------------------------------------------------------------------------------
; Tilemaps
; ------------------------------------------------------------------------------

Map_SplashGameTapText:
	incbin	"source/splash/data/md/gametap_text_map.eni"
	even
Map_SplashClownancyText:
	incbin	"source/splash/data/md/clownancy_text_map.eni"
	even
Map_SplashOllieText:
	incbin	"source/splash/data/md/ollie_text_map.eni"
	even

; ------------------------------------------------------------------------------
; Palettes
; ------------------------------------------------------------------------------

Pal_SplashText:
	incbin	"source/splash/data/md/palette.pal"
	even

; ------------------------------------------------------------------------------
