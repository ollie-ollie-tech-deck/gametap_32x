; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG stage scene report
; ------------------------------------------------------------------------------

	section report
	include	"source/rpg/shared.inc"
	include	"source/framework/report.inc"

; ------------------------------------------------------------------------------

	inform 0,"RPG stage scene"
	CHECK_STRUCT "Scene variables", SCENE_VARS_LENGTH, scene_variables_end-scene_variables
	CHECK_STRUCT "Decor variables", decor.struct_len, obj.struct_len
	CHECK_STRUCT "NPC variables", npc.struct_len, obj.struct_len
	CHECK_STRUCT "Player variables", player.struct_len, obj.struct_len
	CHECK_STRUCT "Store item variables", store.struct_len, obj.struct_len
	CHECK_STRUCT "Tool variables", tool.struct_len, obj.struct_len
	CHECK_STRUCT "Za Warudo variables", za_warudo.struct_len, obj.struct_len
	inform 0,""

; ------------------------------------------------------------------------------
