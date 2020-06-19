;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 8, ex 1 & 2
; Lab section: 24
; TA: David Feng
; 
;=================================================

; test harness
.orig x3000
LD R6, sub_print_opcode_table
JSRR R6		 
LD R6, sub_find_opcode
JSRR R6				 
				 
HALT
;-----------------------------------------------------------------------------------------------
; test harness local data:
sub_print_opcode_table .fill x3200
sub_find_opcode .fill x3600


;===============================================================================================


; subroutines:
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE_TABLE
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
;				 and corresponding opcode in the following format:
;					ADD = 0001
;					AND = 0101
;					BR = 0000
;					…
; Return Value: None
;-----------------------------------------------------------------------------------------------
.orig x3200
ST R0, backup_R0_3200	
ST R1, backup_R1_3200	
ST R2, backup_R2_3200	
ST R3, backup_R3_3200	
ST R6, backup_R6_3200	
ST R7, backup_R7_3200	

LD R1, opcodes_po_ptr ;opcode arr pointer
LD R3, instructions_po_ptr ;string arr pointer
;outer loop for all lines in table
OUT_LOOP_3200
	STRING_PRINT_3200
		;check if R3 points to 0, if so end of instruction
		LDR R0, R3, #0
		BRz END_STRING_PRINT_3200
		;check if R3 points to -1, if so, end all printing
		BRn END_OUT_LOOP_3200
		;else, it's a regular character, and just output
		OUT
		ADD R3, R3, #1
		BR STRING_PRINT_3200
	END_STRING_PRINT_3200
	ADD R3, R3, #1 ;because R3 points to value 0, increment instruction
					;pointer to be at next string
	;now, instruction has been printed, now print " = " and opcode
	LEA R0, equal
	PUTS
	;and opcode
	LDR R2, R1, #0 ;pass opcode (value) to sub_print_opcode
	LD R6, sub_print_opcode
	JSRR R6
	ADD R1, R1, #1 ;increment opcode pointer
	;output newline
	LD R0, newline
	OUT
	BR OUT_LOOP_3200
END_OUT_LOOP_3200

LD R0, backup_R0_3200	
LD R1, backup_R1_3200	
LD R2, backup_R2_3200	
LD R3, backup_R3_3200	
LD R6, backup_R6_3200	
LD R7, backup_R7_3200				 
				 
RET
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE_TABLE local data
backup_R0_3200 .blkw #1
backup_R1_3200 .blkw #1
backup_R2_3200 .blkw #1
backup_R3_3200 .blkw #1
backup_R6_3200 .blkw #1
backup_R7_3200 .blkw #1


sub_print_opcode .fill x3400
opcodes_po_ptr		.fill x4000				; local pointer to remote table of opcodes
instructions_po_ptr	.fill x4100				; local pointer to remote table of instructions
equal .STRINGZ " = "
newline .fill '\n'

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE
; Parameters: R2 containing a 4-bit op-code in the 4 LSBs of the register
; Postcondition: The subroutine has printed out just the 4 bits as 4 ascii 1s and 0s
;				 The output is NOT newline terminated.
; Return Value: None
;-----------------------------------------------------------------------------------------------
.orig x3400
ST R0, backup_R0_3400
ST R1, backup_R1_3400
ST R2, backup_R2_3400				 
ST R7, backup_R7_3400

;left shift R2 12 times
AND R1, R1, #0
ADD R1, R1, #12
START_LSHIFT_3400
	ADD R2, R2, R2
	ADD R1, R1, #-1
	BRz END_LSHIFT_3400
	BR START_LSHIFT_3400
END_LSHIFT_3400
;now first 4 bits are bits to be printed
ADD R1, R1, #4
PRINT_BITS_3400
	LD R0, ascii_shift ;this is 0 in ascii
	ADD R2, R2, #0
	BRn PRINT_ONE_3400
	BR PRINT_ZERO_3400
	PRINT_ONE_3400
		ADD R0, R0, #1
		OUT
		BR END_PRINT_ZERO_3400
	PRINT_ZERO_3400
		OUT
	END_PRINT_ZERO_3400
	ADD R2, R2, R2
	ADD R1, R1, #-1
	BRz END_PRINT_BITS_3400
	BR PRINT_BITS_3400
