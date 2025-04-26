; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Monitor object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/sonic/shared.inc"
	
; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjMonitor:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer
	
	move.w	#14,obj.collide_width(a6)			; Set hitbox size
	move.w	#16,obj.collide_height(a6)
	
	move.w	#16,obj.draw_width(a6)				; Set draw size
	move.w	#16,obj.draw_height(a6)
	
	move.l	#GroundState,obj.update(a6)			; Set ground state
	move.l	#Draw,obj.draw(a6)				; Set draw routine
	
	bsr.w	GetObjectState					; Is this monitor broken?
	bne.s	.SpawnIcon					; If not, branch
	move.w	(a0),d0
	andi.w	#$7FFF,d0
	beq.s	.SpawnIcon					; If not, branch
	
	move.l	#BrokenState,obj.update(a6)			; Set broken state
	move.w	d0,obj.y(a6)
	bra.w	BrokenState
	
.SpawnIcon:
	bsr.w	SpawnObject					; Spawn icon
	bne.s	.NoIcon						; If it failed, branch
	
	move.l	#ObjMonitorIcon,obj.update(a1)			; Setup icon
	move.w	a1,monitor.icon(a6)
	move.w	a6,monitor_icon.parent(a1)
	move.b	obj.subtype(a6),obj.subtype(a1)
	
	bra.s	GroundState					; Handle ground state
	
.NoIcon:
	bra.w	DeleteObject					; Delete ourseives

; ------------------------------------------------------------------------------
; Ground state
; ------------------------------------------------------------------------------

GroundState:
	bsr.s	CheckCollision					; Check collision

GroundState2:
	moveq	#OBJ_FULL_SOLID,d0				; Make solid
	bsr.w	SolidObject

	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Fall state
; ------------------------------------------------------------------------------

FallState:
	bsr.s	CheckCollision					; Check collision
	
	tst.w	obj.y_speed(a6)					; Are we moving downwards?
	bmi.s	.CheckCeiling					; If not, branch

	bsr.w	ObjMapCollideDownWide				; Check floor collision
	tst.w	d1
	bpl.s	FallState2					; If there was no collision, branch
	
	add.w	d1,obj.y(a6)					; Align with floor
	clr.w	obj.y_speed(a6)					; Stop moving downwards
	
	move.l	#GroundState,obj.update(a6)			; Set ground state
	bra.s	GroundState2
	
.CheckCeiling:
	bsr.w	ObjMapCollideUpWide				; Check ceiling collision
	tst.w	d1
	bpl.s	FallState2					; If there was no collision, branch	
	
	add.w	d1,obj.y(a6)					; Align with ceiling
	clr.w	obj.y_speed(a6)					; Stop moving upwards
	
FallState2:
	bsr.w	MoveObject					; Apply speed
	addi.w	#$38,obj.y_speed(a6)

	moveq	#OBJ_FULL_SOLID,d0				; Make solid
	bsr.w	SolidObject

	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Check for collision
; ------------------------------------------------------------------------------

CheckCollision:
	cmpa.w	solid_object_bottom,a6				; Were we touched from the bottom?
	bne.s	.CheckBreak					; If not, branch
	
	move.w	#-$180,obj.y_speed(a6)				; Bounce up
	
	move.l	#FallState,obj.update(a6)			; Set fall state
	bra.w	FallState2

.CheckBreak:
	movea.w	player_object,a1				; Player object
	tst.w	obj.y_speed(a1)					; Are they moving downwards?
	bmi.s	.Solid						; If not, branch
	
	btst	#SONIC_ROLL,obj.flags(a1)			; Are they rolling?
	beq.s	.Solid						; If not, branch
	
	bsr.w	CheckObjectCollide				; Check collision with the player
	bne.s	.End						; If there was none, branch

	btst	#SONIC_AIR,obj.flags(a1)			; Are they in the air?
	beq.s	.Break						; If not, branch

	neg.w	obj.y_speed(a1)					; Bounce the player up
	move.w	#-$180,obj.y_speed(a6)				; Bounce ourselves up

.Break:
	bsr.w	SpawnObject					; Spawn explosion
	bne.s	.NoExplosion					; If it failed, branch
	
	move.l	#ObjMonitorExplosion,obj.update(a1)		; Setup explosion
	move.w	obj.x(a6),obj.x(a1)
	move.w	obj.y(a6),obj.y(a1)
	move.w	obj.y_speed(a6),obj.y_speed(a1)
	
.NoExplosion:
	move.l	#BrokenState,obj.update(a6)			; Set broken state
	bsr.w	GetObjectState
	bne.s	.SetBroken
	move.w	obj.y(a6),d0
	or.w	d0,(a0)
	
	movea.w	monitor.icon(a6),a1				; Move the icon upwards
	move.l	#IconMoveState,obj.update(a1)
	move.w	#-$300,obj.y_speed(a1)

