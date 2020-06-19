;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 6, ex 3
; Lab section: 24
; TA: David Feng
; 
;=================================================
.orig x3000
LD R1, arr_addr
LD R6, sub_get_string_addr
JSRR R6 ;returns # of characters in string (R5)
LD R0, newline
OUT
ADD R0, R1, #0
PUTS

;part 2
LD R6, sub_is_palindrome
JSRR R6
LEA R0, msg_part_one
PUTS
ADD R0, R1, #0
PUTS
ADD R4, R4, #0
BRp IS_PAL_MSG
LEA R0, is_not_pal_msg
PUTS
BR END_OF_MAIN
IS_PAL_MSG
	LEA R0, is_pal_msg
	PUTS
END_OF_MAIN
HALT
;Local Data for Main
arr_addr .FILL x3100
sub_get_string_addr .FILL x3300
sub_is_palindrome .FILL x3500

msg_part_one .STRINGZ "\nThe string "
is_not_pal_msg .STRINGZ " IS NOT a palindrome\n"
is_pal_msg .STRINGZ " IS a palindrome\n"
newline .FILL '\n'
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
enter_shift .FILL #-10

;------------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_IS_PALINDROME
; Parameter (R1): The starting address of a null-terminated string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R1) is
;				 a palindrome or not, and returned a flag to that effect.
; Return Value: R4 {1 if the string is a palindrome, 0 otherwise}
;------------------------------------------------------------------------------------------------------------------
.orig x3500
ST R0, backup_R0_3500
ST R1, backup_R1_3500
ST R2, backup_R2_3500
ST R3, backup_R3_3500
ST R5, backup_R5_3500
ST R7, backup_R7_3500

;part 3
LD R6, sub_to_upper
JSRR R6
;only used registers 1 and 2 in sub_to_upper
LD R1, backup_R1_3500
LD R2, backup_R2_3500
LD R7, backup_R7_3500

AND R4, R4, #0 ;only set R4 to 0 if it's NOT A  palindrome
ADD R4, R4, #1
;R2 will pointing to last element in array (length - 1)
ADD R2, R1, R5
ADD R2, R2, #-1

;Compare first with last, if they aren't equal then set R4 to 1
LOOP
	LDR R3, R1, #0
	LDR R0, R2, #0
	NOT R3, R3 ;take two's complement of R3
	ADD R3, R3, #1
	ADD R3, R3, R0 
	BRnp SET_ZERO_BIT
	ADD R1, R1, #1
	ADD R2, R2, #-1
	ADD R5, R5, #-1 
	BRp LOOP
BR AFTER_SET_ZERO_BIT

SET_ZERO_BIT ;TO reach here, must not be a palindrome!
	ADD R4, R4, #-1
AFTER_SET_ZERO_BIT
LD R0, backup_R0_3500
LD R1, backup_R1_3500
LD R2, backup_R2_3500
LD R3, backup_R3_3500
LD R5, backup_R5_3500
LD R7, backup_R7_3500
RET
;local data for sub_is_palindrome
backup_R0_3500 .BLKW #1
backup_R1_3500 .BLKW #1
backup_R2_3500 .BLKW #1
backup_R3_3500 .BLKW #1
backup_R5_3500 .BLKW #1
backup_R7_3500 .BLKW #1

sub_to_upper .FILL x3700

;------------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_TO_UPPER
; Parameter (R1): Starting address of a null-terminated string
; Postcondition: The subroutine has converted the string to upper-case ​ in-place
;				i.e. the upper-case string has replaced the original string
; No return value, no output (but R1 still contains the array address, unchanged).
;--------------------------------------------------------------------------------------------
.orig x3700
ST R1, backup_R1_3700
ST R2, backup_R2_3700
ST R3, backup_R3_3700
ST R7, backup_R7_3700

;if value at R1 is 0, just exit
BEFORE_CHECK
	LDR R2, R1, #0
	ADD R2, R2, #0
	BRz END_CHECK
	;else if it's not zero, bitwise AND with x5F
	LD R3, HEX_5F
	AND R2, R2, R3
	;store it back into R1
	STR R2, R1, #0
	ADD R1, R1, #1
	BR BEFORE_CHECK
END_CHECK
LD R1, backup_R1_3700
LD R2, backup_R2_3700
LD R3, backup_R3_3700
LD R7, backup_R7_3700
RET
;local data for sub_to_upper
backup_R1_3700 .BLKW #1
backup_R2_3700 .BLKW #1
backup_R3_3700 .BLKW #1
backup_R7_3700 .BLKW #1

HEX_5F .FILL x5F

.end
