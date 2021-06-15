#
#	Integrantes:		Edgar Hernández Gutiérrez ie720967
#
.data
.eqv	direccion_inicial 0x1001  
.text
		#Datos inicial
		addi	$s0,$zero,8				#Tamaño de la torre de hanoi
		#Construcción de la torre de Hanoi
		#La dirección de las 3 torres de Hanoi como mi intención es hacerlo vertical se podria decir que desperdicio memoria pero es más visual
		addi	$t1,$zero,0				#dirección origen
		addi	$t2,$zero,0				#dirección auxiliar
		addi	$t3,$zero,0				#dirección destino
		
		lui	$t1,direccion_inicial
		lui	$t2,direccion_inicial
		lui	$t3,direccion_inicial
		 
		addi	$t2,$t2,4
		addi	$t3,$t3,8
		
		
		addi	$at,$zero,0x0020
		mul	$at,$s0,$at
		#Quiero que aparte de ser vertical, sea escalonada hacia arriba, por lo que la posición inicial tiene que ser la parte de la memoria más alta en memoria para esa "torre"
		#y la dirección ir restandolo de 20h a 20h para ir subiendo la torre de hanoi 
		add	$t1,$t1,$at				
		add	$t2,$t2,$at				
		add	$t3,$t3,$at				
		
		#Tamaño de las torres de Hanoi
		addi	$t4,$zero,0				#tamaño origen
		addi	$t5,$zero,0				#tamaño auxiliar
		addi	$t6,$zero,0				#tamaño destino
		
main:		#Empiezo a guardar mis aros (números) desde lo más alto de la memoria hasta lo más bajo para que quede vista de manera vertical ascendente
		add	$a0,$zero,$s0	
		addi	$a3,$zero,1				#Que torre queremos contruirla con n cantidad de discos
			#preparo la función apilar en t0 pongo el dato que quiero poner y lo voy comparando con el tamaño deseado
ciclo:		beq	$a0,$zero,ciclo_exit
		jal	apilar
		addi	$a0,$a0,-1
		j	ciclo
ciclo_exit:
		#Aqui voy configurando mi torre de Hanoi, en t4 = tamaño de torre 1, t1 = origen, t2 = auxiliar, t3 = destino
		add	$a0,$zero,$t4				#También tengo que agregar el tamaño de la torre que estoy utilizando
		addi	$a1,$zero,1				#Que torre es la de origen
		addi	$a2,$zero,2				#Que torre es la de auxiliar
		addi	$a3,$zero,3				#Que torre se la de destino
		jal 	Hanoi
								
		j exit
		
Hanoi:		#a0 = n, a1 = origen, a2 = auxiliar, a3 = destino
		#Guardo los datos necesarios
		addi 	$sp,$sp,-20
		sw	$a0,0($sp)
		sw	$a1,4($sp)
		sw	$a2,8($sp)
		sw	$a3,12($sp)
		sw	$ra,16($sp)
		#Si el tamaño es menor que 1 hay 2 opciones, que sea un error o sea del tamaño de 1 por lo que
		slti	$at,$a0,1		#at = t4<1 ? 1:0
		bne	$at,$zero,Hanoi_error
		
		addi	$at,$zero,1
		bne	$a0,$at,Hanoi_recursivo
		
		addi	$sp,$sp,-4				#como desapilar y apilar cambian el $ra necesito que guardarlo antes de hacer estas funciones y después cargarlo
		sw	$ra,4($sp)				
		jal	desapilar				#hice de manera estrategica que la entrada de desapilar sea t1 (origen de función Hanoi) y el dato se guardara en t0
		add	$a0,$0,$v0
		jal 	apilar					#lo que hace que t0 funcioné como entrada de apilar y t3 (destino de función hanoi) sea en que torre quiero que se guarde 
		lw	$ra,4($sp)				
		addi	$sp,$sp,4
		
		j	Hanoi_return	
		
