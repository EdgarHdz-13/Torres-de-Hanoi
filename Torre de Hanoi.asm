#
#	Integrantes:		Edgar Hernández Gutiérrez ie720967
#
.data
.eqv	direccion_inicial 0x1001  
.text
		#Datos inicial
		addi	$s0,$zero,4				#Tamaño de la torre de hanoi
		#Construcción de la torre de Hanoi
		#La dirección de las 3 torres de Hanoi como mi intención es hacerlo vertical se podria decir que desperdicio memoria pero es más visual e integro la memoria alineada 2 x 1
		addi	$s1,$zero,0				#dirección origen
		addi	$s2,$zero,0				#dirección auxiliar
		addi	$s3,$zero,0				#dirección destino
		
		lui	$s1,direccion_inicial
		lui	$s2,direccion_inicial
		lui	$s3,direccion_inicial
		 
		addi	$s2,$s2,4
		addi	$s3,$s3,8
		
		
		addi	$t0,$zero,0x0020
		mul	$t0,$s0,$t0
		#Quiero que aparte de ser vertical, sea escalonada hacia arriba, por lo que la posición inicial tiene que ser la parte de la memoria más alta en memoria para esa "torre"
		#y la dirección ir restandolo de 20h a 20h para ir subiendo la torre de hanoi 
		add	$s1,$s1,$t0				
		add	$s2,$s2,$t0				
		add	$s3,$s3,$t0				
		
		#Tamaño de las torres de Hanoi
		addi	$a1,$zero,0				#tamaño origen
		addi	$a2,$zero,0				#tamaño auxiliar
		addi	$a3,$zero,0				#tamaño destino
		
main:		#Empiezo a guardar mis aros (números) desde lo más alto de la memoria hasta lo más bajo para que quede vista de manera vertical ascendente
		add	$t0,$zero,$s0	
		addi	$t3,$zero,1				#Que torre queremos contruirla con n cantidad de discos
		
ciclo_1:	#preparo la función apilar en t0 pongo el dato que quiero poner y lo voy comparando con el tamaño deseado
		jal	apilar
		addi	$t0,$t0,-1
		bne	$t0,$zero,ciclo_1

		#Aqui voy configurando mi torre de Hanoi, en t4 = tamaño de torre 1, t1 = origen, t2 = auxiliar, t3 = destino
		add	$t4,$zero,$a1				#También tengo que agregar el tamaño de la torre que estoy utilizando
		addi	$t1,$zero,1				#Que torre es la de origen
		addi	$t2,$zero,2				#Que torre es la de auxiliar
		addi	$t3,$zero,3				#Que torre se la de destino
		jal 	Hanoi
								
		j exit
		
Hanoi:		#t4 = n, t1 = origen, t2 = auxiliar, t3 = destino, borra t9
		addi	$t9,$zero,1
		bne	$t4,$t9,else
		
		#Si llega aqui significa que ya llegue a que este t4 = 1 lo que va a hacer que empiece a apilar y desapilar torres  ahora aqui hay algo interesante y es que como se a donde 
		#se dirigen los datos, y esto va que antes de llegar aqui se debieron de haber cargado con anterioridad, normalmente hago que vaya de origen hacia destino pero esto no siempre
		#es así ya que van cambiando las entradas, pueden ser un cambio entre destino y auxiliar ó un cambio entre auxiliar y origen
		
		addi	$sp,$sp,-4				#como desapilar y apilar cambian el $ra necesito que guardarlo antes de hacer estas funciones y después cargarlo
		sw	$ra,4($sp)				
		jal	desapilar				#hice de manera estrategica que la entrada de desapilar sea t1 (origen de función Hanoi) y el dato se guardara en t0
		jal 	apilar					#lo que hace que t0 funcioné como entrada de apilar y t3 (destino de función hanoi) sea en que torre quiero que se guarde 
		lw	$ra,4($sp)				
		addi	$sp,$sp,4
		
		jr	$ra		
