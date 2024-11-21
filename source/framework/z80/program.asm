; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Z80 program
; ------------------------------------------------------------------------------

	include	"macro_setup.inc"
	
	CPU 68000
	padding off
	include	"../z80.inc"
	include	"constants.inc"
	include	"variables.inc"

	CPU Z80
	dephase
	!org 0

; ------------------------------------------------------------------------------
; Driver entry point
; ------------------------------------------------------------------------------

DriverStart:
	di							; Disable interrupts
	di
	im	1						; Interrupt mode 1

	jp	InitDriver					; Initialize driver

; ------------------------------------------------------------------------------
; Get next track
; ------------------------------------------------------------------------------

	align	8
GetNextTrack:
	ld	de,zsnd.struct_len				; Next track
	add	ix,de
	ret

; ------------------------------------------------------------------------------
; Read byte from (HL) and advance
; ------------------------------------------------------------------------------

	align	8
ReadNextByteHL:
	ld	a,(hl)						; Read byte
	inc	hl						; Advance
	ret

; ------------------------------------------------------------------------------
; Write to PSG control port
; ------------------------------------------------------------------------------

	align	8
WritePsg:
	ld	(PSG_CTRL),a					; Write to PSG control port
	ret

; ------------------------------------------------------------------------------
; Write track FM register
; ------------------------------------------------------------------------------

	align 8
WriteFmTrackReg:
	bit	FM_P2_TYPE,(ix+zsnd.channel)			; Is this a part 2 track?
	jr	nz,WriteFmTrackReg2				; If so, branch
	jr	WriteFmTrackReg1				; Write part 1 register

; ------------------------------------------------------------------------------
; Write FM register (part 1)
; ------------------------------------------------------------------------------

	align 8
WriteFmReg1:
	ld	(YM_ADDR_0),a					; Write register value
	ld	a,c
	ld	(YM_DATA_0),a
	ret

; ------------------------------------------------------------------------------
; Write FM register (part 2)
; ------------------------------------------------------------------------------

	align 8
WriteFmReg2:
	ld	(YM_ADDR_1),a					; Write register value
	ld	a,c
	ld	(YM_DATA_1),a
	ret

; ------------------------------------------------------------------------------
; V-BLANK interrupt
; ------------------------------------------------------------------------------

	org 38h
VBlankInt:
	di							; Disable interrupts
	jp	UpdateSound					; Update sound

; ------------------------------------------------------------------------------
; Write track FM register (part 2)
; ------------------------------------------------------------------------------

WriteFmTrackReg1:
	add	a,(ix+zsnd.channel)				; Add channel ID to register ID
	jr	WriteFmReg1					; Write register

; ------------------------------------------------------------------------------
; Write track FM register (part 2)
; ------------------------------------------------------------------------------

WriteFmTrackReg2:
	add	a,(ix+zsnd.channel)				; Add channel ID to register ID
	sub	1<<FM_P2_TYPE
	jr	WriteFmReg2					; Write register

; ------------------------------------------------------------------------------
; Do set 68000 bank
; ------------------------------------------------------------------------------

SetM68kBank:
	push	hl						; Save registers
	push	bc

	ld	(z_current_bank),a				; Save bank ID

	ld	hl,M68K_BANK_SET+1				; Set bank ID bits
	ld	b,8

.SetBank:
	ld	(hl),a
	rrca
	djnz	.SetBank
	ld	(hl),l

	pop	bc						; Restore registers
	pop	hl
	ret

; ------------------------------------------------------------------------------
; Initialize the driver
; ------------------------------------------------------------------------------

InitDriver:
	ld	sp,Z80_VARIABLES				; Set stack pointer

	ld	a,2Bh						; Disable DAC
	ld	c,0
	rst	WriteFmReg1

	ld	ix,z_tracks					; Tracks
	ld	b,TRACK_COUNT

	ld	hl,.TrackSetup					; Track setup parameters

.SetupTracks:
	rst	ReadNextByteHL					; Set flags
	ld	(ix+zsnd.flags),a

	rst	ReadNextByteHL					; Set channel type
	ld	(ix+zsnd.channel),a

	rst	GetNextTrack					; Next track
	djnz	.SetupTracks					; Loop until finished

.Loop:
	ei							; Enable interrupts
	jr	.Loop						; Let V-BLANK take care of the updating

; ------------------------------------------------------------------------------

.TrackSetup:
	db	0, 1<<PWM_TYPE					; Music PWM
	db	0, FM1_TYPE					; Music FM1
	db	0, FM2_TYPE					; Music FM2
	db	0, FM3_TYPE					; Music FM3
	db	0, FM4_TYPE					; Music FM4
	db	0, FM5_TYPE					; Music FM5
	db	0, FM6_TYPE					; Music FM6
	db	0, PSG1_TYPE					; Music PSG1
	db	0, PSG2_TYPE					; Music PSG2
	db	0, PSG3_TYPE					; Music PSG3

	db	1<<SFX_FLAG, FM3_TYPE				; SFX FM3
	db	1<<SFX_FLAG, FM4_TYPE				; SFX FM4
	db	1<<SFX_FLAG, FM5_TYPE				; SFX FM5
	db	1<<SFX_FLAG, PSG1_TYPE				; SFX PSG1
	db	1<<SFX_FLAG, PSG2_TYPE				; SFX PSG2
	db	1<<SFX_FLAG, PSG3_TYPE				; SFX PSG3
	
	db	(1<<SFX_FLAG)|(1<<SFX_BG_FLAG), FM4_TYPE	; Background SFX FM4
	db	(1<<SFX_FLAG)|(1<<SFX_BG_FLAG), PSG3_TYPE	; Background SFX PSG3

; ------------------------------------------------------------------------------
; Update sound
; ------------------------------------------------------------------------------

UpdateSound:
	ld	a,(z_sound_pause)				; Are we paused?
	or	a
	jr	z,SoundNotPaused				; If not, branch

; ------------------------------------------------------------------------------
; Update pause
; ------------------------------------------------------------------------------

UpdatePause:
	jp	m,Unpause					; If we should unpause, branch

	ld	b,2						; Has the pause been processed?
	cp	b
	ret	z						; If so, exit
	ld	a,b						; Mark pause as processed
	ld	(z_sound_pause),a

	inc	b						; 3 channels per part
	ld	d,0B4h						; Panning register
	ld	c,0						; No panning

.ClearFmPan:
	ld	a,d						; Set panning
	rst	WriteFmReg1
	ld	a,d
	rst	WriteFmReg2
	inc	d						; Next channel
	djnz	.ClearFmPan					; Loop until finished

	call	StopPwm						; Stop PWM
	call	FmAllKeyOff					; Set all FM channels key off
	
; ------------------------------------------------------------------------------
; Silence PSG
; ------------------------------------------------------------------------------

SilencePsg:
	ld	a,(z_current_bank)				; Move bank out of danger zone
	push	af
	call	MoveBankForPsg

	ld	a,PSG1_TYPE|1Fh					; Start with PSG1
	ld	b,4						; 4 channels

.Silence:
	rst	WritePsg					; Silence channel
	add	a,20h						; Next channel
	djnz	.Silence					; Loop until finished

	pop	af						; Restore bank
	jp	SetM68kBank

; ------------------------------------------------------------------------------
; Continue updating sound after confirming sound is not paused
; ------------------------------------------------------------------------------

SoundNotPaused:
	ld	a,(z_music_tempo_timer)				; Decrement music tempo timer
	dec	a
	ld	(z_music_tempo_timer),a
	jr	nz,UpdateFade					; If it hasn't run out, branch
	
	ld	a,(z_music_tempo)				; Reset tempo timer
	ld	(z_music_tempo_timer),a

	ld	ix,z_music_tracks				; Music tracks
	ld	b,MUSIC_TRACK_COUNT

.ApplyTempo:
	inc	(ix+zsnd.duration_timer)			; Delay note
	rst	GetNextTrack					; Next track
	djnz	.ApplyTempo					; Loop until finished

; ------------------------------------------------------------------------------
; Update fade
; ------------------------------------------------------------------------------

UpdateFade:
	ld	a,(z_sound_fade_timer)				; Get fade timer
	or	a
	jr	z,CheckCommandQueue				; If we are not fading, branch
	ld	b,a
	
	ld	a,(z_sound_fade_delay)				; Get fade delay
	or	a
	jr	z,.UpdateFade					; If it has run out, branch

	dec	a						; Decrement fade delay
	ld	(z_sound_fade_delay),a
	jr	CheckCommandQueue

.UpdateFade:
	dec	b						; Decrement fade timer
	ld	a,b
	ld	(z_sound_fade_timer),a
	jr	nz,.NoFadeStop					; If it hasn't run out, branch

	call	StopSound					; Stop sound
	jr	CheckCommandQueue

.NoFadeStop:
	ld	a,3						; Reset fade delay
	ld	(z_sound_fade_delay),a

	ld	ix,z_music_tracks				; Music tracks
	ld	b,MUSIC_TRACK_COUNT

.FadeTracks:
	bit	PLAY_FLAG,(ix+zsnd.flags)			; Is this track playing?
	jr	z,.NextTrack					; If not, branch
	
	inc	(ix+zsnd.volume)				; Decrease volume

	call	CheckFmTrack					; Is this an FM track?
	jr	nz,.FadePwmPsgTrack				; If not, branch

.FadeFmTrack:
	ld	a,(ix+zsnd.volume)				; Has the volume been minimized?
	cp	080h
	jr	nc,.StopTrack					; If so, branch

	call	SetFmVolume					; Set FM volume
	jr	.NextTrack					; Next track

