; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG object functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/rpg/shared.inc"

; ------------------------------------------------------------------------------
; Check if an object can be interacted with
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.b  - Allowed interaction angles
;	        Bit 0 = Bottom right
;	        Bit 1 = Bottom
;	        Bit 2 = Bottom left
;	        Bit 3 = Left
;	        Bit 4 = Top left
;	        Bit 5 = Top
;	        Bit 6 = Top right
;	        Bit 7 = Right
;	a6.l  - Object slot
; RETURNS:
;	eq/ne - Can interact/Can't interact
; ------------------------------------------------------------------------------

InteractRpgObject:
	movea.w	player_object,a1				; Player object

	move.w	obj.collide_width(a1),d3			; Get maximum horizontal distance needed for collision
	add.w	obj.collide_width(a6),d3
	addq.w	#2,d3

	move.w	obj.collide_height(a1),d4			; Get maximum vertical distance needed for collision
	add.w	obj.collide_height(a6),d4
	addq.w	#2,d4

	move.w	obj.x(a1),d1					; Get horizontal distance from player
	sub.w	obj.x(a6),d1
	move.w	obj.y(a1),d2					; Get vertical distance from player
	sub.w	obj.y(a6),d2

	cmp.w	d3,d1						; Is the player too far away?
	bgt.s	.NoInteract					; If so, branch
	cmp.w	d4,d2
	bgt.s	.NoInteract					; If so, branch
	neg.w	d3
	neg.w	d4
	cmp.w	d3,d1
	blt.s	.NoInteract					; If so, branch
	cmp.w	d4,d2
	blt.s	.NoInteract					; If so, branch

	move.w	d0,d4						; Get angle the player is in from us
	jsr	CalcAngle8
	subi.b	#$10,d0
	rol.b	#3,d0
	andi.w	#%00000111,d0
	btst	d0,d4						; Is this angle allowed?
	beq.s	.NoInteract					; If not, branch
	
	move.w	d0,d1						; Get angles to check
	add.w	d1,d1
	add.w	d1,d0
	lea	.PlayerAngles(pc,d0.w),a0
	moveq	#3-1,d0

.CheckAngles:
	move.b	(a0)+,d1					; Is the player at this angle?
	cmp.b	rpg_obj.angle(a1),d1
	beq.s	.CheckInteract					; If so, branch
	dbf	d0,.CheckAngles					; Loop until angles are checked

.NoInteract:
	andi	#~4,sr						; No interaction
	rts

.CheckInteract:
	tst.l	script_address					; Is there a script running?
	bne.s	.NoInteract					; If so, branch
	btst	#BUTTON_A_BIT,p1_ctrl_tap			; Has the A button been pressed?
	beq.s	.NoInteract					; If not, branch

	ori	#4,sr						; Interaction
	rts
	
; ------------------------------------------------------------------------------

.PlayerAngles:
	dc.b	6, 5, 4						; Bottom right
	dc.b	7, 6, 5						; Bottom
	dc.b	0, 7, 6						; Bottom left
	dc.b	1, 0, 7						; Left
	dc.b	2, 1, 0						; Top left
	dc.b	3, 2, 1						; Top
	dc.b	4, 3, 2						; Top right
	dc.b	5, 4, 3						; Right

; ------------------------------------------------------------------------------
; Make object a trigger
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l  - Object slot
; RETURNS:
;	eq/ne - Collision/No collision
; ------------------------------------------------------------------------------

TriggerRpgObject:
	movea.w	player_object,a1				; Check for collision with player
	jmp	CheckObjectCollide

; ------------------------------------------------------------------------------
; Layer object
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; ------------------------------------------------------------------------------

LayerRpgObject:
	movea.w	player_object,a1				; Player object

	move.w	obj.y(a1),d0					; Get bottom of player
	add.w	obj.collide_height(a1),d0

	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set to lower layer
	
	cmp.w	obj.y(a6),d0					; Is the player behind us?
	bgt.s	.End						; If not, branch
	
	SET_OBJECT_LAYER move.w,2,obj.layer(a6)			; Set to upper layer

