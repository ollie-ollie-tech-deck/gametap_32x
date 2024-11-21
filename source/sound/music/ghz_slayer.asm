ghz_slayer_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     ghz_slayer_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $00

	smpsHeaderDAC       ghz_slayer_DAC
	smpsHeaderFM        ghz_slayer_FM1,	$00, $0C
	smpsHeaderFM        ghz_slayer_FM2,	$00, $0C
	smpsHeaderFM        ghz_slayer_FM3,	$00, $0A
	smpsHeaderFM        ghz_slayer_FM4,	$00, $0C
	smpsHeaderFM        ghz_slayer_FM5,	$00, $10
	smpsHeaderPSG       ghz_slayer_PSG1,	$00, $00, $00, $00
	smpsHeaderPSG       ghz_slayer_PSG2,	$00, $00, $00, $00
	smpsHeaderPSG       ghz_slayer_PSG3,	$00, $04, $00, $00

; DAC Data
ghz_slayer_DAC:
	smpsPan             panCenter, $00
	dc.b	dLowTimpani

ghz_slayer_Loop00:
	dc.b	$06, $06, $54
	smpsLoop            $00, $04, ghz_slayer_Loop00
	dc.b	dKick, $03, $03, $03, $03

ghz_slayer_Loop02:
	dc.b	dSnare

ghz_slayer_Loop01:
	dc.b	dKick
	smpsLoop            $00, $07, ghz_slayer_Loop01
	smpsLoop            $01, $1F, ghz_slayer_Loop02
	dc.b	dSnare, dKick, dKick, dKick, dKick, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	dc.b	$0C, $06

ghz_slayer_Loop03:
	dc.b	dSnare, dKick
	smpsLoop            $00, $4E, ghz_slayer_Loop03
	dc.b	dSnare, dSnare, $03, $03, $06

ghz_slayer_Loop04:
	dc.b	dKick, dSnare
	smpsLoop            $00, $20, ghz_slayer_Loop04

ghz_slayer_Loop05:
	dc.b	dKick, $0C, dSnare
	smpsLoop            $00, $04, ghz_slayer_Loop05
	dc.b	dKick

ghz_slayer_Loop06:
	dc.b	$03, $03, dSnare, dKick
	smpsLoop            $00, $06, ghz_slayer_Loop06
	dc.b	dSnare, $0C, $0C

ghz_slayer_Loop07:
	dc.b	dKick, dSnare
	smpsLoop            $00, $04, ghz_slayer_Loop07
	dc.b	dKick

ghz_slayer_Loop08:
	dc.b	$03, $03, dSnare, dKick
	smpsLoop            $00, $06, ghz_slayer_Loop08
	dc.b	dSnare, $0C, dKick, dKick, dSnare, $06, $03

ghz_slayer_Loop09:
	dc.b	dKick, dKick, dKick, dSnare
	smpsLoop            $00, $0C, ghz_slayer_Loop09
	dc.b	dKick, dSnare, $0C, $0C, dKick, dSnare, $06, $03

ghz_slayer_Loop0A:
	dc.b	dKick, dKick, dKick, dSnare
	smpsLoop            $00, $08, ghz_slayer_Loop0A
	dc.b	dKick, dKick, $06

ghz_slayer_Loop0B:
	dc.b	dSnare, $03, dKick, dKick, dKick
	smpsLoop            $00, $03, ghz_slayer_Loop0B
	dc.b	dSnare, dKick, dSnare, $0C, $0C
	smpsSetTempoMod     $00
	smpsPan             panCenter, $00
	smpsJump            ghz_slayer_DAC

; FM1 Data
ghz_slayer_FM1:
	smpsPan             panCenter, $00
	smpsAlterVol        $01
	smpsAlterNote       $00
	smpsSetvoice        $00

ghz_slayer_Loop39:
	dc.b	nEb1, $06, $06, $06, nRst, $4E
	smpsLoop            $00, $04, ghz_slayer_Loop39

ghz_slayer_Loop3B:
	dc.b	nEb1

