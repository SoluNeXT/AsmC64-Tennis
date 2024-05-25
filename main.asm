#importonce
BasicUpstart2(Init)

//Include Definitions
* = * "Definitions"
#import "def/vic.asm"
#import "def/sprites.asm"

//Include macros
* = * "Macros"
#import "macros/vic.asm"
#import "macros/sprites.asm"



* = * "Init"
Init:{
//.break
	:VIC_SetScreenColors(0,11,0)
	:VIC_ClearScreenSpace(VIC.SCREEN_RAM)

	jsr Ball.Init

	jmp MainLoop
}

// 1er sprite en $0840
//* = $0840 "Sprites"


//Include Libraries
* = * "Ball lib"
#import "libs/Ball.asm"

* = * "MainLoop"
MainLoop:{
	Wait:{
/*
		//Une petite boucle pour ralentir...
			ldx #0
		loopSlow:
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			inx
			bne loopSlow
*/
		VIC_WaitRasterLine(251)
	}

	:VIC_IncBorderColor()
	jsr Ball.Animer
	:VIC_DecBorderColor()

	jmp MainLoop

}


* = (ceil(* / 64)*64) "Sprites 2"
.label SPR_IDX = * / 64
.import binary "assets/sprites.bin"
