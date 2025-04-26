; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Initialization
; ------------------------------------------------------------------------------

	section m68k_init
	include	"src/framework/md.inc"

	global HardReset
	global SoftReset
	global RestartGame
	global Main
	
; ------------------------------------------------------------------------------
; Hard reset
; ------------------------------------------------------------------------------

HardReset:
	; Standard 32X initialization by SEGA. Because this is required
	; for the ROM to boot at all, it is legal under US law to use this.
	dc.b	$28, $7C, $FF, $FF, $FF, $C0, $23, $FC, $00, $00, $00, $00
	dc.b	$00, $A1, $51, $28, $46, $FC, $27, $00, $4B, $F9, $00, $A1
	dc.b	$00, $00, $70, $01, $0C, $AD, $4D, $41, $52, $53, $30, $EC
	dc.b	$66, $00, $03, $E6, $08, $2D, $00, $07, $51, $01, $67, $F8
	dc.b	$4A, $AD, $00, $08, $67, $10, $4A, $6D, $00, $0C, $67, $0A
	dc.b	$08, $2D, $00, $00, $51, $01, $66, $00, $03, $B8, $10, $2D
	dc.b	$00, $01, $02, $00, $00, $0F, $67, $06, $2B, $78, $05, $5A
	dc.b	$40, $00, $72, $00, $2C, $41, $4E, $66, $41, $F9, $00, $00
	dc.b	$04, $D4, $61, $00, $01, $52, $61, $00, $01, $76, $47, $F9
	dc.b	$00, $00, $04, $E8, $43, $F9, $00, $A0, $00, $00, $45, $F9
	dc.b	$00, $C0, $00, $11, $3E, $3C, $01, $00, $70, $00, $3B, $47
	dc.b	$11, $00, $3B, $47, $12, $00, $01, $2D, $11, $00, $66, $FA
	dc.b	$74, $25, $12, $DB, $51, $CA, $FF, $FC, $3B, $40, $12, $00
	dc.b	$3B, $40, $11, $00, $3B, $47, $12, $00, $14, $9B, $14, $9B
	dc.b	$14, $9B, $14, $9B, $41, $F9, $00, $00, $04, $C0, $43, $F9
	dc.b	$00, $FF, $00, $00, $22, $D8, $22, $D8, $22, $D8, $22, $D8
	dc.b	$22, $D8, $22, $D8, $22, $D8, $22, $D8, $41, $F9, $00, $FF
	dc.b	$00, $00, $4E, $D0, $1B, $7C, $00, $01, $51, $01, $41, $F9
	dc.b	$00, $00, $06, $BC, $D1, $FC, $00, $88, $00, $00, $4E, $D0
	dc.b	$04, $04, $30, $3C, $07, $6C, $00, $00, $00, $00, $FF, $00
	dc.b	$81, $37, $00, $02, $01, $00, $00, $00, $AF, $01, $D9, $1F
	dc.b	$11, $27, $00, $21, $26, $00, $F9, $77, $ED, $B0, $DD, $E1
	dc.b	$FD, $E1, $ED, $47, $ED, $4F, $D1, $E1, $F1, $08, $D9, $C1
	dc.b	$D1, $E1, $F1, $F9, $F3, $ED, $56, $36, $E9, $E9, $9F, $BF
	dc.b	$DF, $FF, $4D, $41, $52, $53, $20, $49, $6E, $69, $74, $69
	dc.b	$61, $6C, $20, $26, $20, $53, $65, $63, $75, $72, $69, $74
	dc.b	$79, $20, $50, $72, $6F, $67, $72, $61, $6D, $20, $20, $20
	dc.b	$20, $20, $20, $20, $20, $20, $20, $43, $61, $72, $74, $72
	dc.b	$69, $64, $67, $65, $20, $56, $65, $72, $73, $69, $6F, $6E
	dc.b	$20, $20, $20, $20, $43, $6F, $70, $79, $72, $69, $67, $68
	dc.b	$74, $20, $53, $45, $47, $41, $20, $45, $4E, $54, $45, $52
	dc.b	$50, $52, $49, $53, $45, $53, $2C, $4C, $54, $44, $2E, $20
	dc.b	$31, $39, $39, $34, $20, $20, $20, $20, $20, $20, $20, $20
	dc.b	$20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
	dc.b	$20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
	dc.b	$20, $20, $52, $4F, $4D, $20, $56, $65, $72, $73, $69, $6F
	dc.b	$6E, $20, $31, $2E, $30, $00, $48, $E7, $C0, $40, $43, $F9
	dc.b	$00, $C0, $00, $04, $30, $11, $30, $3C, $80, $00, $32, $3C
	dc.b	$01, $00, $3E, $3C, $00, $12, $10, $18, $32, $80, $D0, $41
	dc.b	$51, $CF, $FF, $F8, $4C, $DF, $02, $03, $4E, $75, $48, $E7
	dc.b	$81, $C0, $41, $F9, $00, $00, $06, $3E, $43, $F9, $00, $C0
	dc.b	$00, $04, $32, $98, $32, $98, $32, $98, $32, $98, $32, $98
	dc.b	$32, $98, $32, $98, $22, $98, $33, $41, $FF, $FC, $30, $11
	dc.b	$08, $00, $00, $01, $66, $F8, $32, $98, $32, $98, $70, $00
	dc.b	$22, $BC, $C0, $00, $00, $00, $7E, $0F, $33, $40, $FF, $FC
	dc.b	$33, $40, $FF, $FC, $33, $40, $FF, $FC, $33, $40, $FF, $FC
	dc.b	$51, $CF, $FF, $EE, $22, $BC, $40, $00, $00, $10, $7E, $09
	dc.b	$33, $40, $FF, $FC, $33, $40, $FF, $FC, $33, $40, $FF, $FC
	dc.b	$33, $40, $FF, $FC, $51, $CF, $FF, $EE, $4C, $DF, $03, $81
	dc.b	$4E, $75, $81, $14, $8F, $01, $93, $FF, $94, $FF, $95, $00
	dc.b	$96, $00, $97, $80, $40, $00, $00, $80, $81, $04, $8F, $02
	dc.b	$48, $E7, $C1, $40, $43, $F9, $00, $A1, $51, $80, $08, $A9
	dc.b	$00, $07, $FF, $80, $66, $F8, $3E, $3C, $00, $FF, $70, $00
	dc.b	$72, $00, $33, $7C, $00, $FF, $00, $04, $33, $41, $00, $06
	dc.b	$33, $40, $00, $08, $4E, $71, $08, $29, $00, $01, $00, $0B
	dc.b	$66, $F8, $06, $41, $01, $00, $51, $CF, $FF, $E8, $4C, $DF
	dc.b	$02, $83, $4E, $75, $48, $E7, $81, $80, $41, $F9, $00, $A1
	dc.b	$52, $00, $08, $A8, $00, $07, $FF, $00, $66, $F8, $3E, $3C
	dc.b	$00, $1F, $20, $C0, $20, $C0, $20, $C0, $20, $C0, $51, $CF
	dc.b	$FF, $F6, $4C, $DF, $01, $81, $4E, $75, $41, $F9, $00, $FF
	dc.b	$00, $00, $3E, $3C, $07, $FF, $70, $00, $20, $C0, $20, $C0
	dc.b	$20, $C0, $20, $C0, $20, $C0, $20, $C0, $20, $C0, $20, $C0
	dc.b	$51, $CF, $FF, $EE, $3B, $7C, $00, $00, $12, $00, $7E, $0A
	dc.b	$51, $CF, $FF, $FE, $43, $F9, $00, $A1, $51, $00, $70, $00
	dc.b	$23, $40, $00, $20, $23, $40, $00, $24, $1B, $7C, $00, $03
	dc.b	$51, $01, $2E, $79, $00, $88, $00, $00, $08, $91, $00, $07
	dc.b	$66, $FA, $70, $00, $33, $40, $00, $02, $33, $40, $00, $04
	dc.b	$33, $40, $00, $06, $23, $40, $00, $08, $23, $40, $00, $0C
	dc.b	$33, $40, $00, $10, $33, $40, $00, $30, $33, $40, $00, $32
	dc.b	$33, $40, $00, $38, $33, $40, $00, $80, $33, $40, $00, $82
	dc.b	$08, $A9, $00, $00, $00, $8B, $66, $F8, $61, $00, $FF, $12
	dc.b	$08, $E9, $00, $00, $00, $8B, $67, $F8, $61, $00, $FF, $06
	dc.b	$08, $A9, $00, $00, $00, $8B, $61, $00, $FF, $3C, $30, $3C
	dc.b	$00, $40, $22, $29, $00, $20, $0C, $81, $53, $51, $45, $52
	dc.b	$67, $00, $00, $92, $30, $3C, $00, $80, $22, $29, $00, $20
	dc.b	$0C, $81, $53, $44, $45, $52, $67, $00, $00, $80, $21, $FC
	dc.b	$00, $88, $02, $A2, $00, $70, $30, $3C, $00, $02, $72, $00
	dc.b	$12, $2D, $00, $01, $14, $29, $00, $80, $E1, $4A, $82, $42
	dc.b	$08, $01, $00, $0F, $66, $0A, $08, $01, $00, $06, $67, $00
	dc.b	$00, $58, $60, $08, $08, $01, $00, $06, $66, $00, $00, $4E
	dc.b	$70, $20, $41, $F9, $00, $88, $00, $00, $3C, $28, $01, $8E
	dc.b	$4A, $46, $67, $00, $00, $10, $34, $29, $00, $28, $0C, $42
	dc.b	$00, $00, $67, $F6, $B4, $46, $66, $2C, $70, $00, $23, $40
	dc.b	$00, $28, $23, $40, $00, $2C, $3E, $14, $2C, $7C, $FF, $FF
	dc.b	$FF, $C0, $4C, $D6, $7F, $F9, $44, $FC, $00, $00, $60, $14
	dc.b	$43, $F9, $00, $A1, $51, $00, $33, $40, $00, $06, $30, $3C
	dc.b	$80, $00, $60, $04, $44, $FC, $00, $01
	