.FadePwmPsgTrack:
	ld	a,(ix+zsnd.volume)				; Has the volume been minimized?
	cp	10h
	jr	c,.SetPwmPsgVolume				; If not, branch
	
.StopTrack:
	res	PLAY_FLAG,(ix+zsnd.flags)			; Stop playing track
	jr	.NextTrack					; Next track

.SetPwmPsgVolume:
	bit	PWM_TYPE,(ix+zsnd.channel)			; Is this a PWM track?
	jr	nz,.FadePwmTrack				; If so, set PWM volume
	
	ld	c,a						; Get PSG volume

	ld	a,(ix+zsnd.instrument)				; Is the PSG instrument a straight tone?
	or	a
	jr	nz,.NextTrack					; If not, branch

	call	SetPsgVolume					; Set PSG volume
	jr	.NextTrack					; Next track

.FadePwmTrack:
	call	SetPwmVolumePan					; Set PWM volume

.NextTrack:
	rst	GetNextTrack					; Next track
	djnz	.FadeTracks					; Loop until finished

; ------------------------------------------------------------------------------
; Process command queue
; ------------------------------------------------------------------------------

CheckCommandQueue:
	ld	hl,CheckMusicQueue				; Set return address
	push	hl

	ld	iy,z_command_queue				; Are there any commands queued?
	ld	a,(iy)
	or	a
	ret	z						; If not, branch

	ld	hl,CommandTypes-2				; Handle command

; ------------------------------------------------------------------------------
; Jump to indexed address from HL
; ------------------------------------------------------------------------------

JumpIndexHL:
	call	ReadIndexHL					; Jump to indexed address
	jp	(hl)

; ------------------------------------------------------------------------------
; Process music queue
; ------------------------------------------------------------------------------

CheckMusicQueue:
	ld	iy,z_music_queue				; Is there any music queued?
	ld	a,(iy)
	or	a
	jr	z,CheckSfxQueue					; If not, branch

	call	PlayMusic					; Play music

; ------------------------------------------------------------------------------
; Process SFX queue
; ------------------------------------------------------------------------------

CheckSfxQueue:
	ld	iy,z_sfx_queue					; Are there any SFX queued?
	ld	a,(iy)
	or	a
	jr	z,UpdateTracks					; If not, branch

	ld	hl,.PopQueue					; Set return address
	push	hl

	ld	hl,SfxTypes-2					; Handle SFX type
	jr	JumpIndexHL

.PopQueue:
	ld	de,z_sfx_queue					; Pop SFX queue
	ld	hl,z_sfx_queue+4
	ld	bc,(SFX_QUEUE_COUNT-1)*4
	ldir
	xor	a
	ld	(de),a

	jr	CheckSfxQueue					; Process next queue slot

; ------------------------------------------------------------------------------
; Update tracks
; ------------------------------------------------------------------------------

UpdateTracks:
	xor	a						; Clear sound queues
	ld	(z_command_queue),a
	ld	(z_music_queue),a

	ld	ix,z_tracks					; Tracks
	ld	b,TRACK_COUNT

.UpdateTracks:
	push	bc						; Update track
	call	UpdateTrack
	pop	bc
	rst	GetNextTrack					; Next track
	djnz	.UpdateTracks					; Loop until finished
	ret

; ------------------------------------------------------------------------------
; Sound types
; ------------------------------------------------------------------------------

CommandTypes:
	dw	StopSound					; Stop sound
	dw	FadeSound					; Fade sound
	dw	HaltSound					; Halt sound
	dw	EnableAtGamesSound				; Enable AtGames mode
	dw	DisableAtGamesSound				; Disable AtGames mode

SfxTypes:
	dw	PlaySfx						; Play SFX
	dw	PlayBackgroundSfx				; Play background SFX

; ------------------------------------------------------------------------------
; Fade sound out
; ------------------------------------------------------------------------------

FadeSound:
	call	StopSfx						; Stop SFX
	call	StopBackgroundSfx				; Stop background SFX

	ld	a,3						; Set up fading
	ld	(z_sound_fade_delay),a
	ld	a,28h
	ld	(z_sound_fade_timer),a
	ret

; ------------------------------------------------------------------------------
; Halt sound
; ------------------------------------------------------------------------------

HaltSound:
	ld	ix,z_music_pwm					; Tracks
	ld	b,TRACK_COUNT

.StopTracks:
	res	OVERRIDE_FLAG,(ix+zsnd.flags)			; Stop track
	res	PLAY_FLAG,(ix+zsnd.flags)

	rst	GetNextTrack					; Next track
	djnz	.StopTracks					; Loop until finished
	ret

; ------------------------------------------------------------------------------
; Enable AtGames mode
; ------------------------------------------------------------------------------

EnableAtGamesSound:
	ld	a,1						; Enable AtGames mode
	ld	(z_atgames_mode),a
	ret

; ------------------------------------------------------------------------------
; Disable AtGames mode
; ------------------------------------------------------------------------------

DisableAtGamesSound:
	xor	a						; Enable AtGames mode
	ld	(z_atgames_mode),a
	ret

; ------------------------------------------------------------------------------
; Reset variables
; ------------------------------------------------------------------------------

ResetVariables:
	ld	hl,z_music_tempo_timer				; Reset variables
	ld	de,z_music_tempo_timer+1
	ld	bc,z_tracks-(z_music_tempo_timer+1)
	xor	a
	ld	(hl),a
	ldir

; ------------------------------------------------------------------------------
; Stop PWM
; ------------------------------------------------------------------------------

StopPwm:
	xor	a						; Stop sample
	call	SetPwmSampleReg
	cpl	a
	jp	SetPwmPanningReg

; ------------------------------------------------------------------------------
; Stop sound
; ------------------------------------------------------------------------------

StopSound:
	call	ResetVariables					; Reset variables

	ld	ix,z_music_pwm					; Tracks
	ld	b,TRACK_COUNT

.StopTracks:
	res	OVERRIDE_FLAG,(ix+zsnd.flags)			; Stop track
	res	PLAY_FLAG,(ix+zsnd.flags)

	rst	GetNextTrack					; Next track
	djnz	.StopTracks					; Loop until finished

	call	SilencePsg					; Silence PSG

; ------------------------------------------------------------------------------
; Silence FM
; ------------------------------------------------------------------------------

SilenceFm:
	ld	a,40h						; Volume register
	ld	c,7Fh						; Minimum volume
	ld	b,3						; 3 channels per part

.ChannelLoop:
	push	bc						; 4 operators
	ld	b,4

.ChannelRegLoop:
	ld	d,a						; Set volume
	rst	WriteFmReg1
	ld	a,d
	rst	WriteFmReg2
	ld	a,d
	add	a,4						; Next operator
	djnz	.ChannelRegLoop					; Loop until finished

	pop	bc						; Next channel
	sub	a,0Fh
	djnz	.ChannelLoop					; Loop until finished

; ------------------------------------------------------------------------------
; Set all FM channels key off
; ------------------------------------------------------------------------------

FmAllKeyOff:
	ld	b,3						; 3 channels per part

.Loop:
	ld	c,b						; Set key off (part 1)
	dec	c
	call	SetFmKeyOnOff

	inc	c						; Set key off (part 2)
	inc	c
	inc	c
	inc	c
	call	SetFmKeyOnOff

	djnz	.Loop						; Loop until finished
	ret

; ------------------------------------------------------------------------------
; Play music
; ------------------------------------------------------------------------------

PlayMusic:
	call	ResetVariables					; Reset variables

	ld	ix,z_music_fm1					; Music FM tracks
	ld	b,MUSIC_FM_TRACK_COUNT

.FmKeyOffLoop:
	res	PLAY_FLAG,(ix+zsnd.flags)			; Set key off
	res	LEGATO_FLAG,(ix+zsnd.flags)
	call	FmKeyOff

	rst	GetNextTrack					; Next track
	djnz	.FmKeyOffLoop					; Loop until finished
	
	ld	b,MUSIC_PSG_TRACK_COUNT				; Music PSG tracks

.PsgKeyOffLoop:
	res	PLAY_FLAG,(ix+zsnd.flags)			; Set key off
	res	LEGATO_FLAG,(ix+zsnd.flags)
	call	PsgKeyOff
	
	rst	GetNextTrack					; Next track
	djnz	.PsgKeyOffLoop					; Loop until finished

	ld	a,(iy+3)					; Set bank
	call	SetM68kBank

	ld	l,(iy+1)					; Get music data
	ld	h,(iy+2)
	push	hl
	pop	iy

	ld	a,(iy+5)					; Get tempo
	ld	(z_music_tempo),a
	ld	(z_music_tempo_timer),a

	call	GetInstrumentsAddress				; Get instruments address

	ld	bc,6						; Get track metadata
	add	hl,bc

	ld	a,(iy+2)					; Get number of PWM+FM tracks
	or	a
	jr	z,.FmDone					; If there are none, branch
	ld	b,a

	ld	ix,z_music_pwm					; Music PWM+FM tracks

.InitFm:
	ld	a,(ix+zsnd.flags)				; Set flags
	and	1<<OVERRIDE_FLAG
	or	1<<PLAY_FLAG
	ld	(ix+zsnd.flags),a

	ld	a,(iy+4)					; Set tempo divider
	ld	(ix+zsnd.tempo_divider),a

	call	InitTrack					; Initialize track

	rst	GetNextTrack					; Next track
	djnz	.InitFm						; Loop until finished

.FmDone:
	ld	a,(iy+3)					; Get number of PSG tracks
	or	a
	ret	z						; If there are none, exit
	ld	b,a

	ld	ix,z_music_psg1					; Music PSG tracks

