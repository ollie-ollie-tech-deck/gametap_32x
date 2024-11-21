; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Z80 variables
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; Track structure
; ------------------------------------------------------------------------------

	rsreset
zsnd.flags		rs.b 1					; Flags
zsnd.channel		rs.b 1					; Channel type
zsnd.tempo_divider	rs.b 1					; Tempo divider
zsnd.track_data_bank	rs.b 1					; Track data bank
zsnd.track_data_addr	rs.w 1					; Track data address
zsnd.transpose		rs.b 1					; Transposition
zsnd.volume		rs.b 1					; Volume
zsnd.panning		rs.b 1					; Panning
zsnd.instrument		rs.b 1					; Instrument
zsnd.fm_outputs		rs.b 0					; FM output operators
zsnd.psg_cursor		rs.b 1					; PSG instrument cursor
zsnd.call_stack_addr	rs.b 1					; Call stack address
zsnd.duration_timer	rs.b 1					; Note duration timer
zsnd.duration		rs.b 1					; Note duration
zsnd.pwm_sample		rs.b 0					; PWM sample
zsnd.frequency		rs.w 1					; Frequency
zsnd.staccato_timer	rs.b 1					; Staccato timer
zsnd.staccato		rs.b 1					; Staccato
zsnd.vibrato_params	rs.w 1					; Vibrato parameters address
zsnd.vibrato_wait	rs.b 1					; Vibrato wait
zsnd.vibrato_speed	rs.b 1					; Vibrato speed
zsnd.vibrato_delta	rs.b 1					; Vibrato delta
zsnd.vibrato_steps	rs.b 1					; Vibrato steps
zsnd.vibrato		rs.w 1					; Vibrato value
zsnd.detune		rs.b 1					; Detune
zsnd.psg_noise		rs.b 0					; PSG noise
zsnd.fm_algo_feedback	rs.b 1					; FM algorithm and feedback
zsnd.fm_instruments	rs.w 1					; FM instruments address
zsnd.loop_counters	rs.b $12				; Loop counters
zsnd.call_stack_base	rs.b 0					; Call stack base
zsnd.struct_len		rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; RAM layout
; ------------------------------------------------------------------------------

Z80_VARIABLES		equ $1C00				; Variables start
SFX_QUEUE_COUNT		equ 4					; Number of sound queue slots

	rsset Z80_VARIABLES
z_command_queue		rs.b 1					; Command queue
z_music_queue		rs.b 4					; Music queue
z_sfx_queue		rs.b 4*SFX_QUEUE_COUNT			; SFX queue
z_current_bank		rs.b 1					; Current bank
z_atgames_mode		rs.b 1					; AtGames mode flag
z_sound_communication	rs.b 1					; Sound communication flag
z_music_tempo_timer	rs.b 1					; Music tempo timer
z_music_tempo		rs.b 1					; Music tempo
z_sound_fade_timer	rs.b 1					; Sound fade timer
z_sound_fade_delay	rs.b 1					; Sound fade delay
z_sound_pause		rs.b 1					; Sound pause flag
z_tracks		rs.b 0					; Tracks
z_music_tracks		rs.b 0					; Music tracks
z_music_pwm		rs.b zsnd.struct_len			; Music PWM track
z_music_fm1		rs.b zsnd.struct_len			; Music FM1 track
z_music_fm2		rs.b zsnd.struct_len			; Music FM2 track
z_music_fm3		rs.b zsnd.struct_len			; Music FM3 track
z_music_fm4		rs.b zsnd.struct_len			; Music FM4 track
z_music_fm5		rs.b zsnd.struct_len			; Music FM5 track
z_music_fm6		rs.b zsnd.struct_len			; Music FM6 track
z_music_psg1		rs.b zsnd.struct_len			; Music PSG1 track
z_music_psg2		rs.b zsnd.struct_len			; Music PSG2 track
z_music_psg3		rs.b zsnd.struct_len			; Music PSG3 track
z_music_tracks_end	rs.b 0					; End of music tracks
z_sfx_tracks		rs.b 0					; SFX tracks
z_sfx_fm3		rs.b zsnd.struct_len			; SFX FM3 track
z_sfx_fm4		rs.b zsnd.struct_len			; SFX FM4 track
z_sfx_fm5		rs.b zsnd.struct_len			; SFX FM5 track
z_sfx_psg1		rs.b zsnd.struct_len			; SFX PSG1 track
z_sfx_psg2		rs.b zsnd.struct_len			; SFX PSG2 track
z_sfx_psg3		rs.b zsnd.struct_len			; SFX PSG3 track
z_sfx_tracks_end	rs.b 0					; End of SFX tracks
z_sfx_bg_tracks		rs.b 0					; Background SFX tracks
z_sfx_bg_fm4		rs.b zsnd.struct_len			; Background SFX FM4 track
z_sfx_bg_psg3		rs.b zsnd.struct_len			; Background SFX PSG3 track
z_sfx_bg_tracks_end	rs.b 0					; End of background SFX tracks
Z80_VARIABLES_END	rs.b 0					; End of variables

Z80_VARS_LENGTH		equ Z80_VARIABLES_END-Z80_VARIABLES	; Length of variables

; ------------------------------------------------------------------------------
