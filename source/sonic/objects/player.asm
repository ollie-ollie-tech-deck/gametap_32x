; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Sonic player object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Physics table
; ------------------------------------------------------------------------------

	rsreset
physics.max_speed	rs.w 1					; Max speed
physics.acceleration	rs.w 1					; Acceleration
physics.deceleration	rs.w 1					; Deceleration
physics.skid		rs.w 1					; Skid speed
physics.gravity		rs.w 1					; Gravity
physics.jump_speed	rs.w 1					; Jump speed

; ------------------------------------------------------------------------------

Physics:
	dc.w	$600, $C, $C, $80, $38, $680

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjSonicPlayer:
	SET_OBJECT_LAYER move.w,2,obj.layer(a6)			; Set layer
	
	move.w	#10,player.width(a6)				; Set hitbox size
	move.w	#14,player.height(a6)
	
	move.w	#24,obj.draw_width(a6)				; Set draw size
	move.w	#24,obj.draw_height(a6)
	
	move.l	#GroundState,obj.update(a6)			; Set ground state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Ground state
; ------------------------------------------------------------------------------

GroundState:
	bsr.w	GetControllerData				; Get controller data
	bsr.w	SetCollisionLayer				; Set collision layer
	lea	Physics(pc),a5					; Get physics table
	
	bsr.w	CheckJump					; Check for jumping
	bsr.w	SlopePhysics					; Slope physics
	bsr.w	MoveGround					; Handle movement
	bsr.w	CheckRoll					; Check for rolling

GroundState2:
	bsr.w	SetGroundSpeed					; Set ground speed
	jsr	MoveObject					; Apply speed
	bsr.w	CheckMapBoundaries				; Check map boundaries

	bsr.w	SetCollisionLayer				; Set collision layer
	bsr.w	WallCollision					; Wall collision
	bsr.w	FloorCollision					; Floor collision
	bsr.w	ResetCollisionLayer				; Reset collision layer

	bsr.w	CheckFall					; Check if we should fall
	
	bsr.w	GroundAnimation					; Handle animation

; ------------------------------------------------------------------------------
; Flash and check for drawing
; ------------------------------------------------------------------------------

CheckFlashDraw:
	move.b	player.recover_timer(a6),d0			; Get recovery timer
	beq.s	.Draw						; If it's not set, branch

	subq.b	#1,player.recover_timer(a6)			; Decrement recovery timer
	lsr.b	#3,d0						; Should we draw the sprite?
	bcs.s	.Draw						; If so, branch
	rts

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Get controller data
; ------------------------------------------------------------------------------

GetControllerData:
	btst	#SONIC_LOCK,obj.flags(a6)			; Are our controls locked?
	bne.s	.End						; If so, branch
	move.w	p1_ctrl_data,player.ctrl_hold(a6)		; Set controller data
	
.End:
	rts

; ------------------------------------------------------------------------------
; Set collision layer
; ------------------------------------------------------------------------------

SetCollisionLayer:
	move.l	map_collision_1,map_collision_layer		; Collision layer 1
	clr.b	map_collision_bit
	
	tst.b	player.collision_layer(a6)			; Are we on layer 2?
	beq.s	.End						; If not, branch
	
	move.l	map_collision_2,map_collision_layer		; Collision layer 2
	move.b	#2,map_collision_bit
	
.End:
	rts
	
; ------------------------------------------------------------------------------
; Reset collision layer
; ------------------------------------------------------------------------------

ResetCollisionLayer:
	move.l	map_collision_1,map_collision_layer		; Reset to collision layer 1
	clr.b	map_collision_bit
	rts

; ------------------------------------------------------------------------------
; Ground movement
; ------------------------------------------------------------------------------

MoveGround:
	move.w	physics.max_speed(a5),d6			; Get max speed
	move.w	physics.acceleration(a5),d5			; Get acceleration speed
	move.w	physics.skid(a5),d4				; Get skid speed
	move.w	physics.deceleration(a5),d3			; Get deceleration speed
	
	tst.b	player.lock(a6)					; Is our movement locked?
	bne.w	.Settle						; If so, branch

	btst	#BUTTON_LEFT_BIT,player.ctrl_hold(a6)		; Is left being held?
	beq.s	.CheckRight					; If not, branch

	move.w	player.ground_speed(a6),d0			; Get ground speed
	beq.s	.AccelLeft					; If we are not moving, branch
	bpl.s	.SkidLeft					; If we are skidding, branch

.AccelLeft:
	bset	#SONIC_X_FLIP,obj.flags(a6)			; Face in the right direction
	bne.s	.AccelLeft2					; If we are already facing in the right direction, branch
	bclr	#SONIC_PUSH,obj.flags(a6)			; Stop pushing

.AccelLeft2:
	sub.w	d5,d0						; Accelerate
	move.w	d6,d1						; Get max speed
	neg.w	d1
	cmp.w	d1,d0						; Are we already at max speed?
	bgt.s	.SetLeftSpeed					; If not, branch
	add.w	d5,d0						; Undo acceleration
	cmp.w	d1,d0						; Are we past the max speed?
	ble.s	.SetLeftSpeed					; If so, branch
	move.w	d1,d0						; Cap the speed

.SetLeftSpeed:
	move.w	d0,player.ground_speed(a6)			; Set ground speed
	rts

.SkidLeft:
	sub.w	d4,d0						; Skid
	bcc.s	.CheckLeftSkidSfx				; If the speed hasn't underflown, branch
	move.w	d4,d0						; Cap speed
	neg.w	d0
	clr.w	player.gametap(a6)				; Reset GameTap counter

.CheckLeftSkidSfx:
	cmpi.w	#$400,d0					; Are we going too fast?
	blt.s	.SetLeftSkidSpeed				; If not, branch
	
	move.w	d0,-(sp)					; Play skid sound
	lea	Sfx_Skid,a0
	jsr	PlaySfx
	move.w	(sp)+,d0

.SetLeftSkidSpeed:
	move.w	d0,player.ground_speed(a6)			; Set ground speed
	rts

; ------------------------------------------------------------------------------

.CheckRight:
	btst	#BUTTON_RIGHT_BIT,player.ctrl_hold(a6)		; Is right being held?
	beq.s	.Settle						; If not, branch

	move.w	player.ground_speed(a6),d0			; Get ground speed
	bmi.s	.SkidRight					; If we are skidding, branch

	bclr	#SONIC_X_FLIP,obj.flags(a6)			; Face in the right direction
	beq.s	.AccelRight					; If we are already facing in the right direction, branch
	bclr	#SONIC_PUSH,obj.flags(a6)			; Stop pushing

.AccelRight:
	add.w	d5,d0						; Accelerate
	cmp.w	d6,d0						; Are we already at max speed?
	blt.s	.SetRightSpeed					; If not, branch
	sub.w	d5,d0						; Undo acceleration
	cmp.w	d6,d0						; Are we past the max speed?
	bge.s	.SetRightSpeed					; If so, branch
	move.w	d6,d0						; Cap the speed

.SetRightSpeed:
	move.w	d0,player.ground_speed(a6)			; Set ground speed
	rts

