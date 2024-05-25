#importonce
#import "../main.asm"


#import "../def/vic.asm"

.macro VIC_SetBorderColor(color){
	.if(color < 0){
		.error("color must be positive")
	}
		lda #mod(color,16)
		sta VIC.BORDER_COLOR
}

.macro VIC_IncBorderColor(){
		inc VIC.BORDER_COLOR
}
.macro VIC_DecBorderColor(){
		dec VIC.BORDER_COLOR
}

.macro VIC_SetBorderColorSafe(color){
	.if(color < 0){
		.error("color must be positive")
	}
		pha
		lda #mod(color,16)
		sta VIC.BORDER_COLOR
		pla
}

/* 
 * bordercolor, backgroundcolor : 0->15 or -1 if not set
 * 						   safe	: 0 = no / other = yes 
 */
.macro VIC_SetScreenColors(bordercolor,backgroundcolor, safe){
	.if(bordercolor < -1 || bordercolor > 15){
		.error("bordercolor must be between 0 and 15 or -1 to skip")
	}
	.if(backgroundcolor < -1 || backgroundcolor > 15){
		.error("backgroundcolor must be between 0 and 15 or -1 to skip")
	}
	.if(bordercolor == -1 && backgroundcolor == -1){
		.error("bordercolor & backgroundcolor are both -1")
	}
	.if(safe != 0){
		pha
	}
	.if(bordercolor != -1){
		lda #mod(bordercolor,16)
		sta VIC.BORDER_COLOR
	}
	.if(backgroundcolor != -1){
		.if(backgroundcolor != bordercolor){
			lda #mod(backgroundcolor,16)
		}
			sta VIC.BACKGROUND_COLOR
	}
	.if(safe != 0){
		pla
	}
}


.macro VIC_SetBackgroundColor(color){
	.if(color < 0){
		.error("color must be positive")
	}
		lda #mod(color,16)
		sta VIC.BACKGROUND_COLOR
}

.macro VIC_SetMultiColor1(color) {
	.if(color < 0){
		.error("color must be positive")
	}
	lda #mod(color,16)
	sta VIC.MULTICOLOR1
}

.macro VIC_SetMultiColor(color1, color2){
	VIC_SetMultiColor1(color1)
	VIC_SetMultiColor2(color2)
}

.macro VIC_SetMultiColor2(color) {
	.if(color < 0){
		.error("color must be positive")
	}
	lda #mod(color,16)
	sta VIC.MULTICOLOR2
}

//screen : Screen RAM address
//clearByte : code $xx du caractère de remplissage
.macro VIC_FillScreen(screen, clearChar) {
	lda #clearChar
	ldx #250
!loop:
	dex
	sta screen, x
	sta screen + 250, x
	sta screen + 500, x
	sta screen + 750, x
	bne !loop-
}

//screen Screen RAM address
//fill with space $20 char
.macro VIC_ClearScreenSpace(screen) {
	VIC_FillScreen(screen,32)
}

//fill with clearByte $xx color
.macro VIC_FillColorRam(color) {
	lda #color
	ldx #250
!loop:
	dex
	sta $D800, x
	sta $D800 + 250, x
	sta $D800 + 500, x
	sta $D800 + 750, x
	bne !loop-
}

//fill with black color
.macro VIC_ClearColorRam() {
	VIC_FillColorRam(0)
}

// LINE 0=>310
.macro VIC_WaitRasterLine(line){
	.if(line > 311 || line < 0){
		.error("RasterLine out of range 0>311")
	}

	.if(line > 55 && line < 256){
		lda #line
	!loop:
		cmp VIC.RASTER_LINE
		bne !loop-
	}else{
	!wait:
		lda #mod(line,256)
	!loop:
		cmp VIC.RASTER_LINE
		bne !loop-

		lda VIC.RASTER_LINE_MSB
		and #%10000000
		.if(line>255)
			beq !wait-
		else
			bne !wait-
	}
}