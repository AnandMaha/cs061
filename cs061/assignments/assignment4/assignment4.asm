;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Assignment name: Assignment 4
; Lab section: 24
; TA: David Feng
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R1
;=================================================================================

.ORIG x3000		
;-------------
;Instructions
;-------------

START_FLAG ;flag for restarting input process

; output intro prompt
LD R0, introPromptPtr
PUTS
; Set up flags, counters, accumulators as needed
AND R1, R1, #0 ;final binary representation
LD R2, digit_counter
LD R4, DEC_9
AND R5, R5, #0 ;if R5 is 0 then number is positive, if not then number is negative; FLAG!!!
AND R6, R6, #0
; Get first character, test for '\n', '+', '-', digit/non-digit: 	
GETC	

LD R3, enter_shift ; is very first character = '\n'? if so, just quit (no message)!
ADD R3, R0, R3 
BRz BEFORE_NEWLINE
	
OUT

LD R3, plus_shift		; is it = '+'? if so, ignore it, go get digits
ADD R3, R0, R3
BRz DIGITS

LD R3, minus_shift		; is it = '-'? if so, set neg flag, go get digits
ADD R3, R0, R3
BRz SET_NEG_FLAG
BR AFTER_SET_NEG_FLAG

SET_NEG_FLAG
	ADD R5, R5, #-1 ;this is the flag!!!
	BR DIGITS
AFTER_SET_NEG_FLAG			
			
LD R3, nine_shift		; is it > '9'? if so, it is not a digit	- o/p error message, start over
ADD R3, R0, R3
BRp ERROR
		
LD R3, zero_shift			; is it < '0'? if so, it is not a digit	- o/p error message, start over
ADD R3, R0, R3
BRn ERROR 
	
ADD R1, R3, #0	;if none of the above, first character is first numeric digit 
				;convert it to number & store in target register!
				;R3 is already converted to actual number
ADD R2, R2, #-1 ;decrement num digits counter
					
; Now get remaining digits (max 5) from user, testing each to see if it is a digit, and build up number in accumulator
;each extra digit, multiply the current number by 10, then add the next digit
DIGITS
	GETC
	
	;allowed inputs can be enter or digits
	LD R3, enter_shift
	ADD R3, R0, R3
	BRz CHECK_IF_SIGN_THEN_ENTER
	
	OUT
	
	LD R3, nine_shift		; is it > '9'? if so, it is not a digit	- o/p error message, start over
	ADD R3, R0, R3
	BRp ERROR
			
	LD R3, zero_shift			; is it < '0'? if so, it is not a digit	- o/p error message, start over
	ADD R3, R0, R3
	BRn ERROR 
	
	;multiply number by 10 (ADD R1 to its original value 9 times)
	ADD R6, R1, #0
	LD R4, DEC_9
	MULTIPLY_10
		ADD R1, R1, R6 
		ADD R4, R4, #-1
		BRz END_MULTIPLY_10
		BR MULTIPLY_10
	END_MULTIPLY_10
	;and add digit to it
	ADD R1, R1, R3		;R3 has actual number (like from above)
	
	ADD R2, R2, #-1
	BRz DETERMINE_NEGATIVE
	BR DIGITS

CHECK_IF_SIGN_THEN_ENTER
	;If num digits is still 5, that means a sign was entered (+ or -)
	ADD R3, R2, #0 
	ADD R3, R3, #-5
	BRz ERROR ;Sign into enter error
	BR DETERMINE_NEGATIVE

;if negative flag is set, then take the two's complement of the number
DETERMINE_NEGATIVE
	ADD R5, R5, #0
	BRnp TAKE_TWOS_COMPLEMENT ; if NOT zero, take two's complement
	BR BEFORE_NEWLINE
	TAKE_TWOS_COMPLEMENT
		NOT R1, R1
		ADD R1, R1, #1
		BR BEFORE_NEWLINE

ERROR
	LD R0, newline
	OUT
	LD R0, errorMessagePtr
	PUTS
	BR START_FLAG

BEFORE_NEWLINE
LD R0, newline ;remember to end with a newline!
OUT

HALT
;---------------	
; Program Data
;---------------

introPromptPtr		.FILL xA800
errorMessagePtr		.FILL xA900
newline 			.FILL '\n'
digit_counter		.FILL #5
DEC_9				.FILL #9
enter_shift 		.FILL #-10
plus_shift	 	    .FILL #-43
minus_shift			.FILL #-45
zero_shift   	    .FILL #-48
nine_shift 	        .FILL #-57

;------------
; Remote data
;------------
.ORIG xA800			; intro prompt
.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"


.ORIG xA900			; error message
.STRINGZ	"ERROR! invalid input\n"

;---------------
; END of PROGRAM
;---------------
.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
