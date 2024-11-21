ghzgems_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     ghzgems_Voices
	smpsHeaderChan      $07, $00
	smpsHeaderTempo     $02, $03

	smpsHeaderDAC       ghzgems_DAC
	smpsHeaderFM        ghzgems_FM1,	$00, $07
	smpsHeaderFM        ghzgems_FM2,	$00, $0A
	smpsHeaderFM        ghzgems_FM3,	$00, $08
	smpsHeaderFM        ghzgems_FM4,	$00, $06
	smpsHeaderFM        ghzgems_FM5,	$00, $02
	smpsHeaderFM        ghzgems_FM6,	$00, $00

; FM1 Data
ghzgems_FM1:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	smpsModSet          $00, $01, $03, $04
	smpsModOn
	smpsModOn
	dc.b	nA5, $02, nF5, nA5, nF5, nB5, nG5, nB5, nG5, nC6, nA5, nC6
	dc.b	nA5, nD6, nB5, nD6, nB5

ghzgems_Loop1B:
	dc.b	nE6, nC6
	smpsLoop            $00, $05, ghzgems_Loop1B
	smpsAlterVol        $01
	dc.b	nE6, nC6, nE6

ghzgems_Loop1C:
	dc.b	nC6, nE6, nC6, nE6
	smpsAlterVol        $01
	smpsLoop            $00, $02, ghzgems_Loop1C
	dc.b	nC6, nE6, nC6, nE6, nC6, nE6, nRst, $7F, $4B
	smpsModOn

ghzgems_Jump04:
	dc.b	nRst, $0F
	smpsSetvoice        $07
	dc.b	$01
	smpsAlterVol        $FA
	dc.b	nC6, $04, nA5, $08, nC6, $04, nB5, $08, nC6, $04, nB5, $08
	dc.b	nG5, $18, nA5, $04, nE6, nD6, $08, nC6, $04, nB5, $08, nC6
	dc.b	$04, nB5, $08, nG5, $1C, nC6, $04, nA5, $08, nC6, $04, nB5
	dc.b	$08, nC6, $04, nB5, $08, nG5, $18, nA5, $04, $04, nF5, $08
	dc.b	nA5, $04, nG5, $08, nA5, $04, nG5, $08, nC5, $1C, nC6, $04
	dc.b	nA5, $08, nC6, $04, nB5, $08, nC6, $04, nB5, $08, nG5, $18
	dc.b	nA5, $04, nE6, nD6, $08, nC6, $04, nB5, $08, nC6, $04, nB5
	dc.b	$08, nG5, $1C, nC6, $04, nA5, $08, nC6, $04, nB5, $08, nC6
	dc.b	$04, nB5, $08, nG5, $18, nA5, $04, $04, nF5, $08, nA5, $04
	dc.b	nG5, $08, nA5, $04, nG5, $08, nC6, $04, $04, nE6, nD6, $31
	dc.b	nRst, $03, nC6, $04
	smpsAlterVol        $01
	dc.b	nD6
	smpsAlterVol        $FF
	dc.b	nE6, $35, nRst, $03, nC6, $04, $04, nE6, nEb6, $31, nRst, $03
	dc.b	nC6, $04
	smpsAlterVol        $01
	dc.b	nEb6
	smpsAlterVol        $FF
	dc.b	nD6, $1F, nRst, $01, nE6, $06, nRst, $02, nE6, $04, nF6, nE6
	dc.b	nG6, nE6, $08, nC6, $04
	smpsSetTempoMod     $03
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsModSet          $00, $01, $03, $04
	smpsAlterVol        $06
	smpsJump            ghzgems_Jump04

; FM2 Data
ghzgems_FM2:
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nRst, $03
	smpsSetvoice        $01
	dc.b	$01, nA2, $04, nA3, nA2, nBb2, nBb3, nB2, nB3

ghzgems_Loop10:
	dc.b	nC3
	smpsLoop            $00, $18, ghzgems_Loop10
	dc.b	nC3, $02, nRst, nC3, $04, nA2, $02, nRst, nA2, $04, nBb2, $02
	dc.b	nRst, nBb2, $04, nB2, $02, nRst, nB2

