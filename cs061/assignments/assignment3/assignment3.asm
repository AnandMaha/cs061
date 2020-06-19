;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Assignment name: Assignment 3
; Lab section: 24
; TA: David Feng
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;  
;  makes the number into binary and prints it to the console
;     16 bits
; ex. 18 is "0000 0000 0001 0000"
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, Value_ptr		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0			; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
LD R2, Bit_count
LD R3, Space_count
FOR_LOOP
	;output bit -- start
	ADD R1, R1, #0 ;determine first bit
	BRn ONE_BIT ;jump to ONE_BIT section
	;zero bit section -- start
	LD R0, Zero_ascii
	OUT
	BRzp END_ONE_BIT ; jump after ONE_BIT section
	;zero bit section -- end
	ONE_BIT
		LD R0, One_ascii
		OUT
	END_ONE_BIT
	;output bit -- end
	
	;decrement bit count
	;the only purpose of this block of 3 lines is to not output a space 
	;at the end of the 16 bit sequence
	ADD R2, R2, #-1
	BRz END_FOR_LOOP
	ADD R2, R2, #1
	
	;output space -- start
	ADD R3, R3, #-1 ;decrement # of spaces needed for a space 
	BRz OUTPUT_SPACE ;check if space need to be outputted
	BRnp END_OUTPUT_SPACE ;if R3 > 0, skip over outputting the space 
	OUTPUT_SPACE
		LD R0, Space_ascii
		OUT
		LD R3, Space_count ;Reset space counter to four
	END_OUTPUT_SPACE
	;output space -- end
	
	ADD R1, R1, R1 ;left bit shift
	
	;decrement bit count
	ADD R2, R2, #-1
	BRp FOR_LOOP
END_FOR_LOOP
LD R0, Newline_ascii
OUT

HALT
;---------------	
;Local Data
;---------------
Value_ptr	.FILL xB270	; The address where value to be displayed is stored
Space_count .FILL #4    ; Counter for output space
Bit_count .FILL #16     ; Number of bits needed for outputting

Space_ascii .FILL ' '   ; Every 4 bits, a space needs to be outputted
Newline_ascii .FILL '\n'; newline to be outputted at the end of printing
Zero_ascii .FILL '0'    ; 0 character 
One_ascii .FILL '1'		; 1 character

.ORIG xB270					; Remote data
Value .FILL x8000			; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
