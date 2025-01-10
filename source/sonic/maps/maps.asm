; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sonic scene map data
; ------------------------------------------------------------------------------

	section m68k_rom_bank_3
	include	"source/sonic/shared.inc"
	
; ------------------------------------------------------------------------------
; Common data
; ------------------------------------------------------------------------------

CollisionHeights:	
	incbin	"source/sonic/maps/collision_heights.bin"
	even
CollisionWidths:	
	incbin	"source/sonic/maps/collision_widths.bin"
	even
CollisionAngles:	
	incbin	"source/sonic/maps/collision_angles.bin"
	even

; ------------------------------------------------------------------------------
; Map metadata index
; ------------------------------------------------------------------------------

SonicMapData:
	dc.l	.RingGirl
	dc.l	.RingGirlBoss
	dc.l	.BenDrowned
	dc.l	.BenDrownedBoss
	dc.l	.Slenderman
	dc.l	.SlendermanBoss
	dc.l	.Hellscape
	dc.l	.HellscapeBoss
	dc.l	.ScaryMaze
	dc.l	.FinalNormal
	dc.l	.FinalPrison
	dc.l	.FinalComputer

; ------------------------------------------------------------------------------
; Ring Girl stage map metadata
; ------------------------------------------------------------------------------

.RingGirl:
	MAP_DATA &
		Art_RingGirl,			&
		Pal_RingGirl,			&
		ArtList_RingGirl,		&
		MarsSprList_RingGirl,		&
		MarsPalList_RingGirl,		&
		Blocks_RingGirl,		&
		Chunks_RingGirl,		&
		MapFg_RingGirl,			&
		MapBg_RingGirl,			&
		Collision1_RingGirl,		&
		Collision2_RingGirl,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_RingGirl,		&
		0, $1F00, 0, $3E0,		&
		0, $200, 0, $100,		&
		Init_RingGirl,			&
		Draw_RingGirl,			&
		Scroll_RingGirl
	
	incbin	"source/sonic/maps/1_ring_girl/entry.bin"
	dc.l	Cards_RingGirl
	dc.l	Song_Holiday

; ------------------------------------------------------------------------------
; Ring Girl boss stage map metadata
; ------------------------------------------------------------------------------

.RingGirlBoss:
	MAP_DATA &
		Art_RingGirlBoss,		&
		Pal_RingGirlBoss,		&
		ArtList_RingGirlBoss,		&
		MarsSprList_RingGirlBoss,	&
		MarsPalList_RingGirlBoss,	&
		Blocks_RingGirlBoss,		&
		Chunks_RingGirlBoss,		&
		MapFg_RingGirlBoss,		&
		MapBg_RingGirlBoss,		&
		Collision1_RingGirlBoss,	&
		Collision2_RingGirlBoss,	&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_RingGirlBoss,		&
		0, $140, 0, $E0,		&
		0, $200, 0, $100,		&
		Init_RingGirlBoss,		&
		Draw_RingGirlBoss,		&
		Scroll_RingGirlBoss
	
	incbin	"source/sonic/maps/1_ring_girl_boss/entry.bin"
	dc.l	Cards_RingGirlBoss
	dc.l	Song_Fantasmas

; ------------------------------------------------------------------------------
; Ben Drowned stage map metadata
; ------------------------------------------------------------------------------

.BenDrowned:
	MAP_DATA &
		Art_BenDrowned,			&
		Pal_BenDrowned,			&
		ArtList_BenDrowned,		&
		MarsSprList_BenDrowned,		&
		MarsPalList_BenDrowned,		&
		Blocks_BenDrowned,		&
		Chunks_BenDrowned,		&
		MapFg_BenDrowned,		&
		MapBg_BenDrowned,		&
		Collision1_BenDrowned,		&
		Collision2_BenDrowned,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_BenDrowned,		&
		0, $2600, 0, $3E0,		&
		0, $200, 0, $100,		&
		Init_BenDrowned,		&
		Draw_BenDrowned,		&
		Scroll_BenDrowned

	incbin	"source/sonic/maps/2_ben_drowned/entry.bin"
	dc.l	Cards_BenDrowned
	dc.l	Song_Ghz

; ------------------------------------------------------------------------------
; Ben Drowned boss stage map metadata
; ------------------------------------------------------------------------------

.BenDrownedBoss:
	MAP_DATA &
		Art_BenDrownedBoss,		&
		Pal_BenDrownedBoss,		&
		ArtList_BenDrownedBoss,		&
		MarsSprList_BenDrownedBoss,	&
		MarsPalList_BenDrownedBoss,	&
		Blocks_BenDrownedBoss,		&
		Chunks_BenDrownedBoss,		&
		MapFg_BenDrownedBoss,		&
		MapBg_BenDrownedBoss,		&
		Collision1_BenDrownedBoss,	&
		Collision2_BenDrownedBoss,	&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_BenDrownedBoss,		&
		0, $140, 0, $E0,		&
		0, $200, 0, $100,		&
		Init_BenDrownedBoss,		&
		Draw_BenDrownedBoss,		&
		Scroll_BenDrownedBoss

	incbin	"source/sonic/maps/2_ben_drowned_boss/entry.bin"
	dc.l	Cards_BenDrownedBoss
	dc.l	Song_KissMe