END_PRINT_BITS_3400		 

LD R0, backup_R0_3400
LD R1, backup_R1_3400
LD R2, backup_R2_3400				 
LD R7, backup_R7_3400			 
				 
RET
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE local data
backup_R0_3400 .blkw #1
backup_R1_3400 .blkw #1
backup_R2_3400 .blkw #1
backup_R7_3400 .blkw #1

ascii_shift .fill #48


;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_OPCODE
; Parameters: None
; Postcondition: The subroutine has invoked the SUB_GET_STRING subroutine and stored a string
; 				as local data; it has searched the AL instruction list for that string, and reported
;				either the instruction/opcode pair, OR "Invalid instruction"
; Return Value: None
;-----------------------------------------------------------------------------------------------
.orig x3600
ST R0, backup_R0_3600
ST R1, backup_R1_3600				 
ST R2, backup_R2_3600
ST R3, backup_R3_3600
ST R4, backup_R4_3600
ST R5, backup_R5_3600				 
ST R7, backup_R7_3600	

START_SUBR_3600

LD R2, arr_loc
LD R6, sub_get_string
JSRR R6
;now that string is stored starting at x3700, now to check if any instruction
;matches exactly with user input, and output appropriate message depending 
;on flag (R4)
LD R1, opcodes_fo_ptr
LD R2, instructions_fo_ptr
AND R4, R4, #0
CHECK_ALL_INSTRUCTIONS
	;exit when R2 points to -1 (1/2)
	LDR R5, R2, #0
	BRn AFTER_SET_FLAG_3600
	
	LD R3, arr_loc
	;check to make sure all characters in instruction are the same as in
	;instruction
	INNER_CHECK_3600
		LDR R5, R3, #0 ;character pointed to in user array
		LDR R0, R2, #0 ;character pointer to in instruction array
		ADD R0, R5, R0
		BRz SET_FLAG_3600;when adding zero or positive numbers, 
						     ;and the result is 0, both operands are 0 (2/2)
		LDR R0, R2, #0 ;to avoid having to use R6
		;compare characters (subtract together)
		NOT R0, R0
		ADD R0, R0, #1
		ADD R5, R5, R0
		BRz INCREMENT_THEN_LOOP ;characters are same, but not at end either array
		BR MOVE_TO_NEXT_INSTRUC_OPCODE
	INCREMENT_THEN_LOOP
		ADD R2, R2, #1
		ADD R3, R3, #1
		BR INNER_CHECK_3600
	MOVE_TO_NEXT_INSTRUC_OPCODE ;R1+1 and R2 should be pointing to the start of next instruc.
		ADD R1, R1, #1 ;increment opcode pointer +1
		ADD_R2_1
			LDR R5, R2, #0
			BRz SECOND_ADD_R2_1
			ADD R2, R2, #1
			BR ADD_R2_1
			SECOND_ADD_R2_1
				ADD R2, R2, #1 ;if done checking last instruction, R2 will
									;point to -1 after this statement
				BR CHECK_ALL_INSTRUCTIONS

SET_FLAG_3600
	ADD R4, R4, #1
AFTER_SET_FLAG_3600

;if R4 is still 0, then user input is invalid instruction
ADD R4, R4, #0
BRz PRINT_INVALID_3600
BR PRINT_INSTRUCTION_3600
PRINT_INVALID_3600
	LEA R0, invalid_str
	PUTS
	BR END_PRINT_INSTRUCTION_3600
PRINT_INSTRUCTION_3600
	LD R0, arr_loc ;this is equivalent to ADD R0, R2, #0 (cause both 
					;strings have been determined to be the same)
	PUTS
	LEA R0, equal_3600
	PUTS
	LDR R2, R1, #0
	LD R6, sub_print_opcode_3600
	JSRR R6
	LD R0, newline_3600
	OUT
