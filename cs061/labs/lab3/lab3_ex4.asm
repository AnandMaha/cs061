;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 3, ex 4
; Lab section: 24
; TA: David Feng
; 
;  enter as many characters, until exit character ('\n')
;   
;=================================================
.orig x3000
;Instructions
;Prompt
LEA R0, PROMPT
PUTS
;pointer address in R6
LD R6, ARR_PTR
FOR_LOOP
	GETC
	OUT ;prevent ghost typing
	STR R0, R6, #0 ;place character into memory
	ADD R6, R6, #1 ;remember to increment memory address
	;the newline character is ascii value 10
	ADD R0, R0, #-10 ;if ascii character is newline, then R0 would be set to 0
	BRnp FOR_LOOP ;only continue adding characters if newline character entered
END_FOR_LOOP

LD R0, newline
OUT

;print out all characters with a newline after printing is finished.
LD R6, ARR_PTR ;start at beginning of array
FOR_LOOP2
	;Print out character
	LDR R0, R6, #0
	OUT
	ADD R6, R6, #1
	;if it was the newline character, it would have printed out, meaning 
	;the end of printing
	ADD R0, R0, #-10
	BRnp FOR_LOOP2
END_FOR_LOOP2
HALT
;Local Data
;prompt string
PROMPT .STRINGZ "Enter as many characters as you want. Press the Enter Key to stop -> \n"
;ascii newline
newline .FILL '\n'
;start of array pointer
ARR_PTR .FILL x4000

.END
