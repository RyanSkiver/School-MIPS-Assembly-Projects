# Author: Ryan Skiver
# Date: 3/4/2025
# Description: Module 3 challenge activity

# Registers used:
#	$a0	-string printing
#	$v0	-syscalls and return value
#	$t7	-secret number
#	$t1	-user input guess
#	$t2	-number of guesses
#	$t3	-guess array offset
#	$t4	-print loop counter
#	$t5	-guesses array

.data  # Data used by the program
prompt: .asciiz "Enter a number between 0-10: "
winner_txt: .asciiz "You guessed the correct number!\n"
low_txt: .asciiz "Guess a bigger number.\n"
high_txt: .asciiz "Guess a smaller number.\n"
loser_txt: .asciiz "The correct number was: "
guesses_txt: .asciiz "Your guesses: "
newline: .asciiz "\n"
space: .asciiz " "

secret: .word 7			#secret value
guesses: .space 20 		#place to hold user guesses

.text  # Instructions/code of the actual program
main:
	#initialization
	li $t2, -1		#initialize guess amount tracker to -1
	lw $t7, secret		#load secret number into $t7
loop:
	bge $t2, 4, end_loss	#jump to end_loop if guesses greater than 5 (4 for logic sake)
	add $t2, $t2, 1		#$t2++
	
	la $a0, prompt		#load prompt into $a0
	li $v0, 4		#print string
	syscall		
	
	li $v0, 5		#user input integer
	syscall
	move $t1, $v0		#$t1 = $v0
	
	beq $t7, $t1, won 	#if $t7 = $t1 jump to winner code
	
	sll $t3, $t2, 2		#shift left 2: $t3 = $t2 * 4
	sw $v0, guesses($t3)	#store user input into guesses[$t3]
	
	bgt $t7, $t1, low	#if $t7 > $t1
	blt $t7, $t1, high	#if $t7 < $t1
	
#text and jump to correct spot depending on guess	
won:
	la $a0, winner_txt	#load winner_txt
	li $v0, 4		#print string
	syscall
	j exit			#jump to exit
low:
	la $a0, low_txt		#load low_txt
	li $v0, 4		#print string
	syscall
	j loop			#jump to exit
high:	
	la $a0, high_txt	#load high_txt
	li $v0, 4		#print string
	syscall
	j loop			#jump to exit

end_loss: #end of loop and results loss
	la $a0, loser_txt	#load loser_txt
	li $v0, 4		#print string
	syscall
	move $a0, $t7		#move secret number
	li $v0, 1		#print integer
	syscall
	la $a0, newline		#newline for appearance
	li $v0, 4		#print string
	syscall
	
	la $a0, guesses_txt	#load guesses_txt
	syscall
	li $t4, 0		#print loop counter initialization
	li $t3, 0		#reinitialize guess array offset to 0
print_loop:	#loop for printing the full array
	bgt $t4, $t2, exit	#if $t4 > $t2 exit ($t2 is number of guesses)
	
	sll $t3, $t4, 2		#shift left 2: $t3 = $t4 * 4
	lw $a0, guesses($t3) 	#load correct guess from array
	li $v0, 1		#print int
	syscall
	
	la $a0, space		#print space for appearance
	li $v0, 4		#print string
	syscall
	
	add $t4, $t4, 1		#$t3++
	j print_loop
exit:
	#exit the program using syscall 10 - exit
	li $v0, 10
	syscall
