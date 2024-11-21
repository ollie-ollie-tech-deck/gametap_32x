ghz_good_future_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     ghz_good_future_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $0C

	smpsHeaderDAC       ghz_good_future_DAC
	smpsHeaderFM        ghz_good_future_FM1,	$00, $13
	smpsHeaderFM        ghz_good_future_FM2,	$00, $0F
	smpsHeaderFM        ghz_good_future_FM3,	$00, $19
	smpsHeaderFM        ghz_good_future_FM4,	$00, $10
	smpsHeaderFM        ghz_good_future_FM5,	$00, $14
	smpsHeaderPSG       ghz_good_future_PSG1,	$00, $07, $00, $00
	smpsHeaderPSG       ghz_good_future_PSG2,	$00, $00, $00, $00
	smpsHeaderPSG       ghz_good_future_PSG3,	$00, $05, $00, $00

; DAC Data
ghz_good_future_DAC:
	smpsPan             panCenter, $00

ghz_good_future_Loop00:
	dc.b	dKick, $0F, dSnare, $0B, dKick, $0C, $07, dSnare, $04, dKick, $0B, $0F
	dc.b	dSnare, $0B, dKick, $0C, $07, dSnare, $0F
	smpsLoop            $00, $10, ghz_good_future_Loop00
	smpsJump            ghz_good_future_Loop00

; FM1 Data
ghz_good_future_FM1:
	smpsAlterNote       $00
	smpsSetvoice        $04
	smpsPan             panRight, $00

ghz_good_future_Jump01:
	dc.b	nRst, $67, $67, $67, $67, $67, $67, $01, nA4, $03, nRst, $01
	dc.b	nC5, $03, nG5, $0B, nRst, $01, nE5, $0A, nRst, $01, nD5, $0B
	dc.b	nE5, nB4, nRst, $01, nG4, $0A, nRst, $01, nE4, $0B, nG4, $03
	dc.b	nRst, $01, nA4, $0B, nRst, $7F, $01, nA5, $0A, nRst, $01, nF5
	dc.b	$03, nRst, $01, nG5, $03, nA5, $07, nRst, $01, nC6, $07, nA5
	dc.b	nRst, $01, nF5, $0B, nG5, $07, nRst, $01, nB5, $03, nG5, $07
	dc.b	nRst, $01, nB5, $07, nD6, nRst, $01, nC6, $03, nRst, $01, nB5
	dc.b	$03, nG5, $07, nRst, $01, nE5, $0B, nRst, $7C, nC4, $03, nRst
	dc.b	$01, nF4, $07, nA4, $03, nRst, $01, nF4, $07, nB4, $04, nG4
	dc.b	$07, nRst, $01, nC5, $03, nA4, $07, nRst, $01, nD5, $03, nRst
	dc.b	$01, nB4, $07, nE5, nRst, $01, nC5, $03, nF5, $07, nRst, $01
	dc.b	nC5, $03, nRst, $01, nG5, $07, nC5, $03, nRst, $01, nB5, $07
	dc.b	nA5, nRst, $01, nG5, $0B, nRst, $7F, $01, nA4, $0C, nRst, $03
	dc.b	nD5, $0C, nRst, $03, nC5, $0C, nRst, $03, nE5, $0E, nRst, $01
	dc.b	nF5, $07, nE5, nRst, $01, nD5, $07, nC5, nRst, $01, nE5, $07
	dc.b	nG4, $0D, nRst, $02, nBb4, $0D, nRst, $06, nG5, $07, nBb5, $0B
	dc.b	nRst, $01, nG5, $0A, nRst, $01, nBb5, $0B, nRst, $13, nG5, $07
	dc.b	nBb5, $0B, nRst, $01, nG5, $0A, nRst, $01, nBb5, $0B, nA4, $0D
	dc.b	nRst, $06, nE5, $07, nA5, $0B, nRst, $01, nE5, $0A, nRst, $01
	dc.b	nA5, $0B, nRst, $13, nE5, $07, nA5, $0B, nRst, $01, nE5, $0A
	dc.b	nRst, $01, nA5, $0B, nAb4, $0D, nRst, $06, nEb5, $07, nAb5, $0B
	dc.b	nRst, $01, nEb5, $0A, nRst, $01, nAb5, $0B, nRst, $13, nEb5, $07
	dc.b	nAb5, $0B, nRst, $01, nEb5, $0A, nRst, $01, nAb5, $0B, nG4, $0D
	dc.b	nRst, $06, nD5, $07, nG5, $0B, nRst, $01, nD5, $0A, nRst, $01
	dc.b	nG5, $0B, nRst, $13, nD5, $07, nG5, $0B, nRst, $01, nD5, $0A
	dc.b	nRst, $01, nG5, $0B
	smpsJump            ghz_good_future_Jump01

