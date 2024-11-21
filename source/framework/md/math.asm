; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Math functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/framework/md.inc"

; ------------------------------------------------------------------------------
; Get trajectory
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - Target X
;	d2.w - Target Y
; RETURNS:
;	d0.w - X trajectory
;	d1.w - Y trajectory
; ------------------------------------------------------------------------------

CalcTrajectory:
	bsr.w	CalcAngle16					; Get angle of trajectory
	
; ------------------------------------------------------------------------------
; Get the sine and cosine of an angle
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Angle
; RETURNS:
;	d0.w - Sine
;	d1.w - Cosine
; ------------------------------------------------------------------------------

CalcSine:
	andi.w	#$FF,d0						; Convert angle into table index
	addq.w	#8,d0
	add.w	d0,d0
	move.w	SineTable+($40*2)-16(pc,d0.w),d1		; Get cosine
	move.w	SineTable-16(pc,d0.w),d0			; Get sine
	rts

; ------------------------------------------------------------------------------

SineTable:
	dc.w	$0000, $0006, $000C, $0012, $0019, $001F, $0025, $002B, $0031, $0038, $003E, $0044, $004A, $0050, $0056, $005C
	dc.w	$0061, $0067, $006D, $0073, $0078, $007E, $0083, $0088, $008E, $0093, $0098, $009D, $00A2, $00A7, $00AB, $00B0
	dc.w	$00B5, $00B9, $00BD, $00C1, $00C5, $00C9, $00CD, $00D1, $00D4, $00D8, $00DB, $00DE, $00E1, $00E4, $00E7, $00EA
	dc.w	$00EC, $00EE, $00F1, $00F3, $00F4, $00F6, $00F8, $00F9, $00FB, $00FC, $00FD, $00FE, $00FE, $00FF, $00FF, $00FF
	dc.w	$0100, $00FF, $00FF, $00FF, $00FE, $00FE, $00FD, $00FC, $00FB, $00F9, $00F8, $00F6, $00F4, $00F3, $00F1, $00EE
	dc.w	$00EC, $00EA, $00E7, $00E4, $00E1, $00DE, $00DB, $00D8, $00D4, $00D1, $00CD, $00C9, $00C5, $00C1, $00BD, $00B9
	dc.w	$00B5, $00B0, $00AB, $00A7, $00A2, $009D, $0098, $0093, $008E, $0088, $0083, $007E, $0078, $0073, $006D, $0067
	dc.w	$0061, $005C, $0056, $0050, $004A, $0044, $003E, $0038, $0031, $002B, $0025, $001F, $0019, $0012, $000C, $0006
	dc.w	$0000, $FFFA, $FFF4, $FFEE, $FFE7, $FFE1, $FFDB, $FFD5, $FFCF, $FFC8, $FFC2, $FFBC, $FFB6, $FFB0, $FFAA, $FFA4
	dc.w	$FF9F, $FF99, $FF93, $FF8B, $FF88, $FF82, $FF7D, $FF78, $FF72, $FF6D, $FF68, $FF63, $FF5E, $FF59, $FF55, $FF50
	dc.w	$FF4B, $FF47, $FF43, $FF3F, $FF3B, $FF37, $FF33, $FF2F, $FF2C, $FF28, $FF25, $FF22, $FF1F, $FF1C, $FF19, $FF16
	dc.w	$FF14, $FF12, $FF0F, $FF0D, $FF0C, $FF0A, $FF08, $FF07, $FF05, $FF04, $FF03, $FF02, $FF02, $FF01, $FF01, $FF01
	dc.w	$FF00, $FF01, $FF01, $FF01, $FF02, $FF02, $FF03, $FF04, $FF05, $FF07, $FF08, $FF0A, $FF0C, $FF0D, $FF0F, $FF12
	dc.w	$FF14, $FF16, $FF19, $FF1C, $FF1F, $FF22, $FF25, $FF28, $FF2C, $FF2F, $FF33, $FF37, $FF3B, $FF3F, $FF43, $FF47
	dc.w	$FF4B, $FF50, $FF55, $FF59, $FF5E, $FF63, $FF68, $FF6D, $FF72, $FF78, $FF7D, $FF82, $FF88, $FF8B, $FF93, $FF99
	dc.w	$FF9F, $FFA4, $FFAA, $FFB0, $FFB6, $FFBC, $FFC2, $FFC8, $FFCF, $FFD5, $FFDB, $FFE1, $FFE7, $FFEE, $FFF4, $FFFA
	; Extra data for cosine/wrapping
	dc.w	$0000, $0006, $000C, $0012, $0019, $001F, $0025, $002B, $0031, $0038, $003E, $0044, $004A, $0050, $0056, $005C
	dc.w	$0061, $0067, $006D, $0073, $0078, $007E, $0083, $0088, $008E, $0093, $0098, $009D, $00A2, $00A7, $00AB, $00B0
	dc.w	$00B5, $00B9, $00BD, $00C1, $00C5, $00C9, $00CD, $00D1, $00D4, $00D8, $00DB, $00DE, $00E1, $00E4, $00E7, $00EA
	dc.w	$00EC, $00EE, $00F1, $00F3, $00F4, $00F6, $00F8, $00F9, $00FB, $00FC, $00FD, $00FE, $00FE, $00FF, $00FF, $00FF
	dc.w	$0100, $00FF, $00FF, $00FF, $00FE, $00FE, $00FD, $00FC, $00FB, $00F9, $00F8, $00F6, $00F4, $00F3, $00F1, $00EE
	dc.w	$00EC, $00EA, $00E7, $00E4, $00E1, $00DE, $00DB, $00D8, $00D4, $00D1, $00CD, $00C9, $00C5, $00C1, $00BD, $00B9
	dc.w	$00B5, $00B0, $00AB, $00A7, $00A2, $009D, $0098, $0093, $008E, $0088, $0083, $007E, $0078, $0073, $006D, $0067
	dc.w	$0061, $005C, $0056, $0050, $004A, $0044, $003E, $0038, $0031, $002B, $0025, $001F, $0019, $0012, $000C, $0006
	dc.w	$0000, $FFFA, $FFF4, $FFEE, $FFE7, $FFE1, $FFDB, $FFD5, $FFCF, $FFC8, $FFC2, $FFBC, $FFB6, $FFB0, $FFAA, $FFA4
	dc.w	$FF9F, $FF99, $FF93, $FF8B, $FF88, $FF82, $FF7D, $FF78, $FF72, $FF6D, $FF68, $FF63, $FF5E, $FF59, $FF55, $FF50
	dc.w	$FF4B, $FF47, $FF43, $FF3F, $FF3B, $FF37, $FF33, $FF2F, $FF2C, $FF28, $FF25, $FF22, $FF1F, $FF1C, $FF19, $FF16
	dc.w	$FF14, $FF12, $FF0F, $FF0D, $FF0C, $FF0A, $FF08, $FF07, $FF05, $FF04, $FF03, $FF02, $FF02, $FF01, $FF01, $FF01
	dc.w	$FF00, $FF01, $FF01, $FF01, $FF02, $FF02, $FF03, $FF04, $FF05, $FF07, $FF08, $FF0A, $FF0C, $FF0D, $FF0F, $FF12
	dc.w	$FF14, $FF16, $FF19, $FF1C, $FF1F, $FF22, $FF25, $FF28, $FF2C, $FF2F, $FF33, $FF37, $FF3B, $FF3F, $FF43, $FF47
	dc.w	$FF4B, $FF50, $FF55, $FF59, $FF5E, $FF63, $FF68, $FF6D, $FF72, $FF78, $FF7D, $FF82, $FF88, $FF8B, $FF93, $FF99
	dc.w	$FF9F, $FFA4, $FFAA, $FFB0, $FFB6, $FFBC, $FFC2, $FFC8, $FFCF, $FFD5, $FFDB, $FFE1, $FFE7, $FFEE, $FFF4, $FFFA

