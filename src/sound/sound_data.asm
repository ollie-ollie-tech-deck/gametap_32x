; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sound data
; ------------------------------------------------------------------------------

	section m68k_rom_sound_0
	include	"src/shared.inc"
	include	"src/sound/smps2asm.inc"

; ------------------------------------------------------------------------------
; Music
; ------------------------------------------------------------------------------

Song_Title:
	include	"src/sound/music/title.asm"
	even
Song_Holiday:
	include	"src/sound/music/holiday.asm"
	even
Song_Drone:
	include	"src/sound/music/drone.asm"
	even
Song_Fantasmas:
	include	"src/sound/music/fantasmas.asm"
	even
Song_Ghz:
	include	"src/sound/music/ghz.asm"
	even
Song_KissMe:
	include	"src/sound/music/kiss_me.asm"
	even
Song_GhzGems:
	include	"src/sound/music/ghz_gems.asm"
	even
Song_Blue:
	include	"src/sound/music/blue.asm"
	even
Song_GhzSlayer:
	include	"src/sound/music/ghz_slayer.asm"
	even
Song_MineEyes:
	include	"src/sound/music/mine_eyes.asm"
	even
Song_GhzGoodFuture:
	include	"src/sound/music/ghz_good_future.asm"
	even
Song_GhzSin:
	include	"src/sound/music/ghz_sin.asm"
	even
Song_GhzTelefon:
	include	"src/sound/music/ghz_telefon.asm"
	even
Song_Godlike:
	include	"src/sound/music/godlike.asm"
	even

	section m68k_rom_sound_1
Song_OneHundredYears:
	include	"src/sound/music/one_hundred_years.asm"
	even
Song_Promise:
	include	"src/sound/music/promise.asm"
	even

; ------------------------------------------------------------------------------
; SFX
; ------------------------------------------------------------------------------

Sfx_Jump:
	include	"src/sound/sfx/jump.asm"
	even
Sfx_Skid:
	include	"src/sound/sfx/skid.asm"
	even
Sfx_Roll:
	include	"src/sound/sfx/roll.asm"
	even
Sfx_Dash:
	include	"src/sound/sfx/dash.asm"
	even
Sfx_Flash:
	include	"src/sound/sfx/flash.asm"
	even
Sfx_Explosion:
	include	"src/sound/sfx/explosion.asm"
	even
Sfx_FireExplosion:
	include	"src/sound/sfx/fire_explosion.asm"
	even
Sfx_Collapse:
	include	"src/sound/sfx/collapse.asm"
	even
Sfx_Spring:
	include	"src/sound/sfx/spring.asm"
	even
Sfx_Bounce:
	include	"src/sound/sfx/bounce.asm"
	even
Sfx_Thump:
	include	"src/sound/sfx/thump.asm"
	even
Sfx_HitBoss:
	include	"src/sound/sfx/hit_boss.asm"
	even
Sfx_Damage:
	include	"src/sound/sfx/damage.asm"
	even
Sfx_Spikes:
	include	"src/sound/sfx/spikes.asm"
	even
Sfx_Rumble:
	include	"src/sound/sfx/rumble.asm"
	even
Sfx_Wiggle:
	include	"src/sound/sfx/wiggle.asm"
	even
Sfx_Warp:
	include	"src/sound/sfx/warp.asm"
	even

; ------------------------------------------------------------------------------
