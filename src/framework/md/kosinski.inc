; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Kosinski decompression functions header
; ------------------------------------------------------------------------------

	global KosDec
	global InitKosQueue
	global FlushKosmQueue
	global QueueKosmList
	global QueueKosmData
	global ProcessKosmQueue
	global QueueKosData
	global SetKosBookmark
	global ProcessKosQueue

; ------------------------------------------------------------------------------
; Kosinski Moduled list start
; ------------------------------------------------------------------------------

__kosm_list_count: = 0

KOSM_LIST_START macro
	__kosm_count: = 0
	dc.w	(__kosm_count_\#__kosm_list_count\)-1
	endm

; ------------------------------------------------------------------------------
; Kosinski Moduled list entry
; ------------------------------------------------------------------------------
; PARAMETERS
;	art  - Art to load
;	vram - VRAM address
; ------------------------------------------------------------------------------

KOSM_LIST_ENTRY macro art, vram
	dc.l	\art
	dc.w	\vram
	__kosm_count: = __kosm_count+1
	endm

; ------------------------------------------------------------------------------
; Kosinski Moduled list end
; ------------------------------------------------------------------------------

KOSM_LIST_END macro
	__kosm_count_\#__kosm_list_count\: equ __kosm_count
	__kosm_list_count: = __kosm_list_count+1
	endm

; ------------------------------------------------------------------------------
