; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Object functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/framework/md.inc"
	
; ------------------------------------------------------------------------------
; Initialize objects
; ------------------------------------------------------------------------------

InitObjects:
	lea	objects,a0					; Initialize object pool
	moveq	#obj.struct_len,d0
	moveq	#OBJECT_COUNT,d1
	bsr.w	InitList
	
	lea	object_draw_queue,a0				; Clear object draw queue
	move.w	#(OBJECT_LAYERS*(OBJ_DRAW_SLOTS+1))*2,d0
	bra.w	ClearMemory
	
; ------------------------------------------------------------------------------
; Update objects
; ------------------------------------------------------------------------------

UpdateObjects:
	.c: = 0							; Reset object draw queue
	rept OBJECT_LAYERS
		clr.w	object_draw_queue+.c
		.c: = .c+((OBJ_DRAW_SLOTS+1)*2)
	endr

	clr.w	solid_objects					; Reset solid object list

	lea	objects,a6					; Get first object slot
	move.w	list.head(a6),d0
	beq.s	.End						; If there are no objects, branch
	
.UpdateLoop:
	movea.w	d0,a6						; Set object slot
	move.w	item.next(a6),-(sp)				; Get next object slot

	move.l	obj.update(a6),d0				; Get update routine
	beq.s	.NextObject					; If it's not set, branch
	
	movea.l	d0,a0						; Run update routine
	jsr	(a0)
	
.NextObject:
	move.w	(sp)+,d0					; Get next object slot
	bne.s	.UpdateLoop					; Loop until finished

.End:
	rts

; ------------------------------------------------------------------------------
; Update objects' previous positions
; ------------------------------------------------------------------------------

UpdateObjectsPrevPos:
	lea	objects,a6					; Get first object slot
	move.w	list.head(a6),d0
	beq.s	.End						; If there are no objects, branch
	
.UpdateLoop:
	movea.w	d0,a6						; Set object slot

	move.w	obj.x(a6),obj.previous_x(a6)			; Set previous position
	move.w	obj.y(a6),obj.previous_y(a6)
	
	move.w	item.next(a6),d0				; Get next object slot
	bne.s	.UpdateLoop					; Loop until finished

.End:
	rts

; ------------------------------------------------------------------------------
; Draw objects
; ------------------------------------------------------------------------------

DrawObjects:
	moveq	#OBJECT_LAYERS-1,d7				; Number of layers
	lea	object_draw_queue,a0				; Object draw queue

.DrawLayerLoop:
	movea.w	a0,a1						; Get layer queue
	move.w	(a1)+,d6					; Number of objects queued
	beq.s	.NextDrawLayer					; If there are no objects, branch

.DrawLoop:
	movea.w	(a1)+,a6					; Get object

	bsr.w	CheckObjectOnScreen				; Is this object onscreen?
	bne.s	.NextObject					; If not, branch

	move.l	obj.draw(a6),d0					; Get draw routine
	beq.s	.NextObject					; If it's not set, branch
	
	movem.l	d6-d7/a0-a1,-(sp)				; Run draw routine
	movea.l	d0,a0
	jsr	(a0)
	movem.l	(sp)+,d6-d7/a0-a1
	
.NextObject:
	subq.w	#2,d6						; Decrement number of objects left
	bne.s	.DrawLoop					; Loop until all objects in layer are drawn

.NextDrawLayer:
	lea	(OBJ_DRAW_SLOTS+1)*2(a0),a0			; Next layer
	dbf	d7,.DrawLayerLoop				; Loop until all layers are drawn

.End:
	rts

; ------------------------------------------------------------------------------
; Spawn object
; ------------------------------------------------------------------------------
; RETURNS:
;	eq/ne - Success/Failure
;	a1.l  - Spawned object
; ------------------------------------------------------------------------------

SpawnObject:
	lea	objects,a0					; Spawn object
	bra.w	AddListItem