.SkidRight:
	add.w	d4,d0						; Skid
	bcc.s	.CheckRightSkidSfx				; If the speed hasn't overflown, branch
	move.w	d4,d0						; Cap speed
	clr.w	player.gametap(a6)				; Reset GameTap counter

.CheckRightSkidSfx:
	cmpi.w	#-$400,d0					; Are we going too fast?
	bgt.s	.SetRightSkidSpeed				; If not, branch
	
	move.w	d0,-(sp)					; Play skid sound
	lea	Sfx_Skid,a0
	jsr	PlaySfx
	move.w	(sp)+,d0

.SetRightSkidSpeed:
	move.w	d0,player.ground_speed(a6)			; Set ground speed
	rts

; ------------------------------------------------------------------------------

.Settle:
	move.w	player.ground_speed(a6),d0			; Get ground speed
	beq.s	.End						; If we are not moving, branch
	bmi.s	.SettleLeft					; If we are moving left, branch

.SettleRight:
	sub.w	d3,d0						; Decelerate
	bcc.s	.SetSettleSpeed					; If we are still moving, branch
	moveq	#0,d0						; Stop moving
	bra.s	.SetSettleSpeed

.SettleLeft:
	add.w	d3,d0						; Decelerate
	bcc.s	.SetSettleSpeed					; If we are still moving, branch
	moveq	#0,d0						; Stop moving

.SetSettleSpeed:
	move.w	d0,player.ground_speed(a6)			; Set ground speed
	
.End:
	rts

; ------------------------------------------------------------------------------
; Slope physics
; ------------------------------------------------------------------------------

SlopePhysics:
	move.b	player.angle(a6),d0				; Are we on a steep enough slope?
	addi.b	#$60,d0
	cmpi.b	#$C0,d0
	bcc.s	.End						; If not, branch
	
	move.b	player.angle(a6),d0				; Get resistance
	bsr.w	CalcSine
	muls.w	#$20,d0
	asr.l	#8,d0
	
	tst.w	player.ground_speed(a6)				; Check movement direction
	beq.s	.End						; If we are not moving, branch
	add.w	d0,player.ground_speed(a6)			; Apply resistance

.End:
	rts
	
; ------------------------------------------------------------------------------
; Check if we should fall
; ------------------------------------------------------------------------------

CheckFall:
	tst.b	player.lock(a6)					; Is our movement locked?
	bne.s	.Locked						; If so, branch
	
	move.b	player.angle(a6),d0				; Are we on a steep enough slope?
	addi.b	#$20,d0
	andi.b	#$C0,d0
	beq.s	.End						; If not, branch
	
	move.w	player.ground_speed(a6),d0			; Get the absolute value of our ground speed
	bpl.s	.CheckSpeed
	neg.w	d0

.CheckSpeed:
	cmpi.w	#$280,d0					; Are we moving too slowly?
	bcc.s	.End						; If not, branch
	clr.w	player.ground_speed(a6)				; Clear ground speed
	
	move.b	#30,player.lock(a6)				; Set movement lock timer
	bra.w	SetAirborneState				; Fall off floor

.Locked:
	subq.b	#1,player.lock(a6)
	
.End:
	rts
	
; ------------------------------------------------------------------------------
; Check if the player should roll
; ------------------------------------------------------------------------------

CheckRoll:
	move.w	player.ground_speed(a6),d0			; Get ground speed
	bpl.s	.CheckGroundSpeed
	neg.w	d0
	
.CheckGroundSpeed:
	cmpi.w	#$100,d0					; Are we moving fast enough?
	bcs.s	.End						; If not, branch
	
	move.b	player.ctrl_hold(a6),d0				; Is left or right being held?
	andi.b	#BUTTON_LEFT|BUTTON_RIGHT,d0
	bne.s	.End						; If not, branch
	
	btst	#BUTTON_DOWN_BIT,player.ctrl_hold(a6)		; Is down being held?
	beq.s	.End						; If not, branch

	bsr.w	SetRollState					; Set roll state
	move.l	#RollState2,(sp)

.End:
	rts

; ------------------------------------------------------------------------------
; Roll state
; ------------------------------------------------------------------------------

RollState:
	bsr.w	GetControllerData				; Get controller data
	bsr.w	SetCollisionLayer				; Set collision layer
	lea	Physics(pc),a5					; Get physics table
	
	bsr.w	CheckJump					; Check for jumping
	bsr.w	RollSlopePhysics				; Slope physics
	bsr.w	MoveRoll					; Handle movement
	
	tst.w	player.ground_speed(a6)				; Are we not moving anymore?
	bne.s	RollState2					; If not, branch

	move.l	#GroundState,obj.update(a6)			; Set ground state
	bclr	#SONIC_ROLL,obj.flags(a6)
	bra.w	GroundState2
	
RollState2:
	bsr.w	SetGroundSpeed					; Set ground speed
	jsr	MoveObject					; Apply speed
	bsr.w	CheckMapBoundaries				; Check map boundaries
	
	bsr.w	WallCollision					; Wall collision
	bsr.w	FloorCollision					; Floor collision
	bsr.w	ResetCollisionLayer				; Reset collision layer
	
	bsr.w	CheckFall					; Check if we should fall
	
	bsr.w	GroundAnimation					; Handle animation
	bra.w	CheckFlashDraw					; Draw sprite

; ------------------------------------------------------------------------------
; Roll movement
; ------------------------------------------------------------------------------

MoveRoll:
	move.w	physics.skid(a5),d4				; Get skid speed
	asr.w	#2,d4
	move.w	physics.deceleration(a5),d3			; Get deceleration speed
	asr.w	#1,d3
	
	btst	#BUTTON_LEFT_BIT,player.ctrl_hold(a6)		; Is left being held?
	beq.s	.CheckRight					; If not, branch

	move.w	player.ground_speed(a6),d0			; Get ground speed
	beq.s	.FaceLeft					; If we are not moving, branch
	bpl.s	.DecelLeft					; If we are decelerating, branch

.FaceLeft:
	bset	#SONIC_X_FLIP,obj.flags(a6)			; Face in the right direction
	bra.s	.Settle

.DecelLeft:
	sub.w	d4,d0						; Decelerate
	bcc.s	.SetLeftSpeed					; If the speed hasn't underflown, branch
	move.w	d4,d0						; Cap speed
	neg.w	d0

.SetLeftSpeed:
	move.w	d0,player.ground_speed(a6)			; Set ground speed
	bra.s	.Settle

; ------------------------------------------------------------------------------

.CheckRight:
	btst	#BUTTON_RIGHT_BIT,player.ctrl_hold(a6)		; Is right being held?
	beq.s	.Settle						; If not, branch

	move.w	player.ground_speed(a6),d0			; Get ground speed
	bmi.s	.DecelRight					; If we are decelerating, branch

	bclr	#SONIC_X_FLIP,obj.flags(a6)			; Face in the right direction
	bra.s	.Settle

.DecelRight:
	add.w	d4,d0						; Decelerate
	bcc.s	.SetRightSpeed					; If the speed hasn't underflown, branch
	move.w	physics.skid(a5),d0				; Cap speed

.SetRightSpeed:
	move.w	d0,player.ground_speed(a6)			; Set ground speed

; ------------------------------------------------------------------------------