.SetBroken:
	move.l	#BrokenState2,(sp)				; Go to broken state
	
.End:
	rts

.Solid:
	moveq	#OBJ_FULL_SOLID,d0				; Make solid
	bra.w	SolidObject

; ------------------------------------------------------------------------------
; Broken state
; ------------------------------------------------------------------------------

BrokenState:
	tst.w	obj.y_speed(a6)					; Are we moving downwards?
	bmi.s	.CheckCeiling					; If not, branch

	bsr.w	ObjMapCollideDownWide				; Check floor collision
	tst.w	d1
	bpl.s	BrokenState2					; If there was no collision, branch
	
	add.w	d1,obj.y(a6)					; Align with floor
	clr.w	obj.y_speed(a6)					; Stop moving downwards
	
	move.l	#BrokenState3,obj.update(a6)			; Set ground state
	bra.s	BrokenState3
	
.CheckCeiling:
	bsr.w	ObjMapCollideUpWide				; Check ceiling collision
	tst.w	d1
	bpl.s	BrokenState2					; If there was no collision, branch
	
	add.w	d1,obj.y(a6)					; Align with ceiling
	clr.w	obj.y_speed(a6)					; Stop moving upwards
	
BrokenState2:
	bsr.w	MoveObject					; Apply speed
	addi.w	#$38,obj.y_speed(a6)

BrokenState3:
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	moveq	#0,d0						; Get base sprite
	cmpi.l	#BrokenState,obj.update(a6)
	bcs.s	.DrawBaseSprite
	moveq	#1,d0

.DrawBaseSprite:
	move.b	#1,-(sp)					; Draw sprite
	move.b	d0,-(sp)
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
; Icon initialization state
; ------------------------------------------------------------------------------

ObjMonitorIcon:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer
	
	move.w	#16,obj.draw_width(a6)				; Set draw size
	move.w	#16,obj.draw_height(a6)
	
	lea	obj.anim(a6),a0					; Set animation
	lea	Anim_MonitorIcon(pc),a1
	moveq	#0,d0
	move.b	obj.subtype(a6),d0
	jsr	SetAnimation
	
	move.l	#IconContainedState,obj.update(a6)		; Set state
	move.l	#DrawIcon,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Icon contained state
; ------------------------------------------------------------------------------

IconContainedState:
	movea.w	monitor_icon.parent(a6),a1			; Get parent monitor
	tst.w	item.list(a1)					; Is it gone?
	beq.s	.Delete						; If so, branch	
	
	move.w	obj.x(a1),obj.x(a6)				; Stay contained in monitor
	move.w	obj.y(a1),obj.y(a6)
	
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite

.Delete:
	bra.w	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Icon move state
; ------------------------------------------------------------------------------

IconMoveState:
	tst.w	obj.y_speed(a6)					; Should we stop?
	bmi.s	.NotDone					; If so, branch
	
	move.w	#$8805,MARS_COMM_12+MARS_SYS			; Play sound

	move.l	#IconWaitState,obj.update(a6)			; Set wait state
	move.w	#30,monitor_icon.timer(a6)
	bra.s	IconWaitState
	
.NotDone:
	bsr.w	MoveObject					; Apply speed
	addi.w	#$18,obj.y_speed(a6)				; Slow down

	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Icon wait state
; ------------------------------------------------------------------------------

IconWaitState:
	subq.w	#1,monitor_icon.timer(a6)			; Decrement timer
	bne.s	.NotDone					; If it hasn't run out, branch
	bra.w	DeleteObject					; Delete ourselves
	
.NotDone:
	lea	obj.anim(a6),a0					; Animate sprite
	jsr	UpdateAnimation
	bra.w	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------
; Draw icon sprite
; ------------------------------------------------------------------------------

DrawIcon:
	move.b	#1,-(sp)					; Draw sprite
	move.b	obj.anim+anim.frame+1(a6),-(sp)
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
; Icon animations
; ------------------------------------------------------------------------------

Anim_MonitorIcon:
	dc.w	.Yugioh-Anim_MonitorIcon
	dc.w	.Shield-Anim_MonitorIcon
	dc.w	.Invincibility-Anim_MonitorIcon

.Yugioh:
	ANIM_START $50, ANIM_RESTART
	dc.w	2, 3, 4, 5
	ANIM_END

.Shield:
	ANIM_START $50, ANIM_RESTART
	dc.w	6, 7, 8, 9
	ANIM_END

.Invincibility:
	ANIM_START $50, ANIM_RESTART
	dc.w	10, 11, 12, 13
	ANIM_END

; ------------------------------------------------------------------------------
