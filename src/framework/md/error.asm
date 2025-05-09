
; ===============================================================
; ---------------------------------------------------------------
; Error handling and debugging modules
;
; (c) 2016-2023, Vladikcomper
; ---------------------------------------------------------------
; Error handler functions and calls
; ---------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/framework/md.inc"
	
; ---------------------------------------------------------------
; Clear 32X screen before displaying error
; ---------------------------------------------------------------

ERROR_CLEAR_32X macro
	move	#$2700,sr
	move.l	d0,-(sp)
	move.b	#4,MARS_COMM_6+MARS_SYS
	CMD_INT 1,0
	move.l	(sp)+,d0
	endm

; ---------------------------------------------------------------
; Check for SH-2 errors
; ---------------------------------------------------------------

CheckSh2Error:
	movem.l	a0/a1,-(sp)					; Save registers
	
	lea	MARS_SYS+MARS_COMM_0,a0				; Check Master SH-2 crash
	lea	.MasterCpu(pc),a1
	bsr.s	.Check
	
	lea	MARS_SYS+MARS_COMM_4,a0				; Check Slave SH-2 crash
	lea	.SlaveCpu(pc),a1
	bsr.s	.Check
	
	movem.l	(sp)+,a0/a1					; Restore registers
	rts

; ---------------------------------------------------------------

.Check:
	cmp.w	#"ER",(a0)					; Has an error occured?
	beq.s	.GetError					; If so, branch
	rts
	
.GetError:
	move	#$2700,sr					; Disable interrupts
	move.w	2(a0),d0					; Get error code

	move.l	#"MDER",d1					; Acknowledge crash
	move.l	d1,(a0)
	
	moveq	#23-1,d2					; Number of debug info entries
	lea	-$23*4(sp),a3					; Register area

.GetRegs:
	move.l	(a0),d3						; Get debugging info entry
	cmp.l	d1,d3
	beq.s	.GetRegs					; Wait if it hasn't been sent
	move.l	d3,(a3)+					; Store entry
	move.l	d1,(a0)						; Acknowledge it and request next entry
	dbf	d2,.GetRegs					; Loop until finished

	lea	-$23*4(sp),sp					; Display error message
	movea.w	sp,a0
	movea.l	.ErrorTypes(pc,d0.w),a2
	Console.Run .Message
	
; ---------------------------------------------------------------

.MasterCpu:
	dc.b	"MASTER", 0
	even
	
.SlaveCpu:
	dc.b	"SLAVE", 0
	even
	
; ---------------------------------------------------------------

.ErrorTypes:
	dc.l	.IllegalInstr
	dc.l	.IllegalSlotInstr
	dc.l	.CpuAddressError
	dc.l	.DmaAddressError
	dc.l	.UserBreak
	
.IllegalInstr:
	dc.b	"ILLEGAL INSTRUCTION", 0
	even
.IllegalSlotInstr:
	dc.b	"ILLEGAL SLOT INSTRUCTION", 0
	even
.CpuAddressError:
	dc.b	"CPU ADDRESS ERROR", 0
	even
.DmaAddressError:
	dc.b	"DMA ADDRESS ERROR", 0
	even
.UserBreak:
	dc.b	"USER BREAK", 0
	even
	
; ---------------------------------------------------------------

