.data
.eqv	direccion_inicial 0x1001  
.text
		
		addi	$s0,$zero,100				#Tama�o de la torre de hanoi
		#Construcci�n de la torre de Hanoi
		#La direcci�n de las 3 torres de Hanoi como mi intenci�n es hacerlo vertical se podria decir que desperdicio memoria pero es m�s visual e integro la memoria alineada 2 x 1
				
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
		#Quiero que aparte de ser vertical, sea escalonada hacia arriba, por lo que la posici�n inicial tiene que ser la parte de la memoria m�s alta para esa "torre"
		#y la direcci�n ir restandolo de 20h a 20h para ir subiendo la torre de hanoi 
		add	$s1,$s1,$t0				
		add	$s2,$s2,$t0				
		add	$s3,$s3,$t0				
		
		#Empiezo a guardar mis aros (n�meros)
		add	$t3,$zero,$s0
ciclo_1:	
		beq	$t3,$zero,termina_ciclo_1
		
		#preparo la funci�n apilar
		add	$t0,$zero,$t3
		addi	$t1,$zero,1	
		add	$t2,$zero,$s0
		jal	apilar
		addi	$t3,$t3,-1
		j	ciclo_1		
termina_ciclo_1:

		addi	$t0,$zero,1
		jal	desapilar
								
		j exit
		
		
		
apilar:		#(t0 = Dato, t1 = Torre de Hanoi  1, 2 ,3  t2 = cantidad)
		addi	$t2,$zero,1
		bne	$t1,$t2,case_2_a
		addi	$s1,$s1,-0x20				#Antes lo habia puesto despu�s, pero para contar el 0 este addi lo puse antes de sw
		sw	$t0,0($s1)
		jr	$ra
		
case_2_a:	addi	$t2,$zero,2
		bne	$t1,$t2,case_3_a
		addi	$s2,$s2,-0x20
		sw	$t0,0($s2)
		jr	$ra
		
case_3_a:	#Podria poner un default, pero confio que no pondr� mal esto en el futuro 
		addi	$s3,$s3,-0x20
		sw	$t0,0($s3)
		
		jr	$ra
		
desapilar:	#(t0 = Torre de Hanoi  1, 2 ,3  Borra t1, Y se guarda el dato en t0 lo cual ayudar� despu�s)
		addi	$t1,$zero,1
		bne	$t0,$t1,case_2_d
		lw	$t0,0($s1)
		sw	$zero,0($s1)
		addi	$s1,$s1,0x0020
		jr	$ra
		
case_2_d:	addi	$t1,$zero,2
		bne	$t0,$t1,case_3_d
		
		lw	$t0,0($s2)
		sw	$zero,0($s2)
		addi	$s2,$s2,0x0020
		jr	$ra
		
case_3_d:		#Podria poner un default, pero confio que no pondr� mal esto en el futuro 
		lw	$t0,0($s0)
		sw	$zero,0($s0)
		addi	$s3,$s3,0x0020
		jr	$ra
		
exit:
		
