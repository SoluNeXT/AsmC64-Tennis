#importonce

#import "../main.asm"


MENU:{


	textTitre1:
		.text "vintage  "
	textTitre2:
		.text "tennis"

	textMenu1:
		.text "players :"
	textMenu2:
		.text "level   :"
	textMenu3:
		.text "win pts :"
	textMenu4:
		.text "launch   "

	Init:{

			//Fond du jeu
			jsr GAME.DrawBackGround

			//Titre...
			ldx #0
		loopTitre1:
			lda textTitre1,x
			sta VIC.SCREEN_RAM + 40 * 7 + 7,x

			//Menu
			lda textMenu1,x
			sta VIC.SCREEN_RAM + 40 * 13 + 24,x
			lda textMenu2,x
			sta VIC.SCREEN_RAM + 40 * 15 + 24,x
			lda textMenu3,x
			sta VIC.SCREEN_RAM + 40 * 17 + 24,x
			lda textMenu4,x
			sta VIC.SCREEN_RAM + 40 * 19 + 24,x


			inx
			cpx #9
			bne loopTitre1

			ldx #0
			ldy #0
			lda #<VIC.SCREEN_RAM+40*5+9
			sta TEMP2BYTES
			lda #>VIC.SCREEN_RAM+40*5+9
			sta TEMP2BYTES+1

		loopTitre2:
			lda textTitre2,x
			sta (TEMP2BYTES),y
			clc
			lda TEMP2BYTES
			adc #40
			sta TEMP2BYTES
			lda TEMP2BYTES+1
			adc #0
			sta TEMP2BYTES+1
			inx
			cpx #6
			bne loopTitre2


			lda #2
			sta GAMESTATUS

			jsr ActiverSprites

			rts
	}

	ActiverSprites:{
			:SPR_CacherTous()
			:SPR_SetIndex(0,33)
			:SPR_SetColor(0,1)
			:SPR_Afficher(0)
			rts
	}

	MenuLoop:{
			//Positionner le sprite du menu
			:SPR_SetX(0,24+22*8)
			lda #50 + 11*8
			ldx SELECTEDMENU

		!:
			clc
			adc #16
			dex
			bne !-
			:SPR_SetYwithA(0)




			//Déplacer le sprite du menu
			ldx VIC.JOY2
			cpx PREVJOY2
			beq noChange
			stx PREVJOY2

		//Up ???
		up:
			txa
			and #VIC.JOY_UP
			bne down
			lda SELECTEDMENU
			cmp #1
			beq down
			dec SELECTEDMENU

		//Down ???
		down:
			txa
			and #VIC.JOY_DOWN
			bne left
			lda SELECTEDMENU
			cmp #4
			beq left
			inc SELECTEDMENU

		//Left ???
		left:

		//Right ???
		right:

		//Fire ???
		fire:
			txa
			and #VIC.JOY_FIRE
			bne noChange

			lda SELECTEDMENU
			cmp #1
			beq changeNbPlayers

			cmp #2
			beq changeLevel

			cmp #3
			beq changeScoreToWin

			cmp #4
			beq launchGame

			//Normalement, pas d'autre valeur possible...
			//Mais par sécurité :
			jmp noChange

		changeNbPlayers:
			sec 			// pour une soustraction, on active la retenue!!!
			lda #3
			sbc NBPLAYERS   // 3 - 1 = 2 et 3 - 2 = 1
			sta NBPLAYERS
			jmp endJoy

		changeLevel:
			clc
			inc NIVEAU
			lda NIVEAU
			cmp #6
			bne endJoy
			lda #1
			sta NIVEAU
			jmp endJoy

		changeScoreToWin:
			clc
			lda GAGNANT
			adc #5
			cmp #25
			bne !+
			lda #10
		!:
			sta GAGNANT
			jmp endJoy


		launchGame:
			lda #3
			sta GAMESTATUS


		endJoy:
		noChange:



		// Animer la couleur du srpite de menu...
			ldy MENUANIM
			lda colorFadeLoop,y
			:SPR_SetColorA(0)
			iny
			cpy #colorFadeLoopLength
			bne !+
			ldy #0
		!:
			sty MENUANIM



		// Afficher les valeurs
			clc
			lda NBPLAYERS
			adc #48 // "0" = CHR 48
			sta VIC.SCREEN_RAM+40*13+34

			lda NIVEAU
			adc #48
			sta VIC.SCREEN_RAM+40*15+34

			lda GAGNANT
			ldx #49 // CHR 49 = "1" >> 10 ou 15
			ldy #48 // CHR 48 = "0"

			cmp #10 //Comparaison à 10
			beq gagnant // = 10

			ldx #50 // CHR 50 = "2" >> 20
			cmp #20
			beq gagnant // = 20
			//si on est ici c'est ni 10 ni 20 donc...15 !
			ldx #49 //CHR 49 = "1"
			ldy #53 // CHR 53 = "5"

		gagnant:
			stx VIC.SCREEN_RAM+40*17+34
			sty VIC.SCREEN_RAM+40*17+35




			rts
	}


}