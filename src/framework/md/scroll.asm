; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Scroll functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/framework/md.inc"

; ------------------------------------------------------------------------------
; Static scroll
; ------------------------------------------------------------------------------

ScrollStatic:
	lea	hscroll,a1					; Horizontal scroll table
	
	move.l	camera_fg_x_draw,d0				; Get scroll positions
	neg.l	d0
	move.w	camera_bg_x_draw,d0
	neg.w	d0

	rept 224						; Set scroll positions
		move.l	d0,(a1)+
	endr

	rts

; ------------------------------------------------------------------------------
; Deformed scroll
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to deformation table
; ------------------------------------------------------------------------------

ScrollDeformed:
	lea	hscroll,a1					; Horizontal scroll table
	lea	auto_scroll,a2					; Auto-scroll table
	
	move.w	#224,d0						; Number of scanlines on screen
	move.w	camera_bg_y_draw,d1				; Get background Y position

	moveq	#0,d4						; Get foreground scroll position
	move.w	camera_fg_x_draw,d4
	neg.w	d4
	swap	d4

	moveq	#0,d2						; Reset section size counter

.FindFirstSect:
	move.w	(a0),d3						; Get section size
	bmi.w	.FoundFirstSection				; If this is the end of the deformation table, branch
	
	add.w	d3,d2						; Add section size
	cmp.w	d1,d2						; Is this the first section on screen?
	bhi.s	.FoundFirstSection				; If so, branch

	addq.w	#4,a0						; Skip past camera position
	move.l	(a0)+,d3					; Is this an auto-scroll section?
	beq.s	.SearchNextSect					; If not, branch
	sub.l	d3,(a2)+					; Apply auto-scroll

.SearchNextSect:
	addq.w	#4,a0						; Go to next section
	bra.s	.FindFirstSect					; Keep searching

; ------------------------------------------------------------------------------

.FoundFirstSection:
	sub.w	d2,d1						; Get number of scanlines to scroll in first section
	neg.w	d1

	lea	2(a0),a3					; Save section found
	movea.l	a2,a4

.ScanAutoScroll:
	tst.w	(a0)+						; Is this the end of the deformation table?
	bmi.s	.ScrollFirstSection				; If so, branch

	addq.w	#2,a0						; Skip past camera position
	move.l	(a0)+,d3					; Is this an auto-scroll section?
	beq.s	.ScanNextAutoScroll				; If not, branch
	sub.l	d3,(a2)+					; Apply auto-scroll

.ScanNextAutoScroll:
	addq.w	#4,a0						; Go to next section
	bra.s	.ScanAutoScroll					; Loop until the rest of the sections are scanned

; ------------------------------------------------------------------------------

.ScrollSections:
	move.w	(a3)+,d1					; Get section size
	bmi.w	.Remaining					; If this is the end of the deformation table, branch

.ScrollFirstSection:
	movea.w	(a3)+,a2					; Get camera
	
	moveq	#0,d3						; Section position offset
	tst.l	(a3)+						; Is this an auto-scroll section?
	beq.s	.NoAutoScroll					; If not, branch
	move.w	(a4)+,d3					; Get auto-scroll offset
	addq.w	#2,a4

.NoAutoScroll:
	move.w	(a3)+,d2					; Get section scroll speed
	bne.s	.NotStatic					; If it's not static, branch
	move.w	d3,d2						; If it is, set speed to auto-scroll speed
	bra.s	.SetScrollPosition

.NotStatic:
	move.w	(a2),d4						; Apply section scroll speed
	add.w	d3,d4
	muls.w	d4,d2
	asr.l	#8,d2

.SetScrollPosition:
	add.w	camera_bg_x_shake,d2				; Negate and set scroll position
	neg.w	d2
	move.w	d2,d4

	move.w	(a3)+,d5					; Does the section speed accumulate?
	beq.w	.NormalSection					; If not, branch

; ------------------------------------------------------------------------------

.AccumSection:
	tst.w	-4(a3)						; Is this section static?
	beq.s	.AccumStaticSection				; If so, branch
	add.w	(a2),d3						; Add layer position

.AccumStaticSection:
	muls.w	d3,d5						; Get speed accumulator

	moveq	#0,d3						; Get base section speed
	move.w	d4,d3
	swap	d3

	move.w	d1,d2						; Is this section only partially visible?
	sub.w	-$C(a3),d2
	beq.w	.AccumSectionStart				; If not, branch
	
	subi.w	#224,d2						; Add accumulator for offscreen scanlines
	neg.w	d2
	add.w	d2,d2
	jmp	.AccumOffScreen(pc,d2.w)
	
.AccumOffScreen:
	rept 224
		sub.l	d5,d3
	endr

