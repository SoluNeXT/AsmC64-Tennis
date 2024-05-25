BasicUpstart2(Init)

#import "./macros/vic.asm"
#import "./macros/sprites.asm"

* = $0840 "Sprites" // $0840 = d 2112 = 64 * 33
.import binary "./assets/sprites.bin"

* = * "Ball"
#import "./libs/Ball.asm"

* = * "Header"
#import "./libs/Header.asm"

* = * "Init"
Init:

	:SetBorderColor(14) // Bleu clair
	:SetBackgroundColor(6) // Bleu foncé

	//Vider l'écran...
	:FillScreen(32)  // 32 = caractère "espace"

	//Init Ball
	jsr BALL.Init

	lda #2 // vitesse X = 2
	ldx #0 // vers la droite
	jsr BALL.SetX

	lda #1 // vitesse Y = 1
	ldx #0 // vers la droite
	jsr BALL.SetY

	//Init Header
	jsr HEADER.Init



* = * "MainLoop"
loop:
	inc VIC.BORDER_COLOR

	jsr BALL.Move
	// X avant Y...
	cmp #0 // Sup ou Inf à 255 ???
	bne xSup255
xInf255:
	cpx #BALL.MinX // marge gauche = 24
	bcs xOK
	bcc invertX
xSup255:
	cpx #BALL.MaxX // Marge gauche = 24 + ecran = 320 - ball = 8 (-256 XMSB) => 320+24-(256+8) = 80
	bcc xOK
invertX:
	lda BALL.DirectionX
	eor #%00000001
	sta BALL.DirectionX

	jsr HEADER.AddRebond

xOK:



	//Bordures ... Haut = 50, bas = 250 ... la balle fait 8 pixels...
	clc
	cpy #BALL.MinY
	bcc invertY
	clc
	cpy #BALL.MaxY
	bcc yOK
invertY:
	lda BALL.DirectionY
	eor #%00000001
	sta BALL.DirectionY

	jsr HEADER.AddRebond

yOK:
	//Ralentir...
	ldx #0


// Add compteur mouvement...
	jsr HEADER.AddMouvement

// Afficher Vitesse X et Y
	jsr HEADER.DisplaySpeed

// Modifier la vitesse avec le joystick !
	ldx VIC.JOY2
	// %111frldu
testUp:
	txa
	and #%00000001
	bne testDown

	lda BALL.SpeedY
	cmp #8
	beq testDown

	inc BALL.SpeedY


testDown:
	txa
	and #%00000010
	bne testLeft

	lda BALL.SpeedY
	cmp #1
	beq testLeft

	dec BALL.SpeedY


testLeft:
	txa
	and #%00000100
	bne testRight

	lda BALL.SpeedX
	cmp #1
	beq testRight

	dec BALL.SpeedX


testRight:
	txa
	and #%00001000
	bne testFire

	lda BALL.SpeedX
	cmp #8
	beq testFire

	inc BALL.SpeedX



testFire:
	// Fire = Pause
	txa
	and #%00010000
	bne noJoy

	// fire pressed...
	// on revérifie le joystick...
	ldx VIC.JOY2
	jmp testFire



noJoy:
dec VIC.BORDER_COLOR

wait:
	lda VIC.RASTER
	cmp #251
	beq l250

	jmp wait



l250:


	jmp loop
