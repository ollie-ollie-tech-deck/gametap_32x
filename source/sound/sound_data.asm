; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sound data
; ------------------------------------------------------------------------------

	section m68k_rom_sound_0
	include	"source/shared.inc"
	include	"source/sound/smps2asm.inc"

; ------------------------------------------------------------------------------
; Music
; ------------------------------------------------------------------------------

Song_Title:
	include	"source/sound/music/title.asm"
	even
Song_Holiday:
	include	"source/sound/music/holiday.asm"
	even
Song_Drone:
	include	"source/sound/music/drone.asm"
	even
Song_Fantasmas:
	include	"source/sound/music/fantasmas.asm"
	even
Song_Ghz:
	include	"source/sound/music/ghz.asm"
	even
Song_KissMe:
	include	"source/sound/music/kiss_me.asm"
	even
Song_GhzGems:
	include	"source/sound/music/ghz_gems.asm"
	even
Song_Blue:
	include	"source/sound/music/blue.asm"
	even
Song_GhzSlayer:
	include	"source/sound/music/ghz_slayer.asm"
	even
Song_MineEyes:
	include	"source/sound/music/mine_eyes.asm"
	even
Song_GhzGoodFuture:
	include	"source/sound/music/ghz_good_future.asm"
	even
Song_GhzSin:
	include	"source/sound/music/ghz_sin.asm"
	even
Song_GhzTelefon:
	include	"source/sound/music/ghz_telefon.asm"
	even
Song_Godlike:
	include	"source/sound/music/godlike.asm"
	even

	section m68k_rom_sound_1
Song_OneHundredYears:
	include	"source/sound/music/one_hundred_years.asm"
	even
Song_Promise:
	include	"source/sound/music/promise.asm"
	even

; ------------------------------------------------------------------------------
; SFX
; ------------------------------------------------------------------------------

Sfx_Jump:
	include	"source/sound/sfx/jump.asm"
	even
Sfx_Skid:
	include	"source/sound/sfx/skid.asm"
	even
Sfx_Roll:
	include	"source/sound/sfx/roll.asm"
	even
Sfx_Dash:
	include	"source/sound/sfx/dash.asm"
	even
Sfx_Flash:
	include	"source/sound/sfx/flash.asm"
	even
Sfx_Explosion:
	include	"source/sound/sfx/explosion.asm"
	even
Sfx_FireExplosion:
	include	"source/sound/sfx/fire_explosion.asm"
	even
Sfx_Collapse:
	include	"source/sound/sfx/collapse.asm"
	even
Sfx_Spring:
	include	"source/sound/sfx/spring.asm"
	even
Sfx_Bounce:
	include	"source/sound/sfx/bounce.asm"
	even
Sfx_Thump:
	include	"source/sound/sfx/thump.asm"
	even
Sfx_HitBoss:
	include	"source/sound/sfx/hit_boss.asm"
	even
Sfx_Damage:
	include	"source/sound/sfx/damage.asm"
	even
Sfx_Spikes:
	include	"source/sound/sfx/spikes.asm"
	even
Sfx_Rumble:
	include	"source/sound/sfx/rumble.asm"
	even
Sfx_Wiggle:
	include	"source/sound/sfx/wiggle.asm"
	even
Sfx_Warp:
	include	"source/sound/sfx/warp.asm"
	even

; ------------------------------------------------------------------------------
