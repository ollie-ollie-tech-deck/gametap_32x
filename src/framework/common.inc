; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Common definitions
; ------------------------------------------------------------------------------

	include	"src/configuration.inc"
	
; ------------------------------------------------------------------------------
; Constants
; ------------------------------------------------------------------------------

; Refresh rate
NTSC			equ 60					; NTSC
PAL			equ 50					; PAL

; ------------------------------------------------------------------------------
; Store text with static size
; ------------------------------------------------------------------------------
; PARAMETERS:
;	len  - Length of text
;	text - Text to store
; ------------------------------------------------------------------------------

SIZED_TEXT macro len, text
	local l, s
	if strlen(\text)>(\len)
		l: = \len
		s: substr 1,\len,\text
	else
		l: = strlen(\text)
		s: equs \text
	endif
	dc.b	"\s"
	dcb.b	(\len)-l, " "
	endm

; ------------------------------------------------------------------------------
; Store number with static number of digits
; ------------------------------------------------------------------------------
; PARAMETERS:
;	digits - Number of digits
;	num    - Number to store
; ------------------------------------------------------------------------------

NUM_TEXT macro digits, num
	local n, d, m
	n: = \num
	d: = 1
	m: = 10
	while (n<>0)&(d<(\digits))
		n: = n/10
		m: = m*10
		d: = d+1
	endw
	n: = (\num)%m
	dcb.b	(\digits)-strlen("\#n"), "0"
	dc.b	"\#n"
	endm

; ------------------------------------------------------------------------------
; Store month text
; ------------------------------------------------------------------------------
; PARAMETERS:
;	month - Month ID
; ------------------------------------------------------------------------------

MONTH_TEXT macro month
	local s
	s: substr 1+(((\month)-1)*3), 3+(((\month)-1)*3), &
		"JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
	dc.b	"\s"
	endm

; ------------------------------------------------------------------------------
; Store build date
; ------------------------------------------------------------------------------

BUILD_DATE macro
	NUM_TEXT 4,_year+1900
	dc.b	"/"								
	NUM_TEXT 2,_month
	dc.b	"/"
	NUM_TEXT 2,_day
	dc.b	" "
	NUM_TEXT 2,_hours
	dc.b	":"
	NUM_TEXT 2,_minutes
	endm

; ------------------------------------------------------------------------------
