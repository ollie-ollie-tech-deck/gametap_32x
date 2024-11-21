; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sound functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/framework/md.inc"
	
; ------------------------------------------------------------------------------
; Pause sound
; ------------------------------------------------------------------------------

PauseSound:
	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr
	
	STOP_Z80						; Pause sound
	move.b	#1,Z80_RAM+z_sound_pause
	START_Z80

	move	(sp)+,sr					; Restore interrupt settings
	rts
	
; ------------------------------------------------------------------------------
; Pause sound
; ------------------------------------------------------------------------------

UnpauseSound:
	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr
	
	STOP_Z80						; Unpause sound
	move.b	#$80,Z80_RAM+z_sound_pause
	START_Z80
	
	move	(sp)+,sr					; Restore interrupt settings
	rts

; ------------------------------------------------------------------------------
; Stop sound
; ------------------------------------------------------------------------------

StopSound:
	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr
	
	STOP_Z80						; Stop sound
	move.b	#2,Z80_RAM+z_command_queue
	START_Z80
	
	move	(sp)+,sr					; Restore interrupt settings
	rts

; ------------------------------------------------------------------------------
; Fade sound out
; ------------------------------------------------------------------------------

FadeSound:
	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr
	
	STOP_Z80						; Fade sound
	move.b	#4,Z80_RAM+z_command_queue
	START_Z80
	
	move	(sp)+,sr					; Restore interrupt settings
	rts

; ------------------------------------------------------------------------------
; Halt sound
; ------------------------------------------------------------------------------

HaltSound:
	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr
	
	STOP_Z80						; Halt sound
	move.b	#6,Z80_RAM+z_command_queue
	START_Z80
	
	move	(sp)+,sr					; Restore interrupt settings
	rts

; ------------------------------------------------------------------------------
; Enable AtGames sound mode
; ------------------------------------------------------------------------------

EnableAtGamesSound:
	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr

	STOP_Z80						; Enable AtGames sound mode
	move.b	#8,Z80_RAM+z_command_queue
	START_Z80

	move	(sp)+,sr					; Restore interrupt settings
	rts

; ------------------------------------------------------------------------------
; Disable AtGames sound mode
; ------------------------------------------------------------------------------

DisableAtGamesSound:
	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr

	STOP_Z80						; Disable AtGames sound mode
	move.b	#$A,Z80_RAM+z_command_queue
	START_Z80

	move	(sp)+,sr					; Restore interrupt settings
	rts

; ------------------------------------------------------------------------------
; Wait for the queued sound command to be processed
; ------------------------------------------------------------------------------

WaitSoundCommand:
	move.l	d0,-(sp)					; Save registers

	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr

.Wait:
	STOP_Z80						; Get command queue
	move.b	Z80_RAM+z_command_queue,d0
	START_Z80
	tst.b	d0						; Has it been processed?
	bne.s	.Wait						; If not, wait

	move	(sp)+,sr					; Restore interrupt settings

	move.l	(sp)+,d0					; Restore registers
	rts

; ------------------------------------------------------------------------------
; Play music
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Music data address
; ------------------------------------------------------------------------------

PlayMusic:
	movem.l	d0/a1,-(sp)					; Save registers

	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr
	STOP_Z80						; Stop the Z80

	lea	Z80_RAM+z_music_queue,a1			; Queue music
	move.b	#1,(a1)+
	
	move.l	a0,d0						; Queue sound data address
	move.w	d0,-(sp)
	move.b	d0,(a1)+
	move.b	(sp)+,d0
	tas.b	d0
	move.b	d0,(a1)+

	add.l	d0,d0						; Queue sound data bank
	swap	d0
	move.b	d0,(a1)+

	START_Z80						; Start the Z80
	move	(sp)+,sr					; Restore interrupt settings
	
	movem.l	(sp)+,d0/a1					; Restore registers
	rts

; ------------------------------------------------------------------------------
; Play background SFX
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Background SFX data address
; ------------------------------------------------------------------------------

PlayBackgroundSfx:
	moveq	#4,d0						; Queue background SFX
	bra.s	AddToSfxQueue

; ------------------------------------------------------------------------------
; Play SFX
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - SFX data address
; ------------------------------------------------------------------------------

PlaySfx:
	moveq	#2,d0						; Queue SFX

; ------------------------------------------------------------------------------
; Add to SFX queue
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Sound data address
;	d0.b - Sound type
; ------------------------------------------------------------------------------

AddToSfxQueue:
	movem.l	d0-d1/a1,-(sp)					; Save registers

	move	sr,-(sp)					; Disable interrupts
	move	#$2700,sr
	STOP_Z80						; Stop the Z80

	lea	Z80_RAM+z_sfx_queue,a1				; SFX queue
	moveq	#SFX_QUEUE_COUNT-1,d1
	
.CheckSlot:
	tst.b	(a1)						; Is this slot free?
	bne.s	.NextSlot					; If not, branch
	
	move.b	d0,(a1)+					; Queue SFX
	
	move.l	a0,d0						; Queue sound data address
	move.w	d0,-(sp)
	move.b	d0,(a1)+
	move.b	(sp)+,d0
	tas.b	d0
	move.b	d0,(a1)+

	add.l	d0,d0						; Queue sound data bank
	swap	d0
	move.b	d0,(a1)+
	
	START_Z80						; Start the Z80
	move	(sp)+,sr					; Restore interrupt settings
	
	movem.l	(sp)+,d0-d1/a1					; Restore registers
	rts
	
.NextSlot:
	addq.w	#4,a1						; Next slot
	dbf	d1,.CheckSlot					; Loop until finished

	START_Z80						; Start the Z80
	move	(sp)+,sr					; Restore interrupt settings
	
	movem.l	(sp)+,d0-d1/a1					; Restore registers
	rts

; ------------------------------------------------------------------------------
