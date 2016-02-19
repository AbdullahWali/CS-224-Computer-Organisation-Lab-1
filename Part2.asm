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

	#Put Everything in a loop that terminates when integer entered is 0
	
	#####################################################
	#Read integer from user and store in s7
	#1st Integer
loop:	la $a0 , IntegerPrompt  
	li $v0 , 4
	syscall  #Print Prompt
		
	li $v0, 5  
	syscall #Get 32 bit Integer From user
	move $s7, $v0
	beq $s7, $0, done #exit loop if s0 is 0
	move $a0 ,$s7 
	
	#loop from 0 to N 
	addi $s1, $0 , 0 #i = 0 
	addi $s2, $s7 , 1 #N+1 in t1 
printLoop:
	slt $t3, $s1, $s2 # i < N+1 
	beq $t3, $0, printLoopDone
	
	
	#Print Message
	la $a0 , ResultMessage
	li $v0 , 4
	syscall	
	
	move $a0 , $s1
	#call factorial
	jal fact
	move $a0, $v0 
	li $v0 , 1
	syscall #print result 
	
	addi $s1, $s1, 1
	j printLoop
printLoopDone:	
	
	j loop 
done:	
	li $v0, 10
	syscall #goodbye
	
	
	
	#####################################################
	###			Functions		####
	####################################################
	
fact: 	#compute factorial of $a0
	addi $t1 , $0, 2 #put 2 in t1
	slt $t0 , $a0 , $t1 
	beq $t0 , $0 , factElse
	addi $v0 , $0, 1 #set result to 1
	jr $ra
	
factElse: addi $sp, $sp , -8
	sw $a0, 4($sp) #save a0 in stack
	sw $ra, 0($sp) #save ra in stack
	
	addi $a0, $a0, -1 
	jal fact #fact ( n-1) 
	lw $ra , 0($sp) #load old ra
	lw $a0, 4 ($sp) #load old a0
	addi $sp, $sp , 8
	mul $v0, $a0, $v0 #set v0 to n * fact(n-1)
	jr $ra
	#############################################
	
	
	######################################################
	#     						######
	#		Data Segment			######
	#						#####
	#####################################################
	
		
	.data 
IntegerPrompt: .asciiz "\nEnter an Integer: "
ResultMessage: .asciiz "\nThe result that was obtained is: "
	
	
	
