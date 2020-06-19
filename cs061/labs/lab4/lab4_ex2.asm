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
AND R1, R1, #0 ;value to store in arr
LD R2, counter ;counter
LD R6, ARR_PTR ;memory address
;populate arr with 0 to 9 
LOOP
	STR R1, R6, #0
	ADD R6, R6, #1
	ADD R1, R1, #1
	ADD R2, R2, #-1
	BRp LOOP
END_LOOP

;output array
LD R2, counter ;counter
LD R6, ARR_PTR ;memory address
LOOP2
	LDR R0, R6, #0
	LD R1, DIGIT_SHIFT
	ADD R0, R0, R1
	OUT
	ADD R6, R6, #1
	ADD R2, R2, #-1
	BRp LOOP2
END_LOOP2
HALT
;Local Data
counter .FILL #10
DEC_6 .FILL #6
DIGIT_SHIFT .FILL #48
ARR_PTR .FILL x4000
;Remote Data
.orig x4000
ARR .BLKW #10

.end
