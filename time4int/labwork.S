  # labwork.S
  # Written 2015 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1 2015-2016.
  # The macros PUSH and POP are in the public domain.

.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm

.data 
.align 2
.text
.global hexasc, delay, time2string, enable_interrupt
  # You can add your own code here
 
  	hexasc:				# 17 = 1 
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
	PUSH $ra			# sparar $ra för att hoppa tillbaka. 
				
	li	$t1,15000	# Delay-konstant för en millisekund, olika beroende på datonrs prestanda.
	
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
	
	POP $ra
	jr	$ra
	nop
	
time2string:
	PUSH $s1
	PUSH $s2
	PUSH $s3
	PUSH $s4
	PUSH $s5
	PUSH $s6
	
	move	$s6,$ra
	
	andi	$t1,$a1,0xf000		# mask 1111 0000 0000 0000
	andi	$t2,$a1,0x0f00		# mask 0000 1111 0000 0000 
	andi	$t3,$a1,0x00f0		# mask 0000 0000 1111 0000  
	andi	$s4,$a1,0x000f		# mask 0000 0000 0000 1111 
	
	srl	$s1,$t1,12		# move the mask 12 step 
	srl	$s2,$t2,8		
	srl	$s3,$t3,4
	
				
	move	$s5,$a0			# adressen ligger nu i s5
					
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
	
	# skriver TWO
	li 	$t5,2
	beq	$s4, $t5, TWO
	
	move	$a0,$s4
	jal 	hexasc
	nop
	sb	$v0,4($s5)

	li	$t5,0x00		# a null byte.förhindrar oönskad utskrift.
	sb	$t5,5($s5)
	j	SKIPTWO
TWO:					# skriver TWO ist 2
	li	$a0,29			# ascii för T minus 55
	jal 	hexasc
	nop
	sb	$v0,4($s5)
	
	li	$a0,32
	jal 	hexasc
	nop
	sb	$v0,5($s5)
	
	li	$a0,24
	jal 	hexasc
	nop
	sb	$v0,6($s5)
	
	li	$t5,0x00
	sb	$t5,7 ($s5)
SKIPTWO:
	move	$ra,$s6			# flyttar tillbaka den ursprungliga
					# Return address till $ra
	
	POP $s6
	POP $s5			# återställer pushen.
	POP $s4
	POP $s3
	POP $s2
	POP $s1
	
	jr	$ra			# hoppar dit där time2string blev kallad.
	nop

enable_interrupt:
	ei
	jr $ra
	nop
