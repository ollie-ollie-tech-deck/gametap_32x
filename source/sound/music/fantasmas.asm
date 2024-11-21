fantasmas_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     fantasmas_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $02

	smpsHeaderDAC       fantasmas_DAC
	smpsHeaderFM        fantasmas_FM1,	$00, $0C
	smpsHeaderFM        fantasmas_FM2,	$00, $0E
	smpsHeaderFM        fantasmas_FM3,	$00, $0B
	smpsHeaderFM        fantasmas_FM4,	$00, $11
	smpsHeaderFM        fantasmas_FM5,	$00, $13
	smpsHeaderPSG       fantasmas_PSG1,	$00, $00, $00, $00
	smpsHeaderPSG       fantasmas_PSG2,	$00, $01, $00, fTone_07
	smpsHeaderPSG       fantasmas_PSG3,	$00, $01, $00, $00

; DAC Data
fantasmas_DAC:
	smpsPan             panCenter, $00
	dc.b	nRst, $7F, $59

fantasmas_Loop00:
	dc.b	dKick, $06, dSnare
	smpsLoop            $00, $80, fantasmas_Loop00
	smpsSetTempoMod     $02
	smpsPan             panCenter, $00
	smpsJump            fantasmas_Loop00

; FM1 Data
fantasmas_FM1:
	smpsPan             panCenter, $00
	smpsSetvoice        $01

fantasmas_Loop1C:
	dc.b	nFs1

fantasmas_Loop19:
	dc.b	$03
	smpsLoop            $00, $10, fantasmas_Loop19

fantasmas_Loop1A:
	dc.b	nB1
	smpsLoop            $00, $09, fantasmas_Loop1A

fantasmas_Loop1B:
	dc.b	nD2
	smpsLoop            $00, $07, fantasmas_Loop1B
	smpsLoop            $01, $02, fantasmas_Loop1C
	dc.b	nRst, $18
	smpsSetvoice        $03

fantasmas_Jump03:
	smpsAlterVol        $01

fantasmas_Loop20:
	dc.b	nFs2

fantasmas_Loop1D:
	dc.b	$03
	smpsLoop            $00, $10, fantasmas_Loop1D

fantasmas_Loop1E:
	dc.b	nB2
	smpsLoop            $00, $09, fantasmas_Loop1E

fantasmas_Loop1F:
	dc.b	nD3
	smpsLoop            $00, $07, fantasmas_Loop1F
	smpsLoop            $01, $10, fantasmas_Loop20
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsAlterVol        $FF
	smpsJump            fantasmas_Jump03

; FM2 Data
fantasmas_FM2:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nRst, $7F, $59

fantasmas_Loop16:
	dc.b	nFs3, $03

fantasmas_Loop15:
	dc.b	$03, $03, nD3, nD3, nD3, nCs3
	smpsLoop            $00, $02, fantasmas_Loop15
	dc.b	nCs3, nD3, nD3, nFs3, nFs3, nFs3, nD3, nD3, nD3, nCs3, nCs3, nCs3
	dc.b	nD3, nD3, nD3, nA3, nA3, nA3, nA3
	smpsLoop            $01, $0C, fantasmas_Loop16
	smpsAlterVol        $01

fantasmas_Loop17:
	dc.b	nCs4, nCs4, nCs4, nA3, nA3, nA3
	smpsLoop            $00, $02, fantasmas_Loop17
	dc.b	nE3, nE3, nFs3, nFs3

fantasmas_Loop18:
	dc.b	nD4, nD4, nD4, nA3, nA3, nA3
	smpsLoop            $00, $02, fantasmas_Loop18
	dc.b	nE3, nE3, nFs3, nFs3
	smpsLoop            $01, $04, fantasmas_Loop17
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsAlterVol        $FF
	smpsJump            fantasmas_Loop16

; FM3 Data
fantasmas_FM3:
	smpsPan             panCenter, $00
	smpsSetvoice        $02
	dc.b	nRst, $01, $7F, $58

fantasmas_Jump02:
	dc.b	nRst, $7F, $7F, $7F, $09, nB3, $06, nD4, nCs4, nCs4, nCs4, nB3
	dc.b	nCs4
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $02

