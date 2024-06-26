#importonce

#import "../main.asm"


#import "../def/sprites.asm"


.function GetActiveBit(noSprite){
	.return pow(2,noSprite)
}
.function GetInvertedBit(noSprite){
	.return 255-GetActiveBit(noSprite)
}

.macro SPR_SetColor(noSprite, col){  // Sprite 0 à 7
	lda #col
	sta SPRITES.COLOR0 + noSprite
}

.macro SPR_SetColorA(noSprite){
	sta SPRITES.COLOR0 + noSprite
}

.macro SPR_SetIndex(noSprite, index){
	lda #index
	sta SPRITES.INDEX0 + noSprite
}

.macro SPR_Afficher(noSprite){
	lda SPRITES.ENABLE
	ora #GetActiveBit(noSprite) // sprite 0 : 2^0 = 1... Sprite 1 : 2^1 = 2... etc 7 : 2^7 = 128
	sta SPRITES.ENABLE
}

.macro SPR_Cacher(noSprite){
	lda SPRITES.ENABLE
	and #GetInvertedBit(noSprite) // sprite 0 : 2^0 = 1... Sprite 1 : 2^1 = 2... etc 7 : 2^7 = 128
	sta SPRITES.ENABLE
}

.macro SPR_CacherTous(){
	lda #0
	sta SPRITES.ENABLE
}

.macro SPR_SetX(noSprite, x){
	.if(x>255){
		lda SPRITES.XMSB
		ora #GetActiveBit(noSprite)
		sta SPRITES.XMSB
	}else{
		lda SPRITES.XMSB
		and #GetInvertedBit(noSprite)
		sta SPRITES.XMSB
	}


	lda #x
	sta SPRITES.X0 + noSprite * 2
}

.macro SPR_SetY(noSprite, y){
	lda #y
	sta SPRITES.Y0 + noSprite * 2
}

.macro SPR_SetYwithA(noSprite){
	sta SPRITES.Y0 + noSprite * 2
}

.macro SPR_DblYOn(noSprite){
	lda SPRITES.DBL_Y
	ora #GetActiveBit(noSprite)
	sta SPRITES.DBL_Y
}

.macro SPR_DblXOn(noSprite){
	lda SPRITES.DBL_X
	ora #GetActiveBit(noSprite)
	sta SPRITES.DBL_X
}

.macro SPR_DblXOff(noSprite){
	lda SPRITES.DBL_X
	and #GetInvertedBit(noSprite)
	sta SPRITES.DBL_X
}

.macro SPR_DblYOff(noSprite){
	lda SPRITES.DBL_Y
	and #GetInvertedBit(noSprite)
	sta SPRITES.DBL_Y
}