; ------------------------------------------------------------------------------

	bcc.s	SoftReset					; If the initialization was successful, branch				
	btst	#5,d0						; Was there a checksum error?
	beq.s	SoftReset					; If not, branch

.ErrorLoop:
	VDP_CMD move.l,0,CRAM,WRITE,VDP_CTRL			; Display a red screen
	move.w	#$E,VDP_DATA
	bra.s	.ErrorLoop					; Loop here forever

; ------------------------------------------------------------------------------
; Initialize
; ------------------------------------------------------------------------------

SoftReset:
	move	#$2700,sr					; Disable interrupts
	
	lea	.Addresses(pc),a0				; Get addresses
	movem.l	(a0)+,a1-sp
	
	moveq	#0,d0						; Clear RV flag
	move.b	d0,MARS_DREQ_CTRL(a1)
	
	move.b	VERSION,d0					; Get hardware version
	move.b	d0,d3
	andi.b	#$F,d0						; Is this a TMSS system?
	beq.s	.NoTmss						; If not, branch
	move.l	#"SEGA",TMSS_SEGA				; If so, satisfy it

.NoTmss:
	WAIT_DMA (a6)						; Wait for DMA to finish, if there's one leftover

	moveq	#(.VDPSetupEnd-.VDPSetup)/2-1,d1		; Length of VDP setup data

