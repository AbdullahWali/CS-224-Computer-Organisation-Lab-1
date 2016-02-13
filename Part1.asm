#	Author: Abdullah Wali
#	Part 1 of Lab 1
#	Exercising MIPS in a non-branching non-jumping program with user I/O



	######################################################
	#     						######
	#		Text Segment			######
	#						#####
	#####################################################

	.text
	.globl __start
	
__start:
	#####################################################
  	#Artithmetic operations				  ###
	#####################################################
	la $a0 , IntegerPrompt  
	li $v0 , 4
	syscall  #Print Prompt
	
	li $v0, 5  
	syscall #Get 32 bit Integer From user

	move $s0, $v0 #store contents in s0
	li $s1, 50 # Put a value in s1 to use in arithmetic operations
	
	add $s0, $s0, $s0 #add s0 to itslef
	sub $s0, $s0, $s1 # substract: s0 - s1
	mul $s0, $s0, $s1 # multiplay: s0 * s1
	
	li $t0 , 0x10010040
	sw  $s0, 0($t0) #store s0 in memory location at $t0
	
	addi $s0, $0, 0 #Put value 0 in s0
	
	lw $s0, 0($t0) # restore value of s0
	
	la $a0 , resultMessage  
	li $v0 , 4 
	syscall  #Print result string
	la $a0, ($s0)
	li $v0, 1
	syscall #Print the Integer
	la $a0, resultMessage2
	li $v0 , 4 
	syscall  #Print 2nd PArt of the string
	la $a0, ($s0)
	li $v0, 34
	syscall #Print the Integer in hex
	
	
	#####################################################
  	#logical operations				  ###
	#####################################################
	
	addi $s1, $0, 0x00FF
	
	and $s3, $s1, $s0   #AND s0 and s1
	or $s3, $s0, $s1    #OR s0 and s1
	xor $s3, $s0, $s1   #XOR
	nor $s3, $s0, $s1  #nor
	
	#same operations with Immediate
	
	andi $s3, $s0, 0x00FF
	ori $s3, $s0, 0x00FF
	xori $s3, $s0, 0x00FF
	
	#shifts
	
	sll $s3, $s0, 3 #logical shift left
	srl $s3, $s0, 3 #logical shift right
	sra $s3, $s0, 3 #arithmetic shift right
	
	#using variable
	addi $t0 , $0 , 3 #temporary integer value 3
	sllv $s3, $s0, $t0 #logical shift left
	srlv $s3, $s0, $t0 #logical shift right
	srav $s3, $s0, $t0 #arithmetic shift right
	
	
	######################################################
	#     						######
	#		Data Segment			######
	#						#####
	#####################################################
	
		
	.data 
IntegerPrompt: .asciiz "Enter an Integer: "
resultMessage: .asciiz "The final result is: "
resultMessage2: .asciiz "\nIn hex it is: "
	