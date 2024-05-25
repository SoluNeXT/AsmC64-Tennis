#importonce

#import "../main.asm"


#import "../def/vic.asm"

.macro SetBorderColor(col){
	lda #col
	sta VIC.BORDER_COLOR
}

.macro SetBackgroundColor(col){
	lda #col 
	sta VIC.BACKGROUND_COLOR
}

.macro Fill1000bytes(mem, val){
	// remplir 1000 octets de mémoire se trouvant à l'adresse mem
	// avec la valeur val...

		lda #val 
		ldx #0

	// 0 < x < 255 >> 1000? => 4 * 250 !
	loop:
		sta mem + 000,x
		sta mem + 250,x
		sta mem + 500,x
		sta mem + 750,x
		inx
		cpx #250
		bne loop
}

.macro FillColor(col){
	:Fill1000bytes(VIC.COLOR_RAM,col)
}

.macro FillScreen(car){
	:Fill1000bytes(VIC.SCREEN_RAM,car)
}

.macro WaitRasterLine(rasterLine){
// valeur = 0 => 311 (312 lignes)

	.if(rasterLine>311)
	{
		.error "Raster line max value is 311"
	}
	.if(rasterLine<0)
	{
		.error "Raster line min value is 0"
	}



	lda #rasterLine
	.if(rasterLine>255)  // 256 => 311
	{
			pha
			txa
			pha
			!:
			ldx VIC.RASTER_MSB
			bpl !-

			cmp VIC.RASTER
			bne !-
			pla
			tax
			pla
	}
	else .if(rasterLine<56) // 312 - 256 = 56
	{
			pha
			txa
			pha
		!:
			ldx VIC.RASTER_MSB
			bmi !-

			cmp VIC.RASTER
			bne !-
			pla
			tax
			pla
	}
	else
	{
			pha
		!:
			cmp VIC.RASTER
			bne !-
			pla
	}
	


}