fantasmas_Loop12:
	dc.b	$06
	smpsAlterVol        $03
	smpsLoop            $00, $03, fantasmas_Loop12
	dc.b	$06
	smpsAlterVol        $05
	dc.b	$06
	smpsAlterVol        $04
	dc.b	$06
	smpsAlterVol        $06
	dc.b	$06
	smpsAlterVol        $E1
	dc.b	nB3, nD4, nCs4, nCs4, nCs4, nCs4, nD4, $0C, nCs4, nD4, $1E, nRst
	dc.b	$06, nB3, nD4, nCs4, $05, nD4, $01, nE4, $06, nD4, nCs4, $03
	dc.b	$03, $06
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $02

fantasmas_Loop13:
	dc.b	$06
	smpsAlterVol        $03
	smpsLoop            $00, $03, fantasmas_Loop13
	dc.b	$06
	smpsAlterVol        $05
	dc.b	$06
	smpsAlterVol        $04
	dc.b	$06
	smpsAlterVol        $06
	dc.b	$06
	smpsAlterVol        $E1
	dc.b	nB3, nD4, nCs4, $05, nD4, $01, nE4, $06, nD4, nCs4, $03, $03
	dc.b	$1E, nD4, $18, nRst, $06, nA3

fantasmas_Loop14:
	dc.b	nD4, $03, $02, nRst, $01, nCs4, $06, $06, $24, nRst, $06, nA3
	dc.b	nD4, nD4, $03, $06, nCs4, nRst, $03, nA3, $06
	smpsLoop            $00, $03, fantasmas_Loop14
	dc.b	nD4, $03, $02, nRst, $01, nCs4, $06, $06, $24, nRst, $06, nA3
	dc.b	nD4, nD4, $03, $06, nCs4, $09, nRst, $7F, $7F, $7C
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $02
	smpsJump            fantasmas_Jump02

; FM4 Data
fantasmas_FM4:
	smpsPan             panCenter, $00
	smpsAlterNote       $06
	smpsSetvoice        $01

fantasmas_Loop0D:
	dc.b	nFs1

fantasmas_Loop0A:
	dc.b	$03
	smpsLoop            $00, $10, fantasmas_Loop0A

fantasmas_Loop0B:
	dc.b	nB1
	smpsLoop            $00, $09, fantasmas_Loop0B

fantasmas_Loop0C:
	dc.b	nD2
	smpsLoop            $00, $07, fantasmas_Loop0C
	smpsLoop            $01, $02, fantasmas_Loop0D
	dc.b	nRst, $18
	smpsSetvoice        $03

fantasmas_Jump01:
	smpsAlterVol        $FC

fantasmas_Loop11:
	dc.b	nFs2

fantasmas_Loop0E:
	dc.b	$03
	smpsLoop            $00, $10, fantasmas_Loop0E

fantasmas_Loop0F:
	dc.b	nB2
	smpsLoop            $00, $09, fantasmas_Loop0F

fantasmas_Loop10:
	dc.b	nD3
	smpsLoop            $00, $07, fantasmas_Loop10
	smpsLoop            $01, $10, fantasmas_Loop11
	smpsPan             panCenter, $00
	smpsAlterNote       $06
	smpsAlterVol        $04
	smpsJump            fantasmas_Jump01

; FM5 Data
fantasmas_FM5:
	smpsPan             panCenter, $00
	smpsAlterNote       $06
	smpsSetvoice        $00
	dc.b	nRst, $01, $7F, $58
	smpsSetvoice        $00

fantasmas_Jump00:
	dc.b	nRst, $01, nFs3, $03

fantasmas_Loop01:
	dc.b	$03, $03, nD3, nD3, nD3, nCs3
	smpsLoop            $00, $02, fantasmas_Loop01
	dc.b	nCs3, nD3, nD3, nFs3, nFs3, nFs3, nD3, nD3, nD3, nCs3, nCs3, nCs3
	dc.b	nD3, nD3, nD3, nA3, nA3, nA3, nA3, nFs3, nFs3, nFs3, nD3, nD3
	dc.b	nD3, nCs3, nCs3, nCs3, nD3, nD3, nD3, nCs3, nCs3, nD3, nD3, nFs3
	dc.b	nFs3, nFs3, nD3, nD3, nD3, nCs3, nCs3, nCs3, nD3, nD3, nD3, nA3
	dc.b	nA3, nA3, nA3, $02, nRst, $01

