#importonce
#import "../main.asm"

#import "../def/sprites.asm"

//Functions
	.function SpriteN_PosX(noSprite){
		.return SPRITES.X0 + noSprite * 2
	}

	.function SpriteN_PosY(noSprite){
		.return SPRITES.Y0 + noSprite * 2
	}

	.function SpriteN_Pointer(noSprite){
		.return SPRITES.POINTER0 + noSprite
	}

	.function SpriteN_Color(noSprite){
		.return SPRITES.COLOR0 + noSprite
	}

	.function GetActiveBit(noSprite){
		.return pow(2,noSprite)
	}
	.function GetInvertedBits(noSprite){
		.return 255-pow(2,noSprite)
	}

//Macro pour afficher un sprite ...
	.macro SPR_Afficher(noSprite,index,couleur){
		//noSprite = 0 à 7...
		.if(noSprite < 0 || noSprite > 7){
			.error("noSprite must be between 0 and 7")
		}
		lda SPRITES.ENABLE
		ora #GetActiveBit(noSprite) // (2^0 = 1, 2^1 = 2 ... 2^7 = 128)
		sta SPRITES.ENABLE

		//couleur = 0 à 15
		.if(couleur >= 0 && couleur <= 15){
			lda #couleur
			sta SpriteN_Color(noSprite)
		}

		//index = quel sprite afficher
		//.if(index >= 0 && index <= 255){
			lda #index
			sta SpriteN_Pointer(noSprite)
		//}
	}

	.macro SPR_Cacher(noSprite){
		//noSprite = 0 à 7...
		.if(noSprite < 0 || noSprite > 7){
			.error("noSprite must be between 0 and 7")
		}
		lda SPRITES.ENABLE
		and #GetInvertedBits(noSprite) // (2^0 = 1, 2^1 = 2 ... 2^7 = 128)
		sta SPRITES.ENABLE
	}

	.macro SPR_SetPosX(noSprite,x){
		//noSprite = 0 à 7...
		.if(noSprite < 0 || noSprite > 7){
			.error("noSprite must be between 0 and 7")
		}
		.if(x>255){
			lda SPRITES.XMSB
			ora #GetActiveBit(noSprite)
			sta SPRITES.XMSB
		}else{
			lda SPRITES.XMSB
			and #GetInvertedBits(noSprite)
			sta SPRITES.XMSB
		}
		// noSprite 0 => 7 = d000 => d00e de 2 en 2
		lda #x
		sta SpriteN_PosX(noSprite)
	}

	.macro SPR_SetPosY(noSprite,y){
		//noSprite = 0 à 7...
		.if(noSprite < 0 || noSprite > 7){
			.error("noSprite must be between 0 and 7")
		}
		// noSprite 0 => 7 = d001 => d00f de 2 en 2
		lda #y
		sta SpriteN_PosY(noSprite)
	}

	.macro SPR_SetPos(noSprite,x,y){
		//noSprite = 0 à 7...
		.if(noSprite < 0 || noSprite > 7){
			.error("noSprite must be between 0 and 7")
		}
		:SPR_SetPosX(noSprite,x)
		:SPR_SetPosY(noSprite,y)
	}

	.macro SPR_Down(noSprite,nbPixels,returnNewPos){
		//noSprite = 0 à 7...
		.if(noSprite < 0 || noSprite > 7){
			.error("noSprite must be between 0 and 7")
		}
		.var SPR = SpriteN_PosY(noSprite)
		lda SPR
		clc
		adc #nbPixels
		sta SPR
		.if(returnNewPos == 1){
			tay
		}
	}

	.macro SPR_Up(noSprite,nbPixels,returnNewPos){
		//noSprite = 0 à 7...
		.if(noSprite < 0 || noSprite > 7){
			.error("noSprite must be between 0 and 7")
		}
		.var SPR = SpriteN_PosY(noSprite)
		lda SPR
		sec
		sbc #nbPixels
		sta SPR
		.if(returnNewPos == 1){
			tay
		}
	}

	.macro SPR_Right(noSprite,nbPixels,returnNewPos){
		//noSprite = 0 à 7...
		.if(noSprite < 0 || noSprite > 7){
			.error("noSprite must be between 0 and 7")
		}
		.var SPR = SpriteN_PosX(noSprite)
		lda SPR
		clc
		adc #nbPixels
		sta SPR 
		.if(returnNewPos == 1){
			tax
		}
		// > 255 ???
		bcc non
	oui:
		lda SPRITES.XMSB
		ora #GetActiveBit(noSprite)
		sta SPRITES.XMSB
	non:
		lda SPRITES.XMSB
		and #GetActiveBit(noSprite)
	}

	.macro SPR_Left(noSprite,nbPixels,returnNewPos){
		//noSprite = 0 à 7...
		.if(noSprite < 0 || noSprite > 7){
			.error("noSprite must be between 0 and 7")
		}
		.var SPR = SpriteN_PosX(noSprite)
		lda SPR
		sec
		sbc #nbPixels
		sta SPR
		.if(returnNewPos == 1){
			tax
		}
		// < 0 ???
		bcs non
	oui:
		lda SPRITES.XMSB
		and #GetInvertedBits(noSprite)
		sta SPRITES.XMSB
	non:
		lda SPRITES.XMSB
		and #GetActiveBit(noSprite)
	}
