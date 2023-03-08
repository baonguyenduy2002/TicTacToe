.data
	introduce: .asciiz "Player 1 marks X \nPlayer 2 marks O.\nEnter the coordinates (0 0, 0 1, 0 2, 1 0, 1 1, 1 2, 2 0, 2 1, 2 2) to mark into your space in the grid. \nThis game is made by Nguyen Duy Bao_2052399\n"
	player1: .asciiz "Player 1 - Enter your coordinate:\n"
	player2: .asciiz "Player 2 - Enter your coordinate:\n"
	row: .asciiz "Row:"
	column: .asciiz "Column:"
	vertical: .asciiz "|"
	horizontal: .asciiz "-------\n"
	blanket: .asciiz " "
	godown: .asciiz "\n"
	X: .asciiz "X"
	O: .asciiz "O"
	win1: .asciiz "Player 1 wins!!!"
	win2: .asciiz "Player 2 wins!!!"
	totie: .asciiz "This match is a draw!!!"
	
	tick: .byte 9,9,9,9,9,9,9,9,9
	
.text
main:
	li $v0, 4
	li $s7, 0			#Count playloop
	li $s0, 0			
	la $a0, introduce		#Print the introduce
	syscall
	
	jal printboard			#Print the current board
	
	playloop:
		loopplayer1:
		li $v0, 4
		la $a0, player1		#Input player 1
		syscall
		li $s3, 1		#Set 1
		la $a0, row
		syscall
		li $v0, 5
		syscall
		move $s1, $v0
		
		li $v0, 4
		la $a0, column
		syscall
		li $v0, 5
		syscall
		move $s2, $v0
		jal checkinput1
		
		jal tickplayer
		jal printboard
		
		jal checkwin
		addi $s7, $s7, 1	#Count playloop++
	
		beq $s0, 1, player1win  #Print the result1
		beq $s7, 9, tie
		
		loopplayer2:
		li $v0, 4
		la $a0, player2		#Input player 2
		syscall
		li $s3, 2		#Set 2
		la $a0, row
		syscall
		li $v0, 5
		syscall
		move $s1, $v0
		
		li $v0, 4
		la $a0, column
		syscall
		li $v0, 5
		syscall
		move $s2, $v0
		jal checkinput2
		
		jal tickplayer
		jal printboard
		
		jal checkwin
		addi $s7, $s7, 1	#Count playloop++
		
		beq $s0, 2, player2win 	#Print the result2
	j playloop
	
player1win:
	li $v0, 4
	la $a0, win1
	syscall
	j end
	
player2win:
	li $v0, 4
	la $a0, win2
	syscall
	j end
	
tie:
	li $v0, 4
	la $a0, totie
	syscall
	j end
end:
	li $v0, 10
	syscall
	
printboard:
	la $t0, tick
	li $t1, 0

	li $v0, 4
	la $a0, horizontal
	syscall
	la $a0, vertical
	syscall
	
	loop1:
		lb $t2, ($t0)
		beq $t1, 9, doneprint
		beq $t2, 1, Xprint
		beq $t2, 2, Oprint
		beq $t2, 9, blankprint
		
	Xprint: li $v0, 4
		la $a0, X
		syscall
		j contprintboard
	Oprint: li $v0, 4
		la $a0, O
		syscall
		j contprintboard
	blankprint: 	li $v0, 4
			la $a0, blanket
			syscall
			j contprintboard
			
	contprintboard:
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		la $a0, vertical
		syscall
		
		bne $t1, 3, cont1
		la $a0, godown
		syscall
		la $a0, horizontal
		syscall
		la $a0, vertical
		syscall
		
		cont1:
		bne $t1, 6, cont2
		la $a0, godown
		syscall
		la $a0, horizontal
		syscall
		la $a0, vertical
		syscall
		cont2:
		
		j loop1
	
doneprint:
	li $v0, 4
	la $a0, godown
	syscall
	la $a0, horizontal
	syscall
	
	jr $ra
	
