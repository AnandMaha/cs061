;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 1, ex 1
; Lab section: 024
; TA: 
; 
;=================================================

.orig x3000
AND R0, R0, #0
AND R1, R1, #0
AND R2, R2, #0
;Instructions (ie LC-3 code)
;multiply 6 by 12
;1) need changing R0
;2) need incrementation R1
;3) need number to add R2
LD R0, DEC_0
LD R1, DEC_6
LD R2, DEC_12

FOR_LOOP
	ADD R0, R0, R2
	ADD R1, R1, #-1
	BRp FOR_LOOP
END_FOR_LOOP


HALT			;end of program code

;Local data
DEC_0 .FILL #0
DEC_6 .FILL #6
DEC_12 .FILL #12



.end			;like } after main(), a compiler directive
