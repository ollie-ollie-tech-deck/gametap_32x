; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Framework (Mega Drive) report
; ------------------------------------------------------------------------------

	section report
	include	"src/framework/md.inc"
	include	"src/framework/report.inc"

; ------------------------------------------------------------------------------

	inform 0,"Framework (Mega Drive)"
	PRINT_STRUCT "Framework variables", framework_variables_end-framework_variables
	PRINT_STRUCT "Game variables", variables_end-variables
	PRINT_STRUCT "Scene variables", scene_variables_end-scene_variables
	inform 0,""

; ------------------------------------------------------------------------------
