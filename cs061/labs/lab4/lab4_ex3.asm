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
AND R1, R1, #0 ;value to store in arr
ADD R1, R1, #1
LD R2, counter ;counter
LD R6, ARR_PTR ;memory address
;populate arr with 2^0 to 2^9
LOOP
	STR R1, R6, #0
	ADD R1, R1, R1
	ADD R6, R6, #1
	ADD R2, R2, #-1
	BRp LOOP
END_LOOP

; put the seventh value in R2
;reset counter and memory address
LD R2, DEC_6 ;counter
LD R6, ARR_PTR ;memory address
LOOP2
	ADD R6, R6, #1
	ADD R2, R2, #-1
	BRp LOOP2
END_LOOP2
LDR R2, R6, #0

HALT
;Local Data
counter .FILL #10
DEC_6 .FILL #6
ARR_PTR .FILL x4000
;Remote Data
.orig x4000
ARR .BLKW #10

.end
