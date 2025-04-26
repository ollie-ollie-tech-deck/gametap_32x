promise_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     promise_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $02

	smpsHeaderDAC       promise_DAC
	smpsHeaderFM        promise_FM1,	$00, $06
	smpsHeaderFM        promise_FM2,	$00, $06
	smpsHeaderFM        promise_FM3,	$00, $07
	smpsHeaderFM        promise_FM4,	$00, $09
	smpsHeaderFM        promise_FM5,	$00, $12
	smpsHeaderPSG       promise_PSG1,	$00, $04, $00, $00
	smpsHeaderPSG       promise_PSG2,	$00, $02, $00, $00
	smpsHeaderPSG       promise_PSG3,	$00, $04, $00, fTone_01

; DAC Data
promise_DAC:
	smpsPan             panCenter, $00
	dc.b	nRst, $30, dMidTimpani, $18, dHiTimpani, $0C, dMidTimpani, dLowTimpani, dVLowTimpani, $18, dHiTimpani, $0C
	dc.b	dMidTimpani, dLowTimpani, dVLowTimpani, $0B, dSnare, $01, $06, dKick, dKick, $0C, dSnare, $06
	dc.b	dKick, dKick, $0C

promise_Loop01:
	dc.b	dSnare, dKick

promise_Loop00:
	dc.b	dSnare, $06, dKick, dKick, $0C
	smpsLoop            $00, $03, promise_Loop00
	smpsLoop            $01, $03, promise_Loop01
	dc.b	dSnare, dKick, dSnare, $06, dKick, dKick, dSnare, dHiTimpani, $03, dMidTimpani, dLowTimpani, $02
	dc.b	dVLowTimpani, dVLowTimpani, dKick, $0C, dSnare, $06, dKick, dKick, $0C

promise_Loop03:
	dc.b	dSnare, dKick

promise_Loop02:
	dc.b	dSnare, $06, dKick, dKick, $0C
	smpsLoop            $00, $03, promise_Loop02
	smpsLoop            $01, $0B, promise_Loop03
	dc.b	dSnare, dKick, dSnare, $03, $03, dKick, $06, dSnare, $03, $03, dKick, $06

promise_Loop04:
	dc.b	dSnare, $0C, dKick

promise_Loop05:
	dc.b	dSnare, $06, dKick, dKick, $0C
	smpsLoop            $00, $02, promise_Loop04
	dc.b	dSnare, $06, dKick, dKick, $0C
	smpsLoop            $01, $05, promise_Loop05
	dc.b	dSnare, $06, dKick, dKick, $0C, dSnare, dKick, dSnare, $03, $03

promise_Loop06:
	dc.b	dKick, $06, dSnare, $02, $02, $02
	smpsLoop            $00, $02, promise_Loop06
	dc.b	dKick, $06, $0C, dSnare, $06, dKick, dKick, $0C, dSnare, dKick

promise_Loop07:
	dc.b	dSnare, $06, dKick, dKick, $0C
	smpsLoop            $00, $03, promise_Loop07
	dc.b	dSnare, dKick, dSnare, $06, dKick, dKick, dKick, dSnare, $02, $02, $02, dKick
	dc.b	$06, $0C, dSnare, dKick, $06, $06, dSnare, dKick, $0C, $06, dSnare, dKick
	dc.b	dKick, dKick, dSnare, dKick, dKick, $0C, dSnare, $06, dKick, dSnare, dKick, dSnare
	dc.b	dKick, $0C, $06, dSnare, dKick, dSnare, dKick, dSnare, $02, $02, $02, dHiTimpani
	dc.b	dHiTimpani, dVLowTimpani, dKick, $0C, dSnare, dSnare, $03, $03, dHiTimpani, dLowTimpani, dSnare, $06
	dc.b	dKick, $0C, $06, dSnare, dKick, dKick, dKick, dSnare, $02, $02, $02, dHiTimpani
	dc.b	dHiTimpani, dVLowTimpani, dKick, $0C, dSnare, dKick, $06, dSnare, dSnare, dKick, $5A, dSnare
	dc.b	$02, $02, $02, $02, $02, $02, dKick, $0C, dSnare, $06, dKick, dKick
	dc.b	$0C

promise_Loop09:
	dc.b	dSnare, dKick

promise_Loop08:
	dc.b	dSnare, $06, dKick, dKick, $0C
	smpsLoop            $00, $03, promise_Loop08
	smpsLoop            $01, $03, promise_Loop09
	dc.b	dSnare, dKick, $12, dSnare, $02, $02, $02, dHiTimpani, dHiTimpani, dHiTimpani, dMidTimpani, dMidTimpani
	dc.b	dMidTimpani, dLowTimpani, dLowTimpani, dLowTimpani, dVLowTimpani, dVLowTimpani, dVLowTimpani, dKick, $0C, dSnare, $06, dKick
	dc.b	dKick, $0C, dSnare, dKick

