#importonce
BasicUpstart2(Init)

* = $0840 "Sprites"
.import binary "assets/sprites.bin"


* = * "Init"
Init:{
		lda #0
		sta $d020

		lda #6
		sta $d021

		lda #32
		ldx #0
	loop:
		sta $0400 + 000,x
		sta $0400 + 250,x
		sta $0400 + 500,x
		sta $0400 + 750,x
		inx
		cpx #250
		bne loop

		lda #34
		sta $07f8

		lda #72
		sta $d000

		lda $d010
		ora #%00000001
		sta $d010

		lda #234
		sta $d001

		lda #1
		sta $d027

		lda $d015
		ora #%00000001
		sta $d015

		rts


}


