;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 6, ex 1
; Lab section: 24
; TA: David Feng
; 
;=================================================
.orig x3000
LD R1, arr_addr
LD R6, sub_get_string_addr
JSRR R6 ;returns # of characters in string (R5)
LD R0, arr_addr
PUTS
HALT
;Local Data for Main
arr_addr .FILL x3100
sub_get_string_addr .FILL x3300
;Remote Data for Main
.orig x3100
arr .BLKW #100

;----------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameter (R1): The starting address of the character array
; Postcondition: The subroutine has prompted the user to input a string,
;				terminated by the [ENTER] key (the "sentinel"), and has stored
;				the received characters in an array of characters starting at (R1).
;				the array is NULL-terminated; the sentinel character is NOT stored.
; Return Value (R5): The number of ​ non-sentinel​ characters read from the user.
;                    R1 contains the starting address of the array unchanged.
;----------------------------------------------------------------------------
.orig x3300
ST R0, backup_R0_3300
ST R1, backup_R1_3300
ST R2, backup_R2_3300
ST R7, backup_R7_3300

LEA R0, intro_str
AND R5, R5, #0
PUTS
BEFORE_INPUT
	GETC
	;check if enter; and if so, assign last element in array with value 0
	LD R2, enter_shift
	ADD R2, R2, R0
	BRz ASSIGN_ZERO
	OUT
	;place into array
	STR R0, R1, #0
	ADD R1, R1, #1
	ADD R5, R5, #1
	BR BEFORE_INPUT
	
ASSIGN_ZERO
	AND R2, R2, #0
	STR R2, R1, #0
LD R0, newline
OUT

LD R0, backup_R0_3300
LD R1, backup_R1_3300
LD R2, backup_R2_3300
LD R7, backup_R7_3300
RET
;Local Data of SUB_GET_STRING
backup_R0_3300 .BLKW #1
backup_R1_3300 .BLKW #1
backup_R2_3300 .BLKW #1
backup_R7_3300 .BLKW #1

intro_str .STRINGZ "Enter a string (end input with enter key)\n->"
newline .FILL '\n'
enter_shift .FILL #-10

.end
