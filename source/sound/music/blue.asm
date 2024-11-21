blue_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     blue_Voices
	smpsHeaderChan      $05, $03
	smpsHeaderTempo     $02, $00

	smpsHeaderDAC       blue_DAC
	smpsHeaderFM        blue_FM1,	$00, $0D
	smpsHeaderFM        blue_FM2,	$00, $0D
	smpsHeaderFM        blue_FM3,	$00, $0D
	smpsHeaderFM        blue_FM4,	$00, $11
	smpsHeaderPSG       blue_PSG1,	$00, $00, $00, fTone_07
	smpsHeaderPSG       blue_PSG2,	$00, $02, $00, fTone_05
	smpsHeaderPSG       blue_PSG3,	$00, $06, $00, fTone_02

; DAC Data
blue_DAC:
	smpsPan             panCenter, $00
	dc.b	nRst, $5E, $5E, $5E, $5E, $5E, $5E, dSnare, $06, $06, $06, $06

blue_Loop00:
	dc.b	dKick, $18, dSnare, $12, dKick, $06, $18, dSnare
	smpsLoop            $00, $07, blue_Loop00
	dc.b	dKick, dSnare, $12, dKick, $06, $18

blue_Jump00:
	dc.b	dSnare, $18, dKick

blue_Loop01:
	dc.b	$0C, $0C, dSnare, $18, dKick, $0C, $0C, dSnare, $18, dKick, $0C, $06
	dc.b	$06, dSnare, dSnare, dSnare, dKick, dKick, dKick, $12, dSnare, dSnare, $06, dKick
	dc.b	$12, $06, dSnare, dSnare, dKick, dKick, $1E, dSnare, $06, $0C, dKick, $06
	smpsLoop            $00, $03, blue_Loop01
	dc.b	$0C, $0C, dSnare, $18, dKick, $0C, $0C, dSnare, $18, dKick, $0C, $06
	dc.b	$06, dSnare, dSnare, dSnare, dKick, dKick, dKick, $12, dSnare, dSnare, $06, dKick
	dc.b	$12, $06, dSnare, $24, dKick, $0C, dSnare, $06, $06, $06, $06

blue_Loop02:
	dc.b	dKick, $18, dSnare, $12, dKick, $06, $18, dSnare
	smpsLoop            $00, $07, blue_Loop02
	dc.b	dKick, dSnare, $12, dKick, $06, $18
	smpsSetTempoMod     $00
	smpsPan             panCenter, $00
	smpsJump            blue_Jump00

; FM1 Data
blue_FM1:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	smpsAlterVol        $05
	dc.b	nA1, $60, nC2, $3C, nEb2, $30, nA1, $7F, smpsNoAttack, $41, nC2, $60
	dc.b	nEb2
	smpsAlterVol        $F9

blue_Loop2C:
	dc.b	nD1

blue_Loop2B:
	dc.b	$06, $06, nRst, nD1, nD1, nD1
	smpsLoop            $00, $02, blue_Loop2B
	dc.b	nRst, nAb1, nD1, nAb1
	smpsLoop            $01, $02, blue_Loop2C

blue_Loop2D:
	dc.b	nF1, nF1, nRst, nF1, nF1, nF1
	smpsLoop            $00, $02, blue_Loop2D
	dc.b	nRst, nAb1, nF1, nAb1
	smpsLoop            $01, $02, blue_Loop2D

blue_Loop2E:
	dc.b	nD1, nD1, nRst, nD1, nD1, nD1
	smpsLoop            $00, $02, blue_Loop2E
	dc.b	nRst, nAb1, nD1, nAb1
	smpsLoop            $01, $02, blue_Loop2E

blue_Loop2F:
	dc.b	nF1, nF1, nRst, nF1, nF1, nF1
	smpsLoop            $00, $02, blue_Loop2F
	dc.b	nRst, nAb1, nF1, nAb1

blue_Loop30:
	dc.b	nF1, nF1, nRst, nF1, nF1, nF1
	smpsLoop            $00, $02, blue_Loop30

blue_Jump04:
	dc.b	nRst, $18
	smpsAlterVol        $09

blue_Loop31:
	dc.b	nBb1, $24, nD2, nC2, $48, nBb1, $24, nC2, nD2, nF1
	smpsLoop            $00, $04, blue_Loop31
	smpsAlterVol        $F7

blue_Loop33:
	dc.b	nD1