.Settle:
	move.w	player.ground_speed(a6),d0			; Get ground speed
	beq.s	.End						; If we are not moving, branch
	bmi.s	.SettleLeft					; If we are moving left, branch

.SettleRight:
	sub.w	d3,d0						; Decelerate
	bcc.s	.SetSettleSpeed					; If we are still moving, branch
	moveq	#0,d0						; Stop moving
	bra.s	.SetSettleSpeed

.SettleLeft:
	add.w	d3,d0						; Decelerate
	bcc.s	.SetSettleSpeed					; If we are still moving, branch
	moveq	#0,d0						; Stop moving

.SetSettleSpeed:
	move.w	d0,player.ground_speed(a6)			; Set ground speed

.End:
	rts

; ------------------------------------------------------------------------------
; Rolling slope physics
; ------------------------------------------------------------------------------

RollSlopePhysics:
	move.b	player.angle(a6),d0				; Are we on a steep enough slope?
	addi.b	#$60,d0
	cmpi.b	#$C0,d0
	bcc.s	.End						; If not, branch
	
	move.b	player.angle(a6),d0				; Get resistance
	bsr.w	CalcSine
	muls.w	#$50,d0
	asr.l	#8,d0
	
	tst.w	player.ground_speed(a6)				; Are we moving left?
	bmi.s	.PushLeft					; If so, branch
	
	tst.w	d0						; Are we being pushed right?
	bpl.s	.AddSpeed					; If so, branch
	asr.w	#2,d0						; Make resistance less intense
	bra.s	.AddSpeed
	
.PushLeft:
	tst.w	d0						; Are we being pushed left?
	bmi.s	.AddSpeed					; If so, branch
	asr.w	#2,d0						; Make resistance less intense

.AddSpeed:
	add.w	d0,player.ground_speed(a6)			; Apply resistance

.End:
	rts

; ------------------------------------------------------------------------------
; Check for jumping
; ------------------------------------------------------------------------------

CheckJump:
	move.b	player.ctrl_tap(a6),d0				; Has A, B, or C been pressed?
	andi.b	#BUTTON_A|BUTTON_B|BUTTON_C,d0
	beq.s	NoJump						; If not, branch

	move.b	player.angle(a6),d0				; Is there enough space to jump?
	addi.b	#$80,d0
	jsr	ObjMapCollideAbove
	cmpi.w	#8,d1
	blt.s	NoJump						; If not, branch

	move.l	#JumpState2,(sp)				; Go to jump state handler on return

StartJump:
	bsr.w	SetAirborneState				; Set jump state
	move.l	#JumpState,obj.update(a6)

	move.w	physics.jump_speed(a5),d2			; Get jump speed
	moveq	#0,d0						; Get our angle on the ground
	move.b	player.angle(a6),d0
	subi.b	#$40,d0
	bsr.w	CalcSine					; Get the sine and cosine of our angle
	muls.w	d2,d1						; Get X speed to jump at (jump speed * cos(angle))
	asr.l	#8,d1
	add.w	d1,obj.x_speed(a6)
	muls.w	d2,d0						; Get Y speed to jump at (jump speed * sin(angle))
	asr.l	#8,d0
	add.w	d0,obj.y_speed(a6)

	bset	#SONIC_ROLL,obj.flags(a6)			; Set roll flag
	bset	#SONIC_JUMP,obj.flags(a6)			; Set jump flag
	
	lea	Sfx_Jump,a0					; Play jump sound
	jmp	PlaySfx
	
NoJump:
	rts
	
; ------------------------------------------------------------------------------
; Set ground speed
; ------------------------------------------------------------------------------

SetGroundSpeed:
	move.w	player.ground_speed(a6),d2			; Get ground speed
	
	move.b	player.angle(a6),d0				; Get sine and cosine of angle
	bsr.w	CalcSine

	muls.w	d2,d1						; Get X speed
	asr.l	#8,d1

	cmpi.w	#$FC0,d1					; Are we moving too fast horizontally?
	blt.s	.CheckNegSpeedX					; If not, branch
	move.w	#$FC0,d1					; If so, cap it
	
.CheckNegSpeedX:
	cmpi.w	#-$FC0,d1					; Are we moving too fast horizontally?
	bgt.s	.SetSpeedX					; If not, branch
	move.w	#-$FC0,d1					; If so, cap it

.SetSpeedX:
	move.w	d1,obj.x_speed(a6)				; Set X speed

	muls.w	d2,d0						; Set Y speed
	asr.l	#8,d0
	move.w	d0,obj.y_speed(a6)
	rts

; ------------------------------------------------------------------------------
; Wall collision
; ------------------------------------------------------------------------------

WallCollision:
	move.b	player.angle(a6),d0				; Are we on a flat surface?
	andi.b	#$3F,d0
	beq.s	.Flat						; If so, branch

	move.b	player.angle(a6),d0				; Are we moving on a ceiling?
	addi.b	#$40,d0
	bmi.s	.End						; If so, branch

.Flat:
	move.b	#$40,d1						; Get angle to point the sensor towards (angle +/- 90 degrees)
	tst.w	player.ground_speed(a6)
	beq.s	.End
	bmi.s	.RotateAngle
	neg.w	d1

.RotateAngle:
	move.b	player.angle(a6),d0				; Get angle
	add.b	d1,d0

	move.w	d0,-(sp)					; Get distance from wall
	jsr	ObjMapCollideFront
	move.w	(sp)+,d0
	tst.w	d1
	bpl.s	.End						; If we aren't colliding with a wall, branch
	
	addi.b	#$20,d0						; Get the angle of the wall
	andi.b	#$C0,d0
	beq.s	.PushDown					; If we are facing a wall downwards, branch
	cmpi.b	#$40,d0						; Are we facing a wall on the left?
	beq.s	.PushLeft					; If so, branch
	cmpi.b	#$80,d0						; Are we facing a wall upwards?
	beq.s	.PushUp						; If so, branch

.PushRight:
	add.w	d1,obj.x(a6)					; Move out of wall
	clr.w	obj.x+2(a6)
	bset	#SONIC_PUSH,obj.flags(a6)			; Mark as pushing
	clr.w	player.ground_speed(a6)				; Stop moving
	clr.w	obj.x_speed(a6)

.End:
	rts

.PushUp:
	sub.w	d1,obj.y(a6)					; Move out of wall
	clr.w	obj.y+2(a6)
	clr.w	obj.y_speed(a6)					; Stop moving
	rts

.PushLeft:
	sub.w	d1,obj.x(a6)					; Move out of wall
	clr.w	obj.x+2(a6)
	bset	#SONIC_PUSH,obj.flags(a6)			; Mark as pushing
	clr.w	player.ground_speed(a6)				; Stop moving
	clr.w	obj.x_speed(a6)
	rts

.PushDown:
	add.w	d1,obj.y(a6)					; Move out of wall
	clr.w	obj.y+2(a6)
	clr.w	obj.y_speed(a6)					; Stop moving
	rts
	
; ------------------------------------------------------------------------------
; Floor collision
; ------------------------------------------------------------------------------

FloorCollision:
	move.w	#$303,obj_angle_buffer				; Reset angle buffers

	move.b	player.angle(a6),d0				; Get the angle
	btst	#6,d0						; Are we in quadrants 0 or $80?
	beq.s	.DownUp						; If not, branch
	addq.b	#1,d0						; Shift the angle

