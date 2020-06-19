;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 9, ex 1 & 2
; Lab section: 24
; TA: David Feng
; 
;=================================================

; test harness
.orig x3000
LD R4, base_ptr
LD R5, max_ptr	
LD R6, tos_ptr
 
LOOP
	LEA R0, enter_str
	PUTS
	GETC
	OUT
	;check if enter was entered
	ADD R1, R0, #-10
	BRz END_LOOP
	;else push value to stack
	LD R1, num_shift
	ADD R0, R0, R1
	LD R1, sub_stack_push_ptr
	JSRR R1
	LD R0, newline
	OUT
	BR LOOP
END_LOOP				 

AND R2, R2, #0
ADD R2, R2, #6
START_LOOP
	LD R1, sub_stack_pop_ptr
	JSRR R1
	LD R3, num_shift_2
	ADD R0, R0,R3
	OUT
	ADD R2, R2, #-1
	BRz END_LOOP_2
	BR START_LOOP
END_LOOP_2
 
HALT
;-----------------------------------------------------------------------------------------------
; test harness local data:
base_ptr .FILL xA000
max_ptr .FILL xA005
tos_ptr .FILL xA000

sub_stack_push_ptr .FILL x3200
sub_stack_pop_ptr .FILL x3400

enter_str .STRINGZ "Enter a number to push onto stack. Press enter key to quit\n->"
num_shift .FILL #-48
num_shift_2 .FILL #48
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

.end
