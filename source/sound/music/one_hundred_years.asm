onehundredyears_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     onehundredyears_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $09

	smpsHeaderDAC       onehundredyears_DAC
	smpsHeaderFM        onehundredyears_FM1,	$00, $0E
	smpsHeaderFM        onehundredyears_FM2,	$00, $11
	smpsHeaderFM        onehundredyears_FM3,	$00, $11
	smpsHeaderFM        onehundredyears_FM4,	$00, $0F
	smpsHeaderFM        onehundredyears_FM5,	$00, $0F
	smpsHeaderPSG       onehundredyears_PSG1,	$00, $03, $00, $00
	smpsHeaderPSG       onehundredyears_PSG2,	$00, $02, $00, $00
	smpsHeaderPSG       onehundredyears_PSG3,	$00, $02, $00, fTone_02

; DAC Data
onehundredyears_DAC:
	smpsPan             panCenter, $00
	dc.b	dKick

onehundredyears_Loop00:
	dc.b	$0C, dSnare, $06, dKick, $03, $03, $0C, dSnare, $03, $09, dKick, $0C
	dc.b	dSnare, $06, dKick, $03, $03, $06, dHiTimpani, $03, $03, dSnare, $06

onehundredyears_Loop01:
	dc.b	dKick, $03, $03
	smpsLoop            $00, $03, onehundredyears_Loop00
	dc.b	$0C, dSnare, $06, dKick, $03, $03, $0C, dSnare, $03, $09, dKick, $0C
	dc.b	dSnare, $06, dKick, $03, $03, $06, dHiTimpani, $03, $03

onehundredyears_Jump00:
	dc.b	dSnare, $06
	smpsLoop            $01, $07, onehundredyears_Loop01
	dc.b	dKick, $03, $03, $0C, dSnare, $06, dKick, $03, $03, $0C, dSnare, $03
	dc.b	$09, dKick, $0C, dSnare, $06, dKick, $03, $03, $06, dHiTimpani, $03, $03

onehundredyears_Loop02:
	dc.b	dSnare, $06, dKick, $03, $03, $0C
	smpsLoop            $00, $02, onehundredyears_Loop02
	dc.b	dSnare, $03, $09, dKick, $0C, dSnare, $06, dKick, $03, $03, $06, dHiTimpani
	dc.b	$03, $03
	smpsJump            onehundredyears_Jump00

; FM1 Data
onehundredyears_FM1:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nRst, $7F, $35

onehundredyears_Loop1E:
	dc.b	nA1, $06, nB1, nC2, $53, nRst, $01, nC2, $0C, nB1, $53, nRst
	dc.b	$01

onehundredyears_Jump05:
	dc.b	nA1, $06, nB1, nC2, $51, nRst, $03, nC2, $0C, nB1, $54, nA1
	dc.b	$06, nB1, nC2, $53, nRst, $01, nC2, $0C, nB1, $54, nA1, $06
	dc.b	nB1, nC2, $54, $0C, nB1, $50, nRst, $04
	smpsLoop            $00, $02, onehundredyears_Loop1E
	dc.b	nA1, $06, nB1, nBb1, $2E, nRst, $02, nBb1, $2C, nRst, $04, nBb1
	dc.b	$2C, nRst, $04, nBb1, $30, $2F, nRst, $01, nBb1, $2E, nRst, $02
	dc.b	nBb1, $2E, nRst, $02, nBb1, $24, nA1, $06, nB1, nC2, $53, nRst
	dc.b	$01, nC2, $0C, nB1, $53, nRst, $01
	smpsJump            onehundredyears_Jump05

; FM2 Data
onehundredyears_FM2:
	smpsPan             panLeft, $00
	smpsSetvoice        $01
	dc.b	nRst, $7F, $41, nEb4, $06, nD4, nEb4, $05, nRst, $01

onehundredyears_Loop17:
	dc.b	nD4, $06, nEb4
	smpsLoop            $00, $05, onehundredyears_Loop17
	dc.b	nD4, nC4, nB3, $5A

onehundredyears_Jump04:
	dc.b	smpsNoAttack, $0C

