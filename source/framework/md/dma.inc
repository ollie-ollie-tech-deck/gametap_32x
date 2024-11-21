; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; Ultra DMA queue by Flamewing header
; ------------------------------------------------------------------------------

	global QueueDma
	global FlushDmaQueue
	global InitDmaQueue
	global ResetDmaQueue

; ------------------------------------------------------------------------------
; DMA entry structure
; ------------------------------------------------------------------------------

	rsreset
dma.reg_94		rs.b 1					; Size (high) register ID
dma.size		rs.b 0					; Size register data start
dma.size_h		rs.b 1					; Size (high) register data
dma.reg_93		rs.b 1					; Size (low) register ID
dma.source		rs.b 0					; Source register data start
dma.size_l		rs.b 1					; Size (low) register data

dma.reg_97		rs.b 1					; Source (high) register ID
dma.source_h		rs.b 1					; Source (high) register data
dma.reg_96		rs.b 1					; Source (middle) register ID
dma_source_m		rs.b 1					; Source (middle) register data
dma.reg_95		rs.b 1					; Source (low) register ID
dma.source_l		rs.b 1					; Source (low) register data

dma.vdp_command		rs.l 1					; VDP command
dma.struct_len		rs.b 0					; Size of structure

DMA_ENTRY_COUNT		EQU $20					; Number of DMA entry slots
DMA_QUEUE_SIZE		EQU DMA_ENTRY_COUNT*dma.struct_len	; Size of DMA queue

; ------------------------------------------------------------------------------
	