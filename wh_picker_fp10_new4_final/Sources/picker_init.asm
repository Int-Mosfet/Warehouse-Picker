 XDEF init

 XREF counter
 XREF day
 XREF hours
 XREF minutes
 XREF seconds
 XREF KEY_PRESSED
 XREF init_LCD
 XREF wh_password
 XREF wh_password1
 XREF wh_password2
 XREF wh_password3
 XREF wh_password4
 XREF container_index
 XREF clear_lcd_flag
 XREF cont_index_hundreds
 XREF cont_index_tens
 XREF cont_index_ones
 XREF Port_p_ddr
 XREF Port_s_ddr
 XREF Port_t_ddr
 XREF start_msg
 XREF inc_password_msg
 XREF RTIENA
 XREF RTIFLG
 XREF RTICTL 
 XREF remainder
 XREF HundredsDigit
 XREF TensDigit
 XREF OnesDigit
 XREF local_time_msg_1
 XREF local_time_msg_2
 XREF time_digits
 XREF gmt_counter
 XREF gmt_OnesDigit
 XREF gmt_TensDigit
 XREF gmt_HundredsDigit
 XREF gmt_remainder
 XREF gmt_day
 XREF gmt_hours
 XREF gmt_minutes
 XREF gmt_seconds
 XREF gmt_time_msg_1
 XREF gmt_time_digits
 XREF gmt_day_char_1
 XREF gmt_day_char_2
 XREF gmt_day_char_3
 XREF gmt_time_msg_2
 XREF added_cont_flag
 XREF removed_cont_flag
 XREF auto_dc_motor_flag  
 XREF man_dc_motor_flag
 XREF dc_count
 XREF dc_time_on
 XREF dc_time_off
 XREF prev_key
 XREF dc_delay_count
 XREF wh_picker_msg
 XREF wh_picker_msg_0
 XREF wh_picker_msg_1
 XREF wh_picker_msg_2
 XREF pb_pressed
 XREF pb_pressed_debounce
 XREF irq_pressed
 XREF toggle_note
 XREF toggle_note2
 XREF toggle_note3
 XREF toggle_note4
 XREF KeypressFlag
 XREF IRQ_to_PW_flag 
 XREF irq_time_stamp
 XREF bobs_flag
 XREF add_B_flag
 XREF add_B_flag1
 XREF add_cont_song_flag
 XREF remove_cont_song_flag
 XREF container_data
 XREF container_array
 XREF cont_check
 XREF step_delay_FLAG
 XREF STEP_COUNT
    
    