; ------------------------------------------------------------------------------
; Slenderman stage map metadata
; ------------------------------------------------------------------------------

.Slenderman:
	MAP_DATA &
		Art_Slenderman,			&
		Pal_Slenderman,			&
		ArtList_Slenderman,		&
		MarsSprList_Slenderman,		&
		MarsPalList_Slenderman,		&
		Blocks_Slenderman,		&
		Chunks_Slenderman,		&
		MapFg_Slenderman,		&
		MapBg_Slenderman,		&
		Collision1_Slenderman,		&
		Collision2_Slenderman,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_Slenderman,		&
		0, $2600, 0, $3E0,		&
		0, $200, 0, $100,		&
		Init_Slenderman,		&
		Draw_Slenderman,		&
		Scroll_Slenderman
	
	incbin	"source/sonic/maps/3_slenderman/entry.bin"
	dc.l	Cards_Slenderman
	dc.l	Song_GhzGems

; ------------------------------------------------------------------------------
; Slenderman boss stage map metadata
; ------------------------------------------------------------------------------

.SlendermanBoss:
	MAP_DATA &
		Art_SlendermanBoss,		&
		Pal_SlendermanBoss,		&
		ArtList_SlendermanBoss,		&
		MarsSprList_SlendermanBoss,	&
		MarsPalList_SlendermanBoss,	&
		Blocks_SlendermanBoss,		&
		Chunks_SlendermanBoss,		&
		MapFg_SlendermanBoss,		&
		MapBg_SlendermanBoss,		&
		Collision1_SlendermanBoss,	&
		Collision2_SlendermanBoss,	&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_SlendermanBoss,		&
		0, $140, 0, $E0,		&
		0, $200, 0, $100,		&
		Init_SlendermanBoss,		&
		Draw_SlendermanBoss,		&
		Scroll_SlendermanBoss
	
	incbin	"source/sonic/maps/3_slenderman_boss/entry.bin"
	dc.l	Cards_SlendermanBoss
	dc.l	Song_Blue

; ------------------------------------------------------------------------------
; Hellscape stage map metadata
; ------------------------------------------------------------------------------

.Hellscape:
	MAP_DATA &
		Art_Hellscape,			&
		Pal_Hellscape,			&
		ArtList_Hellscape,		&
		MarsSprList_Hellscape,		&
		MarsPalList_Hellscape,		&
		Blocks_Hellscape,		&
		Chunks_Hellscape,		&
		MapFg_Hellscape,		&
		MapBg_Hellscape,		&
		Collision1_Hellscape,		&
		Collision2_Hellscape,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_Hellscape,		&
		0, $2600, 0, $3E0,		&
		0, $200, 0, $100,		&
		Init_Hellscape,			&
		Draw_Hellscape,			&
		Scroll_Hellscape

	incbin	"source/sonic/maps/4_hellscape/entry.bin"
	dc.l	Cards_Hellscape
	dc.l	Song_GhzSlayer

; ------------------------------------------------------------------------------
; Hellscape boss stage map metadata
; ------------------------------------------------------------------------------

.HellscapeBoss:
	MAP_DATA &
		Art_HellscapeBoss,		&
		Pal_HellscapeBoss,		&
		ArtList_HellscapeBoss,		&
		MarsSprList_HellscapeBoss,	&
		MarsPalList_HellscapeBoss,	&
		Blocks_HellscapeBoss,		&
		Chunks_HellscapeBoss,		&
		MapFg_HellscapeBoss,		&
		MapBg_HellscapeBoss,		&
		Collision1_HellscapeBoss,	&
		Collision2_HellscapeBoss,	&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_HellscapeBoss,		&
		0, $140, 0, $E0,		&
		0, $200, 0, $100,		&
		Init_HellscapeBoss,		&
		Draw_HellscapeBoss,		&
		Scroll_HellscapeBoss

	incbin	"source/sonic/maps/4_hellscape_boss/entry.bin"
	dc.l	Cards_HellscapeBoss
	dc.l	Song_MineEyes

; ------------------------------------------------------------------------------
; Scary Maze stage map metadata
; ------------------------------------------------------------------------------