; FM2 Data
ghz_good_future_FM2:
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsPan             panCenter, $00

ghz_good_future_Loop07:
	dc.b	nC3, $0D, nRst, $06, nG2, $03, nRst, $01, nA2, $03, nC3, $04
	dc.b	nRst, nC3, $03, nRst, $01, nA2, $07, nC3, nRst, $01, nA2, $07
	dc.b	nBb2, $0D, nRst, $06, nG2, $03, nRst, $01, nA2, $03, nBb2, $04
	dc.b	nRst, nBb2, $03, nRst, $01, nA2, $07, nBb2, nRst, $01, nB2, $07
	smpsLoop            $00, $02, ghz_good_future_Loop07
	dc.b	nC3, $0D, nRst, $06, nG2, $03, nRst, $01, nA2, $03, nC3, $04
	dc.b	nRst, nC3, $03, nRst, $01, nA2, $07, nC3, nRst, $01, nA2, $07
	dc.b	nBb2, $0D, nRst, $06, nG2, $03, nRst, $01, nA2, $03, nBb2, $04
	dc.b	nRst, nBb2, $03, nRst, $01, nC3, $07, nD3, nRst, $01, nBb2, $07
	dc.b	nC3, $0D, nRst, $06, nG2, $03, nRst, $01, nA2, $03, nC3, $04
	dc.b	nRst, nC3, $03, nRst, $01, nE3, $07, nG3, nRst, $01, nC3, $07
	dc.b	nBb2, $0D, nRst, $06, nG2, $03, nRst, $01, nA2, $03, nG2, $04
	dc.b	nBb2, $03, nRst, $01, nBb3, $07, nBb2, $04, nB2, $03, nRst, $01
	dc.b	nB3, $07, nB2, $04

ghz_good_future_Loop08:
	dc.b	nF3, $0D, nRst, $06, nC3, $03, nRst, $01, nF3, $03, $04, nRst
	dc.b	nC3, $03, nRst, $01, nC3, $07, nF3, nRst, $01, nC3, $07, nE3
	dc.b	$0D, nRst, $06, nC3, $03, nRst, $01, nE3, $03, $04, nRst, nE3
	dc.b	$03, nRst, $01, nC3, $07, nD3, nRst, $01, nE3, $07
	smpsLoop            $00, $08, ghz_good_future_Loop08

ghz_good_future_Loop09:
	dc.b	nBb2, $0D, nRst, $06, nG2, $03, nRst, $01, nBb2, $03, $04, nRst
	dc.b	nBb2, $03, nRst, $01, nG2, $07, nBb2, nRst, $01, nG2, $07
	smpsLoop            $00, $02, ghz_good_future_Loop09
	dc.b	nA2, $0D, nRst, $06, nE2, $03, nRst, $01, nA2, $03, $04, nRst
	dc.b	nA2, $03, nRst, $01, nE2, $07, nG2, nRst, $01, nE2, $07, nA2
	dc.b	$03, nRst, $01, nA3, $07, nA2, $04, nB2, $03, nRst, $01, nB3
	dc.b	$07, nB2, $04, nC3, $03, nRst, $01, nC4, $07, nC3, $04, nA2
	dc.b	$03, nRst, $01, nA3, $07, nA2, $04

ghz_good_future_Loop0A:
	dc.b	nAb2, $0D, nRst, $06, nEb2, $03, nRst, $01, nAb2, $03, $04, nRst
	dc.b	nAb2, $03, nRst, $01, nEb2, $07, nAb2, nRst, $01, nEb2, $07
	smpsLoop            $00, $02, ghz_good_future_Loop0A
	dc.b	nG2

