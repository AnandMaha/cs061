;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Assignment name: Assignment 5
; Lab section: 24
; TA: David Feng
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
START_INPUT
	LD R6, sub_menu ;return choice in R1
	JSRR R6
	
	;determine which choice is to be called
	ADD R1, R1, #-1
	BRz CHOICE_1
	ADD R1, R1, #-1
	BRz CHOICE_2
	ADD R1, R1, #-1
	BRz CHOICE_3
	ADD R1, R1, #-1
	BRz CHOICE_4
	ADD R1, R1, #-1
	BRz CHOICE_5
	ADD R1, R1, #-1
	BRz CHOICE_6
	BR GOODBYE ;user input is 7 (quit no matter what)
	
	CHOICE_1
		LD R6, sub_all_machines_busy ;return in R2
		JSRR R6
		ADD R2, R2, #0 ;1 if all busy, 0 otherwise
		BRp ALL_BUSY
		BR NOT_ALL_BUSY
		ALL_BUSY
			LEA R0, allbusy
			PUTS
			BR START_INPUT
		NOT_ALL_BUSY
			LEA R0, allnotbusy
			PUTS
			BR START_INPUT
	
	
	CHOICE_2
		LD R6, sub_all_machines_free ;return in R2
		JSRR R6
		ADD R2, R2, #0 ;1 if all free, 0 otherwise 
		BRp ALL_FREE
		BR NOT_ALL_FREE
		ALL_FREE
			LEA R0, allfree
			PUTS
			BR START_INPUT
		NOT_ALL_FREE
			LEA R0, allnotfree
			PUTS
			BR START_INPUT
	
	CHOICE_3
		LD R6, sub_num_busy_machines ;return # of busy machines in R1
		JSRR R6
		LEA R0, busymachine1
		PUTS
		LD R6, sub_print_num ;now print out the number to console
		JSRR R6
		LEA R0, busymachine2
		PUTS
		BR START_INPUT
	
	CHOICE_4
		LD R6, sub_num_free_machines ;return # of busy machines in R1
		JSRR R6
		LEA R0, freemachine1
		PUTS
		LD R6, sub_print_num ;now print out the number to console
		JSRR R6
		LEA R0, freemachine2
		PUTS
		BR START_INPUT
	
	CHOICE_5
		LD R6, sub_get_machine_num
		JSRR R6
		LEA R0, status1
		PUTS
		LD R6, sub_print_num
		JSRR R6
		LD R6, sub_machine_status
		JSRR R6
		ADD R2, R2, #0
		BRz IS_BUSY
		BR IS_NOT_BUSY
		IS_BUSY
			LEA R0, status2
			PUTS
			BR START_INPUT
		IS_NOT_BUSY
			LEA R0, status3
			PUTS
			BR START_INPUT
	CHOICE_6
		LD R6, sub_first_free ;-1 if no free machine, num otherwise
		JSRR R6
		ADD R1, R1, #0
		BRn NO_FREE_MACHINES
		BR IS_FREE_MACHINE
		NO_FREE_MACHINES
			LEA R0, firstfree2
			PUTS
			BR START_INPUT
		IS_FREE_MACHINE
			LEA R0, firstfree1
			PUTS
			LD R6, sub_print_num
			JSRR R6
			LD R0, newline
			OUT
			BR START_INPUT
GOODBYE	
	LEA R0, goodbye
	PUTS

HALT
;---------------	
;Data
;---------------
;Subroutine pointers
sub_menu .FILL x3200
sub_all_machines_busy .FILL x3400
sub_all_machines_free .FILL x3600
sub_num_busy_machines .FILL x3800
sub_num_free_machines .FILL x4000
sub_machine_status .FILL x4200
sub_first_free .FILL x4400
sub_get_machine_num .FILL x4600
sub_print_num .FILL x4800


;Other data 
newline 		.fill '\n'