onehundredyears_Loop18:
	dc.b	nEb4, $05, nRst, $01, nD4, $06, nEb4, nD4, nEb4, nD4
	smpsLoop            $00, $02, onehundredyears_Loop18
	dc.b	nEb4, nD4, nC4, nB3, $18, nAb4, nG4, nAb4, $0C, $06, nG4, $0C

onehundredyears_Loop19:
	dc.b	nEb4, $06, nD4
	smpsLoop            $00, $07, onehundredyears_Loop19
	dc.b	nC4, nB3, $66

onehundredyears_Loop1A:
	dc.b	nEb4, $06, nD4
	smpsLoop            $00, $07, onehundredyears_Loop1A
	dc.b	nC4, nB3, $18, nAb4, nG4, nAb4, $0C, $06, nG4, $17, nRst, $01
	smpsSetvoice        $00
	smpsAlterVol        $FE

onehundredyears_Loop1B:
	dc.b	nG2, $06, nEb3, $11, nRst, $01, nG2, $0C, nRst
	smpsLoop            $00, $0F, onehundredyears_Loop1B
	dc.b	nG2, $06, nEb3, $11, nRst, $01, nG2, $0C, $0C, nD3, $06, nG2
	dc.b	$12, nD3, $06, nG2, $21, nRst, $03

onehundredyears_Loop1C:
	dc.b	nD3, $12, nG2, $1E
	smpsLoop            $00, $04, onehundredyears_Loop1C
	dc.b	nD3, $08, nRst, $04, nD3, $06, nG2, $1C, nRst, $02, nD3, $0A
	dc.b	nRst, $02, nD3, $06, nG2, $1D, nRst, $01, nD3, $12
	smpsSetvoice        $01
	smpsAlterVol        $02
	dc.b	nEb4, $06, nD4, nEb4, $05, nRst, $01

onehundredyears_Loop1D:
	dc.b	nD4, $06, nEb4
	smpsLoop            $00, $05, onehundredyears_Loop1D
	dc.b	nD4, nC4, nB3, $5A
	smpsJump            onehundredyears_Jump04

; FM3 Data
onehundredyears_FM3:
	smpsPan             panRight, $00
	smpsAlterNote       $04
	smpsSetvoice        $01
	dc.b	nRst, $7F, $41, nEb4, $06, nD4, nEb4, $05, nRst, $01

onehundredyears_Loop0F:
	dc.b	nD4, $06, nEb4
	smpsLoop            $00, $05, onehundredyears_Loop0F
	dc.b	nD4, nC4, nB3, $5A

onehundredyears_Jump03:
	dc.b	smpsNoAttack, $0C

onehundredyears_Loop10:
	dc.b	nEb4, $05, nRst, $01, nD4, $06, nEb4, nD4, nEb4, nD4
	smpsLoop            $00, $02, onehundredyears_Loop10
	dc.b	nEb4, nD4, nC4, nB3, $18, nAb4, nG4, nAb4, $0C, $06, nG4, $0C

onehundredyears_Loop11:
	dc.b	nEb4, $06, nD4
	smpsLoop            $00, $07, onehundredyears_Loop11
	dc.b	nC4, nB3, $66

onehundredyears_Loop12:
	dc.b	nEb4, $06, nD4
	smpsLoop            $00, $07, onehundredyears_Loop12
	dc.b	nC4, nB3, $18, nAb4, nG4, nAb4, $0C, $06, nG4, $17, nRst, $01
	smpsSetvoice        $00
	dc.b	$01
	smpsAlterVol        $FE

onehundredyears_Loop13:
	dc.b	nG2, $06, nEb3, $11, nRst, $01, nG2, $0C, nRst
	smpsLoop            $00, $03, onehundredyears_Loop13
	dc.b	nG2, $06, nEb3, $11, nRst, $01, nG2, $0B, nRst, $0D
	smpsLoop            $01, $03, onehundredyears_Loop13

onehundredyears_Loop14:
	dc.b	nG2, $06, nEb3, $11, nRst, $01, nG2, $0C, nRst
	smpsLoop            $00, $03, onehundredyears_Loop14
	dc.b	nG2, $06, nEb3, $11, nRst, $01, nG2, $0B, nRst, $0C, nD3, $06
	dc.b	nG2, $12, nD3, $06, nG2, $21, nRst, $03

