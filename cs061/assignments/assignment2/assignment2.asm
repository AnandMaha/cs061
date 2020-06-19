;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Assignment name: Assignment 2
; Lab section: 24
; TA: David Feng
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------

;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------
;first number into R1
GETC
OUT
ADD R1, R0, #0
LD R0, newline
OUT

;second number into R2
GETC
OUT
ADD R2, R0, #0
LD R0, newline
OUT

;output left side of equation 
;ex. "5 - 3 = "
ADD R0, R1, #0
OUT
LEA R0, MINUS_W_SPACES
PUTS
ADD R0, R2, #0
OUT
LEA R0, EQUALS_W_SPACES
PUTS

;determine result and output it with newline
;change R1 and R2 to actual values (subtract 48)
;(subtract 16 three times)
ADD R1, R1, #-16
ADD R1, R1, #-16
ADD R1, R1, #-16

ADD R2, R2, #-16
ADD R2, R2, #-16
ADD R2, R2, #-16

;change R2 value to its two's complement
NOT R2, R2
ADD R2, R2, #1

;add R1 and R2 together into R3
;really subtracting R1 and R2 and placing result into R3
ADD R3, R1, R2

;if result is negative, go to correct place in code
BRn NEGATIVE

;THIS IS POSITIVE (AND ZERO) section
;convert R3 to ascii value
ADD R3, R3, #12
ADD R3, R3, #12
ADD R3, R3, #12
ADD R3, R3, #12
;set R0 to R3 and output it
ADD R0, R3, #0
OUT
;output newline and HALT
LD R0, newline
OUT
HALT

;THIS IS NEGATIVE section
NEGATIVE
	;flip R3 to positive number
	NOT R3, R3
	ADD R3, R3, #1
	;ascii conversion
	ADD R3, R3, #12
	ADD R3, R3, #12
	ADD R3, R3, #12
	ADD R3, R3, #12
	;output negative sign
	LD R0, minus_ascii
	OUT
	ADD R0, R3, #0
	OUT
	LD R0, newline
	OUT 
	HALT
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.

MINUS_W_SPACES .STRINGZ " - "
EQUALS_W_SPACES .STRINGZ " = "

newline .FILL '\n'	; newline character - use with LD followed by OUT
minus_ascii .FILL '-'


;---------------	
;END of PROGRAM
;---------------	
.END

