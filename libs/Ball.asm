#importonce
#import "../main.asm"

//Include Definitions
#import "../def/vic.asm"
#import "../def/sprites.asm"

//Include macros
#import "../macros/vic.asm"
#import "../macros/sprites.asm"

Ball:{

	//constantes
	.label ballWidth = 8
	.label ballHeight = 8
	.label ballSpeedX = 3
	.label ballSpeedY = 2

	//Datas
	DirectionX: 
			.byte 0 //0 = vers droite - 1 vers la gauche
	DirectionY:
			.byte 0	//0 = descendre - 1 = monter
	SpeedX:
			.byte 1
	SpeedY:
			.byte 1

	Init:{
		:SPR_Afficher(0,SPR_IDX,1)
		:SPR_SetPos(0,40,50)
		//:SPR_SetPosY(0,50)
		rts
	}

	Animer: {
		//Animer la balle... (la balle fait 8x8 pixel)
		// Top = 50
		// Bottom = 200 + 50 - 8 = 242
		// Left = 24
		// Right = 320 + 24 - 8 = 336 (256 + 80)

		TestVertical:{
			//On va commencer par la verticale ...
				lda DirectionY
				cmp #0
				beq descendre
				
			monter:{
					:SPR_Up(0,ballSpeedY,1)
					cpy #SPRITES.MARGIN_TOP + ballSpeedY - 1
					bcs ras
				changerVersBas:
					lda #0
					sta DirectionY
				ras:
					jmp FinTestVertical	
			}
			descendre:{
					:SPR_Down(0,ballSpeedY,1)
					cpy #SPRITES.MARGIN_TOP + VIC.PIXEL_HEIGHT - ballHeight
					bcc ras
				changerVersHaut:
					lda #1
					sta DirectionY
				ras:
					//jmp FinTestVertical	
			}

			FinTestVertical:
		}


		TestHorizontal:{
//.break
				lda DirectionX
				cmp #0
				beq droite

			gauche:{
					:SPR_Left(0,ballSpeedX,1)
					cmp #1
					beq ras
					cpx #SPRITES.MARGIN_LEFT + ballSpeedX - 1
					bcs ras
				changerVersDroite:
					lda #0
					sta DirectionX
				ras:
					jmp FinTestHorizontal	
			}

			droite:{
					:SPR_Right(0,ballSpeedX,1)
					cmp #0
					beq ras
					cpx #mod(SPRITES.MARGIN_LEFT + VIC.PIXEL_WIDTH - ballWidth,256)
					bcc ras
				changerVersgauche:
					lda #1
					sta DirectionX
				ras:
					//jmp FinTestHorizontal	
			}

			FinTestHorizontal:
		}

		FinAnimation:
			rts
	}


}