; ------------------------------------------------------------------------------
; Delete current object
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l  - Object slot
; RETURNS:
;	eq/ne - Last object/Not last object
;	a1.l  - Next object slot
; ------------------------------------------------------------------------------

DeleteObject:
	movea.w	a6,a1						; Delete current object
	bra.w	RemoveListItem

; ------------------------------------------------------------------------------
; Queue object for drawing
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; ------------------------------------------------------------------------------

DrawObject:
	movea.w	obj.layer(a6),a0				; Get object draw queue layer

	cmpi.w	#OBJ_DRAW_SLOTS*2,(a0)				; Is the queue full?
	bcc.s	.End						; If so, branch
	
	addq.w	#2,(a0)						; Get slot
	adda.w	(a0),a0	
	move.w	a6,(a0)						; Queue object for drawing

.End:
	rts

; ------------------------------------------------------------------------------
; Move object
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; ------------------------------------------------------------------------------

MoveObject:
	movem.w	obj.x_speed(a6),d0-d1				; Add speed to position
	asl.l	#8,d0
	asl.l	#8,d1
	add.l	d0,obj.x(a6)
	add.l	d1,obj.y(a6)
	rts

; ------------------------------------------------------------------------------
; Check if current object is on screen
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l  - Object slot
; RETURNS:
;	eq/ne - On screen/Off screen
; ------------------------------------------------------------------------------

CheckObjectOnScreen:
	move.w	obj.x(a6),d0					; Check if on screen horizontally
	sub.w	camera_fg_x_draw,d0
	move.w	obj.draw_width(a6),d1

	sub.w	d1,d0						; Should this object be drawn?
	cmpi.w	#320,d0
	bge.s	.Offscreen					; If not, branch
	add.w	d1,d0
	add.w	d1,d0
	bmi.s	.Offscreen					; If not, branch

	move.w	obj.y(a6),d0					; Check if on screen vertically
	sub.w	camera_fg_y_draw,d0
	move.w	obj.draw_height(a6),d1

	sub.w	d1,d0						; Should this object be drawn?
	cmpi.w	#224,d0
	bge.s	.Offscreen					; If not, branch
	add.w	d1,d0
	add.w	d1,d0
	bmi.s	.Offscreen					; If not, branch

	ori	#4,sr						; Onscreen
	rts

.Offscreen:
	andi	#~4,sr						; Offscreen
	rts

; ------------------------------------------------------------------------------
; Check if other object is onscreen
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l  - Object slot
; RETURNS:
;	eq/ne - Onscreen/Offscreen
; ------------------------------------------------------------------------------

CheckOtherObjectOnScreen:
	move.w	obj.x(a1),d0					; Check if on screen horizontally
	sub.w	camera_fg_x_draw,d0
	move.w	obj.draw_width(a1),d1

	sub.w	d1,d0						; Should this object be drawn?
	cmpi.w	#320,d0
	bge.s	.Offscreen					; If not, branch
	add.w	d1,d0
	add.w	d1,d0
	bmi.s	.Offscreen					; If not, branch

	move.w	obj.y(a1),d0					; Check if on screen vertically
	sub.w	camera_fg_y_draw,d0
	move.w	obj.draw_height(a1),d1

	sub.w	d1,d0						; Should this object be drawn?
	cmpi.w	#224,d0
	bge.s	.Offscreen					; If not, branch
	add.w	d1,d0
	add.w	d1,d0
	bmi.s	.Offscreen					; If not, branch

	ori	#4,sr						; Onscreen
	rts

.Offscreen:
	andi	#~4,sr						; Offscreen
	rts

; ------------------------------------------------------------------------------
; Check for collision with other object
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l  - Other object slot
;	a6.l  - Object slot
; RETURNS:
;	eq/ne - Collision/No collision
;	d0.w  - Horizontal collision overlap (if collided)
;	d1.w  - Vertical collision overlap (if collided)
;	d2.w  - Collision width (if collided)
;	d3.w  - Collision height (if collided)
; ------------------------------------------------------------------------------

