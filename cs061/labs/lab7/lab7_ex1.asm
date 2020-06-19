;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 7, ex 1
; Lab section: 24
; TA: David Feng
; 
;=================================================
.orig x3000
LD R6, sub_fill_val
JSRR R6
ADD R1, R1, #1
LD R6, sub_print_dec
JSRR R6

HALT
;local data for main
sub_fill_val .FILL x3200
sub_print_dec .FILL x3400

;SUBROUTINE -- sub_fill_val
;Parameter: None
;Postcondition -- R1 contains the value hardcoded
;Return value -- R1 , value hardcoded
.orig x3200
ST R7, backup_R7_3200
LD R1, val
LD R7, backup_R7_3200
RET
;local data for sub_fill_val
backup_R7_3200 .BLKW #1
val .FILL #10001

;SUBROUTINE -- sub_print_dec
;Parameter: R1 (hardcoded value to be printed to console)
;Postcondition -- R1's hardcoded value is printed to console
;Return value -- none
.orig x3400
ST R0, backup_R0_3400
ST R1, backup_R1_3400
ST R2, backup_R2_3400
ST R3, backup_R3_3400
ST R4, backup_R4_3400
ST R5, backup_R5_3400
ST R7, backup_R7_3400

;The plan: subtract 10,000 until the number is negative or zero, output # I can do
;that before getting negative or zero
;same process for 1,000 , 100 , 10 , 1
;done

LD R4, ascii_shift ;#48 
AND R5, R5, #0 ;flag. 0 if no non-zero digit has been found, any other number otherwise

;determine if number is negative
;if it is, then output -, and take two's complement of number
;and print out normally...
ADD R1, R1, #0
BRzp END_NEG_CHECK
;it's negative
LD R0, minus
OUT
NOT R1, R1
ADD R1, R1, #1
END_NEG_CHECK

AND R0, R0, #0
AND R2, R2, #0 ;DEDICATED checking for how many times counter
DETERMINE_10000
	LD R3, dec_10000
	NOT R3, R3
	ADD R3, R3, #1
	ADD R1, R1, R3
	BRn DETERMINE_10000_PRINT
	ADD R2, R2, #1 ;increment # of 10000s
	;"deactivate" flag
	ADD R5, R5, #1
	BR DETERMINE_10000

DETERMINE_10000_PRINT 
	;add R1 by 10000 to become proper number
	LD R3, dec_10000
	ADD R1, R1, R3
	;if flag is still "active", no printing!
	ADD R5, R5, #0
	BRz END_10000_PRINT
	;print out character
	ADD R0, R2, R4
	OUT
END_10000_PRINT

AND R0, R0, #0
AND R2, R2, #0 ;DEDICATED checking for how many times counter
DETERMINE_1000
	LD R3, dec_1000
	NOT R3, R3
	ADD R3, R3, #1
	ADD R1, R1, R3
	BRn DETERMINE_1000_PRINT
	ADD R2, R2, #1 ;increment # of 1000s
	;"deactivate" flag
	ADD R5, R5, #1
	BR DETERMINE_1000

DETERMINE_1000_PRINT 
	;add R1 by 1000 to become proper number
	LD R3, dec_1000
	ADD R1, R1, R3
	;if flag is still "active", no printing!
	ADD R5, R5, #0
	BRz END_1000_PRINT
	;print out character
	ADD R0, R2, R4
	OUT
END_1000_PRINT

AND R0, R0, #0
AND R2, R2, #0 ;DEDICATED checking for how many times counter
DETERMINE_100
	LD R3, dec_100
	NOT R3, R3
	ADD R3, R3, #1
	ADD R1, R1, R3
	BRn DETERMINE_100_PRINT
	ADD R2, R2, #1 ;increment # of 100s
	;"deactivate" flag
	ADD R5, R5, #1
	BR DETERMINE_100

DETERMINE_100_PRINT 
	;add R1 by 100 to become proper number
	LD R3, dec_100
	ADD R1, R1, R3
	;if flag is still "active", no printing!
	ADD R5, R5, #0
	BRz END_100_PRINT
	;print out character
	ADD R0, R2, R4
	OUT
END_100_PRINT

AND R0, R0, #0
AND R2, R2, #0 ;DEDICATED checking for how many times counter
DETERMINE_10
	AND R3, R3, #0
	ADD R3, R3, #-10
	ADD R1, R1, R3
	BRn DETERMINE_10_PRINT
	ADD R2, R2, #1 ;increment # of 10s
	;"deactivate" flag
	ADD R5, R5, #1
	BR DETERMINE_10

DETERMINE_10_PRINT 
	;add R1 by 10 to become proper number
	AND R3, R3, #0
	ADD R3, R3, #10
	ADD R1, R1, R3
	;if flag is still "active", no printing!
	ADD R5, R5, #0
	BRz END_10_PRINT
	;print character
	ADD R0, R2, R4
	OUT
END_10_PRINT

;even if R5 is still 0 at this point, it doesn't matter as the number
;0 should be printed out here
AND R0, R0, #0
DETERMINE_1 ;since R1 < 10, we can just print R1 out 
	ADD R0, R1, R4
	OUT
	
LD R0, newline 
OUT

LD R0, backup_R0_3400
LD R1, backup_R1_3400
LD R2, backup_R2_3400
LD R3, backup_R3_3400
LD R4, backup_R4_3400
LD R5, backup_R5_3400
LD R7, backup_R7_3400


RET
;local data for sub_fill_val
backup_R0_3400 .BLKW #1
backup_R1_3400 .BLKW #1
backup_R2_3400 .BLKW #1
backup_R3_3400 .BLKW #1
backup_R4_3400 .BLKW #1
backup_R5_3400 .BLKW #1
backup_R7_3400 .BLKW #1

dec_10000 .FILL #10000
dec_1000 .FILL #1000
dec_100 .FILL #100
ascii_shift .FILL #48
newline .FILL '\n'
minus .FILL '-'

.end
