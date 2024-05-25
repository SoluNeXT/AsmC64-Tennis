#importonce
#import "../main.asm"


SPRITES:{
	.label POINTER0 = $07f8
	
	.label X0 = $d000
	.label Y0 = $d001
	.label COLOR0 = $d027
	.label COLOR1 = $d025
	.label COLOR2 = $d026
	
	.label XMSB = $d010
	.label ENABLE = $d015
	.label MULTICOLOR = $d01c
	.label DBL_WIDTH = $d01d
	.label DBL_HEIGHT = $d01e
	.label BG_PRIORITY = $d01b

	.label MARGIN_LEFT = 24
	.label MARGIN_TOP = 50
}