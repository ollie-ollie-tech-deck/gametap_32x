; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; PWM samples
; ------------------------------------------------------------------------------

	section sh2_data_1
	include	"src/framework/mars.inc"
	
; ------------------------------------------------------------------------------
; Silent PWM sample
; ------------------------------------------------------------------------------

Pwm_Silence		equ 0
Pwm_Silence_End		equ 0

; ------------------------------------------------------------------------------
; Define PWM sample entry
; ------------------------------------------------------------------------------

PWM_ENTRY macro sample, loop, rate
	dc.l	\sample
	dc.l	(\sample\_End)-(\sample)
	if (\loop)>=0
		dc.l	(\sample)+(\loop)
	else
		dc.l	0
	endif
	dc.l	\rate
	endm

; ------------------------------------------------------------------------------
; Define PWM sample data
; ------------------------------------------------------------------------------

PWM_DATA macro sample, file
	cnop 0,4
\sample\:
	incbin	\file, $2C
\sample\_End:
	cnop 0,4
	endm

; ------------------------------------------------------------------------------
; PWM sample table
; ------------------------------------------------------------------------------

MarsPwmIndex:
	PWM_ENTRY Pwm_Silence,		-1, $800		; $00
	PWM_ENTRY Pwm_Kick,		-1, $800		; $01
	PWM_ENTRY Pwm_Snare,		-1, $800		; $02
	PWM_ENTRY Pwm_Timpani,		-1, $5FE		; $03
	PWM_ENTRY Pwm_GameTap,		-1, $800		; $04
	PWM_ENTRY Pwm_YuGiOh,		-1, $800		; $05
	PWM_ENTRY Pwm_Wahoo,		-1, $800		; $06
	PWM_ENTRY Pwm_Text,		-1, $800		; $07
	PWM_ENTRY Pwm_Timpani,		-1, $800		; $08
	PWM_ENTRY Pwm_Timpani,		-1, $720		; $09
	PWM_ENTRY Pwm_Timpani,		-1, $5FE		; $0A
	PWM_ENTRY Pwm_Timpani,		-1, $5A9		; $0B
	PWM_ENTRY Pwm_SelectMove,	-1, $800		; $0C
	PWM_ENTRY Pwm_SelectConfirm,	-1, $800		; $0D
	PWM_ENTRY Pwm_DoorOpen,		-1, $800		; $0E
	PWM_ENTRY Pwm_DoorClose,	-1, $800		; $0F
	PWM_ENTRY Pwm_CashRegister,	-1, $800		; $10
	PWM_ENTRY Pwm_StomachGrumble,	-1, $800		; $11
	PWM_ENTRY Pwm_RingGirlScare,	-1, $800		; $12
	PWM_ENTRY Pwm_RingGirlHit,	-1, $800		; $13
	PWM_ENTRY Pwm_RingGirlDie,	-1, $800		; $14
	PWM_ENTRY Pwm_Microwave,	 0, $800		; $15
	PWM_ENTRY Pwm_AxeShake,		-1, $800		; $16
	PWM_ENTRY Pwm_AxeSpray,		-1, $800		; $17
	PWM_ENTRY Pwm_Cough,		-1, $800		; $18
	PWM_ENTRY Pwm_WallSmash,	-1, $800		; $19
	PWM_ENTRY Pwm_CouchSlide,	-1, $800		; $1A
	PWM_ENTRY Pwm_BenAppear,	-1, $800		; $1B
	PWM_ENTRY Pwm_WellMeetAgain,	-1, $400		; $1C
	PWM_ENTRY Pwm_Cry,		-1, $400		; $1D
	PWM_ENTRY Pwm_BenTear,		-1, $800		; $1E
	PWM_ENTRY Pwm_BenHit,		-1, $800		; $1F
	PWM_ENTRY Pwm_GarageOpen,	-1, $800		; $20
	PWM_ENTRY Pwm_CarCrash,		-1, $800		; $21
	PWM_ENTRY Pwm_GlassBreak,	-1, $800		; $22
	PWM_ENTRY Pwm_DoorKnock,	-1, $800		; $23
	PWM_ENTRY Pwm_Repair,		-1, $800		; $24
	PWM_ENTRY Pwm_Crash,		-1, $800		; $25
	PWM_ENTRY Pwm_GoodEnding,	 0, $800		; $26
	PWM_ENTRY Pwm_CultScream,	-1, $800		; $27
	PWM_ENTRY Pwm_ToadHurt,		-1, $800		; $28
	PWM_ENTRY Pwm_AoOni,		 0, $800		; $29