ghzgems_Loop11:
	dc.b	$04, nC3
	smpsLoop            $00, $0F, ghzgems_Loop11
	dc.b	nC3, nD3, nE3

ghzgems_Jump03:
	smpsAlterVol        $03

ghzgems_Loop13:
	dc.b	nF3

ghzgems_Loop12:
	dc.b	$04
	smpsLoop            $00, $08, ghzgems_Loop12
	dc.b	nE3, nE3, nE3, nE3, nE3, nC3, nD3, nE3
	smpsLoop            $01, $02, ghzgems_Loop13

ghzgems_Loop14:
	dc.b	nF3
	smpsLoop            $00, $08, ghzgems_Loop14

ghzgems_Loop15:
	dc.b	nE3
	smpsLoop            $00, $08, ghzgems_Loop15

ghzgems_Loop16:
	dc.b	nD3
	smpsLoop            $00, $08, ghzgems_Loop16
	dc.b	nC3, nC3, nC3, nC3, nC3

ghzgems_Loop18:
	dc.b	nC3, nD3, nE3

ghzgems_Loop17:
	dc.b	nF3
	smpsLoop            $00, $08, ghzgems_Loop17
	dc.b	nE3, nE3, nE3, nE3, nE3
	smpsLoop            $01, $03, ghzgems_Loop18
	dc.b	nE3, nE3, nE3

ghzgems_Loop19:
	dc.b	nD3
	smpsLoop            $00, $08, ghzgems_Loop19

ghzgems_Loop1A:
	dc.b	nC3
	smpsLoop            $00, $08, ghzgems_Loop1A
	smpsAlterVol        $FC
	dc.b	nBb3, $0C, nA3, nG3, nF3, nE3, $04, nRst, nD3, nRst, nA2, $0C
	dc.b	nB2, nC3, nD3, nE3, $04, nRst, nA3, nRst, nAb3, $0C, nG3, nF3
	dc.b	nEb3, nD3, $04, nRst, nC3, nRst, nG2, $0C, nD3, nG2, nG3, $04
	dc.b	nE2, nE3, nF2, nF3, nG2, nG3
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsSetvoice        $01
	smpsAlterVol        $01
	smpsJump            ghzgems_Jump03

; FM3 Data
ghzgems_FM3:
	smpsPan             panCenter, $00
	smpsSetvoice        $02
	smpsModOff
	smpsModOff
	smpsModOff
	dc.b	nRst, $20

ghzgems_Loop0E:
	dc.b	nB5, $08, nRst, $04, nA5, $08, nRst, $04
	smpsLoop            $00, $02, ghzgems_Loop0E
	dc.b	nB5, nRst, nA5, nRst, nC6, $08, nRst, $04, nB5, $08, nRst, $04
	dc.b	nA5, $26, nRst, $02

ghzgems_Loop0F:
	dc.b	nA5, $08, nRst, $04, nB5, $08, nRst, $04, nC6, nRst
	smpsLoop            $00, $02, ghzgems_Loop0F
	dc.b	nC6, $08, nRst, $04, nB5, $33, nRst, $01