.ScaryMaze:
	MAP_DATA &
		Art_ScaryMaze,			&
		Pal_ScaryMaze,			&
		ArtList_ScaryMaze,		&
		MarsSprList_ScaryMaze,		&
		MarsPalList_ScaryMaze,		&
		Blocks_ScaryMaze,		&
		Chunks_ScaryMaze,		&
		MapFg_ScaryMaze,		&
		MapBg_ScaryMaze,		&
		Collision1_ScaryMaze,		&
		Collision2_ScaryMaze,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_ScaryMaze,		&
		0, $2600, 0, $3E0,		&
		0, $200, 0, $100,		&
		Init_ScaryMaze,			&
		Draw_ScaryMaze,			&
		Scroll_ScaryMaze

	incbin	"source/sonic/maps/5_scary_maze/entry.bin"
	dc.l	Cards_ScaryMaze
	dc.l	Song_GhzGoodFuture

; ------------------------------------------------------------------------------
; Final (normal) stage map metadata
; ------------------------------------------------------------------------------

.FinalNormal:
	MAP_DATA &
		Art_FinalNormal,		&
		Pal_FinalNormal,		&
		ArtList_FinalNormal,		&
		MarsSprList_FinalNormal,	&
		MarsPalList_FinalNormal,	&
		Blocks_FinalNormal,		&
		Chunks_FinalNormal,		&
		MapFg_FinalNormal,		&
		MapBg_FinalNormal,		&
		Collision1_FinalNormal,		&
		Collision2_FinalNormal,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_FinalNormal,		&
		0, $2600, 0, $3E0,		&
		0, $200, 0, $100,		&
		Init_FinalNormal,		&
		Draw_FinalNormal,		&
		Scroll_FinalNormal

	incbin	"source/sonic/maps/6_1_normal/entry.bin"
	dc.l	Cards_FinalNormal
	dc.l	Song_Ghz

; ------------------------------------------------------------------------------
; Final (prison) stage map metadata
; ------------------------------------------------------------------------------

.FinalPrison:
	MAP_DATA &
		Art_FinalPrison,		&
		Pal_FinalPrison,		&
		ArtList_FinalPrison,		&
		MarsSprList_FinalPrison,	&
		MarsPalList_FinalPrison,	&
		Blocks_FinalPrison,		&
		Chunks_FinalPrison,		&
		MapFg_FinalPrison,		&
		MapBg_FinalPrison,		&
		Collision1_FinalPrison,		&
		Collision2_FinalPrison,		&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_FinalPrison,		&
		0, $2600, 0, $3E0,		&
		0, $200, 0, $100,		&
		Init_FinalPrison,		&
		Draw_FinalPrison,		&
		Scroll_FinalPrison

	incbin	"source/sonic/maps/6_2_prison/entry.bin"
	dc.l	Cards_FinalPrison
	dc.l	Song_GhzSin

; ------------------------------------------------------------------------------
; Final (computer) stage map metadata
; ------------------------------------------------------------------------------

.FinalComputer:
	MAP_DATA &
		Art_FinalComputer,		&
		Pal_FinalComputer,		&
		ArtList_FinalComputer,		&
		MarsSprList_FinalComputer,	&
		MarsPalList_FinalComputer,	&
		Blocks_FinalComputer,		&
		Chunks_FinalComputer,		&
		MapFg_FinalComputer,		&
		MapBg_FinalComputer,		&
		Collision1_FinalComputer,	&
		Collision2_FinalComputer,	&
		CollisionHeights,		&
		CollisionWidths,		&
		CollisionAngles,		&
		Objects_FinalComputer,		&
		0, $2700, 0, $3E0,		&
		0, $200, 0, $100,		&
		Init_FinalComputer,		&
		Draw_FinalComputer,		&
		Scroll_FinalComputer

	incbin	"source/sonic/maps/6_3_computer/entry.bin"
	dc.l	Cards_FinalComputer
	dc.l	Song_GhzTelefon

; ------------------------------------------------------------------------------
; Ring Girl data lists
; ------------------------------------------------------------------------------

ArtList_RingGirl:
	KOSM_LIST_START
	KOSM_LIST_ENTRY Art_GhzFlowerStalk, $6B00
	KOSM_LIST_ENTRY Art_YugiohCard, $8000
	KOSM_LIST_ENTRY Art_CollapseLedge, $85C0
	KOSM_LIST_ENTRY Art_Wall, $9380
	KOSM_LIST_END

MarsSprList_RingGirl:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_SonicOverlay, 0, 1
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMonitor, 1, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicPlatform, 2, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicRock, 3, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBridge, 4, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpikes, 5, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpring, 6, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMotobug, 7, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBuzzBomber, 8, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicCrabmeat, 9, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicChopper, $A, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicNewtron, $B, 2
	MARS_SPR_LIST_ENTRY MarsSpr_Blockbuster, $C, 2
	MARS_SPR_LIST_END

MarsPalList_RingGirl:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_RingGirl, $80, 0
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Ring Girl boss data lists
; ------------------------------------------------------------------------------

