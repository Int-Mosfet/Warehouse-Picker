 XDEF main_menu

 XREF read_pot
 XREF pot_value
 XREF display_to_lcd
 XREF disp
 XREF read_keypad
 XREF KEY_PRESSED
 XREF sub_menu
 XREF IRQ_to_PW_flag
 XREF wh_picker
 XREF Port_s
 XREF local_time
 XREF gmt_time
 XREF password
 XREF backdoor_flag
 XREF backdoor_msg
 XREF rti_delay
 XREF MAIN_MENU_MSG_1
 XREF MAIN_MENU_MSG_2
 XREF MAIN_MENU_MSG_3
 XREF MAIN_MENU_MSG_4
 XREF MAIN_MENU_MSG_5

;after initializing variables in main.asm and picker_init.asm, we enter here
;once we enter main_menu.asm, we pretty much never leave except to go to other functions
;we always return here
;we constantly read the pot value and this is used to display a certain menu
;if you get much more menus, there'll be too many and since these pots aren't 
;in the best conditions sometimes, the max value you'll read is around 170 or worse
;(supposed to read up to 255)
;if the pot value is greater than 110, then we hop there and execute the code
;so fast you can't notice it
;if this was slowed down a lot, the screen would flicker
;the end result is a fairly smooth looking user interface for the LCD
;push A on key pad to go back, and B to select

main_menu:       ;pshd       ;saves the only register that will be touched by this subroutine
                 ;pshx
reading_pot:     ldaa backdoor_flag
                 cmpa #1
                 lbeq display_backdoor_msg
                 jsr read_pot 
                 bclr pot_value, #$F0      
                 ldd pot_value
                 cmpb #20
                 bhs  MENU_2 
                 
MENU_1:   
                 ldd #MAIN_MENU_MSG_1
                 jsr display_to_lcd 
                     
                 jsr read_keypad
                 ldaa KEY_PRESSED  
                 cmpa #$0B
                 bne  reading_pot
                 jsr wh_picker               ;add container
                 bra reading_pot
                          
MENU_2:          ldd pot_value
                 cmpb #50
                 bhs  MENU_3
                 ldd #MAIN_MENU_MSG_2
                 jsr display_to_lcd 
                     
                 jsr read_keypad
                 ldaa KEY_PRESSED
                 cmpa #$0B
                 bne  reading_pot
                 jsr wh_picker                ;remove container
                 bra reading_pot
                 
MENU_3:          ldd pot_value
                 cmpb #80
                 bhs  MENU_4
                 ldd #MAIN_MENU_MSG_3
                 jsr display_to_lcd 
                     
                 jsr read_keypad
                 ldaa KEY_PRESSED
                 cmpa #$0B
                 bne  reading_pot
                 jsr local_time                 ;local time/date
                 lbra reading_pot
                        
MENU_4:          ldd pot_value
                 cmpb #110
                 bhs MENU_5
                 ldd #MAIN_MENU_MSG_5
                 jsr display_to_lcd
                 
                 jsr read_keypad
                 ldaa KEY_PRESSED
                 cmpa #$0B
                 lbne reading_pot
                 jsr gmt_time                  ;gmt time/date
                 lbra reading_pot
  
MENU_5:          ldd #MAIN_MENU_MSG_4
                 jsr display_to_lcd 
                     
                 jsr read_keypad
                 ldaa KEY_PRESSED
                 cmpa #$0B                    ;if B pressed, return to start menu
                 lbne  reading_pot
                 jsr password                 ;password prompt
                 
 display_backdoor_msg: 
                 
                 ldd #backdoor_msg
                 jsr display_to_lcd
                 jsr rti_delay
                 jsr rti_delay                
                 movb #0, backdoor_flag                     
                 lbra reading_pot	          ;keep reading
                 