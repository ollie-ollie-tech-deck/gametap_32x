holiday_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     holiday_Voices
	smpsHeaderChan      $06, $00
	smpsHeaderTempo     $02, $00

	smpsHeaderDAC       holiday_DAC
	smpsHeaderFM        holiday_FM1,	$00, $1C
	smpsHeaderFM        holiday_FM2,	$00, $1B
	smpsHeaderFM        holiday_FM3,	$00, $16
	smpsHeaderFM        holiday_FM4,	$00, $1A
	smpsHeaderFM        holiday_FM5,	$00, $16

; DAC Data
holiday_DAC:
	smpsPan             panCenter, $00
	dc.b	nRst, $7F, $7F, $04, nRst, $06, $06, $12

holiday_Loop00:
	dc.b	$12, dSnare, $0C, nRst, $06
	smpsLoop            $00, $03, holiday_Loop00
	dc.b	$06, $06, $06, dSnare, nRst, nRst, nRst, $12, dSnare, $0C, nRst, $06
	dc.b	$12, dSnare, $0C, nRst, $06, dHiTimpani, $12, dSnare, nRst, $06, $06, $06
	dc.b	$06, $06, $06

holiday_Loop01:
	dc.b	dHiTimpani, $12, dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, dHiTimpani, $0C, $06, dSnare, $0C
	dc.b	$06, dHiTimpani, $12, dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, dHiTimpani, $0C, dSnare, $06
	dc.b	dHiTimpani, $0C, dSnare, $06
	smpsLoop            $00, $02, holiday_Loop01
	dc.b	dHiTimpani, $12, dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, dHiTimpani, $0C, $06, dSnare, $12
	dc.b	dHiTimpani, dSnare, dHiTimpani, dSnare, dHiTimpani, $0C, $06, dSnare, $0C

holiday_Loop02:
	dc.b	$06
	smpsLoop            $00, $07, holiday_Loop02
	dc.b	dHiTimpani, $12, dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, dHiTimpani, $0C, $06, dSnare, $0C
	dc.b	$06, dHiTimpani, $12, dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, dHiTimpani, $0C, dSnare, $06
	dc.b	dHiTimpani, $0C, dSnare, $06, dHiTimpani, $12, dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, dHiTimpani
	dc.b	$0C, $06, dSnare, $12, dHiTimpani, dSnare, dHiTimpani, dSnare, dHiTimpani, $0C, $06, dSnare
	dc.b	$0C

holiday_Loop03:
	dc.b	$06
	smpsLoop            $00, $07, holiday_Loop03

holiday_Loop04:
	dc.b	dHiTimpani, $12, dSnare, dHiTimpani, $0C, $06, dSnare, $12
	smpsLoop            $00, $03, holiday_Loop04
	dc.b	dHiTimpani, $0C, $06, dSnare, $0C, $06, dMidTimpani, $0C, $06, dSnare, $12
	smpsLoop            $01, $02, holiday_Loop04
	dc.b	$03, $31, $02, $12, nRst, dSnare, $0C, nRst, $06, $12, dSnare, $0C
	dc.b	nRst, $06, $12, dSnare, $0C, nRst, $06, $06, $06, $06, dSnare, nRst
	dc.b	nRst, nRst, $12, dSnare, $0C, nRst, $06, $12, dSnare, $0C, nRst, $06
	dc.b	dHiTimpani, $12, dSnare, dSnare, $06, $06, $06, $06, $06, $06, dHiTimpani, $12
	dc.b	dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, $0C, $06, dHiTimpani, $0C, $06, dSnare, $0C
	dc.b	$06, dHiTimpani, $12, dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, dHiTimpani, $0C, dSnare, $06
	dc.b	dHiTimpani, $0C, dSnare, $06, dHiTimpani, $12, dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, dHiTimpani
	dc.b	$0C, $06, dSnare, $12, dHiTimpani, dSnare, dHiTimpani, dSnare, $0C, $06, dHiTimpani, $0C
	dc.b	$06, dSnare, $0C

holiday_Loop05:
	dc.b	$06
	smpsLoop            $00, $07, holiday_Loop05
	dc.b	dHiTimpani, $12, dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, $0C, $06, dHiTimpani, $0C, $06
	dc.b	dSnare, $0C, $06, dHiTimpani, $12, dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, dHiTimpani, $0C
	dc.b	dSnare, $06, dHiTimpani, $0C, dSnare, $06, dHiTimpani, $12, dSnare, dHiTimpani, dSnare, dHiTimpani
	dc.b	dSnare, dHiTimpani, $0C, $06, dSnare, $12, dHiTimpani, dSnare

holiday_Loop06:
	dc.b	dHiTimpani, $0C, $06, dSnare, $0C, $06
	smpsLoop            $00, $02, holiday_Loop06
	dc.b	dHiTimpani, $0C, $06, dSnare, dSnare, dSnare

holiday_Loop07:
	dc.b	dHiTimpani, $12, dSnare, dHiTimpani, $0C, $06, dSnare, $12
	smpsLoop            $00, $03, holiday_Loop07
	dc.b	dHiTimpani, $0C, $06, dSnare, $0C, $06, dMidTimpani, $0C, $06, dSnare, $12
	smpsLoop            $01, $02, holiday_Loop07
	dc.b	$03, $31, $02

holiday_Loop08:
	dc.b	$12, dHiTimpani, dSnare, $0C, dHiTimpani, $06, $12, dSnare, $0C, dHiTimpani, $06, $12
	dc.b	dSnare, dHiTimpani, dSnare, dHiTimpani, dSnare, $0C, dHiTimpani, $06, $12, dSnare, $0C, dHiTimpani
	dc.b	$06, $12, dSnare, dHiTimpani, $06, dSnare, dSnare
	smpsLoop            $00, $02, holiday_Loop08

holiday_Loop09:
	dc.b	dSnare, $12, dHiTimpani, dSnare, dHiTimpani, $0C, $06
	smpsLoop            $00, $07, holiday_Loop09
	dc.b	dSnare, $12, dHiTimpani, $0C, dMidTimpani, $06, dSnare, $12, dHiTimpani, $0C, $06, dSnare
	dc.b	$12, dHiTimpani, dSnare, dHiTimpani

holiday_Loop0A:
	dc.b	dSnare, dSnare, $06
	smpsLoop            $00, $06, holiday_Loop0A
	dc.b	$06

