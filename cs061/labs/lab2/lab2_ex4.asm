;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 2. ex 4
; Lab section: 24
; TA: David Feng
; 
;=================================================
.orig x3000

;Instructions
LD R0, HEX_61
LD R1, HEX_1A
;OUT R0, increment R0, decrement R1
;prints out the 26 letters, all lower case, no space
FOR_LOOP
	OUT
	ADD R0, R0, #1
	ADD R1, R1, #-1
	BRp FOR_LOOP
END_FOR_LOOP
HALT
;local Data
HEX_61 .FILL x61
HEX_1A .FILL x1A
.end
