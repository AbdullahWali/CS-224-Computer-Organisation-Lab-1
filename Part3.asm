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

	#  Permanent:     $s6 = Heap memory address 	$s7 = N

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
	
outerLoopEnd: 	# Done Sorting   #


 	la $a0, SortingDone
 	li $v0, 4
 	syscall # print a message saying sorting is done
 	
 	############################################################
 	#User Choice will be stored in s0
 	############################################################
 UserPromptLoop:
 	la $a0, UserPrompt
 	li $v0, 4
 	syscall #Print User Prompt
 	li $v0, 5
 	syscall #Take user Input
 	move $s0, $v0
 	
 	beq $s0, $0, UserPromptLoopDone #exit loop if input is 0
 	
 	###########################################################
 	####	    	Long switch/case		 ##########	
 	###########################################################
 	
 	
 case1: #calculate Mean Value
 	addi $t0 , $0, 1 
 	bne $s0, $t0, case2
 	
 	addi $a0, $s6, 0 # set address in argument 1
 	addi $a1, $s7, 0 #set size in argument 2
 	jal meanValue
 	mtc1.d $v0, $f12 #put the result in f12 to print later
 	
 	la $a0, MeanValueIs
 	li $v0 , 4
 	syscall
 	li $v0, 3
 	syscall #Prints a message and the result
 	
 	j UserPromptLoop
	
case2:  #calculate Median
	addi $t0 , $0, 2 
 	bne $s0, $t0, case3
 	
 	addi $a0, $s6, 0 # set address in argument 1
 	addi $a1, $s7, 0 #set size in argument 2
	jal MedianValue
 	mtc1.d $v0, $f12 #put the result in f12 to print later
 	
 	la $a0, MedianValueIs
 	li $v0 , 4
 	syscall
 	li $v0, 3
 	syscall #Prints a message and the result
	
	j UserPromptLoop
	
case3:  #smallest value
	addi $t0 , $0, 3 
 	bne $s0, $t0, case4
 		
	la $a0, SmallestValueIs
 	li $v0 , 4
 	syscall
 	
 	lw $a0 , ($s6) #smallest value is first value in sorted array
 	li $v0, 1
 	syscall #Prints a message and the result
 	j UserPromptLoop
 	
 	
 case4: #largest Value
 	addi $t0 , $0, 4 
 	bne $s0, $t0, case5
 	
 	addi $a0, $s6, 0 # set address in argument 1
 	addi $a1, $s7, 0 #set size in argument 2
	jal LargestValue
	move $s1, $v0
	
	la $a0, LargestValueIs
 	li $v0 , 4
 	syscall
 	move $a0, $s1
 	li $v0, 1
 	syscall #Prints a message and the result
 	j UserPromptLoop

case5: #mean of {smallest, median, largest} 

 	addi $t0 , $0, 5 
 	bne $s0, $t0, case6
 	
 	
	# smallest in f20 , median in f22, largest in  f24,  3 in f26
 	lw $s1 , ($s6) #smallest value is first value in sorted array
 	mtc1 $s1, $f20 #store smallest in 20
	cvt.d.w $f20, $f20
 	
 	addi $a0, $s6, 0 # set address in argument 1
 	addi $a1, $s7, 0 #set size in argument 2
 	jal MedianValue
 	mtc1.d $v0 $f22 #store median in f22
 	
 	
 	addi $a0, $s6, 0 # set address in argument 1
 	addi $a1, $s7, 0 #set size in argument 2
 	jal LargestValue
 	mtc1 $v0, $f24 #store largest in f24
 	cvt.d.w $f24, $f24 #convert f24 to double precision
 	
 	addi $s1, $0, 3 
 	mtc1 $s1, $f26
 	cvt.d.w $f26, $f26 #store 3 in f26 in double precision format
 	add.d $f12 , $f20, $f22
 	add.d $f12 , $f12, $f24 #add 3 values
 	div.d $f12, $f12, $f26 #divide and store value in f12 
 	
 	la $a0, meanSML
 	li $v0, 4
 	syscall #print message
 	li $v0, 3
 	syscall #print value
 	
 	j UserPromptLoop
 	
 case6: #3rd value
 
 	addi $t0 , $0, 6 
 	bne $s0, $t0, case7 #check for case
 	
 	add $s1, $0, $0
 	
 	addi $t1, $0, 3  
 	slt $t0, $s7, $t1  #check if size >= 3
 	bne $t0, $0, ThirdValueDone
 	
 	addi $t0, $0, 2 #third value is at index 2
 	mul $t0, $t0, 4 #mul by 4 for bytes
 	add $t0, $t0, $s6 #get address
 	lw $s1, ($t0)
 ThirdValueDone:
 	
 	la $a0, ThirdValueIs
 	li $v0, 4
 	syscall #print message
 	move $a0, $s1
 	li $v0, 1
 	syscall #print value
 	j UserPromptLoop
 	
 case7: #second to last element
  	addi $t0 , $0, 7 
 	bne $s0, $t0, case8
 	
 	la $a0, secondToLast
 	li $v0, 4
 	syscall #print message
 	
 	addi $s1, $0, 0 #initialise result to 0
 	addi $t1, $0, 2  
 	slt $t0, $s7, $t1  #check if size >= 2
 	bne $t0, $0, SecondToLastDone
 	
 	addi $s1 , $s7, -2 #get index 
	mul $s1, $s1, 4
	add $s1, $s1, $s6 #get address of second to last element
 	lw $s1, ($s1)
 SecondToLastDone:
 	move $a0, $s1
 	li $v0, 1
	syscall #print the element
	j UserPromptLoop
	
	