ghz_good_future_Loop0B:
	dc.b	$0D, nRst, $06, nB2, $03, nRst, $01, nD3, $03, $04, nRst, nD3
	dc.b	$03, nRst, $01, nG2, $07, nD3, nRst, $01, nG2, $07
	smpsLoop            $00, $02, ghz_good_future_Loop0B
	smpsJump            ghz_good_future_Loop07

; FM3 Data
ghz_good_future_FM3:
	smpsAlterNote       $00
	smpsSetvoice        $01
	smpsPan             panCenter, $00

ghz_good_future_Loop05:
	dc.b	nG4, $38, nRst, $04
	smpsLoop            $00, $08, ghz_good_future_Loop05

ghz_good_future_Loop06:
	dc.b	nF4, $38, nRst, $04, nE4, $38, nRst, $04
	smpsLoop            $00, $08, ghz_good_future_Loop06
	dc.b	nG4, $74, nRst, $04, nA4, $74, nRst, $04, nAb4, $74, nRst, $04
	dc.b	nG4, $38, nRst, $04, nG4, $38, nRst, $04
	smpsJump            ghz_good_future_Loop05

; FM4 Data
ghz_good_future_FM4:
	smpsAlterNote       $00
	smpsSetvoice        $02
	smpsPan             panLeft, $00

ghz_good_future_Loop03:
	dc.b	nG4, $04, nB4, nD5, $03, nE5, $08, nG5, $04, nB5, $21, nRst
	dc.b	$04, nG4, nBb4, nD5, $03, nE5, $08, nG5, $04, nBb5, $14, nRst
	dc.b	$02, nG5, $0D, nRst, $02, nG4, $04, nB4, nD5, $03, nE5, $08
	dc.b	nG5, $04, nB5, $21, nRst, $22, nBb5, $0D, nRst, $02, nA5, $0D
	dc.b	nRst, $02
	smpsLoop            $00, $02, ghz_good_future_Loop03

ghz_good_future_Loop04:
	dc.b	nE5, $07, nRst, $01, nC5, $07, nA4, nRst, $01, nF4, $0C, nRst
	dc.b	$03, nC5, $07, nE5, $03, nRst, $01, nC5, $07, nE5, $04, nD5
	dc.b	$07, nRst, $01, nB4, $07, nG4, nRst, $01, nE4, $0C, nRst, $03
	dc.b	nD5, $07, nB4, nRst, $01, nG4, $07
	smpsLoop            $00, $07, ghz_good_future_Loop04
	dc.b	nE5, nRst, $01, nC5, $07, nA4, nRst, $01, nF4, $0C, nRst, $03
	dc.b	nC5, $07, nE5, $03, nRst, $01, nC5, $07, nE5, $04, nD5, $07
	dc.b	nRst, $01, nB4, $07, nG4, nRst, $01, nE4, $0C, nRst, $03, nD5
	dc.b	$07, nB4, nRst, $01
	smpsAlterVol        $FB
	dc.b	nG4, $03, nBb5, $0B, nRst, $01, nG5, $0A, nRst, $01, nBb5, $0B
	dc.b	nRst, $13, nG5, $07, nBb5, $0B, nRst, $01, nG5, $0A, nRst, $01
	dc.b	nBb5, $0B, nBb4, $0D, nRst, $06, nD5, $03, nRst, $01, nG5, $03
	dc.b	nA5, $0B, nRst, $01, nE5, $0A, nRst, $01, nA5, $0B, nRst, $13
	dc.b	nC5, $03, nRst, $01, nE5, $03, nA5, $0B, nRst, $01, nE5, $0A
	dc.b	nRst, $01, nA5, $0B, nA4, $0D, nRst, $06, nC5, $03, nRst, $01
	dc.b	nE5, $03, nAb5, $0B, nRst, $01, nEb5, $0A, nRst, $01, nAb5, $0B
	dc.b	nRst, $13, nC5, $03, nRst, $01, nEb5, $03, nAb5, $0B, nRst, $01
	dc.b	nEb5, $0A, nRst, $01, nAb5, $0B, nAb4, $0D, nRst, $06, nC5, $03
	dc.b	nRst, $01, nEb5, $03, nG5, $0B, nRst, $01, nD5, $0A, nRst, $01
	dc.b	nG5, $0B, nRst, $13, nB4, $03, nRst, $01, nD5, $03, nG5, $0B
	dc.b	nRst, $01, nD5, $0A, nRst, $01, nG5, $0B, nG4, $0D, nRst, $06
	smpsAlterVol        $05
	dc.b	nB4, $03, nRst, $01, nD5, $03, nG5, $04
	smpsJump            ghz_good_future_Loop03

