BasicUpstart2(Init)

	.label SpriteLine = $02
	.label sprite1stCol = $03
	.label spriteColPos = $04

ColorFade1:
* = * "ColorFade1"
	.byte	$0d, $03, $0c, $04, $0b, $06, $06, $06
	.byte	$06, $06, $06, $06, $06, $06, $06, $06
	.byte	$06, $06, $06, $0b, $04, $0c, $03, $0d
	.label fade1Length = * - ColorFade1

ColorFade2:
* = * "ColorFade2"
	.byte	$00, $09, $02, $04, $0c, $03, $0d, $01
	.byte	$01, $01, $01, $01, $01, $01, $01, $01
	.byte	$01, $0d, $03, $0c, $0d, $02, $09, $00
	.label fade2Length = * - ColorFade2



* = $0840 "Sprites"
.import binary "assets/sprites.bin"


Init:
		lda #34
		sta $07f8
		sta $07f9
		sta $07fa


		ldx #200
		stx $d000

		ldy #150
		sty $d003
		stx $d002

		ldy #175
		sty $d005
		stx $d004


		lda $d010
		ora #%00000000
		sta $d010
	
		lda $d015
		ora #%00000111
		sta $d015

		sei

		ldx #0
		stx sprite1stCol
		

start:
		lda #22
		sta SpriteLine

		inc sprite1stCol
		ldx sprite1stCol
		cpx #fade2Length
		bne !+

		ldx #0
		stx sprite1stCol
!:
		stx spriteColPos
		lda ColorFade1,x
		sta $d028 
		lda ColorFade2,x
		tax

spr_16:
		ldy #175
		tya
		sta $d005
		ldx #0
loop_16:
		cmp $d012
		bne loop_16

		stx $d029

		inx

		iny
		tya

		dec SpriteLine
		bne loop_16


		lda #22
		sta SpriteLine
spr_anim:
		ldy #200
		tya
		sta $d001
loop_anim:
		cmp $d012
		bne loop_anim

		stx $d027

		inc spriteColPos
		ldx spriteColPos
		cpx #fade2Length
		bne !+

		ldx #0
!:
		stx spriteColPos
		lda ColorFade2,x
		tax

		iny
		tya

		dec SpriteLine
		bne loop_anim

		jmp start
end:
		rts