END_PRINT_INSTRUCTION_3600

BR START_SUBR_3600 ;never ending loop

LD R0, backup_R0_3600
LD R1, backup_R1_3600				 
LD R2, backup_R2_3600
LD R3, backup_R3_3600
LD R4, backup_R4_3600
LD R5, backup_R5_3600				 
LD R7, backup_R7_3600			 
			 
RET
;-----------------------------------------------------------------------------------------------
; SUB_FIND_OPCODE local data
backup_R0_3600 .blkw #1
backup_R1_3600 .blkw #1
backup_R2_3600 .blkw #1
backup_R3_3600 .blkw #1
backup_R4_3600 .blkw #1
backup_R5_3600 .blkw #1
backup_R7_3600 .blkw #1

sub_print_opcode_3600 .fill x3400
arr_loc .fill x3700
sub_get_string .fill x3800
opcodes_fo_ptr			.fill x4000
instructions_fo_ptr		.fill x4100
invalid_str .STRINGZ "Invalid instruction\n"
equal_3600 .STRINGZ " = "
newline_3600 .fill '\n'
;for user string
.orig x3700
user_input .BLKW x100

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameters: R2 - the address to which the null-terminated string will be stored.
; Postcondition: The subroutine has prompted the user to enter a short string, terminated 
; 				by [ENTER]. That string has been stored as a null-terminated character array 
; 				at the address in R2
; Return Value: None (the address in R2 does not need to be preserved)
;-----------------------------------------------------------------------------------------------
.orig x3800
ST R0, backup_R0_3800
ST R1, backup_R1_3800
ST R7, backup_R7_3800

LEA R0, prompt_str
PUTS
GET_STRING_3800
	GETC
	OUT
	;check if enter key, if yes, null terminate array
	LD R1, enter_shift
	ADD R1, R0, R1
	BRz TERMINATE_ARR_3800
	;store character into array
	STR R0, R2, #0
	ADD R2, R2, #1
	BR GET_STRING_3800
TERMINATE_ARR_3800 ;after user types enter, store 0 into array, to denote
						;end of string
	AND R0, R0, #0
	STR R0, R2, #0
				 
LD R0, backup_R0_3800
LD R1, backup_R1_3800
LD R7, backup_R7_3800
			 
				 
				 
RET
;-----------------------------------------------------------------------------------------------
; SUB_GET_STRING local data
backup_R0_3800 .blkw #1
backup_R1_3800 .blkw #1
backup_R7_3800 .blkw #1

prompt_str .STRINGZ "Enter a LC-3 instruction (ex. ADD)\n-> "
enter_shift .fill #-10

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; REMOTE DATA
.ORIG x4000			; list opcodes as numbers from #0 through #15, e.g. .fill #12 or .fill xC
; opcodes
a .FILL #1
b .fill #5
c .fill #0
d .fill #12
e .fill #4
f .fill #4
g .fill #2
h .fill #10
i .fill #6
j .fill #14
k .fill #9
l .fill #12
m .fill #8
n .fill #3
o .fill #11
p .fill #7
q .fill #15
r .fill #13

.ORIG x4100			; list AL instructions as null-terminated character strings, e.g. .stringz "JMP"
								 		; - be sure to follow same order in opcode & instruction arrays!
; instructions	
aa .STRINGZ "ADD"
bb .STRINGZ "AND"
ccc .STRINGZ "BR"
dd .STRINGZ "JMP"
ee .STRINGZ "JSR"
ff .STRINGZ "JSRR"
gg .STRINGZ "LD"
hh .STRINGZ "LDI"
ii .STRINGZ "LDR"
jj .STRINGZ "LEA"
kk .STRINGZ "NOT"
ll .STRINGZ "RET"
mm .STRINGZ "RTI"
nn .STRINGZ "ST"
oo .STRINGZ "STI"
pp .STRINGZ "STR"
qq .STRINGZ "TRAP"
rr .STRINGZ "reserved"
neg_one .fill #-1
;===============================================================================================
.end
