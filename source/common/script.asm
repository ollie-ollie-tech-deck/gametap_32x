; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Script functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/shared.inc"
	
; ------------------------------------------------------------------------------
; Initialize scripting
; ------------------------------------------------------------------------------

InitScript:
	clr.l	script_address					; Clear script address
	clr.b	script_flags					; Clear flags
	rts

; ------------------------------------------------------------------------------
; Start script
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Script address
; ------------------------------------------------------------------------------

StartScript:
	tst.l	script_address					; Is a script already running?
	bne.s	.End						; If so, branch
	move.l	a0,script_address				; Set script address

	clr.b	script_flags					; Clear flags
	clr.w	script_delay_time				; Reset delay time
	clr.b	script_text_sound_time				; Reset text sound time
	move.b	#7,script_text_sound_id				; Reset text sound ID

	move.l	#script_call_stack_base,script_call_stack_addr	; Reset call stack address

	move.w	#$100,script_text_speed_value			; Reset text speed
	clr.w	script_text_speed_count
	clr.l	script_icon_anim+anim.script			; Reset textbox icon animation

	bra.w	ScriptClearTextbox				; Clear textbox

.End:
	rts

; ------------------------------------------------------------------------------
; Unpause script
; ------------------------------------------------------------------------------

UnpauseScript:
	bclr	#SCRIPT_PAUSE_FLAG,script_flags			; Unpause script
	rts

; ------------------------------------------------------------------------------
; Update script
; ------------------------------------------------------------------------------

UpdateScript:
	move.l	script_address,d0				; Are we updating a script?
	bne.s	.GotScript					; If so, branch

.End:
	rts

.GotScript:
	movea.l	d0,a0						; Get script address
	
	btst	#SCRIPT_PAUSE_FLAG,script_flags			; Is the script paused?
	bne.s	.End						; If so, branch

	tst.b	script_text_sound_time				; Should we decrement the text sound time?
	beq.s	.NoTextSound					; If not, branch
	subq.b	#1,script_text_sound_time			; Decrement it

.NoTextSound:
	tst.w	script_delay_time				; Are we currently delaying?
	beq.s	.NoDelay					; If not, branch
	subq.w	#1,script_delay_time				; Decrement delay time
	bne.s	.End						; If we aren't finished, branch

.NoDelay:
	btst	#SCRIPT_SELECTION_FLAG,script_flags		; Are we currently selecting an option?
	beq.s	.NoSelection					; If not, branch

	move.b	p1_ctrl_tap,d0					; Has up or down been pressed?
	andi.b	#BUTTON_UP|BUTTON_DOWN,d0
	beq.s	.NoSelection					; If not, branch

	eori.b	#1,script_selection_id				; Swap selection
	move.w	#$BB0C,MARS_COMM_14+MARS_SYS			; Play sound

.NoSelection:
	btst	#SCRIPT_WAIT_INPUT_FLAG,script_flags		; Are we currently waiting for input?
	beq.s	.NoInputWait					; If not, branch

	btst	#BUTTON_A_BIT,p1_ctrl_tap			; Has the A button been pressed?
	beq.s	.End						; If not, branch

	bclr	#SCRIPT_SELECTION_FLAG,script_flags		; No longer selecting
	beq.s	.ClearWaitInput					; If we weren't selecting to begin with, branch
	
	move.w	#$FF0D,MARS_COMM_14+MARS_SYS			; Play sound

.ClearWaitInput:
	bclr	#SCRIPT_WAIT_INPUT_FLAG,script_flags		; No longer waiting for input

.NoInputWait:
	btst	#SCRIPT_DRAW_TEXT_FLAG,script_flags		; Are we currently drawing text?
	beq.w	ScriptCommand					; If not, branch

; ------------------------------------------------------------------------------