fantasmas_Loop03:
	dc.b	nFs3, $03

fantasmas_Loop02:
	dc.b	$03, $03, nD3, nD3, nD3, nCs3
	smpsLoop            $00, $02, fantasmas_Loop02
	dc.b	nCs3, nD3, nD3, nFs3, nFs3, nFs3, nD3, nD3, nD3, nCs3, nCs3, nCs3
	dc.b	nD3, nD3, nD3, nA3, nA3, nA3, nA3
	smpsLoop            $01, $03, fantasmas_Loop03

fantasmas_Loop05:
	dc.b	nFs3, nFs3, nFs3, nD3, nD3, nD3, nCs3, nCs3, nCs3, nD3, nD3, nD3
	dc.b	nCs3, nCs3, nD3, nD3, nFs3, nFs3, nFs3, nD3, nD3, nD3, nCs3, nCs3
	dc.b	nCs3, nD3, nD3, nD3, nA3, nA3, nA3, nA3, $02, nRst, $01, nFs3
	dc.b	$03

fantasmas_Loop04:
	dc.b	$03, $03, nD3, nD3, nD3, nCs3
	smpsLoop            $00, $02, fantasmas_Loop04
	dc.b	nCs3, nD3, nD3, nFs3, nFs3, nFs3, nD3, nD3, nD3, nCs3, nCs3, nCs3
	dc.b	nD3, nD3, nD3, nA3, nA3, nA3, nA3
	smpsLoop            $01, $03, fantasmas_Loop05
	dc.b	nFs3, nFs3, nFs3, nD3, nD3, nD3, nCs3, nCs3, nCs3, nD3, nD3, nD3
	dc.b	nCs3, nCs3, nD3, nD3, nFs3, nFs3, nFs3, nD3, nD3, nD3, nCs3, nCs3
	dc.b	nCs3, nD3, nD3, nD3, nA3, nA3, nA3, nA3, $02, nRst, $01
	smpsAlterVol        $01

fantasmas_Loop06:
	dc.b	nCs4, $03, $03, $03, nA3, nA3, nA3
	smpsLoop            $00, $02, fantasmas_Loop06
	dc.b	nE3, nE3, nFs3, nFs3

fantasmas_Loop07:
	dc.b	nD4, nD4, nD4, nA3, nA3, nA3
	smpsLoop            $00, $02, fantasmas_Loop07
	dc.b	nE3, nE3, nFs3, nFs3
	smpsLoop            $01, $03, fantasmas_Loop06

fantasmas_Loop08:
	dc.b	nCs4, nCs4, nCs4, nA3, nA3, nA3
	smpsLoop            $00, $02, fantasmas_Loop08
	dc.b	nE3, nE3, nFs3, nFs3

fantasmas_Loop09:
	dc.b	nD4, nD4, nD4, nA3, nA3, nA3
	smpsLoop            $00, $02, fantasmas_Loop09
	dc.b	nE3, nE3, nFs3, nFs3, $02
	smpsPan             panCenter, $00
	smpsAlterNote       $06
	smpsSetvoice        $00
	smpsAlterVol        $FF
	smpsJump            fantasmas_Jump00

; PSG1 Data
fantasmas_PSG1:
	smpsStop

; PSG2 Data
fantasmas_PSG2:
	dc.b	nRst, $7F, $59

fantasmas_Jump05:
	dc.b	nRst, $7F, $7F, $7F, $09, nB1, $06, nD2, nCs2, nCs2, nCs2, nB1

fantasmas_Loop22:
	dc.b	nCs2
	smpsPSGAlterVol     $01
	smpsLoop            $00, $05, fantasmas_Loop22
	dc.b	$06
	smpsPSGAlterVol     $02
	dc.b	$06
	smpsPSGAlterVol     $01
	dc.b	$06
	smpsPSGAlterVol     $02
	dc.b	$06
	smpsPSGAlterVol     $02
	dc.b	$06
	smpsPSGAlterVol     $F4
	dc.b	nB1, nD2, nCs2, nCs2, nCs2, nCs2, nD2, $0C, nCs2, nD2, $1E, nRst
	dc.b	$06, nB1, nD2, nCs2, $05, nD2, $01, nE2, $06, nD2, nCs2, $03
	dc.b	$03