.InitPsg:
	ld	a,(ix+zsnd.flags)				; Set flags
	and	1<<OVERRIDE_FLAG
	or	1<<PLAY_FLAG
	ld	(ix+zsnd.flags),a

	ld	a,(iy+4)					; Set tempo divider
	ld	(ix+zsnd.tempo_divider),a

	call	InitTrack					; Initialize track

	inc	hl						; Set instrument
	rst	ReadNextByteHL
	ld	(ix+zsnd.instrument),a

	rst	GetNextTrack					; Next track
	djnz	.InitPsg					; Loop until finished
	ret

; ------------------------------------------------------------------------------
; Play SFX
; ------------------------------------------------------------------------------

PlaySfx:
	ld	a,(z_sound_fade_timer)				; Are we fading?
	or	a
	ret	nz						; If so, exit
	
	ld	a,(iy+3)					; Set bank
	call	SetM68kBank

	ld	l,(iy+1)					; Get SFX data
	ld	h,(iy+2)
	push	hl
	pop	iy

	call	GetInstrumentsAddress				; Get instruments address

	ld	bc,4						; Get track metadata
	add	hl,bc

	ld	a,(iy+3)					; Get number of tracks
	or	a
	ret	z						; If there are none, exit
	ld	b,a

.InitTracks:
	push	hl						; Get associated music track
	inc	hl
	ld	a,(hl)
	push	af
	call	GetSfxMusicTrack
	push	hl
	pop	ix

	set	OVERRIDE_FLAG,(ix+zsnd.flags)			; Set override flag for music track

	ld	a,(ix+zsnd.channel)				; Is this a PSG3 track?
	cp	PSG3_TYPE
	jr	nz,.OverrideDone				; If not, branch

	ld	a,(z_current_bank)				; Move bank out of danger zone
	push	af
	call	MoveBankForPsg

	ld	a,PSG3_TYPE|1Fh					; Silence PSG3 and noise
	rst	WritePsg
	ld	a,PSG4_TYPE|1Fh
	rst	WritePsg
	
	pop	af						; Restore bank
	call	SetM68kBank

.OverrideDone:
	pop	af						; Get SFX track
	call	GetSfxTrackOffset
	ld	hl,SfxTracks
	call	ReadIndexHL
	push	hl
	pop	ix

	pop	hl						; Restore track metadata address

	ld	a,(ix+zsnd.flags)				; Set flags
	and	(1<<OVERRIDE_FLAG)|(1<<SFX_FLAG)
	or	1<<PLAY_FLAG
	or	(hl)
	ld	(ix+zsnd.flags),a
	inc	hl
	inc	hl

	ld	a,(iy+2)					; Set tempo divider
	ld	(ix+zsnd.tempo_divider),a

	call	InitTrack					; Initialize track

.NextTrack:
	djnz	.InitTracks					; Loop until finished

	ld	ix,z_sfx_fm4					; Is SFX FM4 playing?
	bit	PLAY_FLAG,(ix+zsnd.flags)
	jr	z,.CheckBgSfxPsg				; If not, branch

	ld	ix,z_sfx_bg_fm4					; Set override flag for background SFX
	set	OVERRIDE_FLAG,(ix+zsnd.flags)

.CheckBgSfxPsg:
	ld	ix,z_sfx_psg3					; Is SFX PSG3 playing?
	bit	PLAY_FLAG,(ix+zsnd.flags)
	ret	z						; If not, exit

	ld	ix,z_sfx_bg_psg3				; Set override flag for background SFX
	set	OVERRIDE_FLAG,(ix+zsnd.flags)
	ret

; ------------------------------------------------------------------------------
; Play background SFX
; ------------------------------------------------------------------------------

PlayBackgroundSfx:
	ld	a,(z_sound_fade_timer)				; Are we fading?
	or	a
	ret	nz						; If so, exit
	
	ld	a,(iy+3)					; Set bank
	call	SetM68kBank

	ld	l,(iy+1)					; Get background SFX data
	ld	h,(iy+2)
	push	hl
	pop	iy

	call	GetInstrumentsAddress				; Get instruments address

	ld	bc,4						; Get track metadata
	add	hl,bc

	ld	a,(iy+3)					; Get number of tracks
	or	a
	ret	z						; If there are none, exit
	ld	b,a
	
.InitTracks:
	push	hl						; Get channel type
	inc	hl
	ld	a,(hl)						; Is this a PSG track?
	cp	1<<PSG_TYPE
	jr	nc,.PsgTrack					; If so, branch

	ld	ix,z_music_fm4					; Set override flag for music track
	set	OVERRIDE_FLAG,(ix+zsnd.flags)
	
	ld	ix,z_sfx_bg_fm4					; Initialize FM
	jr	.OverrideDone

.PsgTrack:
	ld	ix,z_music_psg3					; Set override flag for music track
	set	OVERRIDE_FLAG,(ix+zsnd.flags)
	
	ld	ix,z_sfx_bg_psg3				; Initialize PSG

.OverrideDone:
	pop	hl						; Restore track metadata address

	ld	a,(ix+zsnd.flags)				; Set flags
	and	(1<<OVERRIDE_FLAG)|(1<<SFX_FLAG)|(1<<SFX_BG_FLAG)
	or	1<<PLAY_FLAG
	or	(hl)
	ld	(ix+zsnd.flags),a
	inc	hl
	inc	hl

	ld	a,(iy+2)					; Set tempo divider
	ld	(ix+zsnd.tempo_divider),a

	call	InitTrack					; Initialize track

.NextTrack:
	djnz	.InitTracks					; Loop until finished

	ld	ix,z_sfx_fm4					; Is SFX FM4 playing?
	bit	PLAY_FLAG,(ix+zsnd.flags)
	jr	z,.CheckBgSfxPsg				; If not, branch

	ld	ix,z_sfx_bg_fm4					; Set override flag for background SFX
	set	OVERRIDE_FLAG,(ix+zsnd.flags)

.CheckBgSfxPsg:
	ld	ix,z_sfx_psg3					; Is SFX PSG3 playing?
	bit	PLAY_FLAG,(ix+zsnd.flags)
	ret	z						; If not, exit

	ld	ix,z_sfx_bg_psg3				; Set override flag for background SFX
	set	OVERRIDE_FLAG,(ix+zsnd.flags)
	
	ld	a,(z_current_bank)				; Move bank out of danger zone
	push	af
	call	MoveBankForPsg

	ld	a,PSG3_TYPE|1Fh					; Silence PSG3 and noise
	rst	WritePsg
	ld	a,PSG4_TYPE|1Fh
	rst	WritePsg
	
	pop	af						; Restore bank
	jp	SetM68kBank

; ------------------------------------------------------------------------------
; Initialize track
; ------------------------------------------------------------------------------

InitTrack:
	push	bc						; Clear track variables
	push	hl
	ld	c,zsnd.panning
	call	GetTrackVariableHL
	ld	b,zsnd.struct_len-zsnd.panning
	xor	a

.ClearVariables:
	ld	(hl),a
	inc	hl
	djnz	.ClearVariables
	pop	hl
	pop	bc
	
	rst	ReadNextByteHL					; Set track data address
	ld	d,a
	rst	ReadNextByteHL
	ld	e,a
	push	iy
	add	iy,de
	push	iy
	pop	de
	pop	iy
	ld	(ix+zsnd.track_data_addr),e
	ld	(ix+zsnd.track_data_addr+1),d

	ld	a,(z_current_bank)				; Set track data bank
	ld	(ix+zsnd.track_data_bank),a
	
	rst	ReadNextByteHL					; Set transposition
	ld	(ix+zsnd.transpose),a

	rst	ReadNextByteHL					; Set volume
	ld	(ix+zsnd.volume),a

	ld	a,1						; Set note duration
	ld	(ix+zsnd.duration_timer),a

	ld	a,zsnd.call_stack_base				; Set call stack address
	ld	(ix+zsnd.call_stack_addr),a

	bit	PSG_TYPE,(ix+zsnd.channel)			; Is this a PSG track?
	ret	nz						; If so, branch
	
	ld	a,0C0h						; Set panning
	ld	(ix+zsnd.panning),a
	
	exx							; Set instruments address
	ld	(ix+zsnd.fm_instruments),e
	ld	(ix+zsnd.fm_instruments+1),d
	exx
	ret

; ------------------------------------------------------------------------------
; Get instruments address
; ------------------------------------------------------------------------------

GetInstrumentsAddress:
	push	hl						; Save registers
	
	ld	e,(iy+1)					; Get instruments address
	ld	d,(iy)
	add	hl,de

	push	hl						; Store it in de'
	exx
	pop	de
	exx

	pop	hl						; Restore registers
	ret

; ------------------------------------------------------------------------------
; Get SFX track table offset
; ------------------------------------------------------------------------------

GetSfxTrackOffset:
	cp	1<<PSG_TYPE					; Is this a PSG track?
	jr	nc,.PsgTrack					; If so, branch

	sub	2						; Get FM track table offset
	add	a,a
	ret

.PsgTrack:
	srl	a						; Get PSG track table offset
	srl	a
	srl	a
	srl	a
	ret

; ------------------------------------------------------------------------------
; Get associated music track for SFX track
; ------------------------------------------------------------------------------

GetSfxMusicTrack:
	call	GetSfxTrackOffset				; Get music track
	ld	hl,SfxMusicTracks
	
; ------------------------------------------------------------------------------
; Read indexed word value into HL
; ------------------------------------------------------------------------------

ReadIndexHL:
	add	a,l						; Get indexed address
	ld	l,a
	adc	a,h
	sub	l
	ld	h,a

; ------------------------------------------------------------------------------
; Read word from HL
; ------------------------------------------------------------------------------

ReadWordHL:
	rst	ReadNextByteHL					; Read value
	ld	h,(hl)
	ld	l,a
	ret
	
