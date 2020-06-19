;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 7, ex 2
; Lab section: 24
; TA: David Feng
; 
;=================================================
.orig x3000
LEA R0, input_msg
PUTS
GETC
OUT
LD R6, sub_count_ones ;R2 contains number
JSRR R6
ADD R1, R0, #0 ;store character for printing
LEA R0, result_msg_1
PUTS
ADD R0, R1, #0
OUT
LEA R0, result_msg_2
PUTS
LD R4, ascii_shift
ADD R2, R2, R4
ADD R0, R2, #0
OUT
LD R0, newline
OUT
HALT
input_msg .STRINGZ "Enter a character to know the # of 1s in its binary representation. \n ->"
result_msg_1 .STRINGZ "\nThe number of 1's in '"
result_msg_2 .STRINGZ "' is: "
newline .FILL '\n'
ascii_shift .FILL #48
sub_count_ones .FILL x3200


;SUBROUTINE -- sub_count_ones
;Parameter: R0 (character to count ones for)
;Postcondition -- R2 contains the number of ones in ascii representation
;Return value -- R2, contains the number of ones in ascii representation
.orig x3200
ST R0, backup_R0_3200
ST R7, backup_R7_3200

AND R2, R2, #0 ;to return the # of ones
START_COUNT
	ADD R0, R0, #0
	BRn ADD_ONE
	BR AFTER_ADD_ONE
	ADD_ONE
		ADD R2, R2, #1
	AFTER_ADD_ONE
	ADD R0, R0, R0 ;in any case, left shift one
	ADD R0, R0, #0 ;end counting if number is 0
	BRz END_COUNT
	BR START_COUNT
END_COUNT

LD R0, backup_R0_3200
LD R7, backup_R7_3200
RET
;local data for sub_fill_val
backup_R0_3200 .BLKW #1
backup_R7_3200 .BLKW #1

.end
