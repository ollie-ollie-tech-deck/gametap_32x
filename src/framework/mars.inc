; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; 32X definitions
; ------------------------------------------------------------------------------

	include	"src/framework/common.inc"

; ------------------------------------------------------------------------------
; Memory map
; ------------------------------------------------------------------------------

; Cache through
TH			equ $20000000				; Cache through

; System registers
SYS_REGS		equ $4000+TH				; System registers
ADAPTER			equ $00					; Adapter control
	BIT_CART:		equ $01
	BIT_ADEN:		equ $02
	BIT_FM:			equ $80
INT_MASK		equ $01					; Interrupt mask
	BIT_PWMIRQ:		equ $01
	BIT_CMDIRQ:		equ $02
	BIT_HIRQ:		equ $04
	BIT_VIRQ:		equ $08
STANDBY			equ $02					; Standby
HCOUNT			equ $05					; H-BLANK interrupt interval
DREQ_CTRL		equ $07					; DREQ control
	BIT_RV:			equ $01
	BIT_DMA:		equ $02
	BIT_D68S:		equ $04
DREQ_SRC		equ $08					; DREQ source address
DREQ_DEST		equ $0C					; DREQ destination address
DREQ_LENGTH		equ $10					; DREQ length
DREQ_FIFO		equ $12					; DREQ FIFO
VRES_CLEAR		equ $14					; VRES interrupt clear
VBLANK_CLEAR		equ $16					; V-BLANK interrupt clear
HBLANK_CLEAR		equ $18					; H-BLANK interrupt clear
CMD_CLEAR		equ $1A					; CMD interrupt clear
PWM_CLEAR		equ $1C					; PWM interrupt clear
COMM_0			equ $20					; Communication register 0
COMM_1			equ $21					; Communication register 1
COMM_2			equ $22					; Communication register 2
COMM_3			equ $23					; Communication register 3
COMM_4			equ $24					; Communication register 4
COMM_5			equ $25					; Communication register 5
COMM_6			equ $26					; Communication register 6
COMM_7			equ $27					; Communication register 7
COMM_8			equ $28					; Communication register 8
COMM_9			equ $29					; Communication register 9
COMM_10			equ $2A					; Communication register 10
COMM_11			equ $2B					; Communication register 11
COMM_12			equ $2C					; Communication register 12
COMM_13			equ $2D					; Communication register 13
COMM_14			equ $2E					; Communication register 14
COMM_15			equ $2F					; Communication register 15
PWM_TIMER		equ $30					; PWM timer interval
PWM_CTRL		equ $31					; PWM control
PWM_CYCLE		equ $32					; PWM cycle
PWM_LEFT		equ $34					; PWM pulse width (left)
PWM_RIGHT		equ $36					; PWM pulse width (right)
PWM_MONO		equ $38					; PWM pulse width (mono)

; VDP registers
VDP_REGS		equ $4100+TH				; VDP registers
TV_MODE			equ $00					; TV mode
	BIT_PAL:		equ $80
BITMAP_MODE		equ $01					; Bitmap mode
	BIT_PRI:		equ $80
	BIT_240:		equ $40
SCREEN_SHIFT		equ $03					; Screen shift
FILL_LENGTH		equ $04					; Frame buffer fill length
FILL_START		equ $06					; Frame buffer fill start
FILL_DATA		equ $08					; Frame buffer fill data
VDP_STATUS		equ $0A					; VDP status
	BIT_PEN:		equ $20
	BIT_HBLK:		equ $40
	BIT_VBLK:		equ $80
FRAME_CTRL		equ $0B					; Frame buffer control
	BIT_FS:			equ $01
	BIT_FEN:		equ $02

; CRAM
CRAM			equ $4200+TH				; CRAM start
CRAM_SIZE		equ $200				; CRAM size
CRAM_END		equ CRAM+CRAM_SIZE			; CRAM end

