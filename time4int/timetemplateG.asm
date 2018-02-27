  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.
  # Tillägg av Adam Rosell

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text, more text, lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,1000	# Antal millisekunder som delay ska vänta.
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
	
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
	
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
hexasc:				# Om 17 -> H 
	andi	$a0,$a0,0xf
	li	$t0,9
	ble	$a0,$t0,number	# Branchar om 9 eller mindre
	nop
	add	$v0,$a0,55
	j	done
	nop
number:
	add	$v0,$a0,48
done:
	jr	$ra
	nop
			# the delay function
delay:
	PUSH($ra)			# sparar $ra för att hoppa tillbaka. 
				
	li	$t1,150	# Delay-konstant för en millisekund, olika beroende på datonrs prestanda.
	
	li	$t2, 0
delayLoop1:	
	addi	$t2,$t2,1
	
	li	$t3,0
delayLoop2:
	addi	$t3,$t3,1
	ble	$t3,$t1,delayLoop2	# Kolla om loop2 ska fortsätta
	nop

	ble	$t2,$a0,delayLoop1	# Kolla om loop1 ska fortsätta
	nop
	
	POP($ra)
	jr	$ra
	nop
	
time2string:
	PUSH($s1)
	PUSH($s2)
	PUSH($s3)
	PUSH($s4)
	PUSH($s5)
	PUSH($s6)
	
	move	$s6,$ra
	
	andi	$t1,$a1,0xf000		# mask 1111 0000 0000 0000
	andi	$t2,$a1,0x0f00		# mask 0000 1111 0000 0000 
	andi	$t3,$a1,0x00f0		# mask 0000 0000 1111 0000  
	andi	$s4,$a1,0x000f		# mask 0000 0000 0000 1111 
	
	srl	$s1,$t1,12		# move the mask 12 step 
	srl	$s2,$t2,8		
	srl	$s3,$t3,4
	
				
	move	$s5,$a0			# adressen ligger nu i ts5
					
	move	$a0,$s1
	jal 	hexasc			# gör om s1 till korrekt ascii kod.
	nop
	sb	$v0,0($s5)		# sparar vid t8 adressen
	
	move	$a0,$s2		
	jal 	hexasc
	nop
	sb	$v0,1($s5)		# sparar vid t8 adfressen, med förskjutning
	
	li	$t5,0x3A		# Lägger in ett : i $t5
	sb 	$t5,2($s5)		# sparar : i byte 2.

	move	$a0,$s3
	jal 	hexasc
	nop
	sb	$v0,3($s5)
	
	move	$a0,$s4
	jal 	hexasc
	nop
	sb	$v0,4($s5)
	
	li	$t5,0x00		# a null byte.för hindrar oönskad utskrift.
	sb	$t5,5($s5)
	
	move	$ra,$s6			# flyttar tillbaka den ursprungliga
					# Return address till $ra
	
	POP($s6)
	POP($s5)			# återställer pushen.
	POP($s4)
	POP($s3)
	POP($s2)
	POP($s1)
	
	jr	$ra			# hoppar dit där time2string blev kallad.
	nop
	
	
	
