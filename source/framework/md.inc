; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Mega Drive definitions
; ------------------------------------------------------------------------------

	include	"source/framework/common.inc"
	include	"source/framework/md/debugger.inc"

; ------------------------------------------------------------------------------
; Memory map
; ------------------------------------------------------------------------------

; 32X header
MARS_HEADER		equ $000000				; 32X header
BankSet			equ MARS_HEADER+$C0			; Set control or ROM bank
BankSetAll		equ MARS_HEADER+$D4			; Set all ROM banks and control

; Cartridge
CARTRIDGE		equ $000000				; Cartridge start
CARTRIDGE_SIZE		equ $400000				; Cartridge size
CARTRIDGE_END		equ CARTRIDGE+CARTRIDGE_SIZE		; Cartridge end

; SRAM
SRAM			equ $200001				; SRAM start

; 32X frame buffer
MARS_FRAME_BUFFER	equ $840000				; Frame buffer
MARS_FRAME_SIZE		equ $20000				; Frame buffer size
MARS_FRAME_END		equ MARS_FRAME_BUFFER+MARS_FRAME_SIZE	; Frame buffer end
MARS_OVER_WRITE		equ $860000				; Over write
MARS_OVER_END		equ MARS_OVER_WRITE+MARS_FRAME_SIZE	; Over write end

; 32X cartridge
MARS_ROM_FIXED		equ $880000				; Fixed ROM bank
MARS_FIXED_SIZE		equ $80000				; Fixed ROM bank size
MARS_FIXED_END		equ MARS_ROM_FIXED+MARS_FIXED_SIZE	; Fixed ROM bank end
MARS_ROM_BANK		equ $900000				; Switchable ROM bank
MARS_BANK_SIZE		equ $100000				; Switchable ROM bank size
MARS_BANK_END		equ MARS_ROM_BANK+MARS_BANK_SIZE	; Switchable ROM bank end

; Z80 RAM
Z80_RAM			equ $A00000				; Z80 RAM start
Z80_SIZE		equ $2000				; Z80 RAM size
Z80_END			equ Z80_RAM+Z80_SIZE			; Z80 RAM end

; YM2612
YM_ADDR_0		equ $A04000				; YM2612 address port 0
YM_DATA_0		equ $A04001				; YM2612 data port 0
YM_ADDR_1		equ $A04002				; YM2612 address port 1
YM_DATA_1		equ $A04003				; YM2612 data port 1

; I/O
IO_BASE			equ $A10000				; I/O register base
VERSION			equ $A10001				; Hardware version
IO_DATA_1		equ $A10003				; I/O port 1 data
IO_DATA_2		equ $A10005				; I/O port 2 data
IO_DATA_3		equ $A10007				; I/O port 3 data
IO_CTRL_1		equ $A10009				; I/O port 1 control
IO_CTRL_2		equ $A1000B				; I/O port 2 control
IO_CTRL_3		equ $A1000D				; I/O port 3 control

; Z80
Z80_BUS			equ $A11100				; Z80 bus request
Z80_RESET		equ $A11200				; Z80 reset

; Mapper/SRAM
MAPPER_CTRL		equ $A130F1				; Mapper/SRAM control
MAPPER_BANK_1		equ $A130F3				; ROM bank 1
MAPPER_BANK_2		equ $A130F5				; ROM bank 1
MAPPER_BANK_3		equ $A130F7				; ROM bank 1
MAPPER_BANK_4		equ $A130F9				; ROM bank 1
MAPPER_BANK_5		equ $A130FB				; ROM bank 1
MAPPER_BANK_6		equ $A130FD				; ROM bank 1
MAPPER_BANK_7		equ $A130FF				; ROM bank 1

; TMSS
TMSS_SEGA		equ $A14000				; TMSS write register

; 32X
MARS_ID			equ $A130EC				; Identifier
MARS_SYS		equ $A15100				; System registers
MARS_FM			equ $00					; SuperVDP access
	BIT_FM:			equ $07
MARS_ADAPTER		equ $01					; Adapter control
	BIT_ADEN:		equ $00
	BIT_RES:		equ $01
MARS_INT		equ $03					; Interrupt control
	BIT_INTM:		equ $00
	BIT_INTS:		equ $01
