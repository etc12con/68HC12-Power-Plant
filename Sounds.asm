			  XDEF Sounds
 XREF Alternator, SoundCounter, PlayTone, SendsChr, delaytimer, delayon, alarm, locknoise
 XREF unlocknoise, elevator, delaytimers, delayons, delaytimert, delayont,delaytimerm,delayonm
 XREF shutsound
 
 
 
 
 
 
 
 
 ;This file is where we store and play all of the different songs for the power plant.
 ; The length of the time is based on an alternator variable and the pitch of the sound
 ; is set by us.
 ; All of the songs are programed the same with different amount of notes to cyle though.
 ; The lenth of the song is based on how long the action the song is playing takes.
 ; The emergeny shutoff turns off when the user enters the proper ID
 ; The filling music, unlock and lock music finish when the process is finished
 
 
 
    Sounds:
    				; File checks which sound is initiated
   	LDAA alarm
   	CMPA #1
   	BEQ alarmnoise
   	LDAA unlocknoise
   	CMPA #1
   	BEQ unlocknojmp
   	LDAA locknoise
   	CMPA #1
   	BEQ locknojmp
   	LDAA elevator
   	CMPA #1
   	BEQ elevatorjmp
   	LDAA shutsound
   	CMPA #1
   	BEQ shutjmp
 locknojmp: JMP lockno
 unlocknojmp: JMP unlockno
	elevatorjmp: JMP elevatormusic
shutjmp:	JMP shutmus
   	
   	
   	
 alarmnoise: MOVB #1, delayon		  ; Emergency shutoff music
    LDAA delaytimer
    CMPA #1
    BGE skipset
    MOVB #0, delaytimer
skipset:  LDAA Alternator		; alternator dictates which note is currently playing
    CMPA #1				; must wait a specified delay time to switch notes
    BEQ highnoise
    LDAA #6
    PSHA
    JSR SendsChr			; send note to speaker
    PULA
    BRA increment
highnoise:  LDAA #18			; alarm has a high and low note that alternates
    PSHA
    JSR SendsChr
    PULA
increment:  LDAA delaytimer
    CMPA #15
    BEQ changenote
    JMP end
changenote:  MOVB #0, delaytimer
    LDAA Alternator
    CMPA #0
    BNE ch1
    MOVB #1, Alternator
    JMP end
ch1:   MOVB #0, Alternator
    JMP end

unlockno: 						; Unlock music
	MOVB #1, delayont
    LDAA delaytimert
    CMPA #1			; quick delay for fast alternation of notes
    BGE skipsetd
    MOVB #0, delaytimert	
skipsetd:  LDAA Alternator
    CMPA #1
    BEQ highnoised
    LDAA #10
    PSHA
    JSR SendsChr	; play note on speaker
    PULA
    BRA incrementd
highnoised:  LDAA #20
    PSHA
    JSR SendsChr	; play note on speaker
    PULA
incrementd:  LDAA delaytimert
    CMPA #4
    BEQ changenoted
    JMP end
changenoted:  MOVB #0, delaytimert
    LDAA Alternator
    CMPA #0
    BNE ch1d
    MOVB #1, Alternator
    JMP end
ch1d:   MOVB #0, Alternator 
    JMP end
    
    
lockno: 					 ;Lock music, almost identical to unlock music
	MOVB #1, delayont
    LDAA delaytimert
    CMPA #1
    BGE skipsetc
    MOVB #0, delaytimert
skipsetc:  LDAA Alternator
    CMPA #1
    BEQ highnoisec
    LDAA #10
    PSHA
    JSR SendsChr
    PULA
    BRA incrementc
highnoisec:  LDAA #20
    PSHA
    JSR SendsChr
    PULA
incrementc:  LDAA delaytimert
    CMPA #4
    BEQ changenotec
    JMP end
changenotec:  MOVB #0, delaytimert
    LDAA Alternator
    CMPA #0
    BNE ch1c
    MOVB #1, Alternator
    JMP end
ch1c:   MOVB #0, Alternator
    JMP end
    
    
elevatormusic:  MOVB #1, delayont		 ; Filling music
    LDAA delaytimert
    CMPA #1
    BGE skipsett
    MOVB #0, delaytimert
skipsett:   
	LDAA Alternator		; many alterations for many notes
    CMPA #1
    BEQ highnoiset
    LDAA Alternator
    CMPA #2
    BEQ midno
    CMPA #3
    BEQ amp
    CMPA #4
    BEQ ampy
    CMPA #5
    BEQ gampy
    LDAA #10			
    PSHA
    JSR SendsChr
    PULA
    BRA incrementt
gampy: LDAA #11		  
    PSHA
    JSR SendsChr
    PULA
    BRA incrementt
ampy:  LDAA #9		  
    PSHA
    JSR SendsChr
    PULA
    BRA incrementt 
amp:   LDAA #8		  
    PSHA
    JSR SendsChr
    PULA
    BRA incrementt 
midno:   LDAA #12		
    PSHA
    JSR SendsChr
    PULA
    BRA incrementt
highnoiset:  LDAA #7	  
    PSHA
    JSR SendsChr
    PULA
incrementt:  LDAA delaytimert
    CMPA #10
    BEQ changenotet
    JMP end
changenotet: MOVB #0, delaytimert
    LDAA Alternator		; increment through different notes each cycle
    INCA 
    STAA Alternator
    CMPA #6
    BLO endit
    MOVB #0, Alternator
endit:    JMP end
    
    
    
    
    shutmus:    			  ; Finish auto shutoff music, almost identical to filling music except
				  ; with different notes
    MOVB #1, delayont
    LDAA delaytimert
    CMPA #1
    BGE skipseta
    MOVB #0, delaytimert
skipseta:   	
	LDAA Alternator
    CMPA #1
    BEQ highnoisea
    LDAA Alternator
    CMPA #2
    BEQ midnoa
    CMPA #3
    BEQ ampa
    CMPA #4
    BEQ amper
    CMPA #5
    BEQ amperer
    CMPA #6
    BEQ finale
    LDAA #10			;12
    PSHA
    JSR SendsChr
    PULA
    BRA incrementa
finale:	LDAA #5
		PSHA
    	JSR SendsChr
	    PULA
	    BRA incrementa
amperer:LDAA #6
		PSHA
    	JSR SendsChr
    	PULA
   		BRA incrementa	
amper: LDAA #16
	   PSHA
       JSR SendsChr
       PULA
       BRA incrementa
ampa:   LDAA #14   ;4
    PSHA
    JSR SendsChr
    PULA
    BRA incrementa 
midnoa:   LDAA #12		;25
    PSHA
    JSR SendsChr
    PULA
    BRA incrementa
highnoisea:  LDAA #8	  ;10
    PSHA
    JSR SendsChr
    PULA
incrementa:  LDAA delaytimert
    CMPA #7
    BEQ changenotea
    JMP end
changenotea: 
	MOVB #0, delaytimert
    LDAA Alternator
    INCA 
    STAA Alternator
    CMPA #7
    BNE end
    MOVB #0, shutsound
    MOVB #0, Alternator
    MOVB #0, delayont
    MOVB #0, delaytimert
    JMP end
    
    
end:   JSR PlayTone
    RTS







