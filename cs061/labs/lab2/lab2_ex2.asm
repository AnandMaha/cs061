;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 2. ex 2
; Lab section: 24
; TA: David Feng
; 
;=================================================
.orig x3000

;Instructions
LDI R3, DEC_65_PTR
LDI R4, HEX_41_PTR
ADD R3, R3, x1
ADD R4, R4, x1
STI R3, DEC_65_PTR
STI R4, HEX_41_PTR
HALT
;local Data
DEC_65_PTR .FILL x4000
HEX_41_PTR .FILL x4001
;remote data
.orig x4000
NEW_DEC_65 .FILL #65
NEW_HEX_41 .FILL x41
.end
