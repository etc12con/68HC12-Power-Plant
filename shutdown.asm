		    
	
	 XDEF shutdown	
 XREF ledswitches, dispG, display_string, instepper
 XREF hexkeypad, switchchange, disp3, gen1stat, shutoff, HOMEflg
 XREF gen2stat, gen3stat, gen1off, gen2off, gen3off, port_s
 XREF port_t, switchstatus, dispe, rows, lookup, PTU, switchflg, delayon, delaytimer	
 XREF waithold, dispc, gen2flg, gen3flg, dispd, timeswrong, SendsChr, PlayTone, alarm 
 	
 
 
 
 
 ; This is only shown when the IRQ is pressed. 
 ; The IRQ sets a flag that we set up to be able to be seen anywhere so that it can come here ASAP
 ; While here all other things are pasued
 ; When you return everything will be returned back to the way you left them
 ; While here it displays a message and waits for the proper password and ID
 ; This is a simple hex keypad routine
 
 	
  	shutdown:	
  	MOVB #0, HOMEflg		; let program know its not home
  	MOVB #1, alarm		; play alarm music
           	MOVB #$FF, ledswitches	; flash all leds
           	MOVB #$0, instepper		; let program know its not in the stepper
           	MOVB #$1, waithold
           	MOVB gen1off, gen1stat
            MOVB gen2off, gen2stat
            MOVB gen3off, gen3stat	; save generator previous status and turn off all generators
            MOVB #1, gen1off
           	MOVB #1, gen2off
            MOVB #1, gen3off
           	MOVB #$00, $242		; turn off DC motor
  	BSET $242, $20
           	MOVB #0, gen2flg
retry     	LDX #3
         	LDY #9
         	LDAA #20	
         	STAA gen3flg
passchecki1: PSHX
         	LDD #dispG
           	JSR display_string
           	PULX	
         	CPX #7     	
         	BEQ ENDRTI2jmp
         	JSR hexkeypad2		; user input
         	CMPA #9
         	BLE number3i1
         	ADDA #$7
number3i1: 	STAA $411     	;Address 411 contains button pressed for password
         	LDAB disp3, y
         	SUBB #$30
         	CMPB $411
         	BNE incorrect
         	LDAA #'*'		; update LCD to show how far in password
         	PSHX
         	LDX gen2flg
         	STAA dispG,X
         	INX
         	STX gen2flg
         	PULX
         	INX
         	INY      	
         	BRA passchecki1
         	
ENDRTI2jmp: 	JMP ENDRTI2
         	
incorrect: movb #'I', dispd+6
       	movb #'D', dispd+7

       	movb #' ',dispd+8
       	movb #' ',dispd+9
       	movb #' ',dispd+10
       	movb #' ',dispd+11
       	movb #' ',dispd+12
       	movb #' ',dispd+13
       	movb #' ',dispd+14
       	movb #' ',dispd+15
       	movb #' ',dispd+16
       	movb #' ',dispd+17
       	movb #' ',dispd+18
       	movb #' ',dispd+19
       	movb #' ',dispd+20        	
       	LDD #dispd
       	JSR display_string
 waitforf: JSR hexkeypad2
       	CMPA #$F
       	BNE waitforf		; wait for user to acknowledge they are wrong
       	movb #'P', dispd+6
       	movb #'a', dispd+7
       	movb #'s',dispd+8
       	movb #'s',dispd+9
       	movb #'w',dispd+10
       	movb #'o',dispd+11
       	movb #'r',dispd+12
       	movb #'d',dispd+13
       	movb #' ',dispd+14
       	movb #' ',dispd+15
       	movb #'o',dispd+16
       	movb #'r',dispd+17
       	movb #' ',dispd+18
       	movb #'I',dispd+19
       	movb #'D',dispd+20
       	movb #'X',dispG+20
       	movb #'X',dispG+21
       	movb #'X',dispG+22
       	movb #'X',dispG+23       	
       	JMP retry
       	
ENDRTI2:        	
                	movb #'X',dispG+20
                  	movb #'X',dispG+21
                  	movb #'X',dispG+22
                  	movb #'X',dispG+23
                	LDAA switchflg
                	CMPA #1
                	BEQ ENDRTI3
                	LDAA port_t
                	CMPA switchstatus
                	BEQ ENDRTI3	

                	LDD #dispe
                	JSR display_string
waitforswitch:    	LDAA port_t
                	ANDA #$7			; verify switches are in position prior to shutdown
                	CMPA switchstatus
                	BNE waitforswitch

ENDRTI3         MOVB #0, gen2flg
                	MOVB gen1stat, gen1off
                	MOVB gen2stat, gen2off	; return generators to initial conditions
                	MOVB gen3stat, gen3off
                	MOVB #$08, $242		; turn DC motor back on
                	BSET $242, $20
                	MOVB #0, switchchange
                	LDAA #$FF			; when returning to other parts of program, this 
						; indicates a shutdown just occured
                	MOVB #$0, ledswitches
                	MOVB #$0, waithold
                	MOVB #0, timeswrong
     		MOVB #0, alarm
                	MOVB #0, shutoff
     		MOVB #0, delayon
  		MOVB #0, delaytimer
                	MOVB #0, port_s
                	RTS

	
   	hexkeypad2:

   	; similar to hexkeypad file with minor alterations to allow the shutdown file to run correctly
	
    	PSHX
    	PSHY

loop: LDX #rows
loop1: CPX #rows+4
  BEQ loop
 
 

          	LDAA 1, x+
           	STAA PTU
          	JSR debounce
          	ANDA #$0F
          	CMPA #$0F
           	BEQ loop1jmp
           	BRA letgo
           	
  loop1jmp:	jmp loop1
 
 
letgo:  LDAA PTU
    	ANDA #$0F
      	CMPA #$0F
      	BNE letgo 
     	LDAA #0
      	LDY #lookup

loop2:  CMPB 1, y+
      	BEQ gohome
      	inca
      	CPY #lookup + 16
      	BNE loop2
      	BRA loopjmp
      	
 loopjmp:	jmp loop

 gohome:    	
        	PULY
        	PULX
      	

        	RTS

    	debounce:

 

  JSR delay

  LDAA PTU

  TAB

  RTS

	delay:

  LDY #1000

loop4: DEY

  BNE loop4

 

  RTS