Hanoi_recursivo:
		#Si llego aqui los cambia entre auxiliar y destino al momento de guardar
		lw	$a3,8($sp)
		lw	$a2,12($sp)
		#Bajo el contador de cuantos aros tiene nuestra torre de destino
		addi	$a0,$a0,-1
		jal	Hanoi
		#Aqui es necesario para no repetir acción 
		lw	$a0,0($sp)
		lw	$a1,4($sp)
		lw	$a2,8($sp)
		lw	$a3,12($sp)
		lw	$ra,16($sp)
		
		addi	$sp,$sp,-4				#como desapilar y apilar cambian el $ra necesito que guardarlo antes de hacer estas funciones y después cargarlo
		sw	$ra,0($sp)				
		jal	desapilar				#hice de manera estrategica que la entrada de desapilar sea t1 (origen de función Hanoi) y el dato se guardara en t0
		add	$a0,$0,$v0
		jal 	apilar					#lo que hace que t0 funcioné como entrada de apilar y t3 (destino de función hanoi) sea en que torre quiero que se guarde 
		lw	$ra,0($sp)				
		addi	$sp,$sp,4
		#Si llego aqui los cambia entre auxiliar y origen al momento de guardar
		lw	$a2,4($sp)
		lw	$a1,8($sp)
		lw	$a0,0($sp)
		#aqui tambi?n necesito que bajar el tama?o temporal de la torre origen
		addi	$a0,$a0,-1
		jal	Hanoi
		
		j	Hanoi_return
		 		
			
Hanoi_return:	lw	$a0,0($sp)
		lw	$a1,4($sp)
		lw	$a2,8($sp)
		lw	$a3,12($sp)
		lw	$ra,16($sp)
Hanoi_error:	addi 	$sp,$sp,20
		jr	$ra													
		
apilar:		#(a0 = input Dato, a3 = Torre de Hanoi  1, 2 ,3 )
		addi	$at,$zero,1
		bne	$a3,$at,case_2_a
		#Aqui si se escogio la torre 1, apilo en donde me apunta $s1(Dirección torre de hanoi 1) el dato $t0
		addi	$t1,$t1,-0x20				#Antes lo habia puesto después, pero para contar el 0 este addi lo puse antes de sw
		sw	$a0,0($t1)
		addi	$t4,$t4,1
		jr	$ra
		
case_2_a:	addi	$at,$zero,2
		bne	$a3,$at,case_3_a
		#Aqui si se escogio la torre 2, apilo en donde me apunta $s2(Dirección torre de hanoi 2) el dato $t0
		addi	$t2,$t2,-0x20
		sw	$a0,0($t2)
		addi	$t6,$t6,1
		jr	$ra
		
case_3_a:	#Podria poner un default, pero confio que no pondré mal esto en el futuro y apila donde apunta $s3(Dirección torre de Hanoi 3) el dato $t0
		addi	$t3,$t3,-0x20
		sw	$a0,0($t3)
		addi	$t6,$t6,1
		jr	$ra
		
desapilar:	#(v0 = Output dato, a1 = Torre de Hanoi  1, 2 ,3 )
		addi	$at,$zero,1
		bne	$a1,$at,case_2_d
		#Aqui si se escogio la torre 1, desapilo en donde me apunta $s1(Dirección torre de hanoi 1) y guardo el dato en $t0
		lw	$v0,0($t1)
		sw	$zero,0($t1)
		addi	$t1,$t1,0x0020
		addi	$t4,$t4,-1
		jr	$ra
		
case_2_d:	addi	$at,$zero,2
		bne	$a1,$at,case_3_d
		#Aqui si se escogio la torre 2, desapilo en donde me apunta $s2(Dirección torre de hanoi 2) y guardo el dato en $t0
		lw	$v0,0($t2)
		sw	$zero,0($t2)
		addi	$t2,$t2,0x0020
		addi	$t5,$t5,-1
		jr	$ra
		
case_3_d:	#Podria poner un default, pero confio que no pondré mal esto en el futuro y desapila donde apunta $s3(Dirección torre de Hanoi 3) y guarda el dato en $t0
		lw	$v0,0($t3)
		sw	$zero,0($t3)
		addi	$t3,$t3,0x0020
		addi	$t6,$t6,-1
		jr	$ra
		
exit:
		
