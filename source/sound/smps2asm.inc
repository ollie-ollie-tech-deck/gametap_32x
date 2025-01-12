; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; SMPS2ASM macros, created by Flamewing
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; Note equates
; ------------------------------------------------------------------------------

	rsset $80
nRst			rs.b 1					; Rest note
nC0			rs.b 1					; C0
nCs0			rs.b 0					; C#0/Db0
nDb0			rs.b 1
nD0			rs.b 1					; D0
nDs0			rs.b 0					; D#0/Eb0
nEb0			rs.b 1
nE0			rs.b 1					; E0
nF0			rs.b 1					; F0
nFs0			rs.b 0					; F#0/Gb0
nGb0			rs.b 1
nG0			rs.b 1					; G0
nGs0			rs.b 0					; G#0/Ab0
nAb0			rs.b 1
nA0			rs.b 1					; A0
nAs0			rs.b 0					; A#0/Bb0
nBb0			rs.b 1
nB0			rs.b 1					; B0
nC1			rs.b 1					; C1
nCs1			rs.b 0					; C#1/Db1
nDb1			rs.b 1
nD1			rs.b 1					; D1
nDs1			rs.b 0					; D#1/Eb1
nEb1			rs.b 1
nE1			rs.b 1					; E1
nF1			rs.b 1					; F1
nFs1			rs.b 0					; F#1
nGb1			rs.b 1
nG1			rs.b 1					; G1
nGs1			rs.b 0					; G#1/Ab1
nAb1			rs.b 1
nA1			rs.b 1					; A1
nAs1			rs.b 0					; A#1/Bb1
nBb1			rs.b 1
nB1			rs.b 1					; B1
nC2			rs.b 1					; C2
nCs2			rs.b 0					; C#2/Db2
nDb2			rs.b 1
nD2			rs.b 1					; D2
nDs2			rs.b 0					; D#2/Eb2
nEb2			rs.b 1
nE2			rs.b 1					; E2
nF2			rs.b 1					; F2
nFs2			rs.b 0					; F#2/Gb2
nGb2			rs.b 1
nG2			rs.b 1					; G2
nGs2			rs.b 0					; G#2/Ab2
nAb2			rs.b 1
nA2			rs.b 1					; A2
nAs2			rs.b 0					; A#2/Bb2
nBb2			rs.b 1
nB2			rs.b 1					; B2
nC3			rs.b 1					; C3
nCs3			rs.b 0					; C#3/Db3
nDb3			rs.b 1
nD3			rs.b 1					; D3
nDs3			rs.b 0					; D#3/Eb3
nEb3			rs.b 1
nE3			rs.b 1					; E3
nF3			rs.b 1					; F3
nFs3			rs.b 0					; F#3/Gb3
nGb3			rs.b 1
nG3			rs.b 1					; G3
nGs3			rs.b 0					; G#3/Ab3
nAb3			rs.b 1
nA3			rs.b 1					; A3
nAs3			rs.b 0					; A#3/Bb3
nBb3			rs.b 1
nB3			rs.b 1					; B3
nC4			rs.b 1					; C4
nCs4			rs.b 0					; C#4/Db4
nDb4			rs.b 1
nD4			rs.b 1					; D4
nDs4			rs.b 0					; D#4/Eb4
nEb4			rs.b 1
nE4			rs.b 1					; E4
nF4			rs.b 1					; F4
nFs4			rs.b 0					; F#4/Gb4
nGb4			rs.b 1
nG4			rs.b 1					; G4
nGs4			rs.b 0					; G#4/Ab4
nAb4			rs.b 1
nA4			rs.b 1					; A4
nAs4			rs.b 0					; A#4/Bb4
nBb4			rs.b 1
nB4			rs.b 1					; B4
nC5			rs.b 1					; C5
nCs5			rs.b 0					; C#5/Db5
nDb5			rs.b 1
nD5			rs.b 1					; D5
nDs5			rs.b 0					; D#5/Eb5
nEb5			rs.b 1
nE5			rs.b 1					; E5
nF5			rs.b 1					; F5
nFs5			rs.b 0					; F#5/Gb5
nGb5			rs.b 1
nG5			rs.b 1					; G5
nGs5			rs.b 0					; G#5/Ab5
nAb5			rs.b 1
nA5			rs.b 1					; A5
nAs5			rs.b 0					; A#5/Bb5
nBb5			rs.b 1
nB5			rs.b 1					; B5
nC6			rs.b 1					; C6
nCs6			rs.b 0					; C#6/Db6
nDb6			rs.b 1
nD6			rs.b 1					; D6
nDs6			rs.b 0					; D#6/Eb6
nEb6			rs.b 1
nE6			rs.b 1					; E6
nF6			rs.b 1					; F6
nFs6			rs.b 0					; F#6/Gb6
nGb6			rs.b 1
nG6			rs.b 1					; G6
nGs6			rs.b 0					; G#6/Ab6
nAb6			rs.b 1
nA6			rs.b 1					; A6
nAs6			rs.b 0					; A#6/Bb6
nBb6			rs.b 1
nB6			rs.b 1					; B6
nC7			rs.b 1					; C7
nCs7			rs.b 0					; C#7/Db7
nDb7			rs.b 1
nD7			rs.b 1					; D7
nDs7			rs.b 0					; D#7/Eb7
nEb7			rs.b 1
nE7			rs.b 1					; E7
nF7			rs.b 1					; F7
nFs7			rs.b 0					; F#7/Gb7
nGb7			rs.b 1
nG7			rs.b 1					; G7
nGs7			rs.b 0					; G#7/Ab7
nAb7			rs.b 1
nA7			rs.b 1					; A7
nAs7			rs.b 0					; A#7/Bb7
nBb7			rs.b 1

