ghz_sin_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     ghz_sin_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $07

	smpsHeaderDAC       ghz_sin_DAC
	smpsHeaderFM        ghz_sin_FM1,	$00, $05
	smpsHeaderFM        ghz_sin_FM2,	$00, $15
	smpsHeaderFM        ghz_sin_FM3,	$00, $07
	smpsHeaderFM        ghz_sin_FM4,	$00, $07
	smpsHeaderFM        ghz_sin_FM5,	$00, $0A
	smpsHeaderPSG       ghz_sin_PSG1,	$00, $01, $00, $00
	smpsHeaderPSG       ghz_sin_PSG2,	$00, $01, $00, fTone_08
	smpsHeaderPSG       ghz_sin_PSG3,	$00, $00, $00, fTone_02

; DAC Data
ghz_sin_DAC:
	smpsPan             panCenter, $00
	dc.b	dKick, $0C, $0C

ghz_sin_Loop00:
	dc.b	$03
	smpsLoop            $00, $08, ghz_sin_Loop00

ghz_sin_Loop01:
	dc.b	dKick, $0C, dSnare
	smpsLoop            $00, $10, ghz_sin_Loop01

ghz_sin_Loop02:
	dc.b	dKick, dSnare, $06, dKick, dKick, $03, $09, dSnare, $0C, dKick, dSnare, dKick
	dc.b	dSnare
	smpsLoop            $00, $02, ghz_sin_Loop02

ghz_sin_Loop03:
	dc.b	dKick, dSnare
	smpsLoop            $00, $08, ghz_sin_Loop03

ghz_sin_Loop04:
	dc.b	dKick, dSnare, $06, dKick, dKick, $03, $09, dSnare, $0C, dKick, dSnare, dKick
	dc.b	dSnare
	smpsLoop            $00, $04, ghz_sin_Loop04
	smpsJump            ghz_sin_Loop01

; FM1 Data
ghz_sin_FM1:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nRst, $30

ghz_sin_Loop1A:
	dc.b	nCs3, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop1A

ghz_sin_Loop1B:
	dc.b	nCs3, $02, nRst, $04, nCs3, $02, nRst, $01
	smpsLoop            $00, $03, ghz_sin_Loop1B
	dc.b	nCs3, $02, nRst, $01, nCs3, $02, nRst, $04

ghz_sin_Loop1C:
	dc.b	nD3, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop1C

ghz_sin_Loop1D:
	dc.b	nD3, $02, nRst, $04, nD3, $02, nRst, $01
	smpsLoop            $00, $03, ghz_sin_Loop1D
	dc.b	nD3, $02, nRst, $01, nD3, $02, nRst, $04

ghz_sin_Loop1E:
	dc.b	nB2, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop1E

ghz_sin_Loop1F:
	dc.b	nB2, $02, nRst, $04, nB2, $02, nRst, $01
	smpsLoop            $00, $03, ghz_sin_Loop1F
	dc.b	nB2, $02, nRst, $01, nB2, $02, nRst, $04

ghz_sin_Loop20:
	dc.b	nCs3, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop20

ghz_sin_Loop21:
	dc.b	nCs3, $02, nRst, $04, nCs3, $02, nRst, $01
	smpsLoop            $00, $02, ghz_sin_Loop21
	dc.b	nCs3, $02, nRst, $04, nB2, $02, nRst, $01, nB2, $02, nRst, $01
	dc.b	nB2, $02, nRst, $04
	smpsLoop            $01, $04, ghz_sin_Loop1A

ghz_sin_Loop22:
	dc.b	nCs3, $02, nRst, $01
	smpsLoop            $00, $10, ghz_sin_Loop22

ghz_sin_Loop23:
	dc.b	nD3, $02, nRst, $01
	smpsLoop            $00, $10, ghz_sin_Loop23

ghz_sin_Loop24:
	dc.b	nB2, $02, nRst, $01
	smpsLoop            $00, $0C, ghz_sin_Loop24