CheckObjectCollide:
	move.w	obj.x(a1),d0					; Get other object's position
	move.w	obj.y(a1),d1

CheckObjectCollide2:
	move.w	obj.collide_width(a1),d2			; Get maximum distance needed for collision
	add.w	obj.collide_width(a6),d2
	
	sub.w	obj.x(a6),d0					; Get horizontal distance from the other object
	bpl.s	.CheckCollideX
	neg.w	d0

.CheckCollideX:
	cmp.w	d2,d0						; Is there a horizontal collision?
	bge.s	.NoCollision					; If not, branch

	move.w	obj.collide_height(a1),d3			; Get maximum distance needed for collision
	add.w	obj.collide_height(a6),d3

	sub.w	obj.y(a6),d1					; Get vertical distance from the other object
	bpl.s	.CheckCollideY
	neg.w	d1

.CheckCollideY:
	cmp.w	d3,d1						; Is there a vertical collision?
	bge.s	.NoCollision					; If not, branch

	ori	#4,sr						; Collision
	rts

.NoCollision:
	andi	#~4,sr						; No collision
	rts

; ------------------------------------------------------------------------------
; Make object solid
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Solidity flags
;	       Bit 0 = Top solid
;	       Bit 1 = Bottom solid
;	       Bit 2 = Left solid
;	       Bit 3 = Right solid
;	a6.l - Object slot
; ------------------------------------------------------------------------------

SolidObject:
	move.w	d0,-(sp)					; Save registers
	beq.s	.End						; If this object is not solid, branch

	bsr.w	CheckObjectOnScreen				; Is this object onscreen?
	bne.s	.End						; If not, branch

	lea	solid_objects,a0				; Get solid object list slot
	cmpi.w	#OBJECT_COUNT*4,(a0)				; Is the list full?
	bcc.s	.End						; If so, branch
	
	addq.w	#4,(a0)						; Get slot
	adda.w	(a0),a0
	
	move.w	a6,(a0)+					; Add to list
	move.w	(sp),(a0)+

.End:
	move.w	(sp)+,d0					; Restore registers
	rts

; ------------------------------------------------------------------------------
; Check collision with solid objects
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l - Object slot
; ------------------------------------------------------------------------------

CheckSolidObjectCollide:
	lea	solid_object_top,a0				; Reset touched objects
	moveq	#0,d0
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+

	lea	solid_objects,a0				; Solid object list
	move.w	(a0),d7
	beq.w	.End						; If there are no solid objects, branch

	move.w	d7,d6						; X collision iterator

; ------------------------------------------------------------------------------

.CheckXLoop:
	movea.w	(a0,d6.w),a6					; Get solid object
	cmpa.w	a6,a1						; Is it us?
	beq.w	.NextObjectX					; If so, branch

	move.w	obj.x(a1),d0					; Check horizontal collision
	move.w	obj.previous_y(a1),d1
	bsr.w	CheckObjectCollide2
	bne.w	.NextObjectX					; If there was none, branch

	move.b	3(a0,d6.w),d1					; Get solidity flags

; ------------------------------------------------------------------------------

.CheckRight:
	move.w	obj.x(a6),d0					; Right side
	add.w	d2,d0
	lea	solid_object_right,a2
	
	btst	#3,d1						; Is this solid object right solid?
	beq.s	.CheckLeft					; If not, branch

	move.w	obj.x(a1),d4					; Is the colliding object right of this solid object?
	cmp.w	obj.x(a6),d4
	blt.s	.CheckLeft					; If not, branch

	cmp.w	obj.previous_x(a1),d4				; Is the colliding object moving left?
	bgt.s	.CheckLeft					; If not, branch
	
	btst	#2,d1						; Is this solid object also left solid?
	bne.s	.StopX						; If so, branch

	move.w	obj.x(a6),d5					; Is the colliding object too far to the left?
	add.w	obj.collide_width(a6),d5
	sub.w	d4,d5
	add.w	obj.previous_x(a1),d5
	cmp.w	d5,d4
	bge.s	.StopX						; If not, branch

