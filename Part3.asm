#	Author: Abdullah Wali
#	Part 2 of Lab 1
#	Using MIPS for sorting and searching

	#####################################################
	#     						#####
	#		Text Segment			#####
	#						#####
	#####################################################

	.text
	.globl __start
	
__start:

	#  Permenants:     $s6 = Heap memory address 	$s7 = N

	# Ask user for the number of Integers: N
	la $a0 , CountPrompt  
	li $v0 , 4
	syscall  #Print Prompt
	
	li $v0, 5  
	syscall #Get N from User
	move $s7, $v0 # Store N in $s7
	
	#request heap space
	li $t0 , 4 #put the value 4 in $to ( to multiply by for later)
	mul $a0, $v0, $t0  #Multiply the number of integers by 4 to get the number of bytes and set as arguement
	li $v0, 9 
	syscall #request N*4 bytes of memory from heap
	move $s6 , $v0 #put the address of requested memory in $s6
	
	
	# Ask user for the N inputs and store them on heap memory
	move $s0, $s7  #copy s7 to s0 to be able to modify it 
	move $s1, $s6  # copy s6 to s1 to be able to modify it
	
readIntsLoop:
	beq $s0, $0, readIntsLoopDone
	
	la $a0 , IntegerPrompt  
	li $v0 , 4
	syscall  #Print Prompt
	
	li $v0, 5  
	syscall #Get the integer from User
	sw $v0, 0($s1) #store the int in heap memory 
	
	addi $s1 , $s1, 4 #move the heap pointer to next 4 bytes
	addi $s0, $s0, -1 
	j readIntsLoop
	
readIntsLoopDone:


	####################################################################
	# Bubble sort:
	#		$s0 = last, $s1 = i, $s2 = address of heap
	###################################################################
	
	
	move $s2, $s6  #copy s7 to s0 to be able to modify it 	
	addi $s0 , $s7 , -1 #last = N-1
	
outerLoopSort:
	slt $t0 , $0 , $s0
	beq $t0 , $0, outerLoopEnd #end loop if last <= 0
	
	addi $s1 , $0 , 0  # i  = 0
	move $s2 , $s6 #reset the memory address pointer to i = 0
innerLoopSort:
	slt $t0, $s1, $s0  # t0 = i <last
	beq $t0 , $0 , innerLoopEnd #end if not 
	
	lw $t1 , 0 ($s2)  # arr[i]
	lw $t2, 4($s2)  #arr[i+1] 
	
	slt $t0 , $t2, $t1  #if arr[i] > arr[i+1]
	beq $t0 , $0 , noSwap
	#swap arr[i] and arr[i+1]
	sw $t2, 0($s2)
	sw $t1, 4($s2)
noSwap:	
	addi $s2 , $s2, 4 #increment address
	addi $s1, $s1, 1 # i++
	j innerLoopSort
	
innerLoopEnd:
	addi $s0, $s0, -1 #last--
	j outerLoopSort
	
outerLoopEnd:

 	###################
 	# Done Sorting   #
 	##################
	
	
	
	
	#####################################################
	#     						#####
	#		Data Segment			#####
	#						#####
	#####################################################
	
		
	.data 
CountPrompt: .asciiz "Enter the number of Integers to be used: "
IntegerPrompt: .asciiz "Enter an Integer: "