onehundredyears_Loop15:
	dc.b	nD3, $12, nG2, $1E
	smpsLoop            $00, $04, onehundredyears_Loop15
	dc.b	nD3, $09, nRst, $03, nD3, $06, nG2, $1D, nRst, $01, nD3, $0A
	dc.b	nRst, $02, nD3, $06, nG2, $1D, nRst, $01, nD3, $12
	smpsSetvoice        $01
	smpsAlterVol        $02
	dc.b	nEb4, $06, nD4, nEb4, $05, nRst, $01

onehundredyears_Loop16:
	dc.b	nD4, $06, nEb4
	smpsLoop            $00, $05, onehundredyears_Loop16
	dc.b	nD4, nC4, nB3, $5A
	smpsJump            onehundredyears_Jump03

; FM4 Data
onehundredyears_FM4:
	smpsPan             panLeft, $00
	smpsSetvoice        $00
	dc.b	nRst, $7F, $41, nEb3, $06, nD3, nEb3, $05, nRst, $01

onehundredyears_Loop09:
	dc.b	nD3, $06, nEb3
	smpsLoop            $00, $05, onehundredyears_Loop09
	dc.b	nD3, nC3, nB2, $5A

onehundredyears_Jump02:
	dc.b	smpsNoAttack, $0C

onehundredyears_Loop0A:
	dc.b	nEb3, $05, nRst, $01, nD3, $06, nEb3, nD3, nEb3, nD3
	smpsLoop            $00, $02, onehundredyears_Loop0A
	dc.b	nEb3, nD3, nC3, nB2, $18, nAb3, nG3, nAb3, $0C, $06, nG3, $0C

onehundredyears_Loop0B:
	dc.b	nEb3, $06, nD3
	smpsLoop            $00, $07, onehundredyears_Loop0B
	dc.b	nC3, nB2, $66

onehundredyears_Loop0C:
	dc.b	nEb3, $06, nD3
	smpsLoop            $00, $07, onehundredyears_Loop0C
	dc.b	nC3, nB2, $18, nAb3, nG3, nAb3, $0C, $06, nG3, $17, nRst, $01
	smpsPan             panCenter, $00

onehundredyears_Loop0D:
	dc.b	$72
	smpsLoop            $00, $0A, onehundredyears_Loop0D
	smpsPan             panLeft, $00
	dc.b	nEb3, $06, nD3, nEb3, $05, nRst, $01

onehundredyears_Loop0E:
	dc.b	nD3, $06, nEb3
	smpsLoop            $00, $05, onehundredyears_Loop0E
	dc.b	nD3, nC3, nB2, $5A
	smpsJump            onehundredyears_Jump02

; FM5 Data
onehundredyears_FM5:
	smpsPan             panRight, $00
	smpsAlterNote       $04
	smpsSetvoice        $00
	dc.b	nRst, $7F, $41, nEb3, $06, nD3, nEb3, $05, nRst, $01

onehundredyears_Loop03:
	dc.b	nD3, $06, nEb3
	smpsLoop            $00, $05, onehundredyears_Loop03
	dc.b	nD3, nC3, nB2, $5A

onehundredyears_Jump01:
	dc.b	smpsNoAttack, $0C

onehundredyears_Loop04:
	dc.b	nEb3, $05, nRst, $01, nD3, $06, nEb3, nD3, nEb3, nD3
	smpsLoop            $00, $02, onehundredyears_Loop04
	dc.b	nEb3, nD3, nC3, nB2, $18, nAb3, nG3, nAb3, $0C, $06, nG3, $0C

onehundredyears_Loop05:
	dc.b	nEb3, $06, nD3
	smpsLoop            $00, $07, onehundredyears_Loop05
	dc.b	nC3, nB2, $66

onehundredyears_Loop06:
	dc.b	nEb3, $06, nD3
	smpsLoop            $00, $07, onehundredyears_Loop06
	dc.b	nC3, nB2, $18, nAb3, nG3, nAb3, $0C, $06, nG3, $17, nRst