; ------------------------------------------------------------------------------
; Read indexed word value into DE
; ------------------------------------------------------------------------------

ReadIndexDE:
	ex	de,hl						; Read value
	call	ReadIndexHL
	ex	de,hl
	ret

; ------------------------------------------------------------------------------
; Get track variable address (HL)
; ------------------------------------------------------------------------------

GetTrackVariableHL:
	push	ix						; Go to track variable
	pop	hl
	ld	b,0
	add	hl,bc
	ret

; ------------------------------------------------------------------------------
; Get track variable address (IY)
; ------------------------------------------------------------------------------

GetTrackVariableIY:
	push	ix						; Go to track variable
	pop	iy
	ld	b,0
	add	iy,bc
	ret

; ------------------------------------------------------------------------------
; Read 16-bit track variable
; ------------------------------------------------------------------------------

ReadTrackVariableWord:
	call	GetTrackVariableIY				; Read track variable
	ld	l,(iy)
	ld	h,(iy+1)
	ret

; ------------------------------------------------------------------------------
; Write 16-bit track variable
; ------------------------------------------------------------------------------

WriteTrackVariableWord:
	call	GetTrackVariableIY				; Go to track variable
	ld	(iy),l
	ld	(iy+1),h
	ret

; ------------------------------------------------------------------------------
; Check if a track is an FM track
; ------------------------------------------------------------------------------

CheckFmTrack:
	ld	a,(ix+zsnd.channel)				; Is this an FM track?
	and	(1<<PSG_TYPE)|(1<<PWM_TYPE)
	ret

; ------------------------------------------------------------------------------
; SFX tracks
; ------------------------------------------------------------------------------

SfxMusicTracks:
	dw	z_music_fm3					; FM3
	dw	0
	dw	z_music_fm4					; FM4
	dw	z_music_fm5					; FM5
	dw	z_music_psg1					; PSG1
	dw	z_music_psg2					; PSG2
	dw	z_music_psg3					; PSG3
	dw	z_music_psg3					; Noise

SfxTracks:
	dw	z_sfx_fm3					; FM3
	dw	0
	dw	z_sfx_fm4					; FM4
	dw	z_sfx_fm5					; FM5
	dw	z_sfx_psg1					; PSG1
	dw	z_sfx_psg2					; PSG2
	dw	z_sfx_psg3					; PSG3
	dw	z_sfx_psg3					; Noise

; ------------------------------------------------------------------------------
; Update track
; ------------------------------------------------------------------------------

UpdateTrack:
	bit	PLAY_FLAG,(ix+zsnd.flags)			; Is this track playing?
	ret	z						; If not, exit

	ld	a,(ix+zsnd.track_data_bank)			; Set bank
	call	SetM68kBank

	dec	(ix+zsnd.duration_timer)			; Decrement note duration timer
	jp	nz,TrackNoteGoing				; If it hasn't run out, branch

	res	LEGATO_FLAG,(ix+zsnd.flags)			; Clear legato flag

	ld	c,zsnd.track_data_addr				; Get track data address
	call	ReadTrackVariableWord
	
	res	REST_FLAG,(ix+zsnd.flags)			; Clear rest flag

; ------------------------------------------------------------------------------
; Process track data
; ------------------------------------------------------------------------------

ProcessTrackData:
	ld	a,(hl)						; Get byte from track
	cp	TRACK_CMDS_START				; Is it a command?
	jr	c,.NotCommand					; If not, branch

	inc	hl						; Advance track data
	
	ld	de,ProcessTrackData				; Push return address
	push	de
	
	sub	TRACK_CMDS_START				; Get command
	add	a,a
	ld	de,TrackCommands
	call	ReadIndexDE
	
	rst	ReadNextByteHL					; Process command
	push	de
	ret

; ------------------------------------------------------------------------------

.NotCommand:
	call	CheckFmTrack					; Is this an FM track?
	call	z,FmKeyOff					; If so, set key off

	ld	a,(hl)						; Is it a duration value?
	cp	NOTES_START
	jr	c,.GotDuration					; If so, branch

	bit	PWM_TYPE,(ix+zsnd.channel)			; Is this a PWM track?
	jr	z,.NotPwmNote					; If not, branch
	
	ld	(ix+zsnd.pwm_sample),a				; Set sample ID
	jr	.GetDuration					; Get note duration

; ------------------------------------------------------------------------------

.NotPwmNote:
	sub	NOTES_START					; Get note ID
	jr	nz,.NotRest					; If it's not a rest note, branch
	
	ld	(ix+zsnd.frequency),a				; Clear note frequency
	ld	(ix+zsnd.frequency+1),a
	
	set	REST_FLAG,(ix+zsnd.flags)			; Set rest flag

	bit	PSG_TYPE,(ix+zsnd.channel)			; Is this a PSG track?
	call	nz,PsgKeyOff					; If so, set key off
	jr	.GetDuration					; Get note duration

.NotRest:
	add	a,(ix+zsnd.transpose)				; Get note
	add	a,a
	
	ld	de,PsgFrequencies-2				; PSG frequencies
	
	ex	af,af'						; Is AtGames mode enabled?
	ld	a,(z_atgames_mode)
	or	a
	jr	z,.GotPsgFreqTable				; If not, branch
	
	bit	SFX_FLAG,(ix+zsnd.flags)			; Is this an SFX track?
	jr	nz,.GotPsgFreqTable				; If so, branch

	ld	de,PsgFrequenciesAtGames-2			; Use AtGames PSG frequencies

.GotPsgFreqTable:
	ex	af,af'						; Restore AF
	ld	c,0						; Reset octave counter
	
	bit	PSG_TYPE,(ix+zsnd.channel)			; Is this a PSG track?
	jr	nz,.GetNoteFrequency				; If so, branch

.FmNote:
	ld	de,FmFrequencies				; FM frequencies
	
	ex	af,af'						; Is AtGames mode enabled?
	ld	a,(z_atgames_mode)
	or	a
	jr	z,.GotFmFreqTable				; If not, branch

	bit	SFX_FLAG,(ix+zsnd.flags)			; Is this an SFX track?
	jr	nz,.GotFmFreqTable				; If so, branch

	ld	de,FmFrequenciesAtGames				; Use AtGames FM frequencies

.GotFmFreqTable:
	ex	af,af'						; Restore AF
	ld	b,12*2						; 12 notes per octave

.GetFmOctave:
	sub	b						; Subtract 1 octave from the node
	jr	c,.GotFmOctave					; If we are done, branch
	inc	c						; Next octave
	jr	.GetFmOctave					; Loop until finished

.GotFmOctave:
	add	a,b						; Get note and octave
	sla	c
	sla	c
	sla	c

.GetNoteFrequency:
	call	ReadIndexDE					; Get note frequency
	ld	(ix+zsnd.frequency),e
	ld	a,d
	or	c
	ld	(ix+zsnd.frequency+1),a

; ------------------------------------------------------------------------------

.GetDuration:
	inc	hl						; Get byte from track
	ld	a,(hl)
	cp	NOTES_START					; Is it a duration value?
	jr	c,.GotDuration					; If so, branch

	jr	FinishTrackProcess				; Finish processing track

.GotDuration:
	inc	hl						; Got duration byte

	ld	b,(ix+zsnd.tempo_divider)			; Multiply tempo divider with duration
	ld	c,a
	jr	.StartMultiply

.Multiply:
	add	a,c

.StartMultiply:
	djnz	.Multiply
	ld	(ix+zsnd.duration),a				; Set note duration

; ------------------------------------------------------------------------------
; Finish track processing
; ------------------------------------------------------------------------------

FinishTrackProcess:
	ld	c,zsnd.track_data_addr				; Update track data address
	call	WriteTrackVariableWord

	ld	a,(ix+zsnd.duration)				; Set note duration
	ld	(ix+zsnd.duration_timer),a

	bit	PWM_TYPE,(ix+zsnd.channel)			; Is this a PWM track?
	jr	z,FinishFmPsgTrackProcess			; If not, branch

	ld	a,(ix+zsnd.pwm_sample)				; Get PWM sample
	sub	NOTES_START
	ret	z						; If it's a rest note, exit

	jp	PlayPwmSample					; Play sample

; ------------------------------------------------------------------------------
; Finish track processing for FM/PSG
; ------------------------------------------------------------------------------

FinishFmPsgTrackProcess:
	bit	LEGATO_FLAG,(ix+zsnd.flags)			; Is legato active?
	jr	nz,InitTrackNote				; If so, branch

	ld	a,(ix+zsnd.staccato)				; Reset staccato
	ld	(ix+zsnd.staccato_timer),a

	xor	a						; Reset PSG instrument cursor
	ld	(ix+zsnd.psg_cursor),a

	bit	VIBRATO_FLAG,(ix+zsnd.flags)			; Is vibrato active?
	jr	z,InitTrackNote					; If not, branch

	ld	(ix+zsnd.vibrato),a				; Reset vibrato value
	ld	(ix+zsnd.vibrato+1),a

	ld	c,zsnd.vibrato_params				; Reset vibrato parameters
	call	ReadTrackVariableWord
	dec	hl
	rst	ReadNextByteHL
	ld	(ix+zsnd.vibrato_wait),a
	rst	ReadNextByteHL
	ld	(ix+zsnd.vibrato_speed),a
	rst	ReadNextByteHL
	ld	(ix+zsnd.vibrato_delta),a
	rst	ReadNextByteHL
	srl	a
	ld	(ix+zsnd.vibrato_steps),a

; ------------------------------------------------------------------------------
; Initialize note
; ------------------------------------------------------------------------------

InitTrackNote:
	bit	PSG_TYPE,(ix+zsnd.channel)			; Is this a PSG track?
	jr	nz,.PsgNote					; If so, branch