; Standard octave pitch equates
smpsPitch10lo		equ $88					; -10
smpsPitch09lo		equ $94					; -9
smpsPitch08lo		equ $A0					; -8
smpsPitch07lo		equ $AC					; -7
smpsPitch06lo		equ $B8					; -6
smpsPitch05lo		equ $C4					; -5
smpsPitch04lo		equ $D0					; -4
smpsPitch03lo		equ $DC					; -3
smpsPitch02lo		equ $E8					; -2
smpsPitch01lo		equ $F4					; -1
smpsPitch00		equ $00					; 0
smpsPitch01hi		equ $0C					; +1
smpsPitch02hi		equ $18					; +2
smpsPitch03hi		equ $24					; +3
smpsPitch04hi		equ $30					; +4
smpsPitch05hi		equ $3C					; +5
smpsPitch06hi		equ $48					; +6
smpsPitch07hi		equ $54					; +7
smpsPitch08hi		equ $60					; +8
smpsPitch09hi		equ $6C					; +9
smpsPitch10hi		equ $78					; +10

; PSG conversion to S3/S&K/S3D/Chaotix drivers require a tone shift of 12 semi-tones.
psgdelta		equ 12

; SMPS2ASM uses nMaxPSG for songs from S1/S2 drivers.
; nMaxPSG1 and nMaxPSG2 are used only for songs from S3/S&K/S3D drivers.
; The use of psgdelta is intended to undo the effects of PSGPitchConvert
; and ensure that the ending note is indeed the maximum PSG frequency.
nMaxPSG			equ nA5
nMaxPSG1		equ nA5+psgdelta
nMaxPSG2		equ nA5+psgdelta

; ------------------------------------------------------------------------------
; PSG volume envelope equates
; ------------------------------------------------------------------------------

	rsreset
