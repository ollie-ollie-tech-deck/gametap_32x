; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sections
; ------------------------------------------------------------------------------

	include	"source/framework/mars.inc"

; ------------------------------------------------------------------------------
; SH-2 program addresses
; ------------------------------------------------------------------------------

	section sh2_start
MarsProgram:

	section sh2_end
MarsProgramEnd:

; ------------------------------------------------------------------------------
; Slave CPU cache program addresses 
; ------------------------------------------------------------------------------

	section sh2_s_cache_start
SlaveCache:

	section sh2_s_cache_end
SlaveCacheEnd:
	
; ------------------------------------------------------------------------------