; ------------------------------------------------------------------------------
; 2-argument arctangent (angle between (0,0) and (x,y)) (16-bit)
; Based on http://codebase64.org/doku.php?id=base:8bit_atan2_8-bit_angle
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - X value
;	d2.w - Y value
; RETURNS:
;	d0.b - 2-argument arctangent value (angle between (0,0) and (x,y))
; ------------------------------------------------------------------------------

CalcAngle16:
	moveq	#0,d0						; Default to bottom right quadrant
	tst.w	d1						; Is the X value negative?
	beq.s	.ZeroX						; If the X value is zero, branch
	bpl.s	.CheckY						; If not, branch
	neg.w	d1						; If so, get the absolute value
	moveq	#4,d0						; Shift to left quadrant
 
.CheckY:
	tst.w	d2						; Is the Y value negative?
	beq.s	.ZeroY						; If the Y value is zero, branch
	bpl.s	.CheckOctet					; If not, branch
	neg.w	d2						; If so, get the absolute value
	addq.b	#2,d0						; Shift to top quadrant

.CheckOctet:
	cmp.w	d2,d1						; Are we horizontally closer to the center?
	bcc.s	.Divide						; If not, branch
	exg.l	d1,d2						; If so, divide Y from X instead
	addq.b	#1,d0						; Use octant that's horizontally closer to the center
 