.DownUp:
	addi.b	#$1F,d0						; Shift the angle
	andi.b	#$C0,d0						; Get which quadrant we are in

	cmpi.b	#$40,d0						; Are we on a left wall?
	beq.w	FloorCollisionLeft				; If so, branch
	cmpi.b	#$80,d0						; Are we on a ceiling?
	beq.w	FloorCollisionUp				; If so, branch
	cmpi.b	#$C0,d0						; Are we on a right wall?
	beq.w	FloorCollisionRight				; If so, branch

; ------------------------------------------------------------------------------

FloorCollisionDown:
	move.w	player.width(a6),obj.collide_width(a6)		; Set hitbox size
	move.w	player.height(a6),obj.collide_height(a6)

	jsr	ObjMapCollideDownWide				; Check collision
	move.b	d2,player.angle(a6)				; Set angle

	tst.w	d1						; Are we perfectly aligned to the floor?
	beq.s	.End						; If so, branch
	bpl.s	.CheckLedge					; If we are outside the floor, branch
	
	cmpi.w	#-14,d1						; Have we hit a wall?
	blt.s	.End						; If so, branch
	
	add.w	d1,obj.y(a6)					; Align outselves onto the floor
	clr.w	obj.y+2(a6)
	
	bra.w	GetOffObject					; Get off object, if on one

.End:
	rts

.CheckLedge:
	move.b	obj.x_speed(a6),d0				; Get the integer part of the X speed
	bpl.s	.GetMinDist					; If it's already positive, branch
	neg.b	d0						; Get absolute value

.GetMinDist:
	addq.b	#4,d0						; The Y distance must be at least 4 pixels down
	cmpi.b	#14,d0						; ...but cannot be more than 14 pixels down
	bcs.s	.CheckDist					; ...for us to not fall off the surface
	moveq	#14,d0

.CheckDist:
	cmp.b	d0,d1						; Are we about to fall off?
	bgt.s	.MoveOff					; If so, branch
	add.w	d1,obj.y(a6)					; Align ourselves onto the floor
	clr.w	obj.y+2(a6)
	
	bra.w	GetOffObject					; Get off object, if on one

.MoveOff:
	bra.w	MoveOffFloor					; Move off floor

; ------------------------------------------------------------------------------

FloorCollisionRight:
	move.w	player.height(a6),obj.collide_width(a6)		; Set hitbox size
	move.w	player.width(a6),obj.collide_height(a6)
	
	jsr	ObjMapCollideRightWide				; Check collision
	move.b	d2,player.angle(a6)				; Set angle

	tst.w	d1						; Are we perfectly aligned to the wall?
	beq.s	.End						; If so, branch
	bpl.s	.CheckLedge					; If we are outside the wall, branch
	
	cmpi.w	#-14,d1						; Have we hit a wall?
	blt.s	.End						; If so, branch
	
	add.w	d1,obj.x(a6)					; Align outselves onto the wall
	clr.w	obj.x+2(a6)
	
	bra.w	GetOffObject					; Get off object, if on one

.End:
	rts

.CheckLedge:
	move.b	obj.y_speed(a6),d0				; Get the integer part of the Y speed
	bpl.s	.GetMinDist					; If it's already positive, branch
	neg.b	d0						; Get absolute value

.GetMinDist:
	addq.b	#4,d0						; The X distance must be at least 4 pixels down
	cmpi.b	#14,d0						; ...but cannot be more than 14 pixels down
	blo.s	.CheckDist					; ...for us to not fall off the surface
	moveq	#14,d0

.CheckDist:
	cmp.b	d0,d1						; Are we about to fall off?
	bgt.s	.MoveOff					; If so, branch
	add.w	d1,obj.x(a6)					; Align ourselves onto the wall
	clr.w	obj.x+2(a6)
	
	bra.w	GetOffObject					; Get off object, if on one

.MoveOff:
	bra.w	MoveOffFloor					; Move off floor

; ------------------------------------------------------------------------------

FloorCollisionUp:
	move.w	player.width(a6),obj.collide_width(a6)		; Set hitbox size
	move.w	player.height(a6),obj.collide_height(a6)
	
	jsr	ObjMapCollideUpWide				; Check collision
	move.b	d2,player.angle(a6)				; Set angle

	tst.w	d1						; Are we perfectly aligned to the ceiling?
	beq.s	.End						; If so, branch
	bpl.s	.CheckLedge					; If we are outside the ceiling, branch
	
	cmpi.w	#-14,d1						; Have we hit a ceiling?
	blt.w	.End						; If so, branch
	
	sub.w	d1,obj.y(a6)					; Align outselves onto the ceiling
	clr.w	obj.y+2(a6)
	
	bra.w	GetOffObject					; Get off object, if on one

.End:
	rts

.CheckLedge:
	move.b	obj.x_speed(a6),d0				; Get the integer part of the X speed
	bpl.s	.GetMinDist					; If it's already positive, branch
	neg.b	d0						; Get absolute value

.GetMinDist:
	addq.b	#4,d0						; The Y distance must be at least 4 pixels down
	cmpi.b	#14,d0						; ...but cannot be more than 14 pixels down
	bcs.s	.CheckDist					; ...for us to not fall off the surface
	moveq	#14,d0

.CheckDist:
	cmp.b	d0,d1						; Are we about to fall off?
	bgt.s	.MoveOff					; If so, branch
	
	sub.w	d1,obj.y(a6)					; Align ourselves onto the ceiling
	clr.w	obj.y+2(a6)
	
	bra.w	GetOffObject					; Get off object, if on one

.MoveOff:
	bra.w	MoveOffFloor					; Move off floor

; ------------------------------------------------------------------------------

FloorCollisionLeft:
	move.w	player.height(a6),obj.collide_width(a6)		; Set hitbox size
	move.w	player.width(a6),obj.collide_height(a6)
	
	jsr	ObjMapCollideLeftWide				; Check collision
	move.b	d2,player.angle(a6)				; Set angle

	tst.w	d1						; Are we perfectly aligned to the ground?
	beq.s	.End						; If so, branch
	bpl.s	.CheckLedge					; If we are outside the wall, branch
	
	cmpi.w	#-14,d1						; Have we hit a wall?
	blt.s	.End						; If so, branch
	
	sub.w	d1,obj.x(a6)					; Align outselves onto the wall
	clr.w	obj.x+2(a6)
	
	bra.w	GetOffObject					; Get off object, if on one
	
.End:
	rts

.CheckLedge:
	move.b	obj.y_speed(a6),d0				; Get the integer part of the Y speed
	bpl.s	.GetMinDist					; If it's already positive, branch
	neg.b	d0						; Get absolute value

.GetMinDist:
	addq.b	#4,d0						; The X distance must be at least 4 pixels down
	cmpi.b	#14,d0						; ...but cannot be more than 14 pixels down
	blo.s	.CheckDist					; ...for us to not fall off the surface
	moveq	#14,d0