; ------------------------------------------------------------------------------

.CheckLeft:
	sub.w	d2,d0						; Left side
	sub.w	d2,d0
	lea	solid_object_left,a2

	btst	#2,d1						; Is this solid object left solid?
	beq.s	.NextObjectX					; If not, branch

	move.w	obj.x(a1),d4					; Is the colliding object moving right?
	cmp.w	obj.previous_x(a1),d4
	blt.s	.NextObjectX					; If not, branch
	
	btst	#3,d1						; Is this solid object also right solid?
	bne.s	.StopX						; If so, branch

	move.w	obj.x(a6),d5					; Is the colliding object too far to the right?
	sub.w	obj.collide_width(a6),d5
	add.w	d4,d5
	sub.w	obj.previous_x(a1),d5
	cmp.w	d5,d4
	bgt.s	.NextObjectX					; If so, branch

; ------------------------------------------------------------------------------

.StopX:
	clr.w	obj.x_speed(a1)					; Stop horizontally
	move.w	d0,obj.x(a1)					; Push outside object
	clr.w	obj.x+2(a1)

	move.w	a6,(a2)						; Mark as touched
	move.w	d2,2(a2)
	move.w	d3,4(a2)

.NextObjectX:
	subq.w	#4,d6						; Next object
	bne.w	.CheckXLoop					; Loop until finished

; ------------------------------------------------------------------------------

.CheckYLoop:
	movea.w	(a0,d7.w),a6					; Get solid object
	cmpa.w	a6,a1						; Is it us?
	beq.w	.NextObjectY					; If so, branch

	bsr.w	CheckObjectCollide				; Check vertical collision
	bne.w	.NextObjectY					; If there was none, branch

	move.b	3(a0,d7.w),d1					; Get solidity flags

; ------------------------------------------------------------------------------

.CheckBottom:
	move.w	obj.y(a6),d0					; Bottom side
	add.w	d3,d0
	lea	solid_object_bottom,a2
	
	btst	#1,d1						; Is this solid object bottom solid?
	beq.s	.CheckTop					; If not, branch
	
	move.w	obj.y(a1),d4					; Is the colliding object below of this solid object?
	cmp.w	obj.y(a6),d4
	blt.s	.CheckTop					; If not, branch

	cmp.w	obj.previous_y(a1),d4				; Is the colliding object moving up?
	bgt.s	.CheckTop					; If not, branch
	
	btst	#0,d1						; Is this solid object also top solid?
	bne.s	.StopY						; If so, branch

	move.w	obj.y(a6),d5					; Is the colliding object too far above?
	add.w	obj.collide_height(a6),d5
	sub.w	d4,d5
	add.w	obj.previous_y(a1),d5
	cmp.w	d5,d4
	bge.s	.StopY						; If not, branch

; ------------------------------------------------------------------------------

.CheckTop:
	sub.w	d3,d0						; Top side
	sub.w	d3,d0
	lea	solid_object_top,a2

	btst	#0,d1						; Is this solid object top solid?
	beq.s	.NextObjectY					; If not, branch

	move.w	obj.y(a1),d4					; Is the colliding object moving down?
	cmp.w	obj.previous_y(a1),d4
	blt.s	.NextObjectY					; If not, branch
	
	btst	#1,d1						; Is this solid object also bottom solid?
	bne.s	.StopY						; If so, branch

	move.w	obj.y(a6),d5					; Is the colliding object too far below?
	sub.w	obj.collide_height(a6),d5
	add.w	d4,d5
	sub.w	obj.previous_y(a1),d5
	cmp.w	d5,d4
	bgt.s	.NextObjectY					; If so, branch

; ------------------------------------------------------------------------------