ghz_sin_Loop25:
	dc.b	nD3, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop25

ghz_sin_Loop26:
	dc.b	nCs3, $02, nRst, $01
	smpsLoop            $00, $20, ghz_sin_Loop26

ghz_sin_Loop27:
	dc.b	nD3, $02, nRst, $01
	smpsLoop            $00, $10, ghz_sin_Loop27

ghz_sin_Loop28:
	dc.b	nB2, $02, nRst, $01
	smpsLoop            $00, $0C, ghz_sin_Loop28

ghz_sin_Loop29:
	dc.b	nD3, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop29

ghz_sin_Loop2A:
	dc.b	nCs3, $02, nRst, $01
	smpsLoop            $00, $10, ghz_sin_Loop2A
	smpsJump            ghz_sin_Loop1A

; FM2 Data
ghz_sin_FM2:
	smpsPan             panCenter, $00
	smpsSetvoice        $03
	dc.b	nRst, $30

ghz_sin_Jump02:
	dc.b	nB4, $06, nAb4, nRst, nB4, nA4, nRst, nB4, nA4, nRst, nFs4, $0C
	dc.b	nRst, $18, nFs4, $06, nCs5, nB4, nRst, nB4, nA4, nRst, nB4, nA4
	dc.b	nRst, nF4, $0C, nRst, $1E, nB4, $06, nAb4, nRst, nB4, nA4, nRst
	dc.b	nB4, nA4, nRst, nFs4, $0C, nRst, $18, nFs4, $06, $06, nCs4, nRst
	dc.b	nFs4, nE4, nRst, nFs4, nE4, nRst, nB3, $0C, nRst, $1E
	smpsAlterVol        $FD

ghz_sin_Loop19:
	dc.b	nB4, $06, nAb4, $0C, nB4, $06, nA4, $0C, nB4, $06, nA4, $0C
	dc.b	nFs4, $12, nRst, nFs4, $06, nCs5, nB4, $0C, $06, nA4, $0C, nB4
	dc.b	$06, nA4, $0C, nF4, $12, nRst, $18, nB4, $06, nAb4, $0C, nB4
	dc.b	$06, nA4, $0C, nB4, $06, nA4, $0C, nFs4, $12, nRst, nFs4, $06
	dc.b	$06, nCs4, $0C, nFs4, $06, nE4, $0C, nFs4, $06, nE4, nRst, nB3
	dc.b	$0C, nRst, $1E
	smpsLoop            $00, $02, ghz_sin_Loop19
	smpsAlterVol        $03
	smpsJump            ghz_sin_Jump02

; FM3 Data
ghz_sin_FM3:
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nRst, $30

ghz_sin_Loop08:
	dc.b	nCs1, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop08

ghz_sin_Loop09:
	dc.b	nCs1, $02, nRst, $04, nCs1, $02, nRst, $01
	smpsLoop            $00, $03, ghz_sin_Loop09
	dc.b	nCs1, $02, nRst, $01, nCs1, $02, nRst, $04

ghz_sin_Loop0A:
	dc.b	nD1, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop0A

ghz_sin_Loop0B:
	dc.b	nD1, $02, nRst, $04, nD1, $02, nRst, $01
	smpsLoop            $00, $03, ghz_sin_Loop0B
	dc.b	nD1, $02, nRst, $01, nD1, $02, nRst, $04

ghz_sin_Loop0C:
	dc.b	nB0, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop0C

ghz_sin_Loop0D:
	dc.b	nB0, $02, nRst, $04, nB0, $02, nRst, $01
	smpsLoop            $00, $03, ghz_sin_Loop0D
	dc.b	nB0, $02, nRst, $01, nB0, $02, nRst, $04

ghz_sin_Loop0E:
	dc.b	nCs1, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop0E

