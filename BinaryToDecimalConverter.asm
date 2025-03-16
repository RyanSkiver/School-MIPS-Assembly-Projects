# Author: Ryan Skiver
# Date: 3/11/2025
# Description: binary to decimal converter


# Data for the program goes here
.data
prompt: .asciiz "Enter a binary number: "
result: .asciiz "Equivalent decimal number is: "
bin_num: .space 16 #store 15 plus newline character

# Code goes here
.text
main:
	#print prompt
	li $v0, 4		#load print
	la $a0, prompt		#load prompt for printing
	syscall
	
	#user binary input
	li $v0, 8		#read string
	la $a0, bin_num		#load address of bin_num
	li $a1, 15		#set max input size to 15
	syscall
	
	#jump to conversion loop
	la $a0, bin_num		#pass string in as argument
	jal binary_to_dec	#jump to cconverter
	move $t5, $v0		#move result to t5 to save
	
	#priont result text
	li $v0, 4		#print string
	la $a0, result		#load result for printing
	syscall
	#print result number
	li $v0, 1		#print int
	move $a0, $t5		#move decimal for print
	syscall
	
end_main:
	li $v0, 10		# 10 is the exit program syscall
	syscall			# execute call

## end of ca.asm

###############################################################
# Convert ascii string of binary digits to integer
#
# $a0 - input, pointer to null-terminated string of 1's and 0's (requried)
# $v0 - output, integer form of binary string (required)
# $t0 - ascii value of the char pointed to (optional)
# $t1 - integer value (0 or 1) of the char pointed to (optional)
# $t2 - store the address of bin_num

binary_to_dec:
	li $v0, 0		#initialize accumulator
	move $t2, $a0		#move bin_num into $t2
loop:				
	lb $t0, 0($t2)		#load byte from string
	beq $t0, $zero, end_binary_to_dec #if null terminator exit
	beq $t0, 0xa, end_binary_to_dec #if newline exit
	
	sll $v0, $v0, 1		#shift accumulator left 1
	subi $t1, $t0, 0x30	#sub ascii value from loaded byte
	or $v0, $v0, $t1	#add value to accumulator
	
	addi $t2, $t2, 1	#next character
	j loop			#jump to begin of loop
end_binary_to_dec:
        jr $ra