.End:
	rts

; ------------------------------------------------------------------------------
; Animate object
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Base animation ID
;	a1.l - Animation data address
;	a6.l - Object slot
; ------------------------------------------------------------------------------

AnimateRpgObject:
	lea	.Animations(pc),a0				; Get animation table offset
	moveq	#0,d1
	move.b	rpg_obj.angle(a6),d1
	add.w	d1,d1

	move.b	1(a0,d1.w),d2					; Set X flip flag
	andi.b	#~(1<<OBJ_FLIP_X),obj.flags(a6)
	or.b	d2,obj.flags(a6)

	move.b	(a0,d1.w),d1					; Get animation ID
	ext.w	d1
	add.w	d1,d0
	
	move.w	obj.x_speed(a6),d1				; Are we moving?
	or.w	obj.y_speed(a6),d1
	beq.s	.SetAnimation					; If not, branch

	addq.w	#1,d0						; Use movement animation

.SetAnimation:
	lea	obj.anim(a6),a0					; Set animation
	jsr	SetAnimation

	lea	obj.anim(a6),a0					; Animate sprite
	jmp	UpdateAnimation

; ------------------------------------------------------------------------------

.Animations:
	dc.b	2, 0						; Right
	dc.b	0, 0						; Down right
	dc.b	0, 0						; Down
	dc.b	0, 0						; Down left
	dc.b	2, 1<<OBJ_FLIP_X				; Left
	dc.b	4, 0						; Up left
	dc.b	4, 0						; Up
	dc.b	4, 0						; Up right

; ------------------------------------------------------------------------------
; Update object
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; ------------------------------------------------------------------------------

UpdateRpgObject:
	jsr	MoveObject					; Apply speed

	moveq	#0,d0						; Reset angle index
	tst.w	obj.x_speed(a6)					; Are we moving horizontally?
	beq.s	.CheckY						; If not, branch
	bmi.s	.Left						; If we are moving left, branch
	bset	#3,d0						; Set right bit
	bra.s	.CheckY

.Left:
	bset	#2,d0						; Set left bit

.CheckY:
	tst.w	obj.y_speed(a6)					; Are we moving vertically?
	beq.s	.GetAngle					; If not, branch
	bmi.s	.Up						; If we are moving up, branch
	bset	#1,d0						; Set down bit
	bra.s	.GetAngle

.Up:
	bset	#0,d0						; Set up bit

.GetAngle:
	tst.b	d0						; Are we moving?
	beq.s	.End						; If not, branch
	
	move.b	.Angles(pc,d0.w),d0				; Set angle
	move.b	d0,rpg_obj.angle(a6)

.End:
	rts

; ------------------------------------------------------------------------------

.Angles:
	dc.b	0, 6, 2, 0					; 0,   U,     D,     U+D
	dc.b	4, 5, 3, 4					; L,   L+U,   L+D,   L+U+D
	dc.b	0, 7, 1, 0					; R,   R+U,   R+D,   R+U+D
	dc.b	0, 6, 2, 0					; L+R, L+R+U, L+R+D, L+R+U+D

; ------------------------------------------------------------------------------
; Check map collision
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l  - Object slot
; RETURNS:
;	eq/ne - Collision/No collision
; ------------------------------------------------------------------------------

RpgObjectMapCollide:
	andi.w	#~4,sr						; Save status register
	move	sr,-(sp)

	moveq	#0,d0						; Handle collision per angle
	move.b	rpg_obj.angle(a6),d0
	add.w	d0,d0
	add.w	d0,d0
	jsr	.MapCollideIndex(pc,d0.w)

	move	(sp)+,sr					; Set modified status register
	rts

; ------------------------------------------------------------------------------

.MapCollideIndex:
	bra.w	.MapCollideRight				; Right
	bra.w	.MapCollideDown					; Down right
	bra.w	.MapCollideDown					; Down
	bra.w	.MapCollideDown					; Down left
	bra.w	.MapCollideLeft					; Left
	bra.w	.MapCollideUp					; Up left
	bra.w	.MapCollideUp					; Up
	bra.w	.MapCollideUp					; Up right

