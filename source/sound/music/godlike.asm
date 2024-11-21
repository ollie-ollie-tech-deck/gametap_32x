godlike_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     godlike_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $03

	smpsHeaderDAC       godlike_DAC
	smpsHeaderFM        godlike_FM1,	$00, $0A
	smpsHeaderFM        godlike_FM2,	$00, $07
	smpsHeaderFM        godlike_FM3,	$00, $07
	smpsHeaderFM        godlike_FM4,	$00, $0F
	smpsHeaderFM        godlike_FM5,	$00, $0F
	smpsHeaderPSG       godlike_PSG1,	$00, $00, $00, $00
	smpsHeaderPSG       godlike_PSG2,	$00, $00, $00, $00
	smpsHeaderPSG       godlike_PSG3,	$00, $00, $00, $00

; DAC Data
godlike_DAC:
	smpsPan             panCenter, $00
	dc.b	nRst, $7F, $41

godlike_Loop00:
	dc.b	dKick, $0C, dSnare, $09, $03, dKick, $0C, dSnare
	smpsLoop            $00, $16, godlike_Loop00
	smpsJump            godlike_Loop00

; FM1 Data
godlike_FM1:
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nRst, $7F, $41

godlike_Jump04:
	dc.b	nRst, $7F, $41

godlike_Loop15:
	dc.b	nF3, $03, $03, $03, $03, $03, $02, nRst, $1F
	smpsLoop            $00, $08, godlike_Loop15

godlike_Loop16:
	dc.b	nF3, $03, $03, nEb3, nEb3, nF3, nRst, $21
	smpsLoop            $00, $04, godlike_Loop16

godlike_Loop17:
	dc.b	nAb3, $03, nA3, nF3, nRst, $0C, nC3, $03, nEb3, nC3, nBb2, nRst
	dc.b	$0F, nF3, $03, $03, nEb3, nEb3, nF3, nRst, $21
	smpsLoop            $00, $03, godlike_Loop17
	smpsJump            godlike_Jump04

; FM2 Data
godlike_FM2:
	smpsPan             panLeft, $00
	smpsSetvoice        $00
	smpsAlterVol        $09

godlike_Loop12:
	dc.b	nF3, $06

godlike_Loop11:
	dc.b	nF2, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop11
	dc.b	nF2, $03, nF3, nE3, nF3, nEb3, nE3, nEb3, nD3, nEb3
	smpsLoop            $01, $04, godlike_Loop12

godlike_Jump03:
	dc.b	nF3, $06
	smpsLoop            $02, $06, godlike_Loop11

godlike_Loop13:
	dc.b	nF2, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop13
	dc.b	nF2, $03, nF3, nE3, nF3, nEb3, nE3, nEb3, nD3, nEb3, nF3, $06

godlike_Loop14:
	dc.b	nF2, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop14
	dc.b	nF2, $03, nF3, nE3, nF3, nEb3, nE3, nEb3, nD3, nEb3
	smpsJump            godlike_Jump03

; FM3 Data
godlike_FM3:
	smpsPan             panRight, $00
	smpsAlterNote       $08
	smpsSetvoice        $00
	smpsAlterVol        $08

godlike_Loop0E:
	dc.b	nF3, $06

godlike_Loop0D:
	dc.b	nF2, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop0D
	dc.b	nF2, $03, nF3, nE3, nF3, nEb3, nE3, nEb3, nD3, nEb3
	smpsLoop            $01, $04, godlike_Loop0E

godlike_Jump02:
	dc.b	nF3, $06
	smpsLoop            $02, $06, godlike_Loop0D

godlike_Loop0F:
	dc.b	nF2, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop0F
	dc.b	nF2, $03, nF3, nE3, nF3, nEb3, nE3, nEb3, nD3, nEb3, nF3, $06

godlike_Loop10:
	dc.b	nF2, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop10
	dc.b	nF2, $03, nF3, nE3, nF3, nEb3, nE3, nEb3, nD3, nEb3
	smpsJump            godlike_Jump02

