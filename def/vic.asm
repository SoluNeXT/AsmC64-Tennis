#importonce

VIC:{

	.label BORDER_COLOR = $d020
	.label BACKGROUND_COLOR = $d021

	// 40 * 25 = 1000 aracctères sur l'écran...
	.label CHAR_WIDTH = 40
	.label CHAR_HEIGHT = 25

	.label SCREEN_RAM = $0400
	.label COLOR_RAM = $d800
	
	.label RASTER = $d012
	// PAL => 50 images seconde... une ligne dessinée 50 fois par secondes...
	// écran = 310 lignes (écran de la ligne 50...comme la marge haute, jusque 249)

	.label JOY1 = $dc01
	.label JOY2 = $dc00


}