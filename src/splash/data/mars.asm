; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Splash screen scene 32X data
; ------------------------------------------------------------------------------

	section sh2_data_1
	include	"src/splash/data/mars.inc"

; ------------------------------------------------------------------------------	
; Sprites
; ------------------------------------------------------------------------------
	
MarsSpr_SplashBackground:
	incbin	"src/splash/data/mars/background_sprites.spr"
	cnop 0,4
MarsSpr_SplashGameTap:
	incbin	"src/splash/data/mars/gametap_sprites.spr"
	cnop 0,4
MarsSpr_SplashClownancy:
	incbin	"src/splash/data/mars/clownancy_sprites.spr"
	cnop 0,4
MarsSpr_SplashOllie:
	incbin	"src/splash/data/mars/ollie_sprites.spr"
	cnop 0,4
	
; ------------------------------------------------------------------------------
; Palettes
; ------------------------------------------------------------------------------

MarsPal_SplashBackground:
	incbin	"src/splash/data/mars/background_palette.pal"
	cnop 0,4
MarsPal_SplashGameTap:
	incbin	"src/splash/data/mars/gametap_palette.pal"
	cnop 0,4
MarsPal_SplashClownancy:
	incbin	"src/splash/data/mars/clownancy_palette.pal"
	cnop 0,4
MarsPal_SplashOllie:
	incbin	"src/splash/data/mars/ollie_palette.pal"
	cnop 0,4

; ------------------------------------------------------------------------------
