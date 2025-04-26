; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Title screen scene 32X data
; ------------------------------------------------------------------------------

	section sh2_data_1
	include	"src/title/data/mars.inc"

; ------------------------------------------------------------------------------	
; Sprites
; ------------------------------------------------------------------------------
	
MarsSpr_TitleLogos:
	incbin	"src/title/data/mars/logo_sprites.spr"
	cnop 0,4
MarsSpr_TitleBackground:
	incbin	"src/title/data/mars/background_sprites.spr"
	cnop 0,4
MarsSpr_TitleGlitchedLogos:
	incbin	"src/title/data/mars/glitched_logo_sprites.spr"
	cnop 0,4
	
; ------------------------------------------------------------------------------
; Palettes
; ------------------------------------------------------------------------------

MarsPal_TitleLogos:
	incbin	"src/title/data/mars/logo_palette.pal"
	cnop 0,4
	
; ------------------------------------------------------------------------------