promise_Loop0A:
	dc.b	dSnare, $06, dKick, dKick, $0C
	smpsLoop            $00, $03, promise_Loop0A
	dc.b	dSnare, dKick, dSnare, $06, dKick, dSnare, $0C, $02, $02, $02, $02, $02
	dc.b	$02, dKick, $0C, dSnare, $06, dKick, dKick, $0C, dSnare, dKick

promise_Loop0B:
	dc.b	dSnare, $06, dKick, dKick, $0C
	smpsLoop            $00, $03, promise_Loop0B
	dc.b	dSnare, $0B, $01, $02, $02, $02, dVLowTimpani, $06, dSnare, $02, $02, $02
	dc.b	dKick, $06, dHiTimpani, $03, $03, dLowTimpani, dLowTimpani, dHiTimpani, $02, $02, $02, dLowTimpani
	dc.b	dLowTimpani, $01, $02, $01, dKick, $0C, dSnare, dKick, $06, $06, dSnare, dKick
	dc.b	$0C, $06, dSnare, dKick, dKick, dKick, dSnare, dKick, dKick, $0C, dSnare, $06
	dc.b	dKick, dSnare, dKick, dSnare, dKick, $0C, $06, dSnare, dKick, dSnare, dKick, dSnare
	dc.b	$02, $02, $02, dHiTimpani, dHiTimpani, dVLowTimpani, dKick, $0C, dSnare, dSnare, $03, $03
	dc.b	dHiTimpani, dLowTimpani, dSnare, $06, dKick, $0C, $06, dSnare, dKick, dKick, dKick, dSnare
	dc.b	$02, $02, $02, dKick, dHiTimpani, dVLowTimpani, dKick, $0C, dSnare, dKick, $06, dSnare
	dc.b	dSnare, dKick, nRst, $60, $60, $60, $60, $60, $60, $30
	smpsPan             panCenter, $00
	smpsStop

; FM1 Data
promise_FM1:
	smpsPan             panRight, $00
	smpsSetvoice        $00

promise_Loop28:
	dc.b	nA3, $06, nE4, nC5, nE4, nA3, nF4, nC5, nF4, nC4, nG4, nC5
	dc.b	nG4, nD4, nG4, nB4, nG4
	smpsLoop            $00, $0A, promise_Loop28

promise_Loop29:
	dc.b	nA3, nE4, nC5, nE4, nA3, nF4, nC5, nF4, nA3, nFs4, nC5, nFs4
	dc.b	nA3, nF4, nC5, nF4
	smpsLoop            $00, $04, promise_Loop29

promise_Loop2A:
	dc.b	nA3, nE4, nC5, nE4, nA3, nF4, nC5, nF4, nC4, nG4, nC5, nG4
	dc.b	nD4, nG4, nB4, nG4
	smpsLoop            $00, $08, promise_Loop2A

promise_Loop2B:
	dc.b	nA3, nE4, nC5, nE4, nA3, nF4, nC5, nF4, nA3, nFs4, nC5, nFs4
	dc.b	nA3, nF4, nC5, nF4
	smpsLoop            $00, $04, promise_Loop2B

promise_Loop2C:
	dc.b	nE3, $03, nB3, nE4, $0C, nRst, $18, nC4, $03, nG4, nC5, $0C
	dc.b	nRst, $24
	smpsLoop            $00, $03, promise_Loop2C
	dc.b	nE3, $03, nB3, nE4, $0C, nRst, $18, nC4, $03, nG4, nC5, $06
	dc.b	nB4, nG4, nE4, nB4, nB4, nG4, nE4, nE4, nG4, nB4, nG4, nE4
	dc.b	nG4, nB4, nG4

promise_Loop2D:
	dc.b	nE3, nB3, nG4, nE4, nB4, nG4, nE4, nB3, nC4, nE4, nG4, nE4
	dc.b	nC5, nG4, nE4, nG4, nA3, nE4, nC5, nE4, nA3, nE4, nC5, nE4
	dc.b	nB3, nEb4, nFs4, nEb4, nA4, nFs4, nEb4, nB3
	smpsLoop            $00, $04, promise_Loop2D

promise_Loop2E:
	dc.b	nE3, $03, nB3, nE4, $0C, nRst, $18, nC4, $03, nG4, nC5, $0C
	dc.b	nRst, $24
	smpsLoop            $00, $03, promise_Loop2E
	dc.b	nE3, $03, nB3, nE4, $0C, nRst, $18, nC4, $03, nG4, nC5, $0C
	dc.b	nRst, $54
	smpsAlterVol        $FF