; FM5 Data
ghz_good_future_FM5:
	smpsAlterNote       $00
	smpsSetvoice        $03
	smpsPan             panCenter, $00

ghz_good_future_Jump00:
	dc.b	nRst, $4F, nG4, $07, nG5, $0B, nRst, $01
	smpsAlterNote       $EB
	dc.b	nE5
	smpsAlterNote       $F4
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $07, nRst, $01, nD5, $03, nRst, $04, nC5
	smpsAlterNote       $1F
	dc.b	nBb4, $01
	smpsAlterNote       $F3
	dc.b	smpsNoAttack, nB4
	smpsAlterNote       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $03, nRst, $01, nC5, $03, nD5, $04, nRst, nB4, $03, nRst
	dc.b	$04, nG4, smpsNoAttack, $01
	smpsAlterVol        $01
	dc.b	smpsNoAttack, $02
	smpsAlterVol        $01
	dc.b	smpsNoAttack, $03

ghz_good_future_Loop01:
	smpsAlterVol        $01
	dc.b	smpsNoAttack, $02
	smpsLoop            $00, $03, ghz_good_future_Loop01
	smpsAlterVol        $01
	dc.b	smpsNoAttack, $03
	smpsAlterVol        $01
	dc.b	smpsNoAttack, $02
	smpsAlterVol        $01
	dc.b	smpsNoAttack, $01

