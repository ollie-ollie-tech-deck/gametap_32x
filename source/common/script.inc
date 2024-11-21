; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Script functions header
; ------------------------------------------------------------------------------

	global InitScript
	global StartScript
	global UnpauseScript
	global UpdateScript
	global UpdateScriptTextbox
	global DrawScriptTextbox

; ------------------------------------------------------------------------------
; Flags
; ------------------------------------------------------------------------------

	rsreset
SCRIPT_SHOW_TEXTBOX_FLAG	rs.b 1				; Show textbox flag
SCRIPT_CLEAR_TEXTBOX_FLAG	rs.b 1				; Clear textbox flag
SCRIPT_TEXTBOX_DRAWN_FLAG	rs.b 1				; Textbox drawn flag
SCRIPT_DRAW_ICON_FLAG		rs.b 1				; Draw icon flag
SCRIPT_DRAW_TEXT_FLAG		rs.b 1				; Draw text flag
SCRIPT_SELECTION_FLAG		rs.b 1				; Textbox selection flag
SCRIPT_WAIT_INPUT_FLAG		rs.b 1				; Wait input flag
SCRIPT_PAUSE_FLAG		rs.b 1				; Pause flag

; ------------------------------------------------------------------------------
; Define macro ID
; ------------------------------------------------------------------------------

__script_macro_id = 0

SCRIPT_MACRO_ID macro name
	\name\:	equ __script_macro_id
	__script_macro_id: = __script_macro_id+1
	endm

; ------------------------------------------------------------------------------
; End of script command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_END

SCRIPT_END macro
	dc.b	SCRIPT_ID_END
	even
	endm

; ------------------------------------------------------------------------------
; Pause script command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_PAUSE
	
SCRIPT_PAUSE macro
	dc.b	SCRIPT_ID_PAUSE
	endm

; ------------------------------------------------------------------------------
; End frame command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_FRAME_END
	
SCRIPT_END_FRAME macro
	dc.b	SCRIPT_ID_FRAME_END
	endm

; ------------------------------------------------------------------------------
; Show textbox command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_SHOW_TEXTBOX
	
SCRIPT_SHOW_TEXTBOX macro
	dc.b	SCRIPT_ID_SHOW_TEXTBOX
	endm

; ------------------------------------------------------------------------------
; Hide textbox command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_HIDE_TEXTBOX
	
SCRIPT_HIDE_TEXTBOX macro
	dc.b	SCRIPT_ID_HIDE_TEXTBOX
	endm
	
; ------------------------------------------------------------------------------
; Clear textbox command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_CLEAR_TEXTBOX
	
SCRIPT_CLEAR_TEXTBOX macro
	dc.b	SCRIPT_ID_CLEAR_TEXTBOX
	endm

; ------------------------------------------------------------------------------
; Set textbox icon command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	data - Icon data address
;	anim - Animation ID
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_ICON
	
SCRIPT_ICON macro data, anim
	dc.b	SCRIPT_ID_ICON
	dc.l	\data
	dc.b	\anim
	endm

; ------------------------------------------------------------------------------
; Clear textbox icon command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_CLEAR_ICON
	
SCRIPT_CLEAR_ICON macro
	dc.b	SCRIPT_ID_CLEAR_ICON
	endm

; ------------------------------------------------------------------------------
; Icon animation speed command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	speed - Icon speed
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_ICON_SPEED
	
SCRIPT_ICON_SPEED macro speed
	dc.b	SCRIPT_ID_ICON_SPEED
	dc.w	\speed
	endm

; ------------------------------------------------------------------------------
; Reset icon animation speed command
; ------------------------------------------------------------------------------
	
SCRIPT_RESET_ICON_SPEED macro
	SCRIPT_ICON_SPEED -1
	endm

; ------------------------------------------------------------------------------
; Text command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_TEXT
	
SCRIPT_TEXT macro
	dc.b	SCRIPT_ID_TEXT
	rept narg
		i: = 1
		while i<=strlen(\1)
			c: substr i,i,\1
			if '\c'='\'
				i: = i+1
				c: substr i,i,\1
				if '\c'='\'
					dc.b	'\c'
				elseif '\c'='n'
					dc.b	-1
				endif
			else
				dc.b	'\c'
			endif
			i: = i+1
		endw
		shift
	endr
	dc.b	0
	endm

; ------------------------------------------------------------------------------
; Text speed command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	speed - Text speed
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_TEXT_SPEED
	
SCRIPT_TEXT_SPEED macro speed
	dc.b	SCRIPT_ID_TEXT_SPEED
	dc.w	\speed
	endm