.Divide:
	move.w	d1,-(sp)					; Shrink X and Y down into bytes
	moveq	#0,d3
	move.b	(sp)+,d3
	move.b	.WordShiftTable(pc,d3.w),d3
	lsr.w	d3,d1
	lsr.w	d3,d2

	lea	Log2Table(pc),a2				; Perform logarithmic division
	move.b	(a2,d2.w),d2
	sub.b	(a2,d1.w),d2
	bne.s	.GetAtan2Val
	move.w	#$FF,d2						; Edge case where X and Y values are too close for the division to handle

.GetAtan2Val:
	lea	Atan2Table(pc),a2				; Get atan2 value
	move.b	(a2,d2.w),d2
	move.b	.OctantAdjust(pc,d0.w),d0
	eor.b	d2,d0
	
.End:
	rts

; ------------------------------------------------------------------------------

.ZeroY:
	tst.b	d0						; Was the X value negated?
	beq.s	.End						; If not, branch (d0 is already 0, so no need to set it again on branch)
	moveq	#$FFFFFF80,d0					; 180 degrees
	rts

.ZeroX:
	tst.w	d2						; Is the Y value negative?
	bmi.s	.ZeroNegXY					; If so, branch
	moveq	#$40,d0						; 90 degrees
	rts

.ZeroNegXY:
	moveq	#$FFFFFFC0,d0					; 270 degrees
	rts

; ------------------------------------------------------------------------------

.OctantAdjust:
	dc.b	%00000000					; +X, +Y, |X|>|Y|
	dc.b	%00111111					; +X, +Y, |X|<|Y|
	dc.b	%11111111					; +X, -Y, |X|>|Y|
	dc.b	%11000000					; +X, -Y, |X|<|Y|
	dc.b	%01111111					; -X, +Y, |X|>|Y|
	dc.b	%01000000					; -X, +Y, |X|<|Y|
	dc.b	%10000000					; -X, -Y, |X|>|Y|
	dc.b	%10111111					; -X, -Y, |X|<|Y|

