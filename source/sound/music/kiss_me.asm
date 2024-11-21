kissme_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     kissme_Voices
	smpsHeaderChan      $06, $00
	smpsHeaderTempo     $02, $06

	smpsHeaderDAC       kissme_DAC
	smpsHeaderFM        kissme_FM1,	$00, $06
	smpsHeaderFM        kissme_FM2,	$00, $04
	smpsHeaderFM        kissme_FM3,	$00, $04
	smpsHeaderFM        kissme_FM4,	$00, $04
	smpsHeaderFM        kissme_FM5,	$00, $0A

; DAC Data
kissme_DAC:
	smpsPan             panCenter, $00
	dc.b	nRst, $7F, $41

kissme_Loop00:
	dc.b	dKick, $0C

kissme_Loop01:
	dc.b	dSnare, dKick, $06, $06, dSnare, $0C
	smpsLoop            $00, $04, kissme_Loop00

kissme_Jump00:
	dc.b	dKick, $0C
	smpsLoop            $01, $02, kissme_Loop01
	dc.b	dSnare, dKick, $06, $06, dSnare, $0C, dKick, dSnare, dKick, $06, $06, dSnare
	dc.b	$09, $03, $09, $03, $0C

kissme_Loop02:
	dc.b	dKick, $06, $06, dSnare, $0C, dKick, dSnare
	smpsLoop            $00, $07, kissme_Loop02
	dc.b	dKick, $06, $06, dSnare, $09, $03, $09, $03, $0C

kissme_Loop03:
	dc.b	dKick, dSnare, dKick, $06, $06, dSnare, $0C
	smpsLoop            $00, $09, kissme_Loop03
	dc.b	dKick, dSnare, $06, $06

kissme_Loop04:
	dc.b	dKick, $0C, dSnare, dKick, $06, $06, dSnare, $0C
	smpsLoop            $00, $18, kissme_Loop04
	smpsSetTempoMod     $06
	smpsPan             panCenter, $00
	smpsJump            kissme_Jump00

; FM1 Data
kissme_FM1:
	smpsPan             panCenter, $00
	smpsSetvoice        $02
	dc.b	nRst, $7F, $7F, $7F, $03

kissme_Loop28:
	dc.b	nA2, $05, nRst, $01
	smpsLoop            $00, $0C, kissme_Loop28

kissme_Loop29:
	dc.b	nF3, $05, nRst, $01
	smpsLoop            $00, $04, kissme_Loop29

kissme_Loop2A:
	dc.b	nD3, $05, nRst, $01
	smpsLoop            $00, $06, kissme_Loop2A
	dc.b	nF3, $05, nRst, $01, nF3, $05

kissme_Loop2B:
	dc.b	nRst, $01, nG3, $05
	smpsLoop            $00, $08, kissme_Loop2B
	dc.b	nRst, $01
	smpsLoop            $01, $04, kissme_Loop28
	smpsAlterVol        $FB

kissme_Loop2C:
	dc.b	nA2, $05, nRst, $01
	smpsLoop            $00, $0C, kissme_Loop2C

kissme_Loop2D:
	dc.b	nF3, $05, nRst, $01
	smpsLoop            $00, $04, kissme_Loop2D

kissme_Loop2E:
	dc.b	nD3, $05, nRst, $01
	smpsLoop            $00, $06, kissme_Loop2E
	dc.b	nF3, $05, nRst, $01, nF3, $05

kissme_Loop2F:
	dc.b	nRst, $01, nG3, $05
	smpsLoop            $00, $08, kissme_Loop2F
	dc.b	nRst, $01
	smpsLoop            $01, $04, kissme_Loop2C
	smpsAlterVol        $06

kissme_Loop30:
	dc.b	nA2, $05, nRst, $01
	smpsLoop            $00, $0C, kissme_Loop30

kissme_Loop31:
	dc.b	nF3, $05, nRst, $01
	smpsLoop            $00, $04, kissme_Loop31

kissme_Loop32:
	dc.b	nD3, $05, nRst, $01
	smpsLoop            $00, $06, kissme_Loop32
	dc.b	nF3, $05, nRst, $01, nF3, $05