init:
	        jsr init_LCD          ; LCD initialization
			
	        ;;Bob's Flag
	        movb #0, bobs_flag    ;;beginning message for bob the employee
			
			;;Container Init
            ;movb #29, container_index    ;had to set to 29 initially b/c ASCII, make sure to add 29 to 96
            movb #1, container_index		 ;initialize to 1
            movb #0, cont_index_hundreds
            movb #0, cont_index_tens
            movb #0, cont_index_ones
            movb #0, added_cont_flag
            movb #0, removed_cont_flag
            movb #0, add_cont_song_flag
            movb #0, remove_cont_song_flag
            movb #0, container_data       ;set temp container variable to 0
            movb #0, add_B_flag	     ;for adding to container
            movb #0, add_B_flag1          ;for adding to container
            movb #0, cont_check
		    	
			;;STEPPER MOTOR
			movb #0, step_delay_FLAG
			movb #0, STEP_COUNT
			
			movb #0, counter
		    movb #1, day	  ;default is monday
			movb #6, hours	  ;at 6:00 (am or pm)
			movb #0, minutes
			movb #0, seconds
			
			movb #0, gmt_counter
			movb #1, gmt_day      ;default is monday
			movb #10, gmt_hours   ;4 hours ahead of local time for GMT
			                      ;so 10 (am or pm)
			movb #0, gmt_minutes
			movb #0, gmt_seconds
			
			;;KEYPAD
            movb #$F0, $26A      ;sends $F0 to port U direction register
            movb #$F0, $26D      ;sends $F0 to port U polarity select register
            movb #$0F, $26C      ;enables port U pull up register
            
            ;;RTI
            movb #$40, RTICTL  ;RTI will be serviced every 1 ms
            movb #$80, RTIENA  ;Enables RTI
            
            ;;PORTS
            movb #$FF, Port_s_ddr          ;LEDs set to output mode
            movb #%00101000, Port_t_ddr    ;bit 3 is set as input for the DC motor
            movb #%00011110, Port_p_ddr    ;set bits 1 to 4 of Port_p                                       
			;SPEAKER INIT
			movb #0, toggle_note              ;for siren "song" during irq
			movb #0, toggle_note2             ;for keypress beeps
			movb #0, toggle_note3             ;for add container "song"
			movb #0, toggle_note4             ;for remove container "song"
			
			;PUSHBUTTON INIT
			movb #0, pb_pressed               ;pushbutton flag
			movb #0, pb_pressed_debounce      ;pushbutton debounce
			
			;IRQ INIT
			movb #0, irq_pressed              ;irq flag
			movb #0, IRQ_to_PW_flag
			movw #0, irq_time_stamp
			
			;DC MOTOR INIT
            movb #0, auto_dc_motor_flag			;auto dc motor flag
            movb #0, man_dc_motor_flag			;manual dc motor flag
			movb #0, dc_time_on
			movb #0, prev_key
			movb #0, dc_count
			movb #15, dc_time_off
			movw #0, dc_delay_count         
			
			;set keypress flag to 0
			movb #0, KeypressFlag
			
			;;System password initialization;;
            movb #1, wh_password               ;password that works for now
            movb #1, wh_password+1
            movb #1, wh_password+2
            movb #1, wh_password+3
           
            movb #2, wh_password1
            movb #2, wh_password1+1
            movb #2, wh_password1+2
            movb #2, wh_password1+3
           
            movb #3, wh_password2
            movb #3, wh_password2+1
            movb #3, wh_password2+2
            movb #3, wh_password2+3
           
            movb #4, wh_password3
            movb #4, wh_password3+1
            movb #4, wh_password3+2
            movb #4, wh_password3+3
           
            movb #5, wh_password4
            movb #5, wh_password4+1
            movb #5, wh_password4+2
            movb #5, wh_password4+3
           
           
           ;;Cleaning Container Array
               ldx #container_array
               ldaa #0
               ldy  #0