case8: #number of negative elements
  	addi $t0 , $0, 8 
 	bne $s0, $t0, case9
 	
 	la $a0, numNeg
 	li $v0, 4
 	syscall #print message
 	
 	addi $s1 , $0, 0 #s1 holds number of negative elements: num
 	addi $t0 , $s6 , 0 #address
 	addi $t1, $0 , 0 #i 
 	#while arr[i] < 0 && i < size: num++
case8loop:
	lw $t2 ($t0)
	slt $t3, $t2, $0
	beq $t3 , $0, case8loopDone #exit loop when an element is not negative ( array is sorted)
	beq $t1 , $s7 , case8loopDone #exit loop when out of elements
	addi $s1, $s1, 1 #add 1 to num of negative numbers
	addi $t1, $t1, 1 #add 1 to i 
	addi $t0, $t0 , 4 #add 4 to address
	j case8loop 
case8loopDone:	
	move $a0 , $s1
	li $v0, 1
	syscall #print result
	j UserPromptLoop
	
case9: #Average of lower half, rounds down if number of elements is odd
  	addi $t0 , $0, 9 
 	bne $s0, $t0, case10
 	
 	la $a0, AverageLower
	li $v0, 4
	syscall #print message 
	
	sra $a1, $s7, 1  #divide size by 2
	move $a0, $s6 #copy address to a0
	jal meanValue #call meanValue with N/2
	mtc1.d $v0, $f12 #put the result in f12 to print 
	li $v0 , 3
	syscall #print result
	
 	j UserPromptLoop
 	

case10: #Average of upper half
	addi $t0 , $0, 10 
 	bne $s0, $t0, UserPromptLoop
	
 	la $a0, AverageUpper
	li $v0, 4
	syscall #print message 
	
	addi $s1, $0, 0 #hold sum in s1
	sra $t0 , $s7 , 1 #starting index is in t0 : N/2
	add $t1 , $0, $t0 #copy starting index
	sll $t1 , $t1, 2 #multiply by 4
	add $t1, $t1, $s6 #t1 holds starting address
case10Loop:
	slt $t3, $t0, $s7  
	beq $t3 , 0 , case10LoopDone
	
	lw $t3 ($t1)
	add $s1, $s1, $t3 #add to sum 
	
	addi $t1, $t1, 4 #increment address
	addi $t0, $t0, 1 #increment index
	j case10Loop
	
case10LoopDone:	
	mtc1 $s1, $f2
	cvt.d.w $f2, $f2 #move sum to f2 and convert to double
	
	sra $t0, $s7 , 1
	sub $t0 , $s7, $t0 #size of upper list : N - N/2
	mtc1 $t0 ,$f4 
	cvt.d.w $f4, $f4 #move to f4 and convert
	div.d $f12 , $f2, $f4 #divide and store value in f12
	li  $v0, 3
	syscall #print result
	j UserPromptLoop

UserPromptLoopDone:
	li $v0, 10
	syscall #Goodbye	
	
	
      #######################################################
       ####    		     Functions			####
	###						###
	 #################################################
	
	
meanValue: #Computes mean value in an array of ints
	   # $a0 holds address, $a1 holds size
	   # returns floating point value in v0-v1
	
	#if size is 0
	     bne $a1, $0, MeanValueNot0
	     li $v0, 0
	     jr $ra
	     
