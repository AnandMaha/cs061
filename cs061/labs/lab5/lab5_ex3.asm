;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 5, ex 3
; Lab section: 24
; TA: David Feng
; 
;=================================================
.orig x3000
;Instructions
LD R6, sub_binary_read_3400
JSRR R6
LD R6, SUB_OUTPUT_BINARY_3200_PTR
JSRR R6
LEA R0, end_msg
PUTS
HALT
;Local Data (Main)
sub_binary_read_3400 .FILL x3400
SUB_OUTPUT_BINARY_3200_PTR .FILL x3200
end_msg .STRINGZ "Your converted decimal/hex value is stored in R2\n"
;-----------------------------------------------------------------
;SUBROUTINE -- sub_binary_read_3400
;Input - none
;Postcondition - R2 contains value of binary number inputted
;Return value - R2, contains value of binary number
.ORIG x3400			; Subroutine begins here

;Back up registers
ST R0, backup_R0_3400
ST R1, backup_R1_3400
ST R4, backup_R4_3400
ST R6, backup_R6_3400
ST R7, backup_R7_3400
;-------------
;Instructions
;-------------

;write subroutine code
BEFORE_INTRO
	;Variables
	LD R1, counter ;counter for input
	AND R2, R2, #0 ;stores value 
	LD R4, b_shift ;register for loading shifts (b, 0, 1)
	LD R6, ARR_PTR ;array for outputting input back to user (after error)

	LEA R0, intro_msg
	PUTS
	
	GETC ;get 'b'
	OUT
	;if it's not b, restart program (go to BEFORE_INTRO)
	ADD R4, R4, R0
	BRz PUT_B_INTO_ARR
	BR ERROR_B

PUT_B_INTO_ARR
	STR R0, R6, #0
	ADD R6, R6, #1
	BR GET_NUM

ERROR_B
	LEA R0, b_error_msg
	PUTS
	BR BEFORE_INTRO
ERROR_BIT
	LEA R0, bit_error_msg
	PUTS
	LD R0, ARR_PTR ;to output previous input back to the user
	PUTS
	BR GET_NUM

GET_NUM
	GETC
	OUT
	
	;check for proper input
	;is it space?
	LD R4, space_shift
	ADD R4, R4, R0
	BRz GET_NUM ;fine to output space, just re-get input
	;is it less than zero?
	LD R4, zero_shift
	ADD R4, R4, R0
	BRn ERROR_BIT
	;is it greater than one?
	LD R4, one_shift
	ADD R4, R4, R0
	BRp ERROR_BIT
	
	;put 0 or 1 into ARR, increment R6
	STR R0, R6, #0
	ADD R6, R6, #1
	
	ADD R2, R2, R2
	;check if R0 is 0 or 1
	LD R4, zero_shift
	ADD R0, R0, R4
	BRp ADD_ONE
	BR AFTER_ADD_ONE
	ADD_ONE
		ADD R2, R2, #1
	AFTER_ADD_ONE
	ADD R1, R1, #-1
	BRp GET_NUM

;newline line always
LD R0, newline
OUT
;restore registers (DONT RESTORE R2)
LD R0, backup_R0_3400
LD R1, backup_R1_3400
LD R4, backup_R4_3400
LD R6, backup_R6_3400
LD R7, backup_R7_3400
;return (RET)
RET
;---------------	
;Subroutine Data
;---------------
counter .FILL #16    ; Counter for user input (b is outside number input)
intro_msg .STRINGZ "Enter a 16-bit binary number ex. b_________\n->" ;intro prompt
b_error_msg .STRINGZ "\nPlease enter b before entering your binary number!\n";b error message
bit_error_msg .STRINGZ "\nPlease enter either 0 or 1.\n->";bit error message
b_shift .FILL #-98
zero_shift .FILL #-48
one_shift .FILL #-49
space_shift .FILL #-32
newline .FILL '\n'
ARR_PTR .FILL x3500

backup_R0_3400 .BLKW #1
backup_R1_3400 .BLKW #1
backup_R4_3400 .BLKW #1
backup_R6_3400 .BLKW #1
backup_R7_3400 .BLKW #1

;Remote Data
.orig x3500
ARR .BLKW #17

;-------------------------------------------------------------------------------

;-----------------------------------------------------------------
;SUBROUTINE -- SUB_OUTPUT_BINARY_3200
;Input - Pointer of value to output as binary (R5)
;Postcondition - Binary value has been outputted to console
;Return value - none
.ORIG x3200			; Subroutine begins here

;Back up registers
ST R0, backup_R0_3200
ST R1, backup_R1_3200
ST R2, backup_R2_3200
ST R3, backup_R3_3200
ST R7, backup_R7_3200
;-------------
;Instructions
;-------------

;write subroutine code

;R2 is the register w/ number value
ADD R1, R2, #0			; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
LD R2, Bit_count
LD R3, Space_count
FOR_LOOP
	;output bit -- start
	ADD R1, R1, #0 ;determine first bit
	BRn ONE_BIT ;jump to ONE_BIT section
	;zero bit section -- start
	LD R0, Zero_ascii
	OUT
	BRzp END_ONE_BIT ; jump after ONE_BIT section
	;zero bit section -- end
	ONE_BIT
		LD R0, One_ascii
		OUT
	END_ONE_BIT
	;output bit -- end
	
	;decrement bit count
	;the only purpose of this block of 3 lines is to not output a space 
	;at the end of the 16 bit sequence
	ADD R2, R2, #-1
	BRz END_FOR_LOOP
	ADD R2, R2, #1
	
	;output space -- start
	ADD R3, R3, #-1 ;decrement # of spaces needed for a space 
	BRz OUTPUT_SPACE ;check if space need to be outputted
	BRnp END_OUTPUT_SPACE ;if R3 > 0, skip over outputting the space 
	OUTPUT_SPACE
		LD R0, Space_ascii
		OUT
		LD R3, Space_count ;Reset space counter to four
	END_OUTPUT_SPACE
	;output space -- end
	
	ADD R1, R1, R1 ;left bit shift
	
	;decrement bit count
	ADD R2, R2, #-1
	BRp FOR_LOOP
END_FOR_LOOP
LD R0, Newline_ascii
OUT

;restore registers
LD R0, backup_R0_3200
LD R1, backup_R1_3200
LD R2, backup_R2_3200
LD R3, backup_R3_3200
LD R7, backup_R7_3200
;return (RET)
RET
;---------------	
;Subroutine Data
;---------------
Space_count .FILL #4    ; Counter for output space
Bit_count .FILL #16     ; Number of bits needed for outputting

Space_ascii .FILL ' '   ; Every 4 bits, a space needs to be outputted
Newline_ascii .FILL '\n'; newline to be outputted at the end of printing
Zero_ascii .FILL '0'    ; 0 character 
One_ascii .FILL '1'		; 1 character

backup_R0_3200 .BLKW #1
backup_R1_3200 .BLKW #1
backup_R2_3200 .BLKW #1
backup_R3_3200 .BLKW #1
backup_R7_3200 .BLKW #1
;-------------------------------------------------------------------------------




.end