.Message:
	Console.SetXY #1,#1
	Console.WriteLine "%<pal1>%<.l a1 str> %<.l a2 str>%<endl>"
	Console.WriteLine "Location: %<pal2>%<.l $50(a0)>%<endl>"

	Console.WriteLine "   %<pal0>r0: %<pal2>%<.l (a0)>   %<pal0>r8: %<pal2>%<.l $20(a0)>"
	Console.WriteLine "   %<pal0>r1: %<pal2>%<.l 4(a0)>   %<pal0>r9: %<pal2>%<.l $24(a0)>"
	Console.WriteLine "   %<pal0>r2: %<pal2>%<.l 8(a0)>  %<pal0>r10: %<pal2>%<.l $28(a0)>"
	Console.WriteLine "   %<pal0>r3: %<pal2>%<.l $C(a0)>  %<pal0>r11: %<pal2>%<.l $2C(a0)>"
	Console.WriteLine "   %<pal0>r4: %<pal2>%<.l $10(a0)>  %<pal0>r12: %<pal2>%<.l $30(a0)>"
	Console.WriteLine "   %<pal0>r5: %<pal2>%<.l $14(a0)>  %<pal0>r13: %<pal2>%<.l $34(a0)>"
	Console.WriteLine "   %<pal0>r6: %<pal2>%<.l $18(a0)>  %<pal0>r14: %<pal2>%<.l $38(a0)>"
	Console.WriteLine "   %<pal0>r7: %<pal2>%<.l $1C(a0)>   %<pal0>sp: %<pal2>%<.l $58(a0)>"
	Console.WriteLine "   %<pal0>sr: %<pal2>%<.l $54(a0)>   %<pal0>pr: %<pal2>%<.l $44(a0)>%<endl>"
	Console.WriteLine "  %<pal0>gbr: %<pal2>%<.l $48(a0)>  %<pal0>vbr: %<pal2>%<.l $4C(a0)>%<endl>"
	Console.WriteLine "  %<pal0>mac: %<pal2>%<.l $3C(a0)>%<.l $40(a0)>"
	Console.WriteLine ""
	
	bra.w	*

; ---------------------------------------------------------------
; Error handler control flags
; ---------------------------------------------------------------

; Screen appearence flags
_eh_address_error	equ	$01		; use for address and bus errors only (tells error handler to display additional "Address" field)
_eh_show_sr_usp		equ	$02		; displays SR and USP registers content on error screen

; Advanced execution flags
; WARNING! For experts only, DO NOT USES them unless you know what you're doing
_eh_return			equ	$20
_eh_enter_console	equ	$40
_eh_align_offset	equ	$80

; ---------------------------------------------------------------
; Errors vector table
; ---------------------------------------------------------------

; Default screen configuration
_eh_default			equ	0 ;_eh_show_sr_usp

; ---------------------------------------------------------------

BusError:
	ERROR_CLEAR_32X
	__ErrorMessage "BUS ERROR", _eh_default|_eh_address_error

AddressError:
	ERROR_CLEAR_32X
	__ErrorMessage "ADDRESS ERROR", _eh_default|_eh_address_error

IllegalInstr:
	ERROR_CLEAR_32X
	__ErrorMessage "ILLEGAL INSTRUCTION", _eh_default

ZeroDivide:
	ERROR_CLEAR_32X
	__ErrorMessage "ZERO DIVIDE", _eh_default

ChkInstr:
	ERROR_CLEAR_32X
	__ErrorMessage "CHK INSTRUCTION", _eh_default

TrapvInstr:
	ERROR_CLEAR_32X
	__ErrorMessage "TRAPV INSTRUCTION", _eh_default

PrivilegeViol:
	ERROR_CLEAR_32X
	__ErrorMessage "PRIVILEGE VIOLATION", _eh_default

Trace:
	ERROR_CLEAR_32X
	__ErrorMessage "TRACE", _eh_default

Line1010Emu:
	ERROR_CLEAR_32X
	__ErrorMessage "LINE 1010 EMULATOR", _eh_default

Line1111Emu:
	ERROR_CLEAR_32X
	__ErrorMessage "LINE 1111 EMULATOR", _eh_default

ErrorExcept:
	ERROR_CLEAR_32X
	__ErrorMessage "ERROR EXCEPTION", _eh_default

; ---------------------------------------------------------------
; Built-in debuggers
; ---------------------------------------------------------------