MeanValueNot0:

	addi $t2 , $0 , 0 # t2 will hold sum
	addi $t0 , $0 , 0 # i = 0 ( loop variable )
	meanValueLoop: slt $t1, $t0, $a1 #i < size
	beq $t1, $0 , meanValueLoopDone
	
	lw $t3, 0($a0) #load the number into t3 
	add $t2, $t2, $t3 #add the number to sum

	addi $a0, $a0, 4 #increment a0 by 4
	addi $t0 , $t0, 1 #increment i by 1
	j meanValueLoop

	meanValueLoopDone:
	mtc1 $t2, $f4
	cvt.d.w $f4, $f4 #convert f4 to double
	mtc1 $a1, $f6
	cvt.d.w $f6, $f6 #convert f6 to double
	div.d $f0, $f4, $f6
	mfc1 $v0, $f0
	mfc1 $v1, $f1
	jr $ra
		
########################################################
		
MedianValue: #computes median value in an array of ints
	     #$a0 holds address, $a1 holds size
	     #returns floating point value in v0-v1
	     
	     bne $a1, $0,MedianValueNot0
	     li $v0, 0
	     jr $ra
	     
MedianValueNot0:
	     addi $t0 , $0, 2
	     div  $a1, $t0 #divide N/2
	     mfhi $t1 #Get modulus into t0
	     
	     beq $t1, $0 , MedianValueEven
	     
	     #odd modulus case: get value of middle element
	     div $t1, $a1, $t0 #get index of mid element
	     mul $t1, $t1, 4 #multiply by 4 for bytes
	     add $t1, $t1, $a0 # $t1 = address of middle element
	     lw  $t1, ($t1) # t1 now holds the value in that address
	     mtc1 $t1,  $f2 #put result in the floating point processor and convert to floating point value
	     cvt.d.w $f0 , $f2
	     mfc1.d $v0, $f0
	     jr $ra
	     
	     
MedianValueEven: # even modulus: get value of the mean of the 2 middle elements 
	div $t1, $a1, $t0 #get index of mid element
	mul $t1, $t1, 4 #multiply by 4 for bytes
	add $t3, $t1, $a0 # $t3 = address of middle element
	lw  $t1, 0($t3) # t1 now holds the value in that address t3
	lw $t2, -4($t3) # t2 holds the second middle element
	
	add $t1, $t1, $t2 # add the elements together
	addi $t2, $0, 2
	
	#move to coprocessor and divide /2 
	mtc1 $t1, $f2
	mtc1 $t2, $f4
	cvt.d.w $f2, $f2  #convert to double
	cvt.d.w $f4, $f4 #covert to double
	div.d $f0, $f2, $f4
	mfc1.d $v0, $f0
	jr $ra
	

##########################################################

LargestValue: #returns the largest value, a0 contains array address, a1 contains size
	
	addi $t0 , $a1 , -1 #index of last element 
	mul $t0 , $t0 ,4 
	add $t0 , $t0, $a0
	
	lw $v0, ($t0)
	jr $ra 
##########################################################		
	
		
			
					
	#####################################################
	#     						#####
	#		Data Segment			#####
	#						#####
	#####################################################
	
		
	.data 
CountPrompt: .asciiz "Enter the number of Integers to be used: "
IntegerPrompt: .asciiz "Enter an Integer: "
SortingDone:	.asciiz "The Integers are now Sorted\n"
UserPrompt:	.asciiz "\nChoose an operation to perform: \n0.None of these\n1.Mean value\n2.Median value\n3.Smallest value\n4.Largest value\n5.Average of {smallest, median, largest} values\n6.third Value\n7.second to last value\n8.number of negative values\n9.average of lower half list\n10.average of upper half list\n---> "
MeanValueIs: .asciiz "Mean Value is: "
MedianValueIs: .asciiz "Median Value is: "
SmallestValueIs: .asciiz "Smallest Value is: "
LargestValueIs: .asciiz "Largest Value is: "
meanSML: 	.asciiz "Mean of {Smallest, Median, Largest} values is: "
ThirdValueIs:	.asciiz "Third value is: "
secondToLast:	.asciiz "Second to last element is: "
numNeg: 	.asciiz "Number of negative elements is: "
AverageLower: 	.asciiz "Average of lower half list is: " 
AverageUpper: 	.asciiz "Average of the upper half of the list is: "