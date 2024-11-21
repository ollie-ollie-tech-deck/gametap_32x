mineeyes_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     mineeyes_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $03

	smpsHeaderDAC       mineeyes_DAC
	smpsHeaderFM        mineeyes_FM1,	$00, $0D
	smpsHeaderFM        mineeyes_FM2,	$00, $02
	smpsHeaderFM        mineeyes_FM3,	$00, $07
	smpsHeaderFM        mineeyes_FM4,	$00, $07
	smpsHeaderFM        mineeyes_FM5,	$00, $09
	smpsHeaderPSG       mineeyes_PSG1,	$00, $01, $00, $00
	smpsHeaderPSG       mineeyes_PSG2,	$00, $01, $00, $00
	smpsHeaderPSG       mineeyes_PSG3,	$00, $04, $00, $00

; DAC Data
mineeyes_DAC:
	smpsPan             panCenter, $00
	dc.b	dVLowTimpani, $1E, dHiTimpani, $03, $03, $2A, $03, $03, $0C, dVLowTimpani, $1E, dHiTimpani
	dc.b	$03, $03, $2A, $03, $03, dSnare, $0C, dKick

mineeyes_Loop00:
	dc.b	dSnare, dKick, $06

mineeyes_Loop01:
	dc.b	$06, dSnare, $03, dKick, dKick, dKick, dKick, $0C
	smpsLoop            $00, $07, mineeyes_Loop00
	dc.b	dSnare

mineeyes_Jump00:
	dc.b	dKick, $06
	smpsLoop            $01, $05, mineeyes_Loop01

mineeyes_Loop02:
	dc.b	$06, dSnare, $03, dKick, dKick, dKick, dKick, $0C, dSnare, dKick, $06
	smpsLoop            $00, $03, mineeyes_Loop02
	dc.b	$06, dSnare, $03, dKick, dKick, dKick, dKick, $0C, dSnare
	smpsJump            mineeyes_Jump00

; FM1 Data
mineeyes_FM1:
	smpsPan             panCenter, $00
	smpsSetvoice        $03
	dc.b	nRst, $7F, $35, nA1, $0C, nAb1, $7F, smpsNoAttack, $29, nA1, $18

mineeyes_Loop14:
	dc.b	nAb1, $7F, smpsNoAttack, $29

mineeyes_Jump05:
	dc.b	nB1, $0C, nA1
	smpsLoop            $00, $02, mineeyes_Loop14
	dc.b	nAb1, $7F, smpsNoAttack, $29, nA1, $0C, nG1, nFs1, $7F, smpsNoAttack, $29, nB1
	dc.b	$0C, nA1, nAb1, $7F, smpsNoAttack, $41
	smpsAlterVol        $FB
	dc.b	nCs1

mineeyes_Loop15:
	dc.b	$30, $24, $0C, nE1, $18, $18, nCs1, $30
	smpsLoop            $00, $02, mineeyes_Loop15
	smpsAlterVol        $03

mineeyes_Loop16:
	dc.b	$30
	smpsLoop            $00, $07, mineeyes_Loop16
	dc.b	$18
	smpsAlterVol        $02
	smpsJump            mineeyes_Jump05

; FM2 Data
mineeyes_FM2:
	smpsPan             panLeft, $00
	smpsSetvoice        $00
	smpsAlterVol        $05
	dc.b	nAb3, $02

mineeyes_Loop0F:
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nEb4, $02, nRst, $01, nE4, $02
	dc.b	nRst, $01, nEb4, $02

mineeyes_Loop0C:
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nAb3, $02
	smpsLoop            $00, $02, mineeyes_Loop0C
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nEb4, $02, nRst, $01, nE4, $02
	dc.b	nRst, $01, nEb4, $02, nRst, $01, nCs4, $02, nRst, $01, nAb3, $02
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nA3, $02, nRst, $01, nCs4, $02
	dc.b	nRst, $01, nEb4, $02, nRst, $01, nE4, $02, nRst, $01, nEb4, $02