blue_Loop32:
	dc.b	$06, $06, nRst, nD1, nD1, nD1
	smpsLoop            $00, $02, blue_Loop32
	dc.b	nRst, nAb1, nD1, nAb1
	smpsLoop            $01, $02, blue_Loop33

blue_Loop34:
	dc.b	nF1, nF1, nRst, nF1, nF1, nF1
	smpsLoop            $00, $02, blue_Loop34
	dc.b	nRst, nAb1, nF1, nAb1
	smpsLoop            $01, $02, blue_Loop34

blue_Loop35:
	dc.b	nD1, nD1, nRst, nD1, nD1, nD1
	smpsLoop            $00, $02, blue_Loop35
	dc.b	nRst, nAb1, nD1, nAb1
	smpsLoop            $01, $02, blue_Loop35

blue_Loop36:
	dc.b	nF1, nF1, nRst, nF1, nF1, nF1
	smpsLoop            $00, $02, blue_Loop36
	dc.b	nRst, nAb1, nF1, nAb1

blue_Loop37:
	dc.b	nF1, nF1, nRst, nF1, nF1, nF1
	smpsLoop            $00, $02, blue_Loop37
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsJump            blue_Jump04

; FM2 Data
blue_FM2:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nD2, $60, nF2, $3C, nAb2, $30, nD2, $7F, smpsNoAttack, $41, nF2, $60
	dc.b	nAb2
	smpsAlterVol        $01
	dc.b	nD2

blue_Loop22:
	dc.b	$0C
	smpsLoop            $00, $10, blue_Loop22

blue_Loop23:
	dc.b	nC2
	smpsLoop            $00, $10, blue_Loop23

blue_Loop24:
	dc.b	nD2
	smpsLoop            $00, $10, blue_Loop24

blue_Loop25:
	dc.b	nC2
	smpsLoop            $00, $0E, blue_Loop25

blue_Jump03:
	dc.b	nRst, $18
	smpsSetvoice        $03
	smpsAlterVol        $F9

blue_Loop26:
	dc.b	nBb2, $06, $06, $06, nRst, $12, nD3, $06, $06, $06, nRst, $12
	dc.b	nC3, $06, $06, $06, nRst, nC3, nRst, nC3, nC3, nBb2, nF2, nA2
	dc.b	nD2, nBb2, nBb2, nBb2, nRst, $12, nC3, $06, $06, $06, nRst, $12
	dc.b	nD3, $06, $06, $06, nRst, $1E, nBb2, $06, nF2, nA2, nD2
	smpsLoop            $00, $03, blue_Loop26
	dc.b	nBb2, nBb2, nBb2, nRst, $12, nD3, $06, $06, $06, nRst, $12, nC3
	dc.b	$06, $06, $06, nRst, nC3, nRst, nC3, nC3, nBb2, nF2, nA2, nD2
	dc.b	nBb2, nBb2, nBb2, nRst, $12, nC3, $06, $06, $06, nRst, $12, nD3
	dc.b	$06, nRst, $42
	smpsSetvoice        $00
	smpsAlterVol        $07
	dc.b	nD2

blue_Loop27:
	dc.b	$0C
	smpsLoop            $00, $10, blue_Loop27

blue_Loop28:
	dc.b	nC2
	smpsLoop            $00, $10, blue_Loop28

blue_Loop29:
	dc.b	nD2
	smpsLoop            $00, $10, blue_Loop29

blue_Loop2A:
	dc.b	nC2
	smpsLoop            $00, $0E, blue_Loop2A
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsJump            blue_Jump03

; FM3 Data
blue_FM3:
	smpsPan             panRight, $00
	smpsAlterNote       $01
	smpsSetvoice        $00
	dc.b	nRst, $60, $60, $60, $60, $60, $60
	smpsAlterNote       $0A
	dc.b	$0C

blue_Loop12:
	dc.b	nA2

blue_Loop11:
	dc.b	$06, $06, nRst, nA2, nA2, nA2
	smpsLoop            $00, $02, blue_Loop11
	dc.b	nRst, nEb3, nA2, nEb3
	smpsLoop            $01, $02, blue_Loop12
	dc.b	nRst, $01, nC3

blue_Loop13:
	dc.b	$06, $06, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop13
	dc.b	nRst, $05, nEb3, $06, nC3, nEb3

