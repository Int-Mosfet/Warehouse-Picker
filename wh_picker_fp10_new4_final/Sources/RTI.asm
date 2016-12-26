 XDEF RTI_ISR
 
 XREF song1
 XREF song1_backwards
 XREF song2
 XREF song3
 XREF note_we_on
 XREF toggle_note
 XREF toggle_note2
 XREF toggle_count
 XREF toggle_note3
 XREF toggle_note4
 XREF password
 XREF IRQ_to_PW_flag
 XREF gmt_counter
 XREF gmt_seconds
 XREF gmt_minutes
 XREF gmt_hours
 XREF gmt_day
 XREF auto_dc_motor_flag  
 XREF man_dc_motor_flag 
 XREF seconds
 XREF minutes
 XREF hours
 XREF day
 XREF counter
 XREF RTIFLG
 XREF Port_p
 XREF Port_s
 XREF SendsChr
 XREF PlayTone
 XREF Port_t
 XREF Port_t_ddr
 XREF pb_pressed
 XREF pb_pressed_debounce
 XREF irq_pressed
 XREF KeypressFlag
 XREF KEY_PRESSED
 XREF read_keypad
 XREF rti_delay
 XREF dc_time_on
 XREF prev_key
 XREF dc_count
 XREF dc_time_off
 XREF read_pot
 XREF pot_value
 XREF local_time
 XREF add_cont_song_flag
 XREF remove_cont_song_flag
 XREF dc_delay_count
 XREF backdoor_flag
 XREF step_delay_FLAG
  
RTI_ISR:
          ;start with the timer to keep the clock the most accurate
		  ;the most important algorithm is the next 5 lines of code
		  ;you can modify it to count to a number of milliseconds for songs or up to a second
		  ;and make a straight forward easy to read clock implementation
          ldx counter
          inx
          stx counter
          cpx #1000      ;1ms ISR, so after 1000 times it's close to a second
          lbne done_with_local_time  ;exits if we haven't reached one second yet
          
          ;increment seconds variable
          movb #0, counter
          inc seconds
          ldaa seconds
          cmpa #60    ;if 60 seconds reached, increment minute variable
          lbne done_with_local_time
          
          ;increment minutes variable           
          movb #0, seconds  ;seconds needs to be reset
          inc minutes
          ldab minutes
          cmpb #60  ;if you hit 60 minutes, increment hours variable
          bne done_with_local_time
          
          ;increment hours variable
          movb #0, minutes    ;reset minutes variable to zero
          inc hours
          ldaa hours
          cmpa #24  ;hours never reach 24, always 23:59
          bne done_with_local_time  ;exit
          movb #0, hours            ;or set back to zero
    
          ;after 24 hours, increment day variable
          inc day
          ldaa day
          cmpa #8  ;don't go to 8th day
          bne done_with_local_time ;exit if not
          movb #1, day             ;else set to monday
          
done_with_local_time:
  
          ;gmt time is the same as local time, just added 4 hours to default value
		  ;which is what gmt time is in indiana
		  ;we do not check the local time and adjust gmt time accordingly
		  ;we didn't think of that in time
          ldx gmt_counter
          inx
          stx gmt_counter
          cpx #1000                           ;second has passed
          lbne done_with_gmt_time
          movb #0, gmt_counter
          inc gmt_seconds
          ldaa gmt_seconds
          cmpa #60                            ;60 seconds has passed
          lbne done_with_gmt_time          
          movb #0, gmt_seconds
          inc gmt_minutes
          ldab gmt_minutes
          cmpb #60                            ;60 minutes has passed
          bne done_with_gmt_time
          movb #0, gmt_minutes
          inc gmt_hours
          ldaa gmt_hours
          cmpa #24                            ;24 hours has passed
          bne done_with_gmt_time
          movb #0, gmt_hours
          inc gmt_day
          ldaa gmt_day
          cmpa #8                             ;a week has passed
          bne done_with_gmt_time
          movb #1, gmt_day                    ;reset to monday
          
done_with_gmt_time:

