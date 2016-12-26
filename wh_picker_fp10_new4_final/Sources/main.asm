;**************************************************************
;* This stationery serves as the framework for a              *
;* user application. For a more comprehensive program that    *
;* demonstrates the more advanced functionality of this       *
;* processor, please see the demonstration applications       *
;* located in the examples subdirectory of the                *
;* Freescale CodeWarrior for the HC12 Program directory       *
;**************************************************************
; Include derivative-specific definitions
 INCLUDE 'derivative.inc'
 XDEF Entry, _Startup
 XREF __SEG_END_SSTACK
 ;Variable definitions
 XDEF RTIENA
 XDEF RTIFLG
 XDEF RTICTL
 XDEF Port_t
 XDEF Port_t_ddr
 XDEF Port_u
 XDEF Port_s
 XDEF Port_s_ddr
 XDEF Port_p
 XDEF Port_p_ddr
 XDEF MAIN_MENU_MSG_1
 XDEF MAIN_MENU_MSG_2
 XDEF MAIN_MENU_MSG_3
 XDEF MAIN_MENU_MSG_4
 XDEF MAIN_MENU_MSG_5
 XDEF fire_message
 XDEF msg_for_bob
 XDEF backdoor_msg
 XDEF day_char_1
 XDEF day_char_2
 XDEF day_char_3
 XDEF day
 XDEF hours
 XDEF minutes
 XDEF seconds
 XDEF KEYPAD_ROW
 XDEF KEYPAD_KEYS
 XDEF KEYPAD_VALUES
 XDEF KEY_PRESSED
 XDEF sub_menu
 XDEF disp
 XDEF wh_password
 XDEF wh_password1
 XDEF wh_password2
 XDEF wh_password3
 XDEF wh_password4
 XDEF start_msg
 XDEF inc_password_msg
 XDEF pb_pressed
 XDEF pb_pressed_debounce
 XDEF irq_pressed
 XDEF KeypressFlag
 XDEF wh_picker_msg
 XDEF wh_picker_msg_0
 XDEF wh_picker_msg_1
 XDEF wh_picker_msg_2
 XDEF clear_LCD_screen
 XDEF clear_lcd_flag
 XDEF irq_time_stamp
 XDEF auto_dc_motor_flag  
 XDEF man_dc_motor_flag
 XDEF IRQ_to_PW_flag
 XDEF song1
 XDEF song1_backwards
 XDEF song2
 XDEF song3
 XDEF note_we_on
 XDEF toggle_note
 XDEF toggle_note2
 XDEF toggle_count
 XDEF toggle_note3
 XDEF toggle_note4
 XDEF switch_warning_msg
 XDEF switch_warning_msg2
 XDEF med_or_large_msg
 XDEF heavy_or_light_msg
 XDEF fragile_or_rugged_msg 
 XDEF password_entered
 XDEF counter
 XDEF remainder
 XDEF HundredsDigit
 XDEF TensDigit
 XDEF OnesDigit
 XDEF local_time_msg_1
 XDEF local_time_msg_2
 XDEF time_digits
 XDEF gmt_counter
 XDEF gmt_OnesDigit
 XDEF gmt_TensDigit
 XDEF gmt_HundredsDigit
 XDEF gmt_remainder
 XDEF gmt_day
 XDEF gmt_hours
 XDEF gmt_minutes
 XDEF gmt_seconds
 XDEF gmt_time_msg_1
 XDEF gmt_time_digits
 XDEF gmt_day_char_1
 XDEF gmt_day_char_2
 XDEF gmt_day_char_3
 XDEF gmt_time_msg_2
 XDEF dc_count
 XDEF dc_time_on
 XDEF dc_time_off
 XDEF prev_key	        
 XDEF cont_index_hundreds
 XDEF cont_index_tens
 XDEF cont_index_ones
 XDEF cont_index_remainder
 XDEF container_index
 XDEF cont_check
 XDEF container_data
 XDEF container_array
 XDEF added_cont_flag
 XDEF removed_cont_flag
 XDEF add_cont_song_flag
 XDEF remove_cont_song_flag
 XDEF bobs_flag
 XDEF add_B_flag
 XDEF add_B_flag1
 XDEF dc_delay_count
 XDEF backdoor_flag
 XDEF m_seq
 XDEF step_delay_FLAG
 XDEF STEP_COUNT
	        
 XREF init
 XREF read_keypad
 XREF main_menu
 XREF read_pot
 XREF display_to_lcd
 XREF display_string
 XREF password
 XREF RTI_ISR
 XREF rti_delay
 XREF IRQ_ISR
 XREF change_password
 XREF wh_picker
 XREF pot_value



			