blue_Loop14:
	dc.b	nC3, nC3, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop14
	dc.b	nRst, nEb3, nC3

blue_Loop16:
	dc.b	nEb3

blue_Loop15:
	dc.b	nA2, nA2, nRst, nA2, nA2, nA2
	smpsLoop            $00, $02, blue_Loop15
	dc.b	nRst, nEb3, nA2
	smpsLoop            $01, $02, blue_Loop16
	dc.b	nEb3

blue_Loop17:
	dc.b	nC3, nC3, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop17
	dc.b	nRst, nEb3, nC3, nEb3

blue_Loop18:
	dc.b	nC3, nC3, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop18

blue_Jump02:
	dc.b	nRst

blue_Loop19:
	dc.b	$62
	smpsLoop            $00, $0C, blue_Loop19

blue_Loop1B:
	dc.b	nA2

blue_Loop1A:
	dc.b	$06, $06, nRst, nA2, nA2, nA2
	smpsLoop            $00, $02, blue_Loop1A
	dc.b	nRst, nEb3, nA2, nEb3
	smpsLoop            $01, $02, blue_Loop1B
	dc.b	nRst, $01, nC3

blue_Loop1C:
	dc.b	$06, $06, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop1C
	dc.b	nRst, $05, nEb3, $06, nC3, nEb3

blue_Loop1D:
	dc.b	nC3, nC3, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop1D
	dc.b	nRst, nEb3, nC3

blue_Loop1F:
	dc.b	nEb3

blue_Loop1E:
	dc.b	nA2, nA2, nRst, nA2, nA2, nA2
	smpsLoop            $00, $02, blue_Loop1E
	dc.b	nRst, nEb3, nA2
	smpsLoop            $01, $02, blue_Loop1F
	dc.b	nEb3

blue_Loop20:
	dc.b	nC3, nC3, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop20
	dc.b	nRst, nEb3, nC3, nEb3

blue_Loop21:
	dc.b	nC3, nC3, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop21
	smpsPan             panRight, $00
	smpsSetvoice        $00
	smpsJump            blue_Jump02

; FM4 Data
blue_FM4:
	smpsPan             panLeft, $00
	smpsSetvoice        $00
	dc.b	nRst, $7F, $4D
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nD5, $0C, nA5, nAb5, nA5, nD6, nEb6, nCs6, nD6, nA5, nD6, nEb6
	dc.b	nCs6, nFs5, nFs6, nF6, nD6, nF5, nBb5, nCs6, nD6, nCs6, nBb5, nA5
	dc.b	nBb5, nFs5, nFs6, nF6, nA5, nC6, nCs6, nC6, nA5
	smpsSetvoice        $00
	smpsPan             panLeft, $00
	smpsAlterVol        $FC

blue_Loop04:
	dc.b	nA2

blue_Loop03:
	dc.b	$06, $06, nRst, nA2, nA2, nA2
	smpsLoop            $00, $02, blue_Loop03
	dc.b	nRst, nEb3, nA2, nEb3
	smpsLoop            $01, $02, blue_Loop04
	dc.b	nRst, $01, nC3

blue_Loop05:
	dc.b	$06, $06, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop05
	dc.b	nRst, $05, nEb3, $06, nC3, nEb3, nC3, nC3, nRst, nC3, nC3, nC3
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$06, nRst, nC3, nC3, nC3, nRst, nEb3, nC3, nEb3

blue_Loop06:
	dc.b	nA2, nA2, nRst, nA2, nA2, nA2
	smpsLoop            $00, $02, blue_Loop06
	dc.b	nRst, nEb3
	smpsAlterVol        $01
	dc.b	nA2
	smpsAlterVol        $FF
	dc.b	nEb3

blue_Loop07:
	dc.b	nA2, nA2, nRst, nA2, nA2, nA2
	smpsLoop            $00, $02, blue_Loop07
	dc.b	nRst, nEb3, nA2, nEb3

blue_Loop08:
	dc.b	nC3, nC3, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop08
	dc.b	nRst, nEb3, nC3, nEb3

blue_Loop09:
	dc.b	nC3, nC3, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop09