ArtList_RingGirlBoss:
	KOSM_LIST_START
	KOSM_LIST_END

MarsSprList_RingGirlBoss:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_RingGirlBoss, 0, 2
	MARS_SPR_LIST_ENTRY MarsSpr_RingGirlBossBg, 1, $80
	MARS_SPR_LIST_END

MarsPalList_RingGirlBoss:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_RingGirlBoss, $80, 0
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Ben Drowned data lists
; ------------------------------------------------------------------------------

ArtList_BenDrowned:
	KOSM_LIST_START
	KOSM_LIST_ENTRY Art_YugiohCard, $8000
	KOSM_LIST_ENTRY Art_CollapseLedge, $85C0
	KOSM_LIST_ENTRY Art_Wall, $9380
	KOSM_LIST_END

MarsSprList_BenDrowned:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_SonicOverlay, 0, 1
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMonitor, 1, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicPlatformAlt, 2, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicRock, 3, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBridgeBen, 4, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpikes, 5, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpring, 6, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMotobug, 7, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBuzzBomber, 8, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicCrabmeat, 9, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicChopper, $A, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicNewtron, $B, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBen, $C, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicEyeball, $D, 2
	MARS_SPR_LIST_ENTRY MarsSpr_BenBackground, $E, $C0
	MARS_SPR_LIST_END

MarsPalList_BenDrowned:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_BenDrowned, $80, 0
	
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Ben Drowned boss data lists
; ------------------------------------------------------------------------------

ArtList_BenDrownedBoss:
	KOSM_LIST_START
	KOSM_LIST_END

MarsSprList_BenDrownedBoss:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_BenBossSprites, 0, 1
	MARS_SPR_LIST_ENTRY MarsSpr_BenBackground, $E, $C0
	MARS_SPR_LIST_END

MarsPalList_BenDrownedBoss:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_BenDrownedBoss, $80, 0
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Slenderman data lists
; ------------------------------------------------------------------------------

ArtList_Slenderman:
	KOSM_LIST_START
	KOSM_LIST_ENTRY Art_YugiohCard, $8000
	KOSM_LIST_ENTRY Art_CollapseLedge, $85C0
	KOSM_LIST_ENTRY Art_Wall, $9380
	KOSM_LIST_END

MarsSprList_Slenderman:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_SonicOverlay, 0, 1
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMonitor, 1, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicPlatform, 2, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicRock, 3, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBridge, 4, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpikes, 5, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpring, 6, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMotobug, 7, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBuzzBomber, 8, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicCrabmeat, 9, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicChopper, $A, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicNewtron, $B, 2
	MARS_SPR_LIST_END

MarsPalList_Slenderman:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_Slenderman, $80, 0
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Slenderman boss data lists
; ------------------------------------------------------------------------------

ArtList_SlendermanBoss:
	KOSM_LIST_START
	KOSM_LIST_END

MarsSprList_SlendermanBoss:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_SlendermanBoss, 0, $80
	MARS_SPR_LIST_END

MarsPalList_SlendermanBoss:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_SlendermanBoss, $80, 1
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Hellscape data lists
; ------------------------------------------------------------------------------

ArtList_Hellscape:
	KOSM_LIST_START
	KOSM_LIST_ENTRY Art_YugiohCard, $8000
	KOSM_LIST_ENTRY Art_CollapseLedge, $85C0
	KOSM_LIST_ENTRY Art_Wall, $9380
	KOSM_LIST_END

MarsSprList_Hellscape:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_SonicOverlay, 0, 1
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMonitor, 1, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicPlatformAlt, 2, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicRock, 3, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBridgeAlt, 4, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpikes, 5, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpring, 6, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMotobug, 7, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBuzzBomber, 8, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicCrabmeat, 9, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicChopper, $A, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicNewtron, $B, 2
	MARS_SPR_LIST_END

MarsPalList_Hellscape:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_Hellscape, $80, 0
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Hellscape boss data lists
; ------------------------------------------------------------------------------

ArtList_HellscapeBoss:
	KOSM_LIST_START
	KOSM_LIST_END

MarsSprList_HellscapeBoss:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_ToadBoss, 0, 2
	MARS_SPR_LIST_END

MarsPalList_HellscapeBoss:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_HellscapeBoss, $80, 0
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Scary Maze data lists
; ------------------------------------------------------------------------------

ArtList_ScaryMaze:
	KOSM_LIST_START
	KOSM_LIST_ENTRY Art_YugiohCard, $8000
	KOSM_LIST_ENTRY Art_CollapseLedge, $85C0
	KOSM_LIST_ENTRY Art_Wall, $9380
	KOSM_LIST_END