promise_Loop2F:
	dc.b	nA3, $06, nE4, nC5, nE4, nA3, nF4, nC5, nF4, nC4, nG4, nC5
	dc.b	nG4, nD4, nG4, nB4, nG4
	smpsLoop            $00, $04, promise_Loop2F
	dc.b	nRst, $03, nA3, $02, nE4, $01, nA4, $02, nB4, $01, nE5, $27
	dc.b	nRst, $60
	smpsPan             panRight, $00
	smpsSetvoice        $00
	smpsStop

; FM2 Data
promise_FM2:
	smpsPan             panLeft, $00
	smpsAlterNote       $09
	smpsSetvoice        $00
	dc.b	nRst, $01, nA3, $06, nE4, nC5, nE4, nA3, nF4, nC5, nF4, nC4
	dc.b	nG4, nC5, nG4, nD4, nG4, nB4, nG4, nA3, nE4, nC5, nE4, nA3
	dc.b	nF4, nC5, nF4, nC4, nG4, nC5, nG4, nD4, nG4, nB4, nG4, $05
	smpsAlterNote       $00

promise_Loop21:
	dc.b	nA3, $03, nE4, nA4, nC5, nE5, $0C, nF3, $03, nC4, nF4, nA4
	dc.b	nC5, $0C, nC4, $03, nG4, nC5, nE5, nG5, $0C, nG3, $03, nD4
	dc.b	nG4, nB4, nD5, $0C
	smpsLoop            $00, $08, promise_Loop21

promise_Loop22:
	dc.b	nA3, $03, nE4, nA4, nC5, nE5, $0C, nF3, $03, nC4, nF4, nA4
	dc.b	nC5, $0C, nFs3, $03, nC4, nFs4, nA4, nC5, $0C, nF3, $03, nC4
	dc.b	nF4, nA4, nC5, $0C
	smpsLoop            $00, $04, promise_Loop22
	smpsLoop            $01, $02, promise_Loop21

promise_Loop23:
	dc.b	nE3, $06, nB3, nE4
	smpsPan             panCenter, $00
	smpsAlterVol        $04
	dc.b	nG4, nE4, nB3, nE3
	smpsPan             panLeft, $00
	smpsAlterVol        $FC
	dc.b	nC4, nE4, nG4
	smpsPan             panCenter, $00
	smpsAlterVol        $04
	dc.b	nC5, nE5, nC5, nG4, nE4, nC4
	smpsPan             panLeft, $00
	smpsAlterVol        $FC
	smpsLoop            $00, $03, promise_Loop23
	dc.b	nE3, nB3, nE4
	smpsPan             panCenter, $00
	smpsAlterVol        $04
	dc.b	nG4, nE4, nB3, nE3
	smpsPan             panLeft, $00
	smpsAlterVol        $FC
	dc.b	nC4, nE4, nG4, nC5, nE5, $1E
	smpsAlterNote       $0A
	dc.b	nE4, $06, nG4, nB4, nG4, nE4, nG4, nB4, nG4
	smpsAlterNote       $00

promise_Loop24:
	dc.b	nE3, nB3, nE4, nG4, nB4, nE5, nB4, nG4, nC4, nE4, nG4, nC5
	dc.b	nE5, nC5, nG4, nE4, nA3, nE4, nA4, nC5, nE5, nC5, nA4, nE4
	dc.b	nB3, nEb4, nA4, nB4, nFs5, nB4, nA4, nEb4
	smpsLoop            $00, $02, promise_Loop24
	dc.b	nRst

promise_Loop25:
	dc.b	nB3, nE4, nG4, nB4, nE5, nB4, nG4, nC4, nE4, nG4, nC5, nE5
	dc.b	nC5, nG4, nE4, nA3, nE4, nA4, nC5, nE5, nC5, nA4, nE4, nB3
	dc.b	nEb4, nA4, nB4, nFs5, nB4, nA4, nEb4, nE3
	smpsLoop            $00, $02, promise_Loop25

promise_Loop26:
	dc.b	nB3, nE4
	smpsPan             panCenter, $00
	smpsAlterVol        $04
	dc.b	nG4, nE4, nB3, nE3
	smpsPan             panLeft, $00
	smpsAlterVol        $FC
	dc.b	nC4, nE4, nG4
	smpsPan             panCenter, $00
	smpsAlterVol        $04
	dc.b	nC5, nE5, nC5, nG4, nE4, nC4
	smpsPan             panLeft, $00
	smpsAlterVol        $FC
	dc.b	nE3
	smpsLoop            $00, $03, promise_Loop26
	dc.b	nB3, nE4
	smpsPan             panCenter, $00
	smpsAlterVol        $04
	dc.b	nG4, nE4, nB3, nE3
	smpsPan             panLeft, $00
	smpsAlterVol        $FC
	dc.b	nC4, nE4, nG4, nC5, nE5, $1E, nRst, $30
	smpsAlterNote       $09
	dc.b	$01
	smpsAlterVol        $FF

