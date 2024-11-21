; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Framework (32X) report
; ------------------------------------------------------------------------------

	section report
	include	"source/framework/mars.inc"
	include	"source/framework/report.inc"

; ------------------------------------------------------------------------------

	inform 0,"Framework (32X)"
	CHECK_STRUCT "Variables", MARS_VARS_LENGTH, (MASTER_STACK-$400)-variables
	inform 0,""

; ------------------------------------------------------------------------------