.CheckDist:
	cmp.b	d0,d1						; Are we about to fall off?
	bgt.s	.MoveOff					; If so, branch
	
	sub.w	d1,obj.x(a6)					; Align ourselves onto the wall
	clr.w	obj.x+2(a6)
	
	bra.w	GetOffObject					; Get off object, if on one

.MoveOff:
	bra.w	MoveOffFloor					; Move off floor

; ------------------------------------------------------------------------------
; Airborne state
; ------------------------------------------------------------------------------

AirborneState:
	bsr.w	GetControllerData				; Get controller data
	bsr.w	SetCollisionLayer				; Set collision layer
	lea	Physics(pc),a5					; Get physics table
	
	bsr.w	MoveAirborne					; Handle movement
	jsr	MoveObject					; Apply speed
	bsr.w	ApplyGravity					; Apply gravity
	bsr.w	CheckMapBoundaries				; Check map boundaries
	
	bsr.w	AirborneCollision				; Collision
	bsr.w	ResetCollisionLayer				; Reset collision layer

	bsr.w	AirborneAnimation				; Handle animation
	bra.w	CheckFlashDraw					; Draw sprite

; ------------------------------------------------------------------------------
; Jump state
; ------------------------------------------------------------------------------

JumpState:
	bsr.w	GetControllerData				; Get controller data
	bsr.w	SetCollisionLayer				; Set collision layer
	lea	Physics(pc),a5					; Get physics table

JumpState2:
	bsr.w	MoveAirborne					; Handle movement
	bsr.w	CheckJumpHeight					; Check jump height
	jsr	MoveObject					; Apply speed
	bsr.w	ApplyGravity					; Apply gravity
	bsr.w	CheckMapBoundaries				; Check map boundaries
	
	bsr.w	SetCollisionLayer				; Set collision layer
	bsr.w	AirborneCollision				; Collision
	bsr.w	ResetCollisionLayer				; Reset collision layer
	
	bsr.w	AirborneAnimation				; Handle animation
	bra.w	CheckFlashDraw					; Draw sprite

; ------------------------------------------------------------------------------
; Hurt state
; ------------------------------------------------------------------------------

HurtState:
	bsr.w	GetControllerData				; Get controller data
	bsr.w	SetCollisionLayer				; Set collision layer
	lea	Physics(pc),a5					; Get physics table
	
	jsr	MoveObject					; Apply speed
	bsr.w	ApplyGravity					; Apply gravity
	bsr.w	CheckMapBoundaries				; Check map boundaries
	
	bsr.w	AirborneCollision				; Collision
	bsr.w	ResetCollisionLayer				; Reset collision layer

	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Dead state
; ------------------------------------------------------------------------------

DeadState:
	lea	Physics(pc),a5					; Get physics table
	
	jsr	MoveObject					; Apply speed
	bsr.w	ApplyGravity					; Apply gravity

	move.w	camera_fg_y_draw,d0				; Are we off screen?
	addi.w	#256,d0
	cmp.w	obj.y(a6),d0
	bgt.s	.Draw						; If not, branch

	subq.b	#1,player.death_timer(a6)			; Decrement death timer
	bne.s	.NoRestart					; If it hasn't run out, branch

	st	restart_stage					; Restart the stage

.NoRestart:
	move.w	d0,obj.y(a6)					; Stop moving
	clr.w	obj.y_speed(a6)

.Draw:
	bsr.w	AirborneAnimation				; Handle animation
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Jump height
; ------------------------------------------------------------------------------

CheckJumpHeight:
	move.w	#-$400,d1					; Are we jumping high enough?
	cmp.w	obj.y_speed(a6),d1
	ble.s	.End						; If not, branch
	
	move.b	player.ctrl_hold(a6),d0				; Are A, B, or C being held?
	andi.b	#BUTTON_A|BUTTON_B|BUTTON_C,d0
	bne.s	.End						; If so, branch

	move.w	d1,obj.y_speed(a6)				; Cut jump short

.End:
	rts

; ------------------------------------------------------------------------------
; Air movement
; ------------------------------------------------------------------------------

MoveAirborne:
	move.w	physics.max_speed(a5),d6			; Get max speed
	move.w	physics.acceleration(a5),d5			; Get acceleration speed
	add.w	d5,d5

; ------------------------------------------------------------------------------

.CheckLeft:
	btst	#BUTTON_LEFT_BIT,player.ctrl_hold(a6)		; Is left being held?
	beq.s	.CheckRight					; If not, branch

	move.w	obj.x_speed(a6),d0				; Get X speed
	bset	#SONIC_X_FLIP,obj.flags(a6)			; Face in the right direction
	
	sub.w	d5,d0						; Accelerate
	move.w	d6,d1						; Get max speed
	neg.w	d1
	cmp.w	d1,d0						; Are we already at max speed?
	bgt.s	.SetSpeed					; If not, branch
	add.w	d5,d0						; Undo acceleration
	cmp.w	d1,d0						; Are we past the max speed?
	ble.s	.SetSpeed					; If so, branch
	move.w	d1,d0						; Cap the speed
	bra.s	.SetSpeed

; ------------------------------------------------------------------------------

.CheckRight:
	btst	#BUTTON_RIGHT_BIT,player.ctrl_hold(a6)		; Is right being held?
	beq.s	.AirDrag					; If not, branch

	move.w	obj.x_speed(a6),d0				; Get X speed
	bclr	#SONIC_X_FLIP,obj.flags(a6)			; Face in the right direction
	
	add.w	d5,d0						; Accelerate
	cmp.w	d6,d0						; Are we already at max speed?
	blt.s	.SetSpeed					; If not, branch
	sub.w	d5,d0						; Undo acceleration
	cmp.w	d6,d0						; Are we past the max speed?
	bge.s	.SetSpeed					; If so, branch
	move.w	d6,d0						; Cap the speed

.SetSpeed:
	move.w	d0,obj.x_speed(a6)				; Set X speed

; ------------------------------------------------------------------------------

.AirDrag:
	cmpi.w	#-$400,obj.y_speed(a6)				; Are we vertically moving between -4 and 0?
	bcs.s	.End						; If not, branch
	
	move.w	obj.x_speed(a6),d0				; Get air drag value
	move.w	d0,d1
	asr.w	#5,d1
	beq.s	.End						; If we are moving too slow, branch
	bmi.s	.AirDragLeft					; If we are moving left, branch

.AirDragRight:
	sub.w	d1,d0						; Slow down
	bcc.s	.SetAirDragSpeed				; If we haven't stopped yet, branch
	moveq	#0,d0						; Stop moving
	bra.s	.SetAirDragSpeed

.AirDragLeft:
	sub.w	d1,d0						; Slow down
	bcs.s	.SetAirDragSpeed				; If we haven't stopped yet, branch
	moveq	#0,d0						; Stop moving

.SetAirDragSpeed:
	move.w	d0,obj.x_speed(a6)				; Set X speed

.End:
	rts

; ------------------------------------------------------------------------------
; Apply gravity
; ------------------------------------------------------------------------------

ApplyGravity:
	move.w	physics.gravity(a5),d0				; Apply gravity
	add.w	d0,obj.y_speed(a6)
	
	cmpi.w	#-$FC0,obj.y_speed(a6)				; Are we moving up too fast?
	bge.s	.CheckDown					; If not, branch
	move.w	#-$FC0,obj.y_speed(a6)				; If so, cap it

