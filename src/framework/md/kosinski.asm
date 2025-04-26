; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Kosinski decompression functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/framework/md.inc"
	
; ------------------------------------------------------------------------------
; Decompress Kosinski data into RAM
; ------------------------------------------------------------------------------
; New faster version by written by vladikcomper, with additional
; improvements by MarkeyJester and Flamewing
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Source data address
;	a1.l - Destination buffer address
; ------------------------------------------------------------------------------
; RETURNS:
;	a0.l - End of source data address
;	a1.l - End of destination buffer address
; ------------------------------------------------------------------------------

_Kos_RunBitStream macro
	dbf	d2,.Skip\@
	
	moveq	#7,d2						; Set repeat count to 8.
	move.b	d1,d0						; Use the remaining 8 bits.
	not.w	d3						; Have all 16 bits been used up?
	bne.s	.Skip\@						; Branch if not.
	
	move.b	(a0)+,d0					; Get desc field low-byte.
	move.b	(a0)+,d1					; Get desc field hi-byte.
	move.b	(a4,d0.w),d0					; Invert bit order...
	move.b	(a4,d1.w),d1					; ... for both bytes.
	
.Skip\@:
	endm

; ------------------------------------------------------------------------------

_Kos_ReadBit macro
	add.b	d0,d0						; Get a bit from the bitstream.
	endm

; ------------------------------------------------------------------------------

KosDec:
	include	"src/framework/md/kosinski_internal.inc"	; Decompress data
	rts

; ------------------------------------------------------------------------------

KosDec_ByteMap:
	dc.b	$00,$80,$40,$C0,$20,$A0,$60,$E0,$10,$90,$50,$D0,$30,$B0,$70,$F0
	dc.b	$08,$88,$48,$C8,$28,$A8,$68,$E8,$18,$98,$58,$D8,$38,$B8,$78,$F8
	dc.b	$04,$84,$44,$C4,$24,$A4,$64,$E4,$14,$94,$54,$D4,$34,$B4,$74,$F4
	dc.b	$0C,$8C,$4C,$CC,$2C,$AC,$6C,$EC,$1C,$9C,$5C,$DC,$3C,$BC,$7C,$FC
	dc.b	$02,$82,$42,$C2,$22,$A2,$62,$E2,$12,$92,$52,$D2,$32,$B2,$72,$F2
	dc.b	$0A,$8A,$4A,$CA,$2A,$AA,$6A,$EA,$1A,$9A,$5A,$DA,$3A,$BA,$7A,$FA
	dc.b	$06,$86,$46,$C6,$26,$A6,$66,$E6,$16,$96,$56,$D6,$36,$B6,$76,$F6
	dc.b	$0E,$8E,$4E,$CE,$2E,$AE,$6E,$EE,$1E,$9E,$5E,$DE,$3E,$BE,$7E,$FE
	dc.b	$01,$81,$41,$C1,$21,$A1,$61,$E1,$11,$91,$51,$D1,$31,$B1,$71,$F1
	dc.b	$09,$89,$49,$C9,$29,$A9,$69,$E9,$19,$99,$59,$D9,$39,$B9,$79,$F9
	dc.b	$05,$85,$45,$C5,$25,$A5,$65,$E5,$15,$95,$55,$D5,$35,$B5,$75,$F5
	dc.b	$0D,$8D,$4D,$CD,$2D,$AD,$6D,$ED,$1D,$9D,$5D,$DD,$3D,$BD,$7D,$FD
	dc.b	$03,$83,$43,$C3,$23,$A3,$63,$E3,$13,$93,$53,$D3,$33,$B3,$73,$F3
	dc.b	$0B,$8B,$4B,$CB,$2B,$AB,$6B,$EB,$1B,$9B,$5B,$DB,$3B,$BB,$7B,$FB
	dc.b	$07,$87,$47,$C7,$27,$A7,$67,$E7,$17,$97,$57,$D7,$37,$B7,$77,$F7
	dc.b	$0F,$8F,$4F,$CF,$2F,$AF,$6F,$EF,$1F,$9F,$5F,$DF,$3F,$BF,$7F,$FF

; ------------------------------------------------------------------------------
; Initialize Kosisnki queue
; ------------------------------------------------------------------------------

InitKosQueue:
	lea	kos_queue_vars,a0				; Clear variables
	move.w	#kos_queue_vars_end-kos_queue_vars,d0		; Length
	bra.w	ClearMemory

; ------------------------------------------------------------------------------
; Flush Kosinski moduled queue
; ------------------------------------------------------------------------------