mineeyes_Loop0D:
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nA3, $02
	smpsLoop            $00, $02, mineeyes_Loop0D

mineeyes_Loop11:
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nEb4, $02, nRst, $01, nE4, $02
	dc.b	nRst, $01, nEb4, $02

mineeyes_Loop0E:
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nAb3, $02
	smpsLoop            $00, $02, mineeyes_Loop0E
	smpsLoop            $01, $05, mineeyes_Loop0F
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nEb4, $02, nRst, $01, nE4, $02
	dc.b	nRst, $01, nEb4, $02

mineeyes_Loop10:
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nAb3, $02
	smpsLoop            $00, $02, mineeyes_Loop10
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nEb4, $02, nRst, $01, nE4, $02
	dc.b	nRst, $01, nEb4, $02, nRst, $01, nCs4, $02, nRst, $01, nAb3, $02
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nA3, $02, nRst, $01, nCs4, $02
	dc.b	nRst, $01, nEb4, $02, nRst, $01, nE4, $02, nRst, $01, nEb4, $02
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nA3, $02, nRst, $01, nCs4, $02
	dc.b	nRst, $01

mineeyes_Jump04:
	dc.b	nA3, $02
	smpsLoop            $02, $04, mineeyes_Loop11

mineeyes_Loop13:
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nEb4, $02, nRst, $01, nE4, $02
	dc.b	nRst, $01, nEb4, $02

mineeyes_Loop12:
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nAb3, $02
	smpsLoop            $00, $02, mineeyes_Loop12
	smpsLoop            $01, $02, mineeyes_Loop13
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nEb4, $02, nRst, $01, nE4, $02
	dc.b	nRst, $01, nEb4, $02, nRst, $01, nCs4, $02, nRst, $01, nAb3, $02
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nA3, $02, nRst, $01, nCs4, $02
	dc.b	nRst, $01, nEb4, $02, nRst, $01, nE4, $02, nRst, $01, nEb4, $02
	dc.b	nRst, $01, nCs4, $02, nRst, $01, nA3, $02, nRst, $01, nCs4, $02
	dc.b	nRst, $01
	smpsJump            mineeyes_Jump04

; FM3 Data
mineeyes_FM3:
	smpsPan             panRight, $00
	smpsSetvoice        $00
	dc.b	nRst, $01

mineeyes_Loop07:
	dc.b	nAb3, $03, nCs4, nEb4, nE4, nEb4, nCs4, nAb3, nCs4
	smpsLoop            $00, $02, mineeyes_Loop07
	dc.b	nA3, nCs4, nEb4, nE4, nEb4, nCs4, nA3, nCs4, nA3, nCs4, nEb4, nE4
	dc.b	nEb4, nCs4, nAb3, nCs4, $01, nRst, $02
	smpsLoop            $01, $05, mineeyes_Loop07

mineeyes_Loop08:
	dc.b	nAb3, $03, nCs4, nEb4, nE4, nEb4, nCs4, nAb3, nCs4
	smpsLoop            $00, $02, mineeyes_Loop08
	dc.b	nA3, nCs4, nEb4, nE4, nEb4, nCs4, nA3, nCs4, $02

mineeyes_Jump03:
	dc.b	smpsNoAttack, $01

mineeyes_Loop0A:
	dc.b	nA3, $03, nCs4, nEb4, nE4, nEb4, nCs4, nAb3, nCs4, $01, nRst, $02

mineeyes_Loop09:
	dc.b	nAb3, $03, nCs4, nEb4, nE4, nEb4, nCs4, nAb3, nCs4
	smpsLoop            $00, $02, mineeyes_Loop09
	dc.b	nA3, nCs4, nEb4, nE4, nEb4, nCs4, nA3, nCs4
	smpsLoop            $01, $0F, mineeyes_Loop0A
	dc.b	nA3, nCs4, nEb4, nE4, nEb4, nCs4, nAb3, nCs4, $01, nRst, $02