.CheckDown:
	cmpi.w	#$FC0,obj.y_speed(a6)				; Are we falling too fast?
	ble.s	.End						; If not, branch
	move.w	#$FC0,obj.y_speed(a6)				; If so, cap it

.End:
	rts

; ------------------------------------------------------------------------------
; Airborne collision
; ------------------------------------------------------------------------------

AirborneCollision:
	move.w	player.width(a6),obj.collide_width(a6)		; Set hitbox size
	move.w	player.height(a6),obj.collide_height(a6)

	move.w	obj.x_speed(a6),d0				; Get X speed
	move.w	obj.y_speed(a6),d1				; Get Y speed
	bpl.s	.PositiveY					; If it's positive, branch

	cmp.w	d0,d1						; Are we moving towards the left?
	bgt.w	AirborneCollisionLeft				; If so, branch

	neg.w	d0						; Are we moving towards the right?
	cmp.w	d0,d1
	bge.w	AirborneCollisionRight				; If so, branch

	bra.w	AirborneCollisionUp				; We are moving up

.PositiveY:
	cmp.w	d0,d1						; Are we moving towards the right?
	blt.w	AirborneCollisionRight				; If so, branch

	neg.w	d0						; Are we moving towards the left?
	cmp.w	d0,d1
	ble.w	AirborneCollisionLeft				; If so, branch

; ------------------------------------------------------------------------------

AirborneCollisionDown:
	jsr	ObjMapCollideLeft				; Are we colliding with a wall on the left?
	tst.w	d1
	bpl.s	.CheckRightWall					; If there was no collision, branch
	
	sub.w	d1,obj.x(a6)					; Move outside of the wall
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving horizontally

.CheckRightWall:
	jsr	ObjMapCollideRight				; Are we colliding with a wall on the right?
	tst.w	d1
	bpl.s	.NotRightWall					; If not, branch

	add.w	d1,obj.x(a6)					; Move outside of the wall
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving horizontally

.NotRightWall:
	jsr	ObjMapCollideDownWide				; Are we colliding with the floor?
	tst.w	d1
	bpl.w	.End						; If not, branch

	move.b	obj.y_speed(a6),d3				; Are we too deep in?
	addq.b	#8,d3
	neg.b	d3
	cmp.b	d3,d1
	bge.s	.NotFallThrough					; If not, branch
	cmp.b	d3,d0
	blt.s	.End						; If so, branch

.NotFallThrough:
	move.b	d2,player.angle(a6)				; Set angle
	add.w	d1,obj.y(a6)					; Move outside of the floor
	clr.w	obj.y+2(a6)
	
	move.b	d2,d0						; Did we land on a steep slope?
	addi.b	#$20,d0
	andi.b	#$40,d0
	bne.s	.LandCeiling					; If so, branch

	move.b	d2,d0						; Did we land on a more flat surface?
	addi.b	#$10,d0
	andi.b	#$20,d0
	beq.s	.LandFloor					; If so, branch

	move.w	obj.y_speed(a6),d0				; Halve the landing speed
	asr.w	#1,d0
	move.w	d0,obj.y_speed(a6)
	bra.s	.LandSlope

.LandFloor:
	clr.w	obj.y_speed(a6)					; Stop moving vertically
	move.w	obj.x_speed(a6),player.ground_speed(a6)		; Set landing speed
	bra.w	SetGroundState					; Set on ground

.LandCeiling:
	clr.w	obj.x_speed(a6)					; Stop moving horizontally
	cmpi.w	#$FC0,obj.y_speed(a6)				; Is our landing speed greater than 15.75?
	ble.s	.LandSlope					; If not, branch
	move.w	#$FC0,obj.y_speed(a6)				; Cap it at 15.75

.LandSlope:
	bsr.w	SetGroundState					; Set on ground
	move.w	obj.y_speed(a6),player.ground_speed(a6)		; Set landing speed
	tst.b	d2						; Is our angle 0-$7F?
	bpl.s	.End						; If so, branch
	neg.w	player.ground_speed(a6)				; If not, negate our landing speed

.End:
	rts

; ------------------------------------------------------------------------------

AirborneCollisionLeft:
	jsr	ObjMapCollideLeft				; Are we colliding with a wall on the left?
	tst.w	d1
	bpl.s	.CheckCeiling					; If not, branch

	sub.w	d1,obj.x(a6)					; Move outside of the wall
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving horizontally
	move.w	obj.y_speed(a6),player.ground_speed(a6)		; Set landing speed

.CheckCeiling:
	jsr	ObjMapCollideUpWide				; Are we colliding with a ceiling?
	tst.w	d1
	bpl.s	.CheckFloor					; If not, branch

	neg.w	d1						; Get the distance inside the ceiling
	cmpi.w	#$14,d1						; Are we too far into the ceiling?
	bcc.s	.CheckRightWall					; If so, branch

	add.w	d1,obj.y(a6)					; Move outside of the ceiling
	clr.w	obj.y+2(a6)
	tst.w	obj.y_speed(a6)					; Were we moving upwards?
	bpl.s	.End						; If not, branch
	clr.w	obj.y_speed(a6)					; If so, stop moving vertically

.End:
	rts

.CheckRightWall:
	jsr	ObjMapCollideRight				; Are we colliding with a wall on the right?
	tst.w	d1
	bpl.s	.End						; If not, branch

	add.w	d1,obj.x(a6)					; Move outside of the wall
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving horizontally
	rts

.CheckFloor:
	tst.w	obj.y_speed(a6)					; Are we moving upwards?
	bmi.s	.End						; If so, branch

	jsr	ObjMapCollideDownWide				; Are we colliding with the floor?
	tst.w	d1
	bpl.s	.End						; If not, branch
	
	move.b	obj.y_speed(a6),d3				; Are we too deep in?
	addq.b	#8,d3
	neg.b	d3
	cmp.b	d3,d1
	bge.s	.NotFallThrough					; If not, branch
	cmp.b	d3,d0
	blt.s	.End						; If so, branch

.NotFallThrough:
	add.w	d1,obj.y(a6)					; Move outside of the floor
	clr.w	obj.y+2(a6)
	move.b	d2,player.angle(a6)				; Set angle
	clr.w	obj.y_speed(a6)					; Stop moving vertically
	move.w	obj.x_speed(a6),player.ground_speed(a6)		; Set landing speed
	
	bra.w	SetGroundState					; Set on ground

; ------------------------------------------------------------------------------

AirborneCollisionUp:
	jsr	ObjMapCollideLeft				; Are we colliding with a wall on the left?
	tst.w	d1
	bpl.s	.CheckRightWall					; If not, branch

	sub.w	d1,obj.x(a6)					; Move outside of the wall
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving horizontally

.CheckRightWall:
	jsr	ObjMapCollideRight				; Are we colliding with a wall on the right?
	tst.w	d1
	bpl.s	.CheckCeiling					; If not, branch

	add.w	d1,obj.x(a6)					; Move outside of the wall
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving horizontally