.StopY:
	clr.w	obj.y_speed(a1)					; Stop vertically
	move.w	d0,obj.y(a1)					; Push outside object
	clr.w	obj.y+2(a1)

	move.w	a6,(a2)						; Mark as touched
	move.w	d2,2(a2)
	move.w	d3,4(a2)

.NextObjectY:
	subq.w	#4,d7						; Next object
	bne.w	.CheckYLoop					; Loop until finished

.End:
	rts

; ------------------------------------------------------------------------------
; Handle current object despawning
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; RETURNS:
;	a1.l - Next object slot
; ------------------------------------------------------------------------------

DespawnObject:
	move.b	obj.x(a6),d0					; Get number of horizontal chunks away from current one
	sub.b	camera_fg_x,d0

	addq.b	#2,d0						; Is the object far enough away?
	cmpi.b	#3+2,d0
	bhi.s	.Despawn					; If so, branch
	
	move.b	obj.y(a6),d0					; Get number of vertical chunks away from current one
	sub.b	camera_fg_y,d0

	addq.b	#2,d0						; Is the object far enough away?
	cmpi.b	#3+2,d0
	bhi.s	.Despawn					; If so, branch
	rts

.Despawn:
	move.w	obj.state(a6),d0				; Get object state address
	beq.s	.Delete						; If it's not set, branch
	movea.w	d0,a0						; Clear spawn flag
	bclr	#7,(a0)

.Delete:
	bra.w	DeleteObject					; Delete ourselves

; ------------------------------------------------------------------------------
; Handle other object despawning
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l - Object slot
; RETURNS:
;	a1.l - Next object slot
; ------------------------------------------------------------------------------

DespawnOtherObject:
	move.b	obj.x(a1),d0					; Get number of horizontal chunks away from current one
	sub.b	camera_fg_x,d0

	addq.b	#2,d0						; Is the object far enough away?
	cmpi.b	#3+2,d0
	bhi.s	.Despawn					; If so, branch
	
	move.b	obj.y(a1),d0					; Get number of vertical chunks away from current one
	sub.b	camera_fg_y,d0

	addq.b	#2,d0						; Is the object far enough away?
	cmpi.b	#3+2,d0
	bhi.s	.Despawn					; If so, branch
	rts

.Despawn:
	move.w	obj.state(a1),d0				; Get object state address
	beq.s	.Delete						; If it's not set, branch
	movea.w	d0,a0						; Clear spawn flag
	bclr	#7,(a0)

.Delete:
	bra.w	DeleteOtherObject				; Delete object

; ------------------------------------------------------------------------------
; Check if current object should despawn
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l  - Object slot
; RETURNS:
;	eq/ne - Should despawn/Should not despawn
; ------------------------------------------------------------------------------

CheckObjectDespawn:
	move.b	obj.x(a6),d0					; Get number of horizontal chunks away from current one
	sub.b	camera_fg_x,d0

	addq.b	#2,d0						; Is the object far enough away?
	cmpi.b	#3+2,d0
	bhi.s	.Despawn					; If so, branch
	
	move.b	obj.y(a6),d0					; Get number of vertical chunks away from current one
	sub.b	camera_fg_y,d0

	addq.b	#2,d0						; Is the object far enough away?
	cmpi.b	#3+2,d0
	bhi.s	.Despawn					; If so, branch

	andi	#~4,sr						; Object should not despawn
	rts

.Despawn:
	ori	#4,sr						; Object should despawn
	rts

; ------------------------------------------------------------------------------
; Check if other object should despawn
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l  - Object slot
; RETURNS:
;	eq/ne - Should despawn/Should not despawn
; ------------------------------------------------------------------------------

CheckOtherObjectDespawn:
	move.b	obj.x(a1),d0					; Get number of horizontal chunks away from current one
	sub.b	camera_fg_x,d0

	addq.b	#2,d0						; Is the object far enough away?
	cmpi.b	#3+2,d0
	bhi.s	.Despawn					; If so, branch
	
	move.b	obj.y(a1),d0					; Get number of vertical chunks away from current one
	sub.b	camera_fg_y,d0

	addq.b	#2,d0						; Is the object far enough away?
	cmpi.b	#3+2,d0
	bhi.s	.Despawn					; If so, branch

	andi	#~4,sr						; Object should not despawn
	rts