FlushKosmQueue:
	bsr.w	ProcessKosQueue					; Process Kosinski queue
	bsr.w	ProcessKosmQueue				; Process Kosinski moduled queue
	
	STOP_Z80						; Flush DMA queue
	jsr	FlushDmaQueue
	START_Z80
	
	tst.w	kosm_mods_left					; Is there any Kosinski moduled data left?
	bne.s	FlushKosmQueue					; If so, process them
	
	rts

; ------------------------------------------------------------------------------
; Queue a Kosinski Moduled list
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a3.l - Pointer to list
; ------------------------------------------------------------------------------

QueueKosmList:
	move.w  (a3)+,d6					; Get number of entries
	bmi.s   .End						; If it's negative, branch

.Queue:
	movea.l (a3)+,a1					; Get art pointer
	move.w  (a3)+,d2					; Get VRAM address
	bsr.s   QueueKosmData					; Queue
	
	dbf     d6,.Queue					; Loop until finished

.End:
	rts

; ------------------------------------------------------------------------------
; Adds Kosinski Moduled data to the queue
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Destination in VRAM
;	a1.l - Kosinski Moduled data address
; ------------------------------------------------------------------------------

QueueKosmData:
	lea	kosm_queue,a2					; Queue buffer
	tst.l	(a2)						; Is the first slot free?
	beq.s	InitKosmProcess					; If it is, branch
	
.FindFreeSlot:
	addq.w	#6,a2						; Otherwise, check next slot
	tst.l	(a2)
	bne.s	.FindFreeSlot
	
	move.l	a1,(a2)+					; Store source address
	move.w	d2,(a2)+					; Store destination VRAM address
	rts

; ------------------------------------------------------------------------------
; Initialize processing of the first module on the queue
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Destination in VRAM
;	a1.l - Kosinski Moduled data address
; ------------------------------------------------------------------------------

InitKosmProcess:
	move.w	(a1)+,d3					; Get uncompressed size
	cmpi.w	#$A000,d3
	bne.s	.GotSize
	move.w	#$8000,d3					; $A000 means $8000 for some reason

.GotSize:
	move.w	d3,d0						; Get number of complete modules
	rol.w	#4,d0
	andi.w	#$1F,d0
	move.w	d0,kosm_mods_left
	
	andi.w	#$FFF,d3					; Get size of last module in words
	bne.s	.GotLeftover					; Branch if it's non-zero
	subq.w	#1,kosm_mods_left				; Otherwise decrement the number of modules
	move.w	#$1000,d3					; And make the size of the last module $800 words

.GotLeftover:
	move.w	d3,kosm_last_mod_size				; Last module size
	move.w	d2,kosm_decomp_dest				; VRAM address
	move.l	a1,kosm_decomp_src				; Source address
	addq.w	#1,kosm_mods_left				; Store total number of modules
	rts

; ------------------------------------------------------------------------------
; Processes the first module on the queue
; ------------------------------------------------------------------------------

ProcessKosmQueue:
	tst.w	kosm_mods_left					; Are there any modules to load?
	bne.s	.ModulesLeft					; If so, branch

.Done:
	rts

.ModulesLeft:
	bmi.s	.Processing					; If the process has started already, branch
	
	cmpi.w	#(kos_queue_end-kos_queue)/8,kos_queue_count	; Is the Kosinski queue full?
	bcc.s	.Done						; If so, branch
	
	movea.l	kosm_queue,a1					; Add current module to decompression queue
	lea	kos_buffer,a2
	bsr.w	QueueKosData
	ori.w	#$8000,kosm_mods_left				; Set bit to signify decompression in progress
	rts

; ------------------------------------------------------------------------------

.Processing:
	tst.w	kos_queue_count					; Is a module currently being decompressed?
	bne.s	.Done						; If so, branch

	andi.w	#$7FFF,kosm_mods_left				; Decompression not in progress
	move.w	#$1000,d3					; Module size
	subq.w	#1,kosm_mods_left				; Decrement modules left
	bne.s	.Skip						; If this isn't the last, branch
	move.w	kosm_last_mod_size,d3				; Final module size

