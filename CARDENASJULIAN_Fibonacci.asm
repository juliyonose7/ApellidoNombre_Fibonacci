# Programa para generar serie Fibonacci y calcular su suma


.data
    # Mensajes para el usuario final
    msg_cantidad: .asciiz "Ingrese cuantos numeros de la serie Fibonacci desea generar: "
    msg_serie: .asciiz "La serie Fibonacci es: "
    msg_suma: .asciiz "\nLa suma de todos los numeros es: "
    msg_error: .asciiz "Error: Debe ingresar un numero mayor a 0\n"
    msg_error_limite: .asciiz "Error: No puede generar mas de 45 numeros para evitar exeder el limite por overflow\n"
    msg_salto: .asciiz "\n"
    msg_coma: .asciiz ", "
    
    # Variables
    cantidad: .word 0       # variable para almacenar la cantidad de numeros
    fibonacci: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # Array para almacenar la serie de maximo 10
    suma: .word 0           # variable para almacenar la suma
    contador: .word 0       # contador para el bucle

.text
.globl main

main:
    # Mostrar mensaje para pedir cantidad
    li $v0, 4
    la $a0, msg_cantidad                     #limitamos  el numero maximo a  45 ya que es el ultimo que cabe en 32 bits con signo por lo tanto es el limite logico que considero prudente para el script               
    syscall
    
    # Leer cantidad de numeros
    li $v0, 5
    syscall
    sw $v0, cantidad
    
    # Validar que el numero que ingreso el usuario final sea mayor a 0
    lw $t0, cantidad
    ble $t0, 0, error_cantidad
    
    # Validar que no supere el limite de 45 para evitar overflow
    bgt $t0, 45, error_limite
    
    # Inicializar variables
    li $t1, 0          # Contador
    la $t2, fibonacci  # Puntero al array
    li $t3, 0          # Primer numero de Fibonacci
    li $t4, 1          # Segundo numero de Fibonacci
    li $t5, 0          # Suma acumulada
    
    # Generar serie Fibonacci
    lw $t0, cantidad
    beq $t0, 1, solo_uno
    
generar_fibonacci:
    # Guardamos el primer numero 
    sw $t3, 0($t2)
    add $t5, $t5, $t3  # Sumar a la suma total
    addi $t2, $t2, 4   # Siguiente posicion
    addi $t1, $t1, 1   # Incrementar contador
    
    # Si solo se pide 1 numero, terminar
    lw $t0, cantidad
    beq $t1, $t0, mostrar_resultado
    
    # Guardar segundo numero (1)
    sw $t4, 0($t2)
    add $t5, $t5, $t4  # Sumar a la suma total
    addi $t2, $t2, 4   # Siguiente posicion
    addi $t1, $t1, 1   # Incrementar contador
    
    # Si solo se piden 2 numeros, terminar
    lw $t0, cantidad
    beq $t1, $t0, mostrar_resultado
    
    # Generar resto de la serie
bucle_fibonacci:
    # Calcular siguiente numero de Fibonacci
    add $t6, $t3, $t4  # t6 = t3 + t4 (numero anterior + numero actual)
    
    # Guardar en el array
    sw $t6, 0($t2)
    add $t5, $t5, $t6  # Sumamos a la suma total 
    
    # Actualizar numeros para siguiente iteracion
    move $t3, $t4       # t3 = t4 (numero anterior)
    move $t4, $t6       # t4 = t6 (numero actual)
    
    addi $t2, $t2, 4   # Siguiente posicion
    addi $t1, $t1, 1   # Incrementar contador
    
    # Verificar si ya se generaron todos los numeros
    lw $t0, cantidad
    blt $t1, $t0, bucle_fibonacci
    
    j mostrar_resultado

solo_uno:
    # Caso especial: solo un numero
    sw $t3, 0($t2)
    move $t5, $t3

mostrar_resultado:
    # Guardar suma total
    sw $t5, suma
    
    # Mostrar mensaje de la serie
    li $v0, 4
    la $a0, msg_serie
    syscall
    
    # Mostrar serie Fibonacci
    li $t1, 0          # Contador
    la $t2, fibonacci  # Puntero al array
    
mostrar_serie:
    # Mostrar numero
    li $v0, 1
    lw $a0, 0($t2)
    syscall
    
    addi $t1, $t1, 1   # Incrementar contador
    lw $t0, cantidad
    beq $t1, $t0, mostrar_suma  # Si es el ultimo, no mostramos la coma
    
    # Mostrar coma y espacio
    li $v0, 4
    la $a0, msg_coma
    syscall
    
    addi $t2, $t2, 4   # Siguiente posicion
    j mostrar_serie
    
mostrar_suma:
    # Mostrar mensaje de la suma
    li $v0, 4
    la $a0, msg_suma
    syscall
    
    # Mostrar suma total
    li $v0, 1
    lw $a0, suma
    syscall
    
    # Mostrar salto de linea
    li $v0, 4
    la $a0, msg_salto
    syscall
    
    # Salir del programa
    j salir
    
error_cantidad:
    # Mostrar mensaje de error si el usuario final no pone un numero valido
    li $v0, 4
    la $a0, msg_error
    syscall
    j salir
    
error_limite:
    # Mostrar mensaje de error si el usuario final supera el limite de 45
    li $v0, 4
    la $a0, msg_error_limite
    syscall
    
salir:
    # Salir del programa
    li $v0, 10
    syscall