UpdateScriptText:
	btst	#SCRIPT_TEXTBOX_DRAWN_FLAG,script_flags		; Is the textbox drawn?
	beq.s	.End						; If not, branch

	move.w	script_text_speed_value,d0			; Update speed counter
	add.w	d0,script_text_speed_count
	tst.b	script_text_speed_count				; Has it overflown?
	beq.s	.End						; If not, branch
	clr.b	script_text_speed_count				; Reset speed counter integer

	move.b	(a0)+,d0					; Get character
	beq.s	.TextDone					; If we are done, branch
	bmi.s	.NewLine					; If we are doing a new line, branch

	cmpi.b	#' ',d0						; Is it a space?
	beq.s	.NoSound					; If so, branch
	
	tst.b	script_text_sound_time				; Is it okay to play the sound?
	bne.s	.NoSound					; If not, branch
	move.b	#3,script_text_sound_time			; Reset text sound time

	move.w	#$8800,d1					; Play sound
	move.b	script_text_sound_id,d1
	move.w	d1,MARS_COMM_12+MARS_SYS

.NoSound:
	move.b	d0,script_text_char				; Queue character for drawing
	move.l	script_text_cur_cmd,script_text_draw_cmd	; Set character draw VDP command
	addq.w	#2,script_text_cur_cmd				; Next space
	
.End:
	move.l	a0,script_address				; Update script address
	rts

.NewLine:
	move.l	script_text_line_cmd,d0				; New line
	move.l	plane_stride,d1
	add.l	d1,d0
	add.l	d1,d0
	move.l	d0,script_text_line_cmd
	move.l	d0,script_text_cur_cmd
	bra.s	UpdateScriptText

.TextDone:
	bclr	#SCRIPT_DRAW_TEXT_FLAG,script_flags		; No longer drawing text

; ------------------------------------------------------------------------------

ScriptCommand:
	pea	.FrameEnd(pc)					; Push frame end address

.Loop:
	moveq	#0,d0						; Run command
	move.b	(a0)+,d0
	add.w	d0,d0
	add.w	d0,d0
	jsr	.Commands(pc,d0.w)

	bra.s	.Loop						; Loop

.FrameEnd:
	move.l	a0,script_address				; Update script address
	rts

; ------------------------------------------------------------------------------

.Commands:
	bra.w	ScriptEnd					; End of script
	bra.w	ScriptPause					; Pause script
	bra.w	ScriptEndFrame					; End frame
	bra.w	ScriptShowTextbox				; Show textbox
	bra.w	ScriptHideTextbox				; Hide textbox
	bra.w	ScriptClearTextbox				; Clear textbox
	bra.w	ScriptSetIcon					; Set icon
	bra.w	ScriptClearIcon					; Clear icon
	bra.w	ScriptIconSpeed					; Set icon speed
	bra.w	ScriptText					; Draw text
	bra.w	ScriptTextSpeed					; Set text speed
	bra.w	ScriptDelay					; Delay
	bra.w	ScriptWaitInput					; Wait for input
	bra.w	ScriptJump					; Jump
	bra.w	ScriptCall					; Call
	bra.w	ScriptReturn					; Return
	bra.w	ScriptCallM68k					; Call 68000 function
	bra.w	ScriptSetByte					; Set byte value
	bra.w	ScriptSetWord					; Set word value
	bra.w	ScriptSetLong					; Set longword value
	bra.w	ScriptSetBit					; Set bit
	bra.w	ScriptClearBit					; Clear bit
	bra.w	ScriptSetNumberByte				; Set number byte value
	bra.w	ScriptSetNumberWord				; Set number word value
	bra.w	ScriptSetNumberLong				; Set number longword value
	bra.w	ScriptTestByte					; Test byte value
	bra.w	ScriptTestWord					; Test word value
	bra.w	ScriptTestLong					; Test longword value
	bra.w	ScriptTestBit					; Test bit value
	bra.w	ScriptCompareByte				; Compare byte values
	bra.w	ScriptCompareWord				; Compare word values
	bra.w	ScriptCompareLong				; Compare longword values
	bra.w	ScriptJumpEqual					; Jump if equal
	bra.w	ScriptJumpNotEqual				; Jump if not equal
	bra.w	ScriptJumpGreaterUnsigned			; Jump if greater (unsigned)
	bra.w	ScriptJumpGreaterEqualUnsigned			; Jump if greater or equal (unsigned)
	bra.w	ScriptJumpLessUnsigned				; Jump if less (unsigned)
	bra.w	ScriptJumpLessEqualUnsigned			; Jump if less or equal (unsigned)
	bra.w	ScriptJumpGreaterSigned				; Jump if greater (signed)
	bra.w	ScriptJumpGreaterEqualSigned			; Jump if greater or equal (signed)
	bra.w	ScriptJumpLessSigned				; Jump if less (signed)
	bra.w	ScriptJumpLessEqualSigned			; Jump if less or equal (signed)
	bra.w	ScriptJumpOverflow				; Jump if overflown
	bra.w	ScriptJumpNotOverflow				; Jump if not overflown
	bra.w	ScriptJumpNegative				; Jump if negative
	bra.w	ScriptJumpNotNegative				; Jump if not negative
	bra.w	ScriptJumpTableByte				; Jump table with byte index
	bra.w	ScriptJumpTableWord				; Jump table with word index
	bra.w	ScriptJumpTableLong				; Jump table with longword index
	bra.w	ScriptJumpTableRandom				; Jump table with random index
	bra.w	ScriptPrepareSelection				; Prepare selection
	bra.w	ScriptSelection					; Selection
	bra.w	ScriptPlayPwm					; Play PWM sample

