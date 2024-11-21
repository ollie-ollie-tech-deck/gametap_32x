; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_SrdnV:	
		dc.w SME_SrdnV_6-SME_SrdnV, SME_SrdnV_14-SME_SrdnV	
		dc.w SME_SrdnV_22-SME_SrdnV	
SME_SrdnV_6:	dc.b 0, 2	
		dc.b $E0, $F, 0, 0, $FF, $F0	
		dc.b 0, $F, 0, $10, $FF, $F0	
SME_SrdnV_14:	dc.b 0, 2	
		dc.b $E0, $F, 0, $20, $FF, $F0	
		dc.b 0, $F, 0, $30, $FF, $F0	
SME_SrdnV_22:	dc.b 0, 1	
		dc.b $F0, $F, 0, $40, $FF, $F0	
		even