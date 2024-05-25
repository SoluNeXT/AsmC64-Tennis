#importonce

BasicUpstart2(Init)

// Import des macros
#import "./macros/vic.asm"
#import "./macros/sprites.asm"


//Import des globales
#import "./def/globales.asm"


//Import des Sprites
* = $0840 "Sprites" // $0840 = d 2112 = 64 * 33 >> 33 = balle / 34 = raquette
.import binary "./assets/sprites.bin"


//Import des librairies
* = * "Fonctions"
#import "./libs/Fonctions.asm"
* = * "Ball"
#import "./libs/Ball.asm"
* = * "Header"
#import "./libs/Header.asm"
* = * "Game"
#import "./libs/Game.asm"
* = * "Menu"
#import "./libs/Menu.asm"


//GAME
* = * "Init"
Init:

	jsr GAME.RootInit

//Debug >> on va directement au GS3
/*
	ldx #3
	stx GAMESTATUS
	ldx #2
	stx NBPLAYERS
*/
MainLoop:{
		jsr FN.GetRandom
//Wait for raster >> bas d'écran affiché
		ldx #0
		stx $d020		
		:WaitRasterLine(251)
		ldx #5
		stx $d020

		lda GAMESTATUS
	isGS1:	// 1 = Menu Init
		cmp #1
		bne !+
		jsr MENU.Init
		jmp MainLoop


	!:
	isGS2: // 2 = Menu Loop
		cmp #2
		bne !+
		jsr MENU.MenuLoop
		jmp MainLoop
	!:

	isGS3: // 3 = Init Game
		cmp #3
		bne !+
		jsr GAME.Init		
		jmp MainLoop

	!:
	isGS4: // 4 : Game wait for launch ball
		cmp #4
		bne !+
		jsr GAME.WaitLaunch
		jmp MainLoop

	!:
	isGS5: //  5 = Looooop Game 
		cmp #5
		bne !+
		jsr GAME.Running
		jmp MainLoop

	!:
	isGS6: //  6 = Player 1 Mark point
		cmp #6
		bne !+
		lda #12
		sta $d021	
		jmp MainLoop

	!:
	isGS7: //  7 = Player 2 (or CPU) Mark point
		cmp #7
		bne !+
		lda #13
		sta $d021	
		jmp MainLoop

//  

	!:
	isGS8: //  8 = Game End (player 1 or 2 win)
		cmp #8
		bne !+
		lda #14
		sta $d021	
		jmp MainLoop
//  

//  other >> Reset to 1
	!:
		lda #1
		sta GAMESTATUS

		jmp MainLoop
}

