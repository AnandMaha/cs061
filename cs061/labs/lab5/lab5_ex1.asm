;=================================================
; Name: Anand Mahadevan
; Email: amaha018@ucr.edu
; 
; Lab: lab 5, ex 1
; Lab section: 24
; TA: David Feng
; 
;=================================================


.orig x3000
;Instructions
AND R1, R1, #0 ;value to store in arr
ADD R1, R1, #1
LD R2, counter ;counter
LD R6, ARR_PTR ;memory address
;populate arr with 2^0 to 2^9
LOOP
	STR R1, R6, #0
	ADD R1, R1, R1
	ADD R6, R6, #1
	ADD R2, R2, #-1
	BRp LOOP
END_LOOP

; output values in array to console
LD R2, counter ;counter
LD R5, ARR_PTR ;memory address
LD R6, SUB_OUTPUT_BINARY_3200_PTR
LOOP2
	JSRR R6
	ADD R5, R5, #1
	ADD R2, R2, #-1
	BRp LOOP2
END_LOOP2

HALT
;Local Data (Main)
counter .FILL #10
ARR_PTR .FILL x3100
SUB_OUTPUT_BINARY_3200_PTR .FILL x3200
;Remote Data
.orig x3100
ARR .BLKW #10


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

;R5 is the pointer of the current number
LDR R1, R5, #0			; R1 <-- value to be displayed as binary 
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





.end