; Cartridge ROM
CARTRIDGE		equ $2000000				; Cartridge ROM start
CART_SIZE		equ $400000				; Cartridge ROM size
CART_END		equ CARTRIDGE+CART_SIZE			; Cartridge ROM end

; Frame buffer
FRAME_BUFFER		equ $4000000+TH				; Frame buffer start
FRAME_BUFFER_SIZE	equ $20000				; Frame buffer size
FRAME_BUFFER_END	equ FRAME_BUFFER+FRAME_BUFFER_END	; Frame buffer end
OVER_WRITE		equ $4020000+TH				; Over write start
OVER_WRITE_END		equ FRAME_BUFFER+FRAME_END		; Over write end

; SDRAM
SDRAM			equ $6000000				; SDRAM start
SDRAM_SIZE		equ $40000				; SDRAM size
SDRAM_END		equ SDRAM+SDRAM_SIZE			; SDRAM end

; Cache
CACHE			equ $C0000000				; Cache memory start

; Peripheral
FRT			equ $FFFFFE10				; Free running timer registers
TIER			equ $00					; Free running timer enable
TCSR			equ $01					; Free running timer control/status
FRCH			equ $02					; Free running counter (high)
FRCL			equ $03					; Free running counter (low)
OCRH			equ $04					; Output compare (high)
OCRL			equ $05					; Output compare (low)
TCR			equ $06					; Timer control
TOCR			equ $07					; Timer output compare control
CCR			equ $FFFFFE92				; Cache control register
DIV			equ $FFFFFF00				; Division registers
DVSR			equ $00					; Divisor
DVDNT			equ $04					; Dividend for 32-bit division
DVCR			equ $08					; Division control
VCRDIV			equ $0C					; Division vector number
DVDNTH			equ $10					; Dividend (high)
DVDNTL			equ $14					; Dividend (low)
DMA0			equ $FFFFFF80				; DMA channel 0 registers
SAR0			equ $00					; DMA channel 0 source
DAR0			equ $04					; DMA channel 0 destination
TCR0			equ $08					; DMA channel 0 count
CHCR0			equ $0C					; DMA channel 0 control
VCRDMA0			equ $20					; DMA channel 0 vector number
DRCR0			equ $FFFFFE71				; DMA channel 0 request/response selection
DMA1			equ $FFFFFF90				; DMA channel 1 registers
SAR1			equ $00					; DMA channel 1 source
DAR1			equ $04					; DMA channel 1 destination
TCR1			equ $08					; DMA channel 1 count
CHCR1			equ $0C					; DMA channel 1 control
VCRDMA1			equ $18					; DMA channel 1 vector number
DRCR1			equ $FFFFFE72				; DMA channel 1 request/response selection
DMAOR			equ $FFFFFFB0				; DMA operation

; ------------------------------------------------------------------------------
; Includes
; ------------------------------------------------------------------------------

	include	"src/framework/mars/draw_line.inc"
	include	"src/framework/mars/draw_shape.inc"
	include	"src/framework/mars/draw_sprite_distorted.inc"
	include	"src/framework/mars/draw_sprite_scaled.inc"
	include	"src/framework/mars/draw_sprite_unscaled.inc"
	include	"src/framework/mars/error.inc"
	include	"src/framework/mars/load_sprite.inc"
	include	"src/framework/mars/master_irq.inc"
	include	"src/framework/mars/master_main.inc"
	include	"src/framework/mars/palette.inc"
	include	"src/framework/mars/pwm.inc"
	include	"src/framework/mars/renderer.inc"
	include	"src/framework/mars/screen.inc"
	include	"src/framework/mars/sections.inc"
	include	"src/framework/mars/slave_irq.inc"
	include	"src/framework/mars/slave_main.inc"
	include	"src/framework/mars/vectors.inc"
	include	"src/framework/mars/variables.inc"

; ------------------------------------------------------------------------------
