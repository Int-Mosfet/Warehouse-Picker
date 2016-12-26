 XDEF wh_picker

 XREF wh_picker_msg
 XREF wh_picker_msg_0
 XREF wh_picker_msg_1
 XREF wh_picker_msg_2 
 XREF KEY_PRESSED
 XREF pot_value
 XREF read_keypad
 XREF display_to_lcd
 XREF read_pot
 XREF container_index
 XREF cont_index_hundreds
 XREF cont_index_tens
 XREF cont_index_ones
 XREF cont_index_remainder
 XREF clear_LCD_screen
 XREF clear_lcd_flag
 XREF switch_warning_msg
 XREF switch_warning_msg2
 XREF med_or_large_msg
 XREF heavy_or_light_msg
 XREF fragile_or_rugged_msg
 XREF rti_delay
 XREF Port_t
 XREF Port_s
 XREF IRQ_to_PW_flag
 XREF password
 XREF irq_time_stamp
 XREF added_cont_flag
 XREF removed_cont_flag
 XREF add_cont_song_flag
 XREF remove_cont_song_flag
 XREF cont_check
 XREF container_array
 XREF container_data
 XREF add_B_flag
 XREF add_B_flag1
 XREF Port_p
 XREF m_seq
 XREF step_delay_FLAG
 XREF STEP_COUNT
 XREF main_menu
                                                                                         
wh_picker:    ;pshd       ;taking out push/pulls due to SP bug
              ;pshx
checking_pot:    jsr read_pot 
                 bclr pot_value, #$F0
                 
                 ;movb #0, wh_control_msg_2+16             ;trying to clear out check container
                 ;movb #0, wh_control_msg_2+17
                 ;movb #0, wh_control_msg_2+18
                  
                 ldd pot_value
                 cmpb #20
                 lbhs WH_MENU_2
                             
WH_MENU_1:          
                 ldd #wh_picker_msg_0
                 jsr display_to_lcd 
                 
                 jsr read_keypad 
                 ldaa KEY_PRESSED
                 
add_container:
                ;ldd
                ;movw #1, container_array+container_index 
                ;bset container_array, #%00000001 000000001
                
                ;;;;trying to fix lcd bug...this didn't work;;;;
                ;psha
                ;ldaa clear_lcd_flag
                ;inca
                ;cmpa #$1
                ;pula
                ;;lbeq dont_clear_screen
                ;lbhs dont_clear_screen
                ;pshd
                ;ldd #clear_LCD_screen
                ;jsr display_to_lcd
                ;puld
                
  ;dont_clear_screen: 
                
                movb cont_index_hundreds, wh_picker_msg_0+16
                movb cont_index_tens, wh_picker_msg_0+17
                movb cont_index_ones, wh_picker_msg_0+18
                
                ldab added_cont_flag        ;flag checking if container was added
                cmpb #1						;This fixes a weird bug with adds up amount of times
                lbeq exit_wh_picker		;you need to press "A" to go back to main menu
                
                ;;;CHECKING FOR OTHER KEYS PRESSED, TO NOT DO ANYTHING IF PRESSED;;;
                cmpa $01
                beq  checking_pot
                cmpa $02
                beq  checking_pot
                cmpa $03
                beq  checking_pot
                cmpa $04
                beq  checking_pot
                cmpa $05
                beq  checking_pot
                cmpa $06
                beq  checking_pot
                cmpa $07
                beq  checking_pot
                cmpa $08
                beq  checking_pot
                cmpa $09
                beq  checking_pot
                cmpa $0D
                beq  checking_pot
                cmpa $0E
                beq  checking_pot
                cmpa $0F
                beq  checking_pot
                ;;;END CHECKING FOR OTHER KEYS PRESSED;;;
                
                cmpa #$0C				;if C is pressed, increment index
                beq inc_cont_index
   
                ;cmpa #$0D
                ;lbeq dec_cont_index
  
                
                ;cmpa #125			 ;overflow check, check is 96 +29 for ASCII conversion reasons...
                ;beq container_full
                ;container_full:	 ;warn user that containers are all full
                 
                 cmpa #$0A                   ;pressing A exits to prior menu
                 lbeq exit_wh_picker             
                     
                 cmpa #$0B        ;B adds a container
                 lbne  checking_pot
                 ;movb #1, sub_menu
                 ;jsr sub_menu_select
                 