else:
		#Guardo todos los datos necesarios para hacer una recursión, estos son t4=Tamaño, t1=Origen, t2=auxiliar, t3=destino, ra = return address
		addi 	$sp,$sp,-20
		sw	$t4,4($sp)
		sw	$t1,8($sp)
		sw	$t2,12($sp)
		sw	$t3,16($sp)
		sw	$ra,20($sp)
		#Cambio el auxiliar y el destino para seguir el formato del codigo recursivo Hanoi(n-1,o,d,a) -> Hanoi(n-1,o,a,d) se podria decir que guardo el movimiento o -> d
		lw	$t3,12($sp)
		lw	$t2,16($sp)
		#Bajo el contador de cuantos aros tiene nuestra torre de destino
		addi	$t4,$t4,-1
		jal	Hanoi
		#Empiezo a cargar los datos tal cual están en nuestro stack guardados, los movimientos ya se hicieron previamente
		lw	$t4,4($sp)
		lw	$t1,8($sp)
		lw	$t2,12($sp)
		lw	$t3,16($sp)
		lw	$ra,20($sp)
		addi 	$sp,$sp,20
		#como ya habia hecho previamente guardo la dirección de $ra y desapilo la torre "origen" y la pongo en "destino"
		addi	$sp,$sp,-4
		sw	$ra,4($sp)
		jal	desapilar
		jal 	apilar
		lw	$ra,4($sp)
		addi	$sp,$sp,4
		#Guardo todos los datos necesarios para hacer una recursión, estos son t4=Tamaño, t1=Origen, t2=auxiliar, t3=destino, ra = return address
		addi 	$sp,$sp,-20
		sw	$t4,4($sp)
		sw	$t1,8($sp)
		sw	$t2,12($sp)
		sw	$t3,16($sp)
		sw	$ra,20($sp)
		#Ahora hago el cambio entre las entradas origen y destino, se puede decir que se guarda el movimiento de a -> d
		lw	$t2,8($sp)
		lw	$t1,12($sp)
		#aqui también necesito que bajar el tamaño temporal de la torre origen
		addi	$t4,$t4,-1
		jal	Hanoi
		#Vuelvo a cargar los datos tal cual están ya que en teoria después del $ra se continua donde se dejo la función Hanoi ya sea recursivo o hacia donde comenzo
		lw	$t4,4($sp)
		lw	$t1,8($sp)
		lw	$t2,12($sp)
		lw	$t3,16($sp)
		lw	$ra,20($sp)
		addi 	$sp,$sp,20
		
		jr	$ra
						
								
										
														
		
apilar:		#(t0 = input Dato, t3 = Torre de Hanoi  1, 2 ,3  t9 = borra)
		addi	$t9,$zero,1
		bne	$t3,$t9,case_2_a
		#Aqui si se escogio la torre 1, apilo en donde me apunta $s1(Dirección torre de hanoi 1) el dato $t0
		addi	$s1,$s1,-0x20				#Antes lo habia puesto después, pero para contar el 0 este addi lo puse antes de sw
		sw	$t0,0($s1)
		addi	$a1,$a1,1
		jr	$ra
		
case_2_a:	addi	$t9,$zero,2
		bne	$t3,$t9,case_3_a
		#Aqui si se escogio la torre 2, apilo en donde me apunta $s2(Dirección torre de hanoi 2) el dato $t0
		addi	$s2,$s2,-0x20
		sw	$t0,0($s2)
		addi	$a2,$a2,1
		jr	$ra
		
case_3_a:	#Podria poner un default, pero confio que no pondré mal esto en el futuro y apila donde apunta $s3(Dirección torre de Hanoi 3) el dato $t0
		addi	$s3,$s3,-0x20
		sw	$t0,0($s3)
		addi	$a3,$a3,1
		jr	$ra
		
desapilar:	#(t0 = Output dato, t1 = Torre de Hanoi  1, 2 ,3  Borra t9)
		addi	$t9,$zero,1
		bne	$t1,$t9,case_2_d
		#Aqui si se escogio la torre 1, desapilo en donde me apunta $s1(Dirección torre de hanoi 1) y guardo el dato en $t0
		lw	$t0,0($s1)
		sw	$zero,0($s1)
		addi	$s1,$s1,0x0020
		addi	$a1,$a1,-1
		jr	$ra
		
case_2_d:	addi	$t9,$zero,2
		bne	$t1,$t9,case_3_d
		#Aqui si se escogio la torre 2, desapilo en donde me apunta $s2(Dirección torre de hanoi 2) y guardo el dato en $t0
		lw	$t0,0($s2)
		sw	$zero,0($s2)
		addi	$s2,$s2,0x0020
		addi	$a2,$a2,-1
		jr	$ra
		
case_3_d:	#Podria poner un default, pero confio que no pondré mal esto en el futuro y desapila donde apunta $s3(Dirección torre de Hanoi 3) y guarda el dato en $t0
		lw	$t0,0($s3)
		sw	$zero,0($s3)
		addi	$s3,$s3,0x0020
		addi	$a3,$a3,-1
		jr	$ra
		
exit:
		
