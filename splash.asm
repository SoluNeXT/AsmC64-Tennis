BasicUpstart2(MAIN)
BasicEnd:

//Format du fichier KLA : 
// - Memory Loading address :     2 bytes
// - Bitmap SplashDatas		:  8000 bytes
// - Screen RAM colors      :  1000 bytes
// - Color RAM colors       :  1000 bytes
// - Background color       :     1 byte
// --- TOTAL FILE SIZE ---  : 10003 bytes

* = $2000 "Splash datas" // $2000
SplashDatas:
.import binary "./assets/tennis.bin"

#import "./macros/vic.asm" 

.label bitmap = SplashDatas 
.label col1 = bitmap + 8000
.label col2 = col1 + 1000
.label Background = col2 + 1000




.var music = LoadSid("./assets/Alloyrun_Highscore.sid")
*=music.location "Music"
.fill music.size, music.getData(i)
// Print the music info while assembling
.print ""
.print "SID Data"
.print "--------"
.print "location=$"+toHexString(music.location)
.print "init=$"+toHexString(music.init)
.print "play=$"+toHexString(music.play)
.print "songs="+music.songs
.print "startSong="+music.startSong
.print "size=$"+toHexString(music.size)
.print "name="+music.name
.print "author="+music.author
.print "copyright="+music.copyright

.print ""
.print "Additional tech data"
.print "--------------------"
.print "header="+music.header
.print "header version="+music.version
.print "flags="+toBinaryString(music.flags)
.print "speed="+toBinaryString(music.speed)
.print "startpage="+music.startpage
.print "pagelength="+music.pagelength





* = BasicEnd "MAIN"
MAIN:
*=* "Prepare & display Splash"
	//Border black
	lda #0
	sta $d020
	//Screen off
	lda $d011
	and #%11101111
	sta $d011	
	//Background white
	lda Background
	sta $d021
	//Set Multicolors ON
	lda $d016
	ora #%00010000
	sta $d016
	//Set Memory screen ...
	lda $d018
	and #%00000001  // clear screen memory pointer
	ora #%00010000  // set memory screen pointer to $0400
	ora #%00001000  // set Bitmap mode pointer to $2000
	sta $d018
	// Set VIC bank
	lda $dd00
	and #%11111100  // clear memory bank pointer
	ora #%00000011	// set memory bank to $0000-3fff
	sta $dd00
	// Set screen control to Bitmap Mode
	lda $d011
	ora #%00100000
	sta $d011

	//Copy Colors
	ldx #0

loop:
	lda col1,x
	sta $0400,x
	lda col1+250,x
	sta $0400+250,x
	lda col1+500,x
	sta $0400+500,x
	lda col1+750,x
	sta $0400+750,x
	lda col2,x
	sta $d800,x
	lda col2+250,x
	sta $d800+250,x
	lda col2+500,x
	sta $d800+500,x
	lda col2+750,x
	sta $d800+750,x
	inx
	cpx #250
	bne loop

	//Screen on
	lda $d011
	ora #%0010000
	sta $d011	

// Init Music
	ldx #0
    ldy #0
    lda #0
	jsr music.init


*=* "Wait for fire"
	//Wait for Joystick Fire
loopJoy:
	:WaitRasterLine(60)
	inc $d020
	jsr music.play
	dec $d020

	lda $dc00
	and #%00010000
	bne loopJoy

*=* "Quit splash"
	//Leave bitmap mode

	//Screen off
	lda $d011
	and #%11101111
	sta $d011	

	//Set Multicolors OFF
	lda $d016
	and #%11101111
	sta $d016

	// Set screen control to Bitmap Mode
	lda $d011
	and #%11011111
	sta $d011

	//Set Memory screen ...
	lda $d018
	and #%00000001  // clear screen memory pointer
	ora #%00010000  // set memory screen pointer to $0400
	ora #%00000100  // set text mode pointer to $1000
	sta $d018	

	//Screen on
	lda $d011
	ora #%0010000
	sta $d011	

*=* "Return from splash"

// Init Music
	ldx #0
    ldy #0
    lda #0
	jsr music.init

	rts



*=* "End of Splash"

