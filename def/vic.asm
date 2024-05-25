#importonce
#import "../main.asm"


VIC:{

	.label BORDER_COLOR = $d020
	.label BACKGROUND_COLOR = $d021
	.label MULTICOLOR1 = $d022
	.label MULTICOLOR2 = $d023
	.label MULTICOLOR_MODE = $d016

	.label RASTER_LINE = $d012
	.label RASTER_LINE_MSB = $d011

	.label SCREEN_RAM = $0400
	.label COLOR_RAM = $d800

	.label SCREEN_MEMORY = $d018
	.label VIC_BANK_ADDRESS = $dd00
	.label VIC_MEMORY_ACCESS = $01

	.label PIXEL_WIDTH = 320
	.label PIXEL_HEIGHT = 200
	.label CHAR_WIDTH = 40
	.label CHAR_HEIGHT = 25

}