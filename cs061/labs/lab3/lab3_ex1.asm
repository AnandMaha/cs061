;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 3, ex 1
; Lab section: 24
; TA: David Feng
; 
;=================================================
.orig x3000

;Instructions
LD R5, DATA_PTR
LDR R3, R5, #0
ADD R5, R5, #1
ST R5, DATA_PTR
LDR R4, R5, #0

ADD R3, R3, x1
ADD R4, R4, x1

STR R4, R5, #0
ADD R5, R5, #-1
STR R3, R5, #0

HALT
;local Data
DATA_PTR .FILL x4000
;remote data
.orig x4000
NEW_DEC_65 .FILL #65
NEW_HEX_41 .FILL x41
.end
