; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; 32X variables
; ------------------------------------------------------------------------------
	
MASTER_STACK		equ SDRAM_END				; Master CPU stack base
SLAVE_STACK		equ CACHE+$800				; Slave CPU stack base

; ------------------------------------------------------------------------------

	rsset SDRAM+$3000
variables		rs.b 0					; Start of variables

screen_drawn		rs.l 1					; Screen drawn flag
pal_fade_intensity	rs.l 1					; Palette fade intensity
sprite_data_slot	rs.l 1					; Sprite data slot

			rs.b ($10-(__rs&$F))&$F
draw_cmd_buffer		rs.b $400				; Draw command buffer
gfx_data_cmd_buffer	rs.b $400				; Graphics data command buffer

palette			rs.w $100				; Palette buffer
cram_buffer		rs.w $100				; CRAM buffer

loaded_sprites		rs.l $100				; Loaded sprites
dynamic_sprite_data	rs.b $4000				; Dynamic sprite frame data
sprite_data		rs.b $37800				; Sprite data

MARS_VARS_LENGTH	equ __rs-variables

; ------------------------------------------------------------------------------