;; ADDING CONTAINER SONG ;;
;it's just 6 incrementing notes, with more time better music could be played
add_cont:      ldab add_cont_song_flag          ;check if flag's set
               cmpb #1                          
               beq add_continue_song
               
               lbra remove_cont                 ;if not skip
               
add_continue_song:
               ;bset Port_t, #%00001000        ;turn on DC motor              
               ldaa toggle_note3			 ;flag initialized to zero
               bne  send_note1
               ldy  #song1
               sty  note_we_on
               movb #1, toggle_note3
                
send_note1:    ldy  note_we_on
               ldaa 0,y
               beq  reset3
               psha
               jsr  SendsChr
               pula
               jsr  PlayTone
                
               staa Port_s				   ;trying to blink LED's
                
               ldy  toggle_count
               iny
               sty  toggle_count
               cpy  #1000
               blt  done3
                
               movw #0, toggle_count
               ldy  note_we_on
               iny
               sty  note_we_on
               cpy  #song1+6
               bne  done3
               ;movb #0, pb_pressed         ;set the flags to zero
               ;bclr Port_t, #%00001000		;turn off DC motor
               movb #0, add_cont_song_flag
               movb #0, Port_s             ;turn off LED's when song is done
                
               bra  done3
                
reset3:        movb #0, toggle_note3
 
done3:               

;; REMOVING CONTAINER SONG ;;
;it's just 6 decrementing notes, with more time better music could be played
remove_cont:   ldab remove_cont_song_flag      ;checking if flag's set
               cmpb #1
               beq remove_continue_song
                
               lbra irq_button                 ;if not skip

remove_continue_song:
               ;bset Port_t, #%00001000        ;turn on DC motor                
               ldaa toggle_note4			 ;flag initialized to zero
               bne  send_note2
               ldy  #song1_backwards
               sty  note_we_on
               movb #1, toggle_note4
                
send_note2:    ldy  note_we_on
               ldaa 0,y
               beq  reset4
               psha
               jsr  SendsChr
               pula
               jsr  PlayTone
                
               staa Port_s				   ;trying to blink LED's during song
                
               ldy  toggle_count
               iny
               sty  toggle_count
               cpy  #1000
               blt  done4
                        
               movw #0, toggle_count
               ldy  note_we_on
               iny
               sty  note_we_on
               cpy  #song1_backwards+6
               bne  done4
               ;movb #0, pb_pressed         ;set the flags to zero
               
               ;bclr Port_t, #%00001000		;turn off DC motor
               movb #0, remove_cont_song_flag
               movb #0, Port_s             ;turn off LED's when song is done             
                
               bra  done4
                
reset4:        movb #0, toggle_note4
 
done4:       
  
;; CHECKING IF IRQ BUTTON WAS PRESSED ;;
;this will just play a "siren" type song
;and we push what's in A to LED's to act like
;siren lights
  
irq_button:     ldab irq_pressed
                cmpb #1                
                beq  continue_song         ;go play song if irq button pressed
                
                lbra push_button
                                                
continue_song:  
                bset Port_t, #%00001000        ;turn on DC motor   
                ldaa toggle_note			 ;flag initialized to zero
                bne  send_note
                ldy  #song2
                sty  note_we_on
                movb #1, toggle_note
                
send_note:      ldy  note_we_on
                ldaa 0,y
                beq  reset
                psha
                jsr  SendsChr
                pula
                jsr  PlayTone
                
                staa Port_s				   ;trying to blink LED's
                
                ldy  toggle_count
                iny
                sty  toggle_count
                ;not waiting for a second here, only 200ms
                cpy #200
                blt  done
                             
                movw #0, toggle_count
                ldy  note_we_on
                iny
                sty  note_we_on
                cpy  #song2+6
                bne  done
                movb #0, irq_pressed		;set IRQ flag back to zero
                movb #0, Port_s             ;turn off LED's when song is done
                bclr Port_t, #%00001000		;turn off DC motor
                jsr password                ;go to password menu here when done with IRQ
				                            ;occasionally the LCD will have the old message
											;stuck on the screen...
											;the keypress beeps stopped working during password
											;re-entry and if you don't enter right password
											;chip locks up....
											;just saying the current bugs with this approach
                
                bra  done
                