.CheckCeiling:
	jsr	ObjMapCollideUpWide				; Are we colliding with a ceiling?
	tst.w	d1
	bpl.s	.End						; If not, branch

	sub.w	d1,obj.y(a6)					; Move outside of the ceiling
	clr.w	obj.y+2(a6)
	
	move.b	d2,d0						; Did we land on a steep slope?
	addi.b	#$20,d0
	andi.b	#$40,d0
	bne.s	.LandCeiling					; If so, branch

	clr.w	obj.y_speed(a6)					; Stop moving vertically
	rts

.LandCeiling:
	move.b	d2,player.angle(a6)				; Set angle
	bsr.w	SetGroundState					; Set on ground
	move.w	obj.y_speed(a6),player.ground_speed(a6)		; Set landing speed

	tst.b	d2						; Is our angle 0-$7F?
	bpl.s	.End						; If so, branch
	neg.w	player.ground_speed(a6)				; If not, negate our landing speed

.End:
	rts

; ------------------------------------------------------------------------------

AirborneCollisionRight:
	jsr	ObjMapCollideRight				; Are we colliding with a wall on the right?
	tst.w	d1
	bpl.s	.CheckCeiling					; If not, branch

	add.w	d1,obj.x(a6)					; Move outside of the wall
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving horizontally
	move.w	obj.y_speed(a6),player.ground_speed(a6)		; Set landing speed

.CheckCeiling:
	jsr	ObjMapCollideUpWide				; Are we colliding with a ceiling?
	tst.w	d1
	bpl.s	.CheckFloor					; If not, branch

	sub.w	d1,obj.y(a6)					; Move outside of the ceiling
	clr.w	obj.y+2(a6)
	tst.w	obj.y_speed(a6)					; Were we moving upwards?
	bpl.s	.End						; If not, branch
	clr.w	obj.y_speed(a6)					; If so, stop moving vertically

.End:
	rts

.CheckFloor:
	tst.w	obj.y_speed(a6)					; Are we moving upwards?
	bmi.s	.End						; If so, branch

	jsr	ObjMapCollideDownWide				; Are we colliding with the floor?
	tst.w	d1
	bpl.s	.End						; If not, branch

	move.b	obj.y_speed(a6),d3				; Are we too deep in?
	addq.b	#8,d3
	neg.b	d3
	cmp.b	d3,d1
	bge.s	.NotFallThrough					; If not, branch
	cmp.b	d3,d0
	blt.s	.End						; If so, branch

.NotFallThrough:
	add.w	d1,obj.y(a6)					; Move outside of the floor
	clr.w	obj.y+2(a6)
	move.b	d2,player.angle(a6)				; Set angle
	clr.w	obj.y_speed(a6)					; Stop moving vertically
	move.w	obj.x_speed(a6),player.ground_speed(a6)		; Set landing speed

; ------------------------------------------------------------------------------
; Set player on ground
; ------------------------------------------------------------------------------

SetGroundState:
	bclr	#SONIC_AIR,obj.flags(a6)			; Clear air flag
	beq.s	.End						; If it was already cleared, branch
	
	move.l	#GroundState,obj.update(a6)			; Set ground state
	bclr	#SONIC_ROLL,obj.flags(a6)			; Clear roll flag
	bclr	#SONIC_JUMP,obj.flags(a6)			; Stop jumping
	bclr	#SONIC_PUSH,obj.flags(a6)			; Stop pushing

.End:
	rts

; ------------------------------------------------------------------------------
; Set roll state
; ------------------------------------------------------------------------------

SetRollState:
	move.l	#RollState,obj.update(a6)			; Set roll state
	bset	#SONIC_ROLL,obj.flags(a6)			; Start rolling
	
	lea	Sfx_Roll,a0					; Play roll sound
	jmp	PlaySfx

; ------------------------------------------------------------------------------
; Move off the floor
; ------------------------------------------------------------------------------

MoveOffFloor:
	btst	#SONIC_RIDE,obj.flags(a6)			; Are we standing on an object?
	beq.s	SetAirborneState				; If not, then we are on the ground
	
	clr.w	obj_angle_buffer				; Reset angle
	clr.b	player.angle(a6)
	rts

; ------------------------------------------------------------------------------
; Set airborne state
; ------------------------------------------------------------------------------

SetAirborneState:
SetSonicPlayerAirborne:
	move.l	#AirborneState,obj.update(a6)			; Set airborne state
	bset	#SONIC_AIR,obj.flags(a6)			; Set airborne flag
	bclr	#SONIC_JUMP,obj.flags(a6)			; Stop jumping
	bclr	#SONIC_PUSH,obj.flags(a6)			; Stop pushing

; ------------------------------------------------------------------------------
; Get off object
; ------------------------------------------------------------------------------

GetOffObject:
	bclr	#SONIC_RIDE,obj.flags(a6)			; Stop riding on object
	clr.w	player.ride_object(a6)
	clr.w	player.ride_width(a6)
	rts

; ------------------------------------------------------------------------------
; Check map boundaries
; ------------------------------------------------------------------------------

CheckMapBoundaries:
	move.w	obj.x(a6),d0					; Are we past the left boundary?
	move.w	map_fg_bound_left,d1
	add.w	obj.collide_width(a6),d1
	cmp.w	d1,d0
	blt.s	.StopX						; If so, branch
	
	move.w	map_fg_bound_right,d1				; Are we past the right boundary?
	sub.w	obj.collide_width(a6),d1
	cmp.w	d1,d0
	ble.s	.CheckTop					; If not, branch

.StopX:
	move.w	d1,obj.x(a6)					; Stop at boundary
	clr.w	obj.x+2(a6)
	clr.w	obj.x_speed(a6)					; Stop moving
	clr.w	player.ground_speed(a6)

.CheckTop:
	move.w	obj.y(a6),d0					; Are we past the top boundary?
	move.w	map_fg_bound_top,d1
	add.w	obj.collide_height(a6),d1
	cmp.w	d1,d0
	blt.s	.StopY						; If so, branch
	
	move.w	map_fg_bound_bottom,d1				; Are we past the bottom boundary?
	sub.w	obj.collide_height(a6),d1
	cmp.w	d1,d0
	ble.s	.End						; If not, branch

	bra.w	KillSonicPlayer					; Kill us

.StopY:
	move.w	d1,obj.y(a6)					; Stop at boundary
	clr.w	obj.y+2(a6)
	clr.w	obj.y_speed(a6)					; Stop moving

.End:
	rts

; ------------------------------------------------------------------------------
; Handle ground animation
; ------------------------------------------------------------------------------

GroundAnimation:
	move.w	player.ground_speed(a6),d0			; Get animation speed
	beq.s	.ResetFrame					; If it's 0, branch
	
	asr.w	#2,d0						; Get animation speed
	btst	#SONIC_ROLL,obj.flags(a6)
	bne.s	.NextFrame
	asr.w	#1,d0

.NextFrame:
	add.w	d0,player.frame(a6)				; Apply animation speed
	andi.b	#7,player.frame(a6)
	
	asr.w	#5,d0						; Increase GameTap counter
	bpl.s	.GameTapCounter
	neg.w	d0

.GameTapCounter:
	addq.w	#8,d0
	sub.w	d0,player.gametap(a6)
	bpl.s	.End						; If it's not time to play the sound, branch, branch
	
	move.w	#$FF04,MARS_COMM_10+MARS_SYS			; Play the sound
	addi.w	#$100,player.gametap(a6)			; Reset GameTap counter

