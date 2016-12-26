 XDEF read_keypad   
 XREF Port_u
 XREF KEYPAD_VALUES
 XREF KEYPAD_ROW
 XREF KeypressFlag
 XREF KEY_PRESSED
 XREF KEYPAD_KEYS
 XREF PlayTone
 XREF SendsChr

;the keypad routine is scans the keypad and puts the key that was pressed
;into the variable "KEY_PRESSED"
;we scan row by row, if value is found, we return it
;this made for fairly easy use getting a keypress
;and using it
;we end up debouncing for around 4ms and mask off the value
;may be overkill but it works fairly reliably
;if no key is pressed, we return $FF

read_keypad:    pshx
                psha 
                
read_1:  ;set our key counter to 0
         ldx #0                                    ;row 1
         ;jsr delay_1_ms
         ;movb $70, Port_u  ;70
         movb KEYPAD_ROW, Port_u
         ldaa Port_u
         cmpa #$7F
         beq read_2
scan_1:         
         cmpa KEYPAD_KEYS,x
         beq return_key  
         inx
         bra scan_1          
                
read_2:  ;4 keys scanned, look at next row
         ldx #4								      ;row 2
         ;jsr delay_1_ms
         ;movb $B0, Port_u  ;B0
         movb KEYPAD_ROW+1, Port_u
         ldaa Port_u
         cmpa #$BF
         beq read_3
scan_2:  
         cmpa KEYPAD_KEYS,x
         beq return_key  
         inx
         bra scan_2          
  
read_3:  ;8 keys scanned, look at next row
         ldx #8                                    ;row 3
         ;jsr delay_1_ms
         ;movb $D0, Port_u  ;D0
         movb KEYPAD_ROW+2, Port_u
         ldaa Port_u        
         cmpa #$DF
         beq read_4
scan_3:  
         cmpa KEYPAD_KEYS,x
         beq return_key  
         inx
         bra scan_3 
   
read_4:  ;12 keys scanned, look at next row
         ldx #12                                   ;row 4
         ;jsr delay_1_ms
         ;movb $E0, Port_u   ;E0
         movb KEYPAD_ROW+3, Port_u
         ldaa Port_u
                 
scan_4:     
         cmpa #$EF
         beq no_key_pressed     ;if $FF, no key found
         cmpa KEYPAD_KEYS,x    ;compare to key array
         beq return_key       ;key has been found
         inx
         bra scan_4
        ;all rows scanned, either return a key or return $FF      
return_key:
         jsr debounce
         ldaa KEYPAD_VALUES,x
         staa KEY_PRESSED     
         movb #1, KeypressFlag       ;set key press flag                                            
         pula
         pulx                
         rts
   
no_key_pressed:  
         movb #$FF, KEY_PRESSED          
         pula
         pulx
         rts
                         
debounce:
         psha
debounce1:
         ;delaying for 4ms prevents more debounce issues
		 ;for some reason....(crappy buttons perhaps?)
		 ;either way you can't humanly notice it
         jsr delay_1_ms   
         jsr delay_1_ms   
         jsr delay_1_ms   
         jsr delay_1_ms
         ldaa Port_u
         anda #$0F
         cmpa #$0F
         bne debounce1
         pula
         rts
         
 delay_1_ms:  
         pshx     
         ldx #1000
 delay_loop:  
         dbne x, delay_loop 
         pulx
         rts
   