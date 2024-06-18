#importonce

#import "../main.asm"


.label TEMP1 = $03 // Variable temporaire sur 1 octet
.label TEMP2 = $04 // Variable temporaire sur 1 octet
.label TEMP2BYTES = $03 // Variable temporaire sur 2 octets

.label NBPLAYERS = $02 //1 = 1 joueur (contre le CPU) ... 2 = 2 joueurs
.label NIVEAU = $05 // 1 à 5
.label GAGNANT = $06 // 10 points, 15 points, 20 points
.label SELECTEDMENU = $07
.label PREVJOY2 = $08
.label PREVJOY1 = $09
.label MENUANIM = $0A
.label GAMESTATUS = $0B // On a 8 status de jeu...
						//	1 = Init Menu
						//	2 = Looop Menu
						//  3 = Init Game
						//  4 = Game wait for launch ball
						//  5 = Looooop Game 
						//  6 = Player 1 Mark point
						//  7 = Player 2 (or CPU) Mark point
						//  8 = Game End (player 1 or 2 win)
						//  other >> Reset to 1
.label SCORE1 = $0C
.label SCORE2 = $0D
.label SPEEDX = $0E
.label SPEEDY = $0F
.label DIRECTIONX = $10
.label DIRECTIONY = $11
.label LAUNCHER = $12 // 0 = joueur 1 // 1 = joueur 2
.label CPU_WAITLAUNCH = $13 //Temps d'attente avant que le CPU n'envoi la balle
.label FIRSTBALLWAIT = $14 //Temps d'attente avant que l'un des joueur puisse envoyer la balle au début du jeu
.label NBPING = $16 // Nombre de rebonds restants avant d'augmenter la vitesse de la balle

.label MinX = 24
.label MinY = 60
.label MaxX = 80 // + 256 avec le MSB !
.label MaxY = 249

.label EspacementBordureRaquette = 8
.label EpaisseurRaquette = 6
.label HauteurRaquette = 32
.label TailleBalle = 7
.label ContactBallPixel = 4
.label MARGIN_LEFT = SPRITES.MARGIN_LEFT
.label SCREEN_WIDTH = VIC.SCREEN_WIDTH
.label J1PosX = MARGIN_LEFT + EspacementBordureRaquette
.label J2PosX = MARGIN_LEFT + SCREEN_WIDTH - (EspacementBordureRaquette + TailleBalle)
//.label NbPingChangementNiveau = 50

NbPingChangementVitesse:
	.byte 10, 15, 25, 40, 60, 85, 115
// speed   1   2   3   4   5   6    7
colorFadeLoop:
	.byte $01, $07, $03, $05, $04, $02, $06, $00, $00, $06, $02, $04, $05, $03, $07, $01, $01, $01
colorFadeLoopEnd:
.label colorFadeLoopLength = colorFadeLoopEnd - colorFadeLoop

