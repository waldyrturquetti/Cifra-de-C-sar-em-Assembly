.data
	VetorAscii: .asciiz "!"
	VetorNumerico1: .asciiz "0123456789"
	VetorNumerico2: .word 0,1,2,3,4,5,6,7,8,9
	frase: .space 1024
	fator: .space 10
	opcao: .space 3
	arquivo: .asciiz "TextoIN.txt"
	arquivo2: .asciiz "TextoOUT.txt"
	arquivoFator: .asciiz "TextoFator.txt"
	arquivoOpcao: .asciiz "TextoOpcao.txt"	
	frase2: .asciiz "Opcao Invalida"
	Aux1: .asciiz "\n"
	Aux2: .asciiz ". "
	Aux3: .asciiz"\0"
	msg1: .asciiz "\ndigite o fator da cifra:"
	msg2: .asciiz "\ndigite:\n1-Para Codificar.\n2-Para Dicifrar.\nDigte QUALQUE OUTRO NÚMERO para SAIR.\n"
	
.text
	j main
	
	#####################################################################################################
	VaistringParaInteiro:
	
		addi $t0,$0,10
		add $t3,$t1,$0
		addi $t2,$0,1
		la $s2,VetorNumerico1
		
		Volta:
		beq $t3,$0,sai
		mul $t2,$t2,$t0
		addi $t3,$t3,-1
		j Volta
		sai:
		addi $t1,$t1,-1
		
		jal TrazInteiro
		
		mul $s5,$t2,$s3
		add $s6,$s6,$s5
		
		addi $s1,$s1,1
		lb $t4,0($s1)
		bne $t4,$s7,VaistringParaInteiro
		
	j VoltastringParaInteiro
	##############################################################
		
		TrazInteiro:
			
			la $s2,VetorNumerico1
			lb $t4,0($s1)
			lb $t5,0($s2)
			add $s3,$0,$0
			
			VoltaLoop:
			beq $t4,$t5,SaiLoop
			addi $s3,$s3,1
			addi $s2,$s2,1
			lb $t5,0($s2)
			j VoltaLoop
			SaiLoop:
			
			la $s4,VetorNumerico2
			add $s3,$s3,$s3
			add $s3,$s3,$s3
			add $s4,$s4,$s3
			lb $s3,0($s4)
			
			jr $ra
	###################################################################################################