kissme_Loop33:
	dc.b	nRst, $01, nG3, $05
	smpsLoop            $00, $08, kissme_Loop33
	dc.b	nRst, $01
	smpsLoop            $01, $04, kissme_Loop30
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $02
	smpsAlterVol        $FF
	smpsJump            kissme_Loop28

; FM2 Data
kissme_FM2:
	smpsPan             panCenter, $00
	smpsSetvoice        $00

kissme_Loop22:
	dc.b	nA3, $06, $06, nA4, nE4, nA4, nD4, nD4, nB4, nG4, nE4, nE4
	dc.b	nE4, nG4, nD4, nD4, nD4, nB4, nG4, nA3, nA3, nA4, nE4, nA4
	dc.b	nD4, nD4, nB4, nG4, nE4, nE4, nE4, nG4, nD4
	smpsLoop            $00, $02, kissme_Loop22
	smpsPan             panLeft, $00

kissme_Jump04:
	smpsAlterVol        $FD
	dc.b	nA3, $01
	smpsPan             panLeft, $00
	dc.b	smpsNoAttack, $05, $06, nA4, nE4, nA4, nD4, nD4, nB4, nG4, nE4, nE4
	dc.b	nE4, nG4, nD4, nD4, nD4, nB4, nG4

kissme_Loop23:
	smpsPan             panLeft, $00
	dc.b	nA3, $01
	smpsPan             panLeft, $00
	dc.b	smpsNoAttack, $05, $06, nA4, nE4, nA4, nD4, nD4, nB4, nG4, nE4, nE4
	dc.b	nE4, nG4, nD4
	smpsLoop            $00, $02, kissme_Loop23
	dc.b	nD4, nD4, nB4, nG4

kissme_Loop24:
	smpsPan             panLeft, $00
	dc.b	nA3, $01
	smpsPan             panLeft, $00
	dc.b	smpsNoAttack, $05, $06, nA4, nE4, nA4, nD4, nD4, nB4, nG4, nE4, nE4
	dc.b	nE4, nG4, nD4
	smpsLoop            $00, $02, kissme_Loop24
	dc.b	nD4, nD4, nB4, nG4

kissme_Loop25:
	smpsPan             panLeft, $00
	dc.b	nA3, $01
	smpsPan             panLeft, $00
	dc.b	smpsNoAttack, $05, $06, nA4, nE4, nA4, nD4, nD4, nB4, nG4, nE4, nE4
	dc.b	nE4, nG4, nD4
	smpsLoop            $00, $02, kissme_Loop25
	dc.b	nD4, nD4, nB4, nG4
	smpsPan             panLeft, $00
	dc.b	nA3, $01
	smpsPan             panLeft, $00
	dc.b	smpsNoAttack, $05, $06, nA4, nE4, nA4, nD4, nD4, nB4, nG4, nE4, nE4
	dc.b	nE4, nG4, nD4, nRst

kissme_Loop26:
	dc.b	$60
	smpsLoop            $00, $08, kissme_Loop26
	smpsPan             panCenter, $00
	smpsAlterVol        $03

kissme_Loop27:
	dc.b	nA3, $06, $06, nA4, nE4, nA4, nD4, nD4, nB4, nG4, nE4, nE4
	dc.b	nE4, nG4, nD4, nD4, nD4, nB4, nG4, nA3, nA3, nA4, nE4, nA4
	dc.b	nD4, nD4, nB4, nG4, nE4, nE4, nE4, nG4, nD4
	smpsLoop            $00, $04, kissme_Loop27
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsJump            kissme_Jump04

; FM3 Data
kissme_FM3:
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nRst, $7F, $7F, $7F, $03

kissme_Jump03:
	smpsSetvoice        $00

kissme_Loop1A:
	dc.b	nA2, $05, nRst, $01
	smpsLoop            $00, $0C, kissme_Loop1A

kissme_Loop1B:
	dc.b	nF2, $05, nRst, $01
	smpsLoop            $00, $04, kissme_Loop1B

kissme_Loop1C:
	dc.b	nD2, $05, nRst, $01
	smpsLoop            $00, $06, kissme_Loop1C
	dc.b	nF2, $05, nRst, $01, nF2, $05