holiday_Loop0B:
	dc.b	$12, dHiTimpani
	smpsLoop            $00, $0F, holiday_Loop0B
	dc.b	dHiTimpani, dSnare, nRst

holiday_Loop0C:
	dc.b	dSnare, $0C, nRst, $06, $12, dSnare, $0C, nRst, $06, $12, dSnare, $0C
	dc.b	nRst, $06, $06, $06, $06, dSnare, $0C, nRst, $06, $12
	smpsLoop            $00, $05, holiday_Loop0C
	dc.b	dSnare, $0C, nRst, $06, $12, dSnare, $0C, nRst, $06, dHiTimpani, $12, dSnare
	dc.b	dHiTimpani, dSnare, nRst, dSnare, $0C, nRst, $06, $12, dSnare, $0C, nRst, $06
	dc.b	$12, dSnare, $0C, nRst, $06, $06, $06, $06, dSnare, nRst, nRst, nRst
	dc.b	$12, dSnare, $0C, nRst, $06, $12, dSnare, $0C, nRst, $06, dHiTimpani, $12
	dc.b	dSnare, dHiTimpani, dSnare

holiday_Loop0D:
	dc.b	$0C, nRst, $06
	smpsLoop            $00, $0A, holiday_Loop0D
	dc.b	dSnare, $0C, nRst, $06, $0C, $06, dSnare, $12

holiday_Loop0E:
	dc.b	$06
	smpsLoop            $00, $0C, holiday_Loop0E

holiday_Loop0F:
	dc.b	dHiTimpani, $12, dSnare, dHiTimpani, $0C, $06, dSnare, $12
	smpsLoop            $00, $03, holiday_Loop0F

holiday_Loop10:
	dc.b	dHiTimpani, $0C, $06, dSnare, $0C, $06
	smpsLoop            $00, $02, holiday_Loop10
	smpsLoop            $01, $04, holiday_Loop0F

holiday_Loop11:
	dc.b	dHiTimpani, $0C, $06, dSnare, $0C, $06
	smpsLoop            $00, $04, holiday_Loop11

holiday_Loop12:
	dc.b	$06
	smpsLoop            $00, $0C, holiday_Loop12

holiday_Loop13:
	dc.b	dHiTimpani, $12, dSnare, $0C, $06
	smpsLoop            $00, $03, holiday_Loop13
	dc.b	dHiTimpani, $0C, $06, dSnare, $0C, $06
	smpsLoop            $01, $03, holiday_Loop13
	dc.b	dHiTimpani, $12, dSnare, $0C, $06, dHiTimpani, $12, dSnare, dHiTimpani, dHiTimpani, dHiTimpani, nRst
	dc.b	$06, $06, $7F, nRst, $17
	smpsStop

; FM1 Data
holiday_FM1:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nC4, $12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $FC
	dc.b	nEb4, $12
	smpsAlterVol        $03
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nBb3, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nC4, $12, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $FD
	dc.b	nEb4, $12
	smpsAlterVol        $03
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $03
	dc.b	nBb3, $24
	smpsAlterVol        $FD
	dc.b	nC4, $12
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $02
	dc.b	nAb3, $12
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $FB
	dc.b	nEb4, $12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nBb3, $0C
	smpsAlterVol        $FD
	dc.b	$06, $0C, $06, nC4, $12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $03
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nEb4, $12
	smpsAlterVol        $03
	dc.b	$0C, $06
	smpsAlterVol        $06
	dc.b	$06
	smpsAlterVol        $FB
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$06, $06
	smpsAlterVol        $FF
	dc.b	nF4, $12, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nCs4, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FC
	dc.b	nEb4, $0C
	smpsAlterVol        $04
	dc.b	$06, $0C, $06
	smpsAlterVol        $FF
	dc.b	nF4, $12
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $03
	dc.b	nCs4, $12
	smpsAlterVol        $FD
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FC
	dc.b	nEb4, $0C
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C, $06, nF4, $12, $0C, $06
	smpsAlterVol        $02
	dc.b	nCs4, $12
	smpsAlterVol        $FD
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $FC
	dc.b	nEb4, $0C
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $FE
	dc.b	nF4, $12
	smpsAlterVol        $02
	dc.b	$0C, $06
	smpsAlterVol        $03
	dc.b	nCs4, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06, nAb3, $12, $0C, $06
	smpsAlterVol        $FD
	dc.b	nC4, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $03
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nF4, $12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $03
	dc.b	nCs4, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nEb4, $0C
	smpsAlterVol        $03
	dc.b	$06, $0C, $06
	smpsAlterVol        $04
	dc.b	nC4, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12, $12
	smpsAlterVol        $01
	dc.b	$12, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FD
	dc.b	nF4
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nCs4, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $FC
	dc.b	nEb4, $0C
	smpsAlterVol        $04
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nF4, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nCs4, $12, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $FD
	dc.b	nC4, $0C, $06
	smpsAlterVol        $03
	dc.b	$0C, $06
	smpsAlterVol        $FD
	dc.b	nF4, $12
	smpsAlterVol        $03
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06, nCs4, $12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $FB
	dc.b	nEb4, $0C
	smpsAlterVol        $04
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nC4, $12
	smpsAlterVol        $FD
	dc.b	$12, $12, $12, $12
	smpsAlterVol        $FF
	dc.b	$12, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FC
	dc.b	nF4, $12
	smpsAlterVol        $04
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nCs4, $12, $12
	smpsAlterVol        $FD
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06, $0C, $06
	smpsAlterVol        $01
	dc.b	nAb3, $12, $12
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $FD
	dc.b	nEb4, $12
	smpsAlterVol        $04
	dc.b	$12, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06, nF4, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06, $0C, $06
	smpsAlterVol        $03
	dc.b	nCs4, $12
	smpsAlterVol        $FC
	dc.b	$12, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FF
	dc.b	$12, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nC4, $12
	smpsAlterVol        $03
	dc.b	$12, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $F8
	dc.b	$09, nRst, $3F
	smpsAlterVol        $09
	dc.b	nC4, $12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $04
	dc.b	nAb3, $12
	smpsAlterVol        $FD
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nEb4, $12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nBb3, $0C
	smpsAlterVol        $FF
	dc.b	$06, $0C, $06
	smpsAlterVol        $FE
	dc.b	nC4, $12
	smpsAlterVol        $03
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FA
	dc.b	nEb4, $12
	smpsAlterVol        $04
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $06
	dc.b	$06
	smpsAlterVol        $FA
	dc.b	$06, $06, $06
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nF4, $12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nCs4, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nAb3, $12, $0C, $06
	smpsAlterVol        $FB
	dc.b	nEb4, $0C
	smpsAlterVol        $04
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $FE
	dc.b	nF4, $12
	smpsAlterVol        $02
	dc.b	$0C, $06
	smpsAlterVol        $02
	dc.b	nCs4, $12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06, nAb3, $12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nC4, $0C
	smpsAlterVol        $03
	dc.b	$06, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nF4, $12
	smpsAlterVol        $04
	dc.b	$0C, $06
	smpsAlterVol        $04
	dc.b	nCs4, $12
	smpsAlterVol        $FC
	dc.b	$0C, $06
	smpsAlterVol        $02
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nEb4, $0C
	smpsAlterVol        $04
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06