MarsSprList_ScaryMaze:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_SonicOverlay, 0, 1
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMonitor, 1, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicPlatform, 2, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicRock, 3, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBridge, 4, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpikes, 5, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpring, 6, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMotobug, 7, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBuzzBomber, 8, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicCrabmeat, 9, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicChopper, $A, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicNewtron, $B, 2
	MARS_SPR_LIST_END

MarsPalList_ScaryMaze:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_ScaryMaze, $80, 0
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Final (normal) data lists
; ------------------------------------------------------------------------------

ArtList_FinalNormal:
	KOSM_LIST_START
	KOSM_LIST_ENTRY Art_GhzFlowerStalk, $6B00
	KOSM_LIST_ENTRY Art_YugiohCard, $8000
	KOSM_LIST_ENTRY Art_CollapseLedge, $85C0
	KOSM_LIST_ENTRY Art_Wall, $9380
	KOSM_LIST_END

MarsSprList_FinalNormal:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_SonicOverlay, 0, 1
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMonitor, 1, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicPlatform, 2, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicRock, 3, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBridge, 4, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpikes, 5, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpring, 6, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMotobug, 7, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBuzzBomber, 8, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicCrabmeat, 9, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicChopper, $A, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicNewtron, $B, 2
	MARS_SPR_LIST_END

MarsPalList_FinalNormal:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_FinalNormal, $80, 0
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Final (prison) data lists
; ------------------------------------------------------------------------------

ArtList_FinalPrison:
	KOSM_LIST_START
	KOSM_LIST_ENTRY Art_YugiohCard, $8000
	KOSM_LIST_ENTRY Art_CollapseLedge, $85C0
	KOSM_LIST_ENTRY Art_Wall, $9380
	KOSM_LIST_END

MarsSprList_FinalPrison:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_SonicOverlay, 0, 1
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMonitor, 1, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicPlatformAlt, 2, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicRock, 3, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBridgeAlt, 4, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpikes, 5, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpring, 6, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMotobug, 7, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBuzzBomber, 8, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicCrabmeat, 9, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicChopper, $A, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicNewtron, $B, 2
	MARS_SPR_LIST_END

MarsPalList_FinalPrison:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_FinalPrison, $80, 0
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Final (computer) data lists
; ------------------------------------------------------------------------------

ArtList_FinalComputer:
	KOSM_LIST_START
	KOSM_LIST_ENTRY Art_YugiohCard, $8000
	KOSM_LIST_ENTRY Art_CollapseLedge, $85C0
	KOSM_LIST_ENTRY Art_Wall, $9380
	KOSM_LIST_END

MarsSprList_FinalComputer:
	MARS_SPR_LIST_START
	MARS_SPR_LIST_ENTRY MarsSpr_SonicOverlay, 0, 1
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMonitor, 1, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicPlatformComputer, 2, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicRock, 3, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBridgeAlt, 4, $80
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpikes, 5, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicSpring, 6, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicMotobug, 7, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicBuzzBomber, 8, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicCrabmeat, 9, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicChopper, $A, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicNewtron, $B, 2
	MARS_SPR_LIST_ENTRY MarsSpr_SonicButton, $C, 2
	MARS_SPR_LIST_ENTRY MarsSpr_OllieBoss, $D, $9C
	MARS_SPR_LIST_ENTRY MarsSpr_OllieHand, $E, 2
	MARS_SPR_LIST_END

MarsPalList_FinalComputer:
	MARS_PAL_LIST_START
	MARS_PAL_LIST_ENTRY MarsPal_FinalComputer, $80, 0
	MARS_PAL_LIST_ENTRY MarsPal_OllieBoss, $9C, 1
	MARS_PAL_LIST_END

; ------------------------------------------------------------------------------
; Ring Girl map data
; ------------------------------------------------------------------------------

Art_RingGirl:
	incbin	"source/sonic/maps/1_ring_girl/art.kosm"
	even
Pal_RingGirl:
	incbin	"source/sonic/maps/1_ring_girl/palette.bin"
	even
Blocks_RingGirl:
	incbin	"source/sonic/maps/1_ring_girl/blocks.bin"
	even
Chunks_RingGirl:
	incbin	"source/sonic/maps/1_ring_girl/chunks.bin"
	even
MapFg_RingGirl:
	incbin	"source/sonic/maps/1_ring_girl/map_fg.bin"
	even
MapBg_RingGirl:
	incbin	"source/sonic/maps/1_ring_girl/map_bg.bin"
	even
Collision1_RingGirl:
	incbin	"source/sonic/maps/1_ring_girl/collision_1.bin"
	even
Collision2_RingGirl:
	incbin	"source/sonic/maps/1_ring_girl/collision_2.bin"
	even
Objects_RingGirl:
	incbin	"source/sonic/maps/1_ring_girl/objects.bin"
	even
Cards_RingGirl:
	incbin	"source/sonic/maps/1_ring_girl/cards.bin"
	even