ghz_slayer_Loop3A:
	dc.b	$03, $03, $06
	smpsLoop            $00, $0C, ghz_slayer_Loop3A
	dc.b	$06, nF1, nG1, nC2, nE2, nEb2, nB1, nBb1
	smpsLoop            $01, $04, ghz_slayer_Loop3B

ghz_slayer_Loop3C:
	dc.b	nEb1, $05, nRst, $07, nE1, $05, nRst, $07
	smpsLoop            $00, $04, ghz_slayer_Loop3C
	dc.b	nAb1

ghz_slayer_Loop3D:
	dc.b	$06, $06, nA1, nAb1
	smpsLoop            $00, $07, ghz_slayer_Loop3D
	dc.b	nFs1, $0C, nA1, $06, nAb1
	smpsLoop            $01, $02, ghz_slayer_Loop3D

ghz_slayer_Loop3E:
	dc.b	nAb1, nAb1, nA1, nAb1
	smpsLoop            $00, $07, ghz_slayer_Loop3E
	dc.b	nFs1, $0C, nA1

ghz_slayer_Loop3F:
	dc.b	nEb1, $06, $03, $03, $03, $03, $06, nFs1, nEb2, nD2, $0C, nEb1
	dc.b	$06, $03, $03, $03, $03, $06, nBb1, $0C, nCs2
	smpsLoop            $00, $08, ghz_slayer_Loop3F

ghz_slayer_Loop41:
	dc.b	nEb1, $06, $06, $06, $06, nRst, $18, nEb1, $06, $06, $06, nRst
	dc.b	$1E, nA1

ghz_slayer_Loop40:
	dc.b	$03
	smpsLoop            $00, $18, ghz_slayer_Loop40
	dc.b	nAb1, $0C, $0C
	smpsLoop            $01, $04, ghz_slayer_Loop41
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	smpsAlterVol        $FF
	smpsJump            ghz_slayer_FM1

; FM2 Data
ghz_slayer_FM2:
	smpsPan             panRight, $00
	smpsAlterVol        $FE
	smpsAlterNote       $00
	smpsSetvoice        $00
	dc.b	nEb2, $06, $06, $06, nEb3, nBb3, nG3, nBb3, $0C, nA3, $06, nBb3
	dc.b	nA3, $0C, nF3, $18, nEb2, $06, $06, $06, nF3, nD4, nRst, $01
	dc.b	nC4, $05, nBb3, $0C, nA3, $06, nBb3, nA3, $0C, nF3, $18, nEb2
	dc.b	$06, $06, $06, nEb3, nBb3, nG3, nBb3, $0C, nA3, $06, nBb3, nA3
	dc.b	$0C, nF3, $18, nEb2, $06, $06, $06, nG3, nG3, nEb3, nG3, $0C
	dc.b	nF3, $06, nG3, nF3, $0C, nBb2, $18

ghz_slayer_Loop2F:
	dc.b	nEb2

ghz_slayer_Loop2E:
	dc.b	$03, $03, $06
	smpsLoop            $00, $0C, ghz_slayer_Loop2E
	dc.b	$06, nF2, nG2, nC3, nE3, nEb3, nB2, nBb2
	smpsLoop            $01, $04, ghz_slayer_Loop2F

ghz_slayer_Loop30:
	dc.b	nAb2, $03, nFs2, nF2, nEb2, nA2, nG2, nFs2, nEb2
	smpsLoop            $00, $07, ghz_slayer_Loop30

ghz_slayer_Loop33:
	dc.b	nAb2, nFs2, nF2, nEb2, nE3, $06, nEb2, $03, nFs2

ghz_slayer_Loop31:
	dc.b	nAb2, nFs2, nF2, nEb2, nA2, nG2, nFs2, nEb2
	smpsLoop            $00, $03, ghz_slayer_Loop31
	dc.b	nCs3, $0C, nE3, $06, nEb2, $03, nFs2

