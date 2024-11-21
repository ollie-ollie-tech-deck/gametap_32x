skid_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     skid_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cPSG2, skid_PSG2,	$F4, $00
	smpsHeaderSFXChannel cPSG3, skid_PSG3,	$F4, $00

; PSG2 Data
skid_PSG2:
	smpsPSGvoice        $00
	dc.b	nBb3, $01, nRst, nBb3, nRst, $03

skid_Loop01:
	dc.b	nBb3, $01, nRst, $01
	smpsLoop            $00, $0B, skid_Loop01
	smpsStop

; PSG3 Data
skid_PSG3:
	smpsPSGvoice        $00
	dc.b	nRst, $01, nAb3, nRst, nAb3, nRst, $03

skid_Loop00:
	dc.b	nAb3, $01, nRst, $01
	smpsLoop            $00, $0B, skid_Loop00
	smpsStop

; Song seems to not use any FM voices
skid_Voices:
