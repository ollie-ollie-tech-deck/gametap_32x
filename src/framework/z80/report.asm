; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Z80 program report
; ------------------------------------------------------------------------------

	section report
	include	"src/framework/z80.inc"
	include	"src/framework/z80/constants.inc"
	include	"src/framework/z80/variables.inc"
	include	"src/framework/report.inc"

; ------------------------------------------------------------------------------

	inform 0,"Z80 sound driver"
	CHECK_STRUCT "Driver variables", Z80_VARS_LENGTH, Z80_END-Z80_VARIABLES
	inform 0,""

; ------------------------------------------------------------------------------
