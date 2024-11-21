; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Tilemap functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/framework/md.inc"
	
; ------------------------------------------------------------------------------
; Set plane size
; ------------------------------------------------------------------------------
; PARAMETERS
;	d0.w - Plane size configuration
;	       0: 32x32
;	       1: 64x32
;	       2: 128x32
;	       3: 32x64
;	       4: 64x64
;	       5: 32x128
; ------------------------------------------------------------------------------

SetPlaneSize:
	lsl.w	#3,d0						; Get plane size data
	move.l	.PlaneSizes(pc,d0.w),plane_width
	move.w	.PlaneSizes+4(pc,d0.w),plane_stride
	clr.w	plane_stride+2
	move.w	.PlaneSizes+6(pc,d0.w),VDP_CTRL
	rts

; ------------------------------------------------------------------------------

PLANE_SIZE macro w, h
	dc.w	\w, \h						; Dimensions
	dc.w	(\w)*2						; Stride
	dc.w	$9000|(((\w)/32)-1)|((((\h)/32)-1)<<4)		; VDP register
	endm

; ------------------------------------------------------------------------------

.PlaneSizes:
	PLANE_SIZE 32,32					; 32x32
	PLANE_SIZE 64,32					; 64x32
	PLANE_SIZE 128,32					; 128x32
	PLANE_SIZE 32,64					; 32x64
	PLANE_SIZE 64,64					; 64x64
	PLANE_SIZE 32,128					; 32x128

; ------------------------------------------------------------------------------
; Clear tilemap
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.l - VDP command
;	d1.w - Width
;	d2.w - Height
; RETURNS:
;	d0.l - VDP command after last row
; ------------------------------------------------------------------------------

ClearTilemap:
	moveq	#0,d3						; Clear tilemap

; ------------------------------------------------------------------------------
; Fill tilemap
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.l - VDP command
;	d1.w - Width
;	d2.w - Height
;	d3.w - Tile ID
; RETURNS:
;	d0.l - VDP command after last row
; ------------------------------------------------------------------------------

FillTilemap:
	subq.w	#1,d1						; Get width loop count
	bmi.s	.End
	subq.w	#1,d2						; Get height loop count
	bmi.s	.End
	
.Row:
	move.l	d0,VDP_CTRL					; Set VDP command
	move.w	d1,d4						; Get width

.Tile:
	move.w	d3,VDP_DATA					; Draw tile
	dbf	d4,.Tile					; Loop until row is drawn

	add.l	plane_stride,d0					; Next row
	dbf	d2,.Row						; Loop until map is drawn

.End:
	rts

; ------------------------------------------------------------------------------
; Draw tilemap
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.l - VDP command
;	d1.w - Width
;	d2.w - Height
;	d3.w - Base tile ID
;	a0.l - Tilemap data address
; RETURNS:
;	d0.l - VDP command after last row
;	a0.l - End of tilemap data address
; ------------------------------------------------------------------------------

DrawTilemap:
	subq.w	#1,d1						; Get width loop count
	bmi.s	.End
	subq.w	#1,d2						; Get height loop count
	bmi.s	.End
	
.Row:
	move.l	d0,VDP_CTRL					; Set VDP command
	move.w	d1,d4						; Get width

.Tile:
	move.w	(a0)+,d5					; Draw tile
	add.w	d3,d5
	move.w	d5,VDP_DATA
	dbf	d4,.Tile					; Loop until row is drawn

	add.l	plane_stride,d0					; Next row
	dbf	d2,.Row						; Loop until map is drawn

.End:
	rts

; ------------------------------------------------------------------------------
