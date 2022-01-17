#Gabe Holmes 
.data 
	space: .asciiz " " #single space character 
	       .align 5
	dataPtr: .space 96 # space needed to store all of the names 
	
	dataNames: 
		  .asciiz "Joe",
		  .align 5,
		  .asciiz "Jenny",
		  .align 5,
		  .asciiz "Jill",
		  .align 5,
		  .asciiz "John",
		  .align 5,
		  .asciiz "Jeff",
		  .align 5,
		  .asciiz "Joyce",
		  .align 5,
		  .asciiz "Jerry",
		  .align 5,
		  .asciiz "Janice",
		  .align 5,	  
		  .asciiz "Jake",
		  .align 5,
		  .asciiz "Jonna",
		  .align 5,
		  .asciiz "Jack",
		  .align 5,
		  .asciiz "Jocelyn",
		  .align 5,
		  .asciiz "Jessie",
		  .align 5,	  
		  .asciiz "Jess",
		  .align 5,
		  .asciiz "Janet",
		  .align 5,
		  .asciiz "Jane",
		  .align 5,
		  		  
.text	
initData:
	li $t0, 0 #t0 is the loop counter, start at 0
	la $t1, dataNames #stores the first address of the list of names 
	la $t2, dataPtr #stores address if array[0]
	
initPtr:
	sw $t1, ($t2) #put the name from dataName at position t1 in array at position t2
	add $t2, $t2, 4 #move 4 bytes to the next index in array
	addi $t1, $t1, 32 #move to the next name in dataName
	add $t0, $t0, 1 #increase t0 by 1
	
	ble $t0, 16, initPtr #branch to initArray if we are not done initializing the array
	
	li $t0, 0 #restore the counter 
	la $t2, dataPtr #restore $t2 to have the the first address in array
initLoopData: #initialize the data for the nested for loop, t3 stores the first counter and t4 stores second 
	li $t3, 1 #first counter, i in the psudocode 
	li $t4, 0 #second counter, j in the psudocode 
	b loop #go to the loop 
getNames: #get the name at array[j] and array[j+1] and put them in $t1, $t2
	la $t0, dataPtr #address of array in t0 
	mul $t5, $t4, 4 #t5 stores the shift in array we need to get the word at index j
	add $t5, $t5, $t0 #store the address of dataPtr[j] in $t5
	add $t6, $t5, 4 #store the address of dataPtr[j+1] in $t6
	
	lw $t1, ($t5) #dereference t5, put the name in t1
	lw $t2, ($t6) #dereferencfe t6, put the name in t2
	
	jr $ra #return
loop:
	jal getNames # get the current and next names, put them in t1 and t2
	jal initCompare # if the string in t1 comes after t2 alphabetically, then set register t7 to 0 
	jal checkSwap
	
	addi $t4, $t4, -1 #decriment t4 
	
	bge $t4, 0, loop #call loop again if t4 is greater than or equal to 0
	
	add $t3, $t3, 1 #incriment t3
	move $t4, $t3	#set t4 to the value in t3
	addi $t4, $t4, -1 #decriment t4, the second loop counter should start one before the main
	ble $t3, 16, loop #call loop again while we still have more names to sort 
	
	li $v0, 4 #print string syscall
	li $t2, 0 #counter for running through the loop
	la $t0, dataPtr #t0 has the starting address to the array 
	jal printNames #print the names and exit 
checkSwap:
	beqz $t7, swap #if (t7==0) swap();
	jr $ra
swap:
	la $t0, dataPtr #start address of dataPtr in t0
	mul $t5, $t4, 4 #set t5 to the correct shift needed to get the string at dataPtr[j*4]
	add $t5, $t5, $t0 #set t5 to the address of dataPtr[j]
	add $t6, $t5, 4 #set t6 to the address of the next name, dataPtr[j+1]
	
	lw $t8, ($t5) #dereference t5, load in t8 (dataNames[j])
	lw $t9, ($t6) #dereference t6, load it in t9 (dataNames[j+1])
	sw $t8, ($t6) #store dataNames[j+1] in t8
	sw $t9, ($t5) #store dataNames[j] in t9
	
	jr $ra
initCompare: 
	la $t0, dataPtr #t0 starting address of the pointer array
	li $t6, 0 #used to loop through every character in the string
	li $t7, 1 #return value, switched to 0 if t1 comes after t2 alphabetically 
	b compare #go to actual compare function
compare:
	add $t5, $t1, $t6  #add the string to be compared to t5, t6 modifies the string if the two strings have the same starting letters 
	lb $s1, ($t5) # s1 is the character to be compared from the first string 
	add $t5, $t2, $t6 # second string to be compared, also can be modified by the counter t6 
	lb $s2, ($t5) #s2 is the character to be compared from the second string 
	bgt $s1, $s2, need_swap #if s1 is greater, go to need_swap
	blt $s1, $s2, correct_order #if s1 is smaller, go to correct_order because t7 remains at 1
	add $t6, $t6, 1 #incriment the counter 
	bnez $s1, compare#if s1 is not empty, there are more things to be comapred so go back 
	b correct_order#s1 is empty so we are done comparing, so swap needed 
need_swap:
	li $t7, 0 #set t7 to zero
	b correct_order #return 
correct_order:
	jr $ra #return 
printNames:
	lw $a0, ($t0) #print the name from dataPtr (after dereferencing)
	syscall #print 
	
	la $a0, space #print a space after each name 
	syscall #print
	
	add $t2, $t2, 1 #incriment the counter 
	add $t0, $t0, 4 #add 4 to the shift, moves to the next name in dataPtr
	ble $t2, 16, printNames #do this 16 times 
	li $v0, 10 #exit code 
	syscall #exit
	

	

	