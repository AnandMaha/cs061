;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu	
; 
; Lab: lab 9, ex 3
; Lab section: 24
; TA: David Feng
; 
;=================================================

; test harness
.orig x3000
LD R4, base_ptr
LD R5, max_ptr	
LD R6, tos_ptr			 
;first operand
LEA R0, num_str
PUTS
GETC
OUT
;push value to stack
LD R1, num_shift
ADD R0, R0, R1
LD R1, sub_stack_push_ptr
JSRR R1
;second operand
LEA R0, num_str
PUTS
GETC
OUT
;push value to stack
LD R1, num_shift
ADD R0, R0, R1
LD R1, sub_stack_push_ptr
JSRR R1
;now "receive" operand		
LEA R0, operation_str
PUTS
GETC
OUT
LD R1, sub_rpn_multiply
JSRR R1 
LEA R0, result_str
PUTS
LD R1, sub_stack_pop_ptr
JSRR R1
ADD R1, R0, #0 ;sub_print_decimal uses R1, not R0 for the value to be printed
LD R2, sub_print_decimal
JSRR R2
LD R0, newline
OUT
HALT
;-----------------------------------------------------------------------------------------------
; test harness local data:
base_ptr .FILL xA000
max_ptr .FILL xA005
tos_ptr .FILL xA000

sub_stack_push_ptr .FILL x3200
sub_stack_pop_ptr .FILL x3400
sub_rpn_multiply .FILL x3600
sub_print_decimal .FILL x3800


num_str .STRINGZ "\nEnter a number to be an operand.\n->"
operation_str .STRINGZ "\nEnter an operator.\n->"
result_str .STRINGZ "\nThe result is "
num_shift .FILL #-48
newline .FILL '\n'



;===============================================================================================


; subroutines:

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3200
ST R1, backup_R1_3200
ST R7, backup_R7_3200
;check if TOS is less than max
NOT R1, R5
ADD R1, R1, #1
ADD R1, R1, R6
BRz OUTPUT_ERROR_3200 ;if TOS is equal to MAX
;increment TOS
ADD R6, R6, #1
;write value to top of stack
STR R0, R6, #0
BR AFTER_ERROR_3200
OUTPUT_ERROR_3200
	LEA R0, overflow_str
	PUTS
AFTER_ERROR_3200
LD R1, backup_R1_3200
LD R7, backup_R7_3200
RET
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data
backup_R1_3200 .blkw #1
backup_R7_3200 .blkw #1

overflow_str .STRINGZ "\nERROR: Overflow. Don't push elements on a full stack!\n"
;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3400
ST R1, backup_R1_3400
ST R7, backup_R7_3400
;check if TOS is greater than base
NOT R1, R4
ADD R1, R1, #1
ADD R1, R1, R6
BRz OUTPUT_ERROR_3400 ;if TOS is equal to BASE
;copy value at TOS to R0
LDR R0, R6, #0
;decrement TOS
ADD R6, R6, #-1		
BR END_ERROR_3400 
OUTPUT_ERROR_3400
	LEA R0, underflow_str
	PUTS
END_ERROR_3400	 
				 
LD R1, backup_R1_3400
LD R7, backup_R7_3400		 
RET
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data
backup_R1_3400 .blkw #1
backup_R7_3400 .blkw #1

underflow_str .STRINGZ "\nERROR: Underflow. Don't pop elements on an empty stack!\n"


;===============================================================================================

;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    multiplied them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R6 ← updated TOS address
;------------------------------------------------------------------------------------------
.orig x3600
ST R0, backup_R0_3600		
ST R1, backup_R1_3600
ST R2, backup_R2_3600
ST R3, backup_R3_3600
ST R7, backup_R7_3600	
;store second operand in R2
LD R0, sub_stack_pop_ptr_3600
JSRR R0
ADD R2, R0, #0
;store first operand in R1
LD R0, sub_stack_pop_ptr_3600
JSRR R0
ADD R1, R0, #0
;multiply time - store result in R3
MULTIPLY_3600
	ADD R2, R2, #0
	BRnz END_MULTIPLY_3600
	ADD R3, R3, R1
	ADD R2, R2, #-1
	BRnz END_MULTIPLY_3600
	BR MULTIPLY_3600
END_MULTIPLY_3600
;push value in R3 onto stack
ADD R0, R3, #0
LD R1, sub_stack_push_ptr_3600
JSRR R1
				 
LD R0, backup_R0_3600		
LD R1, backup_R1_3600
LD R2, backup_R2_3600
LD R3, backup_R3_3600
LD R7, backup_R7_3600		 
RET
;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data
backup_R0_3600 .blkw #1
backup_R1_3600 .blkw #1
backup_R2_3600 .blkw #1
backup_R3_3600 .blkw #1
backup_R7_3600 .blkw #1

sub_stack_push_ptr_3600 .FILL x3200
sub_stack_pop_ptr_3600 .FILL x3400


;===============================================================================================	

; SUB_PRINT_DECIMAL		Only needs to be able to print 1 or 2 digit numbers. 
;						You can use your lab 7 s/r.
; Parameter (R1): The number to be printed
;
; Postcondition: The subroutine has printed the number to the console.
; Return Value: none
.orig x3800
ST R0, backup_R0_3800
ST R1, backup_R1_3800
ST R2, backup_R2_3800
ST R3, backup_R3_3800
ST R4, backup_R4_3800
ST R7, backup_R7_3800
AND R0, R0, #0
AND R2, R2, #0 ;DEDICATED checking for how many times counter
LD R4, num_shift_3800
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
	ADD R2, R2, #0
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
LD R0, backup_R0_3800
LD R1, backup_R1_3800
LD R2, backup_R2_3800
LD R3, backup_R3_3800
LD R4, backup_R4_3800
LD R7, backup_R7_3800
RET
;SUB_PRINT_DECIMAL local data
backup_R0_3800 .blkw #1
backup_R1_3800 .blkw #1
backup_R2_3800 .blkw #1
backup_R3_3800 .blkw #1
backup_R4_3800 .blkw #1
backup_R7_3800 .blkw #1

num_shift_3800 .FILL #48


.end
