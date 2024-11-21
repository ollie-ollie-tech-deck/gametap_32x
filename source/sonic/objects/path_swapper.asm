; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Path swapper object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjPathSwapper:
	move.b	obj.subtype(a6),d0				; Get subtype
	btst	#2,d0						; Is this a vertical path swapper?
	beq.s	.CheckY						; If so, branch

	andi.w	#3,d0						; Get height
	add.w	d0,d0
	move.w	.Sizes(pc,d0.w),swapper.size(a6)

	move.w	obj.y(a6),d0					; Check which side the player is on
	movea.w	player_object,a1
	cmp.w	obj.y(a1),d0
	scs.b	swapper.side(a6)

	move.l	#UpdateStateX,obj.update(a6)			; Set state
	bra.w	UpdateStateX

; ------------------------------------------------------------------------------

.CheckY:
	andi.w	#3,d0						; Get width
	add.w	d0,d0
	move.w	.Sizes(pc,d0.w),swapper.size(a6)

	move.w	obj.x(a6),d0					; Check which side the player is on
	movea.w	player_object,a1
	cmp.w	obj.x(a1),d0
	scs.b	swapper.side(a6)

	move.l	#UpdateStateY,obj.update(a6)			; Set state
	bra.s	UpdateStateY
	
; ------------------------------------------------------------------------------

.Sizes:
	dc.w	32
	dc.w	64
	dc.w	128
	dc.w	256

; ------------------------------------------------------------------------------
; Vertical swapper update state
; ------------------------------------------------------------------------------

UpdateStateY:
	movea.w	player_object,a1				; Get player
	move.w	obj.x(a6),d1					; Get X position

	tst.b	swapper.side(a6)				; Is the player on the other size?
	bne.s	.CheckAlt					; If so, branch

	cmp.w	obj.x(a1),d1					; Has the player crossed over?
	bhi.w	.End						; If not, branch
	st	swapper.side(a6)				; Mark as crossed over

	move.w	obj.y(a6),d2					; Is the player touching us?
	move.w	d2,d3
	move.w	swapper.size(a6),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	obj.y(a1),d4
	cmp.w	d2,d4
	blt.s	.End						; If not, branch
	cmp.w	d3,d4
	bge.s	.End						; If not, branch

	move.b	obj.subtype(a6),d0				; Should we check if the player is in the air?
	bpl.s	.CheckLayer					; If not, branch
	btst	#SONIC_AIR,obj.flags(a1)			; Is the player in the air?
	bne.s	.End						; If so, branch

.CheckLayer:
	btst	#OBJ_FLIP_X,obj.flags(a6)			; Are we flipped?
	bne.s	.End						; If so, branch
	btst	#3,d0						; Set the player's collision layer
	sne.b	player.collision_layer(a1)
	
	bra.w	DespawnObject					; Handle despawn

.CheckAlt:
	cmp.w	obj.x(a1),d1					; Has the player crossed over?
	bls.s	.End						; If not, branch
	clr.b	swapper.side(a6)				; Mark as crossed over

	move.w	obj.y(a6),d2					; Is the player touching us?
	move.w	d2,d3
	move.w	swapper.size(a6),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	obj.y(a1),d4
	cmp.w	d2,d4
	blt.s	.End						; If not, branch
	cmp.w	d3,d4
	bge.s	.End						; If not, branch

	move.b	obj.subtype(a6),d0				; Should we check if the player is in the air?
	bpl.s	.CheckLayerAlt					; If not, branch
	btst	#SONIC_AIR,obj.flags(a1)			; Is the player in the air?
	bne.s	.End						; If so, branch

.CheckLayerAlt:
	btst	#OBJ_FLIP_X,obj.flags(a6)			; Are we flipped?
	bne.s	.End						; If so, branch
	btst	#4,d0						; Set the player's collision layer
	sne.b	player.collision_layer(a1)

.End:
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Horizontal swapper update state
; ------------------------------------------------------------------------------

UpdateStateX:
	movea.w	player_object,a1				; Get player
	move.w	obj.y(a6),d1					; Get Y position

	tst.b	swapper.side(a6)				; Is the player on the other size?
	bne.s	.CheckAlt					; If so, branch

	cmp.w	obj.y(a1),d1					; Has the player crossed over?
	bhi.w	.End						; If not, branch
	st	swapper.side(a6)				; Mark as crossed over

	move.w	obj.x(a6),d2					; Is the player touching us?
	move.w	d2,d3
	move.w	swapper.size(a6),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	obj.x(a1),d4
	cmp.w	d2,d4
	blt.s	.End						; If not, branch
	cmp.w	d3,d4
	bge.s	.End						; If not, branch

	move.b	obj.subtype(a6),d0				; Should we check if the player is in the air?
	bpl.s	.CheckLayer					; If not, branch
	btst	#SONIC_AIR,obj.flags(a1)			; Is the player in the air?
	bne.s	.End						; If so, branch

.CheckLayer:
	btst	#OBJ_FLIP_X,obj.flags(a6)			; Are we flipped?
	bne.s	.End						; If so, branch
	btst	#3,d0						; Set the player's collision layer
	sne.b	player.collision_layer(a1)
	
	bra.w	DespawnObject					; Handle despawn

.CheckAlt:
	cmp.w	obj.y(a1),d1					; Has the player crossed over?
	bls.s	.End						; If not, branch
	clr.b	swapper.side(a6)				; Mark as crossed over

	move.w	obj.x(a6),d2					; Is the player touching us?
	move.w	d2,d3
	move.w	swapper.size(a6),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	obj.x(a1),d4
	cmp.w	d2,d4
	blt.s	.End						; If not, branch
	cmp.w	d3,d4
	bge.s	.End						; If not, branch

	move.b	obj.subtype(a6),d0				; Should we check if the player is in the air?
	bpl.s	.CheckLayerAlt					; If not, branch
	btst	#SONIC_AIR,obj.flags(a1)			; Is the player in the air?
	bne.s	.End						; If so, branch

.CheckLayerAlt:
	btst	#OBJ_FLIP_X,obj.flags(a6)			; Are we flipped?
	bne.s	.End						; If so, branch
	btst	#4,d0						; Set the player's collision layer
	sne.b	player.collision_layer(a1)

.End:
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
