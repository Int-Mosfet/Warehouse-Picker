 XDEF rti_delay
 XREF seconds

;this function acts like a 'wait for interrupt' instruction
;when the seconds variable is incremented is when it will
;stop branching back to delaying
;this uses the rti to do the delay because incrementing seconds
;is done in the rti
;delay function to use (we use it for splashing strings
;on the LCD mostly, and for the dc motor,
;it can only be used in main_menu function though)
;if used in irq or rti, then a lock up happens...
 
rti_delay:    psha
              ldaa seconds
			  
while_seconds_doesnt_change:      
              cmpa seconds
              beq while_seconds_doesnt_change
			  
              pula
              rts