; ------------------------------------------------------------------------------
; Read longword from script
; ------------------------------------------------------------------------------
; RETURNS:
;	d0.w - Read longword
; ------------------------------------------------------------------------------

ReadScriptLong:
	bsr.s	ReadScriptWord					; Read top word
	swap	d0						; Read bottom word

; ------------------------------------------------------------------------------
; Read word from script
; ------------------------------------------------------------------------------
; RETURNS:
;	d0.w - Read word
; ------------------------------------------------------------------------------

ReadScriptWord:
	move.b	(a0)+,-(sp)					; Get word
	move.w	(sp)+,d0
	move.b	(a0)+,d0
	rts

; ------------------------------------------------------------------------------
; End of script command
; ------------------------------------------------------------------------------

ScriptEnd:
	bsr.s	ScriptHideTextbox				; Hide textbox
	clr.l	script_address					; Exit script
	addq.w	#8,sp
	rts

; ------------------------------------------------------------------------------
; Pause script command
; ------------------------------------------------------------------------------

ScriptPause:
	bset	#SCRIPT_PAUSE_FLAG,script_flags			; Pause script

; ------------------------------------------------------------------------------
; End frame command
; ------------------------------------------------------------------------------

ScriptEndFrame:
	addq.w	#4,sp						; Exit script for this frame
	rts

; ------------------------------------------------------------------------------
; Show textbox command
; ------------------------------------------------------------------------------

ScriptShowTextbox:
	bset	#SCRIPT_SHOW_TEXTBOX_FLAG,script_flags		; Show textbox
	rts

; ------------------------------------------------------------------------------
; Hide textbox command
; ------------------------------------------------------------------------------

ScriptHideTextbox:
	bclr	#SCRIPT_SHOW_TEXTBOX_FLAG,script_flags		; Hide textbox
	rts

; ------------------------------------------------------------------------------
; Clear textbox command
; ------------------------------------------------------------------------------

ScriptClearTextbox:
	bset	#SCRIPT_CLEAR_TEXTBOX_FLAG,script_flags		; Clear textbox

	VDP_CMD move.l,$DA02,VRAM,WRITE,d0			; Reset VDP commands
	btst	#SCRIPT_DRAW_ICON_FLAG,script_flags
	beq.s	.NoIcon
	VDP_CMD move.l,$DA10,VRAM,WRITE,d0

.NoIcon:
	move.l	d0,script_text_line_cmd
	move.l	d0,script_text_cur_cmd
	rts

; ------------------------------------------------------------------------------
; Set icon command
; ------------------------------------------------------------------------------

ScriptSetIcon:
	bset	#SCRIPT_DRAW_ICON_FLAG,script_flags		; Draw icon
	bne.s	.NoClear					; If the icon is already shown, branch
	bsr.s	ScriptClearTextbox				; Clear textbox

.NoClear:
	bsr.w	ReadScriptLong					; Get icon data
	movea.l	d0,a1

	move.l	(a1)+,script_icon_sprites			; Set sprites address

	move.w	(a1)+,d0					; Set CRAM index
	move.b	d0,script_icon_cram

	move.l	(a1)+,d1					; Load palette
	beq.s	.SkipPalette
	move.l	a1,-(sp)
	move.l	d1,-(sp)
	move.b	d0,-(sp)
	move.b	#0,-(sp)
	jsr	LoadMarsPalette
	movea.l	(sp)+,a1