ghz_good_future_Loop02:
	smpsAlterVol        $01
	dc.b	smpsNoAttack, $02
	smpsLoop            $00, $03, ghz_good_future_Loop02
	smpsAlterVol        $01
	dc.b	smpsNoAttack, $01
	smpsAlterVol        $01
	dc.b	smpsNoAttack, $01, nRst, $01, $01, $01, $01, $69
	smpsAlterVol        $F3
	dc.b	nG5, $03, nRst, $01, nE5, $07, nG5, $04, nF5, $07, nRst, $01
	dc.b	nE6, $03, nD6, $04, nRst, nC6, $03, nRst, $04
	smpsAlterNote       $1A
	dc.b	nA5, $01
	smpsAlterNote       $E4
	dc.b	smpsNoAttack, nBb5
	smpsAlterNote       $F1
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FC
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $03, nRst, $01, nA5, $07, nG5, nRst, $01
	smpsAlterNote       $E1
	dc.b	nA5
	smpsAlterNote       $EB
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $07, nE5, $29, nRst, $04, nC5, $07, nRst, $01, nE5, $07
	dc.b	nD5, $1A, nRst, $04, nBb4, $1A, nRst, $1E
	smpsAlterVol        $FB
	dc.b	nC5, $0B, nRst, $01, nA4, $0A, nRst, $01, nC5, $0B
	smpsAlterNote       $1F
	dc.b	nBb4, $01
	smpsAlterNote       $F3
	dc.b	smpsNoAttack, nB4
	smpsAlterNote       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $03, nRst, $01, nA4, $03, nG4, $04, nRst
	smpsAlterNote       $FD
	dc.b	nAb4, $01
	smpsAlterNote       $11
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $EB
	dc.b	smpsNoAttack, nA4
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $03
	smpsAlterNote       $FC
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $F2
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $E5
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $15
	dc.b	smpsNoAttack, nAb4
	smpsAlterNote       $0C
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	nRst
	smpsAlterNote       $F9
	dc.b	$01
	smpsAlterNote       $EE
	dc.b	$01
	smpsAlterNote       $00
	dc.b	nE4, $18, nRst, $7F, $15, nA4, $07, nRst, $01, nA4, $03, nRst
	dc.b	$01, nC5, $07
	smpsAlterNote       $12
	dc.b	nCs5, $01
	smpsAlterNote       $F1
	dc.b	smpsNoAttack, nD5
	smpsAlterNote       $F7
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $03, nRst, $01, nC5, $07
	smpsAlterNote       $14
	dc.b	nEb5, $01
	smpsAlterNote       $EF
	dc.b	smpsNoAttack, nE5
	smpsAlterNote       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $07, nG5, $0B, nRst, $01
	smpsAlterNote       $EB
	dc.b	nE5
	smpsAlterNote       $F4
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $07, nRst, $01, nD5, $03, nRst, $01, nC5, $03, nE5, $07
	dc.b	nRst, $01, nB4, $07, nD5, $04, nC5, $1A, nRst, $5E, nG5, $03
	dc.b	nRst, $01, nA5, $03, nRst, $04, nC6, nRst
	smpsAlterNote       $E1
	dc.b	nA5, $01
	smpsAlterNote       $EB
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $0C, nRst, $0A, nG5, $03, nRst, $01, nA5, $03, nRst, $01
	dc.b	nC6, $07, nD6, nRst, $01, nE6, $03, nD6, $04, nRst, nC6, $03
	dc.b	nRst, $04
	smpsAlterNote       $1C
	dc.b	nBb5, $01
	smpsAlterNote       $F1
	dc.b	smpsNoAttack, nB5
	smpsAlterNote       $F8
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $03, nRst, $01, nA5, $03, nRst, $01, nG5, $03, nE5, $07
	dc.b	nRst, $01, nG5, $0B, nRst, $7F, $01
	smpsAlterNote       $E4
	dc.b	nA5
	smpsAlterNote       $EF
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $F9
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $09, nRst, $03, nF5, $0C, nRst, $03, nC5, $0C, nRst, $03
	dc.b	nB4, $0E, nRst, $01
	smpsAlterNote       $ED
	dc.b	nD5
	smpsAlterNote       $F5
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FB
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $09, nRst, $03, nG4, $21, nRst, $7C, nD5, $38, nRst, $1E
	smpsAlterNote       $12
	dc.b	nEb5, $01
	smpsAlterNote       $EC
	dc.b	smpsNoAttack, nE5
	smpsAlterNote       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $07, nRst, $01, nC5, $07
	smpsAlterNote       $12
	dc.b	nCs5, $01
	smpsAlterNote       $F1
	dc.b	smpsNoAttack, nD5
	smpsAlterNote       $F7
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FF
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $03, nRst, $01, nC5, $03, nE5, $3C, nRst, $1E
	smpsAlterNote       $12
	dc.b	nEb5, $01
	smpsAlterNote       $EC
	dc.b	smpsNoAttack, nE5
	smpsAlterNote       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $07, nRst, $01, nC5, $0A, nRst, $01, nA4, $07
	smpsAlterNote       $12
	dc.b	nEb5, $01
	smpsAlterNote       $EC
	dc.b	smpsNoAttack, nE5
	smpsAlterNote       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FE
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $03, nRst, $01, nEb5, $34, nRst, $17, nAb4, $03, nRst, $01
	dc.b	nC5, $03
	smpsAlterNote       $11
	dc.b	nD5, $01
	smpsAlterNote       $ED
	dc.b	smpsNoAttack, nEb5
	smpsAlterNote       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $07, nRst, $01, nC5, $07, nEb5, nRst, $01, nF5, $03
	smpsAlterNote       $11
	dc.b	nCs5, $01
	smpsAlterNote       $EE
	dc.b	smpsNoAttack, nD5
	smpsAlterNote       $F6
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $FD
	dc.b	smpsNoAttack, $01
	smpsAlterNote       $00
	dc.b	smpsNoAttack, $38, nRst, $40
	smpsAlterVol        $05
	smpsJump            ghz_good_future_Jump00

; PSG1 Data
ghz_good_future_PSG1:
	smpsAlterNote       $00
	smpsPSGvoice        $00