; ------------------------------------------------------------------------------

.FmNote:
	call	GetNoteFrequency				; Get note frequency
	call	nz,UpdateFmFrequency				; If it's valid, initialize it
	
	ld	a,(ix+zsnd.flags)				; Is this track rested or being overridden?
	and	(1<<REST_FLAG)|(1<<OVERRIDE_FLAG)
	ret	nz						; If so, exit

	ld	a,(ix+zsnd.channel)				; Set key on
	or	0F0h
	ld	c,a
	jr	SetFmKeyOnOff

; ------------------------------------------------------------------------------

.PsgNote:
	call	GetNoteFrequency				; Get note frequency
	call	nz,UpdatePsgFrequency				; If it's valid, initialize it

; ------------------------------------------------------------------------------
; Update PSG instrument
; ------------------------------------------------------------------------------
	
UpdatePsgInstrument:
	ld	c,(ix+zsnd.volume)				; Get volume
	ld	a,(ix+zsnd.instrument)				; Get instrument
	or	a
	jr	z,SetPsgVolume					; If it's a straight tone, branch
	
	add	a,a						; Get instrument data				
	ld	hl,PsgInstruments-2
	call	ReadIndexHL

	ld	a,(ix+zsnd.psg_cursor)				; Get instrument byte
	ld	b,0
	ld	c,a
	add	hl,bc
	ld	a,(hl)

	or	a						; Is it the terminator?
	ret	m						; If so, exit

.GotVolume:
	inc	(ix+zsnd.psg_cursor)				; Advance PSG instrument cursor

	add	a,(ix+zsnd.volume)				; Add to volume
	ld	c,a
	cp	10h						; Has it overflown?
	jr	c,SetPsgVolume					; If so, branch
	ld	c,0Fh						; Cap at minimum volume

; ------------------------------------------------------------------------------
; Set PSG volume
; ------------------------------------------------------------------------------

SetPsgVolume:
	push	bc						; Save registers

	ld	a,(ix+zsnd.flags)				; Is this track rested or being overridden?
	ld	b,a
	and	(1<<REST_FLAG)|(1<<OVERRIDE_FLAG)
	jr	nz,.End						; If so, branch

	bit	LEGATO_FLAG,b					; Is legato active?
	jr	nz,.CheckStaccato				; If so, branch

.SetVolume:
	ld	a,(z_current_bank)				; Move bank out of danger zone
	push	af
	call	MoveBankForPsg

	ld	a,c						; Set volume
	or	(ix+zsnd.channel)
	add	a,10h
	rst	WritePsg

	pop	af						; Restore bank
	call	SetM68kBank
	jr	.End

.CheckStaccato:
	ld	a,(ix+zsnd.staccato)				; Is staccato active?
	or	a
	jr	z,.SetVolume					; If not, branch
	
	ld	a,(ix+zsnd.staccato_timer)			; Is staccato being processed?
	or	a
	jr	nz,.SetVolume					; If so, branch

.End:
	pop	bc						; Restore registers
	ret

; ------------------------------------------------------------------------------
; Note going
; ------------------------------------------------------------------------------

TrackNoteGoing:
	bit	PWM_TYPE,(ix+zsnd.channel)			; Is this a PWM track?
	ret	nz						; If so, exit

; ------------------------------------------------------------------------------
; Update staccato
; ------------------------------------------------------------------------------

UpdateTrackStaccato:
	ld	a,(ix+zsnd.staccato_timer)			; Is staccato active?
	or	a
	jr	z,NoTrackStaccato				; If not, exit
	dec	(ix+zsnd.staccato_timer)			; Decrement staccato timer
	jr	nz,NoTrackStaccato				; If it hasn't run out, exit

	set	REST_FLAG,(ix+zsnd.flags)			; Set rest flag

	bit	PSG_TYPE,(ix+zsnd.channel)			; Is this a PSG track?
	jr	nz,PsgKeyOff					; If so, set key off for PSG

; ------------------------------------------------------------------------------
; Set FM key off
; ------------------------------------------------------------------------------

FmKeyOff:
	ld	a,(ix+zsnd.flags)				; Is legato active or is this track being overridden?
	and	(1<<LEGATO_FLAG)|(1<<OVERRIDE_FLAG)
	ret	nz						; If so, exit

ForceFmKeyOff:
	ld	c,(ix+zsnd.channel)				; Set key off

SetFmKeyOnOff:
	ld	a,28h
	rst	WriteFmReg1
	ret

; ------------------------------------------------------------------------------
; Set PSG key off
; ------------------------------------------------------------------------------

PsgKeyOff:
	bit	OVERRIDE_FLAG,(ix+zsnd.flags)			; Is this track being overridden?
	ret	nz						; If so, exit

	ld	a,(z_current_bank)				; Move bank out of danger zone
	push	af
	call	MoveBankForPsg

	ld	a,(ix+zsnd.channel)				; Minimize volume
	or	1Fh
	rst	WritePsg

	cp	PSG3_TYPE|1Fh					; Were we silencing PSG3?
	jr	nz,.End						; If not, exit
	ld	a,PSG4_TYPE|1Fh					; Silence noise as well
	rst	WritePsg

.End:
	pop	af						; Restore bank
	jp	SetM68kBank

; ------------------------------------------------------------------------------
; Continue updating note without staccato
; ------------------------------------------------------------------------------

NoTrackStaccato:
	bit	PSG_TYPE,(ix+zsnd.channel)			; Is this a PSG track?
	jr	z,UpdateTrackVibrato				; If not, branch

	ld	a,(ix+zsnd.instrument)				; Update instrument if it's not a straight tone
	or	a
	call	nz,UpdatePsgInstrument

; ------------------------------------------------------------------------------
; Update vibrato
; ------------------------------------------------------------------------------

UpdateTrackVibrato:
	bit	VIBRATO_FLAG,(ix+zsnd.flags)			; Is vibrato active?
	ret	z						; If not, exit

	ld	a,(ix+zsnd.vibrato_wait)			; Has the wait timer run out?
	or	a
	jr	z,.WaitVibratoDone				; If not, branch
	dec	(ix+zsnd.vibrato_wait)				; Decrement wait timer
	ret

.WaitVibratoDone:
	dec	(ix+zsnd.vibrato_speed)				; Decrement speed counter
	ret	nz						; If it hasn't run out, exit

	ld	c,zsnd.vibrato_params				; Reset vibrato parameters
	call	ReadTrackVariableWord
	rst	ReadNextByteHL
	ld	(ix+zsnd.vibrato_speed),a

	ld	a,(ix+zsnd.vibrato_steps)			; Has the step counter run out?
	or	a
	jr	nz,.AddVibratoDelta				; If not, branch
	
	inc	hl						; Reset step counter
	rst	ReadNextByteHL
	ld	(ix+zsnd.vibrato_steps),a

	ld	a,(ix+zsnd.vibrato_delta)			; Reverse delta value
	neg
	ld	(ix+zsnd.vibrato_delta),a
	ret

.AddVibratoDelta:
	dec	(ix+zsnd.vibrato_steps)				; Decrement step counter

	ld	c,zsnd.vibrato					; Get vibrato value
	call	ReadTrackVariableWord

	ld	a,(ix+zsnd.vibrato_delta)			; Add delta
	ld	c,a
	add	a,a
	sbc	a,a
	ld	b,a
	add	hl,bc
	ld	(ix+zsnd.vibrato),l
	ld	(ix+zsnd.vibrato+1),h

	ld	c,(ix+zsnd.frequency)				; Add note frequency
	ld	b,(ix+zsnd.frequency+1)
	add	hl,bc

; ------------------------------------------------------------------------------
; Update frequency
; ------------------------------------------------------------------------------

UpdateTrackFrequency:
	bit	PSG_TYPE,(ix+zsnd.channel)			; Is this a PSG track?
	jr	z,UpdateFmFrequency				; If so, update FM frequency

; ------------------------------------------------------------------------------
; Update PSG frequency
; ------------------------------------------------------------------------------

UpdatePsgFrequency:
	ld	a,(ix+zsnd.flags)				; Is this track rested or being overridden?
	and	(1<<REST_FLAG)|(1<<OVERRIDE_FLAG)
	ret	nz						; If so, exit

	ld	a,(z_current_bank)				; Move bank out of danger zone
	push	af
	call	MoveBankForPsg

	call	AddDetune					; Add detune

	ld	a,(ix+zsnd.channel)				; Get channel ID
	cp	PSG4_TYPE					; Is this a noise track?
	jr	nz,.NotNoise					; If not, branch
	ld	a,PSG3_TYPE					; Use PSG3 channel ID

.NotNoise:
	ld	b,a						; Set lower frequency value
	ld	a,l
	and	0Fh
	or	b
	rst	WritePsg

	ld	b,4						; Set upper frequency value
	ld	a,l

.Rotate:
	srl	h
	rr	a
	djnz	.Rotate
	and	3Fh
	rst	WritePsg

	pop	af						; Restore bank
	jp	SetM68kBank

; ------------------------------------------------------------------------------
; Add detune to frequency
; ------------------------------------------------------------------------------

AddDetune:
	ld	a,(ix+zsnd.detune)				; Add detune
	ld	c,a
	add	a,a
	sbc	a,a
	ld	b,a
	add	hl,bc
	ret

; ------------------------------------------------------------------------------
; Update FM frequency
; ------------------------------------------------------------------------------

UpdateFmFrequency:
	bit	OVERRIDE_FLAG,(ix+zsnd.flags)			; Is this track being overridden?
	ret	nz						; If so, exit

	call	AddDetune					; Add detune

	ld	c,h						; Set upper frequency value
	ld	a,0A4h
	rst	WriteFmTrackReg

	ld	c,l						; Set lower frequency value
	ld	a,0A0h
	rst	WriteFmTrackReg
	ret