ghz_slayer_Loop32:
	dc.b	nAb2, nFs2, nF2, nEb2, nA2, nG2, nFs2, nEb2
	smpsLoop            $00, $03, ghz_slayer_Loop32
	smpsLoop            $01, $02, ghz_slayer_Loop33
	dc.b	nAb2, nFs2, nF2, nEb2, nE3, $06, nEb2, $03, nFs2

ghz_slayer_Loop34:
	dc.b	nAb2, nFs2, nF2, nEb2, nA2, nG2, nFs2, nEb2
	smpsLoop            $00, $03, ghz_slayer_Loop34
	dc.b	nFs2, $0C, nA2, nEb2, $06, $03, $03, $03, $03, $06, nB2, nEb3
	dc.b	nD3, $0C, nEb3, $06, nEb2

ghz_slayer_Loop35:
	dc.b	$03, $03, $03, $03, $06, nBb2, $0C, nCs3, nEb2, $06, $03, $03
	dc.b	$03, $03, $06, nB2, nEb3, nD3, $0C, nEb2, $06
	smpsLoop            $00, $07, ghz_slayer_Loop35
	dc.b	$03, $03, $03, $03, $06, nBb2, $0C, nCs3

ghz_slayer_Loop38:
	dc.b	nEb2, $06, $06, $06, $06, nEb3, $03, nBb3, nG3, nBb3, nA3, $0C
	dc.b	nEb2, $06, $06, $06, nD4, nC4, nBb3, nA3, $0C, nD4

ghz_slayer_Loop36:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop36
	dc.b	nAb3, $0C, $0C, nEb2, $06, $06, $06, $06, nEb3, $03, nBb3, nG3
	dc.b	nBb3, nA3, $0C, nEb2, $06, $06, $06, nG3, nG3, nEb3, nG3, $0C
	dc.b	nD4

ghz_slayer_Loop37:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop37
	dc.b	nAb3, $0C, $0C
	smpsLoop            $01, $02, ghz_slayer_Loop38
	smpsPan             panRight, $00
	smpsSetvoice        $00
	smpsAlterVol        $02
	smpsJump            ghz_slayer_FM2

; FM3 Data
ghz_slayer_FM3:
	smpsPan             panLeft, $00
	smpsAlterNote       $09

ghz_slayer_Jump01:
	smpsSetvoice        $00
	dc.b	nRst, $01, nEb2, $06, $06, $06, nEb3, nBb3, nG3, nBb3, $0C, nA3
	dc.b	$06, nBb3, nA3, $0C, nF3, $18, nEb2, $06, $06, $06, nF3, nD4
	dc.b	nC4, nBb3, $0C, nA3, $06, nBb3, nA3, $0C, nF3, $18, nEb2, $06
	dc.b	$06, $06, nAb3, nEb4, nC4, nEb4, $0C, nD4, $06, nEb4, nD4, $0C
	dc.b	nBb3, $18, nEb2, $06, $06, $06, nC4, nC4, nAb3, nC4, $0C, nBb3
	dc.b	$06, nC4, nBb3, $0C, nEb3, $18

ghz_slayer_Loop23:
	dc.b	nEb2

ghz_slayer_Loop22:
	dc.b	$03, $03, $06
	smpsLoop            $00, $0C, ghz_slayer_Loop22
	dc.b	$06, nF2, nG2, nC3, nE3, nEb3, nB2, nBb2
	smpsLoop            $01, $04, ghz_slayer_Loop23

ghz_slayer_Loop24:
	dc.b	nAb2, $03, nFs2, nF2, nEb2, nA2, nG2, nFs2, nEb2
	smpsLoop            $00, $07, ghz_slayer_Loop24

ghz_slayer_Loop27:
	dc.b	nAb2, nFs2, nF2, nEb2, nA2, $06, nEb2, $03, nFs2

ghz_slayer_Loop25:
	dc.b	nAb2, nFs2, nF2, nEb2, nA2, nG2, nFs2, nEb2
	smpsLoop            $00, $03, ghz_slayer_Loop25
	dc.b	nFs2, $0C, nA2, $06, nEb2, $03, nFs2