.SetupVdp:
	move.w	(a0)+,(a6)					; Set VDP register
	dbf	d1,.SetupVdp					; Loop until all of them are set
	
	moveq	#0,d0						; Perform VRAM clear
	move.w	d0,(a5)
	WAIT_DMA (a6)
	move.w	(a0)+,(a6)
	
	move.l	(a0)+,(a6)					; Set CRAM write command
	moveq	#$80/4-1,d1					; Length of CRAM
	
.ClearCram:
	move.l	d0,(a5)						; Clear CRAM
	dbf	d1,.ClearCram					; Loop until CRAM is cleared
	
	move.l	(a0)+,(a6)					; Set VSRAM write command
	moveq	#$50/4-1,d1					; Length of VSRAM
	
.ClearVsram:
	move.l	d0,(a5)						; Clear VSRAM
	dbf	d1,.ClearVsram					; Loop until VSRAM is cleared
	
	moveq	#$FFFFFF9F,d2					; PSG1 silence
	moveq	#4-1,d1						; Number of PSG channels
	
.SilencePsg:
	move.b	d2,PSG_CTRL-VDP_CTRL(a6)			; Silence PSG channel
	addi.b	#$20,d2						; Next PSG channel
	dbf	d1,.SilencePsg					; Loop until all PSG channels are silenced
	
	move.w	#$100,d2					; Stop the Z80
	move.w	d2,(a3)
	move.w	d2,(a4)						; Stop Z80 reset

.WaitZ80Stop:
	btst	d0,(a3)						; Has the Z80 stopped?
	bne.s	.WaitZ80Stop					; If not, wait

	moveq	#$40,d1						; Set up I/O ports
	move.b	d1,(sp)+
	move.b	d1,(sp)+
	move.b	d1,(sp)+
	
	lea	stack,sp					; Reset stack pointer
	
	move.w	#.Z80ProgramEnd-.Z80Program-1,d1		; Length of Z80 program

.LoadZ80Program:
	move.b	(a0)+,(a2)+					; Load Z80 program
	dbf	d1,.LoadZ80Program				; Loop until Z80 program is loaded

	move.w	#(Z80_SIZE-(.Z80ProgramEnd-.Z80Program))-1,d1	; Remaining length of Z80 RAM

.ClearZ80Ram:
	move.b	d0,(a2)+					; Clear the rest of Z80 RAM
	dbf	d1,.ClearZ80Ram					; Loop until finished
	
	move.w	d0,(a4)						; Reset the Z80
	rol.b	#8,d0
	move.w	d0,(a3)						; Start the Z80
	move.w	d2,(a4)						; Stop Z80 reset

.WaitMaster:
	bsr.w	CheckSh2Error					; Check for errors
	cmpi.l	#"M_OK",MARS_COMM_0(a1)				; Is the Master CPU initialized?
	bne.s	.WaitMaster					; If not, wait