fTone_00		rs.b 1					; No envelope
fTone_01		rs.b 1					; Envelope #1
fTone_02		rs.b 1					; Envelope #2
fTone_03		rs.b 1					; Envelope #3
fTone_04		rs.b 1					; Envelope #4
fTone_05		rs.b 1					; Envelope #5
fTone_06		rs.b 1					; Envelope #6
fTone_07		rs.b 1					; Envelope #7
fTone_08		rs.b 1					; Envelope #8
fTone_09		rs.b 1					; Envelope #9
fTone_0A		rs.b 1					; Envelope #10
fTone_0B		rs.b 1					; Envelope #11
fTone_0C		rs.b 1					; Envelope #12
fTone_0D		rs.b 1					; Envelope #13
fTone_0E		rs.b 1					; Envelope #14

; ------------------------------------------------------------------------------
; DAC equates
; ------------------------------------------------------------------------------

	rsset $81
dKick			rs.b 1
dSnare			rs.b 1
dTimpani		rs.b 1
			rs.b 1
			rs.b 1
			rs.b 1
			rs.b 1
dHiTimpani		rs.b 1
dMidTimpani		rs.b 1
dLowTimpani		rs.b 1
dVLowTimpani		rs.b 1

; ------------------------------------------------------------------------------
; Channel IDs for SFX
; ------------------------------------------------------------------------------

cPSG1			equ $80
cPSG2			equ $A0
cPSG3			equ $C0
cNoise			equ $E0					; Not for use in S3/S&K/S3D
cFM3			equ $02
cFM4			equ $04
cFM5			equ $05
cFM6			equ $06					; Only in S3/S&K/S3D, overrides DAC

; ------------------------------------------------------------------------------
; Conversion macros
; ------------------------------------------------------------------------------

s2TempotoS1 macro n
	__s2TempotoS1_result: = (((768-(\n))>>1)/(256-(\n)))&$FF
	endm
	
s3TempotoS2 macro n
	__s3TempotoS2_result: = ($100-((((\n)=0)&1)|(\n)))&$FF
	endm
	
s3TempotoS1 macro n
	s3TempotoS2 \n
	s2TempotoS1 __s3TempotoS2_result
	__s3TempotoS1_result: = __s2TempotoS1_result
	endm
	
convertMainTempoMod macro mod
	if SourceDriver=1
		if (\mod)=1
			inform 3,"Invalid main tempo of 1 in song from Sonic 1"
		endif
		dc.b	\mod
	elseif SourceDriver=2
		if (\mod)=0
			inform 3,"Invalid main tempo of 0 in song from Sonic 2"
		endif
		s2TempotoS1 \mod
		dc.b	__s2TempotoS1_result
	else;if SourceDriver>=3
		s3TempotoS1 \mod
		dc.b	__s3TempotoS1_result
	endif
	endm
	
; PSG conversion requires a tone shift of 12 semi-tones.
PSGPitchConvert macro pitch
	if SourceDriver>=3
		dc.b	((\pitch)-psgdelta)&$FF
	else
		dc.b	\pitch
	endif
	endm

; ------------------------------------------------------------------------------
; Header macros
; ------------------------------------------------------------------------------

__song_num: = 0
smpsHeaderStartSong macro ver
	SourceDriver: = \ver
	__song_num: = __song_num+1
	songStart_\#__song_num\: equ *
	endm

smpsHeaderVoiceNull macro
	dc.w	0
	endm
	
; Header - Set up Voice Location
; Common to music and SFX
smpsHeaderVoice macro loc
	dc.w	(\loc)-songStart_\#__song_num
	endm

; Header macros for music (not for SFX)
; Header - Set up Channel Usage
smpsHeaderChan macro fm,psg
	dc.b	\fm, \psg
	endm

; Header - Set up Tempo
smpsHeaderTempo macro div,mod
	dc.b	\div
	convertMainTempoMod \mod
	endm

; Header - Set up DAC Channel
smpsHeaderDAC macro loc,pitch,vol
	dc.w	(\loc)-songStart_\#__song_num
	if narg>1
		dc.b	\pitch
		if narg>2
			dc.b	\vol
		else
			dc.b	0
		endif
	else
		dc.b	0, 0
	endif
	endm