ghz_slayer_Loop26:
	dc.b	nAb2, nFs2, nF2, nEb2, nA2, nG2, nFs2, nEb2
	smpsLoop            $00, $03, ghz_slayer_Loop26
	smpsLoop            $01, $02, ghz_slayer_Loop27
	dc.b	nAb2, nFs2, nF2, nEb2, nA2, $06, nEb2, $03, nFs2

ghz_slayer_Loop28:
	dc.b	nAb2, nFs2, nF2, nEb2, nA2, nG2, nFs2, nEb2
	smpsLoop            $00, $03, ghz_slayer_Loop28
	dc.b	nCs3, $0C, nE3

ghz_slayer_Loop29:
	dc.b	nEb3, $06, $03, $03, $03, $03, $06, nFs3, nBb3, nA3, $0C, nEb3
	dc.b	$06, $03, $03, $03, $03, $06, nF3, $0C, nAb3
	smpsLoop            $00, $08, ghz_slayer_Loop29
	dc.b	nEb2, $06, $06, $06, $06, nEb3, $03, nBb3, nG3, nBb3, nA3, $0C
	dc.b	nEb2, $06, $06, $06, nD4, nC4, nBb3, nA3, $0C, nD3

ghz_slayer_Loop2A:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop2A
	dc.b	nAb2, $0C, $0C, nEb2, $06, $06, $06, $06, nEb3, $03, nBb3, nG3
	dc.b	nBb3, nA3, $0C, nEb2, $06, $06, $06, nG3, nG3, nEb3, nG3, $0C
	dc.b	nD3

ghz_slayer_Loop2B:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop2B
	dc.b	nAb2, $0C, $0C, nEb2, $06, $06, $06, $06, nEb3, $03, nBb3, nG3
	dc.b	nBb3, nA3, $0C, nEb2, $06, $06, $06, nD4, nC4, nBb3, nA3, $0C
	dc.b	nD3

ghz_slayer_Loop2C:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop2C
	dc.b	nAb2, $0C, $0C, nEb2, $06, $06, $06, $06, nEb3, $03, nBb3, nG3
	dc.b	nBb3, nA3, $0C, nEb2, $06, $06, $06, nG3, nG3, nEb3, nG3, $0C
	dc.b	nD3

ghz_slayer_Loop2D:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop2D
	dc.b	nAb2, $0C, $0B
	smpsSetvoice        $00
	smpsJump            ghz_slayer_Jump01

; FM4 Data
ghz_slayer_FM4:
	smpsPan             panRight, $00
	smpsAlterVol        $04
	smpsAlterNote       $00
	smpsSetvoice        $00
	dc.b	nEb1, $06, $06, $06, nEb2, nBb2, nG2, nBb2, $0C, nA2, $06, nBb2
	dc.b	nA2, $0C, nF2, $18, nEb1, $06, $06, $06, nF2, nD3, nRst, $01
	dc.b	nC3, $05, nBb2, $0C, nA2, $06, nBb2, nA2, $0C, nF2, $18, nEb1
	dc.b	$06, $06, $06, nEb2, nBb2, nG2, nBb2, $0C, nA2, $06, nBb2, nA2
	dc.b	$0C, nF2, $18, nEb1, $06, $06, $06, nG2, nG2, nEb2, nG2, $0C
	dc.b	nF2, $06, nG2, nF2, $0C, nBb1, $18, nRst

ghz_slayer_Loop17:
	dc.b	$60
	smpsLoop            $00, $08, ghz_slayer_Loop17

ghz_slayer_Loop18:
	dc.b	nAb1, $03, nFs1, nF1, nEb1, nA1, nG1, nFs1, nEb1
	smpsLoop            $00, $07, ghz_slayer_Loop18

ghz_slayer_Loop1B:
	dc.b	nAb1, nFs1, nF1, nEb1, nE2, $06, nEb1, $03, nFs1