; ------------------------------------------------------------------------------
; Get note frequency
; ------------------------------------------------------------------------------

GetNoteFrequency:
	ld	c,zsnd.frequency				; Get note frequency
	call	ReadTrackVariableWord
	ld	a,h
	or	l
	ret	nz						; If it's valid, exit

	set	REST_FLAG,(ix+zsnd.flags)			; Set rest flag
	ret

; ------------------------------------------------------------------------------
; Get FM instrument
; ------------------------------------------------------------------------------

GetFmInstrument:
	ld	c,zsnd.fm_instruments				; Get instruments address
	call	GetTrackVariableHL
	call	ReadWordHL

	ld	b,(ix+zsnd.instrument)				; Multiply instrument ID by size of instrument
	inc	b
	ld	de,19h
	jr	.StartGet

.GetInstrument:
	add	hl,de

.StartGet:
	djnz	.GetInstrument
	ret

; ------------------------------------------------------------------------------
; Track commands
; ------------------------------------------------------------------------------

TrackCommands:
	dw	SndTrackCmd_Panning				; Set panning
	dw	SndTrackCmd_Detune				; Set detune
	dw	SndTrackCmd_Communication			; Set communication flag
	dw	SndTrackCmd_Return				; Return
	dw	SndTrackCmd_Dummy
	dw	SndTrackCmd_TempoDivider			; Set tempo divider
	dw	SndTrackCmd_Volume				; Set FM volume
	dw	SndTrackCmd_Legato				; Set legato
	dw	SndTrackCmd_Staccato				; Set staccato
	dw	SndTrackCmd_Transpose				; Transpose
	dw	SndTrackCmd_Tempo				; Set tempo
	dw	SndTrackCmd_TempoDividerAll			; Set tempo divider for all tracks
	dw	SndTrackCmd_Volume				; Set PSG volume
	dw	SndTrackCmd_Dummy
	dw	SndTrackCmd_Stop				; Stop background SFX FM4
	dw	SndTrackCmd_Instrument				; Set FM instrument
	dw	SndTrackCmd_Vibrato				; Set vibrato
	dw	SndTrackCmd_VibratoOn				; Enable vibrato
	dw	SndTrackCmd_Stop				; Stop track
	dw	SndTrackCmd_PsgNoise				; Set PSG noise
	dw	SndTrackCmd_VibratoOff				; Disable vibrato
	dw	SndTrackCmd_Instrument				; Set PSG instrument
	dw	SndTrackCmd_Jump				; Jump
	dw	SndTrackCmd_Repeat				; Repeat
	dw	SndTrackCmd_Call				; Call
	dw	SndTrackCmd_Dummy

; ------------------------------------------------------------------------------
; Set panning
; ------------------------------------------------------------------------------

SndTrackCmd_Panning:
	ld	(ix+zsnd.panning),a				; Set panning

	bit	PSG_TYPE,(ix+zsnd.channel)			; Is this a PSG track?
	ret	nz						; If so, exit
	bit	OVERRIDE_FLAG,(ix+zsnd.flags)			; Is this track being overridden?
	ret	nz						; If so, exit

	ld	c,a						; Set panning register
	ld	a,0B4h
	rst	WriteFmTrackReg
	
SndTrackCmd_Dummy:
	ret

; ------------------------------------------------------------------------------
; Set detune
; ------------------------------------------------------------------------------

SndTrackCmd_Detune:
	ld	(ix+zsnd.detune),a				; Set detune
	ret

; ------------------------------------------------------------------------------
; Set communication flag
; ------------------------------------------------------------------------------

SndTrackCmd_Communication:
	ld	(z_sound_communication),a			; Set communication flag
	ret

; ------------------------------------------------------------------------------
; Set tempo divider
; ------------------------------------------------------------------------------

SndTrackCmd_TempoDivider:
	ld	(ix+zsnd.tempo_divider),a			; Set tempo divider
	ret

; ------------------------------------------------------------------------------
; Set volume
; ------------------------------------------------------------------------------

SndTrackCmd_Volume:
	add	a,(ix+zsnd.volume)				; Add volume
	ld	(ix+zsnd.volume),a

	call	CheckFmTrack					; Is this an FM track?
	jr	z,SetFmVolume					; If so, branch

	bit	PWM_TYPE,a					; Is this a PWM track?
	ret	z						; If not, exit

; ------------------------------------------------------------------------------
; Set PWM volume/panning
; ------------------------------------------------------------------------------

SetPwmVolumePan:
	ld	a,0FFh						; We are just updating volume/panning

PlayPwmSample:
	call	SetPwmSampleReg					; Set sample ID

	push	bc						; Save registers

	ld	a,(ix+zsnd.volume)				; Convert volume
	xor	0Fh
	ld	b,a

	ld	c,(ix+zsnd.panning)				; Is left panning enabled?
	sla	c
	jr	nc,.CheckRight					; If not, branch
	
	add	a,a						; Add left bits
	add	a,a
	add	a,a
	add	a,a
	add	a,b

.CheckRight:
	sla	c						; Is right panning enabled?
	jr	c,.SetRegister					; If so, branch

	and	0F0h						; Mask out right bits

.SetRegister:
	pop	bc						; Restore registers

; ------------------------------------------------------------------------------
; Set PWM panning (and plays the sample)
; ------------------------------------------------------------------------------

SetPwmPanningReg:
	call	SetPwmCommRegBank				; Set panning
	ld	(M68K_BANK+5128h),a
	ret

; ------------------------------------------------------------------------------
; Set PWM sample ID
; ------------------------------------------------------------------------------

SetPwmSampleReg:
	call	SetPwmCommRegBank				; Set sample
	ld	(M68K_BANK+5129h),a
	ret

; ------------------------------------------------------------------------------
; Set PWM communication register bank
; ------------------------------------------------------------------------------

SetPwmCommRegBank:
	push	af						; Go to PWM communication register bank
	ld	a,(0A10000h/8000h)&0FFh
	call	SetM68kBank
	pop	af
	ret

; ------------------------------------------------------------------------------
; Set FM volume
; ------------------------------------------------------------------------------

SetFmVolume:
	bit	OVERRIDE_FLAG,(ix+zsnd.flags)			; Is this track being overridden?
	ret	nz						; If so, exit

	push	hl						; Save registers
	push	bc
	
	ld	a,(ix+zsnd.track_data_bank)			; Set bank
	call	SetM68kBank

	call	GetFmInstrument					; Get instrument volume data
	ld	de,21
	add	hl,de

	call	PrepFmVolumeOperators				; Prepare volume operators

.SetVolume:
	call	GetFmVolumeOperator				; Set volume register
	jr	nc,.NextOperator
	ld	a,(de)
	rst	WriteFmTrackReg

.NextOperator:
	inc	de						; Next operator
	djnz	.SetVolume					; Loop until finished

	pop	bc						; Restore registers
	pop	hl

	xor	a						; Make sure sign flag is cleared
	ret

; ------------------------------------------------------------------------------
; Prepare FM volume operators
; ------------------------------------------------------------------------------

PrepFmVolumeOperators:
	ld	a,(ix+zsnd.fm_algo_feedback)			; Get output operators
	and	7
	ld	c,a
	ld	b,0
	ld	iy,FmOutputOperators
	add	iy,bc
	ld	a,(iy)
	ld	(ix+zsnd.fm_outputs),a

	ld	de,FmVolumeOperators				; Volume operators
	ld	b,FmVolumeOperatorsEnd-FmVolumeOperators
	ret

; ------------------------------------------------------------------------------
; Get FM volume operators
; ------------------------------------------------------------------------------

GetFmVolumeOperator:
	rst	ReadNextByteHL					; Get volume register data
	ld	c,a

	rrc	(ix+zsnd.fm_outputs)				; Is this an output operator?
	ret	nc						; If not, exit

	add	a,(ix+zsnd.volume)				; Add volume
	ld	c,a
	ccf
	ret

; ------------------------------------------------------------------------------
; Set legato
; ------------------------------------------------------------------------------

SndTrackCmd_Legato:
	dec	hl						; Set legato flag
	set	LEGATO_FLAG,(ix+zsnd.flags)
	ret

; ------------------------------------------------------------------------------
; Set staccato
; ------------------------------------------------------------------------------

SndTrackCmd_Staccato:
	ld	(ix+zsnd.staccato),a				; Set staccato
	ld	(ix+zsnd.staccato_timer),a
	ret

; ------------------------------------------------------------------------------
; Transpose
; ------------------------------------------------------------------------------

SndTrackCmd_Transpose:
	add	a,(ix+zsnd.transpose)				; Add transposition
	ld	(ix+zsnd.transpose),a
	ret

; ------------------------------------------------------------------------------
; Set tempo
; ------------------------------------------------------------------------------

SndTrackCmd_Tempo:
	ld	(z_music_tempo),a				; Set staccato
	ld	(z_music_tempo_timer),a
	ret

; ------------------------------------------------------------------------------
; Set tempo divider for all tracks
; ------------------------------------------------------------------------------

SndTrackCmd_TempoDividerAll:
	ld	iy,z_music_tracks				; Music tracks
	ld	b,MUSIC_TRACK_COUNT

.SetTempoDivider:
	ld	(iy+zsnd.tempo_divider),a			; Set tempo divider
	ld	de,zsnd.struct_len				; Next track
	add	iy,de
	djnz	.SetTempoDivider				; Loop until finished
	ret

; ------------------------------------------------------------------------------
; Set vibrato
; ------------------------------------------------------------------------------

