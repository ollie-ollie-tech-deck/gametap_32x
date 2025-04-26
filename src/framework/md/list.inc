; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; List functions header
; ------------------------------------------------------------------------------

	global InitList
	global ResetList
	global AddListItem
	global RemoveListItem

; ------------------------------------------------------------------------------
; List header structure
; ------------------------------------------------------------------------------

	rsreset
list.head		rs.w 1					; List head
list.tail		rs.w 1					; List tail
list.freed		rs.w 1					; Freed items tail
list.item_size		rs.w 1					; Size of item
list.cursor		rs.w 1					; Cursor
list.end		rs.w 1					; End of list
list.struct_len		rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; List item header structure
; ------------------------------------------------------------------------------

	rsreset
item.next		rs.w 1					; Next item
item.previous		rs.w 1					; Previous item
item.list		rs.w 1					; List the item is part of
item.struct_len		rs.b 0					; Length of structure

; ------------------------------------------------------------------------------
; List item pool
; ------------------------------------------------------------------------------

LIST_POOL macro size, count
	rs.b list.struct_len+((\size)*(\count))
	endm

; ------------------------------------------------------------------------------