ghz_slayer_Loop19:
	dc.b	nAb1, nFs1, nF1, nEb1, nA1, nG1, nFs1, nEb1
	smpsLoop            $00, $03, ghz_slayer_Loop19
	dc.b	nCs2, $0C, nE2, $06, nEb1, $03, nFs1

ghz_slayer_Loop1A:
	dc.b	nAb1, nFs1, nF1, nEb1, nA1, nG1, nFs1, nEb1
	smpsLoop            $00, $03, ghz_slayer_Loop1A
	smpsLoop            $01, $02, ghz_slayer_Loop1B
	dc.b	nAb1, nFs1, nF1, nEb1, nE2, $06, nEb1, $03, nFs1

ghz_slayer_Loop1C:
	dc.b	nAb1, nFs1, nF1, nEb1, nA1, nG1, nFs1, nEb1
	smpsLoop            $00, $03, ghz_slayer_Loop1C
	dc.b	nFs1, $0C, nA1, nRst

ghz_slayer_Loop1D:
	dc.b	$63
	smpsLoop            $00, $08, ghz_slayer_Loop1D
	dc.b	nEb2, $03, nBb2, nG2, nBb2, nA2, $0C, nRst, $12, nD3, $06, nC3
	dc.b	nBb2, nA2, $0C, nD3

ghz_slayer_Loop1E:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop1E
	dc.b	nAb2, $0C, $0C, nRst, $18, nEb2, $03, nBb2, nG2, nBb2, nA2, $0C
	dc.b	nRst, $12, nG2, $06, $06, nEb2, nG2, $0C, nD3

ghz_slayer_Loop1F:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop1F
	dc.b	nAb2, $0C, $0C, nRst, $18, nEb2, $03, nBb2, nG2, nBb2, nA2, $0C
	dc.b	nRst, $12, nD3, $06, nC3, nBb2, nA2, $0C, nD3

ghz_slayer_Loop20:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop20
	dc.b	nAb2, $0C, $0C, nRst, $18, nEb2, $03, nBb2, nG2, nBb2, nA2, $0C
	dc.b	nRst, $12, nG2, $06, $06, nEb2, nG2, $0C, nD3

ghz_slayer_Loop21:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop21
	dc.b	nAb2, $0C, $0C
	smpsPan             panRight, $00
	smpsSetvoice        $00
	smpsAlterVol        $FC
	smpsJump            ghz_slayer_FM4

; FM5 Data
ghz_slayer_FM5:
	smpsPan             panLeft, $00
	smpsAlterNote       $09

ghz_slayer_Jump00:
	smpsSetvoice        $00
	dc.b	nRst, $13, nEb2, $06, nBb2, nG2, nBb2, $0C, nA2, $06, nBb2, nA2
	dc.b	$0C, nF2, $18, nRst, $12, nF2, $06, nD3, nC3, nBb2, $0C, nA2
	dc.b	$06, nBb2, nA2, $0C, nF2, $18, nRst, $12, nAb2, $06, nEb3, nC3
	dc.b	nEb3, $0C, nD3, $06, nEb3, nD3, $0C, nBb2, $18, nRst, $12, nC3
	dc.b	$06, $06, nAb2, nC3, $0C, nBb2, $06, nC3, nBb2, $0C, nEb2, $18
	dc.b	nRst

ghz_slayer_Loop0C:
	dc.b	$60
	smpsLoop            $00, $08, ghz_slayer_Loop0C

ghz_slayer_Loop0D:
	dc.b	nAb1, $03, nFs1, nF1, nEb1, nA1, nG1, nFs1, nEb1
	smpsLoop            $00, $07, ghz_slayer_Loop0D
	dc.b	nAb1, nFs1, nF1, nEb1, nA1, $06

ghz_slayer_Loop10:
	dc.b	nEb1, $03, nFs1

ghz_slayer_Loop0E:
	dc.b	nAb1, nFs1, nF1, nEb1, nA1, nG1, nFs1, nEb1
	smpsLoop            $00, $03, ghz_slayer_Loop0E
	dc.b	nRst, $12, nEb1, $03, nFs1