; ------------------------------------------------------------------------------
; Reset text speed command
; ------------------------------------------------------------------------------

SCRIPT_RESET_TEXT_SPEED macro
	SCRIPT_TEXT_SPEED $100
	endm

; ------------------------------------------------------------------------------
; Delay command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	time - Delay time
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_DELAY
	
SCRIPT_DELAY macro time
	dc.b	SCRIPT_ID_DELAY
	dc.w	\time
	endm

; ------------------------------------------------------------------------------
; Wait for input command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_WAIT_INPUT
	
SCRIPT_WAIT_INPUT macro
	dc.b	SCRIPT_ID_WAIT_INPUT
	endm

; ------------------------------------------------------------------------------
; Jump command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP
	
SCRIPT_JUMP macro addr
	dc.b	SCRIPT_ID_JUMP
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Call command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Call address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_CALL
	
SCRIPT_CALL macro addr
	dc.b	SCRIPT_ID_CALL
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Return command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_RETURN
	
SCRIPT_RETURN macro addr
	dc.b	SCRIPT_ID_RETURN
	even
	endm

; ------------------------------------------------------------------------------
; Call 68000 function command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Call address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_CALL_M68K
	
SCRIPT_CALL_M68K macro addr
	dc.b	SCRIPT_ID_CALL_M68K
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Set byte value command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr1 - Address to read from
;	addr2 - Address to write to
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_SET_BYTE
	
SCRIPT_SET_BYTE macro addr1, addr2
	dc.b	SCRIPT_ID_SET_BYTE
	dc.l	\addr1
	dc.l	\addr2
	endm

; ------------------------------------------------------------------------------
; Set word value command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr1 - Address to read from
;	addr2 - Address to write to
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_SET_WORD
	
SCRIPT_SET_WORD macro addr1, addr2
	dc.b	SCRIPT_ID_SET_WORD
	dc.l	\addr1
	dc.l	\addr2
	endm

; ------------------------------------------------------------------------------
; Set longword value command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr1 - Address to read from
;	addr2 - Address to write to
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_SET_LONG
	
SCRIPT_SET_LONG macro addr1, addr2
	dc.b	SCRIPT_ID_SET_LONG
	dc.l	\addr1
	dc.l	\addr2
	endm

; ------------------------------------------------------------------------------
; Set bit command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Address to set bit at
;	bit  - Bit to set
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_SET_BIT
	
SCRIPT_SET_BIT macro addr, bit
	dc.b	SCRIPT_ID_SET_BIT
	dc.l	\addr
	dc.b	\bit
	endm

; ------------------------------------------------------------------------------
; Clear bit command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Address to clear bit at
;	bit  - Bit to clear
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_CLEAR_BIT
	
SCRIPT_CLEAR_BIT macro addr, bit
	dc.b	SCRIPT_ID_CLEAR_BIT
	dc.l	\addr
	dc.b	\bit
	endm

; ------------------------------------------------------------------------------
; Set number byte value command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr  - Address to set value at
;	value - Value to set
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_SET_NUMBER_BYTE
	
SCRIPT_SET_NUMBER_BYTE macro addr, value
	dc.b	SCRIPT_ID_SET_NUMBER_BYTE
	dc.l	\addr
	dc.b	\value
	endm

; ------------------------------------------------------------------------------
; Set number word value command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr  - Address to set value at
;	value - Value to set
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_SET_NUMBER_WORD
	
SCRIPT_SET_NUMBER_WORD macro addr, value
	dc.b	SCRIPT_ID_SET_NUMBER_WORD
	dc.l	\addr
	dc.w	\value
	endm

; ------------------------------------------------------------------------------
; Set number longword value command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr  - Address to set value at
;	value - Value to set
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_SET_NUMBER_LONG
	
SCRIPT_SET_NUMBER_LONG macro addr, value
	dc.b	SCRIPT_ID_SET_NUMBER_LONG
	dc.l	\addr
	dc.l	\value
	endm

; ------------------------------------------------------------------------------
; Test byte value command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr  - Address to test value at
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_TEST_BYTE
	
SCRIPT_TEST_BYTE macro addr
	dc.b	SCRIPT_ID_TEST_BYTE
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Test word value command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr  - Address to test value at
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_TEST_WORD
	
SCRIPT_TEST_WORD macro addr
	dc.b	SCRIPT_ID_TEST_WORD
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Test longword value command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr  - Address to test value at
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_TEST_LONG
	
SCRIPT_TEST_LONG macro addr
	dc.b	SCRIPT_ID_TEST_LONG
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Test bit command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Address to test bit at
;	bit  - Bit to test
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_TEST_BIT
	