kissme_Loop1D:
	dc.b	nRst, $01, nG2, $05
	smpsLoop            $00, $08, kissme_Loop1D
	dc.b	nRst, $01
	smpsLoop            $01, $03, kissme_Loop1A

kissme_Loop1E:
	dc.b	nA2, $05, nRst, $01
	smpsLoop            $00, $0C, kissme_Loop1E

kissme_Loop1F:
	dc.b	nF2, $05, nRst, $01
	smpsLoop            $00, $04, kissme_Loop1F

kissme_Loop20:
	dc.b	nD2, $05, nRst, $01
	smpsLoop            $00, $06, kissme_Loop20
	dc.b	nF2, $05, nRst, $01, nF2, $05

kissme_Loop21:
	dc.b	nRst, $01, nG2, $05
	smpsLoop            $00, $08, kissme_Loop21
	dc.b	nRst, $0D
	smpsSetvoice        $01
	smpsAlterVol        $05
	dc.b	nE3, $09, nRst, $03, nE3, $0E, nRst, $16, nF3, $07, nRst, $03
	dc.b	nE3, $04, nRst, $03, nD3, $09, nRst, $04, nE3, $1F, nRst, $53
	dc.b	nE3, $0A, nRst, $02, nE3, $11, nRst, $07, nG3, $04, nRst, $02
	dc.b	nF3, $09, nRst, nE3, $06, nF3, $09, nRst, $03, nD3, $22, nRst
	dc.b	$50, nE3, $09, nRst, $03, nE3, $0C, nRst, nE3, $05, nRst, $01
	dc.b	nE3, $06, nRst, nE3, $0C, nRst, nE3, $05, nRst, $01, nG3, $05
	dc.b	nRst, $01, nA3, $07, nRst, $05, nE3, $0B, nRst, $01, nD3, $0A
	dc.b	nRst, $02, nE3, $1B, nRst, $27, nE3, $04, nRst, $02, nE3, $04
	dc.b	nRst, $02, nE3, $05, nRst, $01, nE3, $0F, nRst, nE3, $07, nRst
	dc.b	$05, nF3, $06, nRst, $02, nE3, $07, nRst, $03, nE3, $04, nRst
	dc.b	$02, nG3, $05, nRst, $01, nA3, $07, nRst, $0B, nE3, $06, nF3
	dc.b	nD3, $05, nRst, $01, nD3, $30, nRst, $12, nE3, $0B, nRst, $01
	dc.b	nE3, $05, nRst, $02, nD3, $04, nRst, $01, nD3, $06, nRst, $01
	dc.b	nE3, $04, nRst, $01, nE3, $06, nRst, nD3, $0C, nE3, $22, nRst
	dc.b	$02, nE3, $0B, nRst, $01, nE3, $04, nRst, $02, nD3, $04, nRst
	dc.b	$02, nE3, $04, nRst, $01, nD3, $04, nRst, $03, nE3, $0B, nRst
	dc.b	$01, nF3, $0B, nRst, $01, nE3, $23, nRst, $01, nE3, $0B, nRst
	dc.b	$01, nE3, $05, nRst, $01, nD3, $06, nE3, $0A, nRst, $02, nE3
	dc.b	$0C, nD3, $0B, nRst, $01, nE3, $23, nRst, $01, nD3, $05, nRst
	dc.b	$02, nD3, $0B, nE3, $1D, nRst, $01, nG3, $06, $0C, nE3, $11
	dc.b	nRst, $0D, nE3, $0B, nRst, $01, nE3, $05, nRst, $02, nD3, $04
	dc.b	nRst, $01, nD3, $06, nRst, $01, nE3, $04, nRst, $01, nE3, $06
	dc.b	nRst, nD3, $0C, nE3, $22, nRst, $02, nE3, $0B, nRst, $01, nE3
	dc.b	$04, nRst, $02, nD3, $04, nRst, $02, nE3, $04, nRst, $01, nD3
	dc.b	$04, nRst, $03, nE3, $0B, nRst, $01, nF3, $0B, nRst, $01, nE3
	dc.b	$23, nRst, $01, nE3, $0B, nRst, $01, nE3, $05, nRst, $01, nD3
	dc.b	$06, nE3, $0A, nRst, $02, nE3, $0C, nD3, $0B, nRst, $01, nE3
	dc.b	$23, nRst, $01, nD3, $05, nRst, $02, nD3, $0B, nE3, $1D, nRst
	dc.b	$01, nG3, $06, $0C, nE3, $11, nRst, $01
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $01
	smpsAlterVol        $FB
	smpsJump            kissme_Jump03