; FM4 Data
godlike_FM4:
	smpsPan             panLeft, $00
	smpsAlterNote       $08
	smpsSetvoice        $00
	dc.b	nRst, $01

godlike_Loop08:
	dc.b	nF2, $06

godlike_Loop07:
	dc.b	nF1, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop07
	dc.b	nF1, $03, nF2, nE2, nF2, nEb2, nE2, nEb2, nD2, nEb2
	smpsLoop            $01, $03, godlike_Loop08
	dc.b	nF2, $06

godlike_Loop09:
	dc.b	nF1, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop09
	dc.b	nF1, $03, nF2, nE2, nF2, nEb2, nE2, nEb2, nD2, nEb2, $02

godlike_Jump01:
	dc.b	smpsNoAttack, $01

godlike_Loop0B:
	dc.b	nF2, $06

godlike_Loop0A:
	dc.b	nF1, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop0A
	dc.b	nF1, $03, nF2, nE2, nF2, nEb2, nE2, nEb2, nD2, nEb2
	smpsLoop            $01, $15, godlike_Loop0B
	dc.b	nF2, $06

godlike_Loop0C:
	dc.b	nF1, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop0C
	dc.b	nF1, $03, nF2, nE2, nF2, nEb2, nE2, nEb2, nD2, nEb2, $02
	smpsJump            godlike_Jump01

; FM5 Data
godlike_FM5:
	smpsPan             panRight, $00
	smpsAlterNote       $0E
	smpsSetvoice        $00
	dc.b	nRst, $01

godlike_Loop02:
	dc.b	nF2, $06

godlike_Loop01:
	dc.b	nF1, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop01
	dc.b	nF1, $03, nF2, nE2, nF2, nEb2, nE2, nEb2, nD2, nEb2
	smpsLoop            $01, $03, godlike_Loop02
	dc.b	nF2, $06

godlike_Loop03:
	dc.b	nF1, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop03
	dc.b	nF1, $03, nF2, nE2, nF2, nEb2, nE2, nEb2, nD2, nEb2, $02

godlike_Jump00:
	dc.b	smpsNoAttack, $01

godlike_Loop05:
	dc.b	nF2, $06

godlike_Loop04:
	dc.b	nF1, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop04
	dc.b	nF1, $03, nF2, nE2, nF2, nEb2, nE2, nEb2, nD2, nEb2
	smpsLoop            $01, $15, godlike_Loop05
	dc.b	nF2, $06

godlike_Loop06:
	dc.b	nF1, $02, nRst, $01
	smpsLoop            $00, $05, godlike_Loop06
	dc.b	nF1, $03, nF2, nE2, nF2, nEb2, nE2, nEb2, nD2, nEb2, $02
	smpsJump            godlike_Jump00

; PSG3 Data
godlike_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $7F, $41

godlike_Jump05:
	smpsPSGvoice        fTone_02
	dc.b	nMaxPSG

godlike_Loop18:
	dc.b	$03
	smpsLoop            $00, $FF, godlike_Loop18
	smpsJump            godlike_Jump05

; PSG1 Data
godlike_PSG1:
; PSG2 Data
godlike_PSG2:
	smpsStop

godlike_Voices:
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
;	$2A
;	$50, $03, $11, $00, 	$90, $CE, $CD, $9B, 	$05, $0A, $09, $08
;	$00, $00, $12, $0C, 	$09, $FF, $50, $4A, 	$18, $27, $25, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $01, $00, $05
	smpsVcCoarseFreq    $00, $01, $03, $00
	smpsVcRateScale     $02, $03, $03, $02
	smpsVcAttackRate    $1B, $0D, $0E, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $09, $0A, $05
	smpsVcDecayRate2    $0C, $12, $00, $00
	smpsVcDecayLevel    $04, $05, $0F, $00
	smpsVcReleaseRate   $0A, $00, $0F, $09
	smpsVcTotalLevel    $00, $25, $27, $18