; ------------------------------------------------------------------------------

.MapCollideRight:
	jsr	ObjMapCollideRight				; Check collision right
	tst.w	d1
	bpl.s	.MapRightCheckUp				; If there was no collision, branch
	
	add.w	d1,obj.x(a6)					; Align self
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided

.MapRightCheckUp:
	jsr	ObjMapCollideUp					; Check collision up
	tst.w	d1
	bpl.s	.MapRightCheckDown				; If there was no collision, branch
	
	sub.w	d1,obj.y(a6)					; Align self
	clr.w	obj.y+2(a6)
	clr.w	obj.y_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided
	
.MapRightCheckDown:
	jsr	ObjMapCollideDown				; Check collision down
	tst.w	d1
	bpl.s	.MapRightEnd					; If there was no collision, branch
	
	add.w	d1,obj.y(a6)					; Align self
	clr.w	obj.y+2(a6)
	clr.w	obj.y_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided
	
.MapRightEnd:
	rts

; ------------------------------------------------------------------------------

.MapCollideDown:
	jsr	ObjMapCollideDown				; Check collision down
	tst.w	d1
	bpl.s	.MapDownCheckLeft				; If there was no collision, branch
	
	add.w	d1,obj.y(a6)					; Align self
	clr.w	obj.y+2(a6)
	clr.w	obj.y_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided
	
.MapDownCheckLeft:
	jsr	ObjMapCollideLeft				; Check collision left
	tst.w	d1
	bpl.s	.MapDownCheckRight				; If there was no collision, branch
	
	sub.w	d1,obj.x(a6)					; Align self
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided

.MapDownCheckRight:
	jsr	ObjMapCollideRight				; Check collision right
	tst.w	d1
	bpl.s	.MapDownEnd					; If there was no collision, branch

	add.w	d1,obj.x(a6)					; Align self
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided
	
.MapDownEnd:
	rts

; ------------------------------------------------------------------------------

.MapCollideLeft:
	jsr	ObjMapCollideLeft				; Check collision left
	tst.w	d1
	bpl.s	.MapLeftCheckUp					; If there was no collision, branch
	
	sub.w	d1,obj.x(a6)					; Align self
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided

.MapLeftCheckUp:
	jsr	ObjMapCollideUp					; Check collision up
	tst.w	d1
	bpl.s	.MapLeftCheckDown				; If there was no collision, branch
	
	sub.w	d1,obj.y(a6)					; Align self
	clr.w	obj.y+2(a6)
	clr.w	obj.y_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided
	
.MapLeftCheckDown:
	jsr	ObjMapCollideDown				; Check collision down
	tst.w	d1
	bpl.s	.MapLeftEnd					; If there was no collision, branch
	
	add.w	d1,obj.y(a6)					; Align self
	clr.w	obj.y+2(a6)
	clr.w	obj.y_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided
	
.MapLeftEnd:
	rts

; ------------------------------------------------------------------------------

.MapCollideUp:
	jsr	ObjMapCollideUp					; Check collision up
	tst.w	d1
	bpl.s	.MapUpCheckLeft					; If there was no collision, branch
	
	sub.w	d1,obj.y(a6)					; Align self
	clr.w	obj.y+2(a6)
	clr.w	obj.y_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided
	
.MapUpCheckLeft:
	jsr	ObjMapCollideLeft				; Check collision left
	tst.w	d1
	bpl.s	.MapUpCheckRight				; If there was no collision, branch
	
	sub.w	d1,obj.x(a6)					; Align self
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided

.MapUpCheckRight:
	jsr	ObjMapCollideRight				; Check collision right
	tst.w	d1
	bpl.s	.MapUpEnd					; If there was no collision, branch
	
	add.w	d1,obj.x(a6)					; Align self
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving

	ori	#4,4(sp)					; Collided
	
.MapUpEnd:
	rts

; ------------------------------------------------------------------------------