holiday_Loop1D:
	smpsAlterVol        $01
	dc.b	nC4, $12
	smpsAlterVol        $FF
	dc.b	$12, $12
	smpsLoop            $00, $02, holiday_Loop1D
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FB
	dc.b	nF4, $12
	smpsAlterVol        $03
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $04
	dc.b	nCs4, $12
	smpsAlterVol        $FC
	dc.b	$0C, $06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FA
	dc.b	nEb4, $0C
	smpsAlterVol        $05
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nF4, $12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nCs4, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $FE
	dc.b	nC4, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nF4, $12
	smpsAlterVol        $04
	dc.b	$0C, $06
	smpsAlterVol        $02
	dc.b	nCs4, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FC
	dc.b	nEb4, $0C
	smpsAlterVol        $04
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $02
	dc.b	nC4, $12, $12
	smpsAlterVol        $FE
	dc.b	$12, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06, nF4, $12
	smpsAlterVol        $02
	dc.b	$12, $0C, $06, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $05
	dc.b	nCs4, $12
	smpsAlterVol        $FD
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nAb3, $12, $12, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nEb4, $12
	smpsAlterVol        $04
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $FD
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nF4, $12, $12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nCs4, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06, nAb3, $12
	smpsAlterVol        $FF
	dc.b	$12, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C, $06
	smpsAlterVol        $FD
	dc.b	nC4, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C, $06, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FB
	dc.b	$09, nRst, $3F
	smpsAlterVol        $0A
	dc.b	nF3, $12
	smpsAlterVol        $FD
	dc.b	$0C
	smpsAlterVol        $FD
	dc.b	nG3, $06
	smpsAlterVol        $02
	dc.b	nAb3, $12, $0C, $06
	smpsAlterVol        $FE
	dc.b	nCs4, $12
	smpsAlterVol        $03
	dc.b	nBb3
	smpsAlterVol        $FD
	dc.b	nEb4
	smpsAlterVol        $04
	dc.b	nC4
	smpsAlterVol        $FF
	dc.b	nF3
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	nG3, $06, nAb3, $12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nEb4, $12
	smpsAlterVol        $07
	dc.b	nC4
	smpsAlterVol        $FA
	dc.b	nF4, nRst
	smpsAlterVol        $05
	dc.b	nF3, nF3, $0C
	smpsAlterVol        $FE
	dc.b	nG3, $06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $FC
	dc.b	nCs4, $12
	smpsAlterVol        $03
	dc.b	nBb3
	smpsAlterVol        $FC
	dc.b	nEb4
	smpsAlterVol        $04
	dc.b	nC4
	smpsAlterVol        $02
	dc.b	nF3
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FD
	dc.b	nG3, $06
	smpsAlterVol        $02
	dc.b	nAb3, $12, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FC
	dc.b	nEb4, $12
	smpsAlterVol        $04
	dc.b	nC4
	smpsAlterVol        $FD
	dc.b	nF4, nRst
	smpsAlterVol        $05
	dc.b	nCs4
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nAb3, nAb3
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	nC4
	smpsAlterVol        $03
	dc.b	$12, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	nF4, nF4
	smpsAlterVol        $05
	dc.b	nEb4
	smpsAlterVol        $FD
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nCs4
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $04
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nAb3, nAb3, nAb3, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	nC4
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$12, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12, $0C
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06, nRst

holiday_Loop1E:
	dc.b	$5C
	smpsLoop            $00, $12, holiday_Loop1E
	smpsAlterVol        $01
	dc.b	nEb4, $12, nC4
	smpsAlterVol        $FD
	dc.b	nF4, nRst
	smpsAlterVol        $06
	dc.b	nC4, $7F, smpsNoAttack, $0B
	smpsAlterVol        $FD
	dc.b	nBb3, $06
	smpsAlterVol        $FF
	dc.b	nC4, $7F, smpsNoAttack, $11
	smpsAlterVol        $FC
	dc.b	nF4, $12
	smpsAlterVol        $04
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06, $0C, $06
	smpsAlterVol        $03
	dc.b	nCs4, $12
	smpsAlterVol        $FD
	dc.b	$12, $0C, $06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$12, $0C, $06, $0C, $06
	smpsAlterVol        $FB
	dc.b	nEb4, $12
	smpsAlterVol        $03
	dc.b	$12, $0C
	smpsAlterVol        $02
	dc.b	$06, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nF4, $12
	smpsAlterVol        $04
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $03
	dc.b	nCs4, $12
	smpsAlterVol        $FC
	dc.b	$12, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$12, $0C, $06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nC4, $12
	smpsAlterVol        $02
	dc.b	$12, $0C
	smpsAlterVol        $01
	dc.b	$06, $0C, $06
	smpsAlterVol        $FD
	dc.b	nF4, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nCs4, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $01
	dc.b	nAb3, $12, $12
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FB
	dc.b	nEb4, $12
	smpsAlterVol        $04
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C, $06, $0C, $06
	smpsAlterVol        $FF
	dc.b	nF4, $12
	smpsAlterVol        $01
	dc.b	$12, $0C, $06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nCs4, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06, $0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nAb3, $12, $12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $FE
	dc.b	nC4, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12, $12, $12, $12, $12, $12
	smpsAlterVol        $FF
	dc.b	$12, $12
	smpsAlterVol        $01
	dc.b	$12, $12, $12, $12
	smpsAlterVol        $FF
	dc.b	$12, $12
	smpsAlterVol        $FD
	dc.b	nF4
	smpsAlterVol        $04
	dc.b	$0C, $06
	smpsAlterVol        $02
	dc.b	nCs4, $12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $FC
	dc.b	nEb4, $0C
	smpsAlterVol        $05
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nF4, $12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $03
	dc.b	nCs4, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $FC
	dc.b	nEb4, $0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nF4, $12, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nCs4, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nAb3, $12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $FD
	dc.b	nEb4, $0C
	smpsAlterVol        $04
	dc.b	$06, $0C, $06
	smpsAlterVol        $FF
	dc.b	nF4, $12
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $02
	dc.b	nCs4, $12
	smpsAlterVol        $FD
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nEb4, $12
	smpsAlterVol        $03
	dc.b	nC4
	smpsAlterVol        $FB
	dc.b	nF4
	smpsAlterVol        $05
	dc.b	nF3
	smpsStop