.SkipPalette:
	moveq	#0,d0						; Set animation
	move.b	(a0)+,d0
	move.l	a0,-(sp)
	lea	script_icon_anim,a0
	jsr	SetAnimation
	movea.l	(sp)+,a0
	rts
	
; ------------------------------------------------------------------------------
; Clear icon command
; ------------------------------------------------------------------------------

ScriptClearIcon:
	bclr	#SCRIPT_DRAW_ICON_FLAG,script_flags		; Hide icon
	beq.s	.NoClear					; If the icon is already hidden, branch
	bsr.w	ScriptClearTextbox				; Clear textbox

.NoClear:
	clr.l	script_icon_anim+anim.script			; Reset icon animation
	rts

; ------------------------------------------------------------------------------
; Icon animation speed command
; ------------------------------------------------------------------------------

ScriptIconSpeed:
	move.b	(a0)+,-(sp)					; Get animation speed
	move.w	(sp)+,d0
	move.b	(a0)+,d0

	tst.w	d0						; Should we reset it?
	bpl.s	.SetSpeed					; If not, branch

	move.l	script_icon_anim+anim.script,d1			; Get animation script
	beq.s	.SetDefault					; If it's not set, branch
	movea.l	d1,a1

	move.w	script_icon_anim+anim.id,d0			; Get animation data
	add.w	d0,d0
	adda.w	(a1,d0.w),a1
	
	move.w	anim_head.speed(a1),d1				; Get animation speed

	tst.w	d1						; Is the animation speed set externally?
	bmi.s	.SetDefault					; If so, branch
	move.w	d1,d0						; Set animation speed

.SetSpeed:
	move.w	d0,script_icon_anim+anim.speed			; Set animation speed
	rts

.SetDefault:
	move.w	#$100,d0					; Set default animation speed
	bra.s	.SetSpeed

; ------------------------------------------------------------------------------
; Text command
; ------------------------------------------------------------------------------

ScriptText:
	bset	#SCRIPT_DRAW_TEXT_FLAG,script_flags		; Start drawing text
	move.w	#2,script_delay_time
	addq.w	#4,sp
	rts

; ------------------------------------------------------------------------------
; Text speed command
; ------------------------------------------------------------------------------

ScriptTextSpeed:
	move.b	(a0)+,-(sp)					; Get text speed
	move.w	(sp)+,d0
	move.b	(a0)+,d0

	tst.w	d0						; Is it too small?
	beq.s	.End						; If so, branch
	cmpi.w	#$100,d0					; Is it too large?
	bhi.s	.End						; If so, branch

	move.w	d0,script_text_speed_value			; Set text speed

.End:
	rts

; ------------------------------------------------------------------------------
; Delay command
; ------------------------------------------------------------------------------

ScriptDelay:
	move.b	(a0)+,script_delay_time				; Set delay time
	move.b	(a0)+,script_delay_time+1
	addq.w	#4,sp
	rts

; ------------------------------------------------------------------------------
; Wait for input command
; ------------------------------------------------------------------------------

ScriptWaitInput:
	bset	#SCRIPT_WAIT_INPUT_FLAG,script_flags		; Wait for input
	addq.w	#4,sp
	rts

; ------------------------------------------------------------------------------
; Jump command
; ------------------------------------------------------------------------------

ScriptJump:
	bsr.w	ReadScriptLong					; Jump to address
	movea.l	d0,a0
	rts

; ------------------------------------------------------------------------------
; Call command
; ------------------------------------------------------------------------------

ScriptCall:
	bsr.w	ReadScriptLong					; Get call address

	movea.l	script_call_stack_addr,a1			; Push return address
	move.l	a0,-(a1)
	move.l	a1,script_call_stack_addr

	movea.l	d0,a0						; Jump to call address
	rts

; ------------------------------------------------------------------------------
; Return command
; ------------------------------------------------------------------------------

ScriptReturn:
	movea.l	script_call_stack_addr,a1			; Pop return address
	movea.l	(a1)+,a0
	move.l	a1,script_call_stack_addr
	rts

