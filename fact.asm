.data
	promptMessage: .asciiz "Positive Integer: "
	result1: .asciiz "The value of 'factorial("
	result2:.asciiz ")' is: "
	
.text
	#.globl main

	#main:
		#display the messsage
		li $v0, 4
		la $a0, promptMessage
		syscall
		
		li $v0, 5 #read in the user input
		syscall
		
		move $t2, $v0 #move the user input into t2
		
			
		jal fact #call the factorial function
		move $a1, $t1 #move the result from fact to a1
		
		#print result1
		li $v0, 4
		la $a0, result1
		syscall
		
		#print the inputed number 
		li $v0, 1
		la $a0, ($t2)
		syscall
		
		#print result2
		li $v0, 4
		la $a0, result2
		syscall
		
		#print the result of the factorial funciton 
		move $a0, $a1 #move the number returned by the fact function to a0
		li $v0, 1
		syscall
		
		#exit thr program
		li $v0, 10
  	 	syscall
		
	fact:
		#adjust the stack pointer and update return address
		addi $sp, $sp-4
       		sw $ra, ($sp)
       		
		move $t0, $v0  #put the input from the input variable into t0
		li $t1, 1 #Set t0 to 1 to start out, this will be multiplied by t0 every time so the first
			  #time it will be the user input * 1
		bnez $t0, next #jump to the recursive part 
		li $t1, 1
		jr $ra #return
	next:
		mul $t1, $t1, $t0 #multiply t0, which is what gets decrimented, by t1 which is the result so far
		addi $t0, $t0, -1 #decrease t0 by 1
		bgtz $t0, next #as long as t0 is greater than zero, call next again 
		lw $ra, ($sp) #adjust return address
    		jr $ra #return
		
		