; ------------------------------------------------------------------------------
; Ring Girl boss map data
; ------------------------------------------------------------------------------

Art_RingGirlBoss:
	incbin	"source/sonic/maps/1_ring_girl_boss/art.kosm"
	even
Pal_RingGirlBoss:
	incbin	"source/sonic/maps/1_ring_girl_boss/palette.bin"
	even
Blocks_RingGirlBoss:
	incbin	"source/sonic/maps/1_ring_girl_boss/blocks.bin"
	even
Chunks_RingGirlBoss:
	incbin	"source/sonic/maps/1_ring_girl_boss/chunks.bin"
	even
MapFg_RingGirlBoss:
	incbin	"source/sonic/maps/1_ring_girl_boss/map_fg.bin"
	even
MapBg_RingGirlBoss:
	incbin	"source/sonic/maps/1_ring_girl_boss/map_bg.bin"
	even
Collision1_RingGirlBoss:
	incbin	"source/sonic/maps/1_ring_girl_boss/collision_1.bin"
	even
Collision2_RingGirlBoss:
	incbin	"source/sonic/maps/1_ring_girl_boss/collision_2.bin"
	even
Objects_RingGirlBoss:
	incbin	"source/sonic/maps/1_ring_girl_boss/objects.bin"
	even
Cards_RingGirlBoss:
	incbin	"source/sonic/maps/1_ring_girl_boss/cards.bin"
	even

; ------------------------------------------------------------------------------
; Ben Drowned map data
; ------------------------------------------------------------------------------

Art_BenDrowned:
	incbin	"source/sonic/maps/2_ben_drowned/art.kosm"
	even
Pal_BenDrowned:
	incbin	"source/sonic/maps/2_ben_drowned/palette.bin"
	even
Blocks_BenDrowned:
	incbin	"source/sonic/maps/2_ben_drowned/blocks.bin"
	even
Chunks_BenDrowned:
	incbin	"source/sonic/maps/2_ben_drowned/chunks.bin"
	even
MapFg_BenDrowned:
	incbin	"source/sonic/maps/2_ben_drowned/map_fg.bin"
	even
MapBg_BenDrowned:
	incbin	"source/sonic/maps/2_ben_drowned/map_bg.bin"
	even
Collision1_BenDrowned:
	incbin	"source/sonic/maps/2_ben_drowned/collision_1.bin"
	even
Collision2_BenDrowned:
	incbin	"source/sonic/maps/2_ben_drowned/collision_2.bin"
	even
Objects_BenDrowned:
	incbin	"source/sonic/maps/2_ben_drowned/objects.bin"
	even
Cards_BenDrowned:
	incbin	"source/sonic/maps/2_ben_drowned/cards.bin"
	even

; ------------------------------------------------------------------------------
; Ben Drowned boss map data
; ------------------------------------------------------------------------------

Art_BenDrownedBoss:
	incbin	"source/sonic/maps/2_ben_drowned_boss/art.kosm"
	even
Pal_BenDrownedBoss:
	incbin	"source/sonic/maps/2_ben_drowned_boss/palette.bin"
	even
Blocks_BenDrownedBoss:
	incbin	"source/sonic/maps/2_ben_drowned_boss/blocks.bin"
	even
Chunks_BenDrownedBoss:
	incbin	"source/sonic/maps/2_ben_drowned_boss/chunks.bin"
	even
MapFg_BenDrownedBoss:
	incbin	"source/sonic/maps/2_ben_drowned_boss/map_fg.bin"
	even
MapBg_BenDrownedBoss:
	incbin	"source/sonic/maps/2_ben_drowned_boss/map_bg.bin"
	even
Collision1_BenDrownedBoss:
	incbin	"source/sonic/maps/2_ben_drowned_boss/collision_1.bin"
	even
Collision2_BenDrownedBoss:
	incbin	"source/sonic/maps/2_ben_drowned_boss/collision_2.bin"
	even
Objects_BenDrownedBoss:
	incbin	"source/sonic/maps/2_ben_drowned_boss/objects.bin"
	even
Cards_BenDrownedBoss:
	incbin	"source/sonic/maps/2_ben_drowned_boss/cards.bin"
	even

; ------------------------------------------------------------------------------
; Slenderman map data
; ------------------------------------------------------------------------------

Art_Slenderman:
	incbin	"source/sonic/maps/3_slenderman/art.kosm"
	even
Pal_Slenderman:
	incbin	"source/sonic/maps/3_slenderman/palette.bin"
	even
Blocks_Slenderman:
	incbin	"source/sonic/maps/3_slenderman/blocks.bin"
	even
Chunks_Slenderman:
	incbin	"source/sonic/maps/3_slenderman/chunks.bin"
	even
MapFg_Slenderman:
	incbin	"source/sonic/maps/3_slenderman/map_fg.bin"
	even