.Despawn:
	ori	#4,sr						; Object should despawn
	rts

; ------------------------------------------------------------------------------
; Get current object state
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; RETURNS:
;	eq/ne - Retrieved/No object slot
;	a0.l - Object state address
; ------------------------------------------------------------------------------

GetObjectState:
	move.w	obj.state(a6),d0				; Get object state address
	beq.s	.End						; If it's not set, branch
	movea.w	d0,a0
	
.End:
	cmpa.w	#0,a0						; Check if object state was retrieved
	eori	#4,sr
	rts

; ------------------------------------------------------------------------------
; Get other object state
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; RETURNS:
;	eq/ne - Retrieved/No object slot
;	a0.l  - Object state address
; ------------------------------------------------------------------------------

GetOtherObjectState:
	move.w	obj.state(a1),d0				; Get object state address
	beq.s	.End						; If it's not set, branch
	movea.w	d0,a0
	
.End:
	cmpa.w	#0,a0						; Check if object state was retrieved
	eori	#4,sr
	rts	
	
; ------------------------------------------------------------------------------
; Clear current object spawn flag
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; ------------------------------------------------------------------------------

ClearObjectSpawnFlag:
	bsr.s	GetObjectState					; Clear spawn flag
	bne.s	.End
	bclr	#7,(a0)

.End:
	rts

; ------------------------------------------------------------------------------
; Clear other object spawn flag
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l - Object slot
; ------------------------------------------------------------------------------

ClearOtherObjectSpawnFlag:
	bsr.s	GetOtherObjectState				; Clear spawn flag
	bne.s	.End
	bclr	#7,(a0)

.End:
	rts

; ------------------------------------------------------------------------------
; Check map collision down
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Y offset (if calling ObjMapCollideDown3)
;	d3.w - X offset (if calling ObjMapCollideDown2 or ObjMapCollideDown3)
;	a6.l - Object slot
; RETURNS:
;	d1.w - Distance from map block
;	d2.b - Angle of map block
; ------------------------------------------------------------------------------

ObjMapCollideDown:
	move.w	obj.x(a6),d3					; Get X offset

ObjMapCollideDown2:
	move.w	obj.y(a6),d2					; Get Y offset
	add.w	obj.collide_height(a6),d2

ObjMapCollideDown3:
	lea	obj_angle_buffer,a4				; Check collision
	bsr.w	GetMapBlockDistDown
	move.b	(a4),d2
	rts

; ------------------------------------------------------------------------------
; Check map collision down (wide)
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; RETURNS:
;	d0.w - Distance from other map block
;	d1.w - Distance from map block
;	d2.b - Angle of map block
; ------------------------------------------------------------------------------

ObjMapCollideDownWide:
	move.w	obj.y(a6),d2					; Check collision (left sensor)
	add.w	obj.collide_height(a6),d2
	move.l	d2,-(sp)
	move.w	obj.x(a6),d3
	sub.w	obj.collide_width(a6),d3
	lea	obj_angle_buffer,a4
	bsr.w	GetMapBlockDistDown
	move.l	(sp)+,d2
	move.l	d1,-(sp)
	
	move.w	obj.x(a6),d3					; Check collision (right sensor)
	add.w	obj.collide_width(a6),d3
	addq.w	#1,a4
	bsr.w	GetMapBlockDistDown
	move.l	(sp)+,d0

	move.b	(a4),d2						; Get angle
	cmp.w	d0,d1						; Is the right side closer?
	ble.s	.End						; If so, branch
	move.b	-(a4),d2					; Use left side
	exg.l	d0,d1

.End:
	rts

