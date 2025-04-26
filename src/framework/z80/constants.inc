; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Z80 constants
; ------------------------------------------------------------------------------

PWM_TYPE		equ 4					; PWM type
FM_P2_TYPE		equ 2					; FM part 2 type
PSG_TYPE		equ 7					; PSG type

FM1_TYPE		equ 0					; FM1 type
FM2_TYPE		equ 1					; FM2 type
FM3_TYPE		equ 2					; FM3 type
FM4_TYPE		equ (1<<FM_P2_TYPE)|0			; FM4 type
FM5_TYPE		equ (1<<FM_P2_TYPE)|1			; FM5 type
FM6_TYPE		equ (1<<FM_P2_TYPE)|2			; FM6 type
PSG1_TYPE		equ (1<<PSG_TYPE)|(0<<5)		; PSG1 type
PSG2_TYPE		equ (1<<PSG_TYPE)|(1<<5)		; PSG2 type
PSG3_TYPE		equ (1<<PSG_TYPE)|(2<<5)		; PSG3 type
PSG4_TYPE		equ (1<<PSG_TYPE)|(3<<5)		; PSG4 type

MUSIC_PWM_TRACK_COUNT	equ 1					; Number of music PWM tracks
MUSIC_FM_TRACK_COUNT	equ 6					; Number of music FM tracks
MUSIC_PSG_TRACK_COUNT	equ 3					; Number of music PSG tracks
MUSIC_TRACK_COUNT	equ 10					; Number of music tracks

SFX_FM_TRACK_COUNT	equ 3					; Number of SFX FM tracks
SFX_PSG_TRACK_COUNT	equ 3					; Number of SFX PSG tracks
SFX_TRACK_COUNT		equ 6					; Number of SFX tracks

BG_SFX_FM_TRACK_COUNT	equ 1					; Number of background SFX FM tracks
BG_SFX_PSG_TRACK_COUNT	equ 1					; Number of background SFX PSG tracks
BG_SFX_TRACK_COUNT	equ 2					; Number of background SFX tracks

TRACK_COUNT		equ 18					; Number of tracks

REST_FLAG		equ 1					; Rest flag bit
OVERRIDE_FLAG		equ 2					; Override flag bit
VIBRATO_FLAG		equ 3					; Vibrato flag bit
LEGATO_FLAG		equ 4					; Legato flag bit
SFX_FLAG		equ 5					; SFX flag bit
SFX_BG_FLAG		equ 6					; Background SFX flag bit
PLAY_FLAG		equ 7					; Play flag bit

NOTES_START		equ $80					; Note IDs start
TRACK_CMDS_START	equ $E0					; Track commands start

STACK_SPACE		equ $80					; Stack space

; ------------------------------------------------------------------------------