; ------------------------------------------------------------------------------
; Call 68000 function command
; ------------------------------------------------------------------------------

ScriptCallM68k:
	bsr.w	ReadScriptLong					; Call function
	move.l	a0,-(sp)
	movea.l	d0,a1
	jsr	(a1)
	movea.l	(sp)+,a0
	rts

; ------------------------------------------------------------------------------
; Set byte value command
; ------------------------------------------------------------------------------

ScriptSetByte:
	bsr.w	ReadScriptLong					; Set value
	movea.l	d0,a1
	bsr.w	ReadScriptLong
	movea.l	d0,a2
	move.b	(a1),(a2)
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Set word value command
; ------------------------------------------------------------------------------

ScriptSetWord:
	bsr.w	ReadScriptLong					; Set value
	movea.l	d0,a1
	bsr.w	ReadScriptLong
	movea.l	d0,a2
	move.w	(a1),(a2)
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Set longword value command
; ------------------------------------------------------------------------------

ScriptSetLong:
	bsr.w	ReadScriptLong					; Set value
	movea.l	d0,a1
	bsr.w	ReadScriptLong
	movea.l	d0,a2
	move.l	(a1),(a2)
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Set bit command
; ------------------------------------------------------------------------------

ScriptSetBit:
	bsr.w	ReadScriptLong					; Set bit
	movea.l	d0,a1
	move.b	(a0)+,d0
	bset	d0,(a1)
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Clear bit command
; ------------------------------------------------------------------------------

ScriptClearBit:
	bsr.w	ReadScriptLong					; Clear bit
	movea.l	d0,a1
	move.b	(a0)+,d0
	bclr	d0,(a1)
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Set number byte value command
; ------------------------------------------------------------------------------

ScriptSetNumberByte:
	bsr.w	ReadScriptLong					; Set value
	movea.l	d0,a1
	move.b	(a0)+,d0
	move.b	d0,(a1)
	rts

; ------------------------------------------------------------------------------
; Set number word value command
; ------------------------------------------------------------------------------

ScriptSetNumberWord:
	bsr.w	ReadScriptLong					; Set value
	movea.l	d0,a1
	bsr.w	ReadScriptWord
	move.w	d0,(a1)
	rts

; ------------------------------------------------------------------------------
; Set number longword value command
; ------------------------------------------------------------------------------

ScriptSetNumberLong:
	bsr.w	ReadScriptLong					; Set value
	movea.l	d0,a1
	bsr.w	ReadScriptLong
	move.l	d0,(a1)
	rts

; ------------------------------------------------------------------------------
; Test byte value command
; ------------------------------------------------------------------------------

ScriptTestByte:
	bsr.w	ReadScriptLong					; Test value
	movea.l	d0,a1
	tst.b	(a1)
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Test word value command
; ------------------------------------------------------------------------------

ScriptTestWord:
	bsr.w	ReadScriptLong					; Test value
	movea.l	d0,a1
	tst.w	(a1)
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Test longword value command
; ------------------------------------------------------------------------------

ScriptTestLong:
	bsr.w	ReadScriptLong					; Test value
	movea.l	d0,a1
	tst.l	(a1)
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Test bit command
; ------------------------------------------------------------------------------

ScriptTestBit:
	bsr.w	ReadScriptLong					; Test bit
	movea.l	d0,a1
	move.b	(a0)+,d0
	btst	d0,(a1)
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Compare byte values command
; ------------------------------------------------------------------------------

ScriptCompareByte:
	bsr.w	ReadScriptLong					; Compare values
	movea.l	d0,a1
	move.b	(a0)+,d0
	move.b	(a1),d1
	cmp.b	d0,d1
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Compare word values command
; ------------------------------------------------------------------------------

ScriptCompareWord:
	bsr.w	ReadScriptLong					; Compare values
	movea.l	d0,a1
	bsr.w	ReadScriptWord
	move.w	(a1),d1
	cmp.w	d0,d1
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Compare longword values command
; ------------------------------------------------------------------------------

ScriptCompareLong:
	bsr.w	ReadScriptLong					; Compare values
	movea.l	d0,a1
	bsr.w	ReadScriptLong
	move.l	(a1),d1
	cmp.l	d0,d1
	move	sr,d0
	move.b	d0,script_condition_flags
	rts