; ------------------------------------------------------------------------------
; Check map collision up
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Y offset (if calling ObjMapCollideUp3)
;	d3.w - X offset (if calling ObjMapCollideUp2 or ObjMapCollideUp3)
;	a6.l - Object slot
; RETURNS:
;	d1.w - Distance from map block
;	d2.b - Angle of map block
; ------------------------------------------------------------------------------

ObjMapCollideUp:
	move.w	obj.x(a6),d3					; Get X offset

ObjMapCollideUp2:
	move.w	obj.y(a6),d2					; Get Y offset
	sub.w	obj.collide_height(a6),d2

ObjMapCollideUp3:
	lea	obj_angle_buffer,a4				; Check collision
	bsr.w	GetMapBlockDistUp
	move.b	(a4),d2
	rts

; ------------------------------------------------------------------------------
; Check map collision up (wide)
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; RETURNS:
;	d0.w - Distance from other map block
;	d1.w - Distance from map block
;	d2.b - Angle of map block
; ------------------------------------------------------------------------------

ObjMapCollideUpWide:
	move.w	obj.y(a6),d2					; Check collision (left sensor)
	sub.w	obj.collide_height(a6),d2
	move.l	d2,-(sp)
	move.w	obj.x(a6),d3
	sub.w	obj.collide_width(a6),d3
	lea	obj_angle_buffer,a4
	bsr.w	GetMapBlockDistUp
	move.l	(sp)+,d2
	move.l	d1,-(sp)

	move.w	obj.x(a6),d3					; Check collision (right sensor)
	add.w	obj.collide_width(a6),d3
	addq.w	#1,a4
	bsr.w	GetMapBlockDistUp
	move.l	(sp)+,d0

	move.b	(a4),d2						; Get angle
	cmp.w	d0,d1						; Is the right side closer?
	ble.s	.End						; If so, branch
	move.b	-(a4),d2					; Use left side
	exg.l	d0,d1

.End:
	rts

; ------------------------------------------------------------------------------
; Check map collision right
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Y offset (if calling ObjMapCollideRight2 or ObjMapCollideRight3)
;	d3.w - X offset (if calling ObjMapCollideRight3)
;	a6.l - Object slot
; RETURNS:
;	d1.w - Distance from map block
;	d2.b - Angle of map block
; ------------------------------------------------------------------------------

ObjMapCollideRight:
	move.w	obj.y(a6),d2					; Get Y offset

ObjMapCollideRight2:
	move.w	obj.x(a6),d3					; Get X offset
	add.w	obj.collide_width(a6),d3

ObjMapCollideRight3:
	lea	obj_angle_buffer,a4				; Check collision
	bsr.w	GetMapBlockDistRight
	move.b	(a4),d2
	rts

; ------------------------------------------------------------------------------
; Check map collision right (wide)
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; RETURNS:
;	d0.w - Distance from other map block
;	d1.w - Distance from map block
;	d2.b - Angle of map block
; ------------------------------------------------------------------------------

ObjMapCollideRightWide:
	move.w	obj.y(a6),d2					; Check collision (top sensor)
	sub.w	obj.collide_height(a6),d2
	move.w	obj.x(a6),d3
	add.w	obj.collide_width(a6),d3
	move.l	d3,-(sp)
	lea	obj_angle_buffer,a4
	bsr.w	GetMapBlockDistRight
	move.l	(sp)+,d3
	move.l	d1,-(sp)

	move.w	obj.y(a6),d2					; Check collision (bottom sensor)
	add.w	obj.collide_height(a6),d2
	addq.w	#1,a4
	bsr.w	GetMapBlockDistRight
	move.l	(sp)+,d0

	move.b	(a4),d2						; Get angle
	cmp.w	d0,d1						; Is the bottom side closer?
	ble.s	.End						; If so, branch
	move.b	-(a4),d2					; Use top side
	exg.l	d0,d1

.End:
	rts