; Strings for reports from menu subroutines:
goodbye         .stringz "Goodbye!\n"
allbusy         .stringz "All machines are busy\n"
allnotbusy      .stringz "Not all machines are busy\n"
allfree         .stringz "All machines are free\n"
allnotfree		.stringz "Not all machines are free\n"
busymachine1    .stringz "There are "
busymachine2    .stringz " busy machines\n"
freemachine1    .stringz "There are "
freemachine2    .stringz " free machines\n"
status1         .stringz "Machine "
status2		    .stringz " is busy\n"
status3		    .stringz " is free\n"
firstfree1      .stringz "The first available machine is number "
firstfree2      .stringz "No machines are free\n"


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, invited the
;                user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7 (as a number, not a character)
;                    no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
.orig x3200
;HINT back up 
ST R0, backup_R0_3200 
ST R2, backup_R2_3200 
ST R3, backup_R3_3200 
ST R7, backup_R7_3200 
START_MENU
	LD R0, Menu_string_addr
	PUTS
	GETC
	OUT
	ADD R2, R0, #0 ;copy R0 to R2 to output newline next
	;check if input is valid, otherwise output error msg
	LD R3, ascii_shift
	ADD R1, R2, R3
	BRnz INVALID_INPUT ;if R1 is <= 0, invalid input
	;R1 is positive now, if here
	;after subtracting by 8, and result is zero or positive, then invalid input
	ADD R1, R1, #-8
	BRzp INVALID_INPUT
	;if here, then we have good input, and will "revert" R1 back to its proper number
	ADD R1, R1, #8
	BR AFTER_INVALID_INPUT
INVALID_INPUT
	LD R0, newline1
	OUT
	LEA R0, Error_msg_1
	PUTS
	BR START_MENU
AFTER_INVALID_INPUT
;either case, output newline
LD R0, newline1
OUT
;HINT Restore
LD R0, backup_R0_3200 
LD R2, backup_R2_3200 
LD R3, backup_R3_3200 
LD R7, backup_R7_3200 
RET
;--------------------------------
;Data for subroutine MENU
;--------------------------------
;backup registers
backup_R0_3200 .BLKW #1
backup_R2_3200 .BLKW #1
backup_R3_3200 .BLKW #1
backup_R7_3200 .BLKW #1

