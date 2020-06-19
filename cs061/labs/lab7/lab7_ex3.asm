;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 7, ex 3
; Lab section: 24
; TA: David Feng
; 
;=================================================

;UNSIGNED RIGHT_SHIFT
;before shifting, determine if msb is 1, if so, add one to number after left shifting
;Left shift number (n-1) times, where n is the # of bits we're working with

;After (n-1) times, set msb to 0 by the following: num AND x7FFF.
;And we're done!

;SIGNED RIGHT_SHIFT
;store msb by the following msb = num AND x8000
;Do "UNSIGNED RIGHT_SHIFT"
;ADD num, msb, num ; this maintains msb because UNSIGNED RIGHT-SHIFT sets its msb to 0.
;e.g. - 110 -> shift1: 101 -> shift2: 011 -> restoreMSB: 111.