My_variables: SECTION

;;BOX CREATION
container_array:      ds.b 100  ;adding 4 to adjust for index issue
container_data:       ds.b 1
container_index:      ds.b 1
cont_index_hundreds:  ds.b 1
cont_index_tens:      ds.b 1
cont_index_ones:      ds.b 1
cont_index_remainder: ds.b 1
added_cont_flag:      ds.b 1
removed_cont_flag:    ds.b 1
add_cont_song_flag:   ds.b 1
remove_cont_song_flag:ds.b 1
cont_check:           ds.b 1  ;this is for checking the bits in the container (heavy, large, rugged, etc)
add_B_flag:           ds.b 1
add_B_flag1           ds.b 1

disp:	              ds.b 33

wh_picker_msg:          ds.b 33
wh_picker_msg_0:        ds.b 33
wh_picker_msg_1:        ds.b 33
wh_picker_msg_2:        ds.b 33

KEY_PRESSED: 		     ds.b 1   ;stores last key pressed
sub_menu: 			     ds.b 1   ;stores the index of the sub_menu we're in
wh_password:        ds.b 4     ;stores the current password
wh_password1:       ds.b 4     ;requirement of 5 passwords pre-loaded...
wh_password2:       ds.b 4
wh_password3:       ds.b 4
wh_password4:       ds.b 4
password_entered:    ds.b 4 	;stores password entered by user



;;LOCAL TIME VARIABLES
counter:             ds.w 1    ;general purpose counter for the RTI
OnesDigit:           ds.b 1
TensDigit:           ds.b 1
HundredsDigit:       ds.b 1
remainder:           ds.w 1
day:                 ds.b 1    ;current day
hours:               ds.b 1    ;current hour		  
minutes:             ds.b 1    ;current minute
seconds:             ds.b 1    ;current second

local_time_msg_1      ds.b 33
local_time_msg_2      ds.b 44
time_digits:          ds.b 5    

;;GMT TIME VARIABLES
gmt_counter:         ds.w 1
gmt_OnesDigit:       ds.b 1
gmt_TensDigit:       ds.b 1
gmt_HundredsDigit:   ds.b 1
gmt_remainder:       ds.w 1
gmt_day:             ds.b 1    ;current day.
gmt_hours:           ds.b 1    ;current gmt hour		  
gmt_minutes:         ds.b 1    ;current gmt minute
gmt_seconds:         ds.b 1    ;current gmt second

gmt_time_msg_1:      ds.b 33
gmt_time_msg_2:      ds.b 33
gmt_time_digits:     ds.b 5    
                               
;;DC MOTOR VARIABLES
auto_dc_motor_flag:  ds.b 1    ;for auto operation
man_dc_motor_flag:   ds.b 1    ;for manual operation
dc_count:            ds.b 1
dc_time_on:          ds.b 1
dc_time_off:         ds.b 1
prev_key:            ds.b 1
dc_delay_count:      ds.w 1    ;for manual delay

;; Bob's flag ;;
bobs_flag:           ds.b 1    ;;Get back to work Bob you lazy bastard!!

;;backdoor flag
backdoor_flag:       ds.b 1                       


;;STEPPER MOTOR VARIABLES
step_delay_FLAG:     ds.b 1
STEP_COUNT:          ds.b  1

clear_lcd_flag:      ds.b 1

irq_pressed:         ds.b 1		 ;irq pressed flag

pb_pressed:          ds.b 1		 ;pb pressed flag
pb_pressed_debounce: ds.w 1

IRQ_to_PW_flag:      ds.b 1		 ;go to password prompt

;SAVING TIMESTAMP FOR IRQ
irq_time_stamp       ds.w 1
;SOUND VARIABLES
note_we_on:         ds.w  1
toggle_note:		ds.b  1
toggle_note2:       ds.b  1
toggle_note3:       ds.b  1
toggle_note4:       ds.b  1
toggle_count:       ds.w  1

KeypressFlag:       ds.b  1