ascii_shift .FILL #-48
newline1 .FILL '\n'
Error_msg_1	      .STRINGZ "INVALID INPUT\n"
Menu_string_addr  .FILL x6400

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY (#1)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------
.orig x3400
;HINT back up 
ST R1, backup_R1_3400 
ST R3, backup_R3_3400 
ST R7, backup_R7_3400 

AND R2, R2, #0
LDI R1, BUSYNESS_ADDR_ALL_MACHINES_BUSY
LD R3, HEX_FFFF_1
AND R1, R1, R3
BRz SET_R2_1_3400 ;0 AND 1 is 0, so if all machines are busy(0), result is 0
BR AFTER_SET_R2_1_3400
SET_R2_1_3400
	ADD R2, R2, #1
AFTER_SET_R2_1_3400

;HINT Restore
LD R1, backup_R1_3400 
LD R3, backup_R3_3400 
LD R7, backup_R7_3400 
RET

;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
;backup registers
backup_R1_3400 .BLKW #1
backup_R3_3400 .BLKW #1
backup_R7_3400 .BLKW #1

HEX_FFFF_1 .FILL xFFFF
BUSYNESS_ADDR_ALL_MACHINES_BUSY .Fill xB200

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE (#2)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------
.orig x3600
;HINT back up 
ST R1, backup_R1_3600 
ST R3, backup_R3_3600 
ST R7, backup_R7_3600 

AND R2, R2, #0
LDI R1, BUSYNESS_ADDR_ALL_MACHINES_FREE
LD R3, HEX_FFFF
AND R1, R1, R3
ADD R1, R1, #1
BRz SET_R2_1 ;xFFFF AND xFFFF is xFFFF; xFFFF + x1 = x0
BR AFTER_SET_R2_1
SET_R2_1
	ADD R2, R2, #1
AFTER_SET_R2_1

;HINT Restore
LD R1, backup_R1_3600 
LD R3, backup_R3_3600 
LD R7, backup_R7_3600 
RET
;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
;backup registers
backup_R1_3600 .BLKW #1
backup_R3_3600 .BLKW #1
backup_R7_3600 .BLKW #1

HEX_FFFF .FILL xFFFF
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xB200

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES (#3)
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R1): The number of machines that are busy (0)
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------
.orig x3800
;HINT back up 
ST R2, backup_R2_3800 
ST R3, backup_R3_3800 
ST R7, backup_R7_3800 
;strategy: left shift until count is 0
AND R1, R1, #0 ;counter
LDI R2, BUSYNESS_ADDR_NUM_BUSY_MACHINES
AND R3, R3, #0
ADD R3, R3, #15
ADD R3, R3, #1 ;R3 is 16
START_LOOP
	ADD R2, R2, #0
	BRzp ADD_ONE
	BR END_ADD_ONE
	ADD_ONE
		ADD R1, R1, #1
	END_ADD_ONE
	ADD R2, R2, R2
	ADD R3, R3, #-1
	BRp START_LOOP ;continue looping until R3 is 0
	
;HINT Restore
LD R2, backup_R2_3800 
LD R3, backup_R3_3800 
LD R7, backup_R7_3800 
RET
;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
backup_R2_3800 .BLKW #1
backup_R3_3800 .BLKW #1
backup_R7_3800 .BLKW #1

BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xB200


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES (#4)
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R1): The number of machines that are free (1)
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------
.orig x4000
;HINT back up 
ST R2, backup_R2_4000 
ST R3, backup_R3_4000 
ST R7, backup_R7_4000 
;strategy: left shift until count is 0
AND R1, R1, #0 ;counter
LDI R2, BUSYNESS_ADDR_NUM_FREE_MACHINES
AND R3, R3, #0
ADD R3, R3, #15
ADD R3, R3, #1 ;R3 is 16
START_LOOP_4000
	ADD R2, R2, #0
	BRn ADD_ONE_4000
	BR END_ADD_ONE_4000
	ADD_ONE_4000
		ADD R1, R1, #1
	END_ADD_ONE_4000
	ADD R2, R2, R2
	ADD R3, R3, #-1
	BRp START_LOOP_4000 ;continue looping until R3 is 0
	
;HINT Restore
LD R2, backup_R2_4000 
LD R3, backup_R3_4000 
LD R7, backup_R7_4000 
RET
;--------------------------------
;Data for subroutine NUM_FREE_MACHINES 
;--------------------------------
backup_R2_4000 .BLKW #1
backup_R3_4000 .BLKW #1
backup_R7_4000 .BLKW #1

BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xB200


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS (#5)
; Input (R1): Which machine to check, guaranteed in range {0,15}
; Postcondition: The subroutine has returned a value indicating whether
;                the selected machine (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;              (R1) unchanged
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------
.orig x4200
;HINT back up 
ST R1, backup_R1_4200
ST R3, backup_R3_4200
ST R7, backup_R7_4200
AND R2, R2, #0
LDI R3, BUSYNESS_ADDR_MACHINE_STATUS
ADD R1, R1, #-15
BRz END_LOOP_4200
START_LOOP_4200
	ADD R3, R3, R3
	ADD R1, R1, #1
	BRz END_LOOP_4200
	BR START_LOOP_4200
END_LOOP_4200
ADD R3, R3, #0
BRn SET_R2_1_4200
BR AFTER_SET_R2_1_4200
SET_R2_1_4200
	ADD R2, R2, #1
AFTER_SET_R2_1_4200
;HINT Restore
LD R1, backup_R1_4200
LD R3, backup_R3_4200
LD R7, backup_R7_4200
RET
;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
backup_R1_4200 .BLKW #1
backup_R3_4200 .BLKW #1
backup_R7_4200 .BLKW #1

BUSYNESS_ADDR_MACHINE_STATUS.Fill xB200

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE (#6)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R1): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------
.orig x4400
;HINT back up 
ST R2, backup_R2_4400
ST R3, backup_R3_4400
ST R4, backup_R4_4400
ST R5, backup_R5_4400
ST R7, backup_R7_4400

;take machine bit AND 1, if 1, then return
AND R1, R1, #0
AND R2, R2, #0
ADD R2, R2, #1 ;R2 is the bit mask
LDI R3, BUSYNESS_ADDR_FIRST_FREE
AND R4, R4, #0 ;dest register
LD R5, bit_count
LOOP
	AND R4, R2, R3
	;if R4 is not zero, exit loop
	BRnp END_SUBR
	ADD R1, R1, #1
	ADD R2, R2, R2 ;left shift 1 bit mask
	ADD R5, R5, #-1
	BRz SET_R1_neg_1 ;if count is 0, that means no bits are free (no RET 1)
	BR LOOP
SET_R1_neg_1
	AND R1, R1, #0
	ADD R1, R1, #-1
END_SUBR

;HINT Restore
LD R2, backup_R2_4400
LD R3, backup_R3_4400
LD R4, backup_R4_4400
LD R5, backup_R5_4400
LD R7, backup_R7_4400

RET
;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
backup_R2_4400 .BLKW #1
backup_R3_4400 .BLKW #1
backup_R4_4400 .BLKW #1
backup_R5_4400 .BLKW #1
backup_R7_4400 .BLKW #1

bit_count .FILL #16
BUSYNESS_ADDR_FIRST_FREE .Fill xB200

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: GET_MACHINE_NUM
; Inputs: None
; Postcondition: The number entered by the user at the keyboard has been converted into binary,
;                and stored in R1. The number has been validated to be in the range {0,15}
; Return Value (R1): The binary equivalent of the numeric keyboard entry
; NOTE: You can use your code from assignment 4 for this subroutine, changing the prompt, 
;       and with the addition of validation to restrict acceptable values to the range {0,15}
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.orig x4600
ST R0, backup_R0_4600
ST R2, backup_R2_4600
ST R3, backup_R3_4600
ST R4, backup_R4_4600
ST R5, backup_R5_4600
ST R7, backup_R7_4600

START_INPUT_4600
	AND R1, R1, #0
	LD R2, digit_counter
	LEA R0, prompt
	PUTS
	DIGITS
		GETC
		OUT
		
		;valid inputs are enter, digit 1-9
		LD R3, enter_shift 
		ADD R3, R0, R3
		BRz ENTER_CHECK
		
		LD R3, nine_shift		; is it > '9'? if so, it is not a digit	- o/p error message, start over
		ADD R3, R0, R3
		BRp INVALID_INPUT_4600
			
		LD R3, zero_shift			; is it < '0'? if so, it is not a digit	- o/p error message, start over
		ADD R3, R0, R3
		BRn INVALID_INPUT_4600 
		
		;multiply number by 10 (ADD R1 to its original value 9 times)
		ADD R5, R1, #0
		AND R4, R4, #0
		ADD R4, R4, #9
		MULTIPLY_10
			ADD R1, R1, R5
			ADD R4, R4, #-1
			BRz END_MULTIPLY_10
			BR MULTIPLY_10
		END_MULTIPLY_10
		;and add digit to it
		ADD R1, R1, R3		;R3 has actual number (R0 - 48)
		
		ADD R2, R2, #-1
		BRz CHECK_LESS_THAN_16
		BR DIGITS
		
ENTER_CHECK ;if enter was entered immediately (no digits before), that's an error
	ADD R2, R2, #-2
	BRz INVALID_INPUT_4600
	BR AFTER_GET_ENTER

CHECK_LESS_THAN_16
	ADD R1, R1, #-16
	BRzp BEFORE_INVALID_INPUT_4600
	ADD R1, R1, #15
	ADD R1, R1, #1
	BR AFTER_INVALID_INPUT_4600
BEFORE_INVALID_INPUT_4600
	GETC
	OUT
INVALID_INPUT_4600
	LD R0, newline_4600
	OUT
	LEA R0, Error_msg_2
	PUTS
	BR START_INPUT_4600
AFTER_INVALID_INPUT_4600

GETC
OUT

AFTER_GET_ENTER
LD R0, backup_R0_4600
LD R2, backup_R2_4600
LD R3, backup_R3_4600
LD R4, backup_R4_4600
LD R5, backup_R5_4600
LD R7, backup_R7_4600
RET
;--------------------------------
;Data for subroutine Get input
;--------------------------------
backup_R0_4600 .BLKW #1
backup_R2_4600 .BLKW #1
backup_R3_4600 .BLKW #1
backup_R4_4600 .BLKW #1
backup_R5_4600 .BLKW #1
backup_R7_4600 .BLKW #1

newline_4600 .FILL '\n'
zero_shift .FILL #-48
nine_shift .FILL #-57
enter_shift .FILL #-10
digit_counter .FILL #2
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_msg_2 .STRINGZ "ERROR INVALID INPUT\n"
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUM
; Inputs: R1, which is guaranteed to be in range {0,16}
; Postcondition: The subroutine has output the number in R1 as a decimal ascii string, 
;                WITHOUT leading 0's, a leading sign, or a trailing newline.
; Return Value: None; the value in R1 is unchanged
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.orig x4800
ST R0, backup_R0_4800
ST R1, backup_R1_4800
ST R2, backup_R2_4800
ST R7, backup_R7_4800
;if R1 < 10, just output, else output 1, and subtract 
AND R0, R0, #0
LD R2, ascii_shift_4800
ADD R1, R1, #-10
BRn OUTPUT
;num is > 10
ADD R0, R0, #1
ADD R0, R0, R2
OUT
ADD R1, R1, #-10 ;because we are adding #10 in OUTPUT
;now can output least sig. dig. of num
OUTPUT
	ADD R1, R1, #10
	ADD R0, R1, R2
	OUT
	
LD R0, backup_R0_4800
LD R1, backup_R1_4800
LD R2, backup_R2_4800
LD R7, backup_R7_4800
RET
;--------------------------------
;Data for subroutine print number
;--------------------------------
backup_R0_4800 .BLKW #1
backup_R1_4800 .BLKW #1
backup_R2_4800 .BLKW #1
backup_R7_4800 .BLKW #1

ascii_shift_4800 .FILL #48


;REMOTE DATA
.ORIG x6400
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xB200			; Remote data
BUSYNESS .FILL x8000		; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.

;---------------	
;END of PROGRAM
;---------------	
.END
