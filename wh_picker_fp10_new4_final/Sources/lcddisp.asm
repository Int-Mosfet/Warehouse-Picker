;The LCD takes in a constant stream of characters
;(the C function given)
;The function given is always looking for a null terminator
;A weird bug popped up (9 chars flickering on screen)
;and sometimes even not displaying them at all on 
;start screen password prompt
;All our strings are null-terminated.
;Eventually we fixed it by
;initializing a 32 char all zero string...
;That doesn't make any sense but LCD bugs were
;minimal after that....
;After that we had a mostly functioning display
;this is essentially a wrapper for the display_string()
;function
 XDEF display_to_lcd
 XREF display_string
 XREF disp

display_to_lcd:
            
            ;tfr from d to x (indexer)
            tfr d, x
			;init our counter
            ldy #0
			dex		 
display_to_lcd_loop:
            ;load a with first char
            ldaa 1,x
            inx
			;store in disp array
            staa   disp,y
			;increment counter
            iny
			;if 32 chars, push string to display
            cpy #32  
            bne  display_to_lcd_loop     
            ;actually displaying string now                     
		    ldd #disp
            jsr display_string
                   
            rts
  