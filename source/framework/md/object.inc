; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Object functions header
; ------------------------------------------------------------------------------

	global InitObjects
	global UpdateObjects
	global UpdateObjectsPrevPos
	global DrawObjects
	global SpawnObject
	global DeleteObject
	global DrawObject
	global MoveObject
	global CheckObjectOnScreen
	global CheckOtherObjectOnScreen
	global CheckObjectCollide
	global SolidObject
	global CheckSolidObjectCollide
	global DespawnObject
	global DespawnOtherObject
	global CheckObjectDespawn
	global CheckOtherObjectDespawn
	global GetObjectState
	global GetOtherObjectState
	global ClearObjectSpawnFlag
	global ClearOtherObjectSpawnFlag
	global ObjMapCollideDown
	global ObjMapCollideDown2
	global ObjMapCollideDown3
	global ObjMapCollideDownWide
	global ObjMapCollideUp
	global ObjMapCollideUp2
	global ObjMapCollideUp3
	global ObjMapCollideUpWide
	global ObjMapCollideRight
	global ObjMapCollideRight2
	global ObjMapCollideRight3
	global ObjMapCollideRightWide
	global ObjMapCollideLeft
	global ObjMapCollideLeft2
	global ObjMapCollideLeft3
	global ObjMapCollideLeftWide
	global ObjMapCollideFront
	global ObjMapCollideAbove

; ------------------------------------------------------------------------------
; Constants
; ------------------------------------------------------------------------------

OBJECT_COUNT		equ 64					; Number of object slots
OBJECT_LAYERS		equ 8					; Number of object layers
OBJ_DRAW_SLOTS		equ 63					; Number of object draw queue slots

OBJ_FLIP_X		equ 0					; Object X flip flag
OBJ_FLIP_Y		equ 1					; Object Y flip flag
OBJ_USER_FLAGS		equ 2					; Start of user object flags

OBJ_TOP_SOLID		equ %0001				; Top solid flag
OBJ_BOTTOM_SOLID	equ %0010				; Bottom solid flag
OBJ_LEFT_SOLID		equ %0100				; Left solid flag
OBJ_RIGHT_SOLID		equ %1000				; Right solid flag
OBJ_VERTI_SOLID		equ OBJ_TOP_SOLID|OBJ_BOTTOM_SOLID	; Vertically solid flags
OBJ_HORIZ_SOLID		equ OBJ_LEFT_SOLID|OBJ_RIGHT_SOLID	; Horizontally solid flags
OBJ_FULL_SOLID		equ OBJ_VERTI_SOLID|OBJ_HORIZ_SOLID	; Fully solid flags

; ------------------------------------------------------------------------------
; Object variables structure
; ------------------------------------------------------------------------------

	rsreset
			rs.b item.struct_len			; List item header
obj.flags		rs.w 1					; Flags
obj.layer		rs.w 1					; Draw queue address
obj.state		rs.w 1					; State address
obj.update		rs.l 1					; Update routine address
obj.draw		rs.l 1					; Draw routine address
obj.x			rs.l 1					; X position
obj.y			rs.l 1					; Y position
obj.previous_x		rs.w 1					; Previous X position
obj.previous_y		rs.w 1					; Previous Y position
obj.x_speed		rs.w 1					; X speed
obj.y_speed		rs.w 1					; Y speed
obj.collide_width	rs.w 1					; Collision width
obj.collide_height	rs.w 1					; Collision height
obj.draw_width		rs.w 1					; Draw width
obj.draw_height		rs.w 1					; Draw height
obj.anim		rs.b anim.struct_len			; Animation data
obj.subtype		rs.b 1					; Subtype
obj.subtype_2		rs.b 1					; Subtype 2
obj.vars		rs.b $60-__rs				; Object specific variables
obj.struct_len		rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; Set object layer
; ------------------------------------------------------------------------------
; PARAMETERS:
;	ins   - Instruction
;	layer - Layer ID
;	dest  - Destination (optional)
; ------------------------------------------------------------------------------

SET_OBJECT_LAYER macro ins, layer, dest
	if narg=3
		\ins	#object_draw_queue+(((OBJ_DRAW_SLOTS+1)*2)*(\layer)),\dest
	else
		\ins	object_draw_queue+(((OBJ_DRAW_SLOTS+1)*2)*(\layer))
	endif
	endm

; ------------------------------------------------------------------------------
; Delete other object
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l  - Object slot
; RETURNS:
;	eq/ne - Last object/Not last object
;	a1.l  - Next object slot
; ------------------------------------------------------------------------------

DeleteOtherObject	equ RemoveListItem

; ------------------------------------------------------------------------------