.WaitSlave:
	bsr.w	CheckSh2Error					; Check for errors
	cmpi.l	#"S_OK",MARS_COMM_4(a1)				; Is the Slave CPU initialized?
	bne.s	.WaitSlave					; If not, wait
	
	move.l	#"M_ST",MARS_COMM_0(a1)				; Allow the SH-2s to start		
	move.l	#"S_ST",MARS_COMM_4(a1)
	
.WaitInitEnd:
	bsr.w	CheckSh2Error					; Check for errors
	cmpi.l	#"M_ST",MARS_COMM_0(a1)				; Are both CPUs running now?
	beq.s	.WaitInitEnd					; If not, wait
	cmpi.l	#"S_ST",MARS_COMM_4(a1)
	beq.s	.WaitInitEnd					; If not, wait
	
	movea.l	d0,a6						; Set base of work RAM
	move.l	a6,usp						; Set user stack pointer

	move.w	#WORK_RAM_SIZE/4-1,d1				; Length of work RAM
	
.ClearWorkRam:
	move.l	d0,-(a6)					; Clear work RAM
	dbf	d1,.ClearWorkRam				; Loop until work RAM is cleared

	move.b	d3,hardware_version				; Save hardware version
	move.w	#$4E73,hblank_int				; Set H-BLANK interrupt to "rte"

	move.b	#3,MARS_BANK+MARS_SYS				; Set ROM bank

	moveq	#PLANE_SIZE_64_32,d0				; Set plane size to 64x32
	bsr.w	SetPlaneSize
	
	bsr.w	InitSprites					; Initialize sprites
	bsr.w	InitDmaQueue					; Initialize DMA queue
	
	bsr.w	DisableAtGamesSound				; Disable AtGames sound mode
	bsr.w	WaitSoundCommand

	move.w	#mars_draw_buffer,mars_draw_slot		; Reset 32X draw command buffer slot
	move.w	#mars_gfx_buffer,mars_gfx_slot			; Reset 32X graphics data command buffer slot

	moveq	#CHUNK_SIZE_128,d0				; Set map chunk size to 128x128
	bsr.w	SetMapChunkSize

	movem.l	(a6),d0-a6					; Clear registers
	
	jmp	Main						; Go to main routine

; ------------------------------------------------------------------------------
; Addresses
; ------------------------------------------------------------------------------

.Addresses:
	dc.l	MARS_SYS					; a1: 32X system registers
	dc.l	Z80_RAM						; a2: Z80 RAM
	dc.l	Z80_BUS						; a3: Z80 bus port
	dc.l	Z80_RESET					; a4: Z80 reset port
	dc.l	VDP_DATA					; a5: VDP data port
	dc.l	VDP_CTRL					; a6: VDP control port
	dc.l	IO_CTRL_1					; sp: I/O control port 1

; ------------------------------------------------------------------------------
; VDP setup data
; ------------------------------------------------------------------------------

.VDPSetup:
	dc.w	$8000|%00000100					; Disable H-BLANK interrupt
	dc.w	$8100|%00110100					; Enable DMA and V-BLANK interrupt, disable display
	dc.w	$8200|($C000>>10)				; Plane A VRAM address
	dc.w	$8300|($D000>>10)				; Window plane VRAM address
	dc.w	$8400|($E000>>13)				; Plane B VRAM address
	dc.w	$8500|($F800>>9)				; Sprite table VRAM address
	dc.w	$8700						; Background color
	dc.w	$8ADF						; H-BLANK interrupt counter
	dc.w	$8B00|%00000000					; Full screen scroll, disable external interrupt
	dc.w	$8C00|%10000001					; H40 mode, disable shadow/highlight and interlacing
	dc.w	$8D00|($FC00>>10)				; Hortizontal scroll table VRAM address
	dc.w	$8F01						; Auto-increment (for VRAM clear)
	dc.w	$9100						; Window horizontal position
	dc.w	$9200						; Window vertical position
	dc.w	$93FF						; DMA length (for VRAM clear)
	dc.w	$94FF
	dc.w	$9780						; DMA mode (for VRAM clear)
	VDP_CMD dc.l,0,VRAM,DMA					; DMA command (for VRAM clear)
.VDPSetupEnd:
	dc.w	$8F02						; Auto-increment
	VDP_CMD dc.l,0,CRAM,WRITE				; CRAM write command
	VDP_CMD dc.l,0,VSRAM,WRITE				; VSRAM write command

; ------------------------------------------------------------------------------
; Z80 program
; ------------------------------------------------------------------------------

.Z80Program:
	incbin	"out/z80.bin"
.Z80ProgramEnd:
	even

; ------------------------------------------------------------------------------
