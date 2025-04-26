; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; 32X functions header
; ------------------------------------------------------------------------------

	global InitMarsGraphics
	global InitMarsGraphics2
	global WaitMars
	global SendMarsGraphicsCmds
	global SendMarsData
	global WaitMarsDraw
	global WaitMarsGraphicsData
	global ClearMarsScreen
	global DrawMarsSprite
	global DrawLoadedMarsSprite
	global DrawMarsLine
	global DrawMarsShape2d
	global DrawMarsShape3d
	global DrawDistortedMarsSprite
	global DrawDistortedLoadedMarsSprite
	global DrawMarsSpriteChain
	global DrawLoadedMarsSpriteChain
	global LoadMarsSprites
	global LoadMarsSpriteList
	global UnloadMarsSprites
	global LoadMarsPalette
	global LoadMarsPaletteList
	global SetMarsColor
	global FillMarsPalette
	global UpdateMarsPaletteFade
	global LoadMarsRotoscopePalette
	global ConvMdColorToMars
	global ConvMarsColorToMd

; ------------------------------------------------------------------------------
; 32X sprite list start
; ------------------------------------------------------------------------------

_mars_spr_list_count: = 0

MARS_SPR_LIST_START macro
	_mars_spr_count: = 0
	dc.w	(_mars_spr_count_\#_mars_spr_list_count\)-1
	endm

; ------------------------------------------------------------------------------
; 32X sprite list entry
; ------------------------------------------------------------------------------
; PARAMETERS
;	sprites - Set of sprites to load
;	id      - Sprite set ID
;	cram    - CRAM index
; ------------------------------------------------------------------------------

MARS_SPR_LIST_ENTRY macro art, id, cram
	dc.l	\art
	dc.b	\id, \cram
	_mars_spr_count: = _mars_spr_count+1
	endm

; ------------------------------------------------------------------------------
; 32X sprite list end
; ------------------------------------------------------------------------------

MARS_SPR_LIST_END macro
	_mars_spr_count_\#_mars_spr_list_count\: equ _mars_spr_count
	_mars_spr_list_count: = _mars_spr_list_count+1
	endm

; ------------------------------------------------------------------------------
; 32X palette list start
; ------------------------------------------------------------------------------

_mars_pal_list_count: = 0

MARS_PAL_LIST_START macro
	_mars_pal_count: = 0
	dc.w	(_mars_pal_count_\#_mars_pal_list_count\)-1
	endm

; ------------------------------------------------------------------------------
; 32X palette list entry
; ------------------------------------------------------------------------------
; PARAMETERS
;	palette  - Palette to load
;	cram     - CRAM index
;	priority - Swap priority
; ------------------------------------------------------------------------------

MARS_PAL_LIST_ENTRY macro palette, cram, priority
	dc.l	\palette
	dc.b	\cram, \priority
	_mars_pal_count: = _mars_pal_count+1
	endm

; ------------------------------------------------------------------------------
; 32X palette list end
; ------------------------------------------------------------------------------

MARS_PAL_LIST_END macro
	_mars_pal_count_\#_mars_pal_list_count\: equ _mars_pal_count
	_mars_pal_list_count: = _mars_pal_list_count+1
	endm

; ------------------------------------------------------------------------------
