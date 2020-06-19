;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 3, ex 2
; Lab section: 24
; TA: David Feng
; 
;=================================================
.orig x3000
;Instructions
LEA R0, PROMPT
PUTS
;prompt user to enter 10 characters, and place all ten into ARR
LD R1, COUNTER
;pointer address in R2
LEA R2, ARR
FOR_LOOP
	GETC
	OUT
	STR R0, R2, #0 ; store the value of R0 into R2
	ADD R2, R2, #1 ;to increment pointer address
	ADD R1, R1, #-1 ; decrement counter
	BRp FOR_LOOP
END_FOR_LOOP

HALT
;Local Data
;prompt string
PROMPT .STRINGZ "Enter 10 characters -> \n"
;make an array of capacity 10
ARR .BLKW #10
;counter variable
COUNTER .FILL #10

.end
