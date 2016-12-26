 XDEF local_time

 XREF read_keypad
 XREF KEY_PRESSED
 XREF local_time_msg_1
 XREF local_time_msg_2
 XREF display_to_lcd
 XREF seconds
 XREF minutes
 XREF hours
 XREF day
 XREF remainder
 XREF HundredsDigit
 XREF TensDigit
 XREF OnesDigit
 XREF day_char_1
 XREF day_char_2
 XREF day_char_3
 XREF time_digits

;here we display time if $FF is returned from keypad,
;else if B is pressed it means user wants to set time
;this will begin a sequence, starting with the hours 
;character, then the minutes, then seconds, and finally
;the day (inputted as 1-7 for mon thru sun)
;to display we need to do ASCII conversion
;and to always be checking for A or B being pressed,
;as well as numbers for the times


local_time:  pshd
             pshx
             pshy
 
			 ;this will display the updating time continuously if in local
			 ;time menu item
disp_time_day:     
             ldaa #0
             ldab hours
             ldx #100
             idiv
             std remainder
             tfr x,d
             stab HundredsDigit
                  
             ldd remainder
             ldx #10
             idiv
             std remainder
             tfr x,d 
             stab TensDigit
                  
             ldd remainder
             stab OnesDigit
                  
             ;ASCII conversion                 
             ldaa TensDigit
             adda #$30
             staa TensDigit
                  
             ldaa OnesDigit
             adda #$30
             staa OnesDigit
                  
             
             movb TensDigit, local_time_msg_1+20   ;hours
             movb OnesDigit, local_time_msg_1+21   ;hours
             
             ;minutes
             ldaa #0
             ldab minutes
             ldx #100
             idiv
             std remainder
             tfr x,d
             stab HundredsDigit
                  
             ldd remainder
             ldx #10
             idiv
             std remainder
             tfr x,d
             stab  TensDigit
                  
             ldd remainder
             stab OnesDigit
                  
             ;ASCII conversion                 
             ldaa TensDigit
             adda #$30
             staa TensDigit
                  
             ldaa OnesDigit
             adda #$30
             staa OnesDigit
             
             movb TensDigit, local_time_msg_1+23  ;minutes
             movb OnesDigit, local_time_msg_1+24  ;minutes
             
             ;seconds
             ldaa #0
             ldab seconds
             ldx #100
             idiv
             std  remainder
             tfr x,d
             stab  HundredsDigit
             
             ldd remainder
             ldx #10
             idiv
             std remainder
             tfr x,d
             stab TensDigit
                  
             ldd remainder
             stab OnesDigit
                  
             ;ASCII conversion                 
             ldaa TensDigit
             adda #$30
             staa TensDigit
                  
             ldaa OnesDigit
             adda #$30
             staa OnesDigit
            
             movb TensDigit, local_time_msg_1+26    ;seconds
             movb OnesDigit, local_time_msg_1+27    ;seconds
             
             ;display day
             ldaa day
             ldx #day_char_1
			 ;using movb to display it
             movb a, x, local_time_msg_1+29       ;M T W T F S S
             ldx #day_char_2
             movb a, x, local_time_msg_1+30       ;O U E H R A U
             ldx #day_char_3
             movb a, x, local_time_msg_1+31       ;N E D H I T N
 
             ldd #local_time_msg_1
             jsr display_to_lcd
           
             ;inputing time/day
             jsr read_keypad 
             ldaa KEY_PRESSED
             cmpa #$0A                   ;exit if A pressed
             lbeq exit_local_time
             cmpa #$0B                   ;else user wants to input time
             lbne disp_time_day          ;keep reading keypad
             
			 ;if B's pressed user will be prompted to enter time
			 ;and blanks will be displayed on LCD
			 ;each time you enter one it'll be filled in
			 ;or you can go back (pressing A acts like a backspace)
          
             movb #'_', local_time_msg_2+18  ;hours
             movb #'_', local_time_msg_2+19  ;hours
   
             movb #'_', local_time_msg_2+21  ;minutes
             movb #'_', local_time_msg_2+22  ;minute
           
             movb #'_', local_time_msg_2+24  ;first char of day
             movb #'_', local_time_msg_2+25  ;second char of day
             movb #'_', local_time_msg_2+26  ;third char of day
           
             ldd #local_time_msg_2
             jsr display_to_lcd
                   
             ;get first digit
			 ;and continue going down the line
			 ;the "day's digit" is last, 1-7
get_first_hours_digit:
             jsr  read_keypad
             ldaa KEY_PRESSED
             cmpa #$FF          ;keep reading if no key pressed
             beq  get_first_hours_digit
             
             cmpa #$0A           ;go back if A pressed
             bne check_if_higher_than_2
             lbra disp_time_day   ;will display current time again if A pressed
			 
check_if_higher_than_2:			  
             ;doing military time
             ;check for 24 instead of 12
             ;make sure user doesn't input a wrong time			 
             cmpa #2
             bhi get_first_hours_digit   ;branch if higher than 2 to re-read
			                             ;has to be 0 or 1
             staa time_digits   ;else store the digit
             ;ASCII conversion 
             adda #$30
             staa local_time_msg_2+18
             ldd #local_time_msg_2
             jsr display_to_lcd          ;display updated message
 
              ;get next digit for hours
get_2nd_hours_digit:
             ldaa time_digits
             cmpa #1
             bhi second_digit_could_be_2    ;branch if higher than 1
			 ;else it's a one or zero
