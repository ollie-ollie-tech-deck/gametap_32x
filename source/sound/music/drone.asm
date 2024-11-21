drone_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     drone_Voices
	smpsHeaderChan      $02, $03
	smpsHeaderTempo     $02, $08

	smpsHeaderDAC       drone_DAC
	smpsHeaderFM        drone_FM1,	$00, $12
	smpsHeaderPSG       drone_PSG1,	$00, $00, $00, $00
	smpsHeaderPSG       drone_PSG2,	$00, $00, $00, $00
	smpsHeaderPSG       drone_PSG3,	$00, $00, $00, $00

; FM1 Data
drone_FM1:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	smpsAlterVol        $02
	dc.b	nFs2, $18

drone_Jump00:
	dc.b	smpsNoAttack, $18
	smpsJump            drone_Jump00

; PSG3 Data
drone_PSG3:
	smpsPSGform         $E7
	smpsPSGAlterVol     $08
	dc.b	nMaxPSG, $18

drone_Jump01:
	dc.b	smpsNoAttack, $18
	smpsJump            drone_Jump01

; DAC Data
drone_DAC:
; PSG1 Data
drone_PSG1:
; PSG2 Data
drone_PSG2:
	smpsStop

drone_Voices:
;	Voice $00
;	$3A
;	$32, $01, $52, $31, 	$1F, $1F, $1F, $18, 	$01, $1F, $00, $00
;	$00, $0F, $00, $00, 	$5A, $0F, $03, $1A, 	$3B, $30, $4F, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $05, $00, $03
	smpsVcCoarseFreq    $01, $02, $01, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $18, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $1F, $01
	smpsVcDecayRate2    $00, $00, $0F, $00
	smpsVcDecayLevel    $01, $00, $00, $05
	smpsVcReleaseRate   $0A, $03, $0F, $0A
	smpsVcTotalLevel    $00, $4F, $30, $3B

