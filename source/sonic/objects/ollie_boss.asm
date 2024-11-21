; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ollie boss object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjOllieBoss:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer
	
	move.w	#40,obj.draw_width(a6)				; Set draw size
	move.w	#64,obj.draw_height(a6)

	move.b	#8,ollie_boss.hit_count(a6)			; Set hit count

	move.l	#Draw,obj.draw(a6)				; Set draw routine

	move.l	#.Wait,obj.update(a6)				; Wait for a couple seconds
	move.w	#120,ollie_boss.timer(a6)

; ------------------------------------------------------------------------------

.Wait:
	subq.w	#1,ollie_boss.timer(a6)				; Decrement timer
	beq.s	.Ready						; If it hasn't run out, branch
	rts

.Ready:
	lea	Song_OneHundredYears,a0				; Play boss music
	jsr	PlayMusic

; ------------------------------------------------------------------------------

StartButtonPick:
	moveq	#0,d1						; Set timer
	move.b	ollie_boss.hit_count(a6),d1
	add.w	d1,d1
	move.w	.Timers(pc,d1.w),ollie_boss.timer(a6)

	move.l	#PickButtonState,obj.update(a6)			; Start picking a button
	rts

; ------------------------------------------------------------------------------

.Timers:
	dc.w	1, (2*60)+5, (2*60)+30, (2*60)+55, (3*60)+20, (3*60)+45, (4*60)+10, (4*60)+35, 5*60

; ------------------------------------------------------------------------------
; Pick button state
; ------------------------------------------------------------------------------

PickButtonState:
	move.w	camera_fg_y,d0					; Set Y position
	addi.w	#48,d0
	move.w	d0,obj.y(a6)

	moveq	#0,d0						; Get timer
	move.w	ollie_boss.timer(a6),d0
	beq.s	.Press						; If we should press the button, branch

	moveq	#0,d1						; Should we pick a button?
	move.b	ollie_boss.hit_count(a6),d1
	add.w	d1,d1
	move.w	.Speeds(pc,d1.w),d1
	divu.w	d1,d0
	swap	d0
	tst.w	d0
	bne.s	.NoPick						; If not, branch

.PickButton:
	jsr	Random						; Pick a random button
	andi.b	#3,d0
	cmpi.b	#3,d0
	beq.s	.PickButton
	cmp.b	ollie_boss.button(a6),d0
	beq.s	.PickButton
	move.b	d0,ollie_boss.button(a6)

.NoPick:
	subq.w	#1,ollie_boss.timer(a6)				; Decrement timer
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------

.Press:
	move.l	#FlashState,obj.update(a6)			; Start flashing
	move.w	#64,ollie_boss.timer(a6)
	bra.s	FlashState

; ------------------------------------------------------------------------------

.Speeds:
	dc.w	1, 25, 30, 35, 40, 45, 50, 55, 60

; ------------------------------------------------------------------------------
; Flash state
; ------------------------------------------------------------------------------

FlashState:
	subq.w	#1,ollie_boss.timer(a6)				; Decrement timer
	bne.s	.NotDone					; If it hasn't run out, branch

	move.l	#MoveDownState,obj.update(a6)			; Start moving down
	move.w	#-$500,obj.y_speed(a6)
	bra.s	MoveDownState

.NotDone:
	btst	#3,ollie_boss.timer+1(a6)			; Should we draw on this frame?
	bne.s	.End						; If not, branch
	jmp	DrawObject					; Draw sprite

.End:
	rts

; ------------------------------------------------------------------------------
; Move down state
; ------------------------------------------------------------------------------

MoveDownState:
	jsr	MoveObject					; Move
	addi.w	#$48,obj.y_speed(a6)				; Apply gravity

	move.w	camera_fg_y,d0					; Have we pressed the button?
	addi.w	#144,d0
	cmp.w	obj.y(a6),d0					
	bgt.s	.Draw						; If not, branch

	move.w	d0,obj.y(a6)					; Cap Y position

	moveq	#0,d0						; Is the player holding the button?
	move.b	ollie_boss.button(a6),d0
	btst	d0,button_flags
	bne.s	.TakeDamage					; If so, branch

	st	ollie_boss_restart				; Restart the stage

.Draw:
	jmp	DrawObject					; Draw sprite

; ------------------------------------------------------------------------------

.TakeDamage:
	lea	Sfx_HitBoss,a0					; Play hit boss sound
	jsr	PlaySfx

	subq.b	#1,ollie_boss.hit_count(a6)			; Decrement hit count
	bne.s	.NotDone					; If we're not done yet, branch

	st	boss_end					; End of boss fight
	jmp	DrawObject					; Draw sprite

.NotDone:
	move.b	#1,ollie_boss_frame				; Make Ollie look pained

	move.l	#HitState,obj.update(a6)			; Start taking damage
	move.w	#60,ollie_boss.timer(a6)

; ------------------------------------------------------------------------------
; Hit state
; ------------------------------------------------------------------------------

HitState:
	subq.w	#1,ollie_boss.timer(a6)				; Decrement timer
	beq.s	.StartWait					; If it has run out, branch
	
	subi.w	#$A,obj.y(a6)					; Move up
	jmp	DrawObject					; Draw sprite

.StartWait:
	clr.b	ollie_boss_frame				; Make Ollie look normal

	move.l	#.Wait,obj.update(a6)				; Wait for a couple seconds
	move.w	#60,ollie_boss.timer(a6)

; ------------------------------------------------------------------------------

.Wait:
	subq.w	#1,ollie_boss.timer(a6)				; Decrement timer
	beq.w	StartButtonPick					; If it has run out, branch
	rts

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	moveq	#0,d0						; Get X position
	move.b	ollie_boss.button(a6),d0
	add.w	d0,d0
	move.w	.ButtonX(pc,d0.w),d0

	move.b	#$E,-(sp)					; Draw sprite
	clr.b	-(sp)
	clr.b	-(sp)
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

.ButtonX:
	dc.w	$2608, $2660, $26B8

; ------------------------------------------------------------------------------