reset:          movb #0, toggle_note
 
done:
 

 ;; CHECK IF PUSHBUTTON PRESSED ;;
 ;here we turn the dc motor on at max speed
 ;(we couldn't get manual mode working)
 ;and jump to the time/date function and 
 ;splash a time stamp on the screen
 ;doing it that way means you could set
 ;the time from the manual mode, so probably
 ;not good if employee could tamper with timestamp
 ;but we had issues trying to just save a string
 ;(which we thought would be straight forward but
 ;it gave us substantial problems)
 
push_button:   
                ldaa Port_p 
                anda #$20	            
                cmpa #$20               ;check push button (active low)  
                                        ;since active low if masked out then it'll skip				
                lbeq  check_keypad      ;if not  pressed, branch to end of ISR
                
pb_debounce:    brclr Port_p, #$20, pb_debounce      ;hold the press until released
                                                     ;Nathan the TA liked this debounce 
													 ;on a pushbutton press
                ldab pb_pressed
                cmpb #1
                lbeq turn_off_led
                
                ;we are now inside manual mode, so here is where we want
				;to read a pot value, and use that to control the dc and stepper
				;motors, but we ran out of time for this
				;so we're just turning on dc motor and lighting up left 4 LEDs
				;to indicate in manual mode, also a timestamp on the LCD
                bset Port_t, #%00001000        ;turn on DC motor
                movb #1, pb_pressed
                movb #$0F, Port_s       ;light up led's to indicate pushbutton works...it does
                
                jsr local_time           ;displays time stamp, press A to get out     

;; CHECKING IF KEYPAD PRESSED, PLAY A LITTLE BEEP SOUND ;;
;here we use the song code to play a tiny beep each time a
;key is pressed.
;we only needed 25ms for this beep
              
check_keypad:   
                ldaa KeypressFlag
                cmpa #1
                bne dc_motor_delay       ;;This will change to whatever is after it,
                                         ;;want to be sure to skip "turn_off_led"
                    
key_pad_beep:                
                ldaa toggle_note2			 ;flag initialized to zero
                bne  send_beep
                ldy  #song3
                sty  note_we_on
                movb #1, toggle_note2		 ;this code sends little beeps to the speaker
                							 ;each time keypad is pressed
send_beep:      ldy  note_we_on
                ldaa 0,y
                beq  reset2
                psha
                jsr  SendsChr
                pula
                jsr  PlayTone
                ldy  toggle_count
                iny
                sty  toggle_count
                cpy #25                  ;25ms delay time
                blt  done2
                movw #0, toggle_count
                ldy  note_we_on
                iny
                sty  note_we_on
                cpy   #song3+6
                bne  done2
                movb #0, KeypressFlag
                      
                lbra  done2
                
reset2:         movb #0, toggle_note2
 
done2:
 
;this is label to either exit or stay out of manual mode
turn_off_led:
                movb #0, pb_pressed
                movb #$F0, Port_s
                movw #0, pb_pressed_debounce
                bclr Port_t, #%00001000		;turn off DC motor
                
                
;;DC MOTOR
dc_motor_delay:    ;unimplemented
                
done6:             
              
                ;silly feature to display a backdoor message
                ;if right 4 dip switches are set
				;i wanted it to bypass the password login
				;but was unable to get that to work
                ldaa Port_t             ;backdoor to get around password
                cmpa #%00001111
                beq display_backdoor_msg
                bne aalans_stepper
                 
               
display_backdoor_msg: 
                 
                 movb #1, backdoor_flag
				 
;tried to do a delay here for the stepper motor
;for unknown reason it would not work
;we had to use our rti_delay function
;which only works outside of the rti
                                                   
aalans_stepper:  ldaa step_delay_FLAG
                 cmpa #1
                 bne end2
                 ldy  toggle_count
                 iny
                 sty  toggle_count
                 cpy #25
                 blt  end2
                 movb #0, step_delay_FLAG
                 
end2:               
  
exit_rti:        ;return from interrupt
                 bset RTIFLG, #$80
                 rti
              
              
              