promise_Loop27:
	dc.b	nA3, $06, nE4, nC5, nE4, nA3, nF4, nC5, nF4, nC4, nG4, nC5
	dc.b	nG4, nD4, nG4, nB4, nG4
	smpsLoop            $00, $04, promise_Loop27
	dc.b	nRst, $03, nA3, $01, nE4, $02, nA4, $01, nB4, $02, nE5, $27
	dc.b	nRst, $5F
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsPan             panLeft, $00
	smpsStop

; FM3 Data
promise_FM3:
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nRst, $7F, $41

promise_Loop17:
	dc.b	nA2, $12, $03, nRst, nF2, $12, $03, nRst, nC3, $12, $03, nRst
	dc.b	nG2, $0C, $06, nB2
	smpsLoop            $00, $03, promise_Loop17

promise_Loop18:
	dc.b	nA2, $12, $03, nRst, nF2, $12, $03, nRst, nC3, $12, $03, nRst
	dc.b	nD3, $0C, nE3, $06, nD3, nA2, $12, $03, nRst, nF2, $12, $03
	dc.b	nRst, nC3, $12, $03, nRst, nG2, $0C, $06, nB2
	smpsLoop            $00, $02, promise_Loop18
	dc.b	nA2, $12, $03, nRst, nF2, $12, $03, nRst, nC3, $12, $03, nRst
	dc.b	nD3, $0C, nE3, $06, nD3

promise_Loop19:
	dc.b	nA2, $12, $03, nRst, nF2, $12, $03, nRst, nFs2, $12, $03, nRst
	dc.b	nF2, $0C, nC3, $06, nB2
	smpsLoop            $00, $04, promise_Loop19
	smpsLoop            $01, $02, promise_Loop17

promise_Loop1A:
	dc.b	nE2, $0C, $06, $06, $06, $06, $06, nC3, $12, $06, $06, $06
	dc.b	$06, $06, $06
	smpsLoop            $00, $03, promise_Loop1A
	dc.b	nE2, $0C, $06, $06, $06, $06, $06, nC3, $1C
	smpsAlterNote       $12
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $13
	dc.b	smpsNoAttack, nCs3
	smpsAlterNote       $FF
	dc.b	nAb3
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nBb3
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, nB3, $22
	smpsAlterNote       $00

promise_Loop1B:
	dc.b	$06, $06, $06, $06, $06, $06

promise_Loop1F:
	dc.b	nE2
	smpsLoop            $00, $02, promise_Loop1B

promise_Loop1C:
	dc.b	nC3
	smpsLoop            $00, $08, promise_Loop1C

promise_Loop1D:
	dc.b	nA2
	smpsLoop            $00, $08, promise_Loop1D

promise_Loop1E:
	dc.b	nB2
	smpsLoop            $00, $08, promise_Loop1E
	smpsLoop            $01, $04, promise_Loop1F

promise_Loop20:
	dc.b	nE2, $0C, $06, $06, $06, $06, $06, nC3, $12, $06, $06, $06
	dc.b	$06, $06, $06
	smpsLoop            $00, $03, promise_Loop20
	dc.b	nE2, $0C, $06, $06, $06, $06, $06, nC3, $1C
	smpsAlterNote       $12
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $13
	dc.b	smpsNoAttack, nCs3
	smpsAlterNote       $FF
	dc.b	nAb3
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nBb3
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, nB3, $46
	smpsAlterNote       $00
	dc.b	nRst, $58, $58, $58, $58, $58, $58
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	smpsStop

; FM4 Data
promise_FM4:
	smpsPan             panCenter, $00
	smpsSetvoice        $02
	dc.b	nRst, $7F, $7F, $7C, nD6, $06, nE6, $2A, nG6, $06, nC6, $2A
	dc.b	nA5, $06, nE6, $2A, nC6, $06, nG5, $1E, nRst, $7F, $5F, nE5
	dc.b	$06, nG5, $0C, nA5, $06, nG5, $0C, nRst, $12, nD5, $06, $0C
	dc.b	nE5, $06, nD5, nC5, nRst, nE5, nG5, $0C, nA5, $06, nG5, $0C
	dc.b	nRst, $12, nG4, $06, nD5, nG5, nB5, nG5, nA5, nE5, nRst, nE5
	dc.b	nA5, nRst