Debugger_AddressRegisters:
	dc.l	$48E700FE, $41FA002A
	jsr		__global__Console_Write(pc)
	dc.l	$49D77C06, $3F3C2000, $2F3CE861, $303A41D7
	dc.w	$221C
	jsr		__global__Error_DrawOffsetLocation(pc)
	dc.l	$522F0002, $51CEFFF2, $4FEF0022, $4E75E0FA, $01F026EA, $41646472, $65737320, $52656769
	dc.l	$73746572, $733AE0E0
	dc.w	$0000

Debugger_Backtrace:
	dc.l	$41FA0088
	jsr		__global__Console_Write(pc)
	dc.l	$22780000, $598945D7
	jsr		__global__Error_MaskStackBoundaries(pc)
	dc.l	$B3CA6570, $0C520040, $64642012, $67602040, $02400001, $66581220, $10200C00, $00616604
	dc.l	$4A01663A, $0C00004E, $660A0201, $00F80C01, $0090672A, $30200C40, $61006722, $12004200
	dc.l	$0C404E00, $66120C01, $00A8650C, $0C0100BB, $62060C01, $00B96606, $0C604EB9, $66102F0A
	dc.l	$2F092208
	jsr		__global__Error_DrawOffsetLocation2(pc)
	dc.l	$225F245F, $548A548A, $B3CA6490, $4E75E0FA, $01F026EA, $4261636B, $74726163, $653AE0E0
	dc.w	$0000

; ---------------------------------------------------------------
; Debugger extensions
; ---------------------------------------------------------------

DebuggerExtensions:
	dc.l	$46FC2700, $4FEFFFF2, $48E7FFFE, $47EF003C
	jsr		__global__ErrorHandler_SetupVDP(pc)
	jsr		__global__Error_InitConsole(pc)
	dc.l	$4CDF7FFF
	pea		__global__Error_IdleLoop(pc)
	dc.l	$2F2F0012, $4E752F0B, $4E6B0C2B, $005D000C, $661A48E7, $C4464BF9, $00C00004, $4DEDFFFC
	lea		__global__ErrorHandler_ConsoleConfig_Initial(pc), a1
	jsr		__global__Console_Reset(pc)
	dc.l	$4CDF6223, $265F4E75, $487A0058, $4E680C28, $005D000C, $67182F0C, $49FA0016, $4FEFFFF0
	dc.l	$41D77E0E
	jsr		__global__FormatString(pc)
	dc.l	$4FEF0010, $285F4E75, $42184447, $0647000F, $90C72F08, $2F0D4BF9, $00C00004, $3E3C9E00
	dc.l	$60023A87, $1E186EFA, $67080407, $00E067F2, $60F22A5F, $205F7E0E, $4E752F08, $4E680C28
	dc.l	$005D000C, $670833FC, $9E0000C0, $0004205F, $4E7548E7, $C0D04E6B, $0C2B005D, $000C660C
	dc.l	$3F3C0000, $610C610A, $67FC544F, $4CDF0B03, $4E756174, $41EF0004, $43F900A1, $00036178
	dc.l	$70F0C02F, $00054E75, $48E7FFFE, $3F3C0000, $61E04BF9, $00C00004, $4DEDFFFC, $61D467F2
	dc.l	$6B4041FA, $00765888, $D00064FA, $20106F32, $20404FEF
	dc.w	$FFF2
	lea		__global__ErrorHandler_ConsoleConfig_Shared(pc), a1
	dc.l	$47D72A3C, $40000003
	jsr		__global__Console_InitShared(pc)
	dc.l	$2ABC8230, $84062A85, $487A000C, $48504CEF, $7FFF0014, $4E754FEF, $000E60B0
	move.l	__global__ErrorHandler_VDPConfig_Nametables(pc), (a5)
	dc.l	$60AA41F9, $00C00004, $44D06BFC, $44D06AFC, $4E7512BC, $00004E71, $72C01011, $E50812BC
	dc.l	$00404E71, $C0011211, $0201003F, $80014600, $1210B101, $10C0C200, $10C14E75

