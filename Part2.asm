#	Author: Abdullah Wali
#	Part 2 of Lab 1
#	Using MIPS for mathematical calculations in a loop



	#####################################################
	#     						#####
	#		Text Segment			#####
	#						#####
	#####################################################

	.text
	.globl __start
	
__start:

	#Put Everything in a loop that terminates when integer 
	
	#####################################################
	#Read 2 integers from user and store in s0 and s1
	#1st Integer
loop:	la $a0 , IntegerPrompt  
	li $v0 , 4
	syscall  #Print Prompt
		
	li $v0, 5  
	syscall #Get 32 bit Integer From user
	move $s0, $v0
	beq $s0, $0, done #exit loop if s0 is 0
	
	#2nd Integer
	la $a0 , IntegerPrompt  
	li $v0 , 4
	syscall  #Print Prompt
	
	li $v0, 5  
	syscall #Get 32 bit Integer From user
	move $s1, $v0
	beq $s1, $0, done #exit loop is s1 is 0 
	############################################
	
	
	
	

	#Print Result
	la $a0 , ResultMessage
	li $v0 , 4
	syscall
	
	
	j loop 
done:	
	
	
	
	
	######################################################
	#     						######
	#		Data Segment			######
	#						#####
	#####################################################
	
		
	.data 
IntegerPrompt: .asciiz "Enter an Integer: "
ResultMessage: .asciiz "The result that was obtained is: \n"
	
	
	