.WordShiftTable:
	dc.b	$00, $01, $02, $02, $03, $03, $03, $03
	dc.b	$04, $04, $04, $04, $04, $04, $04, $04
	dc.b	$05, $05, $05, $05, $05, $05, $05, $05
	dc.b	$05, $05, $05, $05, $05, $05, $05, $05
	dc.b	$06, $06, $06, $06, $06, $06, $06, $06
	dc.b	$06, $06, $06, $06, $06, $06, $06, $06
	dc.b	$06, $06, $06, $06, $06, $06, $06, $06
	dc.b	$06, $06, $06, $06, $06, $06, $06, $06
	dc.b	$07, $07, $07, $07, $07, $07, $07, $07
	dc.b	$07, $07, $07, $07, $07, $07, $07, $07
	dc.b	$07, $07, $07, $07, $07, $07, $07, $07
	dc.b	$07, $07, $07, $07, $07, $07, $07, $07
	dc.b	$07, $07, $07, $07, $07, $07, $07, $07
	dc.b	$07, $07, $07, $07, $07, $07, $07, $07
	dc.b	$07, $07, $07, $07, $07, $07, $07, $07
	dc.b	$07, $07, $07, $07, $07, $07, $07, $07

; ------------------------------------------------------------------------------
; 2-argument arctangent (angle between (0,0) and (x,y)) (8-bit)
; Based on http://codebase64.org/doku.php?id=base:8bit_atan2_8-bit_angle
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - X value
;	d2.w - Y value
; RETURNS:
;	d0.b - 2-argument arctangent value (angle between (0,0) and (x,y))
; ------------------------------------------------------------------------------

CalcAngle8:
	moveq	#0,d0						; Default to bottom right quadrant
	tst.w	d1						; Is the X value negative?
	beq.s	.ZeroX						; If the X value is zero, branch
	bpl.s	.CheckY						; If not, branch
	neg.w	d1						; If so, get the absolute value
	moveq	#4,d0						; Shift to left quadrant
 
.CheckY:
	tst.w	d2						; Is the Y value negative?
	beq.s	.ZeroY						; If the Y value is zero, branch
	bpl.s	.Divide						; If not, branch
	neg.w	d2						; If so, get the absolute value
	addq.b	#2,d0						; Shift to top quadrant

.Divide:
	lea	Log2Table(pc),a2				; Perform logarithmic division
	move.b	(a2,d2.w),d2
	sub.b	(a2,d1.w),d2
	bcs.s	.GetAtan2Val
	neg.b	d2						; Use octant that's horizontally closer to the center
	addq.b	#1,d0

.GetAtan2Val:
	move.b	Atan2Table(pc,d2.w),d2				; Get atan2 value
	move.b	.OctantAdjust(pc,d0.w),d0
	eor.b	d2,d0
	
.End:
	rts

; ------------------------------------------------------------------------------

.ZeroY:
	tst.b	d0						; Was the X value negated?
	beq.s	.End						; If not, branch (d0 is already 0, so no need to set it again on branch)
	moveq	#$FFFFFF80,d0					; 180 degrees
	rts

.ZeroX:
	tst.w	d2						; Is the Y value negative?
	bmi.s	.ZeroNegXY					; If so, branch
	moveq	#$40,d0						; 90 degrees
	rts

.ZeroNegXY:
	moveq	#$FFFFFFC0,d0					; 270 degrees
	rts

; ------------------------------------------------------------------------------

.OctantAdjust:
	dc.b	%00000000					; +X, +Y, |X|>|Y|
	dc.b	%00111111					; +X, +Y, |X|<|Y|
	dc.b	%11111111					; +X, -Y, |X|>|Y|
	dc.b	%11000000					; +X, -Y, |X|<|Y|
	dc.b	%01111111					; -X, +Y, |X|>|Y|
	dc.b	%01000000					; -X, +Y, |X|<|Y|
	dc.b	%10000000					; -X, -Y, |X|>|Y|
	dc.b	%10111111					; -X, -Y, |X|<|Y|

; ------------------------------------------------------------------------------