ghz_sin_Loop0F:
	dc.b	nCs1, $02, nRst, $04, nCs1, $02, nRst, $01
	smpsLoop            $00, $02, ghz_sin_Loop0F
	dc.b	nCs1, $02, nRst, $04, nB0, $02, nRst, $01, nB0, $02, nRst, $01
	dc.b	nB0, $02, nRst, $04
	smpsLoop            $01, $04, ghz_sin_Loop08

ghz_sin_Loop10:
	dc.b	nCs1, $02, nRst, $01
	smpsLoop            $00, $10, ghz_sin_Loop10

ghz_sin_Loop11:
	dc.b	nD1, $02, nRst, $01
	smpsLoop            $00, $10, ghz_sin_Loop11

ghz_sin_Loop12:
	dc.b	nB0, $02, nRst, $01
	smpsLoop            $00, $0C, ghz_sin_Loop12

ghz_sin_Loop13:
	dc.b	nD1, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop13

ghz_sin_Loop14:
	dc.b	nCs1, $02, nRst, $01
	smpsLoop            $00, $20, ghz_sin_Loop14

ghz_sin_Loop15:
	dc.b	nD1, $02, nRst, $01
	smpsLoop            $00, $10, ghz_sin_Loop15

ghz_sin_Loop16:
	dc.b	nB0, $02, nRst, $01
	smpsLoop            $00, $0C, ghz_sin_Loop16

ghz_sin_Loop17:
	dc.b	nD1, $02, nRst, $01
	smpsLoop            $00, $04, ghz_sin_Loop17

ghz_sin_Loop18:
	dc.b	nCs1, $02, nRst, $01
	smpsLoop            $00, $10, ghz_sin_Loop18
	smpsJump            ghz_sin_Loop08

; FM4 Data
ghz_sin_FM4:
	smpsPan             panCenter, $00
	smpsAlterNote       $01
	smpsSetvoice        $00
	dc.b	nRst, $30

ghz_sin_Jump01:
	dc.b	nRst, $7F, $7F, $7F, $03

ghz_sin_Loop06:
	dc.b	nB4, nB4, nRst, nCs5, nRst, $06, nE5, $03, nRst, nFs5, nRst, nCs5
	dc.b	nRst, nB4, nRst, nCs5, nRst
	smpsLoop            $00, $08, ghz_sin_Loop06
	smpsAlterVol        $01

ghz_sin_Loop07:
	dc.b	nCs3, $2F, nRst, $01, nD3, $2F, nRst, $01, nB2, $23, nRst, $01
	dc.b	nD3, $0B, nRst, $01, nCs3, $2F, nRst, $01
	smpsLoop            $00, $02, ghz_sin_Loop07
	smpsAlterVol        $FF
	smpsJump            ghz_sin_Jump01

; FM5 Data
ghz_sin_FM5:
	smpsPan             panCenter, $00
	smpsAlterNote       $0A
	smpsSetvoice        $02
	dc.b	nRst, $30

ghz_sin_Jump00:
	dc.b	nRst, $7F, $7F, $7F, $03

ghz_sin_Loop05:
	dc.b	nB4, nB4, nRst, nCs5, nRst, $06, nE5, $03, nRst, nFs5, nRst, nCs5
	dc.b	nRst, nB4, nRst, nCs5, nRst
	smpsLoop            $00, $07, ghz_sin_Loop05
	dc.b	nB4, nB4, nRst, nCs5, nRst, $06, nE5, $03, nRst, nFs5, nRst, nCs5
	dc.b	nRst, nB4, nRst, nCs5, nRst, $05
	smpsAlterVol        $FE
	dc.b	nCs3, $2F, nRst, $01, nD3, $2F, nRst, $01, nB2, $23, nRst, $01
	dc.b	nD3, $0B, nRst, $01, nCs3, $2F, nRst, $01, nCs3, $2F, nRst, $01
	dc.b	nD3, $2F, nRst, $01, nB2, $23, nRst, $01, nD3, $0B, nRst, $01
	dc.b	nCs3, $2E
	smpsAlterVol        $02
	smpsJump            ghz_sin_Jump00

