; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Credits scene 32X data
; ------------------------------------------------------------------------------

	section sh2_data_2
	include	"source/credits/data/mars.inc"

; ------------------------------------------------------------------------------	
; Sprites
; ------------------------------------------------------------------------------
	
MarsSpr_Credits:
	incbin	"source/credits/data/mars/credits_sprites.spr"
	cnop 0,4

; ------------------------------------------------------------------------------