inc_cont_index:  ;pshx                    ;remove pushes due to stack pointer issues
                 ;pshd
                 clra
                 ldab container_index     ;incrementing index by 1
                 ldx #100
                 idiv
                 std cont_index_remainder
                 tfr x,d
                 stab cont_index_hundreds
                 ldd cont_index_remainder
                 ldx #10
                 idiv
                 std cont_index_remainder
                 tfr x,d
                 stab cont_index_tens
                 ldd cont_index_remainder
                 stab cont_index_ones
                 ;convert to ascii
                 ldaa cont_index_hundreds
                 adda #$30
                 staa cont_index_hundreds
                 
                 ldaa cont_index_tens
                 adda #$30
                 staa cont_index_tens
                 
                 ldaa cont_index_ones
                 adda #$30
                 staa cont_index_ones
                 
                 inc container_index         ;increment container index
                 
                 ;jsr to next parameter here I think
                 ;this will check all the parameters for containers
                 ;at least one subroutine for each parameter
                 
                 ;; BUG IN SWITCH CHECK, WON'T READ PORT_T AFTER SWITCHING TO OPPOSITE SETTING ;;
                 ;; (TRYING TO REMOVE AFTER ADDING OR VICE VERSA)  ;;
                 ;; BUG APPEARED AFTER ADDING SONGS TO ADD/REMOVE CONTAINER ;;
                 ;; commenting out for now
                 ;jsr switch_check
                 ;lbra switch_check
                 lbra medium_or_large  ;temp fix for add/remove bug
                     
                 lbra checking_pot		   ;return back to loop
                 
WH_MENU_2:          ldd pot_value
                 cmpb #50
                 lbhs  WH_MENU_3
                 ldd #wh_picker_msg_1         ;load address of string and display
                 jsr display_to_lcd 
                 
                 jsr read_keypad 
                 ldaa KEY_PRESSED
                 
remove_container: 
                 ;displaying index of container
                 movb cont_index_hundreds, wh_picker_msg_1+16
                 movb cont_index_tens, wh_picker_msg_1+17
                 movb cont_index_ones, wh_picker_msg_1+18
                
                 ldab removed_cont_flag		   ;flag checking if container was added
                 cmpb #1					   ;This fixes a weird bug with adds up amount of times
                 lbeq exit_wh_picker		   ;you need to press "A" to go back to main menu
                 
                 ;;;CHECKING FOR OTHER KEYS PRESSED, TO NOT DO ANYTHING IF PRESSED;;;
                cmpa $01
                lbeq  checking_pot
                cmpa $02
                lbeq  checking_pot
                cmpa $03
                lbeq  checking_pot
                cmpa $04
                lbeq  checking_pot
                cmpa $05
                lbeq  checking_pot
                cmpa $06
                lbeq  checking_pot
                cmpa $07
                lbeq  checking_pot
                cmpa $08
                lbeq  checking_pot
                cmpa $09
                lbeq  checking_pot
                cmpa $0C
                lbeq  checking_pot
                cmpa $0E
                lbeq  checking_pot
                cmpa $0F
                lbeq  checking_pot
                ;;;END CHECKING FOR OTHER KEYS PRESSED;;;
                 
                 cmpa #$0D				;if D is pressed, decrement index
                 lbeq dec_cont_index
                
                 cmpa #$0A                      ;pressing A exits to prior menu
                 lbeq exit_wh_picker   
                     
                 cmpa #$0B        ;pressing B removes a container
                 lbne  checking_pot
                 
dec_cont_index:  
                 ;pshx                    ;remove pushes due to stack pointer issues
                 ;pshd
                 clra
                 ldab container_index     ;incrementing index by 1
                 ldx #100
                 idiv
                 std cont_index_remainder
                 tfr x,d
                 stab cont_index_hundreds
                 ldd cont_index_remainder
                 ldx #10
                 idiv
                 std cont_index_remainder
                 tfr x,d
                 stab cont_index_tens
                 ldd cont_index_remainder
                 stab cont_index_ones
                 ;convert to ascii
                 ldaa cont_index_hundreds
                 adda #$30
                 staa cont_index_hundreds
                 
                 ldaa cont_index_tens
                 adda #$30
                 staa cont_index_tens
                 
                 ldaa cont_index_ones
                 adda #$30
                 staa cont_index_ones
                  
                 dec container_index		 ;decrement container index
                 
                 ;jsr to next parameter here I think
                 ;this will check all the parameters for containers
                 ;at least one subroutine for each parameter
                 
                 ;; BUG IN SWITCH CHECK, WON'T READ PORT_T AFTER SWITCHING TO OPPOSITE SETTING ;;
                 ;; (TRYING TO REMOVE AFTER ADDING OR VICE VERSA)  ;;
                 ;; BUG APPEARED AFTER ADDING SONGS TO ADD/REMOVE CONTAINER ;;
                 ;; commenting out for now
                 ;jsr switch_check2
                 lbra delete_container  ;temp fix for add/remove bug
                 
                 
                 
                 ; movb #2, sub_menu
                 ; jsr sub_menu_select    
                 lbra checking_pot
                 