; Header - Set up FM Channel
smpsHeaderFM macro loc,pitch,vol
	dc.w	(\loc)-songStart_\#__song_num
	dc.b	\pitch, \vol
	endm

; Header - Set up PSG Channel
smpsHeaderPSG macro loc,pitch,vol,mod,voice
	dc.w	(\loc)-songStart_\#__song_num
	PSGPitchConvert \pitch
	dc.b	\vol, \mod, \voice
	endm

; Header macros for SFX (not for music)
; Header - Set up Tempo
smpsHeaderTempoSFX macro div
	dc.b	\div
	endm

; Header - Set up Channel Usage
smpsHeaderChanSFX macro chan
	dc.b	\chan
	endm

; Header - Set up FM Channel
smpsHeaderSFXChannel macro chanid,loc,pitch,vol
	if (\chanid)=cFM6
		inform 3,"Using channel ID of FM6 ($06) in Sonic 1 or Sonic 2 drivers is unsupported. Change it to another channel."
	endif
	dc.b	$80, \chanid
	dc.w	(\loc)-songStart_\#__song_num
	if ((\chanid)&$80)<>0
		PSGPitchConvert \pitch
	else
		dc.b	\pitch
	endif
	dc.b	\vol
	endm

; ------------------------------------------------------------------------------
; Track commands
; ------------------------------------------------------------------------------

; E0xx - Panning, AMS, FMS
smpsPan macro direction,amsfms
panNone = $00
panRight = $40
panLeft = $80
panCentre = $C0
panCenter = $C0 ; silly Americans :U
	dc.b	$E0,(\direction)+(\amsfms)
	endm
	
; E1xx - Set channel detune to val
smpsDetune macro val
	dc.b	$E1, \val
	endm

; E2xx - Useless
smpsNop macro val
	dc.b	$E2, \val
	endm

; E3 - Return (used after smpsCall)
smpsReturn macro val
	dc.b	$E3
	endm
	
; E5xx - Set channel tempo divider to xx
smpsChanTempoDiv macro val
	dc.b	$E5, \val
	endm

; E6xxyy - Alter volume
smpsAlterVol macro val
	dc.b	$E6, \val
	endm

; E7 - Prevent attack of next note
smpsNoAttack		equ $E7

; E8xx - Set note fill to xx
smpsNoteFill macro val
	if SourceDriver>=3
		inform 0,"Note fill will not work as intended unless you multiply the fill value by the tempo divider or complain to Flamewing to add an appropriate coordination flag for it."
	endif
	dc.b	$E8, \val
	endm

; E9xx - Add xx to channel pitch
smpsChangeTransposition macro val
	dc.b	$E9, \val
	endm

; EAxx - Set music tempo modifier to xx
smpsSetTempoMod macro mod
	dc.b	$EA
	convertMainTempoMod \mod
	endm
	
; EBxx - Set music tempo divider to xx
smpsSetTempoDiv macro val
	dc.b	$EB, \val
	endm

; ECxx - Alter PSG volume
smpsPSGAlterVol macro vol
	dc.b	$EC, \vol
	endm

smpsPSGAlterVolS2 macro vol
	; Sonic 2's driver allows the FM command to be used on PSG channels, but others do not.
	if SonicDriverVer=2
		smpsAlterVol \vol
	else
		smpsPSGAlterVol \vol
	endif
	endm

; EE - Stops special SFX (S1 only) and restarts overridden music track
smpsStopSpecial macro
	dc.b	$EE
	endm

; EFxx - Set Voice of FM channel to xx
smpsFMvoice macro voice
	dc.b	$EF, \voice
	endm
	