MapBg_Slenderman:
	incbin	"source/sonic/maps/3_slenderman/map_bg.bin"
	even
Collision1_Slenderman:
	incbin	"source/sonic/maps/3_slenderman/collision_1.bin"
	even
Collision2_Slenderman:
	incbin	"source/sonic/maps/3_slenderman/collision_2.bin"
	even
Objects_Slenderman:
	incbin	"source/sonic/maps/3_slenderman/objects.bin"
	even
Cards_Slenderman:
	incbin	"source/sonic/maps/3_slenderman/cards.bin"
	even

; ------------------------------------------------------------------------------
; Slenderman boss map data
; ------------------------------------------------------------------------------

Art_SlendermanBoss:
	incbin	"source/sonic/maps/3_slenderman_boss/art.kosm"
	even
Pal_SlendermanBoss:
	incbin	"source/sonic/maps/3_slenderman_boss/palette.bin"
	even
Blocks_SlendermanBoss:
	incbin	"source/sonic/maps/3_slenderman_boss/blocks.bin"
	even
Chunks_SlendermanBoss:
	incbin	"source/sonic/maps/3_slenderman_boss/chunks.bin"
	even
MapFg_SlendermanBoss:
	incbin	"source/sonic/maps/3_slenderman_boss/map_fg.bin"
	even
MapBg_SlendermanBoss:
	incbin	"source/sonic/maps/3_slenderman_boss/map_bg.bin"
	even
Collision1_SlendermanBoss:
	incbin	"source/sonic/maps/3_slenderman_boss/collision_1.bin"
	even
Collision2_SlendermanBoss:
	incbin	"source/sonic/maps/3_slenderman_boss/collision_2.bin"
	even
Objects_SlendermanBoss:
	incbin	"source/sonic/maps/3_slenderman_boss/objects.bin"
	even
Cards_SlendermanBoss:
	incbin	"source/sonic/maps/3_slenderman_boss/cards.bin"
	even

; ------------------------------------------------------------------------------
; Hellscape map data
; ------------------------------------------------------------------------------

Art_Hellscape:
	incbin	"source/sonic/maps/4_hellscape/art.kosm"
	even
Pal_Hellscape:
	incbin	"source/sonic/maps/4_hellscape/palette.bin"
	even
Blocks_Hellscape:
	incbin	"source/sonic/maps/4_hellscape/blocks.bin"
	even
Chunks_Hellscape:
	incbin	"source/sonic/maps/4_hellscape/chunks.bin"
	even
MapFg_Hellscape:
	incbin	"source/sonic/maps/4_hellscape/map_fg.bin"
	even
MapBg_Hellscape:
	incbin	"source/sonic/maps/4_hellscape/map_bg.bin"
	even
Collision1_Hellscape:
	incbin	"source/sonic/maps/4_hellscape/collision_1.bin"
	even
Collision2_Hellscape:
	incbin	"source/sonic/maps/4_hellscape/collision_2.bin"
	even
Objects_Hellscape:
	incbin	"source/sonic/maps/4_hellscape/objects.bin"
	even
Cards_Hellscape:
	incbin	"source/sonic/maps/4_hellscape/cards.bin"
	even

; ------------------------------------------------------------------------------
; Hellscape boss map data
; ------------------------------------------------------------------------------

Art_HellscapeBoss:
	incbin	"source/sonic/maps/4_hellscape_boss/art.kosm"
	even
Pal_HellscapeBoss:
	incbin	"source/sonic/maps/4_hellscape_boss/palette.bin"
	even
Blocks_HellscapeBoss:
	incbin	"source/sonic/maps/4_hellscape_boss/blocks.bin"
	even
Chunks_HellscapeBoss:
	incbin	"source/sonic/maps/4_hellscape_boss/chunks.bin"
	even
MapFg_HellscapeBoss:
	incbin	"source/sonic/maps/4_hellscape_boss/map_fg.bin"
	even
MapBg_HellscapeBoss:
	incbin	"source/sonic/maps/4_hellscape_boss/map_bg.bin"
	even
Collision1_HellscapeBoss:
	incbin	"source/sonic/maps/4_hellscape_boss/collision_1.bin"
	even
Collision2_HellscapeBoss:
	incbin	"source/sonic/maps/4_hellscape_boss/collision_2.bin"
	even
Objects_HellscapeBoss:
	incbin	"source/sonic/maps/4_hellscape_boss/objects.bin"
	even
Cards_HellscapeBoss:
	incbin	"source/sonic/maps/4_hellscape_boss/cards.bin"
	even

; ------------------------------------------------------------------------------
; Scary Maze map data
; ------------------------------------------------------------------------------

Art_ScaryMaze:
	incbin	"source/sonic/maps/5_scary_maze/art.kosm"
	even
Pal_ScaryMaze:
	incbin	"source/sonic/maps/5_scary_maze/palette.bin"
	even