fantasmas_Loop23:
	dc.b	$06
	smpsPSGAlterVol     $01
	smpsLoop            $00, $05, fantasmas_Loop23
	dc.b	$06
	smpsPSGAlterVol     $02
	dc.b	$06
	smpsPSGAlterVol     $01
	dc.b	$06
	smpsPSGAlterVol     $02
	dc.b	$06
	smpsPSGAlterVol     $02
	dc.b	$06
	smpsPSGAlterVol     $F4
	dc.b	nB1, nD2, nCs2, $05, nD2, $01, nE2, $06, nD2, nCs2, $03, $03
	dc.b	$1E, nD2, $18, nRst, $06, nA1

fantasmas_Loop24:
	dc.b	nD2, $03, $02, nRst, $01, nCs2, $06, $06, $24, nRst, $06, nA1
	dc.b	nD2, nD2, $03, $06, nCs2, nRst, $03, nA1, $06
	smpsLoop            $00, $03, fantasmas_Loop24
	dc.b	nD2, $03, $02, nRst, $01, nCs2, $06, $06, $24, nRst, $06, nA1
	dc.b	nD2, nD2, $03, $06, nCs2, $09, nRst, $7F, $7F, $7C
	smpsAlterNote       $00
	smpsPSGvoice        fTone_07
	smpsJump            fantasmas_Jump05

; PSG3 Data
fantasmas_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $7F, $59

fantasmas_Jump04:
	dc.b	nRst, $03
	smpsPSGvoice        fTone_01
	dc.b	nMaxPSG

fantasmas_Loop21:
	dc.b	$06
	smpsLoop            $00, $FF, fantasmas_Loop21
	dc.b	$03
	smpsAlterNote       $00
	smpsJump            fantasmas_Jump04

fantasmas_Voices:
;	Voice $00
;	$2A
;	$01, $08, $06, $04, 	$53, $1F, $1F, $50, 	$12, $14, $11, $1F
;	$00, $00, $00, $00, 	$29, $15, $36, $0B, 	$17, $33, $1C, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $04, $06, $08, $01
	smpsVcRateScale     $01, $00, $00, $01
	smpsVcAttackRate    $10, $1F, $1F, $13
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $11, $14, $12
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $03, $01, $02
	smpsVcReleaseRate   $0B, $06, $05, $09
	smpsVcTotalLevel    $00, $1C, $33, $17

;	Voice $01
;	$33
;	$0C, $01, $01, $01, 	$1F, $1F, $1F, $1F, 	$00, $00, $05, $00
;	$00, $00, $00, $07, 	$00, $00, $30, $05, 	$28, $1D, $0C, $00
	smpsVcAlgorithm     $03
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $01, $0C
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $05, $00, $00
	smpsVcDecayRate2    $07, $00, $00, $00
	smpsVcDecayLevel    $00, $03, $00, $00
	smpsVcReleaseRate   $05, $00, $00, $00
	smpsVcTotalLevel    $00, $0C, $1D, $28

;	Voice $02
;	$3B
;	$51, $71, $61, $41, 	$51, $16, $18, $1A, 	$05, $01, $01, $00
;	$09, $01, $01, $01, 	$17, $97, $27, $47, 	$1C, $22, $15, $00
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $06, $07, $05
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $00, $00, $00, $01
	smpsVcAttackRate    $1A, $18, $16, $11
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $01, $01, $05
	smpsVcDecayRate2    $01, $01, $01, $09
	smpsVcDecayLevel    $04, $02, $09, $01
	smpsVcReleaseRate   $07, $07, $07, $07
	smpsVcTotalLevel    $00, $15, $22, $1C

;	Voice $03
;	$20
;	$36, $35, $30, $31, 	$DF, $DF, $9F, $9F, 	$07, $06, $09, $06
;	$07, $06, $06, $08, 	$20, $10, $10, $F8, 	$19, $37, $13, $00
	smpsVcAlgorithm     $00
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $00, $05, $06
	smpsVcRateScale     $02, $02, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $09, $06, $07
	smpsVcDecayRate2    $08, $06, $06, $07
	smpsVcDecayLevel    $0F, $01, $01, $02
	smpsVcReleaseRate   $08, $00, $00, $00
	smpsVcTotalLevel    $00, $13, $37, $19