SndTrackCmd_Vibrato:
	ld	c,zsnd.vibrato_params				; Set vibrato parameters address
	call	WriteTrackVariableWord

	ld	(ix+zsnd.vibrato_wait),a			; Set vibrato parameters
	rst	ReadNextByteHL
	ld	(ix+zsnd.vibrato_speed),a
	rst	ReadNextByteHL
	ld	(ix+zsnd.vibrato_delta),a
	rst	ReadNextByteHL
	srl	a
	ld	(ix+zsnd.vibrato_steps),a
	
	xor	a						; Reset vibrato value
	ld	(ix+zsnd.vibrato),a
	ld	(ix+zsnd.vibrato+1),a

	inc	hl						; Make sure the next decrement doesn't mess things up

; ------------------------------------------------------------------------------
; Enable vibrato
; ------------------------------------------------------------------------------

SndTrackCmd_VibratoOn:
	dec	hl						; Set vibrato flag
	set	VIBRATO_FLAG,(ix+zsnd.flags)
	ret
	
; ------------------------------------------------------------------------------
; Stop SFX
; ------------------------------------------------------------------------------

StopSfx:
	ld	ix,z_sfx_tracks					; SFX tracks
	ld	b,SFX_TRACK_COUNT

.StopTracks:
	call	StopTrack					; Stop track
	
	rst	GetNextTrack					; Next track
	djnz	.StopTracks					; Loop until finished
	ret

; ------------------------------------------------------------------------------
; Stop background SFX
; ------------------------------------------------------------------------------

StopBackgroundSfx:
	ld	ix,z_sfx_bg_fm4					; Stop background SFX FM4
	call	StopTrack

.StopPsg:
	ld	ix,z_sfx_bg_psg3				; Stop background SFX PSG3
	jr	StopTrack

; ------------------------------------------------------------------------------
; Stop track
; ------------------------------------------------------------------------------

SndTrackCmd_Stop:
	inc	sp						; Exit out of track update function
	inc	sp

; ------------------------------------------------------------------------------
; Stop a track
; ------------------------------------------------------------------------------

StopTrack:
	bit	PLAY_FLAG,(ix+zsnd.flags)			; Is this track playing?
	ret	z						; If not, exit

	res	PLAY_FLAG,(ix+zsnd.flags)			; Stop playing track
	res	LEGATO_FLAG,(ix+zsnd.flags)			; Clear legato flag

	bit	PSG_TYPE,(ix+zsnd.channel)			; Is this a PSG track?
	jr	nz,.PsgKeyOff					; If so, branch
	bit	PWM_TYPE,(ix+zsnd.channel)			; Is this a PWM track?
	ret	nz						; If so, exit

	call	FmKeyOff					; Set key off
	jr	.StopTrack

.PsgKeyOff:
	call	PsgKeyOff					; Set key off

.StopTrack:
	ld	a,(ix+zsnd.channel)				; Get channel type

	bit	SFX_FLAG,(ix+zsnd.flags)			; Is this an SFX track?
	ret	z						; If not, exit
	bit	SFX_BG_FLAG,(ix+zsnd.flags)			; Is this a background SFX track?
	jr	nz,.StopBgSfx					; If not, branch
	
	cp	1<<PSG_TYPE					; Is this a PSG track?
	jr	nc,.StopSfxPsgTrack				; If so, branch

	push	ix						; Save SFX track

	cp	FM4_TYPE					; Is this FM4?
	jr	nz,.GetMusicFmTrack				; If not, branch
	
	ld	ix,z_sfx_bg_fm4					; Is background SFX FM4 playing?
	bit	PLAY_FLAG,(ix+zsnd.flags)
	jr	nz,.GotFmTrack					; If so, branch

.GetMusicFmTrack:
	call	GetSfxMusicTrack				; Get music track
	push	hl
	pop	ix

.GotFmTrack:
	res	OVERRIDE_FLAG,(ix+zsnd.flags)			; Stop overriding track
	set	REST_FLAG,(ix+zsnd.flags)			; Set track at rest

	call	LoadFmInstrument				; Load instrument
	
	pop	ix						; Restore SFX track
	ret

.StopSfxPsgTrack:
	ld	iy,z_sfx_bg_psg3				; Is background SFX PSG3 playing?
	bit	PLAY_FLAG,(iy+zsnd.flags)
	jr	z,.GetMusicPsgTrack				; If not, branch

	cp	PSG4_TYPE					; Is this a noise channel?
	jr	z,.GotPsgTrack					; If so, branch
	cp	PSG3_TYPE					; Is this PSG3?
	jr	z,.GotPsgTrack					; If so, branch

.GetMusicPsgTrack:
	call	GetSfxMusicTrack				; Get music track
	push	hl
	pop	iy

.GotPsgTrack:
	res	OVERRIDE_FLAG,(iy+zsnd.flags)			; Stop overriding track
	set	REST_FLAG,(iy+zsnd.flags)			; Set track at rest

	ld	a,(iy+zsnd.channel)				; Is this a noise channel?
	cp	PSG4_TYPE
	ret	nz						; If not, exit

	ld	a,(z_current_bank)				; Move bank out of danger zone
	push	af
	call	MoveBankForPsg

	ld	a,(iy+zsnd.psg_noise)				; Set noise mode
	rst	WritePsg

	pop	af						; Restore bank
	jp	SetM68kBank

; ------------------------------------------------------------------------------

.StopBgSfx:
	bit	OVERRIDE_FLAG,(ix+zsnd.flags)			; Is this track being overridden?
	ret	nz						; If so, exit

	cp	1<<PSG_TYPE					; Is this a PSG track?
	jr	nc,.StopBgSfxPsgTrack				; If so, branch

	push	ix						; Save SFX track

	ld	ix,z_music_fm4					; Music FM4 track
	res	OVERRIDE_FLAG,(ix+zsnd.flags)			; Stop overriding track
	set	REST_FLAG,(ix+zsnd.flags)			; Set track at rest

	bit	PLAY_FLAG,(ix+zsnd.flags)			; Is this track playing?
	jr	z,.BgSfxFmEnd					; If not, branch

	call	LoadFmInstrument				; Load instrument

.BgSfxFmEnd:
	pop	ix						; Restore SFX track
	ret

.StopBgSfxPsgTrack:
	ld	iy,z_music_psg3					; Music PSG3 track
	res	OVERRIDE_FLAG,(iy+zsnd.flags)			; Stop overriding track
	set	REST_FLAG,(iy+zsnd.flags)			; Set track at rest
	
	bit	PLAY_FLAG,(iy+zsnd.flags)			; Is this track playing?
	ret	z						; If not, exit

	ld	a,(iy+zsnd.channel)				; Is this a noise channel
	cp	PSG4_TYPE
	ret	nz						; If not, exit
	
	ld	a,(z_current_bank)				; Move bank out of danger zone
	push	af
	call	MoveBankForPsg

	ld	a,(iy+zsnd.psg_noise)				; Set noise mode
	rst	WritePsg

	pop	af						; Restore bank
	jp	SetM68kBank

; ------------------------------------------------------------------------------
; Set PSG noise
; ------------------------------------------------------------------------------

SndTrackCmd_PsgNoise:
	ld	b,PSG4_TYPE					; Get noise mode
	ld	(ix+zsnd.channel),b
	ld	(ix+zsnd.psg_noise),a
	ld	c,a

	bit	OVERRIDE_FLAG,(ix+zsnd.flags)			; Is this track being overridden?
	ret	nz						; If so, exit
	
	ld	a,(z_current_bank)				; Move bank out of danger zone
	push	af
	call	MoveBankForPsg

	ld	a,c						; Set noise mode
	rst	WritePsg

	pop	af						; Restore bank
	jp	SetM68kBank

; ------------------------------------------------------------------------------
; Disable vibrato
; ------------------------------------------------------------------------------

SndTrackCmd_VibratoOff:
	dec	hl						; Clear vibrato flag
	res	VIBRATO_FLAG,(ix+zsnd.flags)
	ret

; ------------------------------------------------------------------------------
; Set instrument
; ------------------------------------------------------------------------------

SndTrackCmd_Instrument:
	ld	(ix+zsnd.instrument),a				; Set instrument ID
	
	call	CheckFmTrack					; Is this an FM track?
	ret	nz						; If not, exit
	
	bit	OVERRIDE_FLAG,(ix+zsnd.flags)			; Is this track being overridden?
	ret	nz						; If so, exit

; ------------------------------------------------------------------------------
; Load FM instrument
; ------------------------------------------------------------------------------

LoadFmInstrument:
	push	hl						; Save registers
	push	bc

	ld	a,(ix+zsnd.track_data_bank)			; Set bank
	call	SetM68kBank

	call	GetFmInstrument					; Get instrument data

	rst	ReadNextByteHL					; Get feedback/algorithm
	ld	(ix+zsnd.fm_algo_feedback),a
	ld	c,a
	ld	a,0B0h
	call	WriteFmTrackReg

	ld	de,FmOperators					; FM operators
	ld	b,FmOperatorsEnd-FmOperators

.SetOperators:
	rst	ReadNextByteHL					; Set operator
	ld	c,a
	ld	a,(de)
	inc	de
	call	WriteFmTrackReg
	djnz	.SetOperators					; Loop until finished
	
	call	PrepFmVolumeOperators				; Prepare volume operators

.SetVolume:
	call	GetFmVolumeOperator				; Set volume register data
	ld	a,(de)
	inc	de
	rst	WriteFmTrackReg

	djnz	.SetVolume					; Loop until finished

	pop	bc						; Restore registers
	pop	hl

	jr	SetTrackPanning					; Set panning

; ------------------------------------------------------------------------------
; Unpause sound
; ------------------------------------------------------------------------------