; FM4 Data
kissme_FM4:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nRst, $7F, $7F, $7F, $03
	smpsPan             panRight, $00

kissme_Jump02:
	smpsSetvoice        $00

kissme_Loop15:
	dc.b	nA3, $06, $06, $06, nE4, nRst, nE4, nE4, nE4, nE4, nE4, nF4
	dc.b	nF4, nE4, nE4, nC4, nC4, nB3, nB3, nB3, nC4, nC4, nC4, nC4
	dc.b	nC4, nB3, nB3, nB3, nC4, nRst, nC4, nB3, nRst
	smpsLoop            $00, $04, kissme_Loop15
	smpsPan             panCenter, $00
	smpsSetvoice        $00

kissme_Loop16:
	dc.b	nA2, $05, nRst, $01
	smpsLoop            $00, $0C, kissme_Loop16

kissme_Loop17:
	dc.b	nF2, $05, nRst, $01
	smpsLoop            $00, $04, kissme_Loop17

kissme_Loop18:
	dc.b	nD2, $05, nRst, $01
	smpsLoop            $00, $06, kissme_Loop18
	dc.b	nF2, $05, nRst, $01, nF2, $05

kissme_Loop19:
	dc.b	nRst, $01, nG2, $05
	smpsLoop            $00, $08, kissme_Loop19
	dc.b	nRst, $01
	smpsLoop            $01, $08, kissme_Loop16
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsJump            kissme_Jump02

; FM5 Data
kissme_FM5:
	smpsPan             panCenter, $00
	smpsAlterNote       $06
	smpsSetvoice        $00
	dc.b	nRst, $02, nA3, $05, nRst, $01, nA3, $05, nRst, $01, nA4, $05
	dc.b	nRst, $01, nE4, $05, nRst, $01, nA4, $05, nRst, $01, nD4, $05
	dc.b	nRst, $01, nD4, $05, nRst, $01, nB4, $05, nRst, $01, nG4, $05

kissme_Loop05:
	dc.b	nRst, $01, nE4, $05
	smpsLoop            $00, $03, kissme_Loop05
	dc.b	nRst, $01, nG4, $05

kissme_Loop06:
	dc.b	nRst, $01, nD4, $05
	smpsLoop            $00, $03, kissme_Loop06
	dc.b	nRst, $01, nB4, $05, nRst, $01, nG4, $05

kissme_Loop08:
	dc.b	nRst, $01, nA3, $05, nRst, $01, nA3, $05, nRst, $01, nA4, $05
	dc.b	nRst, $01, nE4, $05, nRst, $01, nA4, $05, nRst, $01, nD4, $05
	dc.b	nRst, $01, nD4, $05, nRst, $01, nB4, $05, nRst, $01, nG4, $05

kissme_Loop07:
	dc.b	nRst, $01, nE4, $05
	smpsLoop            $00, $03, kissme_Loop07
	dc.b	nRst, $01, nG4, $05, nRst, $01, nD4, $05
	smpsLoop            $01, $02, kissme_Loop08
	dc.b	nRst, $01, nD4, $05, nRst, $01, nD4, $05, nRst, $01, nB4, $05
	dc.b	nRst, $01, nG4, $05, nRst, $01, nA3, $05, nRst, $01, nA3, $05
	dc.b	nRst, $01, nA4, $05, nRst, $01, nE4, $05, nRst, $01, nA4, $05
	dc.b	nRst, $01, nD4, $05, nRst, $01, nD4, $05, nRst, $01, nB4, $05
	dc.b	nRst, $01, nG4, $05

kissme_Loop09:
	dc.b	nRst, $01, nE4, $05
	smpsLoop            $00, $03, kissme_Loop09
	dc.b	nRst, $01, nG4, $05, nRst, $01, nD4, $04

