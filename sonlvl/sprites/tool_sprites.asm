; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_x2s8Z:	
		dc.w SME_x2s8Z_6-SME_x2s8Z, SME_x2s8Z_E-SME_x2s8Z	
		dc.w SME_x2s8Z_16-SME_x2s8Z	
SME_x2s8Z_6:	dc.b 0, 1	
		dc.b $F0, $F, 0, 0, $FF, $F0	
SME_x2s8Z_E:	dc.b 0, 1	
		dc.b $F0, $F, 0, $10, $FF, $F0	
SME_x2s8Z_16:	dc.b 0, 1	
		dc.b $F0, $F, 0, $20, $FF, $F0	
		even