WH_MENU_3:       ldd #wh_picker_msg_2 ;load address of string and display
                 jsr display_to_lcd 
                 ;read keys in this menu
                 jsr read_keypad 
                 ldaa KEY_PRESSED
                 
                 ;;;CHECKING FOR OTHER KEYS PRESSED, TO NOT DO ANYTHING IF PRESSED;;;
                cmpa $01
                lbeq  checking_pot
                cmpa $02
                lbeq  checking_pot
                cmpa $03
                lbeq  checking_pot
                cmpa $04
                lbeq  checking_pot
                cmpa $05
                lbeq  checking_pot
                cmpa $06
                lbeq  checking_pot
                cmpa $07
                lbeq  checking_pot
                cmpa $08
                lbeq  checking_pot
                cmpa $09
                lbeq  checking_pot
                cmpa $0C
                lbeq  checking_pot
                cmpa $0D
                lbeq  checking_pot
                cmpa $0F
                lbeq  checking_pot
                ;;;END CHECKING FOR OTHER KEYS PRESSED;;;
                
                 ;cmpa #$0E
                 ;;;Trying to load a time stamp here...needs work
                 ;ldd #irq_time_stamp
                 ;jsr display_to_lcd
                 ;jsr rti_delay
                 ;jsr rti_delay
                
                 cmpa #$0A                      ;pressing A exits to prior menu
                 lbeq exit_wh_picker
                 
                 cmpa #$0B        ;B to select
                 lbne  checking_pot
                 ;movb #3, sub_menu
                 ;jsr sub_menu_select
                 
                 
                 ldab container_index
                 ldaa add_B_flag
                 cmpa #0
                 beq first_time
                 bne after_first_time
                 
first_time:      inc add_B_flag
                 addb #2
                  
after_first_time:ldx #container_array
                 ;leax container_index, x
next_container3: ldaa 1, x+
                 ;cmpb container_index  ;-1
                 cmpb #0  ;#0
                 beq at_container3
                 decb
                 bra next_container3         ;we're at the container we want to modify
at_container3:   
                 staa cont_check         ;save what was in A
                 anda #$01               ;masking off first bit
                 cmpa #1                 ;check first bit if #1
                 beq display_its_big     ;branch to put a B on screen
display_its_medium:
                 movb #$4D, wh_picker_msg_2+16      ;else put an M on screen			  M
                 bra next_disp

display_its_big: 
                 movb #$42, wh_picker_msg_2+16       ;put B on screen				  B
next_disp:       
                 ldaa cont_check         ;put cont_check back into A
                 anda #$02               ;mask off second bit
                 cmpa #2                 ;check if it's #2
                 beq display_its_light   ;branch to put an L on screen
display_its_heavy:
                 movb #$48, wh_picker_msg_2+17      ;else put an H on screen			   H
                 bra next_disp2
         
display_its_light:
                 movb #$4C, wh_picker_msg_2+17       ;put L on screen				   L
next_disp2:
                 ldaa cont_check         ;put cont_check back into A
                 anda #$04               ;mask off third bit
                 cmpa #4                 ;check if it's #3
                 beq display_its_rugged  ;branch to put an R on screen				   
display_its_fragile:
                 movb #$46, wh_picker_msg_2+18       ;else put an F on screen		   F
                 bra next_disp3
                 
display_its_rugged:
                 movb #$52, wh_picker_msg_2+18         ;put R on screen			   R
next_disp3:                       
			     ;;finish adding check container code    
                 lbra checking_pot
                 
  
switch_check:	 ;pshd
                 
                 ldaa Port_t
                 ;cmpa #%11000000		   
                 cmpa #%10001100 ;check that switch something is set (not finalized)
                 lbeq medium_or_large	   ;branch if it is
                 ;dec container_index       ;decrement b/c switch wasn't set
                 ldd #switch_warning_msg   ;else display warning that right switches aren't set
                 jsr display_to_lcd
                 jsr rti_delay ;2 sec delay for warning msg
                 jsr rti_delay 
                 ;puld
                 bra switch_check
                 ;rts
                 
switch_check2:   ;pshd
                 
                 ldaa Port_t
                 ;cmpa #%00000011		   
                 cmpa #%00000000  ;check that switch something is set (not finalized)
                 lbeq delete_container	   ;branch to delete_container if it is
                 inc container_index       ;increment b/c switch wasn't set
                 ldd #switch_warning_msg2  ;else display warning that right switches aren't set
                 jsr display_to_lcd
                 jsr rti_delay  ;2 sec delay for warning msg
                 jsr rti_delay 
                 ;puld
				 bra switch_check2
                 ;rts               
                               
                 