ghzgems_Jump02:
	dc.b	nRst, $2D
	smpsSetvoice        $08
	dc.b	$07
	smpsAlterVol        $FC
	dc.b	nG4, $02, nA4, nC5, $04, nA4, nRst, $34, nG4, $02, nA4, nC5
	dc.b	$04, nE5, nRst, $34, nG4, $02, nA4, nC5, $04, nA4, nRst, $24
	dc.b	nC5, $02, nRst, $06, nA4, $08, nG4, $02, nRst, nA4, nRst, nC5
	dc.b	nRst
	smpsModOff
	dc.b	nE5, $04, nC5, $02, nRst, $12, nE5, $04, nC5, $02, nRst, nD5
	dc.b	$04, nB4, $02, nRst, $0E, nG4, $02, nA4, nC5, $04, nA4, nE5
	dc.b	nC5, $02, nRst, $12, nE5, $04, nC5, $02, nRst, nD5, $04, nB4
	dc.b	$02, nRst, $0E, nG4, $02, nA4, nC5, $04, nE5, nE5, nC5, $02
	dc.b	nRst, $12, nE5, $04, nC5, $02, nRst, nD5, $04, nB4, $02, nRst
	dc.b	$0E, nG4, $02, nA4, nC5, $04, nA4, nC5, nA4, $02, nRst, $16
	dc.b	nE5, $04, nRst, nC5, nRst, nA4, nA4, nA3, $02, nRst, nC4, nRst
	dc.b	nE4
	smpsSetvoice        $09
	dc.b	nRst, $03, nF4, $0C, $0C, $0C, $0C, $04, nRst, nF4, nRst, nE4
	dc.b	$0C, $0C, $0C, $0C, $04, nRst, nE4, nRst, nEb4, $0C, $0C, $0C
	dc.b	$0C, $04, nRst, nEb4, nRst, nA4, $0C, $0C, $0C, $0C, $04, nRst
	dc.b	nA4, nRst, $03
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsModOff
	smpsAlterVol        $04
	smpsJump            ghzgems_Jump02

; FM4 Data
ghzgems_FM4:
	smpsPan             panCenter, $00
	smpsSetvoice        $02
	smpsModOff
	smpsModOff
	smpsModOff
	dc.b	nRst, $06
	smpsPan             panCenter, $00
	dc.b	$1A

ghzgems_Loop0A:
	dc.b	nG5, $08, nRst, $04, nF5, $08, nRst, $04
	smpsLoop            $00, $02, ghzgems_Loop0A
	dc.b	nG5, nRst, nF5, nRst, nA5, $08, nRst, $04, nG5, $08, nRst, $04
	dc.b	nF5, $26, nRst, $03

ghzgems_Loop0B:
	dc.b	nF5, $07, nRst, $05, nG5, $07, nRst, $05, nA5, $03, nRst, $05
	smpsLoop            $00, $02, ghzgems_Loop0B
	dc.b	nA5, $07, nRst, $05, nG5, $33
	smpsSetvoice        $06

ghzgems_Jump01:
	dc.b	nRst, $01
	smpsModOff
	dc.b	nE4, $04
	smpsAlterVol        $04

ghzgems_Loop0C:
	dc.b	$04, nC4, nC4, nA3, nA3, nF3, nF3, nD4, nD4, nB3, nB3, nG3
	dc.b	nG3, nD4, nD4, nE4
	smpsLoop            $00, $02, ghzgems_Loop0C
	dc.b	nE4, nC4, nC4, nA3, nA3, nF3, nF3, nD4, nD4, nB3, nB3, nG3
	dc.b	nG3, nE3, nE3, nC4, nC4, nA3, nA3, nF3, nF3, nD3, nD3, nB3
	dc.b	nB3, nRst, $7F, $7F, $17
	smpsSetvoice        $09
	dc.b	$03
	smpsAlterVol        $FA
	dc.b	nD4, $0C, $0C, $0C, $0C, $04, nRst, nD4

ghzgems_Loop0D:
	dc.b	nRst, nC4, $0C, $0C, $0C, $0C, $04, nRst, nC4
	smpsLoop            $00, $02, ghzgems_Loop0D
	dc.b	nRst, nF4, $0C, $0C, $0C, $0C, $04, nRst, nF4, nRst, $03
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsModOff
	smpsAlterVol        $02
	smpsJump            ghzgems_Jump01

; FM5 Data
ghzgems_FM5:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nRst, $1B
	smpsPan             panCenter, $00
	dc.b	$05

ghzgems_Loop04:
	dc.b	nE5, $08, nRst, $04, nD5, $08, nRst, $04
	smpsLoop            $00, $02, ghzgems_Loop04
	dc.b	nE5, nRst, nD5, nRst, nF5, $08, nRst, $04, nE5, $08, nRst, $04
	dc.b	nD5, $26, nRst, $03