; FM2 Data
holiday_FM2:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nRst

holiday_Loop1C:
	dc.b	$6F
	smpsLoop            $00, $30, holiday_Loop1C
	dc.b	nF4, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nG4, $0C
	smpsAlterVol        $01
	dc.b	nAb4, $12
	smpsAlterVol        $04
	dc.b	nEb4
	smpsAlterVol        $FE
	dc.b	nCs4
	smpsAlterVol        $01
	dc.b	nC4, $18
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nG4, $12
	smpsAlterVol        $05
	dc.b	nE4
	smpsAlterVol        $01
	dc.b	nC4, $24
	smpsAlterVol        $FB
	dc.b	nF4, $12, nC5
	smpsAlterVol        $06
	dc.b	nF4
	smpsAlterVol        $F9
	dc.b	nC5, $0C
	smpsAlterVol        $08
	dc.b	nF4, $06
	smpsAlterVol        $FD
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$0C, $06
	smpsAlterVol        $FE
	dc.b	nG4, $0C, nAb4, $12
	smpsAlterVol        $06
	dc.b	nEb4
	smpsAlterVol        $FF
	dc.b	nCs4, nC4, $18
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nG4, $12
	smpsAlterVol        $03
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FC
	dc.b	nC5
	smpsAlterVol        $04
	dc.b	$12, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FC
	dc.b	nE5
	smpsAlterVol        $03
	dc.b	$12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12, $12
	smpsAlterVol        $FD
	dc.b	nF5, $7F, smpsNoAttack, $7F, smpsNoAttack, $6A
	smpsStop

; FM3 Data
holiday_FM3:
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nRst

holiday_Loop1A:
	dc.b	$7E
	smpsLoop            $00, $07, holiday_Loop1A
	dc.b	nF4, $0C
	smpsAlterVol        $FE
	dc.b	$06, $12, $0C, $06
	smpsAlterVol        $03
	dc.b	nEb4, $12
	smpsAlterVol        $FC
	dc.b	nF4
	smpsAlterVol        $01
	dc.b	nEb4, $24, nRst, $12
	smpsAlterVol        $03
	dc.b	nC4, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nCs4, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nC4, $12, $12, nBb3
	smpsAlterVol        $FD
	dc.b	nC4
	smpsAlterVol        $04
	dc.b	nF3, nRst, $0C
	smpsAlterVol        $FF
	dc.b	nC4, $06
	smpsAlterVol        $FD
	dc.b	nCs4, $1E
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nC4, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nBb3
	smpsAlterVol        $FF
	dc.b	nAb3
	smpsAlterVol        $FD
	dc.b	nC4, nEb4, $0C
	smpsAlterVol        $03
	dc.b	nC4, $4E, nRst, $36, nF4, $0C, $06
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nEb4, $12, nF4
	smpsAlterVol        $02
	dc.b	nEb4, $24, nRst, $12
	smpsAlterVol        $01
	dc.b	nC4, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nCs4, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nC4, nC4, nBb3
	smpsAlterVol        $FD
	dc.b	nC4
	smpsAlterVol        $02
	dc.b	nF3, $1E
	smpsAlterVol        $FD
	dc.b	nC4, $06
	smpsAlterVol        $02
	dc.b	nCs4, $1E
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nC4, $0C
	smpsAlterVol        $FF
	dc.b	$06, $12, nBb3
	smpsAlterVol        $04
	dc.b	nAb3
	smpsAlterVol        $F9
	dc.b	nC4
	smpsAlterVol        $01
	dc.b	nEb4, $0C
	smpsAlterVol        $04
	dc.b	nC4, $4E, nRst, $36
	smpsAlterVol        $FF
	dc.b	nF4, $12, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	nEb4, $12
	smpsAlterVol        $FE
	dc.b	nCs4, nEb4, $18
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nCs4, $0C
	smpsAlterVol        $FE
	dc.b	nC4, $12, nBb3, $2A, nRst, $36
	smpsAlterVol        $01
	dc.b	nF4, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C, $12, nEb4
	smpsAlterVol        $02
	dc.b	nCs4
	smpsAlterVol        $FE
	dc.b	nEb4, $18
	smpsAlterVol        $FE
	dc.b	$12, nRst
	smpsAlterVol        $03
	dc.b	nC4, $0C
	smpsAlterVol        $FB
	dc.b	nEb4, $12
	smpsAlterVol        $02
	dc.b	nE4, $4E, nRst, $12
	smpsAlterVol        $04
	dc.b	nC4
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $FD
	dc.b	nEb4, $0C
	smpsAlterVol        $01
	dc.b	nF4, $4E, nRst, $7F, $6B
	smpsAlterVol        $04
	dc.b	nF4, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$12, $0C, $06
	smpsAlterVol        $01
	dc.b	nEb4, $12
	smpsAlterVol        $FD
	dc.b	nF4
	smpsAlterVol        $04
	dc.b	nEb4, $24, nRst, $0C, nC4, $06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nCs4, $12, $12
	smpsAlterVol        $02
	dc.b	nC4
	smpsAlterVol        $FF
	dc.b	$12, nBb3
	smpsAlterVol        $FE
	dc.b	nC4
	smpsAlterVol        $04
	dc.b	nF3, $1E
	smpsAlterVol        $FA
	dc.b	nC4, $06
	smpsAlterVol        $02
	dc.b	nCs4, $1E
	smpsAlterVol        $02
	dc.b	$06, nC4, $12
	smpsAlterVol        $01
	dc.b	$12, nBb3, nAb3
	smpsAlterVol        $FD
	dc.b	nC4, nEb4, $0C
	smpsAlterVol        $02
	dc.b	nC4, $72, nRst, $12
	smpsAlterVol        $03
	dc.b	nF4, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$12, $12, nEb4, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nF4, $12
	smpsAlterVol        $02
	dc.b	nEb4, $24, nRst, $12
	smpsAlterVol        $04
	dc.b	nC4, $0C
	smpsAlterVol        $FB
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nCs4, $12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nC4, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nBb3
	smpsAlterVol        $FD
	dc.b	nC4
	smpsAlterVol        $04
	dc.b	nF3, nRst, $0C, nC4, $06
	smpsAlterVol        $FC
	dc.b	nCs4, $1E
	smpsAlterVol        $02
	dc.b	$06, nC4, $12
	smpsAlterVol        $01
	dc.b	$12, nBb3
	smpsAlterVol        $02
	dc.b	nAb3, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nC4, $12
	smpsAlterVol        $01
	dc.b	nEb4, $0C
	smpsAlterVol        $02
	dc.b	nC4, $72, nRst, $12
	smpsAlterVol        $01
	dc.b	nF4
	smpsAlterVol        $FD
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	nEb4, $12, nCs4
	smpsAlterVol        $FE
	dc.b	nEb4, $18, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nCs4, $0C, nC4, $12, nBb3, $2A, nRst, $36, nF4, $12, $12, $0C
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nEb4
	smpsAlterVol        $FF
	dc.b	nCs4
	smpsAlterVol        $FE
	dc.b	nEb4, $18
	smpsAlterVol        $02
	dc.b	$12, nRst
	smpsAlterVol        $01
	dc.b	nC4, $0C
	smpsAlterVol        $FC
	dc.b	nEb4, $12, nE4, $4E, nRst, $12
	smpsAlterVol        $06
	dc.b	nC4
	smpsAlterVol        $FC
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	nEb4, $0C, nF4, $2A, nRst