; F0wwxxyyzz - Modulation - ww: wait time - xx: modulation speed - yy: change per step - zz: number of steps
smpsModSet macro wait,speed,change,step
	dc.b	$F0
	if SourceDriver>=3
		dc.b	(\wait)-1, \speed, \change
		conv0To256 \step
		.step: = __conv0To256_result
		conv0To256 \speed
		dc.b	(.step/__conv0To256_result)-1
	else
		dc.b	\wait, \speed, \change, \step
	endif
	;dc.b	\speed, \change, \step
	endm
	
; F1xxyy - Turn on Modulation
smpsModOn macro
	dc.b	$F1
	endm

; F2 - End of channel
smpsStop macro
	dc.b	$F2
	endm

; F3xx - PSG waveform to xx
smpsPSGform macro form
	dc.b	$F3, \form
	endm
	
; F4 - Turn off Modulation
smpsModOff macro
	dc.b	$F4
	endm

; F5xx - PSG voice to xx
smpsPSGvoice macro voice
	dc.b	$F5, \voice
	endm

; F6xxxx - Jump to xxxx
smpsJump macro loc
	dc.b	$F6
	dc.w	(\loc)-*-1
	endm

; F7xxyyzzzz - Loop back to zzzz yy times, xx being the loop index for loop recursion fixing
smpsLoop macro index,loops,loc
	dc.b	$F7
	dc.b	\index, \loops
	dc.w	(\loc)-*-1
	endm

; F8xxxx - Call pattern at xxxx, saving return point
smpsCall macro loc
	dc.b	$F8
	dc.w	(\loc)-*-1
	endm

; F9 - Set max release rate
smpsMaxRelRate macro
	dc.b	$F9
	endm

; ------------------------------------------------------------------------------
; Backwards compatibility
; ------------------------------------------------------------------------------

smpsAlterNote macro val
	smpsDetune \val
	endm

smpsAlterPitch macro val
	smpsChangeTransposition \val
	endm

smpsWeirdD1LRR macro
	smpsMaxRelRate
	endm

smpsSetvoice macro voice
	smpsFMvoice \voice
	endm
	
; ------------------------------------------------------------------------------
; FM instruments
; ------------------------------------------------------------------------------

; Voices - Feedback
smpsVcFeedback macro val
	vcFeedback: = \val
	endm

; Voices - Algorithm
smpsVcAlgorithm macro val
	vcAlgorithm: = \val
	endm

smpsVcUnusedBits macro val,d1r1,d1r2,d1r3,d1r4
	vcUnusedBits: = \val
	if narg>1
		vcD1R1Unk: = (\d1r1)<<5
		vcD1R2Unk: = (\d1r2)<<5
		vcD1R3Unk: = (\d1r3)<<5
		vcD1R4Unk: = (\d1r4)<<5
	else
		vcD1R1Unk: = 0
		vcD1R2Unk: = 0
		vcD1R3Unk: = 0
		vcD1R4Unk: = 0
	endif
	endm

; Voices - Detune
smpsVcDetune macro op1,op2,op3,op4
	vcDT1: = \op1
	vcDT2: = \op2
	vcDT3: = \op3
	vcDT4: = \op4
	endm

; Voices - Coarse-Frequency
smpsVcCoarseFreq macro op1,op2,op3,op4
	vcCF1: = \op1
	vcCF2: = \op2
	vcCF3: = \op3
	vcCF4: = \op4
	endm

; Voices - Rate Scale
smpsVcRateScale macro op1,op2,op3,op4
	vcRS1: = \op1
	vcRS2: = \op2
	vcRS3: = \op3
	vcRS4: = \op4
	endm

; Voices - Attack Rate
smpsVcAttackRate macro op1,op2,op3,op4
	vcAR1: = \op1
	vcAR2: = \op2
	vcAR3: = \op3
	vcAR4: = \op4
	endm

