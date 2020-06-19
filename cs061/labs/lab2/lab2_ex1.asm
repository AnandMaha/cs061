;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 2. ex 1
; Lab section: 24
; TA: David Feng
; 
;=================================================
.orig x3000

;Instructions
LD R3, DEC_65
LD R4, HEX_41
ADD R3, R3, #1
ADD R4, R4, #1
ST R3, DEC_65
ST R4, HEX_41
HALT
;Local Data
DEC_65 .FILL #65
HEX_41 .FILL x41

.end