MARS_BANK		equ $05					; Cartridge bank
MARS_DREQ_CTRL		equ $07					; DREQ control
	BIT_RV:			equ $00
	BIT_DMA:		equ $01
	BIT_D68S:		equ $02
	BIT_FULL:		equ $07
MARS_DREQ_SRC		equ $08					; DREQ source address
MARS_DREQ_DEST		equ $0C					; DREQ destination address
MARS_DREQ_LENGTH	equ $10					; DREQ length
MARS_DREQ_FIFO		equ $12					; DREQ FIFO
MARS_SEGA_TV		equ $1A					; Sega TV register
	BIT_CM:			equ $00
MARS_COMM_0		equ $20					; Communication register 0
MARS_COMM_1		equ $21					; Communication register 1
MARS_COMM_2		equ $22					; Communication register 2
MARS_COMM_3		equ $23					; Communication register 3
MARS_COMM_4		equ $24					; Communication register 4
MARS_COMM_5		equ $25					; Communication register 5
MARS_COMM_6		equ $26					; Communication register 6
MARS_COMM_7		equ $27					; Communication register 7
MARS_COMM_8		equ $28					; Communication register 8
MARS_COMM_9		equ $29					; Communication register 9
MARS_COMM_10		equ $2A					; Communication register 10
MARS_COMM_11		equ $2B					; Communication register 11
MARS_COMM_12		equ $2C					; Communication register 12
MARS_COMM_13		equ $2D					; Communication register 13
MARS_COMM_14		equ $2E					; Communication register 14
MARS_COMM_15		equ $2F					; Communication register 15
MARS_PWM_TIMER		equ $30					; PWM timer interval
MARS_PWM_CTRL		equ $31					; PWM control
MARS_PWM_CYCLE		equ $32					; PWM cycle
MARS_PWM_LEFT		equ $34					; PWM pulse width (left)
MARS_PWM_RIGHT		equ $36					; PWM pulse width (right)
MARS_PWM_MONO		equ $38					; PWM pulse width (mono)

; 32X VDP
MARS_VDP		equ $A15180				; 32X VDP registers
MARS_TV_MODE		equ $00					; TV mode
	BIT_PAL:		equ $07
MARS_BITMAP_MODE	equ $01					; Bitmap mode
	BIT_L240:		equ $06
	BIT_PRI:		equ $07
MARS_SCREEN_SHIFT	equ $03					; Screen shift
	BIT_SFT:		equ $00
MARS_FILL_LENGTH	equ $04					; Frame buffer fill length
MARS_FILL_START		equ $06					; Frame buffer fill start
MARS_FILL_DATA		equ $08					; Frame buffer fill data
MARS_VDP_STATUS		equ $0A					; VDP status
	BIT_PEN:		equ $05
	BIT_HBLK:		equ $06
	BIT_VBLK:		equ $07
MARS_FRAME_CTRL		equ $0B					; Frame buffer control
	BIT_FS:			equ $00
	BIT_FEN:		equ $01

; 32X palette
MARS_PALETTE		equ $A15200				; Palette
MARS_PALETTE_SIZE	equ $200				; Palette size
MARS_PALETTE_END	equ MARS_PALETTE+MARS_PALETTE_SIZE	; Palette end

; VDP/PSG
VDP_DATA		equ $C00000				; VDP data port
VDP_CTRL		equ $C00004				; VDP control port
VDP_HV			equ $C00008				; VDP H/V counter
PSG_CTRL		equ $C00011				; PSG control port

; Work RAM
WORK_RAM		equ $FFFF0000				; Work RAM start
WORK_RAM_SIZE		equ $10000				; Work RAM size
WORK_RAM_END		equ WORK_RAM+WORK_RAM_SIZE		; Work RAM end

; ------------------------------------------------------------------------------
; Controller buttons
; ------------------------------------------------------------------------------

BUTTON_UP_BIT		equ 0					; Up bit
BUTTON_DOWN_BIT		equ 1					; Down bit
BUTTON_LEFT_BIT		equ 2					; Left bit
BUTTON_RIGHT_BIT	equ 3					; Right bit
BUTTON_B_BIT		equ 4					; B bit
BUTTON_C_BIT		equ 5					; C bit
BUTTON_A_BIT		equ 6					; A bit
BUTTON_START_BIT	equ 7					; Start bit

