; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Header
; ------------------------------------------------------------------------------

	section m68k_header
	include	"source/framework/md.inc"
	
	xref MarsProgram
	xref MarsProgramEnd
	xref MasterInit
	xref SlaveInit
	xref MasterVector
	xref SlaveVector
	xref HardReset
	xref SoftReset

; ------------------------------------------------------------------------------
; Vector table (Genesis mode)
; ------------------------------------------------------------------------------

	dc.l	stack						; Stack pointer
	dc.l	HardReset-MARS_ROM_FIXED			; Entry point
	dc.l	BusError-MARS_ROM_FIXED				; Bus error
	dc.l	AddressError-MARS_ROM_FIXED			; Address error
	dc.l	IllegalInstr-MARS_ROM_FIXED			; Illegal instruction
	dc.l	ZeroDivide-MARS_ROM_FIXED			; Division by zero
	dc.l	ChkInstr-MARS_ROM_FIXED				; CHK exception
	dc.l	TrapvInstr-MARS_ROM_FIXED			; TRAPV exception
	dc.l	PrivilegeViol-MARS_ROM_FIXED			; Privilege violation
	dc.l	Trace-MARS_ROM_FIXED				; TRACE exception
	dc.l	Line1010Emu-MARS_ROM_FIXED			; Line A emulator
	dc.l	Line1111Emu-MARS_ROM_FIXED			; Line F emulator
	
	dc.b	"----------------"				; Build type
	if DEBUG<>0
		dc.b	"  DEBUG  BUILD  "
	else
		dc.b	" RELEASE  BUILD "
	endif
	dc.b	"----------------"

	dc.l	ErrorExcept-MARS_ROM_FIXED			; Spurious exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; IRQ level 1
	dc.l	ErrorExcept-MARS_ROM_FIXED			; External interrupt
	dc.l	ErrorExcept-MARS_ROM_FIXED			; IRQ level 3
	dc.l	hblank_int					; H-BLANK interrupt
	dc.l	ErrorExcept-MARS_ROM_FIXED			; IRQ level 5
	dc.l	VBlankInt-MARS_ROM_FIXED			; V-BLANK interrupt
	dc.l	ErrorExcept-MARS_ROM_FIXED			; IRQ level 7
	
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #00 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #01 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #02 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #03 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #04 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #05 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #06 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #07 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #08 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #09 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #10 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #11 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #12 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #13 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #14 exception
	dc.l	ErrorExcept-MARS_ROM_FIXED			; TRAP #15 exception
	
	dc.b	"----------------"				; Build date
	dc.b	"   BUILD DATE   "
	BUILD_DATE
	dc.b	"----------------"

; ------------------------------------------------------------------------------
; ROM header
; ------------------------------------------------------------------------------

	dc.b	"SEGA 32X        "				; Hardware ID

	SIZED_TEXT 7,"\COPYRIGHT"				; Copyright holder
	dc.b	" "
	NUM_TEXT 4,_year+1900
	dc.b	"."
	MONTH_TEXT _month

	SIZED_TEXT $30,"\GAME_TITLE"				; Game title
	SIZED_TEXT $30,"\GAME_TITLE"

	dc.b	"GM XXXXXXXX-"					; Version
	NUM_TEXT 2,REVISION
	dc.w	0						; Checksum
	dc.b	"J               "				; I/O support
	dc.l	CARTRIDGE					; ROM start
	dc.l	CARTRIDGE_END-1					; ROM end
	dc.l	WORK_RAM&$FFFFFF				; RAM start
	dc.l	WORK_RAM_END&$FFFFFF				; RAM end
	dc.l	$20202020					; External RAM flags
	dc.l	$20202020					; External RAM start
	dc.l	$20202020					; External RAM end
	dc.b	"            "					; Modem support

	dc.b	"        "					; Notes
	if DEBUG<>0
		dc.b	"-----DO NOT-----"
		dc.b	"---DISTRIBUTE---"
	else
		dc.b	"                                "
	endif

	if REFRESH_RATE=NTSC					; Region
		dc.b	"JU              "
	else
		dc.b	"E               "
	endif

; ------------------------------------------------------------------------------
; Vector table (32X mode)
; ------------------------------------------------------------------------------

	jmp	SoftReset					; Entry point
	jmp	BusError					; Bus error
	jmp	AddressError					; Address error
	jmp	IllegalInstr					; Illegal instruction
	jmp	ZeroDivide					; Division by zero
	jmp	ChkInstr					; CHK exception
	jmp	TrapvInstr					; TRAPV exception
	jmp	PrivilegeViol					; Privilege violation
	jmp	Trace						; TRACE exception
	jmp	Line1010Emu					; Line A emulator
	jmp	Line1111Emu					; Line F emulator
	
	rept 12							; Reserved
		jmp	ErrorExcept
	endr
	
	jmp	ErrorExcept					; Spurious exception
	jmp	ErrorExcept					; IRQ level 1
	jmp	ErrorExcept					; External interrupt
	jmp	ErrorExcept					; IRQ level 3
	jmp	hblank_int.w					; H-BLANK interrupt
	nop
	jmp	ErrorExcept					; IRQ level 5
	jmp	VBlankInt					; V-BLANK interrupt
	jmp	ErrorExcept					; IRQ level 7
	
	jmp	ErrorExcept					; TRAP #00 exception
	jmp	ErrorExcept					; TRAP #01 exception
	jmp	ErrorExcept					; TRAP #02 exception
	jmp	ErrorExcept					; TRAP #03 exception
	jmp	ErrorExcept					; TRAP #04 exception
	jmp	ErrorExcept					; TRAP #05 exception
	jmp	ErrorExcept					; TRAP #06 exception
	jmp	ErrorExcept					; TRAP #07 exception
	jmp	ErrorExcept					; TRAP #08 exception
	jmp	ErrorExcept					; TRAP #09 exception
	jmp	ErrorExcept					; TRAP #10 exception
	jmp	ErrorExcept					; TRAP #11 exception
	jmp	ErrorExcept					; TRAP #12 exception
	jmp	ErrorExcept					; TRAP #13 exception
	jmp	ErrorExcept					; TRAP #14 exception
	jmp	ErrorExcept					; TRAP #15 exception
	
	rept 16							; Reserved
		jmp	ErrorExcept
	endr

	rept 35							; Padding
		rts
	endr
	
; ------------------------------------------------------------------------------
; 32X progarm metadata
; ------------------------------------------------------------------------------

	dc.b	'MARS CHECK MODE '				; Module name
	dc.l	0						; Version
	dc.l	MarsProgram-$2000000				; Program ROM location
	dc.l	0						; Program write location
	dc.l	MarsProgramEnd-MarsProgram			; Program length
	dc.l	MasterInit					; Master SH-2 PC
	dc.l	SlaveInit					; Slave SH-2 PC
	dc.l	MasterVector					; Master SH-2 VBR
	dc.l	SlaveVector					; Slave SH-2 VBR

; ------------------------------------------------------------------------------