Blocks_ScaryMaze:
	incbin	"source/sonic/maps/5_scary_maze/blocks.bin"
	even
Chunks_ScaryMaze:
	incbin	"source/sonic/maps/5_scary_maze/chunks.bin"
	even
MapFg_ScaryMaze:
	incbin	"source/sonic/maps/5_scary_maze/map_fg.bin"
	even
MapBg_ScaryMaze:
	incbin	"source/sonic/maps/5_scary_maze/map_bg.bin"
	even
Collision1_ScaryMaze:
	incbin	"source/sonic/maps/5_scary_maze/collision_1.bin"
	even
Collision2_ScaryMaze:
	incbin	"source/sonic/maps/5_scary_maze/collision_2.bin"
	even
Objects_ScaryMaze:
	incbin	"source/sonic/maps/5_scary_maze/objects.bin"
	even
Cards_ScaryMaze:
	incbin	"source/sonic/maps/5_scary_maze/cards.bin"
	even

; ------------------------------------------------------------------------------
; Final (normal) map data
; ------------------------------------------------------------------------------

Art_FinalNormal:
	incbin	"source/sonic/maps/6_1_normal/art.kosm"
	even
Pal_FinalNormal:
	incbin	"source/sonic/maps/6_1_normal/palette.bin"
	even
Blocks_FinalNormal:
	incbin	"source/sonic/maps/6_1_normal/blocks.bin"
	even
Chunks_FinalNormal:
	incbin	"source/sonic/maps/6_1_normal/chunks.bin"
	even
MapFg_FinalNormal:
	incbin	"source/sonic/maps/6_1_normal/map_fg.bin"
	even
MapBg_FinalNormal:
	incbin	"source/sonic/maps/6_1_normal/map_bg.bin"
	even
Collision1_FinalNormal:
	incbin	"source/sonic/maps/6_1_normal/collision_1.bin"
	even
Collision2_FinalNormal:
	incbin	"source/sonic/maps/6_1_normal/collision_2.bin"
	even
Objects_FinalNormal:
	incbin	"source/sonic/maps/6_1_normal/objects.bin"
	even
Cards_FinalNormal:
	incbin	"source/sonic/maps/6_1_normal/cards.bin"
	even

; ------------------------------------------------------------------------------
; Final (prison) map data
; ------------------------------------------------------------------------------

Art_FinalPrison:
	incbin	"source/sonic/maps/6_2_prison/art.kosm"
	even
Pal_FinalPrison:
	incbin	"source/sonic/maps/6_2_prison/palette.bin"
	even
Blocks_FinalPrison:
	incbin	"source/sonic/maps/6_2_prison/blocks.bin"
	even
Chunks_FinalPrison:
	incbin	"source/sonic/maps/6_2_prison/chunks.bin"
	even
MapFg_FinalPrison:
	incbin	"source/sonic/maps/6_2_prison/map_fg.bin"
	even
MapBg_FinalPrison:
	incbin	"source/sonic/maps/6_2_prison/map_bg.bin"
	even
Collision1_FinalPrison:
	incbin	"source/sonic/maps/6_2_prison/collision_1.bin"
	even
Collision2_FinalPrison:
	incbin	"source/sonic/maps/6_2_prison/collision_2.bin"
	even
Objects_FinalPrison:
	incbin	"source/sonic/maps/6_2_prison/objects.bin"
	even
Cards_FinalPrison:
	incbin	"source/sonic/maps/6_2_prison/cards.bin"
	even

; ------------------------------------------------------------------------------
; Final (computer) map data
; ------------------------------------------------------------------------------

Art_FinalComputer:
	incbin	"source/sonic/maps/6_3_computer/art.kosm"
	even
Pal_FinalComputer:
	incbin	"source/sonic/maps/6_3_computer/palette.bin"
	even
Blocks_FinalComputer:
	incbin	"source/sonic/maps/6_3_computer/blocks.bin"
	even
Chunks_FinalComputer:
	incbin	"source/sonic/maps/6_3_computer/chunks.bin"
	even
MapFg_FinalComputer:
	incbin	"source/sonic/maps/6_3_computer/map_fg.bin"
	even
MapBg_FinalComputer:
	incbin	"source/sonic/maps/6_3_computer/map_bg.bin"
	even
Collision1_FinalComputer:
	incbin	"source/sonic/maps/6_3_computer/collision_1.bin"
	even
Collision2_FinalComputer:
	incbin	"source/sonic/maps/6_3_computer/collision_2.bin"
	even
Objects_FinalComputer:
	incbin	"source/sonic/maps/6_3_computer/objects.bin"
	even
Cards_FinalComputer:
	incbin	"source/sonic/maps/6_3_computer/cards.bin"
	even

; ------------------------------------------------------------------------------
