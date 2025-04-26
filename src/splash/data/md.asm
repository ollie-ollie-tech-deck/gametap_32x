; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Splash screen scene Mega Drive data
; ------------------------------------------------------------------------------

	section m68k_rom_fixed_data
	include	"src/splash/data/md.inc"

; ------------------------------------------------------------------------------
; Art
; ------------------------------------------------------------------------------

Art_SplashGameTapText:
	incbin	"src/splash/data/md/gametap_text_art.kos"
	even
Art_SplashClownancyText:
	incbin	"src/splash/data/md/clownancy_text_art.kos"
	even
Art_SplashOllieText:
	incbin	"src/splash/data/md/ollie_text_art.kos"
	even

; ------------------------------------------------------------------------------
; Tilemaps
; ------------------------------------------------------------------------------

Map_SplashGameTapText:
	incbin	"src/splash/data/md/gametap_text_map.eni"
	even
Map_SplashClownancyText:
	incbin	"src/splash/data/md/clownancy_text_map.eni"
	even
Map_SplashOllieText:
	incbin	"src/splash/data/md/ollie_text_map.eni"
	even

; ------------------------------------------------------------------------------
; Palettes
; ------------------------------------------------------------------------------

Pal_SplashText:
	incbin	"src/splash/data/md/palette.pal"
	even

; ------------------------------------------------------------------------------