kissme_Jump01:
	dc.b	smpsNoAttack, $01
	smpsPan             panLeft, $00
	dc.b	nRst
	smpsAlterVol        $FC
	dc.b	nA3, $05, nRst, $01, nA3, $05, nRst, $01, nA4, $05, nRst, $01
	dc.b	nE4, $05, nRst, $01, nA4, $05, nRst, $01, nD4, $05, nRst, $01
	dc.b	nD4, $05, nRst, $01, nB4, $05, nRst, $01, nG4, $05

kissme_Loop0A:
	dc.b	nRst, $01, nE4, $05
	smpsLoop            $00, $03, kissme_Loop0A
	dc.b	nRst, $01, nG4, $05, nRst, $01, nD4, $05

kissme_Loop0D:
	dc.b	nRst, $01, nD4, $04
	smpsPan             panLeft, $00
	dc.b	smpsNoAttack, $01, nRst, nD4, $05, nRst, $01, nB4, $05, nRst, $01, nG4
	dc.b	$05
	smpsPan             panLeft, $00

kissme_Loop0C:
	dc.b	nRst, $01, nA3, $05, nRst, $01, nA3, $05, nRst, $01, nA4, $05
	dc.b	nRst, $01, nE4, $05, nRst, $01, nA4, $05, nRst, $01, nD4, $05
	dc.b	nRst, $01, nD4, $05, nRst, $01, nB4, $05, nRst, $01, nG4, $05

kissme_Loop0B:
	dc.b	nRst, $01, nE4, $05
	smpsLoop            $00, $03, kissme_Loop0B
	dc.b	nRst, $01, nG4, $05, nRst, $01, nD4, $05
	smpsLoop            $01, $02, kissme_Loop0C
	smpsLoop            $02, $03, kissme_Loop0D
	dc.b	nRst, $01, nD4, $04
	smpsPan             panLeft, $00
	dc.b	smpsNoAttack, $01, nRst, nD4, $05, nRst, $01, nB4, $05, nRst, $01, nG4
	dc.b	$05
	smpsPan             panLeft, $00
	dc.b	nRst, $01, nA3, $05, nRst, $01, nA3, $05, nRst, $01, nA4, $05
	dc.b	nRst, $01, nE4, $05, nRst, $01, nA4, $05, nRst, $01, nD4, $05
	dc.b	nRst, $01, nD4, $05, nRst, $01, nB4, $05, nRst, $01, nG4, $05

kissme_Loop0E:
	dc.b	nRst, $01, nE4, $05
	smpsLoop            $00, $03, kissme_Loop0E
	dc.b	nRst, $01, nG4, $05, nRst, $01, nD4, $05, nRst, $0B
	smpsPan             panCenter, $00
	dc.b	$01
	smpsSetvoice        $01
	dc.b	$02
	smpsAlterVol        $05
	dc.b	nE3, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $08, nRst, $03, nE3, $0E, nRst, $16, nF3, $07, nRst, $03
	dc.b	nE3, $04, nRst, $03, nD3, $09, nRst, $04, nE3, $1F, nRst, $53
	dc.b	nE3, $0A, nRst, $02, nE3, $11, nRst, $07, nG3, $04, nRst, $02
	dc.b	nF3, $09, nRst, nE3, $06, nF3, $09, nRst, $03, nD3, $22, nRst
	dc.b	$50, nE3, $09, nRst, $03, nE3, $0C, nRst, nE3, $05, nRst, $01
	dc.b	nE3, $06, nRst, nE3, $0C, nRst, nE3, $05, nRst, $01, nG3, $05
	dc.b	nRst, $01, nA3, $07, nRst, $05, nE3, $0B, nRst, $01, nD3, $0A
	dc.b	nRst, $02, nE3, $1B, nRst, $27, nE3, $04, nRst, $02, nE3, $04
	dc.b	nRst, $02, nE3, $05, nRst, $01, nE3, $0F, nRst, nE3, $07, nRst
	dc.b	$05, nF3, $06, nRst, $02, nE3, $07, nRst, $03, nE3, $04, nRst
	dc.b	$02, nG3, $05, nRst, $01, nA3, $07, nRst, $0B, nE3, $06, nF3
	dc.b	nD3, $05, nRst, $01, nD3, $30, nRst, $03
	smpsSetvoice        $00
	smpsAlterNote       $06
	dc.b	$02
	smpsAlterVol        $FF
	dc.b	nA3, $05, nRst, $01, nA3, $05, nRst, $01, nA4, $05, nRst, $01
	dc.b	nE4, $05, nRst, $01, nA4, $05, nRst, $01, nD4, $05, nRst, $01
	dc.b	nD4, $05, nRst, $01, nB4, $05, nRst, $01, nG4, $05

