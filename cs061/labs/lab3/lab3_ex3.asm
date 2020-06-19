;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 3, ex 3
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
	STR R0, R2, #0
	ADD R2, R2, #1 ;to increment pointer address
	ADD R1, R1, #-1
	BRp FOR_LOOP
END_FOR_LOOP
LD R0, newline
OUT


;print out all characters with a newline after each.
LD R1, COUNTER
LEA R2, ARR
FOR_LOOP2
	;Print out character, and output newline
	LDR R0, R2, #0
	OUT
	LD R0, newline
	OUT
	;increment pointer address and decrement counter
	ADD R2, R2, #1
	ADD R1, R1, #-1
	BRp FOR_LOOP2
END_FOR_LOOP2
HALT
;Local Data
;prompt string
PROMPT .STRINGZ "Enter 10 characters -> \n"
;make an array of capacity 10
ARR .BLKW #10
;counter variable
COUNTER .FILL #10
;ascii newline
newline .FILL '\n'


.end