promise_Loop10:
	dc.b	nE5, nRst, nA5
	smpsLoop            $00, $03, promise_Loop10
	dc.b	nE5, nA5, nE5, nRst, nE5, nA5, nRst, nE5, nRst, nA5, nRst, $0C

promise_Loop11:
	dc.b	nE5, $06, nA5, nRst, nE5, nRst, nA5, nE5, nRst
	smpsLoop            $00, $02, promise_Loop11
	dc.b	nA5, nE5, nRst, nA5, nE5, nA5, nE5, nRst, nE5, nA5, nRst, nE5
	dc.b	nRst, nA5, nRst, $0C, nE5, $06, nA5, nRst, nE5, nRst, $7F, $41
	dc.b	nD6, $06, nE6, $2A, nG6, $06, nC6, $2A, nA5, $06, nE6, $2A
	dc.b	nC6, $06, nG5, $1E, nRst, $7F, $5F, nE5, $06, nG5, $0C, nA5
	dc.b	$06, nG5, $0C, nRst, $12, nD5, $06, $0C, nE5, $06, nD5, nC5
	dc.b	nRst, nE5, nG5, $0C, nA5, $06, nG5, $0C, nRst, $12, nG4, $06
	dc.b	nD5
	smpsAlterVol        $01
	dc.b	nG5
	smpsAlterVol        $FF
	dc.b	nB5, nG5, nA5, nE5, nRst, nE5, nA5, nRst, nE5, nRst
	smpsAlterVol        $01
	dc.b	nA5
	smpsAlterVol        $FF
	dc.b	nE5, nRst, nA5, nE5, nRst, nA5, nE5, nA5, nE5, nRst, nE5
	smpsAlterVol        $01
	dc.b	nA5, nRst
	smpsAlterVol        $FF
	dc.b	nE5, nRst, nA5, nRst, $0C

promise_Loop12:
	dc.b	nE5, $06, nA5, nRst, nE5, nRst, nA5, nE5, nRst
	smpsLoop            $00, $02, promise_Loop12
	dc.b	nA5, nE5, nRst, nA5, nE5, nA5, nE5, nRst, nE5, nA5, nRst, nE5
	dc.b	nRst, nA5, nRst, $0C, nE5, $06, nA5, nRst, nE5, nRst

promise_Loop13:
	dc.b	nE3, nB3, nE4, nG4, nE4, nB4, nG5, nC4, nE4, nG4, nC5, nE5
	dc.b	nC5, nG4, nE4, nC4
	smpsLoop            $00, $03, promise_Loop13
	dc.b	nE3, nB3, nE4, nG4, nE4, nB4, nG5, nC4, $03, nE4, nG4, nC5
	dc.b	nE5, $2A, nRst, $36

promise_Loop14:
	dc.b	nD4, $06, nE4, nFs4, nG4, nRst, $18
	smpsLoop            $00, $02, promise_Loop14
	dc.b	nD4, $06, nE4, nFs4, nG4, nRst, $48
	smpsLoop            $01, $03, promise_Loop14

promise_Loop15:
	dc.b	nD4, $06, nE4, nFs4, nG4, nRst, $18
	smpsLoop            $00, $02, promise_Loop15
	dc.b	nD4, $06, nE4, nFs4, nG4, nRst, $42

promise_Loop16:
	dc.b	nE3, $06, nB3, nE4, nG4, nE4, nB4, nG5, nC4, nE4, nG4, nC5
	dc.b	nE5, nC5, nG4, nE4, nC4
	smpsLoop            $00, $03, promise_Loop16
	dc.b	nE3, nB3, nE4, nG4, nE4, nB4, nG5, nC4, $03, nE4, nG4, nC5
	dc.b	nE5, $2A, nRst, $60, $60, $60, $60, $60, $60
	smpsPan             panCenter, $00
	smpsSetvoice        $02
	smpsStop

; FM5 Data
promise_FM5:
	smpsPan             panCenter, $00
	smpsSetvoice        $03
	dc.b	nRst, $7F, $7F, $7F, $03, nA3, $0C, nC4, nF3, nA3, nC4, nE4
	dc.b	nG3, nB3, nA3, nC4, nF3, nA3, nC4, nE4, nG3, $03, nB3, nB4
	dc.b	$12, nRst, $7F, $4D, nE4, $06, nG4, $0C, nA4, $06, nG4, $0C
	dc.b	nRst, $12, nD4, $06, $0C, nE4, $06, nD4, nC4, nRst, nE4, nG4
	dc.b	$0C, nA4, $06, nG4, $0C, nRst, $12, nG3, $06, nD4, nG4, nB4
	dc.b	nG4, nRst, $60, $60, $60, $60, $60, $60

