.data
.eqv	direccion_inicial 0x1001  
.text
		
		addi	$s0,$zero,1				#Tamaño de la torre de hanoi
		#Construcción de la torre de Hanoi
		
		#La dirección de las 3 torres de Hanoi como mi intención es hacerlo vertical se podria decir que desperdicio memoria pero es más visual e integro la memoria alineada 2 x 1
		addi	$s1,$zero,0				#origen
		addi	$s2,$zero,0				#auxiliar
		addi	$s3,$zero,0				#destino
		
		lui	$s1,direccion_inicial
		lui	$s2,direccion_inicial
		lui	$s3,direccion_inicial
		 
		addi	$s2,$s2,4
		addi	$s3,$s3,8
		
		addi	$t0,$zero,0x0020
		mul	$t0,$s0,$t0
		#Quiero que aparte de ser vertical, sea escalonada hacia arriba, por lo que la posición inicial tiene que ser la parte de la memoria más alta para esa "torre"
		#y la dirección ir restandolo de 20h a 20h para ir subiendo la torre de hanoi 
		add	$s1,$s1,$t0				
		add	$s2,$s2,$t0				
		add	$s3,$s3,$t0				
		
		#Tamaño de las torres de Hanoi
		add	$a1,$zero,0	
		add	$a2,$zero,0
		add	$a3,$zero,0
		
main:		#Empiezo a guardar mis aros (números) desde lo más alto de la memoria hasta lo más bajo para que quede vista de manera vertical ascendente
		add	$t2,$zero,$s0
ciclo_1:	
		beq	$t2,$zero,termina_ciclo_1
		
		#preparo la función apilar
		add	$t0,$zero,$t2
		addi	$t3,$zero,1
		jal	apilar
		addi	$t2,$t2,-1
		j	ciclo_1		
termina_ciclo_1:
		add	$t0,$zero,$a1
		addi	$t1,$zero,1
		addi	$t2,$zero,2
		addi	$t3,$zero,3
		jal 	Hanoi
								
		j exit
		
Hanoi:		#t0 = n, t1 = origen, t2 = auxiliar, t3 = destino, borra t9
		addi	$t9,$zero,1
		bne	$t0,$t9,else
		#Si llega aqui ya empezo a apilar y desapilar
		addi	$sp,$sp,-4
		sw	$ra,4($sp)
		jal	desapilar
		jal 	apilar
		lw	$ra,4($sp)
		addi	$sp,$sp,4
		jr	$ra		
else:

		
				
						
								
										
														
		
apilar:		#(t0 = Dato, t3 = Torre de Hanoi  1, 2 ,3  t9 = borra)
		addi	$t9,$zero,1
		bne	$t3,$t9,case_2_a
		addi	$s1,$s1,-0x20				#Antes lo habia puesto después, pero para contar el 0 este addi lo puse antes de sw
		sw	$t0,0($s1)
		addi	$a1,$a1,1
		jr	$ra
		
case_2_a:	addi	$t9,$zero,2
		bne	$t3,$t9,case_3_a
		addi	$s2,$s2,-0x20
		sw	$t0,0($s2)
		addi	$a2,$a2,1
		jr	$ra
		
case_3_a:	#Podria poner un default, pero confio que no pondré mal esto en el futuro 
		addi	$s3,$s3,-0x20
		sw	$t0,0($s3)
		addi	$a3,$a3,1
		jr	$ra
		
desapilar:	#(t0 = dato de salida, t1 = Torre de Hanoi  1, 2 ,3  Borra t9)
		addi	$t9,$zero,1
		bne	$t1,$t9,case_2_d
		lw	$t0,0($s1)
		sw	$zero,0($s1)
		addi	$s1,$s1,0x0020
		addi	$a1,$a1,-1
		jr	$ra
		
case_2_d:	addi	$t9,$zero,2
		bne	$t1,$t9,case_3_d
		lw	$t0,0($s2)
		sw	$zero,0($s2)
		addi	$s2,$s2,0x0020
		addi	$a2,$a2,-1
		jr	$ra
		
case_3_d:	#Podria poner un default, pero confio que no pondré mal esto en el futuro 
		lw	$t0,0($s3)
		sw	$zero,0($s3)
		addi	$s3,$s3,0x0020
		addi	$a3,$a3,-1
		jr	$ra
		
exit:
		