onehundredyears_Loop07:
	dc.b	$72
	smpsLoop            $00, $0A, onehundredyears_Loop07
	dc.b	$01, nEb3, $06, nD3, nEb3, $05, nRst, $01

onehundredyears_Loop08:
	dc.b	nD3, $06, nEb3
	smpsLoop            $00, $05, onehundredyears_Loop08
	dc.b	nD3, nC3, nB2, $5A
	smpsJump            onehundredyears_Jump01

; PSG1 Data
onehundredyears_PSG1:
	dc.b	nRst, $7F, $41, nC2, $60, nB1, $54

onehundredyears_Jump08:
	dc.b	smpsNoAttack, $0B, nRst, $01, nC2, $60, nB1, nC2, nB1, nC2, nB1, nC2
	dc.b	nB1, $5F, nRst, $01, nC2, $60, nB1, nC2, nB1, nC2, nB1, nBb1
	dc.b	$7F, smpsNoAttack, $7F, smpsNoAttack, $7F, smpsNoAttack, $03, nC2, $60, nB1, $54
	smpsJump            onehundredyears_Jump08

; PSG2 Data
onehundredyears_PSG2:
	dc.b	nRst, $7F, $41, nG1, $60, nAb1, $54

onehundredyears_Jump07:
	dc.b	smpsNoAttack, $0C, nG1, $60, nAb1, $5F, nRst, $01, nG1, $60, nAb1, nG1
	dc.b	nAb1, $5D, nRst, $03, nG1, $60, nAb1, nG1, nAb1, $5F, nRst, $01
	dc.b	nG1, $60, nAb1, nG1, nAb1, $5D, nRst, $03
	smpsPSGAlterVol     $FF
	dc.b	nBb1, $7F, smpsNoAttack, $0F, nRst, $02, nD2, $18, nEb2, nD2, $2F, nRst
	dc.b	$01, nD2, $18, nEb2, nD2, $2E, nRst, $02, nAb2, $30
	smpsPSGAlterVol     $01
	dc.b	nG1, $60, nAb1, $54
	smpsJump            onehundredyears_Jump07

; PSG3 Data
onehundredyears_PSG3:
	smpsPSGform         $E7
	smpsPSGAlterVol     $02
	dc.b	nMaxPSG

onehundredyears_Loop1F:
	dc.b	$03
	smpsLoop            $00, $7C, onehundredyears_Loop1F

onehundredyears_Jump06:
	dc.b	nMaxPSG, $03
	smpsLoop            $01, $06, onehundredyears_Loop1F

onehundredyears_Loop20:
	dc.b	$03
	smpsLoop            $00, $0E, onehundredyears_Loop20
	smpsJump            onehundredyears_Jump06

onehundredyears_Voices:
;	Voice $00
;	$3B
;	$3E, $42, $41, $33, 	$DE, $14, $1E, $14, 	$14, $0F, $0F, $00
;	$01, $00, $00, $00, 	$36, $25, $26, $29, 	$14, $13, $0A, $00
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $04, $04, $03
	smpsVcCoarseFreq    $03, $01, $02, $0E
	smpsVcRateScale     $00, $00, $00, $03
	smpsVcAttackRate    $14, $1E, $14, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $0F, $0F, $14
	smpsVcDecayRate2    $00, $00, $00, $01
	smpsVcDecayLevel    $02, $02, $02, $03
	smpsVcReleaseRate   $09, $06, $05, $06
	smpsVcTotalLevel    $00, $0A, $13, $14

;	Voice $01
;	$3A
;	$7F, $06, $22, $01, 	$9F, $9F, $8E, $5A, 	$0F, $00, $00, $00
;	$09, $00, $00, $00, 	$71, $83, $14, $05, 	$14, $23, $1E, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $02, $00, $07
	smpsVcCoarseFreq    $01, $02, $06, $0F
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $1A, $0E, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $0F
	smpsVcDecayRate2    $00, $00, $00, $09
	smpsVcDecayLevel    $00, $01, $08, $07
	smpsVcReleaseRate   $05, $04, $03, $01
	smpsVcTotalLevel    $00, $1E, $23, $14

