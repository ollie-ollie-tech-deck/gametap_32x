; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ring Girl boss object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjRingGirlBoss:
	jsr	SpawnObject					; Spawn couch
	move.l	#ObjCouch,obj.update(a1)

	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer
	
	bsr.w	SetHitboxSize					; Set hitbox size
	
	move.w	#24,obj.draw_width(a6)				; Set draw size
	move.w	#32,obj.draw_height(a6)

	move.w	#352,obj.x(a6)					; Set position
	move.w	#172,obj.y(a6)
	
	lea	obj.anim(a6),a0					; Set breathe animation
	lea	Anim_RingGirlBoss(pc),a1
	moveq	#0,d0
	jsr	SetAnimation

	move.b	#8,ring_girl.hit_count(a6)			; Set hit count
	
	move.l	#WalkInState,obj.update(a6)			; Start walking in
	move.w	#-$100,obj.x_speed(a6)

	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Walk in state
; ------------------------------------------------------------------------------

WalkInState:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	SetHitboxSize					; Set hitbox size

	bsr.w	HazardObject					; Hazard object
	jsr	MoveObject					; Move

	cmpi.w	#240,obj.x(a6)					; Have we walked in?
	bgt.s	.Draw						; If not, branch

	clr.w	obj.x_speed(a6)					; Prepare to charge
	move.l	#PreChargeState,obj.update(a6)

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Pre-charge state
; ------------------------------------------------------------------------------

PreChargeState:
	lea	obj.anim(a6),a0					; Set pre-charge animation
	lea	Anim_RingGirlBoss(pc),a1
	moveq	#1,d0
	jsr	SetAnimation
	
	moveq	#0,d1						; Set timer
	move.b	ring_girl.hit_count(a6),d1
	add.w	d1,d1
	move.w	.Timers(pc,d1.w),ring_girl.timer(a6)

	move.l	#.PreCharge,obj.update(a6)			; Start pre-charging
	bra.s	.PreCharge

; ------------------------------------------------------------------------------

.Timers:
	dc.w	1, 75, 80, 85, 90, 95, 110, 115, 120

; ------------------------------------------------------------------------------

.PreCharge:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	SetHitboxSize					; Set hitbox size

	bsr.w	HazardObject					; Hazard object

	cmpi.w	#3,obj.anim+anim.id(a6)				; Are we turning?
	beq.w	.Draw						; If so, branch

	subq.w	#1,ring_girl.timer(a6)				; Decrement timer
	beq.w	.Charge						; If it has run out, branch
	cmpi.w	#5,ring_girl.timer(a6)				; Have we finished aiming?
	bcs.s	.Draw						; If not, branch

	movea.w	player_object,a1				; Get charge trajectory
	moveq	#0,d1
	move.w	obj.y(a1),d2
	sub.w	obj.y(a6),d2
	jsr	CalcTrajectory

	asl.w	#3,d0						; Get charge speed
	cmpi.w	#-$500,d0
	bgt.s	.SetYSpeed
	move.w	#-$500,d0

.SetYSpeed:
	move.w	d0,obj.y_speed(a6)

	cmpi.w	#2,obj.anim+anim.id(a6)				; Are we fully crouching?
	bcs.s	.Draw						; If so, branch

	move.b	obj.flags(a6),d0				; Get previous X flip flag
	andi.b	#1<<OBJ_FLIP_X,d0

	moveq	#0,d1						; Set X speed
	move.b	ring_girl.hit_count(a6),d1
	add.w	d1,d1
	move.w	.Speeds(pc,d1.w),obj.x_speed(a6)

	bclr	#OBJ_FLIP_X,obj.flags(a6)			; Face towards the player
	move.w	obj.x(a1),d1
	cmp.w	obj.x(a6),d1
	blt.s	.CheckTurnAnim
	neg.w	obj.x_speed(a6)
	bset	#OBJ_FLIP_X,obj.flags(a6)
	
.CheckTurnAnim:
	move.b	obj.flags(a6),d1				; Has the X flip flag changed?
	andi.b	#1<<OBJ_FLIP_X,d1
	eor.b	d0,d1
	beq.s	.Draw						; If not, branch

	lea	obj.anim(a6),a0					; Set turn animation
	lea	Anim_RingGirlBoss(pc),a1
	moveq	#3,d0
	jsr	SetAnimation

.Draw:
	jmp	DrawObject					; Draw sprite

.Charge:
	lea	Sfx_Dash,a0					; Play dash sound
	jsr	PlaySfx

	move.l	#ChargeState,obj.update(a6)			; Charge
	bra.s	.Draw

; ------------------------------------------------------------------------------

.Speeds:
	dc.w	-$700, -$700, -$6C0, -$690, -$660, -$630, -$600, -$600, -$600

; ------------------------------------------------------------------------------
; Charge state
; ------------------------------------------------------------------------------

ChargeState:
	lea	obj.anim(a6),a0					; Set charge animation
	lea	Anim_RingGirlBoss(pc),a1
	moveq	#4,d0
	jsr	SetAnimation
	
	move.l	#.Charge,obj.update(a6)				; Start charging

; ------------------------------------------------------------------------------

.Charge:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	SetHitboxSize					; Set hitbox size

	bsr.w	HazardObject					; Hazard object

	cmpi.w	#9,obj.anim+anim.frame(a6)			; Are we now using the flying frames?
	bcs.s	.Draw						; If not, branch

	jsr	MoveObject					; Move
	addi.w	#$38,obj.y_speed(a6)				; Apply gravity

	tst.w	obj.y_speed(a6)					; Are we falling?
	bmi.s	.CheckX						; If not, branch

	move.w	obj.collide_height(a6),-(sp)			; Check floor collision
	move.w	#27,obj.collide_height(a6)
	jsr	ObjMapCollideDownWide
	move.w	(sp)+,obj.collide_height(a6)
	tst.w	d1
	bpl.s	.CheckX						; If there was no collision, branch
	
	add.w	d1,obj.y(a6)					; Align with floor
	clr.w	obj.y_speed(a6)					; Stop moving downwards
	
.CheckX:
	tst.w	obj.x_speed(a6)					; Are we moving left?
	bpl.s	.CheckRight					; If not, branch

	move.w	obj.collide_width(a6),d0			; Have we hit the left wall?
	cmp.w	obj.x(a6),d0
	bge.s	.Rebound					; If so, branch
	bra.s	.Draw

.CheckRight:
	move.w	obj.collide_width(a6),d0			; Have we hit the right wall?
	neg.w	d0
	addi.w	#320,d0
	cmp.w	obj.x(a6),d0
	bgt.s	.Draw						; If not, branch

.Rebound:
	lea	Sfx_Thump,a0					; Play thump sound
	jsr	PlaySfx

	neg.w	obj.x_speed(a6)					; Rebound
	asr.w	obj.x_speed(a6)
	move.w	#-$380,obj.y_speed(a6)
	move.l	#ReboundState,obj.update(a6)

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Rebound state
; ------------------------------------------------------------------------------

ReboundState:
	lea	obj.anim(a6),a0					; Set rebound animation
	lea	Anim_RingGirlBoss(pc),a1
	moveq	#5,d0
	jsr	SetAnimation

	move.l	#.Rebound,obj.update(a6)			; Start rebound
	st	obj.flags+1(a6)					; Enable being hit

; ------------------------------------------------------------------------------

.Rebound:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	SetHitboxSize					; Set hitbox size

	jsr	MoveObject					; Move
	addi.w	#$38,obj.y_speed(a6)				; Apply gravity

	tst.w	obj.y_speed(a6)					; Are we falling?
	bmi.s	.Draw						; If not, branch

	jsr	ObjMapCollideDownWide				; Check floor collision
	tst.w	d1
	bpl.s	.Draw						; If there was no collision, branch

	add.w	d1,obj.y(a6)					; Align with floor
	clr.l	obj.x_speed(a6)					; Stop moving
	
	move.l	#RecoverState,obj.update(a6)			; Recover

.Draw:
	jmp	DrawObject					; Draw

; ------------------------------------------------------------------------------
; Recover state
; ------------------------------------------------------------------------------

RecoverState:
	lea	obj.anim(a6),a0					; Set breathing animation
	lea	Anim_RingGirlBoss(pc),a1
	moveq	#0,d0
	jsr	SetAnimation

	move.w	#120,ring_girl.timer(a6)			; Set timer
	move.l	#.Recover,obj.update(a6)			; Start recovery

; ------------------------------------------------------------------------------

.Recover:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	SetHitboxSize					; Set hitbox size

	bsr.s	CheckHit					; Check if we have been hit

	tst.b	ring_girl.flash(a6)				; Are we flashing?
	bne.s	.Draw						; If so, branch
	subq.w	#1,ring_girl.timer(a6)				; Decrement timer
	beq.s	.PreCharge					; If it has run out, branch

.Draw:
	jmp	CheckFlashDraw					; Draw

.PreCharge:
	clr.b	obj.flags+1(a6)					; Disable being hit
	
	move.l	#PreChargeState,obj.update(a6)			; Prepare to charge
	bra.s	.Draw

; ------------------------------------------------------------------------------
; Defeated state
; ------------------------------------------------------------------------------

DefeatedState:
	subq.w	#1,ring_girl.timer(a6)				; Decrement timer
	beq.s	.Done						; If it has run out, branch

	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bsr.w	SetHitboxSize					; Set hitbox size

	jmp	DrawObject					; Draw sprite

.Done:
	st	boss_end					; End of boss
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Check if we are hit by the player
; ------------------------------------------------------------------------------

CheckHit:
	tst.b	obj.flags+1(a6)					; Can we be hit?
	beq.w	.End						; If not, branch

	bsr.w	BossObjectNoHazard				; Have we been hit?
	bne.s	.End						; If not, branch
	
	lea	Sfx_HitBoss,a0					; Play hit boss sound
	jsr	PlaySfx

	clr.b	obj.flags+1(a6)					; Cannot be hit again

	subq.b	#1,ring_girl.hit_count(a6)			; Decrement hit count
	bne.s	.NotDefeated					; If we haven't been defeated, branch

	jsr	StopSound					; Stop all sound
	move.w	#$FF14,MARS_COMM_12+MARS_SYS			; Play defeated sound

	lea	obj.anim(a6),a0					; Set death animation
	lea	Anim_RingGirlBoss(pc),a1
	moveq	#7,d0
	jsr	SetAnimation

	move.l	#DefeatedState,obj.update(a6)			; Set defeated state
	move.l	#DefeatedState,(sp)
	move.w	#120,ring_girl.timer(a6)
	rts

.NotDefeated:
	bclr	#OBJ_FLIP_X,obj.flags(a6)			; Face the player
	move.w	obj.x(a1),d1
	cmp.w	obj.x(a6),d1
	blt.s	.SetHitAnimation
	bset	#OBJ_FLIP_X,obj.flags(a6)
	
.SetHitAnimation:
	lea	obj.anim(a6),a0					; Set hit animation
	lea	Anim_RingGirlBoss(pc),a1
	moveq	#6,d0
	jsr	SetAnimation

	move.w	#$FF13,MARS_COMM_12+MARS_SYS			; Play hit sound
	move.b	#60,ring_girl.flash(a6)				; Start flashing

.End:
	rts

; ------------------------------------------------------------------------------
; Flash and check for drawing
; ------------------------------------------------------------------------------

CheckFlashDraw:
	tst.b	ring_girl.flash(a6)				; Are we flashing?
	beq.s	.Draw						; If not, branch
	
	subq.b	#1,ring_girl.flash(a6)				; Decrement flash timer
	beq.s	.Recover					; If it has run out, branch
	btst	#2,ring_girl.flash(a6)				; Should we draw on this frame?
	beq.s	.End						; If not, branch

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------

.Recover:
	cmpi.w	#30,ring_girl.timer(a6)				; Should we decrease the recovery timer?
	bcs.s	.End						; If not, branch
	move.w	#30,ring_girl.timer(a6)				; Decrease the recovery timer

.End:
	rts

; ------------------------------------------------------------------------------
; Set hitbox size
; ------------------------------------------------------------------------------

SetHitboxSize:
	move.w	obj.collide_height(a6),d0			; Get previous hitbox height

	move.w	obj.anim+anim.frame(a6),d1			; Get frame
	add.w	d1,d1
	add.w	d1,d1

	move.w	.Sizes(pc,d1.w),obj.collide_width(a6)		; Set hitbox size
	move.w	.Sizes+2(pc,d1.w),obj.collide_height(a6)

	cmpi.w	#10*4,d1					; Are we charging?
	bcs.s	.AdjustY					; If not, branch
	cmpi.w	#14*4,d1
	bls.s	.End						; If so, branch

.AdjustY:
	sub.w	obj.collide_height(a6),d0			; Adjust Y position
	add.w	d0,obj.y(a6)

.End:
	rts

; ------------------------------------------------------------------------------

.Sizes:
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 27
	dc.w	10, 27
	dc.w	10, 27
	dc.w	10, 27
	dc.w	32, 8
	dc.w	32, 8
	dc.w	32, 8
	dc.w	32, 27
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 36
	dc.w	10, 36

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

Anim_RingGirlBoss:
	dc.w	.Breathe-Anim_RingGirlBoss
	dc.w	.PreChargeStart-Anim_RingGirlBoss
	dc.w	.PreCharge-Anim_RingGirlBoss
	dc.w	.PreChargeTurn-Anim_RingGirlBoss
	dc.w	.Charge-Anim_RingGirlBoss
	dc.w	.Rebound-Anim_RingGirlBoss
	dc.w	.Hit-Anim_RingGirlBoss
	dc.w	.Die-Anim_RingGirlBoss

.Breathe:
	ANIM_START $20, ANIM_RESTART
	dc.w	0, 1, 1, 1, 1, 2, 3, 4, 4, 4, 4, 3, 2
	ANIM_END

.PreChargeStart:
	ANIM_START $40, ANIM_SWITCH, 2
	dc.w	0, 0, 0, 5, 6, 7, 7, 7
	ANIM_END

.PreCharge:
	ANIM_START $40, ANIM_RESTART
	dc.w	7
	ANIM_END

.PreChargeTurn:
	ANIM_START $70, ANIM_SWITCH, 2
	dc.w	8
	ANIM_END

.Charge:
	ANIM_START $40, ANIM_LOOP_POINT, 1
	dc.w	9, 10, 11, 12
	ANIM_END

.Rebound:
	ANIM_START $20, ANIM_RESTART
	dc.w	13
	ANIM_END

.Hit:
	ANIM_START $60, ANIM_SWITCH, 0
	dc.w	14, 15, 16, 16, 16, 16, 15, 14
	ANIM_END

.Die:
	ANIM_START $80, ANIM_RESTART
	dc.w	17, 18, 22
	dc.w	17, 21, 19
	dc.w	20, 18, 22
	dc.w	17, 21, 19
	ANIM_END

; ------------------------------------------------------------------------------
; Couch initialization state
; ------------------------------------------------------------------------------

ObjCouch:
	move.w	#104,obj.collide_width(a6)			; Set hitbox size
	move.w	#4,obj.collide_height(a6)

	move.w	#160,obj.x(a6)					; Set position
	move.w	#112,obj.y(a6)
	
	move.l	#CouchState,obj.update(a6)			; Set state

; ------------------------------------------------------------------------------
; Couch update state
; ------------------------------------------------------------------------------

CouchState:
	movea.w	player_object,a1				; Is the player jumping?
	btst	#SONIC_JUMP,obj.flags(a1)
	beq.s	.AllowBounce					; If not, branch
	
	tst.w	obj.y_speed(a1)					; Is the player falling?
	beq.s	.End						; If not, branch
	bmi.s	.End						; If not, branch

	move.w	obj.y(a6),d0					; Is the player above us?
	sub.w	obj.collide_height(a1),d0
	cmp.w	obj.y(a1),d0
	ble.s	.End						; If not, branch

	tst.b	obj.flags+1(a6)					; Should the player bounce off us?
	bne.s	.End						; If not, branch

	jsr	CheckObjectCollide				; Has the player collided with us?
	bne.s	.End						; If not, branch
	
	st	obj.flags+1(a6)					; Disallow bouncing until the player has landed on the floor

	move.w	a6,-(sp)					; Bounce the player
	movea.w	a1,a6
	jsr	SetSonicPlayerAirborne
	movea.w	(sp)+,a6
	move.w	#-$580,obj.y_speed(a1)
	
	lea	Sfx_Bounce,a0					; Play bounce sound
	jmp	PlaySfx

.AllowBounce:
	clr.b	obj.flags+1(a6)					; Allow bouncing

.End:
	rts

; ------------------------------------------------------------------------------