; WARNING! Don't move! This must be placed directly below "DebuggerExtensions"
DebuggerExtensions_ExtraDebuggerList:
	dc.l	DEBUGGER__EXTENSIONS__BTN_A_DEBUGGER	; for button A
	dc.l	DEBUGGER__EXTENSIONS__BTN_C_DEBUGGER	; for button C (not B)
	dc.l	DEBUGGER__EXTENSIONS__BTN_B_DEBUGGER	; for button B (not C)

; ---------------------------------------------------------------
; Error handler blob
; ---------------------------------------------------------------

ErrorHandler:
	dc.l	$46FC2700, $4FEFFFF2, $48E7FFFE, $4EBA022E, $49EF004A, $4E682F08, $47EF0040, $4EBA011E
	dc.l	$41FA02B2, $4EBA0AD6, $225C45D4, $4EBA0B7A, $4EBA0A72, $49D21C19, $6A025249, $47D10806
	dc.l	$0000670E, $41FA0295, $222C0002, $4EBA0164, $504C41FA, $0292222C, $00024EBA, $01562278
	dc.l	$000045EC, $00064EBA, $01AE41FA, $02844EBA, $01424EBA, $0A300806, $00066600, $00AA45EF
	dc.l	$00044EBA, $09FE3F01, $70034EBA, $09C8303C, $64307A07, $4EBA0132, $321F7011, $4EBA09B6
	dc.l	$303C6130, $7A064EBA, $0120303C, $73707A00, $2F0C45D7, $4EBA0112, $584F0806, $00016714
	dc.l	$43FA0240, $45D74EBA, $0AE443FA, $024145D4, $4EBA0AD6, $584F4EBA, $09AA5241, $70014EBA
	dc.l	$09742038, $007841FA, $022F4EBA, $010A2038, $007041FA, $022B4EBA, $00FE4EBA, $09A82278
	dc.l	$000045D4, $53896140, $4EBA0978, $7A199A41, $6B0A6148, $4EBA005A, $51CDFFFA, $08060005
	dc.l	$660A4E71, $60FC7200, $4EBA09A2, $2ECB4CDF, $7FFF487A, $FFEE2F2F, $FFC44E75, $43FA0152
	dc.l	$45FA01F2, $4EFA0888, $223C00FF, $FFFF2409, $C4812242, $240AC481, $24424E75, $4FEFFFD0
	dc.l	$41D77EFF, $20FC2853, $502930FC, $3A206018, $4FEFFFD0, $41D77EFF, $30FC202B, $320A924C
	dc.l	$4EBA05A4, $30FC3A20, $700572EC, $B5C96502, $72EE10C1, $321A4EBA, $05AC10FC, $002051C8
	dc.l	$FFEA4218, $41D77200, $4EBA094C, $4FEF0030, $4E754EBA, $09482F01, $2F0145D7, $43FA013C
	dc.l	$4EBA09E6, $504F4E75, $4FEFFFF0, $7EFF41D7, $30C030FC, $3A2010FC, $00EC221A, $4EBA055E
	dc.l	$421841D7, $72004EBA, $090E5240, $51CDFFE0, $4FEF0010, $4E752200, $48414601, $66F62440
	dc.l	$0C5A4EF9, $66042212, $60A84EBA, $09A043FA, $01174EFA, $09945989, $4EBAFF2E, $B3CA650C
	dc.l	$0C520040, $650A548A, $B3CA64F4, $72004E75, $221267F2, $08010000, $66EC4E75, $4BF900C0
	dc.l	$00044DED, $FFFC4A55, $44D569FC, $41FA0026, $30186A04, $3A8060F8, $70002ABC, $40000000
	dc.l	$2C802ABC, $40000010, $2C802ABC, $C0000000, $3C804E75, $80048134, $85008700, $8B008C81
	dc.l	$8D008F02, $90119100, $92008220, $84040000, $44000000, $00000001, $00100011, $01000101
	dc.l	$01100111, $10001001, $10101011, $11001101, $11101111, $FFFF0EEE, $FFF200CE, $FFF20EEA
	dc.l	$FFF20E86, $FFF24000, $00020028, $00280000, $008000FF, $EAE0FA01, $F02600EA, $41646472
	dc.l	$6573733A, $2000EA4F, $66667365, $743A2000, $EA43616C, $6C65723A, $2000EC83, $20E8BFEC
	dc.l	$C800FA10, $E8757370, $3A20EC83, $00FA03E8, $73723A20, $EC8100EA, $56496E74, $3A2000EA
	dc.l	$48496E74, $3A2000E8, $3C756E64, $6566696E, $65643E00, $02F70000, $00000000, $0000183C
	dc.l	$3C181800, $18006C6C, $6C000000, $00006C6C, $FE6CFE6C, $6C00187E, $C07C06FC, $180000C6
	dc.l	$0C183060, $C600386C, $3876CCCC, $76001818, $30000000, $00001830, $60606030, $18006030
	dc.l	$18181830, $600000EE, $7CFE7CEE, $00000018, $187E1818, $00000000, $00001818, $30000000
	dc.l	$00FE0000, $00000000, $00000038, $3800060C, $183060C0, $80007CC6, $CEDEF6E6, $7C001878
	dc.l	$18181818, $7E007CC6, $0C183066, $FE007CC6, $063C06C6, $7C000C1C, $3C6CFE0C, $0C00FEC0
	dc.l	$FC0606C6, $7C007CC6, $C0FCC6C6, $7C00FEC6, $060C1818, $18007CC6, $C67CC6C6, $7C007CC6
	dc.l	$C67E06C6, $7C00001C, $1C00001C, $1C000018, $18000018, $18300C18, $30603018, $0C000000
	dc.l	$FE0000FE, $00006030, $180C1830, $60007CC6, $060C1800, $18007CC6, $C6DEDCC0, $7E00386C
	dc.l	$C6C6FEC6, $C600FC66, $667C6666, $FC003C66, $C0C0C066, $3C00F86C, $6666666C, $F800FEC2
	dc.l	$C0F8C0C2, $FE00FE62, $607C6060, $F0007CC6, $C0C0DEC6, $7C00C6C6, $C6FEC6C6, $C6003C18
	dc.l	$18181818, $3C003C18, $1818D8D8, $7000C6CC, $D8F0D8CC, $C600F060, $60606062, $FE00C6EE
	dc.l	$FED6D6C6, $C600C6E6, $E6F6DECE, $C6007CC6, $C6C6C6C6, $7C00FC66, $667C6060, $F0007CC6
	dc.l	$C6C6C6D6, $7C06FCC6, $C6FCD8CC, $C6007CC6, $C07C06C6, $7C007E5A, $18181818, $3C00C6C6
	dc.l	$C6C6C6C6, $7C00C6C6, $C6C66C38, $1000C6C6, $D6D6FEEE, $C600C66C, $3838386C, $C6006666
	dc.l	$663C1818, $3C00FE86, $0C183062, $FE007C60, $60606060, $7C00C060, $30180C06, $02007C0C
	dc.l	$0C0C0C0C, $7C001038, $6CC60000, $00000000, $00000000, $00FF3030, $18000000, $00000000
	dc.l	$780C7CCC, $7E00E060, $7C666666, $FC000000, $7CC6C0C6, $7C001C0C, $7CCCCCCC, $7E000000
	dc.l	$7CC6FEC0, $7C001C36, $30FC3030, $78000000, $76CEC67E, $067CE060, $7C666666, $E6001800
	dc.l	$38181818, $3C000C00, $1C0C0C0C, $CC78E060, $666C786C, $E6001818, $18181818, $1C000000
	dc.l	$6CFED6D6, $C6000000, $DC666666, $66000000, $7CC6C6C6, $7C000000, $DC66667C, $60F00000
	dc.l	$76CCCC7C, $0C1E0000, $DC666060, $F0000000, $7CC07C06, $7C003030, $FC303036, $1C000000
	dc.l	$CCCCCCCC, $76000000, $C6C66C38, $10000000, $C6C6D6FE, $6C000000, $C66C386C, $C6000000
	dc.l	$C6C6CE76, $067C0000, $FC983064, $FC000E18, $18701818, $0E001818, $18001818, $18007018
	dc.l	$180E1818, $700076DC, $00000000, $000043FA, $05C80C59, $DEB26672, $70FED059, $74FC7600
	dc.l	$48410241, $00FFD241, $D241B240, $625C675E, $20311000, $675847F1, $08004841, $7000301B
	dc.l	$B253654C, $43F308FE, $45E9FFFC, $E248C042, $B2730000, $65146204, $D6C0601A, $47F30004
	dc.l	$200A908B, $6AE6594B, $600C45F3, $00FC200A, $908B6AD8, $47D2925B, $7400341B, $D3C24841
	dc.l	$42414841, $D2837000, $4E7570FF, $4E754841, $70003001, $D6805283, $323CFFFF, $48415941
	dc.l	$6A8E70FF, $4E7547FA, $05300C5B, $DEB2664A, $D6D37800, $72007400, $45D351CC, $00061619
	dc.l	$7807D603, $D3415242, $B252620A, $65ECB42A, $00026712, $65E4584A, $B25262FA, $65DCB42A
	dc.l	$000265D6, $66F010EA, $0003670A, $51CFFFC6, $4E9464C0, $4E755348, $4E757000, $4E754EFA
	dc.l	$00244EFA, $0018760F, $3401E84A, $C44310FB, $205E51CF, $004C4E94, $64464E75, $48416104
	dc.l	$654A4841, $7404760F, $E5791801, $C84310FB, $403E51CF, $00044E94, $6532E579, $1801C843
	dc.l	$10FB402C, $51CF0004, $4E946520, $E5791801, $C84310FB, $401A51CF, $00044E94, $650EE579
	dc.l	$C24310FB, $100A51CF, $00044ED4, $4E753031, $32333435, $36373839, $41424344, $45464EFA
	dc.l	$00264EFA, $001A7407, $7018D201, $D10010C0, $51CF0006, $4E946504, $51CAFFEE, $4E754841
	dc.l	$61046518, $4841740F, $7018D241, $D10010C0, $51CF0006, $4E946504, $51CAFFEE, $4E754EFA
	dc.l	$00104EFA, $004847FA, $009A0241, $00FF6004, $47FA008C, $42007609, $381B3403, $924455CA
	dc.l	$FFFCD244, $94434442, $8002670E, $06020030, $10C251CF, $00064E94, $6510381B, $6ADC0601
	dc.l	$003010C1, $51CF0004, $4ED44E75, $47FA002E, $42007609, $281B3403, $928455CA, $FFFCD284
	dc.l	$94434442, $8002670E, $06020030, $10C251CF, $00064E94, $65D4281B, $6ADC609E, $3B9ACA00
	dc.l	$05F5E100, $00989680, $000F4240, $000186A0, $00002710, $FFFF03E8, $0064000A, $FFFF2710
	dc.l	$03E80064, $000AFFFF, $48C16008, $4EFA0006, $488148C1, $48E75060, $4EBAFD94, $66182E81
	dc.l	$4EBAFE24, $4CDF060A, $650A0803, $00036604, $4EFA00B6, $4E754CDF, $060A0803, $00026708
	dc.l	$47FA000A, $4EFA00B4, $70FF60DE, $3C756E6B, $6E6F776E, $3E0010FC, $002B51CF, $00064E94
	dc.l	$65D24841, $4A416700, $FE5A6000, $FE520803, $000366C0, $4EFAFE46, $48E7F810, $10D95FCF
	dc.l	$FFFC6E14, $67181620, $7470C403, $4EBB201A, $64EA4CDF, $081F4E75, $4E9464E0, $60F45348
	dc.l	$4E944CDF, $081F4E75, $47FAFDF4, $B702D402, $4EFB205A, $4E714E71, $47FAFEA4, $B702D402
	dc.l	$4EFB204A, $4E714E71, $47FAFE54, $B702D402, $4EFB203A, $53484E75, $47FAFF2E, $14030242
	dc.l	$0003D442, $4EFB2026, $4A406B08, $4A816716, $4EFAFF64, $4EFAFF78, $265A10DB, $57CFFFFC
	dc.l	$67D24E94, $64F44E75, $5248603C, $504B321A, $4ED3584B, $221A4ED3, $52486022, $504B321A
	dc.l	$6004584B, $221A6A08, $448110FC, $002D6004, $10FC002B, $51CF0006, $4E9465CA, $4ED351CF
	dc.l	$00064E94, $65C010D9, $51CFFFBC, $4ED44BF9, $00C00004, $4DEDFFFC, $4A516B10, $2A9941D2
	dc.l	$38184EBA, $01F843E9, $002060EC, $544941FA, $00482ABC, $C0000000, $70007603, $3C803419
	dc.l	$3C823419, $6AFA7200, $4EB02010, $51CBFFEE, $2A194E63, $26C526D9, $26D936FC, $5D002A85
	dc.l	$70003219, $61122ABC, $40000000, $72006108, $3ABC8174, $2A854E75, $2C802C80, $2C802C80
	dc.l	$2C802C80, $2C802C80, $51C9FFEE, $4E754CAF, $00030004, $48E76010, $4E6B0C2B, $005D000C
	dc.l	$661A3413, $0242E000, $C2EB000A, $D441D440, $D4403682, $23DB00C0, $000436DB, $4CDF0806
	dc.l	$4E752F0B, $4E6B0C2B, $005D000C, $66127200, $32130241, $1FFF82EB, $000A2001, $4840E248
	dc.l	$265F4E75, $2F0B4E6B, $0C2B005D, $000C6618, $3F003013, $D06B000A, $02405FFF, $368023DB
	dc.l	$00C00004, $36DB301F, $265F4E75, $2F0B4E6B, $0C2B005D, $000C6604, $37410008, $265F4E75
	dc.l	$2F0B4E6B, $0C2B005D, $000C6606, $584B36C1, $36C1265F, $4E7561D4, $487AFFAA, $48E77E12
	dc.l	$4E6B0C2B, $005D000C, $661C2A1B, $4C93005C, $48464DF9, $00C00000, $72001218, $6E0E6B28
	dc.l	$4893001C, $27054CDF, $487E4E75, $51CB000E, $D642DA86, $0885001D, $2D450004, $D2443C81
	dc.l	$72001218, $6EE667D8, $0241001E, $4EFB1002, $DA86721D, $03856020, $6026602A, $6032603A
	dc.l	$14186014, $181860D8, $60361218, $D2417680, $4843CA83, $48418A81, $36022D45, $000460C0
	dc.l	$024407FF, $60BA0244, $07FF0044, $200060B0, $024407FF, $00444000, $60A60044, $600060A0
	dc.l	$3F041E98, $381F6098, $487AFEFA, $2F0C49FA, $00164FEF, $FFF041D7, $7E0E4EBA, $FD3C4FEF
	dc.l	$0010285F, $4E754218, $44470647, $000F90C7, $2F084EBA, $FF28205F, $7E0E4E75, $741E1018
	dc.l	$1200E609, $C2423CB1, $1000D000, $C0423CB1, $000051CC, $FFEA4E75

; ---------------------------------------------------------------
; WARNING!
;	DO NOT put any data from now on! DO NOT use ROM padding!
;	Symbol data should be appended here after ROM is compiled
;	by ConvSym utility, otherwise debugger modules won't be able
;	to resolve symbol names.
; ---------------------------------------------------------------