promise_Loop0C:
	dc.b	nA3, $0C, nC4, nF3, nA3, nC4, nE4, nG3, nB3
	smpsLoop            $00, $02, promise_Loop0C
	dc.b	nRst, $7F, $4D, nE4, $06, nG4, $0C, nA4, $06, nG4, $0C, nRst
	dc.b	$12, nD4, $06, $0C, nE4, $06, nD4, nC4, nRst, nE4, nG4, $0C
	dc.b	nA4, $06, nG4, $0C, nRst, $12, nG3, $06, nD4, nG4, nB4, nG4
	dc.b	nRst, $7F, $7F, $7F, $03

promise_Loop0D:
	dc.b	nE4, $18, nB4, $12, nC4, nG4, $18, nA4, $0C
	smpsLoop            $00, $03, promise_Loop0D
	dc.b	nE4, $18, nB4, $12, nRst, $66

promise_Loop0E:
	dc.b	nE3, $0C, nB3, nE4, nB3, nC3, nG3, nC4, nG3, nA2, nE3, nA3
	dc.b	nE3, nB2, nEb3, nB3, nEb3
	smpsLoop            $00, $02, promise_Loop0E

promise_Loop0F:
	dc.b	nE4, nB4, nE5, nB4, nC4, nG4, nC5, nG4, nA3, nE4, nA4, nE4
	dc.b	nB3, nEb4, nB4, nEb4
	smpsLoop            $00, $02, promise_Loop0F
	dc.b	nE4, nB4, $1E, nC4, $12, nG4, $18, nA4, $0C, nB4, $18, nE4
	dc.b	$12, nRst, $06, nC4, $12, nG4, $18, nA4, $0C, nB4, $18, nE4
	dc.b	$12, nC4, nG4, $18, nA4, $0C, nB4, $2A, nRst, $68, $68, $68
	dc.b	$68, $68, $68
	smpsPan             panCenter, $00
	smpsSetvoice        $03
	smpsStop

; PSG1 Data
promise_PSG1:
	dc.b	nRst

promise_Loop42:
	dc.b	$68
	smpsLoop            $00, $18, promise_Loop42

promise_Loop43:
	dc.b	nE0, $1E, nRst, $42
	smpsLoop            $00, $03, promise_Loop43
	dc.b	nE0, $1E, nRst, $7F, $7F, $7F, $63
	smpsPSGAlterVol     $FF

promise_Loop44:
	dc.b	nB0, $05, nRst, $01, nE1, $05, nRst, $01, nFs1, $05, nRst, $01
	dc.b	nFs1, $1E
	smpsLoop            $00, $03, promise_Loop44
	dc.b	nB0, $05, nRst, $01, nE1, $05, nRst, $01, nFs1, $05, nRst, $01
	dc.b	nFs1, $18, nF1, $06

promise_Loop45:
	dc.b	nB0, $05, nRst, $01, nE1, $05, nRst, $01, nFs1, $05, nRst, $01
	dc.b	nFs1, $1E
	smpsLoop            $00, $03, promise_Loop45
	dc.b	nB0, $05, nRst, $01, nE1, $05, nRst, $01, nFs1, $05, nRst, $01
	dc.b	nFs1, $18, nF1
	smpsPSGAlterVol     $02

promise_Loop46:
	dc.b	nE0, $1E, nRst, $42
	smpsLoop            $00, $03, promise_Loop46
	dc.b	nE0, $1E, nRst, $6B, $6B, $6B, $6B, $6B, $6B
	smpsPSGvoice        $00
	smpsStop