clr_storage:   staa 1, x+             ;initializing memory as zero 
               iny
               cpy #100
               bne  clr_storage

	    	   

		 ;;LOCAL TIME INIT
		    movb #0, time_digits
            movb #0, time_digits+1
            movb #0, time_digits+2
            movb #0, time_digits+3
            movb #0, time_digits+4
            movb #0, OnesDigit
            movb #0, TensDigit
            movb #0, HundredsDigit
            movb #0, remainder
            
         ;;GMT TIME INIT
            movb #0, gmt_time_digits
            movb #0, gmt_time_digits+1
            movb #0, gmt_time_digits+2
            movb #0, gmt_time_digits+3
            movb #0, gmt_time_digits+4
            movb #0, gmt_OnesDigit
            movb #0, gmt_TensDigit
            movb #0, gmt_HundredsDigit
            movb #0, gmt_remainder
            
            
           
           
           
           ;;Time strings
            
           movb #'P',local_time_msg_1
           movb #'U',local_time_msg_1+1
           movb #'S',local_time_msg_1+2
           movb #'H',local_time_msg_1+3
           movb #' ',local_time_msg_1+4
           movb #'B',local_time_msg_1+5
           movb #' ',local_time_msg_1+6
           movb #'T',local_time_msg_1+7
           movb #'O',local_time_msg_1+8
           movb #' ',local_time_msg_1+9
           movb #'C',local_time_msg_1+10
           movb #'H',local_time_msg_1+11
           movb #'A',local_time_msg_1+12
           movb #'N',local_time_msg_1+13
           movb #'G',local_time_msg_1+14
           movb #'E',local_time_msg_1+15
           movb #' ',local_time_msg_1+16
           movb #' ',local_time_msg_1+17   
           movb #' ',local_time_msg_1+18  
           movb #' ',local_time_msg_1+19  
           movb #' ',local_time_msg_1+20
           movb #' ',local_time_msg_1+21
           movb #':',local_time_msg_1+22   
           movb #'_',local_time_msg_1+23
           movb #'_',local_time_msg_1+24
           movb #':',local_time_msg_1+25      
           movb #'_',local_time_msg_1+26
           movb #'_',local_time_msg_1+27
           movb #':',local_time_msg_1+28
           movb #'_',local_time_msg_1+29
           movb #'_',local_time_msg_1+30
           movb #'_',local_time_msg_1+31
           movb #0,  local_time_msg_1+32
           
           
           movb #'E',local_time_msg_2
           movb #'N',local_time_msg_2+1
           movb #'T',local_time_msg_2+2
           movb #'E',local_time_msg_2+3
           movb #'R',local_time_msg_2+4
           movb #' ',local_time_msg_2+5
           movb #'N',local_time_msg_2+6
           movb #'E',local_time_msg_2+7
           movb #'W',local_time_msg_2+8
           movb #' ',local_time_msg_2+9
           movb #'T',local_time_msg_2+10
           movb #'I',local_time_msg_2+11
           movb #'M',local_time_msg_2+12
           movb #'E',local_time_msg_2+13
           movb #' ',local_time_msg_2+14
           movb #' ',local_time_msg_2+15
           movb #' ',local_time_msg_2+16
           movb #' ',local_time_msg_2+17  
           movb #'_',local_time_msg_2+18
           movb #'_',local_time_msg_2+19
           movb #':',local_time_msg_2+20   
           movb #'_',local_time_msg_2+21
           movb #'_',local_time_msg_2+22
           movb #':',local_time_msg_2+23    
           movb #'_',local_time_msg_2+24
           movb #'_',local_time_msg_2+25
           movb #'_',local_time_msg_2+26  
           movb #' ',local_time_msg_2+27     
           movb #' ',local_time_msg_2+28      
           movb #' ',local_time_msg_2+29      
           movb #' ',local_time_msg_2+30      
           movb #' ',local_time_msg_2+31
           movb #0,  local_time_msg_2+32
           
           movb #'P',gmt_time_msg_1
           movb #'U',gmt_time_msg_1+1
           movb #'S',gmt_time_msg_1+2
           movb #'H',gmt_time_msg_1+3
           movb #' ',gmt_time_msg_1+4
           movb #'B',gmt_time_msg_1+5
           movb #' ',gmt_time_msg_1+6
           movb #'T',gmt_time_msg_1+7
           movb #'O',gmt_time_msg_1+8
           movb #' ',gmt_time_msg_1+9
           movb #'C',gmt_time_msg_1+10
           movb #'H',gmt_time_msg_1+11
           movb #'A',gmt_time_msg_1+12
           movb #'N',gmt_time_msg_1+13
           movb #'G',gmt_time_msg_1+14
           movb #'E',gmt_time_msg_1+15
           movb #' ',gmt_time_msg_1+16
           movb #' ',gmt_time_msg_1+17   
           movb #' ',gmt_time_msg_1+18  
           movb #' ',gmt_time_msg_1+19  
           movb #' ',gmt_time_msg_1+20
           movb #' ',gmt_time_msg_1+21
           movb #':',gmt_time_msg_1+22   
           movb #'_',gmt_time_msg_1+23
           movb #'_',gmt_time_msg_1+24
           movb #':',gmt_time_msg_1+25      
           movb #'_',gmt_time_msg_1+26
           movb #'_',gmt_time_msg_1+27
           movb #':',gmt_time_msg_1+28
           movb #'_',gmt_time_msg_1+29
           movb #'_',gmt_time_msg_1+30
           movb #'_',gmt_time_msg_1+31
           movb #0,  gmt_time_msg_1+32
           
           movb #'E',gmt_time_msg_2
           movb #'N',gmt_time_msg_2+1
           movb #'T',gmt_time_msg_2+2
           movb #'E',gmt_time_msg_2+3
           movb #'R',gmt_time_msg_2+4
           movb #' ',gmt_time_msg_2+5
           movb #'N',gmt_time_msg_2+6
           movb #'E',gmt_time_msg_2+7
           movb #'W',gmt_time_msg_2+8
           movb #' ',gmt_time_msg_2+9
           movb #'T',gmt_time_msg_2+10
           movb #'I',gmt_time_msg_2+11
           movb #'M',gmt_time_msg_2+12
           movb #'E',gmt_time_msg_2+13
           movb #' ',gmt_time_msg_2+14
           movb #' ',gmt_time_msg_2+15
           movb #' ',gmt_time_msg_2+16
           movb #' ',gmt_time_msg_2+17  
           movb #'_',gmt_time_msg_2+18
           movb #'_',gmt_time_msg_2+19
           movb #':',gmt_time_msg_2+20   
           movb #'_',gmt_time_msg_2+21
           movb #'_',gmt_time_msg_2+22
           movb #':',gmt_time_msg_2+23    
           movb #'_',gmt_time_msg_2+24
           movb #'_',gmt_time_msg_2+25
           movb #'_',gmt_time_msg_2+26 
           movb #' ',gmt_time_msg_2+27     
           movb #' ',gmt_time_msg_2+28      
           movb #' ',gmt_time_msg_2+29      
           movb #' ',gmt_time_msg_2+30      
           movb #' ',gmt_time_msg_2+31
           movb #0,  gmt_time_msg_2+32
            
           
           ;movb #0, clear_lcd_flag		   ;workaround that doesn't work
           
           ;;;DUMMY message, fixes LCD bug temporarily....nasty bug
           
           movb #0,wh_picker_msg
           movb #0,wh_picker_msg+1
           movb #0,wh_picker_msg+2
           movb #0,wh_picker_msg+3
           movb #0,wh_picker_msg+4
           movb #0,wh_picker_msg+5
           movb #0,wh_picker_msg+6
           movb #0,wh_picker_msg+7
           movb #0,wh_picker_msg+8
           movb #0,wh_picker_msg+9
           movb #0,wh_picker_msg+10
           movb #0,wh_picker_msg+11
           movb #0,wh_picker_msg+12
           movb #0,wh_picker_msg+13
           movb #0,wh_picker_msg+14
           movb #0,wh_picker_msg+15	 
           movb #0,wh_picker_msg+16
           movb #0,wh_picker_msg+17   
           movb #0,wh_picker_msg+18  
           movb #0,wh_picker_msg+19  
           movb #0,wh_picker_msg+20   
           movb #0,wh_picker_msg+21  
           movb #0,wh_picker_msg+22   
           movb #0,wh_picker_msg+23
           movb #0,wh_picker_msg+24   
           movb #0,wh_picker_msg+25      
           movb #0,wh_picker_msg+26   
           movb #0,wh_picker_msg+27   
           movb #0,wh_picker_msg+28   
           movb #0,wh_picker_msg+29   
           movb #0,wh_picker_msg+30   
           movb #0,wh_picker_msg+31
           movb #0,wh_picker_msg+32
           
           
           ;;wh_control menu strings
           
		   ;press C to add container
           movb #'P',wh_picker_msg_0
           movb #'r',wh_picker_msg_0+1
           movb #'e',wh_picker_msg_0+2
           movb #'s',wh_picker_msg_0+3
           movb #'s',wh_picker_msg_0+4
           movb #' ',wh_picker_msg_0+5
           movb #'C',wh_picker_msg_0+6
           movb #' ',wh_picker_msg_0+7
           movb #'t',wh_picker_msg_0+8
           movb #'o',wh_picker_msg_0+9
           movb #' ',wh_picker_msg_0+10
           movb #'a',wh_picker_msg_0+11
           movb #'d',wh_picker_msg_0+12
           movb #'d',wh_picker_msg_0+13
           movb #' ',wh_picker_msg_0+14
           movb #':',wh_picker_msg_0+15	 
           movb #' ',wh_picker_msg_0+16
           movb #' ',wh_picker_msg_0+17
           movb #' ',wh_picker_msg_0+18
           movb #' ',wh_picker_msg_0+19  
           movb #' ',wh_picker_msg_0+20   
           movb #' ',wh_picker_msg_0+21  
           movb #' ',wh_picker_msg_0+22   
           movb #' ',wh_picker_msg_0+23   
           movb #' ',wh_picker_msg_0+24   
           movb #' ',wh_picker_msg_0+25      
           movb #' ',wh_picker_msg_0+26   
           movb #' ',wh_picker_msg_0+27   
           movb #' ',wh_picker_msg_0+28   
           movb #' ',wh_picker_msg_0+29   
           movb #' ',wh_picker_msg_0+30   
           movb #' ',wh_picker_msg_0+31
           movb #0,  wh_picker_msg_0+32
           
           
           ;press D to erase container
           movb #'P',wh_picker_msg_1
           movb #'r',wh_picker_msg_1+1
           movb #'e',wh_picker_msg_1+2
           movb #'s',wh_picker_msg_1+3
           movb #'s',wh_picker_msg_1+4
           movb #' ',wh_picker_msg_1+5
           movb #'D',wh_picker_msg_1+6
           movb #' ',wh_picker_msg_1+7
           movb #'t',wh_picker_msg_1+8
           movb #'o',wh_picker_msg_1+9
           movb #' ',wh_picker_msg_1+10
           movb #'e',wh_picker_msg_1+11
           movb #'r',wh_picker_msg_1+12
           movb #'a',wh_picker_msg_1+13
           movb #'s',wh_picker_msg_1+14
           movb #'e',wh_picker_msg_1+15
           movb #' ',wh_picker_msg_1+16
           movb #' ',wh_picker_msg_1+17
           movb #' ',wh_picker_msg_1+18
           movb #' ',wh_picker_msg_1+19  
           movb #' ',wh_picker_msg_1+20   
           movb #' ',wh_picker_msg_1+21   
           movb #' ',wh_picker_msg_1+22   
           movb #' ',wh_picker_msg_1+23   
           movb #' ',wh_picker_msg_1+24   
           movb #' ',wh_picker_msg_1+25      
           movb #' ',wh_picker_msg_1+26   
           movb #' ',wh_picker_msg_1+27   
           movb #' ',wh_picker_msg_1+28   
           movb #' ',wh_picker_msg_1+29   
           movb #' ',wh_picker_msg_1+30   
           movb #' ',wh_picker_msg_1+31
           movb #0,  wh_picker_msg_1+32
           
		   ;this is to check containers
		   ;press E to check current container
           movb #'C',wh_picker_msg_2
           movb #'h',wh_picker_msg_2+1
           movb #'e',wh_picker_msg_2+2
           movb #'c',wh_picker_msg_2+3
           movb #'k',wh_picker_msg_2+4
           movb #' ',wh_picker_msg_2+5      
           movb #'C',wh_picker_msg_2+6
           movb #'o',wh_picker_msg_2+7
           movb #'n',wh_picker_msg_2+8
           movb #'t',wh_picker_msg_2+9
           movb #'a',wh_picker_msg_2+10
           movb #'i',wh_picker_msg_2+11
           movb #'n',wh_picker_msg_2+12
           movb #'e',wh_picker_msg_2+13
           movb #'r',wh_picker_msg_2+14
           movb #':',wh_picker_msg_2+15
           movb #' ',wh_picker_msg_2+16
           movb #' ',wh_picker_msg_2+17
           movb #' ',wh_picker_msg_2+18
           movb #' ',wh_picker_msg_2+19  
           movb #' ',wh_picker_msg_2+20   
           movb #' ',wh_picker_msg_2+21   
           movb #' ',wh_picker_msg_2+22   
           movb #' ',wh_picker_msg_2+23   
           movb #' ',wh_picker_msg_2+24   
           movb #' ',wh_picker_msg_2+25      
           movb #' ',wh_picker_msg_2+26   
           movb #' ',wh_picker_msg_2+27   
           movb #' ',wh_picker_msg_2+28   
           movb #' ',wh_picker_msg_2+29   
           movb #' ',wh_picker_msg_2+30   
           movb #' ',wh_picker_msg_2+31
           movb #0,  wh_picker_msg_2+32
           
           
	       rts
	       
	       
	       