; ------------------------------------------------------------------------------
; Jump if equal command
; ------------------------------------------------------------------------------

ScriptJumpEqual:
	bsr.w	ReadScriptLong					; Jump to address if equal
	move.b	script_condition_flags,d1
	move	d1,ccr
	bne.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if not equal command
; ------------------------------------------------------------------------------

ScriptJumpNotEqual:
	bsr.w	ReadScriptLong					; Jump to address if not equal
	move.b	script_condition_flags,d1
	move	d1,ccr
	beq.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if greater (unsigned) command
; ------------------------------------------------------------------------------

ScriptJumpGreaterUnsigned:
	bsr.w	ReadScriptLong					; Jump to address if greater
	move.b	script_condition_flags,d1
	move	d1,ccr
	bls.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if greater or equal (unsigned) command
; ------------------------------------------------------------------------------

ScriptJumpGreaterEqualUnsigned:
	bsr.w	ReadScriptLong					; Jump to address if greater or equal
	move.b	script_condition_flags,d1
	move	d1,ccr
	bcs.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if less (unsigned) command
; ------------------------------------------------------------------------------

ScriptJumpLessUnsigned:
	bsr.w	ReadScriptLong					; Jump to address if less
	move.b	script_condition_flags,d1
	move	d1,ccr
	bcc.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if less or equal (unsigned) command
; ------------------------------------------------------------------------------

ScriptJumpLessEqualUnsigned:
	bsr.w	ReadScriptLong					; Jump to address if less or equal
	move.b	script_condition_flags,d1
	move	d1,ccr
	bhi.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if greater (signed) command
; ------------------------------------------------------------------------------

ScriptJumpGreaterSigned:
	bsr.w	ReadScriptLong					; Jump to address if greater
	move.b	script_condition_flags,d1
	move	d1,ccr
	ble.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if greater or equal (signed) command
; ------------------------------------------------------------------------------

ScriptJumpGreaterEqualSigned:
	bsr.w	ReadScriptLong					; Jump to address if greater or equal
	move.b	script_condition_flags,d1
	move	d1,ccr
	blt.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if less (signed) command
; ------------------------------------------------------------------------------

ScriptJumpLessSigned:
	bsr.w	ReadScriptLong					; Jump to address if less
	move.b	script_condition_flags,d1
	move	d1,ccr
	bge.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if less or equal (signed) command
; ------------------------------------------------------------------------------

ScriptJumpLessEqualSigned:
	bsr.w	ReadScriptLong					; Jump to address if less or equal
	move.b	script_condition_flags,d1
	move	d1,ccr
	bgt.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if overflown command
; ------------------------------------------------------------------------------

ScriptJumpOverflow:
	bsr.w	ReadScriptLong					; Jump to address if overflown
	move.b	script_condition_flags,d1
	move	d1,ccr
	bvc.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if not overflown command
; ------------------------------------------------------------------------------

ScriptJumpNotOverflow:
	bsr.w	ReadScriptLong					; Jump to address if not overflown
	move.b	script_condition_flags,d1
	move	d1,ccr
	bvs.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if negative command
; ------------------------------------------------------------------------------

ScriptJumpNegative:
	bsr.w	ReadScriptLong					; Jump to address if negative
	move.b	script_condition_flags,d1
	move	d1,ccr
	bpl.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump if not negative command
; ------------------------------------------------------------------------------

ScriptJumpNotNegative:
	bsr.w	ReadScriptLong					; Jump to address if not negative
	move.b	script_condition_flags,d1
	move	d1,ccr
	bmi.s	.End
	movea.l	d0,a0

.End:
	rts

; ------------------------------------------------------------------------------
; Jump table with byte index command
; ------------------------------------------------------------------------------

ScriptJumpTableByte:
	bsr.w	ReadScriptLong					; Get table index
	movea.l	d0,a1
	moveq	#0,d0
	move.b	(a1),d0
	
; ------------------------------------------------------------------------------

ScriptJumpTableJump:
	moveq	#0,d1						; Keep index within table
	move.b	(a0)+,d1
	divu.w	d1,d0
	clr.w	d0
	swap	d0

	lsl.l	#2,d0						; Jump to indexed address
	adda.l	d0,a0
	bsr.w	ReadScriptLong
	movea.l	d0,a0	
	rts

