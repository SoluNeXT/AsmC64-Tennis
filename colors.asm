BasicUpstart2(init)

.label firstline = 47
.label lastline = 249
.label lineheight = 4
.label color0 = 0
.label color1 = 6

init:
	ldx #firstline
loop:
	txa
	ldy #color0
wait:
	cmp $d012
	bne wait
	sty $d021

	txa
	adc #lineheight
	ldy #color1
wait2:
	cmp $d012
	bne wait2
	sty $d021

	inx
	inx

	cpx #lineheight
	bne loop

	jmp init