Atan2Table:
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00
	dc.b	$00, $00, $00, $00, $00, $00, $01, $01
	dc.b	$01, $01, $01, $01, $01, $01, $01, $01
	dc.b	$01, $01, $01, $01, $01, $01, $01, $01
	dc.b	$01, $01, $01, $01, $01, $01, $01, $01
	dc.b	$01, $01, $01, $01, $01, $01, $01, $01
	dc.b	$01, $01, $01, $01, $01, $01, $01, $01
	dc.b	$01, $01, $01, $01, $01, $01, $01, $01
	dc.b	$01, $02, $02, $02, $02, $02, $02, $02
	dc.b	$02, $02, $02, $02, $02, $02, $02, $02
	dc.b	$02, $02, $02, $02, $02, $02, $02, $02
	dc.b	$03, $03, $03, $03, $03, $03, $03, $03
	dc.b	$03, $03, $03, $03, $03, $03, $03, $03
	dc.b	$04, $04, $04, $04, $04, $04, $04, $04
	dc.b	$04, $04, $04, $05, $05, $05, $05, $05
	dc.b	$05, $05, $05, $05, $05, $06, $06, $06
	dc.b	$06, $06, $06, $06, $06, $07, $07, $07
	dc.b	$07, $07, $07, $08, $08, $08, $08, $08
	dc.b	$08, $09, $09, $09, $09, $09, $09, $0A
	dc.b	$0A, $0A, $0A, $0B, $0B, $0B, $0B, $0B
	dc.b	$0C, $0C, $0C, $0C, $0D, $0D, $0D, $0D
	dc.b	$0E, $0E, $0E, $0F, $0F, $0F, $0F, $10
	dc.b	$10, $10, $11, $11, $11, $12, $12, $12
	dc.b	$13, $13, $13, $14, $14, $14, $15, $15
	dc.b	$16, $16, $16, $17, $17, $17, $18, $18
	dc.b	$19, $19, $1A, $1A, $1A, $1B, $1B, $1C
	dc.b	$1C, $1C, $1D, $1D, $1E, $1E, $1F, $1F

Log2Table:
	dc.b	$00, $00, $1F, $32, $3F, $49, $52, $59
	dc.b	$5F, $64, $69, $6E, $72, $75, $79, $7C
	dc.b	$7F, $82, $84, $87, $89, $8C, $8E, $90
	dc.b	$92, $94, $95, $97, $99, $9A, $9C, $9E
	dc.b	$9F, $A0, $A2, $A3, $A4, $A6, $A7, $A8
	dc.b	$A9, $AA, $AC, $AD, $AE, $AF, $B0, $B1
	dc.b	$B2, $B3, $B4, $B5, $B5, $B6, $B7, $B8
	dc.b	$B9, $BA, $BA, $BB, $BC, $BD, $BE, $BE
	dc.b	$BF, $C0, $C0, $C1, $C2, $C2, $C3, $C4
	dc.b	$C4, $C5, $C6, $C6, $C7, $C8, $C8, $C9
	dc.b	$C9, $CA, $CA, $CB, $CC, $CC, $CD, $CD
	dc.b	$CE, $CE, $CF, $CF, $D0, $D0, $D1, $D1
	dc.b	$D2, $D2, $D3, $D3, $D4, $D4, $D5, $D5
	dc.b	$D5, $D6, $D6, $D7, $D7, $D8, $D8, $D8
	dc.b	$D9, $D9, $DA, $DA, $DA, $DB, $DB, $DC
	dc.b	$DC, $DC, $DD, $DD, $DE, $DE, $DE, $DF
	dc.b	$DF, $DF, $E0, $E0, $E0, $E1, $E1, $E1
	dc.b	$E2, $E2, $E2, $E3, $E3, $E3, $E4, $E4
	dc.b	$E4, $E5, $E5, $E5, $E6, $E6, $E6, $E7
	dc.b	$E7, $E7, $E8, $E8, $E8, $E8, $E9, $E9
	dc.b	$E9, $EA, $EA, $EA, $EA, $EB, $EB, $EB
	dc.b	$EC, $EC, $EC, $EC, $ED, $ED, $ED, $ED
	dc.b	$EE, $EE, $EE, $EE, $EF, $EF, $EF, $F0
	dc.b	$F0, $F0, $F0, $F1, $F1, $F1, $F1, $F1
	dc.b	$F2, $F2, $F2, $F2, $F3, $F3, $F3, $F3
	dc.b	$F4, $F4, $F4, $F4, $F5, $F5, $F5, $F5
	dc.b	$F5, $F6, $F6, $F6, $F6, $F7, $F7, $F7
	dc.b	$F7, $F7, $F8, $F8, $F8, $F8, $F8, $F9
	dc.b	$F9, $F9, $F9, $F9, $FA, $FA, $FA, $FA
	dc.b	$FA, $FB, $FB, $FB, $FB, $FB, $FC, $FC
	dc.b	$FC, $FC, $FC, $FD, $FD, $FD, $FD, $FD
	dc.b	$FE, $FE, $FE, $FE, $FE, $FE, $FF, $FF