SCRIPT_TEST_BIT macro addr, bit
	dc.b	SCRIPT_ID_TEST_BIT
	dc.l	\addr
	dc.b	\bit
	endm

; ------------------------------------------------------------------------------
; Compare byte values command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr  - Address of source value
;	value - Destination value
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_COMPARE_BYTE
	
SCRIPT_COMPARE_BYTE macro addr, value
	dc.b	SCRIPT_ID_COMPARE_BYTE
	dc.l	\addr
	dc.b	\value
	endm

; ------------------------------------------------------------------------------
; Compare word values command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr  - Address of source value
;	value - Destination value
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_COMPARE_WORD
	
SCRIPT_COMPARE_WORD macro addr, value
	dc.b	SCRIPT_ID_COMPARE_WORD
	dc.l	\addr
	dc.w	\value
	endm

; ------------------------------------------------------------------------------
; Compare longword values command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr  - Address of source value
;	value - Destination value
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_COMPARE_LONG
	
SCRIPT_COMPARE_LONG macro addr, value
	dc.b	SCRIPT_ID_COMPARE_LONG
	dc.l	\addr
	dc.l	\value
	endm

; ------------------------------------------------------------------------------
; Jump if equal command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_EQUAL
	
SCRIPT_JUMP_EQUAL macro addr
	dc.b	SCRIPT_ID_JUMP_EQUAL
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if not equal command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_NOT_EQUAL
	
SCRIPT_JUMP_NOT_EQUAL macro addr
	dc.b	SCRIPT_ID_JUMP_NOT_EQUAL
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if zero command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

SCRIPT_JUMP_ZERO macro addr
	SCRIPT_JUMP_EQUAL \addr
	endm

; ------------------------------------------------------------------------------
; Jump if not zero command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

SCRIPT_JUMP_NOT_ZERO macro addr
	SCRIPT_JUMP_NOT_EQUAL \addr
	endm

; ------------------------------------------------------------------------------
; Jump if clear command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

SCRIPT_JUMP_CLEAR macro addr
	SCRIPT_JUMP_EQUAL \addr
	endm

; ------------------------------------------------------------------------------
; Jump if set command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

SCRIPT_JUMP_SET macro addr
	SCRIPT_JUMP_NOT_EQUAL \addr
	endm

; ------------------------------------------------------------------------------
; Jump if greater (unsigned) command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_HIGHER
	
SCRIPT_JUMP_HIGHER macro addr
	dc.b	SCRIPT_ID_JUMP_HIGHER
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if greater or equal (unsigned) command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_HIGHER_SAME
	
SCRIPT_JUMP_HIGHER_SAME macro addr
	dc.b	SCRIPT_ID_JUMP_HIGHER_SAME
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if less (unsigned) command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_LOWER
	
SCRIPT_JUMP_LOWER macro addr
	dc.b	SCRIPT_ID_JUMP_LOWER
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if less or equal (unsigned) command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_LOWER_SAME
	
SCRIPT_JUMP_LOWER_SAME macro addr
	dc.b	SCRIPT_ID_JUMP_LOWER_SAME
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if greater (signed) command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_GREATER
	
SCRIPT_JUMP_GREATER macro addr
	dc.b	SCRIPT_ID_JUMP_GREATER
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if greater or equal (signed) command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_GREATER_EQUAL
	
SCRIPT_JUMP_GREATER_EQUAL macro addr
	dc.b	SCRIPT_ID_JUMP_GREATER_EQUAL
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if less (signed) command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_LESS
	
SCRIPT_JUMP_LESS macro addr
	dc.b	SCRIPT_ID_JUMP_LESS
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if less or equal (signed) command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_LESS_EQUAL
	
SCRIPT_JUMP_LESS_EQUAL macro addr
	dc.b	SCRIPT_ID_JUMP_LESS_EQUAL
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if overflown command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_VS
	
SCRIPT_JUMP_VS macro addr
	dc.b	SCRIPT_ID_JUMP_VS
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if not overflown command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_VC
	
SCRIPT_JUMP_VC macro addr
	dc.b	SCRIPT_ID_JUMP_VC
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if negative command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_MI
	
SCRIPT_JUMP_MI macro addr
	dc.b	SCRIPT_ID_JUMP_MI
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump if not negative command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_PL
	
SCRIPT_JUMP_PL macro addr
	dc.b	SCRIPT_ID_JUMP_PL
	dc.l	\addr
	endm

