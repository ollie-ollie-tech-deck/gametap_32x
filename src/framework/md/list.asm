; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; List functions
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"src/framework/md.inc"
	
; ------------------------------------------------------------------------------
; Initialize list
; ------------------------------------------------------------------------------
; PARAMETERS:
;	d0.w - Item size (item header included)
;	d1.w - Number of items
;	a0.l - List address
; ------------------------------------------------------------------------------

InitList:
	clr.l	list.head(a0)					; Reset head and tial
	clr.w	list.freed(a0)					; Reset freed items tail
	move.w	d0,list.item_size(a0)				; Set item size
	
	mulu.w	d1,d0						; Set end of list
	addi.w	#list.struct_len,d0
	add.w	a0,d0
	move.w	d0,list.end(a0)

	move.w	a0,d0						; Reset cursor
	addi.w	#list.struct_len,d0
	add.w	list.item_size(a0),d0
	move.w	d0,list.cursor(a0)

	subq.w	#1,d1						; Item loop count
	lea	list.struct_len(a0),a1				; Item pool
	moveq	#0,d0						; Clear value

.SetupItems:
	move.l	d0,(a1)+					; Reset links
	move.w	d0,(a1)+

	move.w	list.item_size(a0),d2				; Item data loop count
	subq.w	#item.struct_len,d2
	lsr.w	#1,d2
	subq.w	#1,d2

.ClearItem:
	move.w	d0,(a1)+					; Clear item data
	dbf	d2,.ClearItem					; Loop until item data is cleared
	dbf	d1,.SetupItems					; Loop until all items are set up
	rts

; ------------------------------------------------------------------------------
; Reset list
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - List address
; ------------------------------------------------------------------------------

ResetList:
	clr.l	list.head(a0)					; Reset list
	clr.w	list.freed(a0)					; Reset freed item tail
	
	move.w	a0,d0						; Reset cursor
	addi.w	#list.struct_len,d0
	add.w	list.item_size(a0),d0
	move.w	d0,list.cursor(a0)

	clr.l	list.struct_len+item.next(a0)			; Reset next and previous links in first item
	rts

; ------------------------------------------------------------------------------
; Add list item
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - List address
; RETURNS:
;	eq/ne - Success/Failure
;	a1.l  - Allocated list item
; ------------------------------------------------------------------------------

AddListItem:
	tst.w	list.head(a0)					; Are there any items?
	beq.s	.NoItems					; If not, branch

; ------------------------------------------------------------------------------

	move.w	list.freed(a0),d0				; Were there any items that were freed?
	beq.s	.Append						; If not, branch
	
	movea.w	d0,a1						; If so, retrieve item
	move.w	item.next(a1),list.freed(a0)			; Set next free item

; ------------------------------------------------------------------------------

.SetLinks:
	movea.w	list.tail(a0),a2				; Get list tail
	move.w	a1,list.tail(a0)

	move.w	a1,item.next(a2)				; Set links
	move.w	a2,item.previous(a1)
	clr.w	item.next(a1)
	move.w	a0,item.list(a1)
	
	ori	#4,sr						; Success
	rts

; ------------------------------------------------------------------------------

.Append:
	move.w	list.cursor(a0),d0				; Get cursor
	cmp.w	list.end(a0),d0					; Is there no more room?
	bcc.s	.Fail						; If so, branch

	movea.w	d0,a1
	add.w	list.item_size(a0),d0				; Advance cursor
	move.w	d0,list.cursor(a0)

	bra.s	.SetLinks					; Set links

; ------------------------------------------------------------------------------

.Fail:
	andi	#~4,sr						; Failure
	rts

; ------------------------------------------------------------------------------

.NoItems:
	lea	list.struct_len(a0),a1				; Allocate at start of list item pool
	move.w	a1,list.head(a0)
	move.w	a1,list.tail(a0)
	move.w	a0,item.list(a1)
	
	ori	#4,sr						; Success
	rts

; ------------------------------------------------------------------------------
; Remove list item
; ------------------------------------------------------------------------------
; PARAMETERS:
;	a1.l  - List item
; RETURNS:
;	eq/ne - End of list/Not end of list
;	a1.l  - Next list item
; ------------------------------------------------------------------------------

RemoveListItem:
	move.w	item.next(a1),-(sp)				; Get next item
	movea.w	item.list(a1),a0				; Get list
	clr.w	item.list(a1)

	cmpa.w	list.head(a0),a1				; Is this the head item?
	beq.s	.Head						; If not, branch
	cmpa.w	list.tail(a0),a1				; Is this the tail item?
	beq.s	.Tail						; If so, branch

; ------------------------------------------------------------------------------

.Middle:
	movea.w	item.previous(a1),a2				; Fix links
	move.w	item.next(a1),item.next(a2)
	movea.w	item.next(a1),a2
	move.w	item.previous(a1),item.previous(a2)

; ------------------------------------------------------------------------------

.AppendFreed:
	move.w	list.freed(a0),d0				; Get freed list tail
	beq.s	.FirstFreed					; If there are no freed items, branch

	move.w	d0,item.next(a1)				; Set links
	move.w	a1,list.freed(a0)
	bra.s	.Finish	

.FirstFreed:
	move.w	a1,list.freed(a0)				; Set first freed item
	clr.w	item.next(a1)

; ------------------------------------------------------------------------------

.Finish:
	lea	item.struct_len(a1),a1				; Item data
	move.w	list.item_size(a0),d0				; Clear loop count
	subq.w	#item.struct_len,d0
	lsr.w	#1,d0
	subq.w	#1,d0
	moveq	#0,d1						; Zero

.ClearItem:
	move.w	d1,(a1)+					; Clear item data
	dbf	d0,.ClearItem					; Loop until item data is cleared

	movea.w	(sp)+,a1					; Get next item
	cmpa.w	#0,a1						; Check if next item exists
	rts

; ------------------------------------------------------------------------------

.Tail:
	movea.w	item.previous(a1),a2				; Fix links
	move.w	a2,list.tail(a0)
	clr.w	item.next(a2)

	bra.s	.AppendFreed					; Append freed items

; ------------------------------------------------------------------------------

.Head:
	cmpa.w	list.tail(a0),a1				; Is this also the tail item?
	beq.s	.Last						; If so, branch

	movea.w	item.next(a1),a2				; Fix links
	move.w	a2,list.head(a0)
	clr.w	item.previous(a2)

	bra.s	.AppendFreed					; Append freed items

; ------------------------------------------------------------------------------

.Last:
	bsr.w	ResetList					; Reset list
	clr.w	(sp)
	bra.s	.Finish

; ------------------------------------------------------------------------------
