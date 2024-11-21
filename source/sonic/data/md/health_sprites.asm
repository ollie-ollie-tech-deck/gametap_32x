; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_lTmGp:	
		dc.w SME_lTmGp_C-SME_lTmGp, SME_lTmGp_E-SME_lTmGp	
		dc.w SME_lTmGp_16-SME_lTmGp, SME_lTmGp_24-SME_lTmGp	
		dc.w SME_lTmGp_38-SME_lTmGp, SME_lTmGp_52-SME_lTmGp	
SME_lTmGp_C:	dc.b 0, 0	
SME_lTmGp_E:	dc.b 0, 1	
		dc.b $F8, $A, 0, 0, $FF, $F8	
SME_lTmGp_16:	dc.b 0, 2	
		dc.b $F8, $A, 0, 0, $FF, $F8	
		dc.b $F8, $A, 0, 0, $FF, $E7	
SME_lTmGp_24:	dc.b 0, 3	
		dc.b $F8, $A, 0, 0, $FF, $F8	
		dc.b $F8, $A, 0, 0, $FF, $E7	
		dc.b $F8, $A, 0, 0, $FF, $D7	
SME_lTmGp_38:	dc.b 0, 4	
		dc.b $F8, $A, 0, 0, $FF, $F8	
		dc.b $F8, $A, 0, 0, $FF, $E7	
		dc.b $F8, $A, 0, 0, $FF, $D7	
		dc.b $F8, $A, 0, 0, $FF, $C7	
SME_lTmGp_52:	dc.b 0, 5	
		dc.b $F8, $A, 0, 0, $FF, $F8	
		dc.b $F8, $A, 0, 0, $FF, $E7	
		dc.b $F8, $A, 0, 0, $FF, $D7	
		dc.b $F8, $A, 0, 0, $FF, $C7	
		dc.b $F8, $A, 0, 0, $FF, $B7	
		even