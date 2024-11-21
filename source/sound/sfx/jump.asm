jump_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     jump_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG1, jump_PSG1,	$F4, $00

; PSG1 Data
jump_PSG1:
	smpsPSGvoice        $00
	dc.b	nF2, $05
	smpsModSet          $02, $01, $F8, $65
	dc.b	nBb2, $15
	smpsStop

; Song seems to not use any FM voices
jump_Voices:
