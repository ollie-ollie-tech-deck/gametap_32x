; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ben Drowned boss object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjBenBoss:
	lea	blood_particles,a0				; Initialize blood particles
	move.w	#BLOOD_PARTICLE_COUNT,d1
	bsr.w	InitParticles

	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer

	move.w	#16,obj.collide_width(a6)			; Set hitbox size
	move.w	#16,obj.collide_height(a6)
	
	move.w	#128,obj.draw_width(a6)				; Set draw size
	move.w	#128,obj.draw_height(a6)

	move.w	#262,obj.x(a6)					; Set position
	move.w	#120,obj.y(a6)
	
	move.b	#6,ben_boss.hit_count(a6)			; Set hit count
	move.b	#3,ben_boss.attack_count(a6)			; Set attack count
	
	bsr.w	SpawnObject					; Spawn hurt box
	move.l	#ObjHurtBox,obj.update(a1)
	move.w	obj.x(a6),obj.x(a1)
	move.w	obj.y(a6),d0
	addi.w	#32,d0
	move.w	d0,obj.y(a1)
	move.w	a1,ben_boss.hurt_box(a6)
	
	lea	obj.anim(a6),a0					; Set animation
	lea	Anim_BenBoss(pc),a1
	moveq	#0,d0
	jsr	SetAnimation

	move.l	#EarthquakeState,obj.update(a6)			; Set earthquake state
	move.w	#60+75,ben_boss.timer(a6)
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Earthquake state
; ------------------------------------------------------------------------------

EarthquakeState:
	bsr.w	HazardObject					; Hazard object
	bne.s	.NotHit						; If the player was not hit, branch
	move.w	#-$300,obj.x_speed(a1)				; Force the player to go to the left

.NotHit:
	bsr.w	AttackPlayerNearby				; Attack the player if nearby
	bsr.w	HandleEarthquake				; Handle earthquake

	lea	.StopTimes(pc),a1				; Should the vein move?
	moveq	#0,d1
	move.b	ben_boss.hit_count(a6),d1
	add.w	d1,d1
	move.w	(a1,d1.w),d1
	cmp.w	ben_boss.timer(a6),d1
	bgt.s	.Earthquake					; If not, branch

	movea.w	player_object,a1				; Get player

	cmpi.w	#60,ben_boss.timer(a6)				; Is the arrow visible?
	ble.s	.GradualMove					; If so, branch

	move.w	obj.x(a1),ben_boss.vein_x(a6)			; Snap vein to player's position
	clr.w	ben_boss.vein_x+2(a6)
	bra.s	.Draw

.GradualMove:
	move.w	obj.x(a1),d0					; Get speed to move vein towards player
	sub.w	ben_boss.vein_x(a6),d0
	ext.l	d0
	asl.l	#8,d0
	asl.l	#3,d0
	move.l	d0,d1
	add.l	d0,d0
	add.l	d1,d0

	moveq	#0,d1						; Get max speed
	move.b	ben_boss.hit_count(a6),d1
	add.w	d1,d1
	add.w	d1,d1
	move.l	.MaxSpeeds(pc,d1.w),d1

	cmp.l	d1,d0						; Is it too large for moving left?
	bge.s	.CheckRightMax					; If not, branch
	move.l	d1,d0						; Cap the speed

.CheckRightMax:
	neg.l	d1						; Is it too large for moving right?
	cmp.l	d1,d0
	ble.s	.MoveVein					; If not, branch
	move.l	d1,d0						; Cap the speed

.MoveVein:
	add.l	d0,ben_boss.vein_x(a6)				; Apply speed to vein position

	cmpi.w	#32,ben_boss.vein_x(a6)				; Is the vein at the far left side?
	bge.s	.CheckRight					; If not, branch
	move.w	#32,ben_boss.vein_x(a6)				; Stop moving vein

.CheckRight:
	cmpi.w	#176,ben_boss.vein_x(a6)			; Is the vein at the far right side?
	ble.s	.Earthquake					; If not, branch
	move.w	#176,ben_boss.vein_x(a6)			; Stop moving vein

.Earthquake:
	tst.w	ben_boss.timer(a6)				; Are we done with the earthquake?
	beq.s	.SpawnVein					; If so, branch

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------

.StopTimes:
	dc.w	10, 10, 14, 18, 22, 26, 30

.MaxSpeeds:
	dc.l	-$4C000, -$4C000, -$40000, -$34000, -$28000, -$1C000, -$10000

; ------------------------------------------------------------------------------

.SpawnVein:
	clr.w	camera_fg_y_shake				; Stop shaking screen
	clr.w	camera_bg_y_shake

	bsr.w	SpawnObject					; Spawn vein
	move.l	#ObjVein,obj.update(a1)
	move.w	ben_boss.vein_x(a6),obj.x(a1)
	move.w	#-$600,obj.y_speed(a1)
	move.w	#216,vein.target_y(a1)
	move.w	a6,vein.parent(a1)
	move.w	a1,ben_boss.attack_vein(a6)

	lea	Sfx_Collapse,a0					; Play burst out sound
	jsr	PlaySfx
	
	move.l	#WaitVeinState,obj.update(a6)			; Wait for vein

; ------------------------------------------------------------------------------
; Wait for vein state
; ------------------------------------------------------------------------------

WaitVeinState:
	bsr.w	HazardObject					; Hazard object
	bne.s	.NotHit						; If the player was not hit, branch
	move.w	#-$300,obj.x_speed(a1)				; Force the player to go to the left

.NotHit:
	bsr.w	AttackPlayerNearby				; Attack the player if nearby

	tst.w	ben_boss.attack_vein(a6)			; Has the vein despawned?
	beq.s	.CheckNextPhase					; If so, branch

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite
	
; ------------------------------------------------------------------------------

.CheckNextPhase:
	subq.b	#1,ben_boss.attack_count(a6)			; Decrement attack count
	beq.s	.NextPhase					; If there's no more attacks to do, branch
	
	move.l	#EarthquakeState,obj.update(a6)			; Set earthquake state
	move.w	#60+75,ben_boss.timer(a6)
	bra.s	.Draw

.NextPhase:
	move.l	#WaitDefendVeinState,obj.update(a6)		; Wait for defensive vein

; ------------------------------------------------------------------------------
; Wait for defensive vein state
; ------------------------------------------------------------------------------

WaitDefendVeinState:
	bsr.w	HazardObject					; Hazard object
	bne.s	.NotHit						; If the player was not hit, branch
	move.w	#-$300,obj.x_speed(a1)				; Force the player to go to the left

.NotHit:
	tst.w	ben_boss.defend_vein(a6)			; Are we defending ourselves?
	bne.s	.Draw						; If so, branch

	bsr.w	SpawnObject					; Spawn stuck vein
	move.l	#ObjStuckVein,obj.update(a1)
	move.w	a6,vein.parent(a1)
	move.w	a1,ben_boss.attack_vein(a6)
	
	movea.w	ben_boss.hurt_box(a6),a1			; Disable hurt box
	st	obj.flags+1(a1)

	move.l	#WaitStuckVeinState,obj.update(a6)		; Wait for stuck vein

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Wait for stuck vein state
; ------------------------------------------------------------------------------

WaitStuckVeinState:
	bsr.w	BossObject					; Have we been hit?
	bne.s	.CheckStuckVein					; If not, branch
	
	lea	Sfx_HitBoss,a0					; Play hit boss sound
	jsr	PlaySfx

	move.w	#$FF1F,MARS_COMM_12+MARS_SYS			; Play scream sound
	
	move.w	#-$600,obj.x_speed(a1)				; Force the player to go left
	bset	#SONIC_LOCK,obj.flags(a1)
	clr.w	player.ctrl_hold(a1)
	
	move.w	a6,-(sp)					; Move stuck vein out
	movea.w	ben_boss.attack_vein(a6),a6
	move.l	#StuckVeinMoveOutState2,obj.update(a6)
	bsr.w	MoveStuckVeinOut
	movea.w	(sp)+,a6
	
	lea	obj.anim(a6),a0					; Set hit animation
	lea	Anim_BenBoss(pc),a1
	moveq	#1,d0
	jsr	SetAnimation
	
	move.l	#HitState,obj.update(a6)			; Set hit state
	move.w	#60,ben_boss.timer(a6)
	
	subq.b	#1,ben_boss.hit_count(a6)			; Decrement hit count
	bne.s	.Draw						; If we haven't been defeated, branch
	
	move.l	#DefeatedState,obj.update(a6)			; Set defeated state
	clr.w	ben_boss.timer(a6)
	move.w	#2,ben_boss.defeat_shake(a6)
	bra.s	.Draw
	
.CheckStuckVein:
	tst.w	ben_boss.attack_vein(a6)			; Has the vein despawned?
	bne.s	.Draw						; If not, branch
	
	movea.w	ben_boss.hurt_box(a6),a1			; Enable hurt box
	clr.b	obj.flags+1(a1)

	move.b	#3,ben_boss.attack_count(a6)			; Reset attack count
	move.l	#EarthquakeState,obj.update(a6)			; Set earthquake state
	move.w	#60+75,ben_boss.timer(a6)

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite
	
; ------------------------------------------------------------------------------
; Hit state
; ------------------------------------------------------------------------------

HitState:
	bsr.w	HandleEarthquake				; Handle earthquake
	tst.w	ben_boss.timer(a6)				; Are we done?
	beq.s	.Done						; If so, branch

.Draw:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------

.Done:
	lea	obj.anim(a6),a0					; Set regular animation
	lea	Anim_BenBoss(pc),a1
	moveq	#0,d0
	jsr	SetAnimation
	
	movea.w	player_object,a1				; Unlock player's control
	bclr	#SONIC_LOCK,obj.flags(a1)
	
	movea.w	ben_boss.hurt_box(a6),a1			; Enable hurt box
	clr.b	obj.flags+1(a1)

	move.l	#WaitStuckVeinState,obj.update(a6)		; Wait for stuck vein
	bra.s	.Draw

; ------------------------------------------------------------------------------
; Defeated state
; ------------------------------------------------------------------------------

DefeatedState:
	movea.w	player_object,a1				; Has the player stopped moving?
	tst.w	obj.x_speed(a1)
	bne.w	.Update						; If not, branch
	
	cmpi.w	#90,ben_boss.timer(a6)				; Has enough time passed?
	bcs.w	.Update						; If not, branch
	
	move.l	#.MoveRight,obj.update(a6)			; Start moving right
	move.b	#BUTTON_RIGHT,player.ctrl_hold(a1)

; ------------------------------------------------------------------------------

.MoveRight:
	movea.w	player_object,a1				; Should the player jump?
	cmpi.w	#200,obj.x(a1)
	blt.w	.Update						; If not, branch

	ori.w	#(BUTTON_A<<8)|BUTTON_A,player.ctrl_hold(a1)	; Make the player jump
	move.l	#.WaitHit,obj.update(a6)			; Wait until we are hit
	
; ------------------------------------------------------------------------------

.WaitHit:
	movea.w	player_object,a1				; Check collision with player
	bsr.w	CheckObjectCollide
	bne.s	.Update						; If there was none, branch

	move.l	#.Saw,obj.update(a6)				; Set saw state
	move.w	#8,ben_boss.defeat_shake(a6)
	
	bsr.w	FadeSound					; Fade sound out
	move.w	#$FF1E,MARS_COMM_12+MARS_SYS			; Play tear sound
	
	move.l	#PlayerSawState,obj.update(a1)			; Make the player saw through us
	SET_OBJECT_LAYER move.w,1,obj.layer(a1)			; Set layer
	
; ------------------------------------------------------------------------------

.Saw:
	moveq	#3-1,d7						; Number of particles to spawn
	
.SpawnBlood:
	lea	blood_particles,a0				; Spawn blood particle
	bsr.w	AddListItem
	bne.s	.UpdateBlood					; If it failed to spawn branch
	
	move.w	obj.x(a6),d0					; Set blood particle position
	addq.w	#8,d0
	move.w	d0,particle.x(a1)
	move.w	obj.y(a6),particle.y(a1)
	
	bsr.w	Random						; Set blood particle trajectory
	andi.w	#$3F,d0
	addi.w	#$60,d0
	bsr.w	CalcSine
	asl.w	#3,d0
	asl.w	#3,d1
	move.w	d1,particle.x_speed(a1)
	move.w	d0,particle.y_speed(a1)
	
	move.w	#8,particle.y_accel(a1)				; Set blood particle gravity

	dbf	d7,.SpawnBlood					; Loop until finished

.UpdateBlood:
	lea	blood_particles,a1				; Update blood particles
	bsr.w	UpdateParticles

; ------------------------------------------------------------------------------

.Update:
	bsr.s	.Earthquake					; Handle earthquake
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite
	
.Done:
	clr.w	camera_fg_y_shake				; Stop shaking screen
	clr.w	camera_bg_y_shake
	
	bra.w	DeleteObject					; Delete ourselves
	
; ------------------------------------------------------------------------------

.Earthquake:
	addq.w	#1,ben_boss.timer(a6)				; Update timer
	andi.w	#$7F,ben_boss.timer(a6)

	btst	#0,ben_boss.timer+1(a6)				; Should we perform the shake?
	bne.s	.End						; If not, branch
	
	move.w	ben_boss.defeat_shake(a6),d0			; Shake screen violently
	eor.w	d0,camera_fg_y_shake
	eor.w	d0,camera_bg_y_shake
	
.End:
	rts

; ------------------------------------------------------------------------------
; Player saw state
; ------------------------------------------------------------------------------

PlayerSawState:
	cmpi.w	#266,obj.x(a6)					; Are we done moving?
	bcc.s	.End						; If so, branch
	addi.l	#$2000,obj.x(a6)				; Move right

	addq.b	#1,player.frame(a6)				; Animate sprite
	andi.b	#7,player.frame(a6)
	bra.w	DrawObject					; Draw sprite

.End:
	st	ben_tear_screen					; Go to Ben tear screen
	rts

; ------------------------------------------------------------------------------
; Handle earthquake
; ------------------------------------------------------------------------------

HandleEarthquake:
	tst.w	ben_boss.timer(a6)				; Is the timer active?
	beq.s	.Done						; If not, branch
	subq.w	#1,ben_boss.timer(a6)				; Decrement timer
	beq.s	.Done						; If it has run out, branch

	cmpi.w	#75,ben_boss.timer(a6)				; Should we perform the shake?
	beq.s	.PlaySound					; If so, branch
	bgt.s	.End						; If not, branch
	bra.s	.CheckOffset

.PlaySound:
	lea	Sfx_Rumble,a0					; Play rumble sound
	jsr	PlaySfx

.CheckOffset:
	btst	#0,ben_boss.timer+1(a6)
	bne.s	.End						; If not, branch
	
	eori.w	#2,camera_fg_y_shake				; Shake screen
	eori.w	#2,camera_bg_y_shake
	rts

.Done:
	clr.w	camera_fg_y_shake				; Stop shaking screen
	clr.w	camera_bg_y_shake
	
.End:
	rts

; ------------------------------------------------------------------------------
; Check if the player is nearby while attacking
; ------------------------------------------------------------------------------

AttackPlayerNearby:
	tst.w	ben_boss.defend_vein(a6)			; Are we already defending ourselves?
	bne.s	.End						; If so, branch

	movea.w	player_object,a1				; Is the player nearby?
	cmpi.w	#160,obj.x(a1)
	blt.s	.End						; If not, branch
	
	bsr.w	SpawnObject					; Spawn vein
	move.l	#ObjVein,obj.update(a1)
	move.w	#208,obj.x(a1)
	move.w	#-$1400,obj.y_speed(a1)
	move.w	#144,vein.target_y(a1)
	move.w	a6,vein.parent(a1)
	move.w	a1,ben_boss.defend_vein(a6)
	
.End:
	rts

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	lea	mars_sprite_chain,a0				; Sprite chain buffer
	move.w	#3,(a0)+					; Set sprite count
	
	move.w	#$600,(a0)+					; Set overlay sprite 1
	move.w	#112,d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,(a0)+
	move.w	#208,d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,(a0)+
	
	move.w	#$700,(a0)+					; Set overlay sprite 2
	move.w	#304,d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,(a0)+
	move.w	#128,d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,(a0)+
	
	move.b	obj.anim+anim.frame+1(a6),(a0)+			; Set main sprite
	clr.b	(a0)+
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,(a0)+
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,(a0)+
	
	lea	blood_particles,a1				; Get first blood particle
	move.w	list.head(a1),d0
	beq.s	.CheckArrow					; If there are no blood particles, branch

.DrawBloodLoop:
	movea.w	d0,a1						; Set blood particle
	move.w	item.next(a1),-(sp)				; Get next blood particle

	movem.w	particle.x_speed(a1),d1-d2			; Set blood particle frame ID
	bsr.w	CalcAngle16
	subi.b	#$40,d0
	lsr.b	#4,d0
	addq.b	#8,d0
	move.b	d0,(a0)+

	clr.b	(a0)+						; Set blood particle sprite
	move.w	particle.x(a1),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,(a0)+
	move.w	particle.y(a1),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,(a0)+
	addq.w	#1,mars_sprite_chain

.NextBlood:
	move.w	(sp)+,d0					; Get next blood particle
	bne.s	.DrawBloodLoop					; Loop until finished

.CheckArrow:
	cmpi.l	#EarthquakeState,obj.update(a6)			; Is there an earthquake?
	bne.s	.Draw						; If not, branch

	cmpi.w	#60,ben_boss.timer(a6)				; Should we draw the arrow?
	bgt.s	.Draw						; If not, branch

	move.b	#3,(a0)+					; Draw arrow
	clr.b	(a0)+
	move.w	ben_boss.vein_x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,(a0)+
	move.w	#160,d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,(a0)+
	addq.w	#1,mars_sprite_chain

.Draw:
	clr.b	-(sp)						; Draw sprites
	pea	mars_sprite_chain
	bsr.w	DrawLoadedMarsSpriteChain
	rts

; ------------------------------------------------------------------------------
; Vein initialization state
; ------------------------------------------------------------------------------

ObjVein:
	SET_OBJECT_LAYER move.w,0,obj.layer(a6)			; Set layer
	
	move.w	#8,obj.collide_width(a6)			; Set hitbox size
	move.w	#104,obj.collide_height(a6)
	
	move.w	#16,obj.draw_width(a6)				; Set draw size
	move.w	#112,obj.draw_height(a6)
	
	move.w	#336,obj.y(a6)					; Set Y position
	
	move.l	#ObjVeinUpdate,obj.update(a6)			; Set state
	move.l	#DrawVein,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Vein update state
; ------------------------------------------------------------------------------

ObjVeinUpdate:
	movea.w	vein.parent(a6),a2				; Get parent object

	bsr.w	HazardObject					; Hazard object
	bsr.w	MoveObject					; Move
	
	tst.w	obj.y_speed(a6)					; Are we moving down?
	bmi.s	.MoveUp						; If not, branch

; ------------------------------------------------------------------------------

.MoveDown:
	cmpa.w	ben_boss.defend_vein(a2),a6			; Are we the defensive vein?
	bne.s	.NotDefend					; If not, branch
	tst.w	obj.y_speed(a6)					; Have we already started moving down?
	bne.s	.NotDefend					; If so, branch
	
	cmpi.w	#160,obj.x(a1)					; Is the player nearby?
	bge.s	.NotDefend					; If so, branch
	move.w	#$1400,obj.y_speed(a6)				; Start moving down

.NotDefend:
	cmpi.w	#336,obj.y(a6)					; Have we moved down enough?
	blt.s	.Draw						; If not, branch
	
	cmpa.w	ben_boss.attack_vein(a2),a6			; Are we the attacking vein?
	bne.s	.CheckDefend					; If not, branch
	clr.w	ben_boss.attack_vein(a2)			; Unset attacking vein

.CheckDefend:
	cmpa.w	ben_boss.defend_vein(a2),a6			; Are we the defensive vein?
	bne.s	.Delete						; If not, branch
	clr.w	ben_boss.defend_vein(a2)			; Unset defensive vein
	
.Delete:
	bra.w	DeleteObject

; ------------------------------------------------------------------------------

.MoveUp:
	move.w	vein.target_y(a6),d0				; Have we moved up enough?
	cmp.w	obj.y(a6),d0
	blt.s	.Draw						; If not, branch
	
	move.w	d0,obj.y(a6)					; Set to target Y position
	neg.w	obj.y_speed(a6)					; Start moving down
	
	cmpa.w	ben_boss.defend_vein(a2),a6			; Are we the defensive vein?
	bne.s	.Draw						; If not, branch
	clr.w	obj.y_speed(a6)					; Stop moving

.Draw:
	bra.w	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Draw vein sprite
; ------------------------------------------------------------------------------

DrawVein:
	clr.b	-(sp)						; Draw sprite
	move.b	#4,-(sp)
	clr.b	-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite
	rts

; ------------------------------------------------------------------------------
; Stuck vein initialization state
; ------------------------------------------------------------------------------

ObjStuckVein:
	SET_OBJECT_LAYER move.w,0,obj.layer(a6)			; Set layer

	move.w	#112,obj.draw_width(a6)				; Set draw size
	move.w	#48,obj.draw_height(a6)
	
	move.w	#432,obj.x(a6)					; Set position
	move.w	#88,obj.y(a6)
	
	moveq	#$74,d0						; Set speed
	bsr.w	CalcSine
	asl.w	#4,d1
	move.w	d1,obj.x_speed(a6)
	asl.w	#4,d0
	move.w	d0,obj.y_speed(a6)
	
	move.l	#StuckVeinMoveInState,obj.update(a6)		; Set state
	move.l	#DrawStuckVein,obj.draw(a6)			; Set draw routine

; ------------------------------------------------------------------------------
; Stuck vein move in state
; ------------------------------------------------------------------------------

StuckVeinMoveInState:
	bsr.w	MoveObject					; Move
	cmpi.w	#160,obj.x(a6)					; Have we moved enough?
	ble.s	.Earthquake					; If so, branch
	bra.w	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------

.Earthquake:
	lea	Sfx_Thump,a0					; Play thump sound
	jsr	PlaySfx

	clr.l	obj.x_speed(a6)					; Stop moving
	move.l	#StuckVeinEarthquakeState,obj.update(a6)	; Set earthquake state
	move.w	#15,vein.timer(a6)

; ------------------------------------------------------------------------------
; Stuck vein move in earthquake state
; ------------------------------------------------------------------------------

StuckVeinEarthquakeState:
	bsr.w	HandleEarthquake				; Handle earthquake
	tst.w	vein.timer(a6)					; Are we done with the earthquake?
	beq.s	.Wiggle						; If so, branch
	
	bra.w	DrawObject					; Draw sprite
	
.Wiggle:
	move.l	#StuckVeinWiggleState,obj.update(a6)		; Set wiggle state
	move.b	#3,vein.wiggle_count(a6)
	move.w	#90,vein.timer(a6)

; ------------------------------------------------------------------------------
; Stuck vein wiggle out state
; ------------------------------------------------------------------------------

StuckVeinWiggleState:
	subq.w	#1,vein.timer(a6)				; Decrement timer
	beq.s	.CheckMoveOut					; If it has run out, branch

	cmpi.w	#30,vein.timer(a6)				; Should we perform the wiggle?
	blt.s	.DoWiggle					; If so, branch
	bne.s	.Draw						; If not, branch

	lea	Sfx_Wiggle,a0					; Play wiggle sound
	jsr	PlaySfx

.DoWiggle:
	btst	#0,vein.timer+1(a6)				; Should we apply the wiggle offset?
	bne.s	.Draw						; If not, branch
	
	eori.w	#2,obj.x(a6)					; Wiggle

.Draw:	
	bra.w	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------

.CheckMoveOut:
	subq.b	#1,vein.wiggle_count(a6)			; Decrement wiggle count
	beq.s	.MoveOut					; If we are done, branch

	move.w	#90,ben_boss.timer(a6)				; Wiggle again
	bra.s	.Draw

.MoveOut:
	lea	Sfx_Thump,a0					; Play thump sound
	jsr	PlaySfx

	move.l	#StuckVeinMoveOutState,obj.update(a6)		; Start moving out
	move.w	#30,ben_boss.timer(a6)
	bsr.w	DrawObject

; ------------------------------------------------------------------------------

MoveStuckVeinOut:
	moveq	#$74,d0						; Set speed
	bsr.w	CalcSine
	neg.w	d1
	asl.w	#4,d1
	move.w	d1,obj.x_speed(a6)
	neg.w	d0
	asl.w	#4,d0
	move.w	d0,obj.y_speed(a6)
	rts

; ------------------------------------------------------------------------------
; Stuck vein move in state
; ------------------------------------------------------------------------------

StuckVeinMoveOutState:
	bsr.w	HandleEarthquake				; Handle earthquake

StuckVeinMoveOutState2:
	bsr.w	MoveObject					; Move
	cmpi.w	#432,obj.x(a6)					; Have we moved enough?
	bge.s	.Delete						; If so, branch
	bra.w	DrawObject					; Draw sprite

.Delete:
	movea.w	vein.parent(a6),a1				; Unset stuck vein
	clr.w	ben_boss.attack_vein(a1)
	bra.w	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Draw stuck vein sprites
; ------------------------------------------------------------------------------

DrawStuckVein:
	clr.b	-(sp)						; Draw sprite
	move.b	#5,-(sp)
	clr.b	-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	move.w	d0,-(sp)
	move.w	#$100,-(sp)
	move.w	#$100,-(sp)
	bsr.w	DrawLoadedMarsSprite
	rts
	
; ------------------------------------------------------------------------------
; Hurt box object
; ------------------------------------------------------------------------------

ObjHurtBox:
	move.w	#32,obj.collide_width(a6)			; Set hitbox size
	move.w	#32,obj.collide_height(a6)
	
	move.l	#.Update,obj.update(a6)				; Set state
	
; ------------------------------------------------------------------------------

.Update:
	tst.b	obj.flags+1(a6)					; Are we disabled?
	bne.s	.End						; If so, branch

	bsr.w	HazardObject					; Hazard object
	bne.s	.End						; If the player was not hit, branch
	move.w	#-$300,obj.x_speed(a1)				; Force the player to go to the left

.End:
	rts

; ------------------------------------------------------------------------------
; Animations
; ------------------------------------------------------------------------------

Anim_BenBoss:
	dc.w	.HeartBeat-Anim_BenBoss
	dc.w	.HeartBeatHit-Anim_BenBoss

.HeartBeat:
	ANIM_START $28, ANIM_RESTART
	dc.w	0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 1
	ANIM_END

.HeartBeatHit:
	ANIM_START $80, ANIM_RESTART
	dc.w	0, 1, 2, 2, 1
	ANIM_END

; ------------------------------------------------------------------------------