ghzgems_Loop05:
	dc.b	nD5, $07, nRst, $05, nE5, $07, nRst, $05, nF5, $03, nRst, $05
	smpsLoop            $00, $02, ghzgems_Loop05
	dc.b	nF5, $07, nRst, $05, nE5, $33

ghzgems_Jump00:
	dc.b	nRst, $7F, $65
	smpsSetvoice        $00
	dc.b	$05
	smpsAlterNote       $02
	smpsAlterVol        $04
	dc.b	nG4, $08, nA4, nB4, nC5, $28, nD5, $08, nB4, nG4, nC5, $28
	dc.b	nB4, $08, nG4, nB4, nC5, $28, nD5, $08, nB4, nG4, nC5, $40
	smpsAlterNote       $00
	smpsAlterVol        $FE
	smpsSetvoice        $00

ghzgems_Loop06:
	dc.b	nBb4, $04, nF4, nD5, nF4
	smpsLoop            $00, $04, ghzgems_Loop06

ghzgems_Loop07:
	dc.b	nA4, nE4, nC5, nE4
	smpsLoop            $00, $04, ghzgems_Loop07

ghzgems_Loop08:
	dc.b	nAb4, nEb4, nC5, nEb4
	smpsLoop            $00, $04, ghzgems_Loop08

ghzgems_Loop09:
	dc.b	nC5, nA4, nE5, nA4
	smpsLoop            $00, $03, ghzgems_Loop09
	dc.b	nC5, nA4, nE5, nA4, $03
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	smpsAlterVol        $FE
	smpsJump            ghzgems_Jump00

; FM6 Data
ghzgems_FM6:
	smpsPan             panCenter, $00
	smpsSetvoice        $04
	dc.b	nRst, $04, nG1
	smpsSetvoice        $05
	dc.b	nAb1
	smpsSetvoice        $04
	dc.b	nG1, nG1
	smpsSetvoice        $05
	dc.b	nAb1, nAb1, nAb1

ghzgems_Loop00:
	smpsSetvoice        $04
	dc.b	nG1, $08
	smpsSetvoice        $05
	dc.b	nAb1, $04
	smpsSetvoice        $04
	dc.b	nG1, $08, $04
	smpsSetvoice        $05
	dc.b	nAb1, $08
	smpsLoop            $00, $07, ghzgems_Loop00
	smpsSetvoice        $04
	dc.b	nG1
	smpsSetvoice        $05
	dc.b	nAb1, $04
	smpsSetvoice        $04
	dc.b	nG1, $08
	smpsSetvoice        $05
	dc.b	nAb1, $04, $04, $04

ghzgems_Loop01:
	smpsSetvoice        $04
	dc.b	nG1, $08
	smpsSetvoice        $05
	dc.b	nAb1, $04
	smpsSetvoice        $04
	dc.b	nG1, $08, $04
	smpsSetvoice        $05
	dc.b	nAb1, $08
	smpsLoop            $00, $07, ghzgems_Loop01
	smpsSetvoice        $04
	dc.b	nG1
	smpsSetvoice        $05
	dc.b	nAb1, $04
	smpsSetvoice        $04
	dc.b	nG1, $08
	smpsSetvoice        $05
	dc.b	nAb1, $04, $04, $04

ghzgems_Loop02:
	smpsSetvoice        $04
	dc.b	nG1, $08
	smpsSetvoice        $05
	dc.b	nAb1, $04
	smpsSetvoice        $04
	dc.b	nG1, $08, $04
	smpsSetvoice        $05
	dc.b	nAb1, $08
	smpsLoop            $00, $07, ghzgems_Loop02
	smpsSetvoice        $04
	dc.b	nG1
	smpsSetvoice        $05
	dc.b	nAb1, $04
	smpsSetvoice        $04
	dc.b	nG1, $08
	smpsSetvoice        $05
	dc.b	nAb1, $04, $04, $04

ghzgems_Loop03:
	smpsSetvoice        $04
	dc.b	nG1, $08
	smpsSetvoice        $05
	dc.b	nAb1, $04
	smpsSetvoice        $04
	dc.b	nG1, $08, $04
	smpsSetvoice        $05
	dc.b	nAb1, $08
	smpsLoop            $00, $07, ghzgems_Loop03
	smpsSetvoice        $04
	dc.b	nG1
	smpsSetvoice        $05
	dc.b	nAb1, $04
	smpsSetvoice        $04
	dc.b	nG1, $08
	smpsSetvoice        $05
	dc.b	nAb1, $04, $04, $04
	smpsSetTempoMod     $03
	smpsPan             panCenter, $00
	smpsAlterNote       $00
	smpsJump            ghzgems_Loop01

; DAC Data
ghzgems_DAC:
	smpsStop

ghzgems_Voices:
;	Voice $00
;	$0E
;	$11, $03, $73, $11, 	$C8, $0F, $89, $49, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$08, $0F, $0F, $0F, 	$25, $0C, $11, $17
	smpsVcAlgorithm     $06
	smpsVcFeedback      $01
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $07, $00, $01
	smpsVcCoarseFreq    $01, $03, $03, $01
	smpsVcRateScale     $01, $02, $00, $03
	smpsVcAttackRate    $09, $09, $0F, $08
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $08
	smpsVcTotalLevel    $17, $11, $0C, $25

;	Voice $01
;	$02
;	$00, $05, $02, $00, 	$D3, $DF, $DF, $9F, 	$05, $0A, $06, $07
;	$00, $00, $12, $00, 	$29, $8F, $50, $09, 	$1C, $13, $27, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $02, $05, $00
	smpsVcRateScale     $02, $03, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $13
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $06, $0A, $05
	smpsVcDecayRate2    $00, $12, $00, $00
	smpsVcDecayLevel    $00, $05, $08, $02
	smpsVcReleaseRate   $09, $00, $0F, $09
	smpsVcTotalLevel    $00, $27, $13, $1C

;	Voice $02
;	$1D
;	$01, $33, $22, $00, 	$1F, $50, $14, $11, 	$0A, $0D, $01, $1B
;	$00, $0C, $00, $00, 	$9F, $3D, $1F, $2D, 	$12, $09, $09, $08
	smpsVcAlgorithm     $05
	smpsVcFeedback      $03
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $02, $03, $00
	smpsVcCoarseFreq    $00, $02, $03, $01
	smpsVcRateScale     $00, $00, $01, $00
	smpsVcAttackRate    $11, $14, $10, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1B, $01, $0D, $0A
	smpsVcDecayRate2    $00, $00, $0C, $00
	smpsVcDecayLevel    $02, $01, $03, $09
	smpsVcReleaseRate   $0D, $0F, $0D, $0F
	smpsVcTotalLevel    $08, $09, $09, $12

;	Voice $03
;	$3D
;	$00, $00, $01, $51, 	$88, $97, $8F, $99, 	$06, $07, $0D, $07
;	$01, $02, $0A, $00, 	$67, $1F, $2F, $1F, 	$1C, $0B, $0A, $17
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $05, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $00, $00
	smpsVcRateScale     $02, $02, $02, $02
	smpsVcAttackRate    $19, $0F, $17, $08
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $0D, $07, $06
	smpsVcDecayRate2    $00, $0A, $02, $01
	smpsVcDecayLevel    $01, $02, $01, $06
	smpsVcReleaseRate   $0F, $0F, $0F, $07
	smpsVcTotalLevel    $17, $0A, $0B, $1C

;	Voice $04
;	$2A
;	$10, $31, $00, $02, 	$9F, $5F, $5F, $5F, 	$19, $19, $13, $0E
;	$08, $06, $05, $11, 	$CB, $AB, $BB, $2B, 	$02, $0A, $0B, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $03, $01
	smpsVcCoarseFreq    $02, $00, $01, $00
	smpsVcRateScale     $01, $01, $01, $02
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0E, $13, $19, $19
	smpsVcDecayRate2    $11, $05, $06, $08
	smpsVcDecayLevel    $02, $0B, $0A, $0C
	smpsVcReleaseRate   $0B, $0B, $0B, $0B
	smpsVcTotalLevel    $00, $0B, $0A, $02