BUTTON_UP		equ 1<<BUTTON_UP_BIT			; Up mask
BUTTON_DOWN		equ 1<<BUTTON_DOWN_BIT			; Down mask
BUTTON_LEFT		equ 1<<BUTTON_LEFT_BIT			; Left mask
BUTTON_RIGHT		equ 1<<BUTTON_RIGHT_BIT			; Right mask
BUTTON_B		equ 1<<BUTTON_B_BIT			; B mask
BUTTON_C		equ 1<<BUTTON_C_BIT			; C mask
BUTTON_A		equ 1<<BUTTON_A_BIT			; A mask
BUTTON_START		equ 1<<BUTTON_START_BIT			; Start mask

; ------------------------------------------------------------------------------
; Reqeust Z80 bus access
; ------------------------------------------------------------------------------
; PARAMETERS:
;	reg - Z80 control port (optional)
; ------------------------------------------------------------------------------

REQUEST_Z80 macro reg
	if narg>0
		move.w	#$100,\reg
	else
		move.w	#$100,Z80_BUS
	endif
	endm

; ------------------------------------------------------------------------------
; Wait for Z80 bus acknowledgement
; ------------------------------------------------------------------------------
; PARAMETERS:
;	reg - Z80 control port (optional)
; ------------------------------------------------------------------------------

WAIT_Z80 macro reg
.Wait\@:
	if narg>0
		btst	#0,\reg
	else
		btst	#0,Z80_BUS
	endif
	bne.s	.Wait\@
	endm

; ------------------------------------------------------------------------------
; Stop the Z80 and get bus access
; ------------------------------------------------------------------------------
; PARAMETERS:
;	reg - Z80 control port (optional)
; ------------------------------------------------------------------------------

STOP_Z80 macro reg
	if narg>0
		REQUEST_Z80 \reg
		WAIT_Z80 \reg
	else
		REQUEST_Z80
		WAIT_Z80
	endif
	endm

; ------------------------------------------------------------------------------
; Start the Z80 and release bus access
; ------------------------------------------------------------------------------
; PARAMETERS:
;	reg - Z80 bus port (optional)
; ------------------------------------------------------------------------------

START_Z80 macro reg
	if narg>0
		move.w	#0,\reg
	else
		move.w	#0,Z80_BUS
	endif
	endm

; ------------------------------------------------------------------------------
; Start Z80 reset
; ------------------------------------------------------------------------------
; PARAMETERS:
;	reg - Z80 reset port (optional)
; ------------------------------------------------------------------------------

RESET_Z80_ON macro reg
	if narg>0
		move.w	#0,\reg
	else
		move.w	#0,Z80_RESET
	endif
	ror.b	#8,d0
	endm

; ------------------------------------------------------------------------------
; Stop Z80 reset
; ------------------------------------------------------------------------------
; PARAMETERS:
;	reg - Z80 reset port (optional)
; ------------------------------------------------------------------------------

RESET_Z80_OFF macro reg
	if narg>0
		move.w	#$100,\reg
	else
		move.w	#$100,Z80_RESET
	endif
	endm

; ------------------------------------------------------------------------------
; Wait for a VDP DMA to finish
; ------------------------------------------------------------------------------
; PARAMETERS:
;	ctrl - VDP control port (optional)
; ------------------------------------------------------------------------------

WAIT_DMA macro ctrl
.Wait\@:
	if narg>0
		move	\ctrl,ccr
	else
		move	VDP_CTRL,ccr
	endif
	bvs.s	.Wait\@
	endm

; ------------------------------------------------------------------------------
; VDP command instruction
; ------------------------------------------------------------------------------
; PARAMETERS:
;	ins  - Instruction
;	addr - Address in VDP memory
;	type - Type of VDP memory
;	rwd  - VDP command
;	dest - Destination (optional)
; ------------------------------------------------------------------------------

