; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Toad boss object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjToadBoss:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer

	move.w	#12,obj.collide_width(a6)			; Set hitbox size
	move.w	#24,obj.collide_height(a6)
	
	move.w	#16,obj.draw_width(a6)				; Set draw size
	move.w	#32,obj.draw_height(a6)

	move.w	#272,obj.x(a6)					; Set position
	move.w	#167,obj.y(a6)
	
	move.b	#8,toad.hit_count(a6)				; Set hit count
	move.b	#3,toad.jump_count(a6)				; Set jump count
	
	lea	obj.anim(a6),a0					; Set idle animation
	lea	Anim_ToadBoss(pc),a1
	moveq	#0,d0
	jsr	SetAnimation

	move.l	#.Fall,obj.update(a6)				; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------

.Fall:
	jsr	MoveObject					; Move
	addi.w	#$38,obj.y_speed(a6)				; Apply gravity
	
	jsr	ObjMapCollideDownWide				; Check floor collision
	tst.w	d1
	bmi.s	.StartWait					; If there was a collision, branch

	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------

.StartWait:
	add.w	d1,obj.y(a6)					; Align with floor
	clr.w	obj.y_speed(a6)					; Stop moving
	
	move.l	#WaitState,obj.update(a6)			; Set wait state
	move.w	#60,toad.timer(a6)

; ------------------------------------------------------------------------------
; Wait state
; ------------------------------------------------------------------------------

WaitState:
	subq.w	#1,toad.timer(a6)				; Decrement timer
	beq.s	.WaitDone					; If it has run out, branch
	
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------

.WaitDone:
	move.l	#GroundState,obj.update(a6)			; Set ground state

; ------------------------------------------------------------------------------
; Ground state
; ------------------------------------------------------------------------------

GroundState:
	jsr	HazardObject					; Hazard object

	tst.w	toad.jump_timer(a6)				; Are we already preparing a jump?
	bne.s	.NoJump						; If so, branch
	
	movea.w	player_object,a1				; Player object
	
	cmpi.b	#60,player.recover_timer(a1)			; Is the player recovering?
	bcc.s	.NoJump						; If so, branch
	btst	#SONIC_JUMP,obj.flags(a1)			; Did the player jump?
	beq.s	.NoJump						; If not, branch

	move.w	#10,toad.jump_timer(a6)				; Set jump timer

.NoJump:
	tst.w	toad.jump_timer(a6)				; Is the jump timer active?
	beq.s	.NoJumpPrepare					; If not, branch
	subq.w	#1,toad.jump_timer(a6)				; Decrement jump timer
	bne.s	.NoJumpPrepare					; If it hasn't run out, branch
	
	lea	Sfx_Jump,a0					; Play sound sound
	jsr	PlaySfx

	move.l	#JumpState,obj.update(a6)			; Set jump state
	move.w	#-$640,obj.y_speed(a6)

.NoJumpPrepare:
	bsr.w	MoveHorizontal					; Move
	jsr	MoveObject
	bsr.w	CheckWallCollision				; Check wall collision
	
	bsr.w	UpdateSprite					; Update sprite
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Jump state
; ------------------------------------------------------------------------------

JumpState:
	jsr	HazardObject					; Hazard object

	bsr.w	MoveHorizontal					; Move
	jsr	MoveObject
	addi.w	#$38,obj.y_speed(a6)				; Apply gravity
	bsr.w	CheckWallCollision				; Check wall collision
	
	tst.w	obj.y_speed(a6)					; Are we falling downwards?
	bmi.s	.Draw						; If not, branch
	
	jsr	ObjMapCollideDownWide				; Check floor collision
	tst.w	d1
	bpl.s	.Draw						; If there was no collision, branch

	add.w	d1,obj.y(a6)					; Align with floor
	clr.w	obj.y_speed(a6)					; Stop moving
	
	subq.b	#1,toad.jump_count(a6)				; Decrement jump count
	bne.s	.NoTrip						; If it hasn't run out, branch
	
	move.l	#TripState,obj.update(a6)			; Set trip state
	move.w	#180,toad.timer(a6)
	bra.w	TripState
	
.NoTrip:
	move.l	#GroundState,obj.update(a6)			; Set ground state
	bra.w	GroundState
	
.Draw:
	bsr.w	UpdateSprite					; Update sprite
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Trip state
; ------------------------------------------------------------------------------

TripState:
	subq.w	#1,toad.timer(a6)				; Decrement timer
	beq.s	.GetUp						; If it has run out, branch

	cmpi.w	#7,obj.anim+anim.frame(a6)			; Have we landed?
	bne.s	.NoHitCheck					; If not, branch

	move.w	#24,obj.collide_width(a6)			; Have we been hit?
	jsr	BossObjectNoHazard
	bne.s	.NoHitCheck					; If not, branch
	
	lea	Sfx_HitBoss,a0					; Play hit boss sound
	jsr	PlaySfx

	subq.b	#1,toad.hit_count(a6)				; Decrement hit count
	bne.s	.GotHit						; If we haven't been defeated, branch
	
	move.l	#DefeatedState,obj.update(a6)			; Set defeated state
	bra.w	DefeatedState