blue_Jump01:
	dc.b	nRst, $18
	smpsPan             panCenter, $00
	smpsSetvoice        $02
	smpsAlterVol        $01
	dc.b	nF4, $24, nC5, nG4, $3C, nRst, $0C, nBb4, $24, nA4, nF4, nG4
	dc.b	nF4, nC5, nE4, $3C, nRst, $0C, nG4, $24, nF4, nE4, nF4, nG4
	dc.b	nF4, nG4, $3C, nRst, $0C, nG4, $24, nA4, nD4, nF4, nBb4, nA4
	dc.b	nE4, $3C, nRst, $0C, nG4, $24, nF4, nE4, nF4
	smpsSetvoice        $00
	smpsPan             panLeft, $00
	smpsAlterVol        $FF

blue_Loop0B:
	dc.b	nA2

blue_Loop0A:
	dc.b	$06, $06, nRst, nA2, nA2, nA2
	smpsLoop            $00, $02, blue_Loop0A
	dc.b	nRst, nEb3, nA2, nEb3
	smpsLoop            $01, $02, blue_Loop0B
	dc.b	nRst, $01, nC3

blue_Loop0C:
	dc.b	$06, $06, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop0C
	dc.b	nRst, $05, nEb3, $06, nC3, nEb3, nC3, nC3, nRst, nC3, nC3, nC3
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$06, nRst, nC3, nC3, nC3, nRst, nEb3, nC3, nEb3

blue_Loop0D:
	dc.b	nA2, nA2, nRst, nA2, nA2, nA2
	smpsLoop            $00, $02, blue_Loop0D
	dc.b	nRst, nEb3
	smpsAlterVol        $01
	dc.b	nA2
	smpsAlterVol        $FF
	dc.b	nEb3

blue_Loop0E:
	dc.b	nA2, nA2, nRst, nA2, nA2, nA2
	smpsLoop            $00, $02, blue_Loop0E
	dc.b	nRst, nEb3, nA2, nEb3

blue_Loop0F:
	dc.b	nC3, nC3, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop0F
	dc.b	nRst, nEb3, nC3, nEb3

blue_Loop10:
	dc.b	nC3, nC3, nRst, nC3, nC3, nC3
	smpsLoop            $00, $02, blue_Loop10
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsJump            blue_Jump01

; PSG1 Data
blue_PSG1:
	smpsPSGAlterVol     $01
	dc.b	nA0, $60, nC0, $3C, nEb0, $30, nA0, $7F, smpsNoAttack, $41, nC0, $60
	dc.b	nEb0
	smpsPSGAlterVol     $03
	dc.b	nD0

blue_Loop3E:
	dc.b	$0C
	smpsLoop            $00, $10, blue_Loop3E

blue_Loop3F:
	dc.b	nC1
	smpsLoop            $00, $10, blue_Loop3F

blue_Loop40:
	dc.b	nD0
	smpsLoop            $00, $10, blue_Loop40

blue_Loop41:
	dc.b	nC1
	smpsLoop            $00, $0E, blue_Loop41

blue_Jump07:
	dc.b	nRst, $18
	smpsPSGAlterVol     $FD

blue_Loop43:
	dc.b	nF1, $06, nC1, nF0, nF1, nC1, nF0, nG1, nC1, nG1, nC1, nA0
	dc.b	nG1, nA0, nG0, nG1, nC1, nG0, nG1, nD1, nG0, nF1, nF0, nA0
	dc.b	nF0, nG0, nC1, nD1, nF1, nD1, nG0, nC1, nD1, nF1, nD1, nG0
	dc.b	nD1

blue_Loop42:
	dc.b	nF1, nD1, nG0
	smpsLoop            $00, $04, blue_Loop42
	smpsLoop            $01, $03, blue_Loop43
	dc.b	nF1, nC1, nF0, nF1, nC1, nF0, nG1, nC1, nG1, nC1, nA0, nG1
	dc.b	nA0, nG0, nG1, nC1, nG0, nG1, nD1, nG0, nF1, nF0, nA0, nF0
	dc.b	nG0, nC1, nD1, nF1, nD1, nG0, nC1, nD1, nF1, nD1, nG0, nD1
	dc.b	nF1, nRst, $42
	smpsPSGAlterVol     $03
	dc.b	nD0

blue_Loop44:
	dc.b	$0C
	smpsLoop            $00, $10, blue_Loop44

blue_Loop45:
	dc.b	nC1
	smpsLoop            $00, $10, blue_Loop45

blue_Loop46:
	dc.b	nD0
	smpsLoop            $00, $10, blue_Loop46