; PSG2 Data
promise_PSG2:
	dc.b	nRst, $60, $60, $60, $60, $60, $60, $0C
	smpsAlterNote       $03
	dc.b	nFs1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $05, $03, nRst, nG1, $06, smpsNoAttack, nF1, nE1, $18, nRst
	dc.b	$06, nD1, $03, nRst, nD1, $06
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nE1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD1, nC1, $12
	smpsAlterNote       $03
	dc.b	nFs1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $05, $03, nRst, nG1, $06, smpsNoAttack, nA1, nG1, $18, nRst
	dc.b	$06
	smpsAlterNote       $FD
	dc.b	nB1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nC2, $02, nRst, $03, nC2, $09
	smpsAlterNote       $03
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $01, $09
	smpsAlterNote       $04
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FC
	dc.b	smpsNoAttack, nBb1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $01, nG1, $06, nRst
	smpsAlterNote       $03
	dc.b	nFs1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $05, $03, nRst, nG1, $06, smpsNoAttack, nF1, nE1, $18, nRst
	dc.b	$06, nD1, $03, nRst, nD1, $06
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nE1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD1, nC1, $12
	smpsAlterNote       $03
	dc.b	nFs1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $05, $03, nRst, nG1, $06, smpsNoAttack, nA1, nG1, $18, nRst
	dc.b	$06
	smpsAlterNote       $FD
	dc.b	nB1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nC2, $02, nRst, $03, nC2, $09
	smpsAlterNote       $03
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $01, $0C
	smpsAlterNote       $FD
	dc.b	$01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nC2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $0D, nRst, $03, nB1, $06, nA1, $0C, nB1, $06, nC2
	smpsAlterNote       $02
	dc.b	nCs2, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD2, $11, nC2, $06, nB1, $0C, nC2, $06, nB1, nA1, $12
	dc.b	nB1, $06, nC2, $0C, nB1, $06, nC2
	smpsAlterNote       $04
	dc.b	nCs2, $01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $10, nC2, $06, nD2, $0C
	smpsAlterNote       $03
	dc.b	nEb2, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nE2, smpsNoAttack, $0A
	smpsAlterNote       $FD
	dc.b	nB1, $01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nC2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $0D, nRst, $03, nB1, $06, nA1, $0C, nB1, $06, nC2
	smpsAlterNote       $02
	dc.b	nCs2, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD2, $11, nC2, $06, nB1, $0C, nC2, $06, nB1, nA1, $12
	dc.b	nB1, $06, nC2, $0C, nB1, $06, nC2
	smpsAlterNote       $04
	dc.b	nCs2, $01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $10, nC2, $06, nD2, $0C
	smpsAlterNote       $03
	dc.b	nEb2, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nE2, smpsNoAttack, $0A, nA1, $2F, nRst, $7F, $7F, $5F
	smpsAlterNote       $03
	dc.b	nFs1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $05, $03, nRst, nG1, $06, smpsNoAttack, nF1, nE1, $18, nRst
	dc.b	$06, nD1, $03, nRst, nD1, $06
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nE1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD1, nC1, $12
	smpsAlterNote       $03
	dc.b	nFs1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $05, $03, nRst, nG1, $06, smpsNoAttack, nA1, nG1, $18, nRst
	dc.b	$06
	smpsAlterNote       $FD
	dc.b	nB1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nC2, $02, nRst, $03, nC2, $09
	smpsAlterNote       $03
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $01, $09
	smpsAlterNote       $04
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FC
	dc.b	smpsNoAttack, nBb1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $01, nG1, $06, nRst
	smpsAlterNote       $03
	dc.b	nFs1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $05, $03, nRst, nG1, $06, smpsNoAttack, nF1, nE1, $18, nRst
	dc.b	$06, nD1, $03, nRst, nD1, $06
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nE1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD1, nC1, $12
	smpsAlterNote       $03
	dc.b	nFs1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $05, $03, nRst, nG1, $06, smpsNoAttack, nA1, nG1, $18, nRst
	dc.b	$06
	smpsAlterNote       $FD
	dc.b	nB1, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nC2, $02, nRst, $03, nC2, $09
	smpsAlterNote       $03
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, nB1
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $01, $0C
	smpsAlterNote       $FD
	dc.b	$01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nC2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $0D, nRst, $03, nB1, $06, nA1, $0C, nB1, $06, nC2
	smpsAlterNote       $02
	dc.b	nCs2, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD2, $11, nC2, $06, nB1, $0C, nC2, $06, nB1, nA1, $12
	dc.b	nB1, $06, nC2, $0C, nB1, $06, nC2
	smpsAlterNote       $04
	dc.b	nCs2, $01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $10, nC2, $06, nD2, $0C
	smpsAlterNote       $03
	dc.b	nEb2, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nE2, smpsNoAttack, $0A
	smpsAlterNote       $FD
	dc.b	nB1, $01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nC2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $0D, nRst, $03, nB1, $06, nA1, $0C, nB1, $06, nC2
	smpsAlterNote       $02
	dc.b	nCs2, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nD2, $11, nC2, $06, nB1, $0C, nC2, $06, nB1, nA1, $12
	dc.b	nB1, $06, nC2, $0C, nB1, $06, nC2
	smpsAlterNote       $04
	dc.b	nCs2, $01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nD2
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $10, nC2, $06, nD2, $0C
	smpsAlterNote       $03
	dc.b	nEb2, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nE2, smpsNoAttack, $0A

promise_Loop3C:
	dc.b	nE0, $1E, nB0, $06, nG1, nE1, $36
	smpsLoop            $00, $03, promise_Loop3C
	dc.b	nE0, $1E, nB0, $06, nG1, nE1, $33, nRst, $21

