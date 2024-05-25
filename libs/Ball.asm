#importonce

BALL:{

	Init:{
			:SPR_SetIndex(0,33)
			:SPR_SetColor(0,1)
			:SPR_Afficher(0)
			:SPR_SetX(0,184)
			:SPR_SetY(0,150)
			rts
	}

	//Paramètres...
	DirectionX:
		.byte 0 	// 0 = positif / 1 = négatif
	DirectionY:
		.byte 0 	// 0 = pos / 1 = neg
	SpeedX:
		.byte 0 	// vitesse ... quel que soit le sens pour X
	SpeedY:
		.byte 0 	// vitesse Y

	.label MinX = 24
	.label MaxX = 80 //On sait qu'on rajoute 256 ;)
	.label MinY = 58
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
			lda DirectionY
			cmp #0
			bne yNeg
		yPos:
			lda SPRITES.Y0 
			clc
			adc SpeedY
			sta SPRITES.Y0
			jmp yOK
		yNeg:
			lda SPRITES.Y0
			sec
			sbc SpeedY
			sta SPRITES.Y0
//			jmp yOK
		yOK:
			tay // On stock la valeur de Y dans le registre Y... pour plus tard !
			
			//X...

			lda DirectionX
			cmp #0
			beq xPos
		xNeg:
			lda SPRITES.X0
			sec
			sbc SpeedX
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
			adc SpeedX
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
