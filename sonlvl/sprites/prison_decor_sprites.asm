; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_foh2V:	
		dc.w SME_foh2V_8-SME_foh2V, SME_foh2V_16-SME_foh2V	
		dc.w SME_foh2V_24-SME_foh2V, SME_foh2V_2C-SME_foh2V	
SME_foh2V_8:	dc.b 0, 2	
		dc.b $D0, $F, 0, 0, $FF, $F0	
		dc.b $F0, $F, 0, $10, $FF, $F0	
SME_foh2V_16:	dc.b 0, 2	
		dc.b $E0, $F, 0, $20, $FF, $F0	
		dc.b 0, $F, 0, $30, $FF, $F0	
SME_foh2V_24:	dc.b 0, 1	
		dc.b $F0, $F, 0, $40, $FF, $F0	
SME_foh2V_2C:	dc.b 0, 2	
		dc.b $E0, $F, 0, $50, $FF, $F0	
		dc.b 0, $F, 0, $60, $FF, $F0	
		even