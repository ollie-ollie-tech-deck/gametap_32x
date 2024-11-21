; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_xaKLT:	
		dc.w SME_xaKLT_16-SME_xaKLT, SME_xaKLT_2A-SME_xaKLT	
		dc.w SME_xaKLT_3E-SME_xaKLT, SME_xaKLT_52-SME_xaKLT	
		dc.w SME_xaKLT_6C-SME_xaKLT, SME_xaKLT_80-SME_xaKLT	
		dc.w SME_xaKLT_8E-SME_xaKLT, SME_xaKLT_A2-SME_xaKLT	
		dc.w SME_xaKLT_B6-SME_xaKLT, SME_xaKLT_CA-SME_xaKLT	
		dc.w SME_xaKLT_DE-SME_xaKLT	
SME_xaKLT_16:	dc.b 0, 3	
		dc.b $EC, $D, 0, 0, $FF, $EC	
		dc.b $F4, 0, 0, 8, 0, $C	
		dc.b $FC, $E, 0, 9, $FF, $F4	
SME_xaKLT_2A:	dc.b 0, 3	
		dc.b $EC, 6, 0, $15, $FF, $EC	
		dc.b $EC, 9, 0, $1B, $FF, $FC	
		dc.b $FC, $A, 0, $21, $FF, $FC	
SME_xaKLT_3E:	dc.b 0, 3	
		dc.b $EC, 6, 0, $2A, $FF, $EC	
		dc.b $EC, 9, 0, $1B, $FF, $FC	
		dc.b $FC, $A, 0, $21, $FF, $FC	
SME_xaKLT_52:	dc.b 0, 4	
		dc.b $EC, 6, 0, $30, $FF, $EC	
		dc.b $EC, 9, 0, $1B, $FF, $FC	
		dc.b $FC, 9, 0, $36, $FF, $FC	
		dc.b $C, 0, 0, $3C, 0, $C	
SME_xaKLT_6C:	dc.b 0, 3	
		dc.b $F4, $D, 0, $3D, $FF, $EC	
		dc.b $FC, 0, 0, $20, 0, $C	
		dc.b 4, 8, 0, $45, $FF, $FC	
SME_xaKLT_80:	dc.b 0, 2	
		dc.b $F8, $D, 0, $48, $FF, $EC	
		dc.b $F8, 1, 0, $50, 0, $C	
SME_xaKLT_8E:	dc.b 0, 3	
		dc.b $F8, $D, 0, $48, $FF, $EC	
		dc.b $F8, 1, 0, $50, 0, $C	
		dc.b $FE, 0, 0, $52, 0, $14	
SME_xaKLT_A2:	dc.b 0, 3	
		dc.b $F8, $D, 0, $48, $FF, $EC	
		dc.b $F8, 1, 0, $50, 0, $C	
		dc.b $FE, 4, 0, $53, 0, $14	
SME_xaKLT_B6:	dc.b 0, 3	
		dc.b $F8, $D, 0, $48, $FF, $EC	
		dc.b $F8, 1, 0, $50, 0, $C	
		dc.b $FE, 0, $E0, $52, 0, $14	
SME_xaKLT_CA:	dc.b 0, 3	
		dc.b $F8, $D, 0, $48, $FF, $EC	
		dc.b $F8, 1, 0, $50, 0, $C	
		dc.b $FE, 4, $E0, $53, 0, $14	
SME_xaKLT_DE:	dc.b 0, 0	
		even