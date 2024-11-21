; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_EFSgp:	
		dc.w SME_EFSgp_6-SME_EFSgp, SME_EFSgp_E-SME_EFSgp	
		dc.w SME_EFSgp_16-SME_EFSgp	
SME_EFSgp_6:	dc.b 0, 1	
		dc.b $F0, $F, 0, 0, $FF, $F0	
SME_EFSgp_E:	dc.b 0, 1	
		dc.b $F0, $F, 0, $10, $FF, $F0	
SME_EFSgp_16:	dc.b 0, 1	
		dc.b $F0, $F, 0, $20, $FF, $F0	
		even