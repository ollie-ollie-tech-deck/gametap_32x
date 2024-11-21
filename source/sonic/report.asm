; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sonic stage scene report
; ------------------------------------------------------------------------------

	section report
	include	"source/sonic/shared.inc"
	include	"source/framework/report.inc"

; ------------------------------------------------------------------------------

	inform 0,"Sonic stage scene"
	CHECK_STRUCT "Scene variables", SCENE_VARS_LENGTH, scene_variables_end-scene_variables
	CHECK_STRUCT "Ben variables", ben.struct_len, obj.struct_len
	CHECK_STRUCT "Ben boss variables", ben_boss.struct_len, obj.struct_len
	CHECK_STRUCT "Ben boss vein variables", vein.struct_len, obj.struct_len
	CHECK_STRUCT "Ben portal variables", ben_portal.struct_len, obj.struct_len
	CHECK_STRUCT "Blockbuster variables", blockbuster.struct_len, obj.struct_len
	CHECK_STRUCT "Bridge variables", bridge.struct_len, obj.struct_len
	CHECK_STRUCT "Buzz Bomber variables", buzz_bomber.struct_len, obj.struct_len
	CHECK_STRUCT "Buzz Bomber missile variables", buzz_missile.struct_len, obj.struct_len
	CHECK_STRUCT "Chopper variables", chopper.struct_len, obj.struct_len
	CHECK_STRUCT "Collapsing ledge piece variables", ledge.struct_len, obj.struct_len
	CHECK_STRUCT "Crabmeat variables", crabmeat.struct_len, obj.struct_len
	CHECK_STRUCT "Explosion variables", explosion.struct_len, obj.struct_len
	CHECK_STRUCT "Eyeball variables", eyeball.struct_len, obj.struct_len
	CHECK_STRUCT "Monitor variables", monitor.struct_len, obj.struct_len
	CHECK_STRUCT "Monitor icon variables", monitor_icon.struct_len, obj.struct_len
	CHECK_STRUCT "Motobug variables", motobug.struct_len, obj.struct_len
	CHECK_STRUCT "Newtron variables", newtron.struct_len, obj.struct_len
	CHECK_STRUCT "Newtron missile variables", newt_missile.struct_len, obj.struct_len
	CHECK_STRUCT "Ollie boss variables", ollie_boss.struct_len, obj.struct_len
	CHECK_STRUCT "Path swapper variables", swapper.struct_len, obj.struct_len
	CHECK_STRUCT "Platform variables", platform.struct_len, obj.struct_len
	CHECK_STRUCT "Player variables", player.struct_len, obj.struct_len
	CHECK_STRUCT "Ring Girl boss variables", ring_girl.struct_len, obj.struct_len
	CHECK_STRUCT "Slenderman boss variables", slenderman.struct_len, obj.struct_len
	CHECK_STRUCT "Slenderman boss fist variables", slender_fist.struct_len, obj.struct_len
	inform 0,""

; ------------------------------------------------------------------------------