; ------------------------------------------------------------------------------
; Jump table with byte index command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Address of index value
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_TABLE_BYTE
	
__script_jump_table_id = 0

SCRIPT_JUMP_TABLE_BYTE macro addr
	__script_jump_table_count: = 0
	dc.b	SCRIPT_ID_JUMP_TABLE_BYTE
	dc.l	\addr
	dc.b	__script_jump_table_count_\#__script_jump_table_id
	endm

; ------------------------------------------------------------------------------
; Jump table with word index command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Address of index value
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_TABLE_WORD
	
SCRIPT_JUMP_TABLE_WORD macro addr
	__script_jump_table_count: = 0
	dc.b	SCRIPT_ID_JUMP_TABLE_WORD
	dc.l	\addr
	dc.b	__script_jump_table_count_\#__script_jump_table_id
	endm

; ------------------------------------------------------------------------------
; Jump table with longword index command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Address of index value
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_TABLE_LONG
	
SCRIPT_JUMP_TABLE_LONG macro addr
	__script_jump_table_count: = 0
	dc.b	SCRIPT_ID_JUMP_TABLE_LONG
	dc.l	\addr
	dc.b	__script_jump_table_count_\#__script_jump_table_id
	endm

; ------------------------------------------------------------------------------
; Jump table with random index command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_JUMP_TABLE_RANDOM
	
SCRIPT_JUMP_TABLE_RANDOM macro
	__script_jump_table_count: = 0
	dc.b	SCRIPT_ID_JUMP_TABLE_RANDOM
	dc.b	__script_jump_table_count_\#__script_jump_table_id
	endm

; ------------------------------------------------------------------------------
; Selection command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	opt1_text  - Option 1 text
;	opt1_jump - Option 1 jump address
;	opt2_text  - Option 2 text
;	opt2_jump - Option 2 jump address
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_PREPARE_SELECTION
	SCRIPT_MACRO_ID SCRIPT_ID_SELECTION
	
SCRIPT_SELECTION macro opt1_text, opt1_jump, opt2_text, opt2_jump
	.opt1_str: equs \opt1_text
	.opt2_str: equs \opt2_text
	dc.b	SCRIPT_ID_PREPARE_SELECTION
	SCRIPT_TEXT "\.opt1_str\\n\.opt2_str"
	dc.b	SCRIPT_ID_SELECTION
	SCRIPT_JUMP_TABLE_BYTE script_selection_id
	SCRIPT_JUMP_TABLE_ENTRY \opt1_jump
	SCRIPT_JUMP_TABLE_ENTRY \opt2_jump
	SCRIPT_JUMP_TABLE_END
	endm

; ------------------------------------------------------------------------------
; Jump table entry
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Jump table entry address
; ------------------------------------------------------------------------------

SCRIPT_JUMP_TABLE_ENTRY macro addr
	dc.l	\addr
	__script_jump_table_count: = __script_jump_table_count+1
	endm

; ------------------------------------------------------------------------------
; End of jump table
; ------------------------------------------------------------------------------

SCRIPT_JUMP_TABLE_END macro
	__script_jump_table_count_\#__script_jump_table_id: equ __script_jump_table_count
	__script_jump_table_id: = __script_jump_table_id+1
	endm

; ------------------------------------------------------------------------------
; Play PWM sample
; ------------------------------------------------------------------------------
; PARAMETERS:
;	sample - PWM sample play command
; ------------------------------------------------------------------------------

	SCRIPT_MACRO_ID SCRIPT_ID_PLAY_PWM
	
SCRIPT_PLAY_PWM macro sample
	dc.b	SCRIPT_ID_PLAY_PWM
	dc.w	\sample
	endm

; ------------------------------------------------------------------------------
; Set event bit command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	bit - Event bit to set
; ------------------------------------------------------------------------------

SCRIPT_SET_EVENT macro bit
	SCRIPT_SET_BIT event_flags+((\bit)/8), (\bit)&7
	endm

; ------------------------------------------------------------------------------
; Clear event bit command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	bit - Event bit to clear
; ------------------------------------------------------------------------------

SCRIPT_CLEAR_EVENT macro bit
	SCRIPT_CLEAR_BIT event_flags+((\bit)/8), (\bit)&7
	endm

; ------------------------------------------------------------------------------
; Check event bit command
; ------------------------------------------------------------------------------
; PARAMETERS:
;	bit - Event bit to check
; ------------------------------------------------------------------------------

SCRIPT_CHECK_EVENT macro bit
	SCRIPT_TEST_BIT event_flags+((\bit)/8), (\bit)&7
	endm

; ------------------------------------------------------------------------------