; ------------------------------------------------------------------------------
; Check map collision left
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d2.w - Y offset (if calling ObjMapCollideLeft2 or ObjMapCollideLeft3)
;	d3.w - X offset (if calling ObjMapCollideLeft3)
;	a6.l - Object slot
; RETURNS:
;	d1.w - Distance from map block
;	d2.b - Angle of map block
; ------------------------------------------------------------------------------

ObjMapCollideLeft:
	move.w	obj.y(a6),d2					; Get Y offset

ObjMapCollideLeft2:
	move.w	obj.x(a6),d3					; Get X offset
	sub.w	obj.collide_width(a6),d3

ObjMapCollideLeft3:
	lea	obj_angle_buffer,a4				; Check collision
	bsr.w	GetMapBlockDistLeft
	move.b	(a4),d2
	rts

; ------------------------------------------------------------------------------
; Check map collision left (wide)
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a6.l - Object slot
; RETURNS:
;	d0.w - Distance from other map block
;	d1.w - Distance from map block
;	d2.b - Angle of map block
; ------------------------------------------------------------------------------

ObjMapCollideLeftWide:
	move.w	obj.y(a6),d2					; Check collision (top sensor)
	sub.w	obj.collide_height(a6),d2
	move.w	obj.x(a6),d3
	sub.w	obj.collide_width(a6),d3
	move.l	d3,-(sp)
	lea	obj_angle_buffer,a4
	bsr.w	GetMapBlockDistLeft
	move.l	(sp)+,d3
	move.l	d1,-(sp)

	move.w	obj.y(a6),d2					; Check collision (bottom sensor)
	add.w	obj.collide_height(a6),d2
	addq.w	#1,a4
	bsr.w	GetMapBlockDistLeft
	move.l	(sp)+,d0

	move.b	(a4),d2						; Get angle
	cmp.w	d0,d1						; Is the bottom side closer?
	ble.s	.End						; If so, branch
	move.b	-(a4),d2					; Use top side
	exg.l	d0,d1

.End:
	rts

; ------------------------------------------------------------------------------
; Check map collision in front
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Angle
;	a6.l - Object slot
; RETURNS:
;	d1.w - Distance from map block
;	d2.b - Angle of map block
; ------------------------------------------------------------------------------

ObjMapCollideFront:
	move.b	d0,obj_angle_buffer				; Set angles
	move.b	d0,obj_angle_buffer+1

	btst	#6,d0						; Are we in quadrants 0 or $80?
	beq.s	.DownUp						; If not, branch
	addq.b	#1,d0						; Shift the angle

.DownUp:
	addi.b	#$1F,d0						; Shift the angle
	andi.b	#$C0,d0						; Get which quadrant we are in
	beq.w	ObjMapCollideDown				; If quadrant 0, branch
	cmpi.b	#$80,d0						; Are we in quadrant $80?
	beq.w	ObjMapCollideUp					; If so, branch
	cmpi.b	#$40,d0						; Are we in quadrant $40?
	beq.w	ObjMapCollideLeft				; If so, branch
	bra.w	ObjMapCollideRight				; Handle quadrant $C0

; ------------------------------------------------------------------------------
; Check map collision above
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.b - Angle
;	a6.l - Object slot
; RETURNS:
;	d1.w - Distance from map block
;	d2.b - Angle of map block
; ------------------------------------------------------------------------------

ObjMapCollideAbove:
	move.b	d0,obj_angle_buffer				; Set angles
	move.b	d0,obj_angle_buffer+1

	addi.b	#$20,d0						; Shift the angle
	andi.b	#$C0,d0						; Get which quadrant we are in
	beq.w	ObjMapCollideDownWide				; If quadrant 0, branch
	cmpi.b	#$80,d0						; Are we in quadrant $80?
	beq.w	ObjMapCollideUpWide				; If so, branch
	cmpi.b	#$40,d0						; Are we in quadrant $40?
	beq.w	ObjMapCollideLeftWide				; If so, branch
	bra.w	ObjMapCollideRightWide				; Handle quadrant $C0

; ------------------------------------------------------------------------------
