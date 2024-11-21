; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Animation functions header
; ------------------------------------------------------------------------------

	global SetAnimation
	global ResetAnimation
	global UpdateAnimation

; ------------------------------------------------------------------------------
; Animation variables structure
; ------------------------------------------------------------------------------

	rsreset
anim.script		rs.l 1					; Animation script
anim.cursor		rs.l 1					; Animation cursor
anim.speed		rs.w 1					; Animation speed
anim.id			rs.w 1					; Animation ID
anim.frame		rs.w 1					; Animation frame
anim.prev_frame		rs.w 1					; Previous animation frame
anim.struct_len		rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; Animation data header
; ------------------------------------------------------------------------------

	rsreset
anim_head.speed		rs.w 1					; Animation speed
anim_head.length	rs.w 1					; Animation length
anim_head.end_type	rs.w 1					; Animation end type
anim_head.end_param	rs.w 1					; Animation end parameter
anim_head.struct_len	rs.b 0					; Animation header structure length

; ------------------------------------------------------------------------------
; Animation end types
; ------------------------------------------------------------------------------

	rsreset
ANIM_RESTART		rs.b 2					; Restart
ANIM_LOOP_POINT		rs.b 2					; Loop point
ANIM_SWITCH		rs.b 2					; Animation switch

; ------------------------------------------------------------------------------
; Animation data start
; ------------------------------------------------------------------------------
; PARAMETERS:
;	speed - Animation speed
;	type  - Animation end type
;	param - Animation end parameter
;	        (Only for loop point and animation switch)
; ------------------------------------------------------------------------------

__anim_id = 0
ANIM_START macro speed, type, param
	dc.w	\speed
	dc.w	(.AnimData\#__anim_id\_End-.AnimData\#__anim_id\_Start)/2
	dc.w	\type
	if ((\type)=ANIM_LOOP_POINT)|((\type)=ANIM_SWITCH)
		dc.w	\param
	else
		dc.w	0
	endif
	
.AnimData\#__anim_id\_Start:
	endm

; ------------------------------------------------------------------------------
; Animation data end
; ------------------------------------------------------------------------------

ANIM_END macro
.AnimData\#__anim_id\_End:
	__anim_id: = __anim_id+1
	endm

; ------------------------------------------------------------------------------