medium_or_large: ;pshd               
                   
                   ldd #med_or_large_msg			   ;setting container as medium or large
                   jsr display_to_lcd
                   
                   jsr read_keypad 
                   ldaa KEY_PRESSED
                   
                   cmpa #$01
                   lbeq set_medium
                   
                   cmpa #$02
                   lbeq set_large
                   
                   bra medium_or_large			   ;else keep displaying message
                   
set_medium:	       movb #1, Port_s
                   bclr container_data, #%00000001   ;clear bit 0
                   bra heavy_or_light
  
set_large:  	   movb #2, Port_s
                   bset container_data, #%00000001   ;set bit 0
                    ;rts
                   
  
heavy_or_light:  
                   ldd #heavy_or_light_msg			 ;setting container as heavy or light
                   jsr display_to_lcd
                   
                   jsr read_keypad
                   ldaa KEY_PRESSED
                   
                   cmpa #$01
                   lbeq set_heavy
                   
                   cmpa #$02
                   lbeq set_light
                   
                   bra heavy_or_light			;else keep displaying message
                   ;cmpa #$FF
                   ;lbeq heavy_or_light
                   
set_heavy:	       movb #3, Port_s
                   bclr container_data, #%00000010		   ;clear bit 1
                   bra fragile_or_rugged
  
set_light:  	   movb #4, Port_s
                   bset container_data, #%00000010		   ;set bit 1
                   ;rts
  
fragile_or_rugged:   ldd #fragile_or_rugged_msg			  ;setting container as fragile or rugged
                     jsr display_to_lcd
                   
                     jsr read_keypad
                     ldaa KEY_PRESSED
                   
                     cmpa #$01
                     lbeq set_fragile
                   
                     cmpa #$02
                     lbeq set_rugged
                     
                     bra fragile_or_rugged		   ;else keep displaying message
                     ;cmpa #$FF
                     ;lbeq fragile_or_rugged
                     
set_fragile:    	 movb #5, Port_s
                     bclr container_data, #%00000100	  ;clear bit 2
                     bra end_cont_menu
   
set_rugged:	    	 movb #6, Port_s
                     bset container_data, #%00000100	  ;set bit 2
   
end_cont_menu:	     ;puld
                     ;rts						  ;this gets lost in memory
                     movb #$FF, Port_s
                     movb #1, added_cont_flag
                     movb #1, remove_cont_song_flag  ;play the incrementing jingle, doesn't make sense since I had to swap flags...bugs...
                     
                     ;movb #$FF, Port_s
                     ;Fixes unknown bug....
                     jsr rti_delay
					 jsr rti_delay
					 jsr rti_delay
                     
                     ;ldab #0
                     ldab container_index
                     ;ldaa add_B_flag1
                     ;cmpa #0
                    ; beq first_time1
                     ;bne after_first_time1
                 
;first_time1:         inc add_B_flag1
;                     addb #2
;after_first_time1:   
                     ldx #container_array
                     ;leax container_index, x
next_container1:     ldaa 1, x+
                     ;cmpb container_index  ;-1
                     cmpb #0
                     beq at_container
                     decb
                     bra next_container1         ;we're at the container we want to modify
at_container:        oraa container_data
                     staa 1, x                   ;putting user package to storage                     
                     ;inc container_index         ;increment container index

dc_motor_on:         
                     jsr rti_delay
                     jsr rti_delay
                     jsr rti_delay
                     jsr rti_delay
                     jsr rti_delay
                     
                     
                     bset Port_t, #%00001000        ;turn on motor
                     ;movb #1, dc_motor_test_flag    ;delay on time of motor
                
                     jsr rti_delay
                     movb #$01, Port_s
                     jsr rti_delay
                     movb #$03, Port_s
                     jsr rti_delay
                     movb #$07, Port_s
                     jsr rti_delay
                     movb #$0F, Port_s
                    
                     
                     bclr Port_t, #%00001000
                     
                     
reset1:              ldx #m_seq      ;pointer x to first motor sequence index

                     ldaa 4, +x  ;pre-increment x to point to last non-zero value of the array      

loop:                ldaa 1, x-  ;decrement x

                     cmpa #0     ;compare to null byte terminator
       
                     beq reset1  ;start at end of array if pointing to 0

                     staa Port_p ;output to motor

                     jsr slow       ; slow delay subroutine is run by default

                     bra loop
       
