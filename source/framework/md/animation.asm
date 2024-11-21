; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Animation functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/framework/md.inc"

; ------------------------------------------------------------------------------
; Set animation
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Animation variables
;	a1.l - Animation script
;	d0.w - Animation ID
; ------------------------------------------------------------------------------

SetAnimation:
	cmpa.l	anim.script(a0),a1				; Is this animation script already set?
	bne.s	.SetAnim					; If not, branch
	cmp.w	anim.id(a0),d0					; Is this animation already set?
	beq.s	.End						; If so, branch

.SetAnim:
	move.l	a1,anim.script(a0)				; Set animation script
	move.w	d0,anim.id(a0)					; Set animation ID
	
	add.w	d0,d0						; Get animation data
	adda.w	(a1,d0.w),a1
	
	tst.w	anim_head.speed(a1)				; Is the animation speed set externally?
	bmi.s	.NoSpeedSet					; If so, branch
	move.w	anim_head.speed(a1),anim.speed(a0)		; Set animation speed
	
.NoSpeedSet:
	move.w	anim_head.struct_len(a1),anim.frame(a0)		; Set animation frame
	move.w	#-1,anim.prev_frame(a0)
	clr.l	anim.cursor(a0)					; Reset cursor

.End:
	rts
	
; ------------------------------------------------------------------------------
; Reset animation
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Animation variables
; ------------------------------------------------------------------------------

ResetAnimation:
	move.l	anim.script(a0),d0				; Get animation script
	beq.s	.End						; If it's not set, branch
	
	movea.l	d0,a1						; Get animation data
	move.w	anim.id(a0),d0
	add.w	d0,d0
	adda.w	(a1,d0.w),a1

	move.w	anim_head.struct_len(a1),anim.frame(a0)		; Set animation frame
	move.w	#-1,anim.prev_frame(a0)
	clr.l	anim.cursor(a0)					; Reset cursor

.End:
	rts

; ------------------------------------------------------------------------------
; Update animation
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Animation variables
; ------------------------------------------------------------------------------

UpdateAnimation:
	move.l	anim.script(a0),d0				; Get animation script
	beq.s	.End						; If it's not set, branch
	
	move.w	anim.frame(a0),anim.prev_frame(a0)		; Set previous animation frame
	
	movea.l	d0,a1						; Get animation data
	move.w	anim.id(a0),d0
	add.w	d0,d0
	adda.w	(a1,d0.w),a1
	
	move.w	anim_head.length(a1),d0				; Are we at the end of the animation?
	cmp.w	anim.cursor(a0),d0
	bls.s	.AnimEnd					; If so, branch

.GetFrame:
	move.w	anim.cursor(a0),d0				; Get animation frame
	add.w	d0,d0
	move.w	anim_head.struct_len(a1,d0.w),anim.frame(a0)
	
	move.w	anim.speed(a0),d0				; Advance cursor
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,anim.cursor(a0)

.End:
	rts
	
; ------------------------------------------------------------------------------

.AnimEnd:
	move.w	anim_head.end_type(a1),d0			; Handle animation end
	jmp	.Types(pc,d0.w)

; ------------------------------------------------------------------------------

.Types:
	bra.s	.Restart					; Restart
	bra.s	.LoopPoint					; Loop point

; ------------------------------------------------------------------------------

.SwitchAnim:
	move.w	anim_head.end_param(a1),anim.id(a0)		; Set animation ID
	clr.l	anim.cursor(a0)					; Reset cursor
	
	movea.l	anim.script(a0),a1				; Get new animation data
	move.w	anim.id(a0),d0
	add.w	d0,d0
	adda.w	(a1,d0.w),a1
	
	tst.w	anim_head.speed(a1)				; Is the animation speed set externally?
	bmi.s	.NoSpeedSet					; If so, branch
	move.w	anim_head.speed(a1),anim.speed(a0)		; Set animation speed
	
.NoSpeedSet:
	bra.s	.GetFrame					; Get animation frame

; ------------------------------------------------------------------------------

.Restart:
	move.w	anim_head.length(a1),d0				; Get animation length

.MoveBack:
	sub.w	d0,anim.cursor(a0)				; Move back towards start
	cmp.w	anim.cursor(a0),d0				; Are we still past the end of the animation?
	bls.s	.MoveBack					; If so, keep moving back

	bra.s	.GetFrame					; Get animation frame

; ------------------------------------------------------------------------------

.LoopPoint:
	move.w	anim_head.length(a1),d0				; Get animation length

.MoveBack2:
	sub.w	d0,anim.cursor(a0)				; Move back towards start
	cmp.w	anim.cursor(a0),d0				; Are we still past the end of the animation?
	bls.s	.MoveBack2					; If so, keep moving back
	
	move.w	anim_head.end_param(a1),d0			; Add loop point
	add.w	d0,anim.cursor(a0)
	
	bra.w	.GetFrame					; Get animation frame

; ------------------------------------------------------------------------------