.AccumSectionStart:
	cmp.w	d0,d1						; Is this the last section to scroll?
	bcs.s	.GotAccumSectionSize				; If not, branch
	move.w	d0,d1						; Cap size to remaining screen space

.GotAccumSectionSize:
	move.w	d1,d2						; Fill in the section
	subi.w	#224,d1
	neg.w	d1
	move.w	d1,d6
	add.w	d1,d1
	add.w	d1,d1
	add.w	d6,d1
	add.w	d1,d1
	jmp	.FillAccumSection(pc,d1.w)

.FillAccumSection:
	rept 224
		swap	d3					; Get background scroll position
		move.w	d3,d4
		swap	d3
		move.l	d4,(a1)+				; Set scanline scroll position
		sub.l	d5,d3					; Add accumulator
	endr
	
	sub.w	d2,d0						; Subtract section size from remaining screen space
	bne.w	.ScrollSections					; If this is not the last section, branch
	rts

; ------------------------------------------------------------------------------

.NormalSection:
	cmp.w	d0,d1						; Is this the last section to scroll?
	bcs.s	.GotNormalSectionSize				; If not, branch
	move.w	d0,d1						; Cap size to remaining screen space

.GotNormalSectionSize:
	move.w	d1,d2						; Fill in the section
	subi.w	#224,d1
	neg.w	d1
	add.w	d1,d1
	jmp	.FillNormalSection(pc,d1.w)
	
.FillNormalSection:
	rept 224
		move.l	d4,(a1)+
	endr
	
	sub.w	d2,d0						; Subtract section size from remaining screen space
	bne.w	.ScrollSections					; If this is not the last section, branch
	rts

; ------------------------------------------------------------------------------

.Remaining:
	subi.w	#224,d0						; Fill in the rest of the scanlines
	neg.w	d0
	add.w	d0,d0
	jmp	.FillRemaining(pc,d0.w)
	
.FillRemaining:
	rept 224
		move.l	d4,(a1)+
	endr
	rts
	
; ------------------------------------------------------------------------------
; Initialize camera
; ------------------------------------------------------------------------------

InitCamera:
	clr.l	camera_fg_x_shake				; Reset shake offsets
	clr.l	camera_bg_x_shake

	move.l	map_fg_bound_left,map_fg_target_left		; Sync boundaries
	move.l	map_fg_bound_top,map_fg_target_top
	move.l	map_bg_bound_left,map_bg_target_left
	move.l	map_bg_bound_top,map_bg_target_top
	
	lea	camera_fg_x,a1					; Clamp foreground camera X position
	move.w	map_fg_bound_left,d1
	move.w	map_fg_bound_right,d2
	subi.w	#320,d2
	bsr.w	ClampCameraValue
	move.w	(a1),camera_fg_x_scroll
	
	lea	camera_fg_y,a1					; Clamp foreground camera Y position
	move.w	map_fg_bound_top,d1
	move.w	map_fg_bound_bottom,d2
	subi.w	#224,d2
	bsr.w	ClampCameraValue
	move.w	(a1),camera_fg_y_scroll
	
	lea	camera_bg_x,a1					; Clamp background camera X position
	move.w	map_bg_bound_left,d1
	move.w	map_bg_bound_right,d2
	subi.w	#320,d2
	bsr.w	ClampCameraValue
	move.w	(a1),camera_bg_x_scroll
	
	lea	camera_bg_y,a1					; Clamp background camera Y position
	move.w	map_bg_bound_top,d1
	move.w	map_bg_bound_bottom,d2
	subi.w	#224,d2
	bsr.w	ClampCameraValue
	move.w	(a1),camera_bg_y_scroll

; ------------------------------------------------------------------------------
; Update camera
; ------------------------------------------------------------------------------

UpdateCamera:
	move.w	camera_fg_x,camera_fg_x_previous		; Set previous camera positions
	move.w	camera_fg_y,camera_fg_y_previous
	move.w	camera_bg_x,camera_bg_x_previous
	move.w	camera_bg_y,camera_bg_y_previous

	move.w	cam_focus_object,d0				; Get camera focus object
	beq.w	ScrollLayers					; If it's not set, branch
	movea.w	d0,a6

	move.w	obj.x(a6),d0					; Get object's X position relative to camera
	sub.w	camera_fg_x_scroll,d0

	cmp.w	cam_focus_left,d0				; Has the object gone past the left boundary?
	blt.s	.ScrollLeft					; If so, branch
	cmp.w	cam_focus_right,d0				; Has the object gone past the right boundary?
	ble.s	.CheckScrollY					; If not, branch

.ScrollRight:
	sub.w	cam_focus_right,d0				; Scroll camera
	add.w	d0,camera_fg_x_scroll
	bra.s	.CheckScrollY

.ScrollLeft:
	sub.w	cam_focus_left,d0				; Scroll camera
	add.w	d0,camera_fg_x_scroll
	