; ------------------------------------------------------------------------------
; Jump table with word index command
; ------------------------------------------------------------------------------

ScriptJumpTableWord:
	bsr.w	ReadScriptLong					; Jump to indexed address
	movea.l	d0,a1
	moveq	#0,d0
	move.w	(a1),d0
	bra.s	ScriptJumpTableJump

; ------------------------------------------------------------------------------
; Jump table with longword index command
; ------------------------------------------------------------------------------

ScriptJumpTableLong:
	bsr.w	ReadScriptLong					; Jump to indexed address
	movea.l	d0,a1
	moveq	#0,d0
	move.w	2(a1),d0
	bra.s	ScriptJumpTableJump

; ------------------------------------------------------------------------------
; Jump table with random index command
; ------------------------------------------------------------------------------

ScriptJumpTableRandom:
	bsr.w	Random						; Jump to random indexed address
	andi.l	#$FFFF,d0
	bra.s	ScriptJumpTableJump

; ------------------------------------------------------------------------------
; Prepare selection command
; ------------------------------------------------------------------------------

ScriptPrepareSelection:
	VDP_CMD move.l,$DB04,VRAM,WRITE,d0			; Reset VDP commands
	btst	#SCRIPT_DRAW_ICON_FLAG,script_flags
	beq.s	.NoIcon
	VDP_CMD move.l,$DB12,VRAM,WRITE,d0

.NoIcon:
	move.l	d0,script_text_line_cmd
	move.l	d0,script_text_cur_cmd
	
	move.w	#$100,script_text_speed_value			; Reset text speed
	clr.w	script_text_speed_count

	clr.b	script_text_sound_id				; Don't play sound when drawing selection text
	rts

; ------------------------------------------------------------------------------
; Selection command
; ------------------------------------------------------------------------------

ScriptSelection:
	bset	#SCRIPT_WAIT_INPUT_FLAG,script_flags		; Enable selection
	bset	#SCRIPT_SELECTION_FLAG,script_flags
	clr.b	script_selection_id

	move.b	#7,script_text_sound_id				; Restore text sound ID
	addq.w	#4,sp
	rts

; ------------------------------------------------------------------------------
; Play PWM sample command
; ------------------------------------------------------------------------------

ScriptPlayPwm:
	bsr.w	ReadScriptWord					; Play sample
	move.w	d0,MARS_COMM_10+MARS_SYS
	rts

; ------------------------------------------------------------------------------
; Update script
; ------------------------------------------------------------------------------

UpdateScriptTextbox:
	bclr	#SCRIPT_CLEAR_TEXTBOX_FLAG,script_flags		; Should we clear the textbox?
	beq.s	.CheckShow					; If not, branch

	move.w	#$D980,d0					; Clear textbox
	move.l	#$480,d1
	bsr.w	ClearVramRegion

.CheckShow:
	move.b	script_textbox_switch,d0			; Is the textbox being switched on/off?
	move.b	script_flags,d1
	andi.b	#1<<SCRIPT_TEXTBOX_DRAWN_FLAG,d1
	cmp.b	d0,d1
	beq.s	.CheckText					; If not, branch
	move.b	d1,script_textbox_switch			; Mark textbox as switched

.Wait32X:
	tst.b	MARS_COMM_4+MARS_SYS				; Is the 32X still drawing?
	bne.s	.Wait32X					; If not, branch

.CheckTextboxVisible:
	move.w	#$9200,d0					; Textbox hidden setting
	btst	#SCRIPT_TEXTBOX_DRAWN_FLAG,script_flags		; Is the textbox drawn?
	beq.s	.SetTextboxVisible				; If not, branch
	move.w	#$9293,d0					; Textbox shown setting

.SetTextboxVisible:
	move.w	d0,VDP_CTRL					; Set textbox visibility