holiday_Loop1B:
	dc.b	$5B
	smpsLoop            $00, $21, holiday_Loop1B
	dc.b	$03
	smpsAlterVol        $04
	dc.b	nE4, $12
	smpsAlterVol        $FF
	dc.b	$48, nRst, $36
	smpsAlterVol        $02
	dc.b	nE4, $12
	smpsAlterVol        $FD
	dc.b	$12, $12
	smpsAlterVol        $FF
	dc.b	nF4, $0C
	smpsAlterVol        $02
	dc.b	nE4, $12, nD4
	smpsAlterVol        $FD
	dc.b	nE4
	smpsAlterVol        $02
	dc.b	nF4, $06, nRst, $12
	smpsAlterVol        $03
	dc.b	nF4
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	nEb4, $12, nCs4
	smpsAlterVol        $FE
	dc.b	nEb4, $18
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nCs4, $0C
	smpsAlterVol        $FF
	dc.b	nC4, $12, nBb3, $2A, nRst, $36
	smpsAlterVol        $02
	dc.b	nF4, $12
	smpsAlterVol        $FD
	dc.b	$12, $0C
	smpsAlterVol        $01
	dc.b	$12, nEb4
	smpsAlterVol        $01
	dc.b	nCs4
	smpsAlterVol        $FC
	dc.b	nEb4, $18
	smpsAlterVol        $02
	dc.b	$12, nRst
	smpsAlterVol        $04
	dc.b	nC4, $0C
	smpsAlterVol        $F9
	dc.b	nEb4, $12
	smpsAlterVol        $03
	dc.b	nE4, $4E, nRst, $12
	smpsAlterVol        $03
	dc.b	nF4
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FC
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	nEb4, $12
	smpsAlterVol        $03
	dc.b	nCs4
	smpsAlterVol        $FC
	dc.b	nEb4, $18
	smpsAlterVol        $03
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nCs4, $0C, nC4, $12, nBb3, $2A, nRst, $36
	smpsAlterVol        $FF
	dc.b	nF4, $12, $12, $0C, $12, nEb4, nCs4
	smpsAlterVol        $FD
	dc.b	nEb4, $18
	smpsAlterVol        $01
	dc.b	$12, nRst
	smpsAlterVol        $02
	dc.b	nC4, $0C
	smpsAlterVol        $FE
	dc.b	nEb4, $12, nE4, $4E
	smpsAlterVol        $03
	dc.b	nC4, $48, nRst, $12
	smpsAlterVol        $FF
	dc.b	nE4
	smpsAlterVol        $FF
	dc.b	$12, $0C
	smpsAlterVol        $FE
	dc.b	nF4, $18
	smpsAlterVol        $03
	dc.b	nE4, $12
	smpsAlterVol        $01
	dc.b	nD4, $0C
	smpsAlterVol        $FD
	dc.b	nE4, $12
	smpsAlterVol        $FF
	dc.b	nF4, $36
	smpsStop

; FM4 Data
holiday_FM4:
	smpsPan             panCenter, $00
	smpsSetvoice        $02
	dc.b	nRst

holiday_Loop17:
	dc.b	$7E
	smpsLoop            $00, $07, holiday_Loop17
	dc.b	nF4, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C, $06, nEb4, $12, nF4
	smpsAlterVol        $01
	dc.b	nEb4, $24, nRst, $7F, $23
	smpsAlterVol        $01
	dc.b	nAb4, $12, nRst, $7F, $7F, $10, nF4, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$12, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nEb4, $12
	smpsAlterVol        $FE
	dc.b	nF4
	smpsAlterVol        $01
	dc.b	nEb4, $24, nRst, $7F, $23
	smpsAlterVol        $03
	dc.b	nAb4, $12, nRst, $7F, $7D, nF4, $48
	smpsAlterVol        $FF
	dc.b	nCs4
	smpsAlterVol        $F9
	dc.b	nAb4, $12
	smpsAlterVol        $04
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	nG4, $2A, nRst, $24, nF4, $48
	smpsAlterVol        $03
	dc.b	nCs4, $24, nRst, $0C
	smpsAlterVol        $FF
	dc.b	nAb4, $18
	smpsAlterVol        $FE
	dc.b	$12, nRst
	smpsAlterVol        $01
	dc.b	nF4, $0C
	smpsAlterVol        $FD
	dc.b	nAb4, $12
	smpsAlterVol        $03
	dc.b	nG4, $4E, nRst