ghz_good_future_Loop0D:
	dc.b	nB2, $03, nRst, $01, nC2, $03, nRst, $01, nB2, $03, nC2, $04
	smpsLoop            $00, $04, ghz_good_future_Loop0D

ghz_good_future_Loop0E:
	dc.b	nG2, $03, nRst, $01, nBb1, $03, nRst, $01, nG2, $03, nBb1, $04
	smpsLoop            $00, $04, ghz_good_future_Loop0E
	smpsLoop            $01, $04, ghz_good_future_Loop0D

ghz_good_future_Loop0F:
	dc.b	nG2, $03, nRst, $01, nF1, $03, nRst, $01, nG2, $03, nF1, $04
	smpsLoop            $00, $04, ghz_good_future_Loop0F

ghz_good_future_Loop10:
	dc.b	nG2, $03, nRst, $01, nE1, $03, nRst, $01, nG2, $03, nE1, $04
	smpsLoop            $00, $04, ghz_good_future_Loop10
	smpsLoop            $01, $08, ghz_good_future_Loop0F

ghz_good_future_Loop11:
	dc.b	nG2, $03, nRst, $01, nBb1, $03, nRst, $01, nG2, $03, nBb1, $04
	smpsLoop            $00, $08, ghz_good_future_Loop11

ghz_good_future_Loop12:
	dc.b	nA2, $03, nRst, $01, nA1, $03, nRst, $01, nA2, $03, nA1, $04
	smpsLoop            $00, $08, ghz_good_future_Loop12

ghz_good_future_Loop13:
	dc.b	nAb2, $03, nRst, $01, nAb1, $03, nRst, $01, nAb2, $03, nAb1, $04
	smpsLoop            $00, $08, ghz_good_future_Loop13

ghz_good_future_Loop14:
	dc.b	nG2, $03, nRst, $01, nB1, $03, nRst, $01, nG2, $03, nB1, $04
	smpsLoop            $00, $08, ghz_good_future_Loop14
	smpsJump            ghz_good_future_Loop0D

; PSG3 Data
ghz_good_future_PSG3:
	smpsPSGform         $E7
	smpsAlterNote       $00

ghz_good_future_Jump02:
	smpsPSGvoice        fTone_02
	dc.b	nMaxPSG

ghz_good_future_Loop0C:
	dc.b	$04, $04, $03, $04
	smpsLoop            $00, $80, ghz_good_future_Loop0C
	smpsJump            ghz_good_future_Jump02

; PSG2 Data
ghz_good_future_PSG2:
	smpsStop

ghz_good_future_Voices:
;	Voice $00
;	$28
;	$39, $35, $30, $31, 	$1F, $1F, $1F, $1F, 	$0C, $0A, $07, $0A
;	$07, $07, $07, $09, 	$26, $16, $16, $F6, 	$17, $32, $14, $00
	smpsVcAlgorithm     $00
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $00, $05, $09
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $07, $0A, $0C
	smpsVcDecayRate2    $09, $07, $07, $07
	smpsVcDecayLevel    $0F, $01, $01, $02
	smpsVcReleaseRate   $06, $06, $06, $06
	smpsVcTotalLevel    $00, $14, $32, $17

;	Voice $01
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

;	Voice $02
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

;	Voice $03
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

;	Voice $04
;	$3E
;	$38, $01, $7A, $34, 	$59, $D9, $5F, $9C, 	$0F, $04, $0F, $0A
;	$02, $02, $05, $05, 	$AF, $AF, $66, $66, 	$28, $00, $23, $00
	smpsVcAlgorithm     $06
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $00, $03
	smpsVcCoarseFreq    $04, $0A, $01, $08
	smpsVcRateScale     $02, $01, $03, $01
	smpsVcAttackRate    $1C, $1F, $19, $19
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0F, $04, $0F
	smpsVcDecayRate2    $05, $05, $02, $02
	smpsVcDecayLevel    $06, $06, $0A, $0A
	smpsVcReleaseRate   $06, $06, $0F, $0F
	smpsVcTotalLevel    $00, $23, $00, $28