second_digit_less_than_2:	   ;or greater than 9
             jsr read_keypad
             ldaa KEY_PRESSED
             cmpa #$FF        ;if no key was pressed, read keypad again
             beq  second_digit_less_than_2
             
             cmpa #$0A      ;if A pressed go back to change the previous digit
             bne compare_digit_to_9 ;if not move on
             movb #'_', local_time_msg_2+18
             ldd #local_time_msg_2
             jsr display_to_lcd
             bra get_first_hours_digit
           
compare_digit_to_9:		   
             cmpa #9
             bhi  second_digit_less_than_2   ;read again if over 9
             ;else store it
			 staa time_digits+1
             ;ASCII conversion  
             adda #$30
             staa local_time_msg_2+19 
             ldd #local_time_msg_2
             jsr display_to_lcd
			 ;continue to reading minutes now
             bra first_minutes_digit
             
			 
second_digit_could_be_2: ;not sure yet, higher than 1 though
             ;this is still for 2nd hours digit 
             jsr read_keypad
             ldaa KEY_PRESSED
             cmpa #$FF        ;if no key was pressed, read keypad again
             beq second_digit_could_be_2
               
             cmpa #$0A      ;if A pressed, put '_' char back
             bne check_if_3_or_higher  ;otherwise continue reading it
             movb #'_', local_time_msg_2+18  
             ldd #local_time_msg_2
             jsr display_to_lcd 
             bra get_first_hours_digit      ;go back to get first digit

check_if_3_or_higher:			 
             ;second digit can't be 3 or higher
             cmpa #3
             bhi second_digit_could_be_2
			 ;else store it
             staa time_digits+1
			 ;ASCII conversion
             adda #$30
             staa local_time_msg_2+19
             ldd #local_time_msg_2
             jsr display_to_lcd  
 
             
               
             ;read first digit for minutes
first_minutes_digit:			 
             jsr  read_keypad
             ldaa KEY_PRESSED
             cmpa #$FF        ;if no key was pressed, read keypad again
             beq  first_minutes_digit
             ;if A pressed, we go back to previous char  
             cmpa #$0A 
             ;else continue			 
             bne continue_read_1st_minute
             movb #'_', local_time_msg_2+19
             ldd #local_time_msg_2
             jsr display_to_lcd 
             bra get_2nd_hours_digit
			 
continue_read_1st_minute:               
             ;can't be greater than 5
             cmpa #5
             bhi first_minutes_digit  ;if higher than 5, re-read
			 ;else store
             staa time_digits+2
             ;ASCII conversion 
             adda #$30     
             staa local_time_msg_2+21     
             ldd #local_time_msg_2   
             jsr display_to_lcd  ;restore it

 
             ;;getting 2nd digit minutes
second_minutes_digit
             jsr  read_keypad
             ldaa KEY_PRESSED
             cmpa #$FF        ;if no key pressed read keypad again
             beq  second_minutes_digit
             ;if A pressed, we go back to previous char  
             cmpa #$0A
             bne continue_read_2nd_minute   ;else we move on
             movb #'_', local_time_msg_2+21
             ldd #local_time_msg_2
             jsr display_to_lcd 
             bra first_minutes_digit

continue_read_2nd_minute:			 
             cmpa #9      ;can't be higher than 9
             bhi second_minutes_digit  ;if it is, re-read
			 ;else store it
             staa time_digits+3
             
             ;ASCII conversion			 
             adda #$30
             staa local_time_msg_2+22
             ldd #local_time_msg_2
             jsr display_to_lcd  ;restore it
              
              
			  ;reading the day
read_day_1:              
             jsr read_keypad
             ldaa KEY_PRESSED
             cmpa #$FF
             beq read_day_1
             ;if A pressed, we go back to previous char  
             cmpa #$0A
             bne continue_read_1st_day        ;else we move on
             movb #'_', local_time_msg_2+22
             ldd #local_time_msg_2
             jsr display_to_lcd 
             bra second_minutes_digit

continue_read_1st_day:			 
             ;has to be 1-7, otherwise re-read
             cmpa #7
             bhi read_day_1
             cmpa #0
             beq read_day_1
			 ;otherwise store it
             staa time_digits+4
             tfr a,d
             ldx #day_char_1
			 ;first char of day put in string
             movb d, x, local_time_msg_2+24    
             ldx #day_char_2
			 ;second char of day put in string
             movb d, x, local_time_msg_2+25
             ldx #day_char_3
			 ;third char of day put in string
             movb d, x, local_time_msg_2+26
			 ;display it to LCD
             ldd #local_time_msg_2
             jsr display_to_lcd 

confirm_day:
             jsr read_keypad 
             ldaa KEY_PRESSED
             cmpa #$FF
             beq confirm_day
             ;if A pressed, we go back to previous char(s)
             ;set all 3 back to blanks if we go back here			 
             cmpa #$0A
             bne continue_confirm_day        ;else we move on
             movb #'_', local_time_msg_2+24
             movb #'_', local_time_msg_2+25
             movb #'_', local_time_msg_2+26
             ldd #local_time_msg_2
             jsr display_to_lcd 
             bra read_day_1         ;start over reading day

continue_confirm_day:
             cmpa #$0B      ;if B pressed, we load in new values
             bne confirm_day ;else we go back
			 
             ;store hours
             ldaa time_digits
             ldab #10
             mul
             ldaa time_digits+1
             aba
             staa hours
               
             ;store minutes
             ldaa time_digits+2
             ldab #10
             mul
             ldaa time_digits+3
             aba
             staa minutes
               
             ;store day
             movb time_digits+4, day   
             lbra disp_time_day

exit_local_time:			  
             puly
             pulx
             puld
             rts