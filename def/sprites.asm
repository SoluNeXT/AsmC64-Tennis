#importonce

#import "../main.asm"


SPRITES:{

	.label INDEX0 = $07f8

	.label X0 = $d000
	.label Y0 = $d001
	.label X1 = $d002
	.label Y1 = $d003
	.label X2 = $d004
	.label Y2 = $d005
	.label COLOR0 = $d027
	.label COLOR1 = $d025
	.label COLOR2 = $d026

	.label XMSB = $d010 // Position X > 255 !

	.label ENABLE = $d015
	.label DBL_X = $d01d
	.label DBL_Y = $d017
	.label MULTICOLOR = $d01c
	.label BG_PRIORITY = $d01b
	.label COLLISION = $d01e
	.label COLLISION_BG = $d01f

	.label MARGIN_LEFT = 24
	.label MARGIN_TOP = 50

}