.GotHit:
	move.l	#HitState,obj.update(a6)			; Set hit state
	move.w	#60,toad.timer(a6)
	bra.w	HitState
	
.NoHitCheck:
	lea	obj.anim(a6),a0					; Set trip animation
	lea	Anim_ToadBoss(pc),a1
	moveq	#3,d0
	jsr	SetAnimation
	
	moveq	#6,d1						; Update trip
	bsr.w	UpdateTrip
	
	jmp	DrawObject					; Draw sprite
	
; ------------------------------------------------------------------------------

.GetUp:
	move.l	#GetUpState,obj.update(a6)			; Get up

; ------------------------------------------------------------------------------
; Get up state
; ------------------------------------------------------------------------------

GetUpState:
	lea	obj.anim(a6),a0					; Set get up animation
	lea	Anim_ToadBoss(pc),a1
	moveq	#4,d0
	jsr	SetAnimation
	
	moveq	#-6,d1						; Update trip
	bsr.w	UpdateTrip
	
	cmpi.w	#4,obj.anim+anim.id(a6)				; Have we fully gotten up?
	beq.s	.Draw						; If not, branch
	
	move.b	#3,toad.jump_count(a6)				; Set jump count
	
	move.l	#WaitState,obj.update(a6)			; Set wait state
	move.w	#60,toad.timer(a6)
	
.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Hit state
; ------------------------------------------------------------------------------

HitState:
	subq.w	#1,toad.timer(a6)				; Decrement timer
	beq.s	.GetUp						; If it has run out, branch
	
	btst	#2,toad.timer+1(a6)				; Should we draw on this frame?
	beq.s	.End						; If not, branch
	jmp	DrawObject					; Draw sprite

.End:
	rts
	
; ------------------------------------------------------------------------------

.GetUp:
	move.l	#GetUpState,obj.update(a6)			; Get up
	bra.w	GetUpState

; ------------------------------------------------------------------------------
; Defeated state
; ------------------------------------------------------------------------------

DefeatedState:
	st	boss_end					; End of boss
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Handle horizontal movement
; ------------------------------------------------------------------------------

MoveHorizontal:
	moveq	#$10,d0						; Acceleration
	
	cmpi.l	#JumpState,obj.update(a6)			; Are we moving in the air?
	beq.s	.MoveNormal					; If so, branch

	movea.w	player_object,a1				; Get player object
	cmpi.b	#60,player.recover_timer(a1)			; Is the player recovering?
	bcs.s	.MoveNormal					; If not, branch
	
	tst.w	obj.x_speed(a6)					; Are we moving right?
	bpl.s	.Decelerate					; If so, branch
	neg.w	d0						; Decelerate the other direction
	
.Decelerate:
	sub.w	d0,obj.x_speed(a6)				; Decelerate
	bcc.s	.End						; If we haven't stopped, branch
	clr.w	obj.x_speed(a6)					; Stop moving
	rts
	
.MoveNormal:
	move.w	obj.x(a6),d1					; Are we left of the player?
	cmp.w	obj.x(a1),d1
	blt.s	.MoveRight					; If so, branch
	
.MoveLeft:
	sub.w	d0,obj.x_speed(a6)				; Accelerate left
	cmpi.w	#-$280,obj.x_speed(a6)				; Are we moving fast enough?
	bgt.s	.End						; If not, branch
	move.w	#-$280,obj.x_speed(a6)				; Cap speed
	bra.s	.End
	
.MoveRight:
	add.w	d0,obj.x_speed(a6)				; Accelerate right
	cmpi.w	#$280,obj.x_speed(a6)				; Are we moving fast enough?
	blt.s	.End						; If not, branch
	move.w	#$280,obj.x_speed(a6)				; Cap speed
	
.End:
	rts

; ------------------------------------------------------------------------------
; Update sprite
; ------------------------------------------------------------------------------

UpdateSprite:
	cmpi.l	#JumpState,obj.update(a6)			; Are we moving in the air?
	bne.s	.NotJumping					; If not, branch

	lea	obj.anim(a6),a0					; Set jump animation
	lea	Anim_ToadBoss(pc),a1
	moveq	#2,d0
	jsr	SetAnimation
	bra.s	.SetFlip

.NotJumping:
	tst.w	obj.x_speed(a6)					; Get X speed
	bne.s	.NotIdle					; If we are moving, branch

	lea	obj.anim(a6),a0					; Set idle animation
	lea	Anim_ToadBoss(pc),a1
	moveq	#0,d0
	jmp	SetAnimation

.NotIdle:
	lea	obj.anim(a6),a0					; Set move animation
	lea	Anim_ToadBoss(pc),a1
	moveq	#1,d0
	jsr	SetAnimation
	
	move.w	obj.x_speed(a6),d0				; Set animation speed
	bpl.s	.CalcAnimSpeed
	neg.w	d0
	
