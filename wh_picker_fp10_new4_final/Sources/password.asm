 XDEF password
 
 XREF wh_password
 XREF wh_password1
 XREF wh_password2
 XREF wh_password3
 XREF wh_password4
 XREF disp
 XREF KEY_PRESSED
 XREF password_entered
 XREF read_keypad
 XREF display_to_lcd
 XREF rti_delay
 XREF start_msg
 XREF inc_password_msg
 XREF PlayTone
 XREF SendsChr
 XREF msg_for_bob
 XREF bobs_flag

;push x and d
password: pshx
          pshd

password_start: ;display our start message
          ldd #start_msg
          jsr display_to_lcd
          ;we're using x as a counter, init to zero		  
          ldx #0
read_password:
          ;grab a keypress
          jsr read_keypad
		  ;load into a
          ldaa KEY_PRESSED
		  ;check for no key pressed, if so keep reading
          cmpa #$FF
          beq read_password
		  ;else store character into password_entered array
          staa password_entered, x
          ;staa password_entered, x+
		  ;increment our counter
          inx
          ;if 4 chars entered, begin checking		  
          cpx  #4
          bne read_password
		  
		  ;reinitialize our character counter
          ldx #0  
check_password:
          ;load a with password entered
          ldaa password_entered, x
          
          ;compare it to our password
          		  
          cmpa wh_password, x
		  ;branch if not equal to incorrect password splash screen
          bne wrong_password
		  
          ;;TODO: STORE 4 MORE PASSWORDS;;
          
		  ;increment counter
		  inx
          ;check 4 characters		  
          cpx #4
		  ;if not, keep checking
          bne check_password
		  ;only display bob's message the first time
          ldab bobs_flag                 
          cmpb #1
		  ;if higher than or equal to 1, skip this part
          lbhs exit_read_password 
          ;;Display Bob's message		  
          ldd #msg_for_bob               
          jsr display_to_lcd             ;;Nice supportive employer
          jsr rti_delay                  ;;tells Bob to get to work
          jsr rti_delay
          movb #1, bobs_flag
          ;exit routine and head to main menu           
          bra exit_read_password
         
  
wrong_password:
          ;put wrong password splash screen on LCD
          ldd #inc_password_msg
          jsr display_to_lcd
                      
          jsr rti_delay    ;delays close to 1 sec so the user has time to read warning
          jsr rti_delay    ;delays close to 1 sec so the user has time to read warning
          ;re-read a password
          bra password_start
;correct password has been entered if you get here                                            
exit_read_password:  
          puld
          pulx 
          rts
           