checkinput1:
	slt $t3, $s1, $0		#Check less than 0
	beq $t3, 1, loopplayer1
	slt $t3, $s2, $0
	beq $t3, 1, loopplayer1
	
	li $t3, 2			#Check more than 2
	slt $t3, $t3, $s1
	beq $t3, 1, loopplayer1
	li $t3, 2
	slt $t3, $t3, $s2
	beq $t3, 1, loopplayer1

	li $t3, 0			#Check coincident square
	add $t3, $t3, $s1
	add $t3, $t3, $s1
	add $t3, $t3, $s1
	add $t3, $t3, $s2
	
	lb $t6, tick($t3)
	beq $t6, 9, checkdone1
	j loopplayer1
	
	checkdone1:
	jr $ra
	
checkinput2:
	slt $t3, $s1, $0		#Check less than 0
	beq $t3, 1, loopplayer2
	slt $t3, $s2, $0
	beq $t3, 1, loopplayer2
	
	li $t3, 2			#Check more than 2
	slt $t3, $t3, $s1
	beq $t3, 1, loopplayer2
	li $t3, 2
	slt $t3, $t3, $s2
	beq $t3, 1, loopplayer2

	li $t3, 0			#Check coincident square
	add $t3, $t3, $s1
	add $t3, $t3, $s1
	add $t3, $t3, $s1
	add $t3, $t3, $s2
	
	lb $t6, tick($t3)
	beq $t6, 9, checkdone2
	j loopplayer2
	
	checkdone2:
	
	jr $ra
	
tickplayer:
	li $t0, 0
	add $t0, $t0, $s1
	add $t0, $t0, $s1
	add $t0, $t0, $s1
	add $t0, $t0, $s2
	
	sb $s3, tick($t0)
	
	jr $ra
	  
checkwin:
	beq $s1, 0, firstrow
	beq $s1, 1, secondrow
	beq $s1, 2, thirdrow
	firstrow:
		lb $t1, tick
		bne $t1, $s3, checkcolumn
		lb $t1, tick+1
		bne $t1, $s3, checkcolumn
		lb $t1, tick+2
		bne $t1, $s3, checkcolumn
		move $s0, $s3
		jr $ra
	secondrow:
		lb $t1, tick+3
		bne $t1, $s3, checkcolumn
		lb $t1, tick+4
		bne $t1, $s3, checkcolumn
		lb $t1, tick+5
		bne $t1, $s3, checkcolumn
		move $s0, $s3
		jr $ra
	thirdrow:
		lb $t1, tick+6
		bne $t1, $s3, checkcolumn
		lb $t1, tick+7
		bne $t1, $s3, checkcolumn
		lb $t1, tick+8
		bne $t1, $s3, checkcolumn
		move $s0, $s3
		jr $ra
		
	checkcolumn:
	beq $s2, 0, firstcolumn
	beq $s2, 1, secondcolumn
	beq $s2, 2, thirdcolumn
	
	firstcolumn:
		lb $t1, tick
		bne $t1, $s3, checkdiagonal
		lb $t1, tick+3
		bne $t1, $s3, checkdiagonal
		lb $t1, tick+6
		bne $t1, $s3, checkdiagonal
		move $s0, $s3
		jr $ra
	secondcolumn:
		lb $t1, tick+1
		bne $t1, $s3, checkdiagonal
		lb $t1, tick+4
		bne $t1, $s3, checkdiagonal
		lb $t1, tick+7
		bne $t1, $s3, checkdiagonal
		move $s0, $s3
		jr $ra
	thirdcolumn:
		lb $t1, tick+2
		bne $t1, $s3, checkdiagonal
		lb $t1, tick+5
		bne $t1, $s3, checkdiagonal
		lb $t1, tick+8
		bne $t1, $s3, checkdiagonal
		move $s0, $s3
		jr $ra
		
	checkdiagonal:
		lb $t1, tick+4
		bne $t1, $s3, takeback
		lb $t1, tick
		bne $t1, $s3, dia3
		lb $t1, tick+8
		bne $t1, $s3, dia3
		move $s0, $s3
		j takeback
		
		dia3:
		lb $t1, tick+2
		bne $t1, $s3, takeback
		lb $t1, tick+6
		bne $t1, $s3, takeback
		move $s0, $s3
		
		takeback:
		jr $ra
	    
	     
	      
	       
	         
	