ghz_slayer_Loop0F:
	dc.b	nAb1, nFs1, nF1, nEb1, nA1, nG1, nFs1, nEb1
	smpsLoop            $00, $03, ghz_slayer_Loop0F
	dc.b	nAb1, nFs1, nF1, nEb1, nRst, $06
	smpsLoop            $01, $02, ghz_slayer_Loop10
	dc.b	nEb1, $03, nFs1

ghz_slayer_Loop11:
	dc.b	nAb1, nFs1, nF1, nEb1, nA1, nG1, nFs1, nEb1
	smpsLoop            $00, $03, ghz_slayer_Loop11
	dc.b	nCs2, $0C, nE2

ghz_slayer_Loop12:
	dc.b	nEb2, $06, $03, $03, $03, $03, $06, nFs2, nBb2, nA2, $0C, nEb2
	dc.b	$06, $03, $03, $03, $03, $06, nF2, $0C, nAb2
	smpsLoop            $00, $08, ghz_slayer_Loop12
	dc.b	nRst, $18, nEb2, $03, nBb2, nG2, nBb2, nA2, $0C, nRst, $12, nD3
	dc.b	$06, nC3, nBb2, nA2, $0C, nD2

ghz_slayer_Loop13:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop13
	dc.b	nAb1, $0C, $0C, nRst, $18, nEb2, $03, nBb2, nG2, nBb2, nA2, $0C
	dc.b	nRst, $12, nG2, $06, $06, nEb2, nG2, $0C, nD2

ghz_slayer_Loop14:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop14
	dc.b	nAb1, $0C, $0C, nRst, $18, nEb2, $03, nBb2, nG2, nBb2, nA2, $0C
	dc.b	nRst, $12, nD3, $06, nC3, nBb2, nA2, $0C, nD2

ghz_slayer_Loop15:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop15
	dc.b	nAb1, $0C, $0C, nRst, $18, nEb2, $03, nBb2, nG2, nBb2, nA2, $0C
	dc.b	nRst, $12, nG2, $06, $06, nEb2, nG2, $0C, nD2

ghz_slayer_Loop16:
	dc.b	$06
	smpsLoop            $00, $0C, ghz_slayer_Loop16
	dc.b	nAb1, $0C, $0B
	smpsSetvoice        $00
	smpsJump            ghz_slayer_Jump00

; PSG3 Data
ghz_slayer_PSG3:
	smpsPSGform         $E7

ghz_slayer_Jump02:
	smpsAlterNote       $00
	dc.b	nRst, $7F, $7F, $7F, $03
	smpsPSGvoice        fTone_01
	dc.b	nMaxPSG

ghz_slayer_Loop42:
	dc.b	$06
	smpsLoop            $00, $7F, ghz_slayer_Loop42
	dc.b	$66
	smpsPSGvoice        fTone_02

ghz_slayer_Loop43:
	dc.b	$06
	smpsLoop            $00, $DF, ghz_slayer_Loop43
	dc.b	$12
	smpsPSGvoice        fTone_01

ghz_slayer_Loop44:
	dc.b	$0C
	smpsLoop            $00, $07, ghz_slayer_Loop44

ghz_slayer_Loop45:
	dc.b	$06
	smpsLoop            $00, $0B, ghz_slayer_Loop45
	dc.b	$2A

ghz_slayer_Loop46:
	dc.b	$0C
	smpsLoop            $00, $07, ghz_slayer_Loop46

ghz_slayer_Loop47:
	dc.b	$06
	smpsLoop            $00, $0B, ghz_slayer_Loop47

ghz_slayer_Loop49:
	dc.b	$1E

ghz_slayer_Loop48:
	dc.b	$06
	smpsLoop            $00, $1B, ghz_slayer_Loop48
	smpsLoop            $01, $02, ghz_slayer_Loop49
	dc.b	$1E
	smpsJump            ghz_slayer_Jump02

; PSG1 Data
ghz_slayer_PSG1:
; PSG2 Data
ghz_slayer_PSG2:
	smpsStop

ghz_slayer_Voices:
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

