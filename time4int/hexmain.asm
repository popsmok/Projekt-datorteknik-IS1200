  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.
  # Edited by Adam Rosell
	.text
main:
	li	$a0,15		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

hexasc:	
	andi	$a0,$a0,0xf	# maskar, endast 1 byten.
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
  # You can write your own code for hexasc here
  #