slow:                jsr rti_delay       ;;very slow, but works

                     ;wai                        ;;doesn't work
                     ;movb #1, step_delay_FLAG   ;;doesn't work
                     ldab STEP_COUNT
                     cmpb #4
                     ;beq back0
                     beq exit_steppy
                     inc STEP_COUNT

                     bra loop
                     
exit_steppy:         movb #0, STEP_COUNT
                     
                     
                     bset Port_t, #%00001000        ;turn on dc motor
                
                     jsr rti_delay
                     movb #$1F, Port_s
                     jsr rti_delay
                     movb #$3F, Port_s
                     jsr rti_delay
                     movb #$7F, Port_s
                     jsr rti_delay
                     movb #$FF, Port_s
                     jsr rti_delay
                     
                     bclr Port_t, #%00001000        ;turn off dc motor
                     movb #0, Port_s
                     ;lbra checking_pot			  ;gets lost in memory
                     lbra main_menu           ;goes back to main menu
                     
                     ;lbra exit_wh_picker		  ;gets lost in memory
                     ;jsr switch_check			  ;this constantly goes to switch_check, doesn't lock up
  					 
delete_container:    movb #1, add_cont_song_flag   ;play the decrementing jingle, doesn't make sense since I had to swap flags...bugs...
                     movb #7, Port_s
   	                 movb #1, removed_cont_flag
   	                 
   	                 ;Fixes unknown bug....
                     jsr rti_delay
                     jsr rti_delay
                     jsr rti_delay
   					 
   			         ;ldab #0  
                     ldab container_index
                     ldx #container_array
next_container2:     ldaa 1, x+
                     ;cmpb container_index  ;-1
                     cmpb #0
                     beq at_container2
                     decb
                     bra next_container2         ;we're at the container we want to modify
at_container2:      
                     ;ldaa 1, x+
                     ;incb
                     ;cmpb container_index-2
                     ;bne next_container2         ;we're at the container we want to modify
                     ldaa #0
                     staa 1, x
                     dec container_index
                     
dc_motor_on2:        jsr rti_delay
                     jsr rti_delay
                     jsr rti_delay
                     jsr rti_delay
                     jsr rti_delay
                     jsr rti_delay
                     bset Port_t, #%00001000        ;turn on dc motor
                     
                     movb #$FF, Port_s
                     jsr rti_delay
                     jsr rti_delay
                     movb #$7F, Port_s
                     jsr rti_delay
                     movb #$3F, Port_s
                     jsr rti_delay
                     movb #$1F, Port_s
                     jsr rti_delay
                     movb #$0F, Port_s
                     
                     bclr Port_t, #%00001000        ;turn off dc motor
                     
                     
reset12:             ldx #m_seq      ;pointer x to first motor sequence index

                     ldaa 4, +x  ;pre-increment x to point to last non-zero value of the array      

loop2:               ldaa 1, x-  ;decrement x

                     cmpa #0     ;compare to null byte terminator
       
                     beq reset12  ;start at end of array if pointing to 0

                     staa Port_p ;output to motor

                     jsr slow2       ; slow delay subroutine is run by default

                     bra loop2
       
slow2:               jsr rti_delay       ;;very slow, but works

                     ;wai                        ;;doesn't work
                     ;movb #1, step_delay_FLAG   ;;doesn't work
                     ldab STEP_COUNT
                     cmpb #4
                     ;beq back0
                     beq exit_steppy2
                     inc STEP_COUNT

                     bra loop2
                     
exit_steppy2:        movb #0, STEP_COUNT
                     
                     bset Port_t, #%00001000        ;turn on dc motor
                
                     jsr rti_delay
                     movb #$07, Port_s
                     jsr rti_delay
                     movb #$03, Port_s
                     jsr rti_delay
                     movb #$01, Port_s
                     jsr rti_delay
                     movb #$00, Port_s
                     jsr rti_delay
                     
                     bclr Port_t, #%00001000       ;turn off dc motor
                     
                     ;lbra checking_pot			  ;gets lost in memory
                     lbra main_menu                           
                     
exit_wh_picker:      ;pulx
                     ;puld
                     ;puld   ;Need 2 extra puld's because we are off somewhere....
                     ;puld   ;Not fixing that due to time....it's a dirty temp. fix
					         ;to remove most push/pulls
                     movb #0, removed_cont_flag
                     movb #0, added_cont_flag
                     
                     movb #0, wh_picker_msg_2+16             ;trying to clear out check container
                     movb #0, wh_picker_msg_2+17
                     movb #0, wh_picker_msg_2+18
                     
                     rts
                     
                     
                     
                     