.End:
	rts

; ------------------------------------------------------------------------------

.ResetFrame:
	clr.w	player.gametap(a6)				; Reset GameTap counter
	rts

; ------------------------------------------------------------------------------
; Handle air animation
; ------------------------------------------------------------------------------

AirborneAnimation:
	move.w	#$80,d1						; Get base animation speed
	move.w	obj.x_speed(a6),d0				; Get X speed
	asr.w	#4,d0
	bpl.s	.ApplyBase					; If it's positive, branch
	neg.w	d1						; Negate base animation speed
	
.ApplyBase:
	add.w	d1,d0						; Apply animation speed
	add.w	d0,player.frame(a6)
	andi.b	#7,player.frame(a6)

	asr.w	#5,d0						; Increase GameTap counter
	bpl.s	.GameTapCounter
	neg.w	d0

.GameTapCounter:
	addq.w	#8,d0
	sub.w	d0,player.gametap(a6)
	bpl.s	.End						; If it's not time to play the sound, branch, branch
	
	move.w	#$FF04,MARS_COMM_10+MARS_SYS			; Play the sound
	addi.w	#$100,player.gametap(a6)			; Reset GameTap counter
	
.End:
	rts

; ------------------------------------------------------------------------------
; Hurt the player
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Hazard X position
; ------------------------------------------------------------------------------

HurtSonicPlayer:
	movea.w	player_object,a1				; Get player object

	cmpi.l	#DeadState,obj.update(a1)			; Is the player dead?
	beq.s	.End						; If so, branch
	
	tst.b	player.recover_timer(a1)			; Is the player already hurt?
	bne.s	.End						; If so, branch
	
	subq.b	#1,player_health				; Decrement player health
	beq.s	KillSonicPlayer					; If the player should die, branch

	move.w	d0,-(sp)					; Save hazard X position

	lea	Sfx_Damage,a0					; Play damage sound
	jsr	PlaySfx

	move.l	a6,-(sp)					; Set hurt state
	movea.w	a1,a6
	bsr.w	SetSonicPlayerAirborne
	movea.l	(sp)+,a6
	move.l	#HurtState,obj.update(a1)
	bclr	#SONIC_ROLL,obj.flags(a1)
	
	move.b	#120,player.recover_timer(a1)			; Set recovery timer

	move.w	#-$400,obj.y_speed(a1)				; Repel the player
	move.w	#-$200,obj.x_speed(a1)
	clr.w	player.ground_speed(a1)
	
	move.w	(sp)+,d0					; Restore hazard X position

	cmp.w	obj.x(a1),d0					; Is the player left of the hazard?
	bge.s	.End						; If so, branch
	neg.w	obj.x_speed(a1)					; If not, repel the other way
	
.End:
	rts

; ------------------------------------------------------------------------------
; Kill the player
; ------------------------------------------------------------------------------

KillSonicPlayer:
	movea.w	player_object,a1				; Get player object

	cmpi.l	#DeadState,obj.update(a1)			; Is the player already dead?
	beq.s	.End						; If so, branch

	lea	Sfx_Damage,a0					; Play damage sound
	jsr	PlaySfx

	move.l	a6,-(sp)					; Set hurt state
	movea.w	a1,a6
	bsr.w	SetSonicPlayerAirborne
	movea.l	(sp)+,a6
	move.l	#HurtState,obj.update(a1)
	bclr	#SONIC_ROLL,obj.flags(a1)

	clr.b	player_health					; Clear player health

	move.l	#DeadState,obj.update(a1)			; Set dead state
	clr.w	obj.x_speed(a1)
	clr.w	player.ground_speed(a1)
	move.w	#-$700,obj.y_speed(a1)
	move.b	#120,player.death_timer(a1)

	clr.w	cam_focus_object				; Stop focusing on the player

.End:
	rts

; ------------------------------------------------------------------------------
; Check collision with solid objects
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; ------------------------------------------------------------------------------

CheckSonicSolidObjects:
	cmpi.l	#DeadState,obj.update(a6)			; Are we dead?
	beq.w	.End						; If so, branch

	move.w	player.ride_object(a6),d0			; Is the player riding on an object?
	beq.s	.NoRideStop					; If not, branch
	movea.w	d0,a1						; Get the object being ridden on

	tst.w	item.list(a1)					; Has the object been deleted?
	beq.s	.StopRide					; If so, branch
	
	btst	#SONIC_AIR,obj.flags(a6)			; Is the player in the air now?
	bne.s	.StopRide					; If so, branch
	
	move.w	obj.x(a1),d0					; Move the player along horizontally
	sub.w	obj.previous_x(a1),d0
	add.w	d0,obj.x(a6)
	
	move.w	obj.y(a1),d0					; Move the player along vertically
	sub.w	obj.collide_height(a1),d0
	sub.w	obj.collide_height(a6),d0
	move.w	d0,obj.y(a6)
	clr.w	obj.y_speed(a6)
	
	move.w	obj.x(a6),d0					; Get horizontal distance from the object
	sub.w	obj.x(a1),d0
	bpl.s	.CheckRideDistance
	neg.w	d0
	
.CheckRideDistance:
	cmp.w	player.ride_width(a6),d0			; Has the player moved off the object?
	blt.s	.NoRideStop					; If not, branch

.StopRide:
	bsr.w	SetAirborneState				; Stop riding the object
	
.NoRideStop:
	move.w	a6,-(sp)					; Check player's collision with solid objects
	movea.w	a6,a1
	jsr	CheckSolidObjectCollide
	movea.w	(sp)+,a6
	
	tst.w	solid_object_left				; Has the solid object's sides been touched?
	bne.s	.Push						; If so, branch
	tst.w	solid_object_right
	beq.s	.NoPush						; If not, branch

.Push:
	clr.w	player.ground_speed(a6)				; Reset ground speed

.NoPush:
	tst.w	solid_object_top				; Is a solid object being stood on?
	beq.s	.End						; If not, branch
	
	move.w	solid_object_top,player.ride_object(a6)		; Set the player on the object
	move.w	solid_width_top,player.ride_width(a6)
	bset	#SONIC_RIDE,obj.flags(a6)
	
	move.w	obj.x_speed(a6),player.ground_speed(a6)		; Set speed on the object
	clr.b	player.angle(a6)				; Reset angle

	movea.w	solid_object_top,a1				; Is the solid object a spring?
	cmpi.l	#ObjSpringUpdate,obj.update(a1)
	beq.s	.End						; If so, branch
	
	lea	Physics(pc),a5					; Get physics table
	bra.w	SetGroundState					; Set ground state
	
.End:
	rts

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	pea	MarsSpr_SonicPlayer				; Draw sprite
	move.b	player.frame(a6),-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite

	btst	#SONIC_TAPE,obj.flags(a6)			; Should we be holding a tape?
	beq.s	.End						; If not, branch

	pea	MarsSpr_SonicPlayer				; Draw tape sprite
	move.b	#8,-(sp)
	move.b	#2,-(sp)
	clr.b	-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawMarsSprite

.End:
	rts

; ------------------------------------------------------------------------------
