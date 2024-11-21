; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ben object
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/sonic/shared.inc"

; ------------------------------------------------------------------------------
; Initialization state
; ------------------------------------------------------------------------------

ObjBen:
	SET_OBJECT_LAYER move.w,1,obj.layer(a6)			; Set layer

	move.w	#14,obj.collide_width(a6)			; Set hitbox size
	move.w	#24,obj.collide_height(a6)
	
	move.w	#32,obj.draw_width(a6)				; Set draw size
	move.w	#32,obj.draw_height(a6)

	move.l	#UpdateState,obj.update(a6)			; Set state
	move.l	#Draw,obj.draw(a6)				; Set draw routine

; ------------------------------------------------------------------------------
; Update state
; ------------------------------------------------------------------------------

UpdateState:
	move.w	cur_ben_object,d0				; Is there a Ben statue?
	beq.s	.CheckAppear					; If not, branch
	cmpa.w	d0,a6						; Is it us?
	beq.s	.CheckAppear					; If so, branch
	clr.b	obj.flags+1(a6)					; If not, hide ourselves

.CheckAppear:
	tst.b	obj.flags+1(a6)					; Have we already appeared?
	bne.w	.AlreadyAppeared				; If so, branch
	
	move.w	obj.y(a6),d0					; Is the player too far above us?
	subi.w	#224+32,d0
	sub.w	camera_fg_y,d0
	bpl.w	.Draw						; If so, branch
	
	move.w	obj.y(a6),d0					; Is the player too far below us?
	addi.w	#32,d0
	sub.w	camera_fg_y,d0
	bmi.s	.Draw						; If so, branch

	move.w	obj.x(a6),d0					; Has the player gone past us on the left?
	subi.w	#320+64,d0
	move.w	d0,d1
	sub.w	camera_fg_x,d0
	bpl.s	.CheckRight					; If not, branch
	sub.w	camera_fg_x_previous,d1
	bpl.s	.Appear						; If so, branch

.CheckRight:
	move.w	obj.x(a6),d0					; Has the player gone past us on the right?
	addi.w	#64,d0
	move.w	d0,d1
	sub.w	camera_fg_x,d0
	bmi.s	.Draw						; If not, branch
	sub.w	camera_fg_x_previous,d1
	bpl.s	.Draw						; If not, branch

.Appear:
	bsr.w	SpawnObject					; Spawn portal
	bne.s	.NoPortal
	move.l	#ObjPortal,obj.update(a1)
	move.w	obj.x(a6),obj.x(a1)
	move.w	obj.y(a6),obj.y(a1)
	move.w	a6,ben_portal.parent(a1)
	move.w	a1,ben.portal(a6)
	
.NoPortal:
	move.w	a6,ben_appear					; Appear
	st	obj.flags+1(a6)
	
	move.w	a6,cam_focus_object				; Focus camera on us
	move.w	#2,camera_fg_x_speed
	move.w	#2,camera_fg_y_speed
	move.w	#96,cam_focus_top
	move.w	#96,cam_focus_bottom
	bra.s	.Draw

.AlreadyAppeared:
	bsr.w	HazardObject					; Hazard object

.Draw:
	bsr.w	DrawObject					; Draw sprite
	bra.w	DespawnObject					; Handle despawn

; ------------------------------------------------------------------------------
; Draw sprite
; ------------------------------------------------------------------------------

Draw:
	tst.b	obj.flags+1(a6)					; Have we appeared?
	beq.w	.End						; If not, branch

	move.w	ben.portal(a6),d0				; Is there a portal?
	beq.s	.Draw						; If not, branch
	movea.w	d0,a1						; Should we draw the Ben sprite?
	cmpi.w	#$80,ben_portal.scale(a1)
	blt.s	.End						; If not, branch

.Draw:
	move.b	#$C,-(sp)					; Draw sprite
	clr.b	-(sp)
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

.End:
	rts