kissme_Loop0F:
	dc.b	nRst, $01, nE4, $05
	smpsLoop            $00, $03, kissme_Loop0F
	dc.b	nRst, $01, nG4, $05

kissme_Loop10:
	dc.b	nRst, $01, nD4, $05
	smpsLoop            $00, $03, kissme_Loop10

kissme_Loop13:
	dc.b	nRst, $01, nB4, $05, nRst, $01, nG4, $05

kissme_Loop12:
	dc.b	nRst, $01, nA3, $05, nRst, $01, nA3, $05, nRst, $01, nA4, $05
	dc.b	nRst, $01, nE4, $05, nRst, $01, nA4, $05, nRst, $01, nD4, $05
	dc.b	nRst, $01, nD4, $05, nRst, $01, nB4, $05, nRst, $01, nG4, $05

kissme_Loop11:
	dc.b	nRst, $01, nE4, $05
	smpsLoop            $00, $03, kissme_Loop11
	dc.b	nRst, $01, nG4, $05, nRst, $01, nD4, $05
	smpsLoop            $01, $02, kissme_Loop12
	dc.b	nRst, $01, nD4, $05, nRst, $01, nD4, $05
	smpsLoop            $02, $03, kissme_Loop13
	dc.b	nRst, $01, nB4, $05, nRst, $01, nG4, $05, nRst, $01, nA3, $05
	dc.b	nRst, $01, nA3, $05, nRst, $01, nA4, $05, nRst, $01, nE4, $05
	dc.b	nRst, $01, nA4, $05, nRst, $01, nD4, $05, nRst, $01, nD4, $05
	dc.b	nRst, $01, nB4, $05, nRst, $01, nG4, $05

kissme_Loop14:
	dc.b	nRst, $01, nE4, $05
	smpsLoop            $00, $03, kissme_Loop14
	dc.b	nRst, $01, nG4, $05, nRst, $01, nD4, $04
	smpsPan             panCenter, $00
	smpsAlterNote       $0A
	smpsSetvoice        $00
	smpsJump            kissme_Jump01

kissme_Voices:
;	Voice $00
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

;	Voice $01
;	$3B
;	$46, $42, $42, $43, 	$10, $12, $19, $4F, 	$08, $05, $01, $01
;	$01, $01, $01, $01, 	$76, $F1, $F7, $F9, 	$41, $23, $2B, $00
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $04, $04, $04
	smpsVcCoarseFreq    $03, $02, $02, $06
	smpsVcRateScale     $01, $00, $00, $00
	smpsVcAttackRate    $0F, $19, $12, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $01, $01, $05, $08
	smpsVcDecayRate2    $01, $01, $01, $01
	smpsVcDecayLevel    $0F, $0F, $0F, $07
	smpsVcReleaseRate   $09, $07, $01, $06
	smpsVcTotalLevel    $00, $2B, $23, $41

;	Voice $02
;	$2A
;	$30, $70, $08, $01, 	$1F, $1F, $1F, $1F, 	$08, $10, $0E, $0C
;	$00, $03, $06, $05, 	$30, $20, $29, $28, 	$22, $14, $2A, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $07, $03
	smpsVcCoarseFreq    $01, $08, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0C, $0E, $10, $08
	smpsVcDecayRate2    $05, $06, $03, $00
	smpsVcDecayLevel    $02, $02, $02, $03
	smpsVcReleaseRate   $08, $09, $00, $00
	smpsVcTotalLevel    $00, $2A, $14, $22