; ------------------------------------------------------------------------------

.CheckScrollY:
	move.w	obj.y(a6),d0					; Get objects's Y position relative to camera
	sub.w	camera_fg_y_scroll,d0

	cmp.w	cam_focus_top,d0				; Has the object gone past the top boundary?
	blt.s	.ScrollTop					; If so, branch
	cmp.w	cam_focus_bottom,d0				; Has the object gone past the bottom boundary?
	ble.s	ScrollLayers					; If not, branch

.ScrollBottom:
	sub.w	cam_focus_bottom,d0				; Scroll camera
	add.w	d0,camera_fg_y_scroll
	bra.s	ScrollLayers

.ScrollTop:
	sub.w	cam_focus_top,d0				; Scroll camera
	add.w	d0,camera_fg_y_scroll

; ------------------------------------------------------------------------------
; Scroll layers
; ------------------------------------------------------------------------------

ScrollLayers:
	lea	map_foreground,a0				; Update foreground camera
	bsr.s	.ScrollLayer
	lea	map_background,a0				; Update background camera

; ------------------------------------------------------------------------------

.ScrollLayer:
	lea	map.bound_left(a0),a1				; Update left boundary
	move.w	map.target_left(a0),d0
	moveq	#8,d1
	bsr.w	ShiftCameraValue
	
	lea	map.bound_right(a0),a1				; Update right boundary
	move.w	map.target_right(a0),d0
	moveq	#8,d1
	bsr.s	ShiftCameraValue
	
	lea	map.bound_top(a0),a1				; Update top boundary
	move.w	map.target_top(a0),d0
	moveq	#8,d1
	bsr.s	ShiftCameraValue
	
	lea	map.bound_bottom(a0),a1				; Update bottom boundary
	move.w	map.target_bottom(a0),d0
	moveq	#8,d1
	bsr.s	ShiftCameraValue

	lea	map.x_scroll(a0),a1				; Clamp camera X position
	move.w	map.bound_left(a0),d1
	move.w	map.bound_right(a0),d2
	subi.w	#320,d2
	bsr.s	ClampCameraValue
	
	lea	map.y_scroll(a0),a1				; Clamp camera Y position
	move.w	map.bound_top(a0),d1
	move.w	map.bound_bottom(a0),d2
	subi.w	#224,d2
	bsr.s	ClampCameraValue

	lea	map.x_current(a0),a1				; Update camera X position
	move.w	map.x_scroll(a0),d0
	move.w	map.x_speed(a0),d1
	bsr.s	ShiftCameraValue
	
	lea	map.y_current(a0),a1				; Update camera Y position
	move.w	map.y_scroll(a0),d0
	move.w	map.y_speed(a0),d1
	bsr.s	ShiftCameraValue
	
	move.l	map.x_current(a0),d0				; Get draw X offset
	swap	d0
	add.w	map.x_shake(a0),d0
	swap	d0
	move.l	d0,map.x_draw(a0)
	
	move.l	map.y_current(a0),d0				; Get draw Y offset
	swap	d0
	add.w	map.y_shake(a0),d0
	swap	d0
	move.l	d0,map.y_draw(a0)
	rts
	
; ------------------------------------------------------------------------------
; Shift camera value
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l - Current value
;	d0.w - Target value
;	d1.w - Speed
; ------------------------------------------------------------------------------

ShiftCameraValue:
	sub.w	(a1),d0						; Get delta value
	beq.s	.End						; If it's 0, branch
	bmi.s	.Negative					; If it's negative, branch

.Positive:
	cmp.w	d1,d0						; Is the value shifting too fast?
	blt.s	.SetValue					; If not, branch
	move.w	d1,d0						; Cap shift speed
	bra.s	.SetValue

.Negative:
	neg.w	d1						; Is the value shifting too fast?
	cmp.w	d1,d0
	bgt.s	.SetValue					; If not, branch
	move.w	d1,d0						; Cap shift speed
	
.SetValue:
	add.w	d0,(a1)						; Apply shift speed

.End:
	rts
	
; ------------------------------------------------------------------------------
; Clamp camera value
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l - Current value
;	d1.w - Minimum value
;	d2.w - Maximum value
; ------------------------------------------------------------------------------

ClampCameraValue:
	move.w	(a1),d0						; Get value
	cmp.w	d1,d0						; Has it gone past the minimum value?
	bge.s	.CheckMax					; If not, branch
	move.w	d1,d0						; Cap at minimum value

.CheckMax:
	cmp.w	d2,d0						; Has it gone past the maximum value?
	ble.s	.SetValue					; If not, branch
	move.w	d2,d0						; Cap at maximum value

.SetValue:
	move.w	d0,(a1)						; Update value
	rts

; ------------------------------------------------------------------------------
