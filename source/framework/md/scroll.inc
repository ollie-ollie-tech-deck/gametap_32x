; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Scroll functions header
; ------------------------------------------------------------------------------
	
	global ScrollStatic
	global ScrollDeformed
	global InitCamera
	global UpdateCamera
	
; ------------------------------------------------------------------------------
; HOW A DEFORMATION TABLE WORKS
; ------------------------------------------------------------------------------
; The background is split up into sections with varying sizes. The speed
; that each section scrolls at is the how much its designated camera moves,
; multiplied by the section speed.
;
; If an auto-scroll speed is set, it will continually add that value,
; and add the resulting offset.
;
; If a speed accumulator is set, what that means is that for each block
; of scanlines (size of block can be set by the user), it will add
; that speed. This is useful for things like water and clouds with
; perspective.
;
; Speeds are in 8.8 fixed point format.
; ------------------------------------------------------------------------------
	
; ------------------------------------------------------------------------------
; Deformation table section entry
; ------------------------------------------------------------------------------
; PARAMETERS:
;	size  - Section size
;	cam   - Camera position
;	speed - Scroll speed
;	auto  - Auto-scroll speed and direction
;	accum - Speed accumulation
; ------------------------------------------------------------------------------

DEFORM macro size, cam, speed, auto, accum
	if (\size)<=0
		inform 2,"Invalid deformation section size %d", \size
	endif
	dc.w	\size, \cam
	dc.l	\auto
	dc.w	\speed, \accum
	endm
	
; ------------------------------------------------------------------------------
; Deformation table end
; ------------------------------------------------------------------------------

DEFORM_END macros
	dc.w	-1
	
; ------------------------------------------------------------------------------