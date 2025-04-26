; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Particle functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialize particles
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Particle pool address
;	d1.w - Number of particles
; ------------------------------------------------------------------------------

InitParticles:
	moveq	#particle.struct_len,d0				; Initialize particle pool
	bra.w	InitList
	
; ------------------------------------------------------------------------------
; Update particles
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l - Particle pool address
; ------------------------------------------------------------------------------

UpdateParticles:
	move.w	list.head(a1),d0				; Get first particle
	beq.s	.End						; If there are no particles, branch

.UpdateLoop:
	movea.w	d0,a1						; Set particle
	move.w	item.next(a1),-(sp)				; Get next particle

	movem.w	particle.x_speed(a1),d0-d1			; Move particle
	asl.l	#8,d0
	asl.l	#8,d1
	add.l	d0,particle.x(a1)
	add.l	d1,particle.y(a1)

	movem.w	particle.x_accel(a1),d0-d1			; Apply acceleration
	add.w	d0,particle.x_speed(a1)
	add.w	d1,particle.y_speed(a1)

	move.w	camera_fg_x,d0					; Are we offscreen horizontally?
	addi.w	#320+16,d0
	cmp.w	particle.x(a1),d0
	blt.s	.Delete						; If so, branch
	subi.w	#320+16+16,d0
	cmp.w	particle.x(a1),d0
	bgt.s	.Delete						; If so, branch

	move.w	camera_fg_y,d0					; Are we offscreen vertically?
	addi.w	#224+16,d0
	cmp.w	particle.y(a1),d0
	blt.s	.Delete						; If so, branch
	subi.w	#224+16+16,d0
	cmp.w	particle.y(a1),d0
	ble.s	.NextParticle					; If not, branch

.Delete:
	bsr.w	RemoveListItem					; Delete piece

.NextParticle:
	move.w	(sp)+,d0					; Get next particle
	bne.s	.UpdateLoop					; Loop until finished

.End:
	rts

; ------------------------------------------------------------------------------