VRAM_WRITE_CMD		equ $40000000				; VRAM write
CRAM_WRITE_CMD		equ $C0000000				; CRAM write
VSRAM_WRITE_CMD		equ $40000010				; VSRAM write
VRAM_READ_CMD		equ $00000000				; VRAM read
CRAM_READ_CMD		equ $00000020				; CRAM read
VSRAM_READ_CMD		equ $00000010				; VSRAM read
VRAM_DMA_CMD		equ $40000080				; VRAM DMA
CRAM_DMA_CMD		equ $C0000080				; CRAM DMA
VSRAM_DMA_CMD		equ $40000090				; VSRAM DMA
VRAM_COPY_CMD		equ $000000C0				; VRAM DMA copy

; ------------------------------------------------------------------------------

VDP_CMD macro ins, addr, type, rwd, dest
	local cmd
	cmd: = (\type\_\rwd\_CMD)|(((\addr)&$3FFF)<<16)|((\addr)/$4000)
	if narg=5
		\ins	#\#cmd,\dest
	else
		\ins	cmd
	endif
	endm

; ------------------------------------------------------------------------------
; VDP command instruction (low word)
; ------------------------------------------------------------------------------
; PARAMETERS:
;	ins  - Instruction
;	addr - Address in VDP memory
;	type - Type of VDP memory
;	rwd  - VDP command
;	dest - Destination (optional)
; ------------------------------------------------------------------------------

VDP_CMD_LO macro ins, addr, type, rwd, dest
	local cmd
	cmd: = ((\type\_\rwd\_CMD)&$FFFF)|((\addr)/$4000)
	if narg=5
		\ins	#\#cmd,\dest
	else
		\ins	cmd
	endif
	endm

; ------------------------------------------------------------------------------
; VDP command instruction (high word)
; ------------------------------------------------------------------------------
; PARAMETERS:
;	ins  - Instruction
;	addr - Address in VDP memory
;	type - Type of VDP memory
;	rwd  - VDP command
;	dest - Destination (optional)
; ------------------------------------------------------------------------------

VDP_CMD_HI macro ins, addr, type, rwd, dest
	local cmd
	cmd: = ((\type\_\rwd\_CMD)>>16)|((\addr)&$3FFF)
	if narg=5
		\ins	#\#cmd,\dest
	else
		\ins	cmd
	endif
	endm

; ------------------------------------------------------------------------------
; VDP DMA from 68000 memory to VDP memory
; ------------------------------------------------------------------------------
; PARAMETERS:
;	src  - Source address in 68000 memory
;	dest - Destination address in VDP memory
;	len  - Length of data in bytes
;	type - Type of VDP memory
;	ctrl - VDP control port (optional)
; ------------------------------------------------------------------------------

DMA_68K macro src, dest, len, type, ctrl
	if narg>4
		move.l	#$94009300|((((\len)/2)&$FF00)<<8)|(((\len)/2)&$FF),\ctrl
		move.l	#$96009500|((((\src)/2)&$FF00)<<8)|(((\src)/2)&$FF),\ctrl
		move.w	#$9700|(((\src)>>17)&$7F),\ctrl
		VDP_CMD_HI move.w,\dest,\type,DMA,\ctrl
		VDP_CMD_LO move.w,\dest,\type,DMA,-(sp)
		move.w	(sp)+,\ctrl
	else
		move.l	#$94009300|((((\len)/2)&$FF00)<<8)|(((\len)/2)&$FF),VDP_CTRL
		move.l	#$96009500|((((\src)/2)&$FF00)<<8)|(((\src)/2)&$FF),VDP_CTRL
		move.w	#$9700|(((\src)>>17)&$7F),VDP_CTRL
		VDP_CMD_HI move.w,\dest,\type,DMA,VDP_CTRL
		VDP_CMD_LO move.w,\dest,\type,DMA,-(sp)
		move.w	(sp)+,VDP_CTRL
	endif
	endm

; ------------------------------------------------------------------------------
; Fill VRAM with byte
; (Auto-increment should be set to 1 beforehand)
; ------------------------------------------------------------------------------
; PARAMETERS:
;	addr - Address in VRAM
;	len  - Length of fill in bytes
;	byte - Byte to fill VRAM with
;	ctrl - VDP control port (optional)
;	data - VDP data port (optional)
; ------------------------------------------------------------------------------

