ghz_telefon_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     ghz_telefon_Voices
	smpsHeaderChan      $02, $03
	smpsHeaderTempo     $02, $08

	smpsHeaderDAC       ghz_telefon_DAC
	smpsHeaderFM        ghz_telefon_FM1,	$00, $00
	smpsHeaderPSG       ghz_telefon_PSG1,	$00, $00, $00, $00
	smpsHeaderPSG       ghz_telefon_PSG2,	$00, $00, $00, $00
	smpsHeaderPSG       ghz_telefon_PSG3,	$00, $02, $00, $00

; DAC Data
ghz_telefon_DAC:
	smpsPan             panCenter, $00

ghz_telefon_Loop00:
	dc.b	dKick, $0C, dSnare, $06, dKick, $12, dSnare, $0C, dKick, dSnare, $06, dKick
	dc.b	$0C, $06, dSnare, $03, dKick, $09, $0C, dSnare, $06, dKick, $12, dSnare
	dc.b	$0C, dKick, dSnare, $06, dKick, $0C, $06, dSnare, $03, dKick, dSnare, dSnare
	smpsLoop            $00, $04, ghz_telefon_Loop00
	smpsJump            ghz_telefon_DAC

; FM1 Data
ghz_telefon_FM1:
	smpsPan             panCenter, $00
	smpsAlterVol        $06
	smpsAlterNote       $00
	smpsSetvoice        $00
	dc.b	nG1, $03

ghz_telefon_Loop01:
	dc.b	nRst, $06, nG2, $03, nRst, $06, nBb3, $03, nRst, $15, nBb2, $03
	dc.b	nRst, nC3, nRst, $06, nC3, $03, nRst, $06, nG4, $03, nRst, $0F
	dc.b	nC3, $03, nRst, nBb2, nRst, nG2
	smpsLoop            $00, $03, ghz_telefon_Loop01
	dc.b	nRst, $06, nG2, $03, nRst, $06, nBb3, $03, nRst, $15, nBb2, $03
	dc.b	nRst, nC3, nRst, $06, nC3, $03, nRst, $06, nG4, $03

ghz_telefon_Loop02:
	dc.b	nRst, $1B, nBb2, $03, nRst, $0F, nBb2, $03, nRst, $1B, nEb2, $03
	dc.b	nRst, $09, nEb3, $03, nRst, nEb2
	smpsLoop            $00, $04, ghz_telefon_Loop02
	dc.b	nRst, $1B
	smpsAlterVol        $FA
	smpsJump            ghz_telefon_FM1

; PSG2 Data
ghz_telefon_PSG2:
	smpsAlterNote       $00
	smpsPSGvoice        $00
	dc.b	nRst, $06, nD0, $03, nRst, nBb0, nRst, nG0, nRst, $09, nBb0, $03
	dc.b	nRst, nA0, nRst, nBb0, nRst, nA0, nRst, nF0, nRst, nG0, nRst, nD1
	dc.b	nRst, $08, nC1, $03, nRst, $04, nBb0, $03, nRst, nA0, nRst, $09
	dc.b	nBb0, $03, nRst, nA0, nRst, nF0, nRst, $09, nD0, $03, nRst, nBb0
	dc.b	nRst, nG0

ghz_telefon_Loop04:
	dc.b	nRst, nBb0, nRst, $09, nA0, $03
	smpsLoop            $00, $02, ghz_telefon_Loop04
	dc.b	nRst, nF0, nRst, nG0, nRst, $09, nG0, $03, nRst, nEb0, nRst, nG0
	dc.b	nRst, $09, nF0, $03, nRst, nG0, nRst, nF0, nRst, nC0, nRst, nD0
	dc.b	nRst, nBb0, nRst, nG0, nRst, $09, nBb0, $03, nRst, nA0, nRst, nBb0
	dc.b	nRst, $09, nA0, $03, nRst, nF0, nRst, nG0, nRst, $09, nD1, $03
	dc.b	nRst, nC1, nRst, nBb0, nRst, nA0, nRst, $09, nBb0, $03, nRst, nG0
	dc.b	nRst, $27, nC0, $03, nRst, $45, nC0, $06, nRst, nC0, nRst, nC0
	dc.b	$01, nD0, $05, nG0, $06, nRst, $0C, nD0, $06, nRst, nF0, nRst
	dc.b	nF0, nG0, nRst, $0C, nD0, $06, nRst, $12, nC0, $03, nRst, $45
	dc.b	nD0, $06, nRst, nF0, nRst, nF0, nG0, nRst, $0C, nD0, $06, nRst
	dc.b	nF0, nRst, nF0, nG0, nRst, nD0, $03, nRst, nEb0, nRst, nBb0, nRst
	smpsJump            ghz_telefon_PSG2

; PSG3 Data
ghz_telefon_PSG3:
	smpsPSGform         $E7

ghz_telefon_Jump00:
	smpsPSGvoice        fTone_02
	smpsPSGAlterVol     $02
	smpsAlterNote       $00
	dc.b	nMaxPSG

ghz_telefon_Loop03:
	dc.b	$06
	smpsLoop            $00, $80, ghz_telefon_Loop03
	smpsPSGAlterVol     $FE
	smpsJump            ghz_telefon_Jump00

; PSG1 Data
ghz_telefon_PSG1:
	smpsStop

ghz_telefon_Voices:
;	Voice $00
;	$04
;	$01, $00, $00, $00, 	$1F, $1F, $DD, $1F, 	$11, $0D, $05, $05
;	$00, $02, $02, $02, 	$65, $3A, $15, $1A, 	$27, $00, $13, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $00, $01
	smpsVcRateScale     $00, $03, $00, $00
	smpsVcAttackRate    $1F, $1D, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $05, $0D, $11
	smpsVcDecayRate2    $02, $02, $02, $00
	smpsVcDecayLevel    $01, $01, $03, $06
	smpsVcReleaseRate   $0A, $05, $0A, $05
	smpsVcTotalLevel    $00, $13, $00, $27

