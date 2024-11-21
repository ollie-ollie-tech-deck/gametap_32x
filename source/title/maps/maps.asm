; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Title screen scene map data
; ------------------------------------------------------------------------------

	section m68k_rom_bank_3
	include	"source/title/shared.inc"
	
; ------------------------------------------------------------------------------
; Map metadata index
; ------------------------------------------------------------------------------

TitleMapData:
	dc.l	.Title

; ------------------------------------------------------------------------------
; Title map metadata
; ------------------------------------------------------------------------------

.Title:
	MAP_DATA &
		Art_Title,			&
		Pal_Title,			&
		0,				&
		0,				&
		0,				&
		Blocks_Title,			&
		Chunks_Title,			&
		0,				&
		MapBg_Title,			&
		0,				&
		0,				&
		0,				&
		0,				&
		0,				&
		0,				&
		0, $200, 0, $100,		&
		0, $200, 0, $100,		&
		0,				&
		0,				&
		0

; ------------------------------------------------------------------------------
; Title map data
; ------------------------------------------------------------------------------

Art_Title:
	incbin	"source/title/maps/title/art.kosm"
	even
Pal_Title:
	incbin	"source/title/maps/title/palette.bin"
	even
Blocks_Title:
	incbin	"source/title/maps/title/blocks.bin"
	even
Chunks_Title:
	incbin	"source/title/maps/title/chunks.bin"
	even
MapBg_Title:
	incbin	"source/title/maps/title/map_bg.bin"
	even

; ------------------------------------------------------------------------------
