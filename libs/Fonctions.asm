#importonce

#import "../main.asm"


FN:{

	GetRandom:{
		rnd:
		        asl random
		        rol random+1
		        rol random+2
		        rol random+3
		        bcc nofeedback
		        lda random
		        eor #$B7
		        sta random
		        lda random+1
		        eor #$1D
		        sta random+1
		        lda random+2
		        eor #$C1
		        sta random+2
		        lda random+3
		        eor #$04
		        sta random+3
		nofeedback:
				lda random
		        rts

		random: 
				.byte $FF,$FF,$FF,$FF
	}


}