mineeyes_Loop0B:
	dc.b	nAb3, $03, nCs4, nEb4, nE4, nEb4, nCs4, nAb3, nCs4
	smpsLoop            $00, $02, mineeyes_Loop0B
	dc.b	nA3, nCs4, nEb4, nE4, nEb4, nCs4, nA3, nCs4, $02
	smpsJump            mineeyes_Jump03

; FM4 Data
mineeyes_FM4:
	smpsPan             panCenter, $00
	smpsSetvoice        $02
	dc.b	nRst, $7F, $35, nA2, $0C, nAb2, $7F, smpsNoAttack, $29, nA2, $18

mineeyes_Loop04:
	dc.b	nAb2, $7F, smpsNoAttack, $29

mineeyes_Jump02:
	dc.b	nB2, $0C, nA2
	smpsLoop            $00, $02, mineeyes_Loop04
	dc.b	nAb2, $7F, smpsNoAttack, $29, nA2, $0C, nG2, nFs2, $7F, smpsNoAttack, $29, nB2
	dc.b	$0C, nA2, nAb2, $7F, smpsNoAttack, $41
	smpsAlterVol        $FC
	dc.b	nCs2

mineeyes_Loop05:
	dc.b	$30, $24, $0C, nE2, $18, $18, nCs2, $30
	smpsLoop            $00, $02, mineeyes_Loop05
	smpsAlterVol        $04

mineeyes_Loop06:
	dc.b	$30
	smpsLoop            $00, $07, mineeyes_Loop06
	dc.b	$18
	smpsJump            mineeyes_Jump02

; FM5 Data
mineeyes_FM5:
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nRst, $5C, $5C, $5C, $5C, $5C, $5C

mineeyes_Jump01:
	dc.b	nRst

mineeyes_Loop03:
	dc.b	$4F
	smpsLoop            $00, $0C, mineeyes_Loop03
	dc.b	nAb5, $0C
	smpsAlterVol        $08
	dc.b	nCs6, $18, nRst, $7F, $1D
	smpsAlterVol        $F8
	dc.b	nAb5, $0C
	smpsAlterVol        $08
	dc.b	nCs6, $18, nRst, $7F, $7F, $6A
	smpsAlterVol        $F8
	smpsJump            mineeyes_Jump01

; PSG2 Data
mineeyes_PSG2:
	dc.b	nRst, $5C, $5C, $5C, $5C, $5C, $5C

mineeyes_Jump08:
	dc.b	nRst, $18, nCs1, $3C, nEb1, $06, nCs1, $1E, nAb1, $36, nA1, $0C
	dc.b	nFs1, $18, nCs1, $06, nAb1, nB1, nA1, nAb1, $12, $06, $06, $06
	dc.b	nB1, nA1, nAb1, $12, nCs1, $06, $06, nAb1, nAb1, nAb1, nAb1, nAb1
	dc.b	$0C, $06, $06, $04, nRst, $02, nB1, $06, nA1, $0C, nAb1, $12
	dc.b	nCs1, $06, nAb1, nAb1, nAb1, nAb1, $0C, $06, $0C, $06, nB1, nA1
	dc.b	nAb1, $12, nCs1, $06, $06, nAb1, nAb1, nAb1, nAb1, $1E, nEb1, $0C
	dc.b	nCs1, $06, $12, $06, $06, nAb1, nAb1, nAb1, nAb1, $0C, $12, $06
	dc.b	nB1, nA1, nAb1, $1E, nCs1, $06, $06, $06, $0C, $06, $06, $06
	dc.b	nEb1, $0A, nCs1, $08, $12, nRst, $06, nB1, nB1, nCs2, nCs2, nCs2
	dc.b	nCs2, $12, nEb2, $0C, $0C, $12, $06

