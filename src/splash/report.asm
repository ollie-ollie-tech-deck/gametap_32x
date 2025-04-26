; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Splash screen scene report
; ------------------------------------------------------------------------------

	section report
	include	"src/splash/shared.inc"
	include	"src/framework/report.inc"

; ------------------------------------------------------------------------------

	inform 0,"Splash screen scene"
	CHECK_STRUCT "Scene variables", SCENE_VARS_LENGTH, scene_variables_end-scene_variables
	inform 0,""

; ------------------------------------------------------------------------------
