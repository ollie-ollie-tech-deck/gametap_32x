; ------------------------------------------------------------------------------
; GameTap 32X
; By Ollie_Ollie_TechDeck
; ------------------------------------------------------------------------------
; RPG stage map routines
; ------------------------------------------------------------------------------

	section m68k_rom_fixed
	include	"source/rpg/shared.inc"
	
; ------------------------------------------------------------------------------
; Ollie's bedroom initialization event
; ------------------------------------------------------------------------------

Init_OllieBedroom:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts
	
; ------------------------------------------------------------------------------
; Ollie's bedroom draw event
; ------------------------------------------------------------------------------

Draw_OllieBedroom:
	rts

; ------------------------------------------------------------------------------
; Ollie's bedroom scrolling
; ------------------------------------------------------------------------------

Scroll_OllieBedroom:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Ollie's bathroom initialization event
; ------------------------------------------------------------------------------

Init_OllieBathroom:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Ollie's bathroom draw event
; ------------------------------------------------------------------------------

Draw_OllieBathroom:
	rts

; ------------------------------------------------------------------------------
; Ollie's bathroom scrolling
; ------------------------------------------------------------------------------

Scroll_OllieBathroom:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Ollie's living room initialization event
; ------------------------------------------------------------------------------

Init_OllieLivingRoom:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Ollie's living room draw event
; ------------------------------------------------------------------------------

Draw_OllieLivingRoom:
	rts

; ------------------------------------------------------------------------------
; Ollie's living room scrolling
; ------------------------------------------------------------------------------

Scroll_OllieLivingRoom:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Ollie's dining room initialization event
; ------------------------------------------------------------------------------

Init_OllieDiningRoom:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Ollie's dining room draw event
; ------------------------------------------------------------------------------

Draw_OllieDiningRoom:
	rts

; ------------------------------------------------------------------------------
; Ollie's dining room scrolling
; ------------------------------------------------------------------------------

Scroll_OllieDiningRoom:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Outside of Ollie's house initialization event
; ------------------------------------------------------------------------------

Init_OllieOutside:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Outside of Ollie's house draw event
; ------------------------------------------------------------------------------

Draw_OllieOutside:
	rts

; ------------------------------------------------------------------------------
; Outside of Ollie's house scrolling
; ------------------------------------------------------------------------------

Scroll_OllieOutside:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Ollie's garage initialization event
; ------------------------------------------------------------------------------

Init_OllieGarage:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Ollie's garage draw event
; ------------------------------------------------------------------------------

Draw_OllieGarage:
	rts

; ------------------------------------------------------------------------------
; Ollie's garage scrolling
; ------------------------------------------------------------------------------

Scroll_OllieGarage:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; 7-Eleven street initialization event
; ------------------------------------------------------------------------------

Init_7ElevenStreet:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; 7-Eleven street draw event
; ------------------------------------------------------------------------------

Draw_7ElevenStreet:
	rts

; ------------------------------------------------------------------------------
; 7-Eleven street scrolling
; ------------------------------------------------------------------------------

Scroll_7ElevenStreet:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; 7-Eleven store initialization event
; ------------------------------------------------------------------------------

Init_7ElevenStore:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; 7-Eleven store draw event
; ------------------------------------------------------------------------------

Draw_7ElevenStore:
	rts

; ------------------------------------------------------------------------------
; 7-Eleven store scrolling
; ------------------------------------------------------------------------------

Scroll_7ElevenStore:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Hospital room initialization event
; ------------------------------------------------------------------------------

Init_HospitalRoom:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Hospital room draw event
; ------------------------------------------------------------------------------

Draw_HospitalRoom:
	rts

; ------------------------------------------------------------------------------
; Hospital room scrolling
; ------------------------------------------------------------------------------

Scroll_HospitalRoom:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Hospital hallway initialization event
; ------------------------------------------------------------------------------

Init_HospitalHallway:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Hospital hallway draw event
; ------------------------------------------------------------------------------

Draw_HospitalHallway:
	rts

; ------------------------------------------------------------------------------
; Hospital hallway scrolling
; ------------------------------------------------------------------------------

Scroll_HospitalHallway:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Outside of hospital initialization event
; ------------------------------------------------------------------------------

Init_HospitalOutside:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y
	
	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	
	jsr	SpawnObject					; Spawn fog
	move.l	#ObjFog,obj.update(a1)
	rts

; ------------------------------------------------------------------------------
; Outside of hospital draw event
; ------------------------------------------------------------------------------

Draw_HospitalOutside:
	rts

; ------------------------------------------------------------------------------
; Outside of hospital scrolling
; ------------------------------------------------------------------------------

Scroll_HospitalOutside:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Prison initialization event
; ------------------------------------------------------------------------------

Init_Prison:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y

	move.b	#%11,map_fg_flags				; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Prison draw event
; ------------------------------------------------------------------------------

Draw_Prison:
	rts

; ------------------------------------------------------------------------------
; Prison scrolling
; ------------------------------------------------------------------------------

Scroll_Prison:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
; Scary Maze initialization event
; ------------------------------------------------------------------------------

Init_RpgScaryMaze:
	clr.l	camera_bg_x					; Set background camera position
	clr.l	camera_bg_y

	clr.b	map_fg_flags					; Initialize map drawing
	clr.b	map_bg_flags
	rts

; ------------------------------------------------------------------------------
; Scary Maze draw event
; ------------------------------------------------------------------------------

Draw_RpgScaryMaze:
	rts

; ------------------------------------------------------------------------------
; Scary Maze scrolling
; ------------------------------------------------------------------------------

Scroll_RpgScaryMaze:
	jmp	ScrollStatic					; Scroll map

; ------------------------------------------------------------------------------