;	Voice $05
;	$03
;	$0F, $00, $39, $30, 	$19, $1D, $1F, $1F, 	$13, $0D, $15, $11
;	$0D, $15, $19, $1F, 	$80, $70, $D8, $BA, 	$2D, $04, $00, $00
	smpsVcAlgorithm     $03
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $00, $00
	smpsVcCoarseFreq    $00, $09, $00, $0F
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1D, $19
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $11, $15, $0D, $13
	smpsVcDecayRate2    $1F, $19, $15, $0D
	smpsVcDecayLevel    $0B, $0D, $07, $08
	smpsVcReleaseRate   $0A, $08, $00, $00
	smpsVcTotalLevel    $00, $00, $04, $2D

;	Voice $06
;	$32
;	$31, $36, $71, $02, 	$1C, $11, $0C, $8B, 	$04, $10, $0D, $0A
;	$00, $05, $03, $00, 	$46, $BB, $A4, $1C, 	$25, $20, $28, $06
	smpsVcAlgorithm     $02
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $07, $03, $03
	smpsVcCoarseFreq    $02, $01, $06, $01
	smpsVcRateScale     $02, $00, $00, $00
	smpsVcAttackRate    $0B, $0C, $11, $1C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0D, $10, $04
	smpsVcDecayRate2    $00, $03, $05, $00
	smpsVcDecayLevel    $01, $0A, $0B, $04
	smpsVcReleaseRate   $0C, $04, $0B, $06
	smpsVcTotalLevel    $06, $28, $20, $25

;	Voice $07
;	$16
;	$72, $70, $71, $01, 	$8F, $15, $9A, $89, 	$0D, $00, $14, $00
;	$0F, $00, $04, $00, 	$C8, $08, $18, $08, 	$18, $0B, $05, $11
	smpsVcAlgorithm     $06
	smpsVcFeedback      $02
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $07, $07, $07
	smpsVcCoarseFreq    $01, $01, $00, $02
	smpsVcRateScale     $02, $02, $00, $02
	smpsVcAttackRate    $09, $1A, $15, $0F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $14, $00, $0D
	smpsVcDecayRate2    $00, $04, $00, $0F
	smpsVcDecayLevel    $00, $01, $00, $0C
	smpsVcReleaseRate   $08, $08, $08, $08
	smpsVcTotalLevel    $11, $05, $0B, $18

;	Voice $08
;	$00
;	$73, $75, $33, $71, 	$53, $19, $14, $1A, 	$01, $0D, $0F, $00
;	$1B, $18, $1F, $0A, 	$40, $03, $F3, $0D, 	$1A, $21, $15, $0A
	smpsVcAlgorithm     $00
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $07, $07
	smpsVcCoarseFreq    $01, $03, $05, $03
	smpsVcRateScale     $00, $00, $00, $01
	smpsVcAttackRate    $1A, $14, $19, $13
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $0F, $0D, $01
	smpsVcDecayRate2    $0A, $1F, $18, $1B
	smpsVcDecayLevel    $00, $0F, $00, $04
	smpsVcReleaseRate   $0D, $03, $03, $00
	smpsVcTotalLevel    $0A, $15, $21, $1A

;	Voice $09
;	$24
;	$03, $02, $32, $02, 	$17, $0D, $18, $12, 	$01, $0C, $01, $0B
;	$0C, $0B, $0B, $01, 	$9F, $5F, $6C, $1F, 	$19, $0D, $15, $14
	smpsVcAlgorithm     $04
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $00, $00
	smpsVcCoarseFreq    $02, $02, $02, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $12, $18, $0D, $17
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0B, $01, $0C, $01
	smpsVcDecayRate2    $01, $0B, $0B, $0C
	smpsVcDecayLevel    $01, $06, $05, $09
	smpsVcReleaseRate   $0F, $0C, $0F, $0F
	smpsVcTotalLevel    $14, $15, $0D, $19