; PSG1 Data
ghz_sin_PSG1:
	smpsAlterNote       $FE
	dc.b	nRst, $30

ghz_sin_Jump05:
	dc.b	nRst, $7F, $7F, $7F, $03, nCs1, $30, nD1, nB0, nCs1, nCs1, nD1
	dc.b	nB0, nCs1, nCs1, nD1, nAb1, nF1, nCs1, nD1, nB1, nAb1
	smpsJump            ghz_sin_Jump05

; PSG2 Data
ghz_sin_PSG2:
	dc.b	nRst, $30

ghz_sin_Jump04:
	dc.b	nB1, $06, nAb1, nRst, nB1, nA1, nRst, nB1, nA1, nRst, nFs1, $0C
	dc.b	nRst, $18, nFs1, $06, nCs2, nB1, nRst, nB1, nA1, nRst, nB1, nA1
	dc.b	nRst, nF1, $0C, nRst, $1E, nB1, $06, nAb1, nRst, nB1, nA1, nRst
	dc.b	nB1, nA1, nRst, nFs1, $0C, nRst, $18, nFs1, $06, $06, nCs1, nRst
	dc.b	nFs1, nE1, nRst, nFs1, nE1, nRst, nB0, $0C, nRst, $1E
	smpsPSGAlterVol     $FF

ghz_sin_Loop2D:
	dc.b	nB1, $06, nAb1, $0C, nB1, $06, nA1, $0C, nB1, $06, nA1, $0C
	dc.b	nFs1, $12, nRst, nFs1, $06, nCs2, nB1, $0C, $06, nA1, $0C, nB1
	dc.b	$06, nA1, $0C, nF1, $12, nRst, $18, nB1, $06, nAb1, $0C, nB1
	dc.b	$06, nA1, $0C, nB1, $06, nA1, $0C, nFs1, $12, nRst, nFs1, $06
	dc.b	$06, nCs1, $0C, nFs1, $06, nE1, $0C, nFs1, $06, nE1, nRst, nB0
	dc.b	$0C, nRst, $1E
	smpsLoop            $00, $02, ghz_sin_Loop2D
	smpsPSGAlterVol     $01
	smpsJump            ghz_sin_Jump04

; PSG3 Data
ghz_sin_PSG3:
	smpsPSGform         $E7
	smpsPSGAlterVol     $02
	dc.b	nMaxPSG

ghz_sin_Loop2B:
	dc.b	$03
	smpsLoop            $00, $10, ghz_sin_Loop2B

ghz_sin_Jump03:
	dc.b	nMaxPSG, $03
	smpsLoop            $01, $17, ghz_sin_Loop2B

ghz_sin_Loop2C:
	dc.b	$03
	smpsLoop            $00, $09, ghz_sin_Loop2C
	smpsJump            ghz_sin_Jump03

ghz_sin_Voices:
;	Voice $00
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

;	Voice $01
;	$38
;	$01, $02, $01, $04, 	$14, $14, $14, $14, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$16, $17, $18, $1A, 	$2F, $20, $27, $00
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $04, $01, $02, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $14, $14, $14, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0A, $08, $07, $06
	smpsVcTotalLevel    $00, $27, $20, $2F

;	Voice $02
;	$10
;	$35, $76, $70, $30, 	$DF, $DF, $5F, $5F, 	$06, $08, $09, $09
;	$06, $03, $03, $01, 	$26, $16, $06, $26, 	$21, $34, $19, $00
	smpsVcAlgorithm     $00
	smpsVcFeedback      $02
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $07, $03
	smpsVcCoarseFreq    $00, $00, $06, $05
	smpsVcRateScale     $01, $01, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $09, $09, $08, $06
	smpsVcDecayRate2    $01, $03, $03, $06
	smpsVcDecayLevel    $02, $00, $01, $02
	smpsVcReleaseRate   $06, $06, $06, $06
	smpsVcTotalLevel    $00, $19, $34, $21

;	Voice $03
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

