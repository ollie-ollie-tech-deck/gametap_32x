title_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     title_Voices
	smpsHeaderChan      $06, $00
	smpsHeaderTempo     $02, $02

	smpsHeaderDAC       title_DAC
	smpsHeaderFM        title_FM1,	$00, $0B
	smpsHeaderFM        title_FM2,	$00, $07
	smpsHeaderFM        title_FM3,	$00, $0A
	smpsHeaderFM        title_FM4,	$00, $0A
	smpsHeaderFM        title_FM5,	$00, $0A

; FM1 Data
title_FM1:
	smpsPan             panCenter, $00
	smpsAlterVol        $05
	smpsAlterNote       $00
	smpsSetvoice        $00

title_Jump03:
	dc.b	nG4, $06, nC5, $0C, nG4, $06, nF4, $09, nEb4, $01, nRst
	smpsAlterVol        $05
	dc.b	nD4
	smpsAlterVol        $FB
	dc.b	nEb4, $0C, nF4, $06, nBb4, $0C, nF4, $06, nEb4, $09, nD4, $01
	dc.b	nRst, nEb4, nC4, $0C, nD4, $09, nG4, $03, nA4, $06, nBb4, nC5
	dc.b	$09, nD5, $03, nBb4, $06, nG4, nAb4, $09, nBb4, $03, nC5, $06
	dc.b	nEb5, nD5, nD5, $03, nC5, nD5, nEb5, nD5, $09, nRst, $03, nEb5
	dc.b	nF5, nG5, $0B, nRst, $19, nC5, $03, nD5, nEb5, nF5, nG5, nBb5
	dc.b	nG5, $0C, nRst, $12, nBb4, $03, nC5, nD5, nEb5, nF5, nBb5, nF5
	dc.b	$0C, nRst, $12, nAb4, $03, nBb4, nC5, nD5, nEb5, nAb5, nEb5, $0C
	dc.b	nRst, $12, nD5, $18, nC5, nD5, $0C, nEb5, nEb5, $18, $18, nF5
	dc.b	nG5, $0C, nAb5, nG5, $12, nAb5, $06, nG5, $09, nF5, $03, nEb5
	dc.b	$06, nD5, nEb5, $18, nD5, $12, nC5, $06, nBb4, $18, $0C, nAb4
	dc.b	nC5, $18, nEb5, $12, nC5, $06, nD5, $18, nG4, $0F, nRst, $09
	dc.b	nF5, $18, nRst, $06, nC5, $03, nD5, nEb5, nF5, nD5, nRst, nEb5
	dc.b	nF5, nG5, $06, $03, nAb5, nG5, $06, nRst, nG5, $03, nAb5, nBb5
	dc.b	nC6, nG5, $06, nAb5, $03, nF5, nG5, nEb5, nF5, nD5, nEb5, nC5
	dc.b	nD5, nEb5, $06, nF5, nG5, $03, nAb5, $06, nG5, nF5, $03, nEb5
	dc.b	$06, nD5, $03, nEb5, nF5, nG5, $06, nAb5, $03, nG5, $06, nF5
	dc.b	$03, nG5, $06, nF5, $18, $12, nEb5, $03, nD5, nEb5, $12, nD5
	dc.b	$06, nC5, $18, nB4, $12, nG4, $06, nB4, $0C, nD5, nC5, $18
	dc.b	$0C, nD5, $06, nEb5, nF5, $12, nG5, $06, nF5, $18
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsJump            title_Jump03

; FM2 Data
title_FM2:
	smpsPan             panCenter, $00
	smpsAlterVol        $06
	smpsAlterNote       $00
	smpsSetvoice        $00

title_Loop01:
	dc.b	nC3, $03, nG3, nC4, nEb4, nC4, nG3, nC3, nEb3
	smpsLoop            $00, $02, title_Loop01
	dc.b	nBb2, nF3, nBb3, nD4, nBb3, nF3, nBb2, nD3, nC3, nG3, nC4, nEb4
	dc.b	nC4, nG3, nC3, nEb3

title_Loop02:
	dc.b	nG2, nD3, nG3, nBb3, nG3, nD3, nG2, nBb2
	smpsLoop            $00, $02, title_Loop02
	dc.b	nAb2, nEb3, nAb3, nC4, nAb3, nEb3, nAb2, nC3, nG2, nB2, nD3, nG3
	dc.b	nB3, nG3, nD3, nB2, nG2, nB2, nD3, nG3, nB3, nD4, nF4, nG4
	dc.b	nC2, $0C, nEb2, nEb2, $12, nRst, $06, nBb2, $18, $18, nAb2, nAb2
	dc.b	nG2, nG2

