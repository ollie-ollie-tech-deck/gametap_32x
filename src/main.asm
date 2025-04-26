; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Main source
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/shared.inc"

; ------------------------------------------------------------------------------
; Main function
; ------------------------------------------------------------------------------

Main:
	jsr	StopSound					; Stop sound

	.c: = 0							; Clear event flags
	rept EVENT_BYTES/4
		clr.l	event_flags+.c
		.c: = .c+4
	endr
	if (EVENT_BYTES&2)<>0
		clr.w	event_flags+.c
	endif

	clr.w	sonic_stage_id					; Reset stage IDs

	jmp	SplashScreenScene				; Go to splash screen

; ------------------------------------------------------------------------------