promise_Loop3D:
	dc.b	nB0, $05, nRst, $01, nE1, $05, nRst, $01, nFs1, $05, nRst, $01
	dc.b	nFs1
	smpsAlterNote       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $1C
	smpsLoop            $00, $03, promise_Loop3D
	dc.b	nB0, $05, nRst, $01, nE1, $05, nRst, $01, nFs1, $05, nRst, $01
	dc.b	nFs1
	smpsAlterNote       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $16, nFs1, $06

promise_Loop3E:
	dc.b	nB0, $05, nRst, $01, nE1, $05, nRst, $01, nFs1, $05, nRst, $01
	dc.b	nFs1
	smpsAlterNote       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $1C
	smpsLoop            $00, $03, promise_Loop3E
	dc.b	nB0, $05, nRst, $01, nE1, $05, nRst, $01, nFs1, $05, nRst, $01
	dc.b	nFs1
	smpsAlterNote       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, nG1, $16, nFs1, $06, $05

promise_Loop3F:
	dc.b	nRst, $01, nG1, $05, nRst, $01, nA1, $05, nRst, $01, nBb1
	smpsAlterNote       $F9
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nB1, $1C
	smpsAlterNote       $00
	dc.b	nFs1, $05
	smpsLoop            $00, $03, promise_Loop3F
	dc.b	nRst, $01, nG1, $05, nRst, $01, nA1, $05, nRst, $01, nBb1
	smpsAlterNote       $F9
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nB1, $16, nA1, $06

promise_Loop40:
	smpsAlterNote       $00
	dc.b	nFs1, $05, nRst, $01, nG1, $05, nRst, $01, nA1, $05, nRst, $01
	dc.b	nBb1
	smpsAlterNote       $F9
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nB1, $1C
	smpsLoop            $00, $03, promise_Loop40
	smpsAlterNote       $00
	dc.b	nFs1, $05, nRst, $01, nG1, $05, nRst, $01, nA1, $05, nRst, $01
	dc.b	nBb1
	smpsAlterNote       $F9
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $01
	dc.b	smpsNoAttack, nB1, $16, nA1, $18
	smpsAlterNote       $00
	dc.b	nG1, $12, nE0, $0C

promise_Loop41:
	dc.b	nB0, $06, nG1, nE1, $36, nE0, $1E
	smpsLoop            $00, $03, promise_Loop41
	dc.b	nB0, $06, nG1, nE1, $33, nRst, $6A, $6A, $6A, $6A, $6A, $31
	smpsPSGvoice        $00
	smpsStop

; PSG3 Data
promise_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $7F, $41, nMaxPSG

promise_Loop30:
	dc.b	$06
	smpsLoop            $00, $3C, promise_Loop30
	smpsPSGvoice        fTone_02

promise_Loop31:
	dc.b	$06
	smpsLoop            $00, $41, promise_Loop31
	smpsPSGvoice        fTone_01
	dc.b	$06
	smpsPSGvoice        fTone_02
	dc.b	$06, $06
	smpsPSGvoice        fTone_01

promise_Loop32:
	dc.b	$06
	smpsLoop            $00, $7C, promise_Loop32
	smpsPSGvoice        fTone_02

promise_Loop33:
	dc.b	$06
	smpsLoop            $00, $41, promise_Loop33
	smpsPSGvoice        fTone_01
	dc.b	$06
	smpsPSGvoice        fTone_02
	dc.b	$06, $06
	smpsPSGvoice        fTone_01

promise_Loop34:
	dc.b	$06
	smpsLoop            $00, $40, promise_Loop34

promise_Loop36:
	dc.b	$0C, $0C, $06, $06, $06, $0C

promise_Loop35:
	dc.b	$06
	smpsLoop            $00, $07, promise_Loop35
	smpsLoop            $01, $03, promise_Loop36
	dc.b	$0C, $0C, $06, $06, $06, $12
	smpsPSGvoice        fTone_02
	dc.b	$18, $18, $24
	smpsPSGvoice        fTone_01

promise_Loop37:
	dc.b	$06
	smpsLoop            $00, $3A, promise_Loop37
	dc.b	$24

promise_Loop38:
	dc.b	$06
	smpsLoop            $00, $37, promise_Loop38
	dc.b	$36

promise_Loop3A:
	dc.b	$0C, $0C, $06, $06, $06, $0C

promise_Loop39:
	dc.b	$06
	smpsLoop            $00, $07, promise_Loop39
	smpsLoop            $01, $02, promise_Loop3A
	dc.b	$0C, $0C, $06, $06, $06, $0C, $06, $06, $06, $48
	smpsPSGAlterVol     $0A

promise_Loop3B:
	dc.b	smpsNoAttack, $60
	smpsLoop            $00, $06, promise_Loop3B
	smpsPSGAlterVol     $F6
	dc.b	smpsNoAttack, $30
	smpsStop

promise_Voices:
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

;	Voice $03
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

