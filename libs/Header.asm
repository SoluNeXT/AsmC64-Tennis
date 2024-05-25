#importonce

#import "../main.asm"


HEADER:{

	TexteHeader:
		// MVT:00000000____RBD:0000____SPD:0/0_____
		.byte $8d, $96, $94, $ba // MVT:
		.byte $b0, $b0, $b0, $b0 // 0000
		.byte $b0, $b0, $b0, $b0 // 0000
		.byte $a0, $a0, $a0, $a0 // ____
		.byte $92, $82, $84, $ba // RBD:
		.byte $b0, $b0, $b0, $b0 // 0000
		.byte $a0, $a0, $a0, $a0 // ____
		.byte $93, $90, $84, $ba // SPD:
		.byte $b0, $af, $b0, $a0 // 0/0_
		.byte $a0, $a0, $a0, $a0 // ____

	Init:{
		// Afficher le texte en haut de l'écran...
			ldx #0
		loop:
			lda TexteHeader,x
			sta VIC.SCREEN_RAM,x
			inx
			cpx #40
			bne loop
			rts
	}

	.label TEMP = $03

	AddMouvement:{
			lda #<(VIC.SCREEN_RAM + 3)
			sta TEMP
			lda #>(VIC.SCREEN_RAM + 3)
			sta TEMP + 1
			ldy #8

			jsr AddCompteur

			rts

	}

	AddRebond:{
			//Sauver A et Y
			pha
			tya
			pha

			lda #<(VIC.SCREEN_RAM + 19)
			sta TEMP
			lda #>(VIC.SCREEN_RAM + 19)
			sta TEMP + 1
			ldy #4

			jsr AddCompteur


			//Récupérer A et Y
			pla
			tay
			pla
			rts
	}

	AddCompteur:{
		loop:
			lda (TEMP),y
			clc
			adc #1
			cmp #$BA
			bne inf10
		egal10:
			lda #$B0
			sta (TEMP),y

			dey
			cpy #0
			bne loop

			rts

		inf10:
			sta (TEMP),y
			rts
	}

	DisplaySpeed:{
			lda BALL.SpeedX
			clc
			adc #$B0
			sta VIC.SCREEN_RAM + 32

			lda BALL.SpeedY
			clc
			adc #$B0
			sta VIC.SCREEN_RAM + 34

			rts
	}

	DisplayScore:{
		scoreJ1:{
				lda SCORE1
				cmp #10
				bcc inf10
				cmp #20
				bcc inf20

			equal20:
				lda #48+128 // zéro inversé
				sta VIC.SCREEN_RAM+10
				lda #50+128 // 2 inversé
				sta VIC.SCREEN_RAM+9
				jmp scoreJ1ok


			inf10:
				clc
				adc #48+128 // on ajoute 0 inversé
				sta VIC.SCREEN_RAM+10
				lda #48+128
				sta VIC.SCREEN_RAM+9
				jmp scoreJ1ok

			inf20:
				clc
				adc #48+128-10 // on ajoute 0 inversé et on retranche 10
				sta VIC.SCREEN_RAM+10
				lda #49+128
				sta VIC.SCREEN_RAM+9
				//jmp scoreJ1ok

			scoreJ1ok:

		}

		scoreJ2:{
				lda SCORE2
				cmp #10
				bcc inf10
				cmp #20
				bcc inf20

			equal20:
				lda #48+128 // zéro inversé
				sta VIC.SCREEN_RAM+30
				lda #50+128 // 2 inversé
				sta VIC.SCREEN_RAM+29
				jmp scoreJ2ok


			inf10:
				clc
				adc #48+128 // on ajoute 0 inversé
				sta VIC.SCREEN_RAM+30
				lda #48+128
				sta VIC.SCREEN_RAM+29
				jmp scoreJ2ok

			inf20:
				clc
				adc #48+128-10 // on ajoute 0 inversé et on retranche 10
				sta VIC.SCREEN_RAM+30
				lda #49+128
				sta VIC.SCREEN_RAM+29
				//jmp scoreJ2ok

			scoreJ2ok:

		}

		niveau:{
				lda NIVEAU
				clc
				adc #48+128
				sta VIC.SCREEN_RAM+23
		}

			rts
	}


}