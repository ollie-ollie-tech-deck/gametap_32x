; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Report macro
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; Print structure info
; ------------------------------------------------------------------------------
; PARAMETERS:
;	name - Name of structure
;	size - Size of structure
; ------------------------------------------------------------------------------

PRINT_STRUCT macro name, size
	local name_str
	name_str: equs \name
	name_str: substr 1, 34, "\name_str\:                                "
	inform 0,"    \name_str\ 0x%h", \size
	endm

; ------------------------------------------------------------------------------
; Check if a structure is too large and report accordingly
; ------------------------------------------------------------------------------
; PARAMETERS:
;	name     - Name of structure
;	size     - Size of structure
;	max_size - Max size
; ------------------------------------------------------------------------------

CHECK_STRUCT macro name, size, max_size
	local name_str
	name_str: equs \name
	name_str_2: substr 1, 34, "\name_str\:                                "

	if (\size)<=(\max_size)
		inform 0,"    \name_str_2\ 0x%h / 0x%h", \size, \max_size
	else
		inform 0,"    \name_str_2\ 0x%h / 0x%h (TOO LARGE BY 0x%h)", \size, \max_size, (\size)-(\max_size)
	endif
	endm

; ------------------------------------------------------------------------------