; ------------------------------------------------------------------------------
; Calculate the square root of a value
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.l - Value
; RETURNS:
;	d0.w - Square root
; ------------------------------------------------------------------------------

CalcSqrt:
	move.l	d0,d1						; Calculate square root
	moveq	#0,d2
	moveq	#0,d3
	moveq	#$10-1,d4

.Loop:
	add.w	d0,d0
	add.l	d1,d1
	addx.l	d3,d3
	add.l	d1,d1
	addx.l	d3,d3
	add.l	d2,d2
	addq.l	#1,d2
	cmp.l	d2,d3
	bcs.s	.Subtract
	addq.w	#1,d0
	sub.l	d2,d3
	addq.l	#1,d2
	dbf	d4,.Loop
	rts

.Subtract:
	subq.l	#1,d2
	dbf	d4,.Loop
	rts

; ------------------------------------------------------------------------------
; Get a random number
; ------------------------------------------------------------------------------
; RETURNS:
;	d0.l - Random number
; ------------------------------------------------------------------------------

Random:
	move.l	rng_seed,d1					; Get RNG seed
	bne.s	.GotSeed					; If it's set, branch
	move.l	#$2A6D365A,d1					; Reset RNG seed otherwise

.GotSeed:
	move.l	d1,d0						; Get random number
	asl.l	#2,d1
	add.l	d0,d1
	asl.l	#3,d1
	add.l	d0,d1
	move.w	d1,d0
	swap	d1
	add.w	d1,d0
	move.w	d0,d1
	swap	d1
	move.l	d1,rng_seed					; Update RNG seed
	rts

; ------------------------------------------------------------------------------
; Convert 2D coordinates to 3D coordinates
; ------------------------------------------------------------------------------
; PARAMETERS
;	d0.w - X position (in 2D space)
;	d1.w - Y position (in 2D space)
;	d2.w - Z position (in 3D space)
; ------------------------------------------------------------------------------
; RETURNS:
;	d0.w - X position (in 3D space)
;	d1.w - Y position (in 3D space)
; ------------------------------------------------------------------------------

Conv2dPointTo3d:
	subi.w	#320/2,d0					; Center 2D coordinates
	subi.w	#224/2,d1

	muls.w	d2,d0						; Multiply by Z position
	muls.w	d2,d1

	asr.l	#8,d0						; Get 3D coordinates
	asr.l	#8,d1
	rts
	
; ------------------------------------------------------------------------------
; Convert 3D coordinates to 2D coordinates
; ------------------------------------------------------------------------------
; PARAMETERS
;	d0.w - X position (in 3D space)
;	d1.w - Y position (in 3D space)
;	d2.w - Z position (in 3D space)
; ------------------------------------------------------------------------------
; RETURNS:
;	d0.w - X position (in 2D space)
;	d1.w - Y position (in 2D space)
; ------------------------------------------------------------------------------

Conv3dPointTo2d:
	tst.w	d2						; Is the Z position 0?
	beq.s	.End						; If so, branch

	ext.l	d0						; Divide by Z position
	ext.l	d1
	asl.l	#8,d0
	asl.l	#8,d1
	divs.w	d2,d0
	divs.w	d2,d1
	
	addi.w	#320/2,d0					; Get 2D coordinates
	addi.w	#224/2,d1

.End:
	rts

; ------------------------------------------------------------------------------