VRAM_FILL macro addr, len, byte, ctrl, data
	if narg>3
		move.l	#$94009300|((((\len)-1)&$FF00)<<8)|(((\len)-1)&$FF),\ctrl
		move.w	#$9780,\ctrl
		VDP_CMD move.l,\addr,VRAM,DMA,\ctrl
		move.w	#(\byte)<<8,\data
		WAIT_DMA \ctrl
	else
		move.l	#$94009300|((((\len)-1)&$FF00)<<8)|(((\len)-1)&$FF),VDP_CTRL
		move.w	#$9780,VDP_CTRL
		VDP_CMD move.l,\addr,VRAM,DMA,VDP_CTRL
		move.w	#(\byte)<<8,VDP_DATA
		WAIT_DMA
	endif
	endm

; ------------------------------------------------------------------------------
; Copy a region of VRAM to a location in VRAM
; (Auto-increment should be set to 1 beforehand)
; ------------------------------------------------------------------------------
; PARAMETERS:
;	src  - Source address in VRAM
;	dest - Destination address in VRAM
;	len  - Length of copy in bytes
;	ctrl - VDP control port (optional)
; ------------------------------------------------------------------------------

VRAM_COPY macro src, dest, len, ctrl
	if narg>3
		move.l	#$94009300|((((\len)-1)&$FF00)<<8)|(((\len)-1)&$FF),\ctrl
		move.l	#$96009500|(((\src)&$FF00)<<8)|((\src)&$FF),\ctrl
		move.w	#$97C0,\ctrl
		VDP_CMD move.l,\dest,VRAM,COPY,\ctrl
		WAIT_DMA \ctrl
	else
		move.l	#$94009300|((((\len)-1)&$FF00)<<8)|(((\len)-1)&$FF),VDP_CTRL
		move.l	#$96009500|(((\src)&$FF00)<<8)|((\src)&$FF),VDP_CTRL
		move.w	#$97C0,VDP_CTRL
		VDP_CMD move.l,\dest,VRAM,COPY,VDP_CTRL
		WAIT_DMA
	endif
	endm

; ------------------------------------------------------------------------------
; Send interrupt request to the 32X
; ------------------------------------------------------------------------------
; PARAMETERS
;	msh - Trigger Master CPU command interrupt
;	ssh - Trigger Slave CPU command interrupt
; ------------------------------------------------------------------------------

CMD_INT macro msh, ssh
	ori.b	#(\msh)|((\ssh)<<1),MARS_SYS+MARS_INT		; Request interrupt

.WaitInt\@:
	jsr	CheckSH2Error					; Check for errors
	move.b	MARS_SYS+MARS_INT,d0				; Wait for the 32X to acknowledge it
	andi.b	#(\msh)|((\ssh)<<1),d0
	bne.s	.WaitInt\@
	endm

; ------------------------------------------------------------------------------
; Wait for DREQ to be ready
; ------------------------------------------------------------------------------

WAIT_DREQ macro
.Wait\@:
	jsr	CheckSH2Error					; Check for errors
	tst.b	MARS_SYS+MARS_DREQ_CTRL				; Is DREQ ready?
	bmi.s	.Wait\@						; If not, wait
	endm

; ------------------------------------------------------------------------------
; Includes
; ------------------------------------------------------------------------------

	include	"source/framework/md/animation.inc"
	include	"source/framework/md/controller.inc"
	include	"source/framework/md/dma.inc"
	include	"source/framework/md/enigma.inc"
	include	"source/framework/md/error.inc"
	include	"source/framework/md/interrupt.inc"
	include	"source/framework/md/kosinski.inc"
	include	"source/framework/md/list.inc"
	include	"source/framework/md/map.inc"
	include	"source/framework/md/mars.inc"
	include	"source/framework/md/math.inc"
	include	"source/framework/md/memory.inc"
	include	"source/framework/md/object.inc"
	include	"source/framework/md/palette.inc"
	include	"source/framework/md/scene.inc"
	include	"source/framework/md/scroll.inc"
	include	"source/framework/md/sound.inc"
	include	"source/framework/md/sprite.inc"
	include	"source/framework/md/tilemap.inc"
	include	"source/framework/md/vdp.inc"
	include	"source/framework/md/variables.inc"
	include	"source/framework/z80/variables.inc"

; ------------------------------------------------------------------------------
