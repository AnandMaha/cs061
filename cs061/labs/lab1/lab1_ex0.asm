;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 1, ex 0
; Lab section: 024
; TA: 
; 
;=================================================

.orig x3000
;Instructions (ie LC-3 code)
LEA R0, MSG_TO_PRINT
PUTS

HALT			;end of program code

;local data
MSG_TO_PRINT .STRINGZ "Hello world.\n"

.end			;like } after main(), a compiler directive
