; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Credits scene report
; ------------------------------------------------------------------------------

	section report
	include	"source/credits/shared.inc"
	include	"source/framework/report.inc"

; ------------------------------------------------------------------------------

	inform 0,"Credits scene"
	CHECK_STRUCT "Scene variables", SCENE_VARS_LENGTH, scene_variables_end-scene_variables
	inform 0,""

; ------------------------------------------------------------------------------
