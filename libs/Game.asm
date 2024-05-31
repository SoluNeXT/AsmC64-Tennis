#importonce

#import "../main.asm"

GAME:{

	.label TIMEBEFORELAUNCH = 100 // 2 secondes

	//Score et niveau en haut de l'écran ...
	textPlayer1:
	.text "player 1:99"
	textPlayer2:
	.text "99:player 2"
	textCPU:
	.text "99:computer"
	textNiveau:
	.text "niveau:0   "
	textWin:
	.text "  win!  "

	.label textCPUwin = textCPU + 3
	.label textP1win  = textPlayer1
	.label textP2win  = textPlayer2 + 3

	RootInit:{

			lda #1
			sta GAMESTATUS
			sta NBPLAYERS
			sta NIVEAU
			sta SELECTEDMENU
			lda #10
			sta GAGNANT

			lda #TIMEBEFORELAUNCH
			sta CPU_WAITLAUNCH



			rts

	}

	Init:{
			//background
			jsr DrawBackGround

			//Mettre les scores des joueurs à 0
			ldx #0
			stx SCORE1
			stx SCORE2
			clc

			//Textes en haut (score, niveau)
			//ldx #0
		loop:
			lda textPlayer1,x
			adc #128
			sta VIC.SCREEN_RAM,x

			ldy NBPLAYERS
			cpy #1
			beq vsCPU

			lda textPlayer2,x
			jmp next

		vsCPU:
			lda textCPU,x
		next:
			clc
			adc #128
			sta VIC.SCREEN_RAM+29,x

			lda textNiveau,x
			adc #128
			sta VIC.SCREEN_RAM+16,x



			inx
			cpx #11
			bne loop

			// Afficher et positionner les raquettes
			:SPR_SetIndex(1,34) // Sprite 1 (joueur 1) = pointer 34
			:SPR_SetIndex(2,34) // Sprite 2 (j2 / cpu) = pointer 34
			:SPR_SetColor(1,1) // Blanc
			:SPR_SetColor(2,1) // Blanc
			:SPR_SetX(1,J1PosX)
			:SPR_SetX(2,J2PosX)
			:SPR_SetY(1,50+78)
			:SPR_SetY(2,50+78)
			:SPR_DblYOn(1)
			:SPR_DblYOn(2)
			:SPR_Afficher(1)
			:SPR_Afficher(2)

			//Qui commence le jeu ??? J1 ou J2/CPU ???
			jsr FN.GetRandom
			and #1 //0 ou 1
			sta LAUNCHER

			// Positionner la balle
			:SPR_SetIndex(0,33) // Sprite 0 : la balle pointer33
			:SPR_SetColor(0,1)
			:SPR_Afficher(0)
			// start position... à chaque nouvelle balle !
			jsr SetInitialBallPosition // en fonction du joueur qui lance...



			// Passer au lancement de la balle
			lda #4
			sta GAMESTATUS

			rts
	}

	SetInitialBallPosition:{
			jsr FN.GetRandom // pour la hauteur de la balle
			and #127
			clc
			adc #86
			:SPR_SetYwithA(0)
			
			lda LAUNCHER
			lsr
			bcs player2

		player1:
			:SPR_SetX(0,J1PosX+32)
			lda #0
			jmp next

		player2:
			:SPR_SetX(0,J2PosX-32-TailleBalle)
			lda #1

		next:
			sta DIRECTIONX
			
			lda NIVEAU
			sta SPEEDX
			lda #1
			sta SPEEDY

			jsr FN.GetRandom
			and #1
			sta DIRECTIONY

			rts
	}

	WaitLaunch:{
			jsr HEADER.DisplayScore	//Pour afficher le score des joueurs... et le niveau
			jsr MovingPlayer		//Pour bouger les raquettes, même quand la balle n'est pas lancée

			//Boucle pour attendre le lancement de la balle (que ce ne soit pas immédiat)
			lda CPU_WAITLAUNCH
			cmp #0
			beq launchPossible
			dec CPU_WAITLAUNCH
			rts

		launchPossible:
		//.break
			clc
			lda LAUNCHER
			beq waitP1

			lda NBPLAYERS
			and #2
			beq waitCPU

		waitP2:
			lda VIC.JOY1
			jmp waitFire

		waitP1:
			lda VIC.JOY2

		waitFire:
			and #VIC.JOY_FIRE
			beq launch
			rts

		waitCPU:
			// pas d'attente >> launch

		launch:
			lda #5
			sta GAMESTATUS
			rts


	}

	MovingPlayer:{
			//Player 1
			jsr MoveP1

			//Player 2/CPU
			lda NBPLAYERS
			and #1
			bne moveCPU

		moveP2:
			//jsr MoveP2
			//rts
			jmp MoveP2

		moveCPU:
			//jsr MoveCPU
			//rts
			jmp MoveCPU
	}

	MoveP1:{
			ldx VIC.JOY2
			txa
			and #VIC.JOY_UP
			beq goUp
			txa
			and #VIC.JOY_DOWN
			beq goDown
			rts

		goUp:
			lda SPRITES.Y1
			clc
			sbc NIVEAU

			cmp #MinY-1
			bcs !+
			lda #MinY-1
		!:
			sta SPRITES.Y1
			rts

		goDown:
			lda SPRITES.Y1
			sec
			adc NIVEAU

			cmp #MaxY-HauteurRaquette
			bcc !+
			lda #MaxY-HauteurRaquette
		!:
			sta SPRITES.Y1
			rts
	}

	MoveP2:{
			ldx VIC.JOY1
			txa
			and #VIC.JOY_UP
			beq goUp
			txa
			and #VIC.JOY_DOWN
			beq goDown
			rts

		goUp:
			lda SPRITES.Y2
			clc
			sbc NIVEAU

			cmp #MinY-1
			bcs !+
			lda #MinY-1
		!:
			sta SPRITES.Y2
			rts

		goDown:
		//.break
			lda SPRITES.Y2
			sec
			adc NIVEAU

			cmp #MaxY-HauteurRaquette
			bcc !+
			lda #MaxY-HauteurRaquette
		!:
			sta SPRITES.Y2
			rts
	}

	MoveCPU:{
			ldx SPRITES.Y2
			txa
			clc
			adc #(HauteurRaquette-TailleBalle) / 2 + TailleBalle
			cmp SPRITES.Y0
			bcc goDown

			txa
			clc
			adc #(HauteurRaquette-TailleBalle) / 2 - TailleBalle
			cmp SPRITES.Y0
			bcs goUp
			rts

		goUp:
			lda SPRITES.Y2
			sec
			sbc NIVEAU
			cmp #MinY-1
			bcs !+
			lda #MinY-1
		!:
			sta SPRITES.Y2
			rts

		goDown:
			lda SPRITES.Y2
			sec
			adc NIVEAU

			cmp #MaxY+TailleBalle-HauteurRaquette
			bcc !+
			lda #MaxY+TailleBalle-HauteurRaquette
		!:
			sta SPRITES.Y2
			rts

	}

	DrawBackGround:{
	
			//Colors
			:SetBorderColor(0)
			:SetBackgroundColor(6)

			//ClearScreen
			:FillScreen(32) //Espaces
			:FillColor(1) //Blanc

			//Elements du fond:
			//Horizontaux
			ldx #0
		!:
			lda #$A0 // 160 = espace inversé
			sta VIC.SCREEN_RAM,x

			lda #$63 // barre haute blanche
			sta VIC.SCREEN_RAM+40,x

			lda #$64 //barre basse blanche
			sta VIC.SCREEN_RAM+40*24,x

			inx
			cpx #40
			bne !-







			//Verticaux
			lda #<VIC.SCREEN_RAM + 100
			sta TEMP2BYTES
			lda #>VIC.SCREEN_RAM + 100
			sta TEMP2BYTES + 1

			ldx #0
			ldy #0
		!:
			lda #$65 // barre verticale
			sta (TEMP2BYTES),y

			clc
			lda TEMP2BYTES
			adc #120
			sta TEMP2BYTES
			lda TEMP2BYTES + 1
			adc #0
			sta TEMP2BYTES + 1

			inx
			cpx #8
			bne !-

			rts
	}



	Running:{
			// Déplacement des joueurs
			jsr MovingPlayer

			// Déplacement de la balle
			jsr BALL.Move

			// Test position de la balle par rapport aux raquettes
			jsr TestRaquettes

			// Afficher le score
			jsr HEADER.DisplayScore


			rts
	}

	TestRaquettes:{
			//On a dans Y la position Y de la balle, 
			//et dans X la position X de la balle avec A=0 si X<256 et A=1 si X>255

			//On va se mettre Y de côté pour plus tard...
			sty TEMP1


			// Vérification de la position de X
			// Dans quelle sens va la balle ???
			ldy DIRECTIONX

			cpy #0 // positif donc vers joueur 2
			beq testRaquetteJ2

		testRaquetteJ1:
			//ici, Y = 1 ...
			cmp #0 // est-ce que X > 255 ?
			beq oui
		non:
			rts
		oui:
			//On va tester si la balle a dépassé la raquette...
			cpx #J1PosX -1
			bcc J1RateBalle

			cpx #J1PosX + EpaisseurRaquette
			bcs non
		zone2contactJ1:
			//On va vérifier Y ici...
			lda TEMP1 //On récupère Y
			//On compare avec la position de la raquette
			cmp SPRITES.Y1 //Joueur 1
			bcc audessus
			sec
			sbc #HauteurRaquette
			cmp SPRITES.Y1
			bcs endessous
			//Ici on touche la raquette
			//donc on inverse la direction de la balle
			lda DIRECTIONX
			eor #1
			sta DIRECTIONX


		audessus:
		endessous:


		testRaquetteJ2:
			cmp #0 // est-ce que X > 255 ?
			bne oui2
		non2:
			rts
		oui2:
			//On va tester si la balle a dépassé la raquette...
			cpx #J2PosX + EpaisseurRaquette
			bcs J2RateBalle

			cpx #J2PosX - TailleBalle + 1
			bcc non2
		zone2contactJ2:
			//On va vérifier Y ici...
			lda TEMP1 //On récupère Y
			//On compare avec la position de la raquette
			cmp SPRITES.Y2 //Joueur 2
			bcc audessus2
			sec
			sbc #HauteurRaquette
			cmp SPRITES.Y2
			bcs endessous2
			//Ici on touche la raquette
			//donc on inverse la direction de la balle
			lda DIRECTIONX
			eor #1
			sta DIRECTIONX


		audessus2:
		endessous2:


			rts

		J1RateBalle:
			lda #7
			sta GAMESTATUS
			rts

		J2RateBalle:
			lda #6
			sta GAMESTATUS
			rts			
	}

	P1Mark:{
			clc
			inc SCORE1
			lda SCORE1
			cmp GAGNANT
			beq p1win

			lda #1
			sta LAUNCHER
			jsr SetInitialBallPosition

			lda NBPLAYERS
			cmp #1
			beq vsCPU

			lda #1
			jmp next

		vsCPU:
			lda #TIMEBEFORELAUNCH

		next:
			sta CPU_WAITLAUNCH

			lda #4
			sta GAMESTATUS

			jmp HEADER.DisplayScore

		p1win:
			lda #8
			sta GAMESTATUS
			lda #0
			sta LAUNCHER
			sta MENUANIM
			jmp HEADER.DisplayScore
	}

	P2Mark:{
			clc
			inc SCORE2
			lda SCORE2
			cmp GAGNANT
			beq p2win

			lda #0
			sta LAUNCHER
			jsr SetInitialBallPosition

			lda #1
			sta CPU_WAITLAUNCH

			lda #4
			sta GAMESTATUS

			jmp HEADER.DisplayScore

		p2win:
			lda #8
			sta GAMESTATUS
			lda #0
			sta LAUNCHER
			sta MENUANIM
			jmp HEADER.DisplayScore
	}

	GameWin:{
			ldx MENUANIM
			inx
			cpx #colorFadeLoopLength
			bne !+
			ldx #0
		!:
			stx MENUANIM
			lda colorFadeLoop,x
			tay

			lda LAUNCHER
			cmp #0 //P1 launcher donc P2 win
			beq p2win

		p1win:
			ldx #0
		!:
			lda textWin,x
			sta VIC.SCREEN_RAM + 40*11 + 6,x
			lda textP1win,x
			sta VIC.SCREEN_RAM + 40*10 + 6,x
			tya
			sta VIC.COLOR_RAM + 40*10 + 6,x
			sta VIC.COLOR_RAM + 40*11 + 6,x
			inx
			cpx #8
			bne !-
			jmp waitForClick

		p2win:
			ldx #0
		!:
			lda textWin,x
			sta VIC.SCREEN_RAM + 40*11 + 26,x
			lda NBPLAYERS
			cmp #2
			beq vsP2
		vsCPU:
			lda textCPUwin,x
			jmp next

		vsP2:	
			lda textP2win,x

		next:
			sta VIC.SCREEN_RAM + 40*10 + 26,x

			tya
			sta VIC.COLOR_RAM + 40*10 + 26,x
			sta VIC.COLOR_RAM + 40*11 + 26,x
			inx
			cpx #8
			bne !-

		waitForClick:
			lda VIC.JOY1
			and VIC.JOY2
			and #VIC.JOY_FIRE
			bne exit

		click:
			lda #99
			sta GAMESTATUS

		exit:
			rts

	}
}