.Skip:
	move.w	kosm_decomp_dest,d2				; Advance VRAM address
	move.w	d2,d0
	add.w	d3,d0
	move.w	d0,kosm_decomp_dest

	move.l	kosm_queue,d0					; Round to the nearest 16 byte boundary
	move.l	kos_queue,d1
	sub.l	d1,d0
	andi.l	#$F,d0
	add.l	d0,d1
	move.l	d1,kosm_queue

	move.l	#kos_buffer,d1					; DMA decompressed module into VRAM
	bsr.w	QueueDma
	
	tst.w	kosm_mods_left					; Is this the last module?
	bne.w	.Exit						; If not, branch

	lea	kosm_queue,a0					; Shift Kosinski moduled queue
	lea	kosm_queue+6,a1
	rept	(kosm_queue_end-kosm_queue)/6-1
		move.l	(a1)+,(a0)+
		move.w	(a1)+,(a0)+
	endr
	moveq	#0,d0
	move.l	d0,(a0)+
	move.w	d0,(a0)+

	move.l	kosm_queue,d0					; Is the queue empty?
	beq.s	.Exit						; If so, branch
	
	movea.l	d0,a1						; Prepare next queue entry
	move.w	kosm_decomp_dest,d2
	bra.w	InitKosmProcess

.Exit:
	rts

; ------------------------------------------------------------------------------
; Adds Kosinski-compressed data to the decompression queue
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l - Compressed data address
;	a2.l - Decompression destination in RAM
; ------------------------------------------------------------------------------

QueueKosData:
	move.w	kos_queue_count,d0				; Get queue slot
	lsl.w	#3,d0
	lea	kos_queue,a3
	
	move.l	a1,(a3,d0.w)					; Store source
	move.l	a2,4(a3,d0.w)					; Store destination
	
	addq.w	#1,kos_queue_count				; Increment entry count
	rts

; ------------------------------------------------------------------------------
; Checks if V-BLANK occured in the middle of Kosinski queue processing
; and stores the location from which processing is to resume if it did
; ------------------------------------------------------------------------------

SetKosBookmark:
	tst.w	kos_queue_count					; Is decompression in progress?
	bpl.s	SetKosBookmarkDone				; If not, branch

	movea.l	vblank_return,a0				; Get V-BLANK return address
	move.l	2(a0),d0
	
	cmpi.l	#ProcessKosQueueMain,d0				; Were we processing the queue?
	bcs.s	SetKosBookmarkDone				; If not, branch
	cmpi.l	#ProcessKosQueueDone,d0
	bcc.s	SetKosBookmarkDone				; If not, branch
	
	move.l	d0,kos_bookmark					; Set bookmark
	move.l	#BackupKosRegs,2(a0)				; Set bookmark registers after end of interrupt

SetKosBookmarkDone:
	rts

; ------------------------------------------------------------------------------
; Processes the first entry in the Kosinski decompression queue
; ------------------------------------------------------------------------------

ProcessKosQueue:
	tst.w	kos_queue_count					; Is there any data to decompress?
	beq.s	SetKosBookmarkDone				; If not, branch
	bmi.w	RestoreKosBookmark				; If the decompression was interrupted and bookmarked, branch

ProcessKosQueueMain:
	ori.w	#$8000,kos_queue_count				; Set sign bit to signify decompression in progress
	
	movea.l	kos_decomp_src,a0				; Get source
	movea.l	kos_decomp_dest,a1				; Get destination

	include	"src/framework/md/kosinski_internal.inc"	; Decompress data
	
	move.l	a0,kos_decomp_src				; Next source
	move.l	a1,kos_decomp_dest				; Next destination

	andi.w	#$7FFF,kos_queue_count				; Clear decompression in progress bit
	subq.w	#1,kos_queue_count				; Decrement entry count
	beq.s	ProcessKosQueueDone				; If there are none left, branch

	lea	kos_queue,a0					; Shift queue
	lea	kos_queue+8,a1
	rept	(kos_queue_end-(kos_queue+8))/4
		move.l	(a1)+,(a0)+
	endr

ProcessKosQueueDone:
	rts

; ------------------------------------------------------------------------------

RestoreKosBookmark:
	movem.w	kos_decomp_regs,d0-d6				; Restore decompression registers
	movem.l	kos_decomp_regs+(7*2),a0-a1/a5

	move.l	kos_bookmark,-(sp)				; Go to bookmarked address
	move.w	kos_decomp_sr,-(sp)
	
	moveq	#8-1,d7						; Prepare for decompression
	lea	KosDec_ByteMap(pc),a4
	rte

; ------------------------------------------------------------------------------

BackupKosRegs:
	move	sr,kos_decomp_sr				; Save registers
	movem.w	d0-d6,kos_decomp_regs
	movem.l	a0-a1/a5,kos_decomp_regs+(7*2)
	rts

; ------------------------------------------------------------------------------