holiday_Loop18:
	dc.b	$76
	smpsLoop            $00, $09, holiday_Loop18
	smpsAlterVol        $01
	dc.b	nAb4, $12
	smpsAlterVol        $FE
	dc.b	$12, nRst, $7F, $11
	smpsAlterVol        $04
	dc.b	nAb4, $12, nRst, $7F, $7D
	smpsAlterVol        $FE
	dc.b	nF4, $48
	smpsAlterVol        $01
	dc.b	nCs4
	smpsAlterVol        $F9
	dc.b	nAb4, $12
	smpsAlterVol        $03
	dc.b	$12
	smpsAlterVol        $02
	dc.b	$0C, $12
	smpsAlterVol        $01
	dc.b	nG4, $2A, nRst, $24
	smpsAlterVol        $FF
	dc.b	nF4, $48
	smpsAlterVol        $02
	dc.b	nCs4, $24, nRst, $0C, nAb4, $18
	smpsAlterVol        $FC
	dc.b	$12, nRst
	smpsAlterVol        $01
	dc.b	nF4, $0C
	smpsAlterVol        $FF
	dc.b	nAb4, $12
	smpsAlterVol        $02
	dc.b	nG4, $4E, nRst, $7F, $7F, $58
	smpsAlterVol        $01
	dc.b	nAb4, $12, nRst, $7F, $7F, $7F, $7B
	smpsAlterVol        $01
	dc.b	nF4, $24, nEb4
	smpsAlterVol        $FE
	dc.b	nCs4, $48
	smpsAlterVol        $02
	dc.b	nAb3
	smpsAlterVol        $F8
	dc.b	nG4
	smpsAlterVol        $03
	dc.b	$48
	smpsAlterVol        $02
	dc.b	$48, $48, nRst

holiday_Loop19:
	dc.b	$7E
	smpsLoop            $00, $10, holiday_Loop19
	smpsAlterVol        $03
	dc.b	nF4, $48, nCs4
	smpsAlterVol        $F8
	dc.b	nAb4, $12
	smpsAlterVol        $04
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$12, nG4, $2A, nRst, $24
	smpsAlterVol        $03
	dc.b	nF4, $48
	smpsAlterVol        $01
	dc.b	nCs4, $24, nRst, $0C
	smpsAlterVol        $FE
	dc.b	nAb4, $18
	smpsAlterVol        $FE
	dc.b	$12, nRst
	smpsAlterVol        $01
	dc.b	nF4, $0C
	smpsAlterVol        $FE
	dc.b	nAb4, $12
	smpsAlterVol        $03
	dc.b	nG4, $4E
	smpsAlterVol        $FF
	dc.b	nF4, $48
	smpsAlterVol        $01
	dc.b	nCs4
	smpsAlterVol        $FB
	dc.b	nAb4, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $03
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nG4, $2A, nRst, $24
	smpsAlterVol        $02
	dc.b	nF4, $48
	smpsAlterVol        $01
	dc.b	nCs4, $24, nRst, $0C
	smpsAlterVol        $FE
	dc.b	nAb4, $18
	smpsAlterVol        $FE
	dc.b	$12, nRst
	smpsAlterVol        $02
	dc.b	nF4, $0C
	smpsAlterVol        $FE
	dc.b	nAb4, $12
	smpsAlterVol        $01
	dc.b	nG4, $4E
	smpsStop

; FM5 Data
holiday_FM5:
	smpsPan             panCenter, $00
	smpsSetvoice        $03
	dc.b	nRst, $60, $60, $60, $60, $60, $60, nF3, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nCs3
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nAb2, nAb2
	smpsAlterVol        $FF
	dc.b	nEb3, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nF3, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nCs3
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nAb2
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	nEb3, $0C
	smpsAlterVol        $03
	dc.b	$06, $0C, $06
	smpsAlterVol        $FE
	dc.b	nF3, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	nCs3, nCs3, nAb2, nAb2
	smpsAlterVol        $FE
	dc.b	nEb3, $0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nF3, $12, $12
	smpsAlterVol        $01
	dc.b	nCs3, nCs3, nAb2, nAb2
	smpsAlterVol        $FE
	dc.b	nC3, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nF3, $12
	smpsAlterVol        $03
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nCs3
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nAb2
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	nEb3, $0C, $06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nC3, $12, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nF3
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	nCs3, nCs3
	smpsAlterVol        $04
	dc.b	nAb2
	smpsAlterVol        $FB
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	nEb3, $0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06, nF3, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $03
	dc.b	nCs3
	smpsAlterVol        $FC
	dc.b	$12, nAb2, nAb2
	smpsAlterVol        $FF
	dc.b	nC3, $0C
	smpsAlterVol        $01
	dc.b	$06, $0C, $06
	smpsAlterVol        $FE
	dc.b	nF3, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nCs3
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nAb2, nAb2
	smpsAlterVol        $FE
	dc.b	nEb3, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $FF
	dc.b	nC3, $12, $12, $12, $12, $12, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $04
	dc.b	nF2
	smpsAlterVol        $FC
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FC
	dc.b	nCs3, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C, $06
	smpsAlterVol        $01
	dc.b	nAb2, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06, $0C, $06
	smpsAlterVol        $FD
	dc.b	nEb3, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $04
	dc.b	nF2, $12
	smpsAlterVol        $FD
	dc.b	$12

holiday_Loop14:
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsLoop            $00, $02, holiday_Loop14
	smpsAlterVol        $FF
	dc.b	nCs3, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C, $06, $0C, $06
	smpsAlterVol        $01
	dc.b	nAb2, $12
	smpsAlterVol        $FE
	dc.b	$12, $0C
	smpsAlterVol        $01
	dc.b	$06, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nC3, $12, $12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FC
	dc.b	$09, nRst, $7F, $7F, $61
	smpsAlterVol        $08
	dc.b	nF3, $12
	smpsAlterVol        $FF
	dc.b	$12, nCs3, nCs3, nAb2
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FD
	dc.b	nEb3, $0C
	smpsAlterVol        $03
	dc.b	$06, $0C, $06
	smpsAlterVol        $FF
	dc.b	nF3, $12
	smpsAlterVol        $02
	dc.b	$12, nCs3
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $03
	dc.b	nAb2
	smpsAlterVol        $FE
	dc.b	$12, nC3, $0C, $06, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nF3, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nCs3
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nAb2, nAb2
	smpsAlterVol        $FD
	dc.b	nEb3, $0C
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06, nC3, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12, $12
	smpsAlterVol        $03
	dc.b	nF3
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nCs3
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	nAb2
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	nEb3, $0C
	smpsAlterVol        $01
	dc.b	$06, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nF3, $12, $12
	smpsAlterVol        $01
	dc.b	nCs3
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	nAb2
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	nC3, $0C
	smpsAlterVol        $01
	dc.b	$06, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nF3, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nCs3
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nAb2
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	nEb3, $0C
	smpsAlterVol        $01
	dc.b	$06, $0C, $06
	smpsAlterVol        $02
	dc.b	nC3, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12, $12, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nF2
	smpsAlterVol        $FE
	dc.b	$12, $0C, $06
	smpsAlterVol        $02
	dc.b	$0C, $06
	smpsAlterVol        $FF
	dc.b	nCs3, $12, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $02
	dc.b	nAb2, $12
	smpsAlterVol        $FE
	dc.b	$12, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06, nEb3, $12
	smpsAlterVol        $01
	dc.b	$12, $0C, $06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $03
	dc.b	nF2, $12
	smpsAlterVol        $FD
	dc.b	$12, $0C, $06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $FC
	dc.b	nCs3, $12
	smpsAlterVol        $02
	dc.b	$12, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nAb2, $12
	smpsAlterVol        $FE
	dc.b	$12, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nC3, $12
	smpsAlterVol        $02
	dc.b	$12

