#importonce

#import "../main.asm"


BALL:{

	//Paramètres...
	DirectionX:
		.byte 0 	// 0 = positif / 1 = négatif
	DirectionY:
		.byte 0 	// 0 = pos / 1 = neg
	SpeedX:
		.byte 0 	// vitesse ... quel que soit le sens pour X
	SpeedY:
		.byte 0 	// vitesse Y

	.label MinX = 25
	.label MaxX = 80 //On sait qu'on rajoute 256 ;)
	.label MinY = 59
	.label MaxY = 242

	SetX:{
		// a = vitesse et x = direction (0 ou 1)
		sta SpeedX
		stx DirectionX
		rts
	}

	SetY:{
		// a = vitesse et x = direction (0 ou 1)
		sta SpeedY
		stx DirectionY
		rts
	}





	Move:{
		//On reçoit x et y à rajouter aux X et Y de la balle...
			//Y...
			lda DIRECTIONY
			cmp #0
			bne yNeg
		yPos:
			lda SPRITES.Y0 
			clc
			adc SPEEDY
			cmp #MaxY
			bcc !+
			lda DIRECTIONY
			eor #1
			sta DIRECTIONY
			lda #MaxY
		!:
			sta SPRITES.Y0
			jmp yOK
		yNeg:
			lda SPRITES.Y0
			sec
			sbc SPEEDY
			cmp #MinY+1
			bcs !+
			lda DIRECTIONY
			eor #1
			sta DIRECTIONY
			lda #MinY+1
		!:
			sta SPRITES.Y0
//			jmp yOK
		yOK:
			tay // On stock la valeur de Y dans le registre Y... pour plus tard !
			

			//X...
			lda DIRECTIONX
			cmp #0
			beq xPos
		xNeg:
			lda SPRITES.X0
			sec
			sbc SPEEDX
			sta SPRITES.X0
			tax // pour plus tard...
			bpl xOK
		xInf255:
			lda SPRITES.XMSB
			and #%11111110
			sta SPRITES.XMSB
			jmp xOK
		xPos:
			lda SPRITES.X0 
			clc
			adc SPEEDX
			sta SPRITES.X0 
			tax
			bcc xOK
		xSup255:
			lda SPRITES.XMSB
			ora #%00000001
			sta SPRITES.XMSB
		xOK:
			lda SPRITES.XMSB
			and #%00000001     // Retourne 0 si w 255 et 1 si > 255 dans A
			// retour
			rts
	}




}