mineeyes_Loop1C:
	dc.b	$06, nE2
	smpsLoop            $00, $04, mineeyes_Loop1C
	dc.b	nCs2, $36, nB1, $06, nCs2, nCs2, nCs2, nCs2, $12, nEb2, $0C, $0C
	dc.b	$12, $06

mineeyes_Loop1D:
	dc.b	$06, nE2
	smpsLoop            $00, $04, mineeyes_Loop1D
	dc.b	nCs2, $36, nRst, $7F, $7F, $6A
	smpsJump            mineeyes_Jump08

; PSG1 Data
mineeyes_PSG1:
	dc.b	nRst, $5C, $5C, $5C, $5C, $5C, $5C

mineeyes_Jump07:
	dc.b	nRst

mineeyes_Loop19:
	dc.b	$70
	smpsLoop            $00, $07, mineeyes_Loop19
	dc.b	$02, nB0, $06, $06, nCs1, nCs1, nCs1, nCs1, $12, nEb1, $0C, $0C
	dc.b	$12, $06

mineeyes_Loop1A:
	dc.b	$06, nE1
	smpsLoop            $00, $04, mineeyes_Loop1A
	dc.b	nCs1, $36, nB0, $06, nCs1, nCs1, nCs1, nCs1, $12, nEb1, $0C, $0C
	dc.b	$12, $06

mineeyes_Loop1B:
	dc.b	$06, nE1
	smpsLoop            $00, $04, mineeyes_Loop1B
	dc.b	nCs1, $36, nRst, $7F, $7F, $6A
	smpsJump            mineeyes_Jump07

; PSG3 Data
mineeyes_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $5C, $5C, $5C, $5C, $5C, $5C

mineeyes_Jump06:
	dc.b	nRst

mineeyes_Loop17:
	dc.b	$63
	smpsLoop            $00, $08, mineeyes_Loop17
	smpsPSGvoice        fTone_02
	dc.b	nMaxPSG

mineeyes_Loop18:
	dc.b	$03
	smpsLoop            $00, $BF, mineeyes_Loop18
	dc.b	$7F, smpsNoAttack, $2C
	smpsJump            mineeyes_Jump06

mineeyes_Voices:
;	Voice $00
;	$3A
;	$71, $0C, $33, $01, 	$1C, $16, $1D, $1F, 	$04, $06, $04, $08
;	$00, $01, $03, $00, 	$16, $17, $16, $A6, 	$25, $2F, $25, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $00, $07
	smpsVcCoarseFreq    $01, $03, $0C, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1D, $16, $1C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $04, $06, $04
	smpsVcDecayRate2    $00, $03, $01, $00
	smpsVcDecayLevel    $0A, $01, $01, $01
	smpsVcReleaseRate   $06, $06, $07, $06
	smpsVcTotalLevel    $00, $25, $2F, $25

;	Voice $01
;	$3A
;	$04, $06, $02, $01, 	$5B, $19, $1F, $51, 	$13, $14, $14, $1F
;	$00, $00, $00, $00, 	$25, $85, $15, $07, 	$2B, $0E, $35, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $02, $06, $04
	smpsVcRateScale     $01, $00, $00, $01
	smpsVcAttackRate    $11, $1F, $19, $1B
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $14, $14, $13
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $08, $02
	smpsVcReleaseRate   $07, $05, $05, $05
	smpsVcTotalLevel    $00, $35, $0E, $2B

;	Voice $02
;	$3A
;	$01, $01, $01, $02, 	$8D, $07, $07, $52, 	$09, $00, $00, $03
;	$01, $02, $02, $00, 	$52, $02, $02, $28, 	$18, $22, $18, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $01, $01, $01
	smpsVcRateScale     $01, $00, $00, $02
	smpsVcAttackRate    $12, $07, $07, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $00, $00, $09
	smpsVcDecayRate2    $00, $02, $02, $01
	smpsVcDecayLevel    $02, $00, $00, $05
	smpsVcReleaseRate   $08, $02, $02, $02
	smpsVcTotalLevel    $00, $18, $22, $18

;	Voice $03
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