holiday_Loop15:
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsLoop            $00, $02, holiday_Loop15
	smpsAlterVol        $FA
	dc.b	$09, nRst, $3F
	smpsAlterVol        $08
	dc.b	nF2, $12
	smpsAlterVol        $FE
	dc.b	$0C, nG2, $06, nAb2, $12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06, nCs3, $12
	smpsAlterVol        $01
	dc.b	nBb2
	smpsAlterVol        $FF
	dc.b	nEb3
	smpsAlterVol        $01
	dc.b	nC3, nF2
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	nG2, $06, nAb2, $12, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nEb3, $12
	smpsAlterVol        $03
	dc.b	nC3
	smpsAlterVol        $FD
	dc.b	nF3, nRst
	smpsAlterVol        $04
	dc.b	nF2
	smpsAlterVol        $FF
	dc.b	$0C, nG2, $06
	smpsAlterVol        $FE
	dc.b	nAb2, $12, $0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nCs3, $12
	smpsAlterVol        $02
	dc.b	nBb2
	smpsAlterVol        $FD
	dc.b	nEb3
	smpsAlterVol        $02
	dc.b	nC3
	smpsAlterVol        $02
	dc.b	nF2
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	nG2, $06
	smpsAlterVol        $01
	dc.b	nAb2, $12, $0C, $06
	smpsAlterVol        $FE
	dc.b	nEb3, $12
	smpsAlterVol        $03
	dc.b	nC3
	smpsAlterVol        $FE
	dc.b	nF3
	smpsAlterVol        $02
	dc.b	$01, nE3, nD3
	smpsAlterVol        $01
	dc.b	nCs3, nC3, nBb2, nA2
	smpsAlterVol        $01
	dc.b	nAb2, nFs2
	smpsAlterVol        $01
	dc.b	nF2, $09
	smpsAlterVol        $FB
	dc.b	nCs3, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06, $12
	smpsAlterVol        $02
	dc.b	nAb2
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FD
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	nC3
	smpsAlterVol        $02
	dc.b	$12, $0C, $06
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	nF3
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nEb3, nEb3
	smpsAlterVol        $FF
	dc.b	nCs3, nCs3, nCs3, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $03
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	nAb2, nAb2
	smpsAlterVol        $FD
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	nC3
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $03
	dc.b	$0C, $06
	smpsAlterVol        $FE
	dc.b	$12, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$12, $06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06, $0C, $06
	smpsAlterVol        $02
	dc.b	nF2, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	nG2, $06
	smpsAlterVol        $01
	dc.b	nAb2, $12, $0C, $06
	smpsAlterVol        $FD
	dc.b	nCs3, $12
	smpsAlterVol        $05
	dc.b	nBb2
	smpsAlterVol        $FD
	dc.b	nEb3
	smpsAlterVol        $02
	dc.b	nC3, nF2, nF2, $0C
	smpsAlterVol        $FE
	dc.b	nG2, $06
	smpsAlterVol        $01
	dc.b	nAb2, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FC
	dc.b	nEb3, $12
	smpsAlterVol        $04
	dc.b	nC3
	smpsAlterVol        $FD
	dc.b	nF3
	smpsAlterVol        $03
	dc.b	$02, nE3, $01, nEb3, $02, nD3, $01, nCs3, $02
	smpsAlterVol        $01
	dc.b	nC3, $01, nB2, $02
	smpsAlterVol        $01
	dc.b	nBb2, $01, nA2, $02
	smpsAlterVol        $01
	dc.b	nAb2, $01, nG2, $02, nFs2, $01
	smpsAlterVol        $01
	dc.b	nF2, $12
	smpsAlterVol        $FC
	dc.b	$0C
	smpsAlterVol        $FD
	dc.b	nG2, $06
	smpsAlterVol        $02
	dc.b	nAb2, $12, $0C
	smpsAlterVol        $FF
	dc.b	$06, nCs3, $12
	smpsAlterVol        $01
	dc.b	nBb2
	smpsAlterVol        $FF
	dc.b	nEb3
	smpsAlterVol        $02
	dc.b	nC3
	smpsAlterVol        $01
	dc.b	nF2
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	nG2, $06
	smpsAlterVol        $01
	dc.b	nAb2, $12, $0C, $06
	smpsAlterVol        $FE
	dc.b	nEb3, $12
	smpsAlterVol        $02
	dc.b	nC3
	smpsAlterVol        $FE
	dc.b	nF3
	smpsAlterVol        $01
	dc.b	$02, nE3, $01, nEb3, $02
	smpsAlterVol        $01
	dc.b	nD3, $01, nCs3, $02, nC3, $01
	smpsAlterVol        $01
	dc.b	nB2, $02, nBb2, $01, nA2, $02
	smpsAlterVol        $01
	dc.b	nAb2, $01, nG2, $02
	smpsAlterVol        $01
	dc.b	nFs2, $01
	smpsAlterVol        $01
	dc.b	nF2, $12
	smpsAlterVol        $FC
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	nG2, $06, nAb2, $12, $0C
	smpsAlterVol        $01
	dc.b	$06, nCs3, $12
	smpsAlterVol        $02
	dc.b	nBb2
	smpsAlterVol        $FD
	dc.b	nEb3
	smpsAlterVol        $02
	dc.b	nC3
	smpsAlterVol        $03
	dc.b	nF2
	smpsAlterVol        $FC
	dc.b	$0C, nG2, $06
	smpsAlterVol        $FE
	dc.b	nAb2, $12
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $FF
	dc.b	nEb3, $12
	smpsAlterVol        $03
	dc.b	nC3
	smpsAlterVol        $FE
	dc.b	nF3, nF3, $02, nE3, $01, nEb3, $02
	smpsAlterVol        $01
	dc.b	nD3, $01, nCs3, $02, nC3, $01, nB2, $02
	smpsAlterVol        $01
	dc.b	nBb2, $01, nA2, $02, nAb2, $01, nG2, $02, nFs2, $01
	smpsAlterVol        $01
	dc.b	nF2, $12
	smpsAlterVol        $FD
	dc.b	$0C, nG2, $06, nAb2, $12, $0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nCs3, $12
	smpsAlterVol        $03
	dc.b	nBb2
	smpsAlterVol        $FF
	dc.b	nEb3
	smpsAlterVol        $02
	dc.b	nC3
	smpsAlterVol        $FF
	dc.b	nF2, nF2, $0C
	smpsAlterVol        $FD
	dc.b	nG2, $06
	smpsAlterVol        $02
	dc.b	nAb2, $12
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $FC
	dc.b	nEb3, $12
	smpsAlterVol        $04
	dc.b	nC3
	smpsAlterVol        $FD
	dc.b	nF3
	smpsAlterVol        $02
	dc.b	$02, nE3, $01
	smpsAlterVol        $01
	dc.b	nEb3, $02, nD3, $01, nCs3, $02, nC3, $01, nB2, $02
	smpsAlterVol        $01
	dc.b	nBb2, $01, nA2, $02, nAb2, $01, nG2, $02
	smpsAlterVol        $01
	dc.b	nFs2, $01
	smpsAlterVol        $01
	dc.b	nF2, $12
	smpsAlterVol        $FD
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	nG2, $06
	smpsAlterVol        $01
	dc.b	nAb2, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nCs3, $12
	smpsAlterVol        $01
	dc.b	nBb2
	smpsAlterVol        $FE
	dc.b	nEb3
	smpsAlterVol        $02
	dc.b	nC3
	smpsAlterVol        $01
	dc.b	nF2
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	nG2, $06, nAb2, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nEb3, $12
	smpsAlterVol        $03
	dc.b	nC3
	smpsAlterVol        $FD
	dc.b	nF3
	smpsAlterVol        $01
	dc.b	$02, nE3, $01, nEb3, $02, nD3, $01
	smpsAlterVol        $01
	dc.b	nCs3, $02, nC3, $01, nB2, $02, nBb2, $01
	smpsAlterVol        $01
	dc.b	nA2, $02, nAb2, $01, nG2, $02, nFs2, $01
	smpsAlterVol        $01
	dc.b	nF2, $12
	smpsAlterVol        $FD
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	nG2, $06
	smpsAlterVol        $FF
	dc.b	nAb2, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $03
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nCs3, $12
	smpsAlterVol        $01
	dc.b	nBb2
	smpsAlterVol        $FE
	dc.b	nEb3
	smpsAlterVol        $02
	dc.b	nC3
	smpsAlterVol        $01
	dc.b	nF2
	smpsAlterVol        $FD
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	nG2, $06
	smpsAlterVol        $FF
	dc.b	nAb2, $12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nEb3, $12
	smpsAlterVol        $03
	dc.b	nC3
	smpsAlterVol        $FD
	dc.b	nF3
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $02
	dc.b	nC3
	smpsAlterVol        $FF
	dc.b	$12, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $02
	dc.b	$12, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $03
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12, $12, $12, $12
	smpsAlterVol        $FF
	dc.b	nF3
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nCs3, $12, $12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C, $06
	smpsAlterVol        $01
	dc.b	nAb2, $12, $12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06, nEb3, $12, $12, $0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C, $06, nF3, $12, $12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nCs3, $12
	smpsAlterVol        $FE
	dc.b	$12, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $03
	dc.b	nAb2, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	nC3, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nF3, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nCs3, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $03
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $01
	dc.b	nAb2, $12, $12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $FF
	dc.b	nEb3, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C, $06
	smpsAlterVol        $FE
	dc.b	nF3, $12, $12
	smpsAlterVol        $01
	dc.b	$0C, $06, $0C
	smpsAlterVol        $FF
	dc.b	$06
	smpsAlterVol        $03
	dc.b	nCs3, $12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FC
	dc.b	$06
	smpsAlterVol        $02
	dc.b	nAb2, $12, $12