blue_Loop47:
	dc.b	nC1
	smpsLoop            $00, $0E, blue_Loop47
	smpsAlterNote       $00
	smpsPSGvoice        fTone_07
	smpsJump            blue_Jump07

; PSG2 Data
blue_PSG2:
	dc.b	nRst, $7F, $4D

blue_Loop3D:
	dc.b	nD2, $0C, nA2, nAb2, nA2, nD3, nEb3, nCs3, nD3, nA2, nD3, nEb3
	dc.b	nCs3, nFs2, nFs3, nF3, nD3, nF2, nBb2, nCs3, nD3, nCs3, nBb2, nA2
	dc.b	nBb2, nFs2, nFs3, nF3, nA2, nC3, nCs3, nC3, nA2
	smpsLoop            $00, $02, blue_Loop3D
	dc.b	nD2, nA2, nAb2, nA2, nD3, nEb3, nCs3, nD3, nA2, nD3, nEb3, nCs3
	dc.b	nFs2, nFs3, nF3, nD3, nF2, nBb2, nCs3, nD3, nCs3, nBb2, nA2, nBb2
	dc.b	nFs2, nFs3, nF3, nA2, nC3, nCs3

blue_Jump06:
	dc.b	nC3, $06, nRst, $12
	smpsPSGvoice        $00
	dc.b	$03
	smpsPSGAlterVol     $04
	dc.b	nF2, $24, nC3, nG2, $3C, nRst, $0C, nBb2, $24, nA2, nF2, nG2
	dc.b	nF2, nC3, nE2, $3C, nRst, $0C, nG2, $24, nF2, nE2, nF2, nG2
	dc.b	nF2, nG2, $3C, nRst, $0C, nG2, $24, nA2, nD2, nF2, nBb2, nA2
	dc.b	nE2, $3C, nRst, $0C, nG2, $24, nF2, nE2, nF2, $21
	smpsPSGvoice        fTone_05
	smpsPSGAlterVol     $FC
	dc.b	nD2, $0C, nA2, nAb2, nA2, nD3, nEb3, nCs3, nD3, nA2, nD3, nEb3
	dc.b	nCs3, nFs2, nFs3, nF3, nD3, nF2, nBb2, nCs3, nD3, nCs3, nBb2, nA2
	dc.b	nBb2, nFs2, nFs3, nF3, nA2, nC3, nCs3, nC3, nA2, nD2, nA2, nAb2
	dc.b	nA2, nD3, nEb3, nCs3, nD3, nA2, nD3, nEb3, nCs3, nFs2, nFs3, nF3
	dc.b	nD3, nF2, nBb2, nCs3, nD3, nCs3, nBb2, nA2, nBb2, nFs2, nFs3, nF3
	dc.b	nA2, nC3, nCs3
	smpsAlterNote       $00
	smpsPSGvoice        fTone_05
	smpsJump            blue_Jump06

; PSG3 Data
blue_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $78, $78, $78, $78, $78, nMaxPSG

blue_Loop38:
	dc.b	$0C
	smpsLoop            $00, $1E, blue_Loop38
	dc.b	$18

blue_Loop39:
	dc.b	$0C
	smpsLoop            $00, $1D, blue_Loop39

blue_Jump05:
	dc.b	nMaxPSG, $18

blue_Loop3A:
	dc.b	$0C
	smpsLoop            $00, $5A, blue_Loop3A
	dc.b	$54

blue_Loop3B:
	dc.b	$0C
	smpsLoop            $00, $1E, blue_Loop3B
	dc.b	$18

blue_Loop3C:
	dc.b	$0C
	smpsLoop            $00, $1D, blue_Loop3C
	smpsAlterNote       $00
	smpsJump            blue_Jump05

blue_Voices:
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

;	Voice $02
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

;	Voice $03
;	$2C
;	$70, $40, $21, $60, 	$9F, $1F, $1F, $5F, 	$0C, $09, $0C, $15
;	$04, $04, $06, $06, 	$56, $46, $46, $4F, 	$0C, $00, $10, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $06, $02, $04, $07
	smpsVcCoarseFreq    $00, $01, $00, $00
	smpsVcRateScale     $01, $00, $00, $02
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $15, $0C, $09, $0C
	smpsVcDecayRate2    $06, $06, $04, $04
	smpsVcDecayLevel    $04, $04, $04, $05
	smpsVcReleaseRate   $0F, $06, $06, $06
	smpsVcTotalLevel    $00, $10, $00, $0C

