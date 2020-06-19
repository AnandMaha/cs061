;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 5, ex 2
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
HALT
;Local Data (Main)
sub_binary_read_3400 .FILL x3400
SUB_OUTPUT_BINARY_3200_PTR .FILL x3200

;-----------------------------------------------------------------
;SUBROUTINE -- sub_binary_read
;Input - none
;Postcondition - R2 contains value of binary number inputted
;Return value - R2, contains value of binary number
.ORIG x3400			; Subroutine begins here

;Back up registers
ST R0, backup_R0_3400
ST R1, backup_R1_3400
ST R3, backup_R3_3400
ST R7, backup_R7_3400
;-------------
;Instructions
;-------------

;write subroutine code

LEA R0, intro_msg
PUTS
;Variables
LD R1, counter
AND R2, R2, #0
AND R3, R3, #0

GETC ;get 'b'
OUT

GET_NUM
	GETC
	OUT
	ADD R2, R2, R2
	;check if R0 is 0 or 1
	ADD R0, R0, #-16
	ADD R0, R0, #-16
	ADD R0, R0, #-16
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
LD R3, backup_R3_3400
LD R7, backup_R7_3400
;return (RET)
RET
;---------------	
;Subroutine Data
;---------------
counter .FILL #16    ; Counter for user input (b is outside number input)
intro_msg .STRINGZ "Enter a 16-bit binary number ex. b_________\n" ;intro prompt
zero_shift .FILL #-48
newline .FILL '\n'

backup_R0_3400 .BLKW #1
backup_R1_3400 .BLKW #1
backup_R3_3400 .BLKW #1
backup_R7_3400 .BLKW #1
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