holiday_Loop16:
	smpsAlterVol        $FF
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsLoop            $00, $02, holiday_Loop16
	smpsAlterVol        $FF
	dc.b	nC3, $12
	smpsAlterVol        $02
	dc.b	$12, $12
	smpsAlterVol        $FF
	dc.b	$12, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $FD
	dc.b	$12
	smpsAlterVol        $03
	dc.b	$12
	smpsAlterVol        $FF
	dc.b	$12, $12
	smpsAlterVol        $01
	dc.b	$12, $12
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	nF3
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nCs3
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $03
	dc.b	nAb2
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FB
	dc.b	nEb3, $0C
	smpsAlterVol        $04
	dc.b	$06, $0C, $06, nF3, $12, $12
	smpsAlterVol        $FF
	dc.b	nCs3
	smpsAlterVol        $02
	dc.b	$12, nAb2
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FE
	dc.b	nEb3, $0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $01
	dc.b	$0C
	smpsAlterVol        $01
	dc.b	$06
	smpsAlterVol        $FD
	dc.b	nF3, $12
	smpsAlterVol        $02
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nCs3
	smpsAlterVol        $FE
	dc.b	$12
	smpsAlterVol        $03
	dc.b	nAb2
	smpsAlterVol        $FF
	dc.b	$12
	smpsAlterVol        $FC
	dc.b	nEb3, $0C
	smpsAlterVol        $02
	dc.b	$06
	smpsAlterVol        $02
	dc.b	$0C
	smpsAlterVol        $FE
	dc.b	$06, nF3, $12
	smpsAlterVol        $01
	dc.b	$12
	smpsAlterVol        $01
	dc.b	nCs3, nCs3
	smpsAlterVol        $FE
	dc.b	nEb3
	smpsAlterVol        $02
	dc.b	nC3
	smpsAlterVol        $FF
	dc.b	nF3
	smpsAlterVol        $04
	dc.b	nF2, $7F, smpsNoAttack, $23
	smpsStop

holiday_Voices:
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

;	Voice $02
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

;	Voice $03
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

