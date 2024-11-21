; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Error handler functions header
; ------------------------------------------------------------------------------

	global CheckSh2Error
	global BusError
	global AddressError
	global IllegalInstr
	global ZeroDivide
	global ChkInstr
	global TrapvInstr
	global PrivilegeViol
	global Trace
	global Line1010Emu
	global Line1111Emu
	global ErrorExcept
	global DebuggerExtensions
	global ErrorHandler
	
; ------------------------------------------------------------------------------
; Debugger extensions
; ------------------------------------------------------------------------------

__global__ErrorHandler_ConsoleOnly: equ DebuggerExtensions+$0
__global__ErrorHandler_ClearConsole: equ DebuggerExtensions+$26
__global__KDebug_WriteLine_Formatted: equ DebuggerExtensions+$50
__global__KDebug_Write_Formatted: equ DebuggerExtensions+$54
__global__KDebug_FlushLine: equ DebuggerExtensions+$AA
__global__ErrorHandler_PauseConsole: equ DebuggerExtensions+$C2
__global__ErrorHandler_PagesController: equ DebuggerExtensions+$F8
__global__VSync: equ DebuggerExtensions+$158

__global__ErrorHandler: equ ErrorHandler+$0
__global__Error_IdleLoop: equ ErrorHandler+$122
__global__Error_InitConsole: equ ErrorHandler+$13C
__global__Error_MaskStackBoundaries: equ ErrorHandler+$148
__global__Error_DrawOffsetLocation: equ ErrorHandler+$1B2
__global__Error_DrawOffsetLocation2: equ ErrorHandler+$1B6
__global__ErrorHandler_SetupVDP: equ ErrorHandler+$23C
__global__ErrorHandler_VDPConfig: equ ErrorHandler+$274
__global__ErrorHandler_VDPConfig_Nametables: equ ErrorHandler+$28A
__global__ErrorHandler_ConsoleConfig_Initial: equ ErrorHandler+$2C6
__global__ErrorHandler_ConsoleConfig_Shared: equ ErrorHandler+$2CA
__global__Art1bpp_Font: equ ErrorHandler+$334
__global__FormatString: equ ErrorHandler+$8F8
__global__Console_Init: equ ErrorHandler+$9CE
__global__Console_Reset: equ ErrorHandler+$A10
__global__Console_InitShared: equ ErrorHandler+$A12
__global__Console_SetPosAsXY_Stack: equ ErrorHandler+$A4E
__global__Console_SetPosAsXY: equ ErrorHandler+$A54
__global__Console_GetPosAsXY: equ ErrorHandler+$A82
__global__Console_StartNewLine: equ ErrorHandler+$AA4
__global__Console_SetBasePattern: equ ErrorHandler+$ACC
__global__Console_SetWidth: equ ErrorHandler+$AE0
__global__Console_WriteLine_WithPattern: equ ErrorHandler+$AF6
__global__Console_WriteLine: equ ErrorHandler+$AF8
__global__Console_Write: equ ErrorHandler+$AFC
__global__Console_WriteLine_Formatted: equ ErrorHandler+$BA8
__global__Console_Write_Formatted: equ ErrorHandler+$BAC
__global__Decomp1bpp: equ ErrorHandler+$BDC

; ------------------------------------------------------------------------------