MarsPwmIndexEnd:

; ------------------------------------------------------------------------------
; PWM samples (section 1)
; ------------------------------------------------------------------------------

	PWM_DATA Pwm_Kick,		"src/sound/pwm/kick.wav"
	PWM_DATA Pwm_Snare,		"src/sound/pwm/snare.wav"
	PWM_DATA Pwm_Timpani,		"src/sound/pwm/timpani.wav"
	PWM_DATA Pwm_GameTap,		"src/sound/pwm/gametap.wav"
	PWM_DATA Pwm_YuGiOh,		"src/sound/pwm/yugioh.wav"
	PWM_DATA Pwm_Wahoo,		"src/sound/pwm/wahoo.wav"
	PWM_DATA Pwm_Text,		"src/sound/pwm/text.wav"
	PWM_DATA Pwm_SelectMove,	"src/sound/pwm/select_move.wav"
	PWM_DATA Pwm_SelectConfirm,	"src/sound/pwm/select_confirm.wav"
	PWM_DATA Pwm_DoorOpen,		"src/sound/pwm/door_open.wav"
	PWM_DATA Pwm_DoorClose,		"src/sound/pwm/door_close.wav"
	PWM_DATA Pwm_CashRegister,	"src/sound/pwm/cash_register.wav"
	PWM_DATA Pwm_StomachGrumble,	"src/sound/pwm/stomach_grumble.wav"
	PWM_DATA Pwm_RingGirlScare,	"src/sound/pwm/ring_girl_scare.wav"
	PWM_DATA Pwm_RingGirlHit,	"src/sound/pwm/ring_girl_hit.wav"
	PWM_DATA Pwm_RingGirlDie,	"src/sound/pwm/ring_girl_die.wav"
	PWM_DATA Pwm_Microwave,		"src/sound/pwm/microwave.wav"
	PWM_DATA Pwm_AxeShake,		"src/sound/pwm/axe_shake.wav"
	PWM_DATA Pwm_AxeSpray,		"src/sound/pwm/axe_spray.wav"
	PWM_DATA Pwm_Cough,		"src/sound/pwm/cough.wav"
	PWM_DATA Pwm_WallSmash,		"src/sound/pwm/wall_smash.wav"
	PWM_DATA Pwm_CouchSlide,	"src/sound/pwm/couch_slide.wav"
	PWM_DATA Pwm_BenAppear,		"src/sound/pwm/ben_appear.wav"
	PWM_DATA Pwm_WellMeetAgain,	"src/sound/pwm/well_meet_again.wav"
	PWM_DATA Pwm_Cry,		"src/sound/pwm/cry.wav"

; ------------------------------------------------------------------------------
; PWM samples (section 2)
; ------------------------------------------------------------------------------

	section sh2_data_2
	PWM_DATA Pwm_BenTear,		"src/sound/pwm/ben_tear.wav"
	PWM_DATA Pwm_BenHit,		"src/sound/pwm/ben_hit.wav"
	PWM_DATA Pwm_GarageOpen,	"src/sound/pwm/garage_open.wav"	
	PWM_DATA Pwm_CarCrash,		"src/sound/pwm/car_crash.wav"
	PWM_DATA Pwm_GlassBreak,	"src/sound/pwm/glass_break.wav"
	PWM_DATA Pwm_DoorKnock,		"src/sound/pwm/door_knock.wav"
	PWM_DATA Pwm_Repair,		"src/sound/pwm/repair.wav"
	PWM_DATA Pwm_Crash,		"src/sound/pwm/crash.wav"
	PWM_DATA Pwm_GoodEnding,	"src/sound/pwm/good_ending.wav"
	PWM_DATA Pwm_CultScream,	"src/sound/pwm/cult_scream.wav"
	PWM_DATA Pwm_ToadHurt,		"src/sound/pwm/toad_hurt.wav"
	PWM_DATA Pwm_AoOni,		"src/sound/pwm/ao_oni.wav"

; ------------------------------------------------------------------------------