.CheckText:
	move.l	script_text_draw_cmd,d0				; Should we draw a character for the textbox?
	beq.s	.End						; If not, branch
	clr.l	script_text_draw_cmd				; Reset command

	move.w	#$8F80,VDP_CTRL					; Draw tiles vertically
	move.l	d0,VDP_CTRL					; Set VDP command

	moveq	#0,d0						; Draw character
	move.b	script_text_char,d0
	add.w	d0,d0
	add.w	script_text_tile,d0
	move.w	d0,VDP_DATA
	addq.w	#1,d0
	move.w	d0,VDP_DATA

	move.w	#$8F02,VDP_CTRL					; Restore VDP auto-increment

.End:
	rts

; ------------------------------------------------------------------------------
; Draw textbox
; ------------------------------------------------------------------------------

DrawScriptTextbox:
	btst	#SCRIPT_SHOW_TEXTBOX_FLAG,script_flags		; Is the textbox visible?
	bne.s	.Shown						; If so, branch
	bclr	#SCRIPT_TEXTBOX_DRAWN_FLAG,script_flags		; Textbox not drawn
	rts

.Shown:
	lea	.FramePieces(pc),a0				; Frame pieces
	moveq	#(.FramePiecesEnd-.FramePieces)/4-1,d1		; Number of frame pieces

	moveq	#0,d0						; Sprite set/No flip
	move.w	#152,d3						; Y position
	move.w	#$100,d4					; Unscaled

.DrawFramePieces:
	movem.w	d0/d1,-(sp)					; Draw frame piece
	move.b	d0,-(sp)
	move.w	(a0)+,d2
	move.b	d2,-(sp)
	move.b	d0,-(sp)
	move.w	(a0)+,-(sp)
	move.w	d3,-(sp)
	move.w	d4,-(sp)
	move.w	d4,-(sp)
	jsr	DrawLoadedMarsSprite
	movem.w	(sp)+,d0/d1

	dbf	d1,.DrawFramePieces				; Loop until all pieces are drawn

	btst	#SCRIPT_SELECTION_FLAG,script_flags		; Should we draw the selection frame?
	beq.s	.DrawIcon					; If not, branch

	lea	.SelectionPieces(pc),a0				; Selection pieces
	moveq	#(.SelectionPiecesEnd-.SelectionPieces)/6-1,d1	; Number of selection pieces

	move.w	#176,d3						; Y position
	tst.b	script_selection_id
	beq.s	.DrawSelectionPieces
	addi.w	#16,d3

.DrawSelectionPieces:
	movem.w	d0/d1,-(sp)					; Draw selection piece
	move.b	d0,-(sp)
	move.w	(a0)+,d2
	move.b	d2,-(sp)
	move.w	(a0)+,d2
	move.b	d2,-(sp)
	move.w	(a0)+,-(sp)
	move.w	d3,-(sp)
	move.w	d4,-(sp)
	move.w	d4,-(sp)
	jsr	DrawLoadedMarsSprite
	movem.w	(sp)+,d0/d1

	dbf	d1,.DrawSelectionPieces				; Loop until all pieces are drawn

.DrawIcon:
	btst	#SCRIPT_DRAW_ICON_FLAG,script_flags		; Should we draw the icon?
	beq.s	.SetDrawn					; If not, branch

	move.w	d0,-(sp)					; Update icon animation
	lea	script_icon_anim,a0
	bsr.w	UpdateAnimation
	move.w	(sp)+,d0

	move.l	script_icon_sprites,-(sp)			; Draw icon
	move.b	anim.frame+1(a0),-(sp)
	move.b	script_icon_cram,-(sp)
	move.b	d0,-(sp)
	move.w	#11,-(sp)
	move.w	#152+12,-(sp)
	move.w	d4,-(sp)
	move.w	d4,-(sp)
	jsr	DrawMarsSprite

.SetDrawn:
	bset	#SCRIPT_TEXTBOX_DRAWN_FLAG,script_flags		; Textbox drawn
	rts

; ------------------------------------------------------------------------------

.FramePieces:
	dc.w	0, 0						; Left
	dc.w	1, 80						; Middle left
	dc.w	1, 160						; Middle right
	dc.w	2, 240						; Right
.FramePiecesEnd:

.SelectionPieces:
	dc.w	3, 0, 71					; Left
	dc.w	4, 0, 151					; Middle
	dc.w	3, 1, 305					; Right
.SelectionPiecesEnd:

; ------------------------------------------------------------------------------