; ------------------------------------------------------------------------------
; Portal initialization state
; ------------------------------------------------------------------------------

ObjPortal:
	SET_OBJECT_LAYER move.w,7,obj.layer(a6)			; Set layer
	
	move.w	#256,obj.draw_width(a6)				; Set draw size
	move.w	#256,obj.draw_height(a6)
	
	move.w	#$FF1B,MARS_COMM_14+MARS_SYS			; Play sound

	move.l	#DrawObject,obj.update(a6)			; Set state
	move.l	#DrawPortal,obj.draw(a6)			; Set draw routine
	bra.w	DrawObject

.Nothing:
	rts

; ------------------------------------------------------------------------------
; Draw portal sprite
; ------------------------------------------------------------------------------

DrawPortal:
	tst.w	ben_appear					; Should we draw the sprite?
	beq.w	.End						; If not, branch

	cmpi.w	#$80,ben_portal.scale(a6)			; Should the portal be transparent?
	blt.s	.DrawPortal					; If not, branch

	btst	#1,ben_portal.scale+1(a6)			; Should we draw on this frame?
	beq.s	.ScalePortal					; If not, branch

.DrawPortal:
	move.b	#$C,-(sp)					; Draw portal
	move.b	ben_portal.frame(a6),d0
	addq.b	#1,d0
	move.b	d0,-(sp)
	addq.b	#1,ben_portal.frame(a6)
	andi.b	#$F,ben_portal.frame(a6)
	clr.b	-(sp)
	move.w	obj.x(a6),d0
	sub.w	camera_fg_x_draw,d0
	move.w	d0,-(sp)
	move.w	obj.y(a6),d0
	sub.w	camera_fg_y_draw,d0
	addi.w	#28,d0
	move.w	d0,-(sp)
	lea	Scales,a0
	move.w	ben_portal.scale(a6),d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a0,d0.w),-(sp)
	move.w	2(a0,d0.w),-(sp)
	bsr.w	DrawLoadedMarsSprite

.ScalePortal:
	addq.w	#1,ben_portal.scale(a6)				; Scale portal up
	cmpi.w	#$120,ben_portal.scale(a6)			; Are we done?
	blt.s	.End						; If not, branch
	move.w	#$120,ben_portal.scale(a6)			; Stop scaling
	
	move.w	cam_focus_object,d0				; Focus camera on the player
	move.w	player_object,d1
	move.w	d1,cam_focus_object
	cmp.w	d1,d0						; Was it already focusing on the player?
	bne.s	.End						; If not, branch
	
	move.w	camera_fg_x_draw,d0
	cmp.w	camera_fg_x_scroll,d0
	bne.s	.End						; If not, branch
	move.w	camera_fg_y,d0
	cmp.w	camera_fg_y_scroll,d0
	bne.s	.End						; If not, branch

	move.w	#16,camera_fg_x_speed				; Restore camera settings
	clr.w	ben_appear

	movea.w	ben_portal.parent(a6),a1			; Delete ourselves
	clr.w	ben.portal(a1)
	bra.w	DeleteObject

.End:
	rts

; ------------------------------------------------------------------------------
; Y scale values
; ------------------------------------------------------------------------------

	section m68k_rom_fixed_data

Scales:
	.t1: = $70*256
	.t2: = 0
	rept $120
		.i: = 1
		while ((32*256)/.i)>(.t1/256)
			.i: = .i+1
		endw
		dc.w	.i
		if .t1>=(32*256)
			.t1: = .t1-$80
		elseif .t1>0
			.t1: = .t1-$40
		else
			.t1: = 0
		endif

		.i: = 1
		while ((32*256)/.i)>(.t2/256)
			.i: = .i+1
		endw
		dc.w	.i
		if .t2<(32*256)
			.t2: = .t2+$C0
		elseif .t2<(224*256)
			.t2: = .t2+$100
		else
			.t2: = 224*256
		endif
	endr
	dc.w	0, 0

; ------------------------------------------------------------------------------