main:
	la $s0,VetorAscii  
	la $t8,Aux1
	lb $t6,0($t8)
	la $t8,Aux2
	lb $t9,1($t8)
	la $t8,Aux3
	lb $s7,0($t8)
	addi $t8,$0,126
	
	###############################################################################
	li $v0,13		#Abri o arquivo
	la $a0, arquivoFator
	la $a1,0		
	li $a2,0		#Para leitura
	syscall
	##################
	
	#######################
	move $a0, $v0
	la $a1, fator		#endereço onde esta a string do fator
	li $a2, 10		
	li $v0, 14
	syscall
	######################## 
	
	add $t1,$v0,$0		#quantidade de Caracteres que possui
	addi $t1,$t1,-1
	
	##########################
	li $v0,16		#fecha o arquivo
	syscall
	#################################################################################
	la $s1,fator
	add $s6,$0,$0
	j VaistringParaInteiro
	VoltastringParaInteiro:
	add $s2,$0,$s6
	ble $s2,$t8,pula
	rem $s2,$s2,$t8
	pula:
		
	###############################################################################
	li $v0,13		#Abri o arquivo
	la $a0, arquivo
	la $a1,0		
	li $a2,0		#Para leitura
	syscall
	##################
	
	#######################
	move $a0, $v0
	la $a1, frase		#endereço onde esta a string do fator
	li $a2, 1024		
	li $v0, 14
	syscall
	######################## 
	
	add $s6,$v0,$0		#quantidade de Caracteres que possui
	
	##########################
	li $v0,16		#fecha o arquivo
	syscall
	#################################################################################

	###############################################################################
	li $v0,13		#Abri o arquivo
	la $a0,arquivoOpcao
	la $a1,0		
	li $a2,0		#Para leitura
	syscall
	##################
	
	#######################
	move $a0, $v0
	la $a1, opcao		#endereço onde esta a string do fator
	li $a2, 3		
	li $v0, 14
	syscall
	######################## 
	
	##########################
	li $v0,16		#fecha o arquivo
	syscall
	#################################################################################
	
	###########################
	la $t0,opcao
	lb $t2,0($t0)
	la $t3,VetorNumerico1
	lb $t1,2($t3)
	beq $t2,$t1,decifrar
					#decide para Algoritmo vai a de Codificar ou a de Decifrar
	lb $t1,1($t3)				
	bne $t2,$t1,EscreveArquivo2
	###########################	
	
	la $s1,frase
	la $s0,VetorAscii
	#add $t0, $0, $s1
	lb $t1,0($s1)
	#addi $s6,$0,1
	###########################################################
	cifrar:
	
		jal Codificando
		
		#addi $s6,$s6,1
		addi $s1,$s1,1
		lb $t1,0($s1)
		bne $s7,$t1,cifrar
		
		#li $v0,4
		#la $a0,frase
		#syscall
	
		j EscreveArquivo
		
	#############################################################	
	Codificando: 
			
		addi $sp,$sp,-8
		sw $ra,0($sp)
		add $t2,$0,$s0
		lb $t3, 0($t2)
		sw $t2,4($sp)
		
		addi $t3,$t3,-1
		addi $t4, $0, 32
		volta: 
			beq $t1,$t9,sairTroca
			addi $t4,$t4,1
			addi $t3, $t3,1
			bne $t3, $t1, volta 
		 					#troca a letra da frase comum pela codificada
		add $t4,$t4,$s2
		ble $t4,$t8,pula1
		sub $t4,$t4,$t8
		lb $t3, 0($t2)
		add $t3,$t3,$t4
		addi $t3,$t3,-1
		sb $t3, 0($s1)
		addi $t4,$t4,33
		ble $t4,$t8,sairTroca
		addi $t3,$t3,-32
		sb $t3, 0($s1)
				
		#li $v0,11
		#move $a0,$t1	
		#syscall
		
		j sairTroca	
		
		pula1:
		add $t1,$t1,$s2
		sb $t1, 0($s1)
		
		#li $v0,11
		#move $a0,$t1	
		#syscall
					
		sairTroca:
			#addi $s7,$s7,-1
			lw $t2,4($sp)
			lw $ra,0($sp)
			addi $sp,$sp,8
		
			jr $ra
	#################################################################	
	
	decifrar:
	
	la $s1,frase
	la $s0,VetorAscii
	lb $t1,0($s1)
	decifrar1:
		
		jal Decifrando
		
		addi $s1,$s1,1
		lb $t1,0($s1)
		bne $s7,$t1,decifrar1
	
		#li $v0,4
		#la $a0,frase
		#syscall
					
		j EscreveArquivo
		
	#############################################################	
	Decifrando: 
		addi $sp,$sp,-8
		sw $ra,0($sp)
		add $t2,$0,$s0
		lb $t3, 0($t2)
		sw $t2,4($sp)
		
		addi $t3,$t3,-1
		addi $t4, $0, 32
		addi $t5, $0, 33
		addi $t7,$0,93
		volta2: 
			beq $t1,$t9,sairTroca2
			addi $t4,$t4,1
			addi $t3, $t3,1
			bne $t3, $t1, volta2 
		 					#troca a letra da frase codificada pela comum
		sub $t4,$t4,$s2	
				
		bge $t4,$t5,pula2		#if($t4 <= 33)
		sub $t4,$t5,$t4
		sub $t4,$t7,$t4			
		lb $t3, 0($s0)
		add $t3,$t3,$t4
		addi $t3,$t3,1
		sb $t3, 0($s1)		
		
		#li $v0,11
		#move $a0,$t1	
		#syscall
		
		j sairTroca2	
		
		pula2:
		sub $t1,$t1,$s2
		sb $t1, 0($s1)
		
		#li $v0,11
		#move $a0,$t1	
		#syscall
		
		
		sairTroca2:
			#addi $s7,$s7,-1
			lw $t2,4($sp)
			lw $ra,0($sp)
			addi $sp,$sp,8
			
			jr $ra
	##############################################################

	####################################################
	EscreveArquivo:
		li $v0, 13			
  		la $a0, arquivo2	
		li $a1, 1 				
		li $a2, 0			#Escreve no Arquivo
		syscall
  
  		addi $a0, $v0, 0		
	  	li $v0, 15       		
  		la $a1,frase  		
  		move $a2,$s6		
  		syscall            		
  		
  		##########################
		li $v0,16		#fecha o arquivo
		syscall
		
		j sair
	####################################################
	####################################################
	EscreveArquivo2:
		li $v0, 13			
  		la $a0, arquivo2	
		li $a1, 1 				
		li $a2, 0			#Escreve no Arquivo
		syscall
  
  		addi $a0, $v0, 0		
	  	li $v0, 15       		
  		la $a1,frase2 		
  		addi $a2,$0,14	
  		syscall            		
  		
  		##########################
		li $v0,16		#fecha o arquivo
		syscall
	
	####################################################
	
	
	sair:
		li $v0,10
		syscall
		
