; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Title screen scene report
; ------------------------------------------------------------------------------

	section report
	include	"source/title/shared.inc"
	include	"source/framework/report.inc"

; ------------------------------------------------------------------------------

	inform 0,"Title screen scene"
	CHECK_STRUCT "Scene variables", SCENE_VARS_LENGTH, scene_variables_end-scene_variables
	inform 0,""

; ------------------------------------------------------------------------------