title_Loop03:
	dc.b	nC3, $03, nG3, nC4, nEb4, nC4, nG3, nC3, nG3
	smpsLoop            $00, $02, title_Loop03

title_Loop04:
	dc.b	nEb3, nBb3, nEb4, nG4, nEb4, nBb3, nEb3, nBb3
	smpsLoop            $00, $02, title_Loop04

title_Loop05:
	dc.b	nF3, nC4, nF4, nAb4, nF4, nC4, nAb3, nC4
	smpsLoop            $00, $02, title_Loop05
	dc.b	nG3, nB3, nF4, nG4, nF4, nD4, nB3, nD4, nEb4, nD4, nF4, nB3
	dc.b	nC4, nEb4, nD4, nBb3

title_Loop06:
	dc.b	nC4, nG3, nC4, nEb4
	smpsLoop            $00, $03, title_Loop06
	dc.b	nG4, nF4, nEb4

title_Loop07:
	dc.b	nD4, nBb3, nF3, nBb3
	smpsLoop            $00, $03, title_Loop07
	dc.b	nD4, nF4, nEb4, nD4

title_Loop08:
	dc.b	nC4, nAb3, nEb3, nAb3
	smpsLoop            $00, $03, title_Loop08
	dc.b	nC4, nEb4, nD4, nC4, nBb3

title_Loop09:
	dc.b	nG3, nD3, nG3, nB3
	smpsLoop            $00, $03, title_Loop09
	dc.b	nD4, nG4, nB4, nG4, nF3, $06, $06, $0C, $06, $0C, $06, nEb3
	dc.b	nEb3, nEb3, $0C, $06, $0C, $06, nC3, nC3, nC3, $0C, $06, $0C
	dc.b	$06, nBb2, nBb2, nBb2, $0C, $06, $0C, nC3, $06, nBb2, $03, nD3
	dc.b	nF3, nBb3, nD4, nRst, $09, nBb2, $06, nF2, $03, nBb2, $0F, nC3
	dc.b	$03, nEb3, nG3, nC4, nEb4, $06, nRst, nC3, nEb3, $03, nC3, $0F
	dc.b	nG2, $03, nB2, nD3, nG3, nB3, $06, nRst, nG2, nD2, $03, nG2
	dc.b	$0F, nC3, $03, nEb3, nG3, nC4, nEb4, $06, nRst, nC3, $03, nRst
	dc.b	nG2, nC3, $09, nRst, $06, nBb1, $12, $06, nD2, $0C, nEb2
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsJump            title_Loop01

; FM3 Data
title_FM3:
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00

title_Jump02:
	dc.b	nRst, $7F, $59, nC2, $12, $06, $12, nC3, $06, nBb2, $12, $06
	dc.b	$12, $06, nAb2, $12, $06, $18, nG2, $12, $06, $18, nRst, $7F
	dc.b	$7F, $7F, $03, nC5, nD5, nEb5, $06, $03, nD5, nC5, $06, nRst
	dc.b	$7F, $29, nBb2, $18, $09, nRst, $0F, nC3, $18, $09, nRst, $0F
	dc.b	nG2, $18, $09, nRst, $0F, nC2, $18, $18, nRst, $24, nG5, $0C
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsJump            title_Jump02

; FM4 Data
title_FM4:
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00

title_Jump01:
	dc.b	nRst, $7F, $65, nC3, $0C, $12, nD3, $03, nEb3, nF3, $18, $18
	dc.b	nEb3, nEb3, nD3, nD3, nRst, $7F, $7F, $7F, $03
	smpsAlterVol        $03
	dc.b	nC4

title_Loop00:
	dc.b	$06, $06, $0C, $06, $0C, $06
	smpsLoop            $00, $02, title_Loop00
	dc.b	nAb3, nAb3, nAb3, $0C, $06, $0C, $06, nG3, nG3, nG3, $0C, $06
	dc.b	$0C, $06, nRst, $7F, $41, nBb2, $12, $06, nD3, $0C, nEb3
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsAlterVol        $FD
	smpsJump            title_Jump01

; FM5 Data
title_FM5:
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00

title_Jump00:
	dc.b	nRst, $7F, $7F, $7F, $03, nB4, $18, nRst, $7F, $7F, $7F, $03
	smpsAlterVol        $02
	dc.b	nAb3, $06, $06, $0C, $06, $0C, $06, nG3, nG3, nG3, $0C, $06
	dc.b	$0C, $06, nF3, nF3, nF3, $0C, $06, $0C, $06, nEb3, nEb3, nEb3
	dc.b	$0C, $06, $0C, $06, nRst, $7F, $65, nC5, $0C
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $00
	smpsAlterVol        $FE
	smpsJump            title_Jump00

; DAC Data
title_DAC:
	smpsStop

title_Voices:
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