.CalcAnimSpeed:
	lsr.w	#4,d0
	cmpi.w	#$20,d0
	bcc.s	.SetAnimSpeed
	moveq	#$20,d0
	
.SetAnimSpeed:
	move.w	d0,obj.anim+anim.speed(a6)

.SetFlip:
	move.w	obj.x_speed(a6),d0				; Get X speed
	bpl.s	.CheckSpeed
	neg.w	d0
	
.CheckSpeed:
	cmpi.w	#$20,d0						; Are we moving fast enough?
	bcs.s	.End						; If not, branch

	bclr	#OBJ_FLIP_X,obj.flags(a6)			; Face left
	tst.w	obj.x_speed(a6)					; Are we moving left?
	bmi.s	.End						; If so, branch
	bset	#OBJ_FLIP_X,obj.flags(a6)			; Face right

.End:
	rts
	
; ------------------------------------------------------------------------------
; Check wall collision
; ------------------------------------------------------------------------------

CheckWallCollision:
	jsr	ObjMapCollideLeft				; Check wall collision
	tst.w	d1
	bpl.s	.CheckRightWall					; If there was no collision, branch

	sub.w	d1,obj.x(a6)					; Align with wall
	clr.w	obj.x_speed(a6)					; Stop moving

.CheckRightWall:
	jsr	ObjMapCollideRight				; Check wall collision
	tst.w	d1
	bpl.s	.End						; If there was no collision, branch

	add.w	d1,obj.x(a6)					; Align with wall
	clr.w	obj.x_speed(a6)					; Stop moving
	
.End:
	rts
	
; ------------------------------------------------------------------------------
; Update trip
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - X offset
; ------------------------------------------------------------------------------

UpdateTrip:
	move.w	d1,-(sp)					; Save X offset
	
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	
	cmpi.w	#3,obj.anim+anim.id(a6)				; Have we tripped?
	beq.s	.CheckFrameChange				; If so, branch
	cmpi.w	#4,obj.anim+anim.id(a6)				; Have we fully gotten up?
	bne.s	.End						; If not, branch
	
.CheckFrameChange:
	move.w	obj.anim+anim.frame(a6),d0			; Get frame
	cmp.w	obj.anim+anim.prev_frame(a6),d0			; Has the frame changed?
	bne.s	.Update						; If so, branch

.End
	addq.w	#2,sp						; Restore stack pointer
	rts
	
.Update:
	subq.w	#3,d0						; Get hitbox size table offset
	add.w	d0,d0
	add.w	d0,d0
	
	move.w	obj.collide_height(a6),d1			; Set hitbox height
	move.w	.Hitboxes+2(pc,d0.w),obj.collide_height(a6)
	sub.w	obj.collide_height(a6),d1
	add.w	d1,obj.y(a6)
	
	move.w	d0,-(sp)					; Check floor collision
	jsr	ObjMapCollideDownWide
	tst.w	d1
	bpl.s	.NoFloorCollide					; If there was no collision, branch
	add.w	d1,obj.y(a6)					; Align with floor
	
.NoFloorCollide:
	move.w	(sp)+,d0					; Set hitbox width
	move.w	.Hitboxes(pc,d0.w),obj.collide_width(a6)
	
	move.w	(sp)+,d1					; Offset X position
	btst	#OBJ_FLIP_X,obj.flags(a6)
	bne.s	.SetOffsetX
	neg.w	d1
	
.SetOffsetX:
	add.w	d1,obj.x(a6)
	
	bra.w	CheckWallCollision				; Check wall collision

; ------------------------------------------------------------------------------

.Hitboxes:
	dc.w	12, 24
	dc.w	15, 21
	dc.w	18, 18
	dc.w	21, 15
	dc.w	24, 11

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	clr.b	-(sp)						; Draw sprite
	move.b	obj.anim+anim.frame+1(a6),-(sp)
	move.b	obj.flags(a6),-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	jsr	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Animations
; ------------------------------------------------------------------------------

Anim_ToadBoss:
	dc.w	.Idle-Anim_ToadBoss
	dc.w	.Move-Anim_ToadBoss
	dc.w	.Jump-Anim_ToadBoss
	dc.w	.Trip-Anim_ToadBoss
	dc.w	.GetUp-Anim_ToadBoss

.Idle:
	ANIM_START $100, ANIM_RESTART
	dc.w	0
	ANIM_END

.Move:
	ANIM_START -1, ANIM_RESTART
	dc.w	0, 1, 2, 1
	ANIM_END

.Jump:
	ANIM_START $100, ANIM_RESTART
	dc.w	3
	ANIM_END

.Trip:
	ANIM_START $80, ANIM_LOOP_POINT, 4
	dc.w	3, 4, 5, 6, 7
	ANIM_END

.GetUp:
	ANIM_START $80, ANIM_SWITCH, 0
	dc.w	7, 6, 5, 4, 3
	ANIM_END

; ------------------------------------------------------------------------------