; Voices - Amplitude Modulation
; The original SMPS2ASM erroneously assumed the 6th and 7th bits
; were the Amplitude Modulation.
; According to several docs, however, it's actually the high bit.
smpsVcAmpMod macro op1,op2,op3,op4
	vcAM1: = (\op1)<<5
	vcAM2: = (\op2)<<5
	vcAM3: = (\op3)<<5
	vcAM4: = (\op4)<<5
	endm

; Voices - First Decay Rate
smpsVcDecayRate1 macro op1,op2,op3,op4
	vcD1R1: = \op1
	vcD1R2: = \op2
	vcD1R3: = \op3
	vcD1R4: = \op4
	endm

; Voices - Second Decay Rate
smpsVcDecayRate2 macro op1,op2,op3,op4
	vcD2R1: = \op1
	vcD2R2: = \op2
	vcD2R3: = \op3
	vcD2R4: = \op4
	endm

; Voices - Decay Level
smpsVcDecayLevel macro op1,op2,op3,op4
	vcDL1: = \op1
	vcDL2: = \op2
	vcDL3: = \op3
	vcDL4: = \op4
	endm

; Voices - Release Rate
smpsVcReleaseRate macro op1,op2,op3,op4
	vcRR1: = \op1
	vcRR2: = \op2
	vcRR3: = \op3
	vcRR4: = \op4
	endm

; Voices - Total Level
; The original SMPS2ASM decides TL high bits automatically,
; but later versions leave it up to the user.
; Alternatively, if we're converting an SMPS 68k song to SMPS Z80,
; then we *want* the TL bits to match the algorithm, because SMPS 68k
; prefers the algorithm over the TL bits, ignoring the latter, while
; SMPS Z80 does the opposite.
; Unfortunately, there's nothing we can do if we're trying to convert
; an SMPS Z80 song to SMPS 68k. It will ignore the bits no matter
; what we do, so we just print a warning.
smpsVcTotalLevel macro op1,op2,op3,op4
	vcTL1: = \op1
	vcTL2: = \op2
	vcTL3: = \op3
	vcTL4: = \op4
	dc.b	(vcUnusedBits<<6)+(vcFeedback<<3)+vcAlgorithm
;   0     1     2     3     4     5     6     7
;%1000,%1000,%1000,%1000,%1010,%1110,%1110,%1111
	vcTLMask4: = 0
	vcTLMask3: = 0
	vcTLMask2: = 0
	vcTLMask1: = 0

	if SourceDriver<3
		vcTLMask4: = (((vcAlgorithm=7)&1)<<7)
		vcTLMask3: = (((vcAlgorithm>=4)&1)<<7)
		vcTLMask2: = (((vcAlgorithm>=5)&1)<<7)
		vcTLMask1: = 128
		vcTL1: = vcTL1&127
		vcTL2: = vcTL2&127
		vcTL3: = vcTL3&127
		vcTL4: = vcTL4&127
	endif

	dc.b	(vcDT4<<4)+vcCF4,       (vcDT3<<4)+vcCF3,       (vcDT2<<4)+vcCF2,       (vcDT1<<4)+vcCF1
	dc.b	(vcRS4<<6)+vcAR4,       (vcRS3<<6)+vcAR3,       (vcRS2<<6)+vcAR2,       (vcRS1<<6)+vcAR1
	dc.b	vcAM4|vcD1R4|vcD1R4Unk, vcAM3|vcD1R3|vcD1R3Unk, vcAM2|vcD1R2|vcD1R2Unk, vcAM1|vcD1R1|vcD1R1Unk
	dc.b	vcD2R4,                 vcD2R3,                 vcD2R2,                 vcD2R1
	dc.b	(vcDL4<<4)+vcRR4,       (vcDL3<<4)+vcRR3,       (vcDL2<<4)+vcRR2,       (vcDL1<<4)+vcRR1
	dc.b	vcTL4|vcTLMask4,        vcTL3|vcTLMask3,        vcTL2|vcTLMask2,        vcTL1|vcTLMask1
	endm

; ------------------------------------------------------------------------------
