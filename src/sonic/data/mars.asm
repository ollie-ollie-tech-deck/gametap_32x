; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sonic scene 32X data
; ------------------------------------------------------------------------------

	section sh2_data_1
	include	"src/sonic/data/mars.inc"

; ------------------------------------------------------------------------------	
; Sprites (section 1)
; ------------------------------------------------------------------------------
	
MarsSpr_SonicPlayer:
	incbin	"src/sonic/data/mars/player_sprites.spr"
	cnop	0,4
MarsSpr_SonicHealth:
	incbin	"src/sonic/data/mars/health_sprites.spr"
	cnop	0,4
MarsSpr_SonicOverlay:
	incbin	"src/sonic/data/mars/overlay_sprites.spr"
	cnop	0,4
MarsSpr_SonicMonitor:
	incbin	"src/sonic/data/mars/monitor_sprites.spr"
	cnop	0,4
MarsSpr_SonicPlatform:
	incbin	"src/sonic/data/mars/platform_sprites.spr"
	cnop	0,4
MarsSpr_SonicPlatformAlt:
	incbin	"src/sonic/data/mars/platform_alt_sprites.spr"
	cnop	0,4
MarsSpr_SonicPlatformComputer:
	incbin	"src/sonic/data/mars/platform_computer_sprites.spr"
	cnop	0,4
MarsSpr_SonicRock:
	incbin	"src/sonic/data/mars/rock_sprites.spr"
	cnop	0,4
MarsSpr_SonicBridge:
	incbin	"src/sonic/data/mars/bridge_sprites.spr"
	cnop	0,4
MarsSpr_SonicBridgeAlt:
	incbin	"src/sonic/data/mars/bridge_alt_sprites.spr"
	cnop	0,4
MarsSpr_SonicBridgeBen:
	incbin	"src/sonic/data/mars/bridge_ben_sprites.spr"
	cnop	0,4
MarsSpr_SonicSpikes:
	incbin	"src/sonic/data/mars/spike_sprites.spr"
	cnop	0,4
MarsSpr_SonicSpring:
	incbin	"src/sonic/data/mars/spring_sprites.spr"
	cnop	0,4
MarsSpr_SonicExplosion:
	incbin	"src/sonic/data/mars/explosion_sprites.spr"
	cnop	0,4
MarsSpr_SonicMotobug:
	incbin	"src/sonic/data/mars/motobug_sprites.spr"
	cnop	0,4
MarsSpr_SonicBuzzBomber:
	incbin	"src/sonic/data/mars/buzz_bomber_sprites.spr"
	cnop	0,4
MarsSpr_SonicCrabmeat:
	incbin	"src/sonic/data/mars/crabmeat_sprites.spr"
	cnop	0,4
MarsSpr_SonicChopper:
	incbin	"src/sonic/data/mars/chopper_sprites.spr"
	cnop	0,4
MarsSpr_SonicNewtron:
	incbin	"src/sonic/data/mars/newtron_sprites.spr"
	cnop	0,4
MarsSpr_SonicButton:
	incbin	"src/sonic/data/mars/button_sprites.spr"
	cnop	0,4
MarsSpr_Blockbuster:
	incbin	"src/sonic/data/mars/blockbuster_sprites.spr"
	cnop	0,4
MarsSpr_RingGirlRotoscope:
	incbin	"src/sonic/data/mars/ring_girl_rotoscope_sprites.spr"
	cnop	0,4
MarsSpr_OllieWakeUp:
	incbin	"src/sonic/data/mars/ollie_wake_up_sprites.spr"
	cnop	0,4
MarsSpr_RingGirlBoss:
	incbin	"src/sonic/data/mars/ring_girl_boss_sprites.spr"
	cnop	0,4
MarsSpr_RingGirlBossBg:
	incbin	"src/sonic/data/mars/ring_girl_boss_bg_sprites.spr"
	cnop	0,4
MarsSpr_SonicBen:
	incbin	"src/sonic/data/mars/ben_sprites.spr"
	cnop	0,4
MarsSpr_SonicEyeball:
	incbin	"src/sonic/data/mars/eyeball_sprites.spr"
	cnop	0,4
MarsSpr_BenBackground:
	incbin	"src/sonic/data/mars/ben_background_sprites.spr"
	cnop	0,4
MarsSpr_BenBossSprites:
	incbin	"src/sonic/data/mars/ben_boss_sprites.spr"
	cnop	0,4
MarsSpr_SlendermanBoss:
	incbin	"src/sonic/data/mars/slenderman_boss_sprites.spr"
	cnop	0,4
MarsSpr_ToadBoss:
	incbin	"src/sonic/data/mars/toad_boss_sprites.spr"
	cnop	0,4
MarsSpr_OllieBoss:
	incbin	"src/sonic/data/mars/ollie_boss_sprites.spr"
	cnop	0,4
MarsSpr_OllieHand:
	incbin	"src/sonic/data/mars/ollie_hand_sprites.spr"
	cnop	0,4

; ------------------------------------------------------------------------------
; Palettes (section 1)
; ------------------------------------------------------------------------------

MarsPal_RingGirl:
	incbin	"src/sonic/maps/1_ring_girl/mars_palette.pal"
	cnop	0,4
MarsPal_RingGirlBoss:
	incbin	"src/sonic/maps/1_ring_girl_boss/mars_palette.pal"
	cnop	0,4
MarsPal_BenDrowned:
	incbin	"src/sonic/maps/2_ben_drowned/mars_palette.pal"
	cnop	0,4
MarsPal_BenBackground:
	incbin	"src/sonic/data/mars/ben_background_palette.pal"
	cnop	0,4
MarsPal_BenDrownedBoss:
	incbin	"src/sonic/maps/2_ben_drowned_boss/mars_palette.pal"
	cnop	0,4
MarsPal_Slenderman:
	incbin	"src/sonic/maps/3_slenderman/mars_palette.pal"
	cnop	0,4
MarsPal_SlendermanBoss:
	incbin	"src/sonic/maps/3_slenderman_boss/mars_palette.pal"
	cnop	0,4
MarsPal_Hellscape:
	incbin	"src/sonic/maps/4_hellscape/mars_palette.pal"
	cnop	0,4
MarsPal_HellscapeBoss:
	incbin	"src/sonic/maps/4_hellscape_boss/mars_palette.pal"
	cnop	0,4
MarsPal_ScaryMaze:
	incbin	"src/sonic/maps/5_scary_maze/mars_palette.pal"
	cnop	0,4
MarsPal_FinalNormal:
	incbin	"src/sonic/maps/6_1_normal/mars_palette.pal"
	cnop	0,4
MarsPal_FinalPrison:
	incbin	"src/sonic/maps/6_2_prison/mars_palette.pal"
	cnop	0,4
MarsPal_FinalComputer:
	incbin	"src/sonic/maps/6_3_computer/mars_palette.pal"
	cnop	0,4
MarsPal_OllieBoss:
	incbin	"src/sonic/data/mars/ollie_boss_palette.pal"
	cnop	0,4

; ------------------------------------------------------------------------------
; Sprites (section 2)
; ------------------------------------------------------------------------------

	section sh2_data_2
MarsSpr_BenTear:
	incbin	"src/sonic/data/mars/ben_tear_sprites.spr"
	cnop	0,4

; ------------------------------------------------------------------------------