;;constant declarations
My_constants: SECTION

;;STEPPER MOTOR
m_seq  dc.b 0, $0a, $12, $14, $0c, 0

;;KEYPAD
;value to be sent to keypad
KEYPAD_ROW: dc.b $70,$B0, $D0, $E0
;value to be read from keypad                                       
KEYPAD_KEYS: dc.b $77,$7B,$7D,$7E,$B7,$BB,$BD,$BE,$D7,$DB,$DD,$DE,$E7,$EB,$ED,$EE
;value pressed on keypad 
KEYPAD_VALUES: dc.b $1,$2,$3,$C,$4,$5,$6,$D,$7,$8,$9,$E,$A,$0,$B,$F     

;SONGS
song1:  dc.b $1, $2, $3, $4, $5, $6, 0			   ;play when adding container
song1_backwards: dc.b $6, $5, $4, $3, $2, $1, 0    ;play when removing container
song2:  dc.b $1, $3, $1, $3, $1, $3, 0			   ;play when IRQ is pressed ("siren" sound)
song3:  dc.b $1, $1, $1, $1, $1, $1, 0             ;keypress beeps

;;MAIN_MENU.ASM 
MAIN_MENU_MSG_1: dc.b "---MAIN  MENU---ADD CONTAINER   ","0"
MAIN_MENU_MSG_2: dc.b "---MAIN  MENU---REMOVE CONTAINER","0"  
MAIN_MENU_MSG_3: dc.b "---MAIN  MENU---CHANGE LOCALTIME","0"
MAIN_MENU_MSG_5: dc.b "---MAIN  MENU---CHANGE GMT TIME ","0"  
MAIN_MENU_MSG_4: dc.b "---MAIN  MENU---RETURN TO START ","0"

;;IRQ
fire_message:    dc.b "FIRE!FIRE!FIRE! RUN RUN RUN RUN "

;;PASSWORD.ASM
start_msg:            dc.b "WAREHOUSE PICKER ENTER PASSWORD ","0"
inc_password_msg:     dc.b "WRONG PASSWORD!!PLEASE TRY AGAIN","0"
msg_for_bob:          dc.b "HELLO BOB!        GET TO WORK!  ","0"
backdoor_msg:         dc.b "BACKDOOR!!!!!!! HACK THE PLANET!","0"

clear_LCD_screen:     dc.b "                                ","0"
switch_warning_msg:   dc.b "Flip dipswtch 8 toadd container!","0"
switch_warning_msg2:  dc.b "Flip dipswtch 7 to delete cont!!","0"
med_or_large_msg:     dc.b "Medium (1) or   Big(2) ?????????","0"
heavy_or_light_msg:   dc.b "Heavy (1)  or   Light(2) ???????","0"
fragile_or_rugged_msg:dc.b "Fragile(1) or   Rugged (2) ?????","0"


;;PORTS
Port_t:     EQU $240	;dipswitch control port
Port_t_ddr: EQU $242    ;dipswitch ddr
Port_u:     EQU $268    ;keypad control port    
Port_s:     EQU $248	;led control port
Port_s_ddr: EQU $24A	;led ddr
Port_p:     EQU $258	;motor control port
Port_p_ddr: EQU $25A	;motor ddr

;;RTI
RTIENA:  EQU $38
RTIFLG:  EQU $37


;;DAYS
day_char_1: dc.b 0,'M','T','W','T','F','S','S'
day_char_2: dc.b 0,'O','U','E','H','R','A','U'
day_char_3: dc.b 0,'N','E','D','U','I','T','N'

gmt_day_char_1: dc.b 0,'M','T','W','T','F','S','S'
gmt_day_char_2: dc.b 0,'O','U','E','H','R','A','U'
gmt_day_char_3: dc.b 0,'N','E','D','U','I','T','N'

;;CODE SECTION
MyCode:     SECTION
Entry:
_Startup:        
        lds #__SEG_END_SSTACK ;stack initialization
        cli   ;enables interrupts
        
        ;initialize variables in separate file
        ;then return
        jsr init
        
            
        
		;go to password function then return if
		;correct password entered
        jsr password
		;if password matches, go to main menu
		;this is now "our main" essentially
		;constantly reading pot value and displaying
		;menu item to screen
        jsr main_menu
        
        ;end main        
        