Unpause:
	xor	a						; Clear pause flag
	ld	(z_sound_pause),a

	ld	ix,z_music_fm1-zsnd.struct_len			; Music FM tracks
	ld	b,MUSIC_FM_TRACK_COUNT

.MusicFmLoop:
	call	UnpauseTrack					; Unpause track
	djnz	.MusicFmLoop					; Loop until finished

	ld	ix,z_sfx_fm3-zsnd.struct_len			; SFX FM tracks
	ld	b,SFX_FM_TRACK_COUNT

.SfxFmLoop:
	call	UnpauseTrack					; Unpause track
	djnz	.SfxFmLoop					; Loop until finished

	ld	ix,z_sfx_bg_fm4-zsnd.struct_len			; Unpause background SFX FM track

; ------------------------------------------------------------------------------
; Unpause track
; ------------------------------------------------------------------------------

UnpauseTrack:
	rst	GetNextTrack					; Next track

	bit	PLAY_FLAG,(ix+zsnd.flags)			; Is this track playing?
	ret	z						; If not, exit
	bit	OVERRIDE_FLAG,(ix+zsnd.flags)			; Is this track being overridden?
	ret	nz						; If so, exit

; ------------------------------------------------------------------------------
; Set track panning
; ------------------------------------------------------------------------------

SetTrackPanning:
	ld	a,0B4h						; Set panning
	ld	c,(ix+zsnd.panning)
	rst	WriteFmTrackReg
	ret

; ------------------------------------------------------------------------------
; Repeat
; ------------------------------------------------------------------------------

SndTrackCmd_Repeat:
	ld	c,zsnd.loop_counters				; Get loop counter
	call	GetTrackVariableIY
	ld	c,a
	add	iy,bc

	rst	ReadNextByteHL					; Get repeat count
	ld	c,a

	ld	a,(iy)						; Has the loop started?
	or	a
	jr	nz,.Jump					; If so, branch
	ld	(iy),c						; Set loop count

.Jump:
	rst	ReadNextByteHL					; Read first byte of jump address
	dec	(iy)						; Decrement repeat count
	jr	nz,SndTrackCmd_Jump				; If it hasn't run out, branch

SkipTrackJumpAddress:
	inc	hl
	ret

; ------------------------------------------------------------------------------
; Return
; ------------------------------------------------------------------------------

SndTrackCmd_Return:
	ld	c,(ix+zsnd.call_stack_addr)			; Move call stack pointer
	call	GetTrackVariableHL
	inc	(ix+zsnd.call_stack_addr)
	inc	(ix+zsnd.call_stack_addr)

	call	ReadWordHL					; Pop return address
	jr	SkipTrackJumpAddress

; ------------------------------------------------------------------------------
; Call
; ------------------------------------------------------------------------------

SndTrackCmd_Call:
	dec	(ix+zsnd.call_stack_addr)			; Move call stack pointer
	dec	(ix+zsnd.call_stack_addr)
	ld	c,(ix+zsnd.call_stack_addr)
	call	GetTrackVariableIY
	
	ld	(iy),l						; Push return address
	ld	(iy+1),h

; ------------------------------------------------------------------------------
; Jump
; ------------------------------------------------------------------------------

SndTrackCmd_Jump:
	ld	b,a						; Jump
	ld	c,(hl)
	add	hl,bc
	ret

; ------------------------------------------------------------------------------
; Move bank for PSG access
; ------------------------------------------------------------------------------

MoveBankForPsg:
	push	af						; Move bank out of danger zone
	ld	a,(400000h/8000h)&0FFh
	call	SetM68kBank
	pop	af
	ret

; ------------------------------------------------------------------------------
; Note frequencies
; ------------------------------------------------------------------------------

FmFrequencies:
	dw	25Eh, 284h, 2ABh, 2D3h, 2FEh, 32Dh, 35Ch, 38Fh, 3C5h, 3FFh, 43Ch, 47Ch

PsgFrequencies:
	dw	356h, 326h, 2F9h, 2CEh, 2A5h, 280h, 25Ch, 23Ah, 21Ah, 1FBh, 1DFh, 1C4h
	dw	1ABh, 193h, 17Dh, 167h, 153h, 140h, 12Eh, 11Dh, 10Dh, 0FEh, 0EFh, 0E2h
	dw	0D6h, 0C9h, 0BEh, 0B4h, 0A9h, 0A0h, 097h, 08Fh, 087h, 07Fh, 078h, 071h
	dw	06Bh, 065h, 05Fh, 05Ah, 055h, 050h, 04Bh, 047h, 043h, 040h, 03Ch, 039h
	dw	036h, 033h, 030h, 02Dh, 02Bh, 028h, 026h, 024h, 022h, 020h, 01Fh, 01Dh
	dw	01Bh, 01Ah, 018h, 017h, 016h, 015h, 013h, 012h, 011h, 001h

FmFrequenciesAtGames:
	dw	1E5h, 203h, 222h, 242h, 265h, 28Bh, 2B0h, 2D9h, 304h, 333h, 364h, 397h

PsgFrequenciesAtGames:
	dw	3FFh, 3EEh, 3B6h, 380h, 34Dh, 31Fh, 2F2h, 2C7h, 29Fh, 279h, 256h, 234h
	dw	215h, 1F7h, 1DBh, 1C0h, 1A7h, 18Fh, 179h, 163h, 14Fh, 13Dh, 12Ah, 11Ah
	dw	10Bh, 0FBh, 0EDh, 0E0h, 0D3h, 0C7h, 0BCh, 0B2h, 0A8h, 09Eh, 095h, 08Dh
	dw	085h, 07Eh, 076h, 070h, 06Ah, 063h, 05Dh, 058h, 053h, 04Fh, 04Ah, 047h
	dw	043h, 03Fh, 03Bh, 038h, 035h, 031h, 02Fh, 02Ch, 02Ah, 027h, 026h, 024h
	dw	021h, 020h, 01Dh, 01Ch, 01Bh, 01Ah, 017h, 016h, 015h, 001h

; ------------------------------------------------------------------------------
; FM operators
; ------------------------------------------------------------------------------

FmOperators:
	db	30h, 38h, 34h, 3Ch
	db	50h, 58h, 54h, 5Ch
	db	60h, 68h, 64h, 6Ch
	db	70h, 78h, 74h, 7Ch
	db	80h, 88h, 84h, 8Ch
FmOperatorsEnd:

FmVolumeOperators:
	db	40h, 48h, 44h, 4Ch
FmVolumeOperatorsEnd:

; ------------------------------------------------------------------------------
; FM volume output operators
; ------------------------------------------------------------------------------

FmOutputOperators:
	db	1000b
	db	1000b
	db	1000b
	db	1000b
	db	1010b
	db	1110b
	db	1110b
	db	1111b

; ------------------------------------------------------------------------------
; PSG instruments
; ------------------------------------------------------------------------------

PsgInstruments:
	dw	PsgInstrument1
	dw	PsgInstrument2
	dw	PsgInstrument3
	dw	PsgInstrument4
	dw	PsgInstrument5
	dw	PsgInstrument6
	dw	PsgInstrument7
	dw	PsgInstrument8
	dw	PsgInstrument9

; ------------------------------------------------------------------------------

PsgInstrument1:
	db	00h, 00h, 00h, 01h, 01h, 01h, 02h, 02h, 02h, 03h, 03h, 03h
	db	04h, 04h, 04h, 05h, 05h, 05h, 06h, 06h, 06h, 07h, 0Fh, 80h

PsgInstrument2:
	db	00h, 02h, 04h, 06h, 08h, 10h, 80h

PsgInstrument3:
	db	00h, 00h, 01h, 01h, 02h, 02h, 03h, 03h, 04h, 04h, 05h, 05h
	db	06h, 06h, 07h, 07h, 80h

PsgInstrument4:
	db	00h, 00h, 02h, 03h, 04h, 04h, 05h, 05h, 05h, 06h, 80h

PsgInstrument5:
	db	00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 01h, 01h
	db	01h, 01h, 01h, 01h, 01h, 01h, 01h, 01h, 01h, 01h, 01h, 01h
	db	02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 03h, 03h, 03h, 03h
	db	03h, 03h, 03h, 03h, 04h, 80h

PsgInstrument6:
	db	03h, 03h, 03h, 02h, 02h, 02h, 02h, 01h, 01h, 01h, 00h, 00h
	db	00h, 00h, 80h

PsgInstrument7:
	db	00h, 00h, 00h, 00h, 00h, 00h, 01h, 01h, 01h, 01h, 01h, 02h
	db	02h, 02h, 02h, 02h, 03h, 03h, 03h, 04h, 04h, 04h, 05h, 05h
	db	05h, 06h, 07h, 80h

PsgInstrument8:
	db	00h, 00h, 00h, 00h, 00h, 01h, 01h, 01h, 01h, 01h, 02h, 02h
	db	02h, 02h, 02h, 02h, 03h, 03h, 03h, 03h, 03h, 04h, 04h, 04h
	db	04h, 04h, 05h, 05h, 05h, 05h, 05h, 06h, 06h, 06h, 06h, 06h
	db	07h, 07h, 07h, 80h

PsgInstrument9:
	db	00h, 01h, 02h, 03h, 04h, 05h, 06h, 07h, 08h, 09h, 0Ah, 0Bh
	db	0Ch, 0Dh, 0Eh, 0Fh, 80h

; ------------------------------------------------------------------------------

	if MOMPASS=1
		if $>(Z80_VARIABLES-STACK_SPACE)
			fatal "Z80 program takes up \{($-(Z80_VARIABLES-STACK_SPACE))}h too many bytes\n"
		endif
	endif

; ------------------------------------------------------------------------------
