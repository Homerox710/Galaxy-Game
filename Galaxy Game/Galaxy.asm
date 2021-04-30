Macro SetPos X,Y   ;Macro para posicionar el cursor
    
    Mov Ah,02h                 
    Mov Dl,X  ;se agrega a dl la posicion en X
    Mov Dh,Y  ;se agrega a dh la posicion en Y
    int 10h
endm

Macro Score    ;Macro para imprimir el puntaje

SetPos 39,1
     
mov al,Puntaje 

    aam
    mov uni,al
    mov al,ah
    aam
    mov cen,ah
    
    mov dece,al
    
    mov ah,02h
    
    mov dl,cen
    add dl,30h ; se suma 30h a dl para imprimir el numero real.
    int 21h
    
    mov dl,dece
    add dl,30h
    int 21h
    
    mov dl,uni
    add dl,30h
    int 21h
    
endm
   
   
Macro MoverDerecha
    
     Setpos NaveX,21         

     mov ah, 09h 
     mov al,OFFSET[Vacio] ;Permite que el caracter se mueva sin copiarlo seguidamente
     mov bl,07h
     mov cx,0001b
     int 10h
     
     
     add NaveX,1  ;suma una posicion en X
     
     cmp NaveX,79  ;compara si la nave llego al final y pone NaveX en 0
     je Pos0Nave
     
     mov color,1110b;amarillo
     mov ah,02h
     mov dh,21 ;fila
     mov dl,NaveX;columna
     mov bx,00h
     int 10h  
     
     mov bl,color
     mov ah,09h        ;copia la nave en la nueva posicion
     mov cx,1
     
     mov al,offset[Nave]
     int 10h
     
     endm

Macro MoverIzq
    
              
     Setpos NaveX,21
       
 
     mov ah, 09h 
     mov al,OFFSET[Vacio] ;Permite que el caracter se mueva sin copiarlo seguidamente
     mov bl,07h
     mov cx,0001b
     int 10h
     
     
     sub NaveX,1 ;resta una posicion en X
     
     cmp NaveX,0    ;compara si la nave llego a la posicion 0 y pone NaveX en 79 
     je PosFinNave
   
     
     mov color,1110b;amarillo
     mov ah,02h
     mov dh,21 ;fila
     mov dl,NaveX;columna
     mov bx,00h
     int 10h  
     
     mov bl,color
     mov ah,09h       ;copia la nave en la nueva posicion
     mov cx,1
     
     mov al,offset[Nave]
     int 10h
     jmp juego
     
     endm

.model small
.stack
.data                                          
 
   Instrucciones dw '  ',0ah,0dh
dw ' ',0ah,0dh                   ;variable para imprimir las instrucciones iniciales del juego
dw ' ',0ah,0dh
dw '           ====================================================',0ah,0dh
dw '          ||                                                  ||',0ah,0dh                                        
dw '          ||        Instituto Tecnologico de Costa Rica       ||',0ah,0dh
dw '          ||                                                  ||',0ah,0dh
dw '          ||        Ingenieria En Computacion                 ||',0ah,0dh
dw '          ||                                                  ||',0ah,0dh
dw '          ||        Proyecto Ensamblador 8086                 ||',0ah,0dh
dw '          ||                                                  ||',0ah,0dh          
dw '          ||        Elias Mena Segura                         ||',0ah,0dh
dw '          ||                                                  ||',0ah,0dh  
dw '          ||        Sede San Carlos                           ||',0ah,0dh 
dw '          ||                                                  ||',0ah,0dh 
dw '          ||        2018                                      ||',0ah,0dh 
dw '          ||                                                  ||',0ah,0dh 
dw '          ||        Introduzca su nickname                    ||',0ah,0dh
dw '           ====================================================',0ah,0dh
dw '$',0ah,0dh
 
 
   Game_over dw '  ',0ah,0dh
dw '        ================',0ah,0dh
dw '       ||              ||',0ah,0dh                                        
dw '       ||   GAMEOVER   ||',0ah,0dh
dw '       ||              ||',0ah,0dh
dw '        ================',0ah,0dh  
dw '$',0ah,0dh

   You_Win dw '  ',0ah,0dh
dw '        ================',0ah,0dh
dw '       ||              ||',0ah,0dh                                        
dw '       ||   You Win   ||',0ah,0dh
dw '       ||              ||',0ah,0dh
dw '        ================',0ah,0dh  
dw '$',0ah,0dh

   Try_Again dw '  ',0ah,0dh
dw '        ================',0ah,0dh
dw '       ||              ||',0ah,0dh                                        
dw '       ||  Try Again   ||',0ah,0dh
dw '       ||              ||',0ah,0dh
dw '        ================',0ah,0dh 
dw '$',0ah,0dh
                   
Line dw "--$"
Enemigo db "¾$"
Aliado db "Ñ$"
Reset db "(R to reset)$"
Vidas dw "$"
Quit db "(Q to Quit)$"                     
Nave dw "ß$"  
Vacio db " $"
Disparo dw "ø$" 
Puntaje db 000
Color db 1111b      
Nickname db 10 dup(" "),"$"
NaveX db 40 
Cen db 0
Dece db 0
Uni db 0
DispY db 20
Limite db 0
ContVIdas db 74
conta_enemigos db 0 
conta_aliados db 0
ejeX           db 0 
ejeY           db 04  
numAliados db 1
numEnemigos db 5
cont db 0
.code          

     mov ax, @data
     mov ds,ax
     
            ;Inicia el modo grafico.
     mov ah,00h
     mov al,03h
     int 10h
     mov cx,1
     mov si,0
;_________________________________________________________________________________________________     
Leer:

     Setpos 00,01     ;Impresion de las instrucciones.   
     mov ah, 09h
     mov dx, offset [Instrucciones]
     int 21h     
     
     lea dx,Nickname
     mov ah,0ah   ;espera a qye introduzca su nickname
     int 21h
     
                              
     
     mov ah,00h
     mov al,03h ;Obtencion de la posicion del cursor.
     int 10h     ;limpia pantalla                                            
     
     mov ax,00h 
;_________________________________________________________________________________________________     

ImprimirNickname:
     
     Setpos 04,01  ;posicion
                   ;imprime el nickname
     mov ah,09h
     mov dx,offset[nickname+2]
     int 21h

;_________________________________________________________________________________________________     
ImprimirVidas: ; Etiqueta encargada de imprimir las vidas.
     
     mov color,0100b;rojo
     Setpos 74,01 ;posicion 
     
     mov bl,color
     mov ah,09h
     mov cx,5   ;veces que se imprime
     mov al,offset[vidas]
     int 10h
     
;_________________________________________________________________________________________________     
ImprimirNave:  
     
     mov color,1110b;amarillo
     Setpos 40,21
     
     mov bl,color
     mov ah,09h
     mov cx,1
     
     mov al,offset[Nave]
     int 10h  

;_________________________________________________________________________________________________  
Score
;_________________________________________________________________________________________________  
     
     Setpos 0,2
     mov cx,80
     
ImpresionLinea: ; Etiqueta encargada de generar parametro de pantalla de juego.      
     
     mov ah,09h
     mov dx, offset [Line] 
     int 21h
     
     sub cx,1
     add dl,1
     loop ImpresionLinea
     
     
     Setpos 0,22
     mov cx,80

Linea2:
     mov ah,09h
     mov dx, offset [Line] 
     int 21h
     
     sub cx,1
     add dl,1
     loop Linea2
     
     Setpos 0,23     
     mov cx,80



;_________________________________________________________________________________

ImprimirReset: ; Etiqueta encargada de imprimir informacion de reset.
     
     Setpos 9,23
    
     mov ah, 09h
     mov dx, offset [Reset]
     int 21h
     

;________________________________________________________________________________________________________     
   
   
ImprimirQuit: ;Etiqueta encargada de imprimir informacion de quitar.
     
     Setpos 60,23
     
     mov ah, 09h
     mov dx, offset [Quit]
     int 21h 
;________________________________________________________________________________________________________     
     
     
ImprimirEnemigos_Random:
     Mov ejeX,00       
     Mov ah,2ch    ;;busca un numero random entre 1 y 99
     int 21h
     mov ejeX,dl 
          
     cmp ejeX,79   ;verifica que  el numero no sea mayor a 79
        JG ImprimirEnemigos_Random  ;si es mayor vuelve a llamar el random
        jl ImprimirEnemigos   ;si es menor  
 
ImprimirEnemigos:
       
     cmp ejex,"¾"  ;verifica si en esa posicion ya hay un enemigo
     je  ImprimirEnemigos_Random ;si ya hay un enemigo salta al random
     add conta_enemigos,1        ; si no, lo imprime
     
    Setpos ejeX,ejeY
     mov ah, 09h
     mov al, "¾"
     mov bl,1111b
     mov cx,1
     int 10h
     mov bl,numEnemigos 
     cmp conta_enemigos,bl 
        jl ImprimirEnemigos_Random
        Je ImprimirAliados_Random  
        


;________________________________________________________________________________________________________     
ImprimirAliados_Random: 
     Mov ejeX,00     ;ejex=0  
     Mov ah,2ch      ;busca un numero random entre 1 y 99
     int 21h
     mov ejeX,dl     
                      
     cmp ejex,79     ;verifica que  el numero no sea mayor a 79
        jg  ImprimirAliados_Random  ;si es mayor vuelve a llamar el random
        jl ImprimirAliados          ; si no, lo imprime
        
ImprimirAliados:

     cmp ejex,"¾"  ;verifica si en esa posicion ya hay un enemigo
     je  ImprimirAliados_Random  ;si ya hay un enemigo salta al random
 
     cmp ejex,"Ñ"  ;verifica si en esa posicion ya hay un aliado
     je  ImprimirAliados_Random ;si ya hay un aliado salta al random
                                                     

     mov color,08h
     add conta_aliados,1
     Setpos ejeX,ejeY 
     mov ah, 09h 
    
     mov bl,color
     mov cx,1
      mov al,"Ñ"
     int 10h
     mov bl,numAliados
     cmp conta_aliados,bl
        jl ImprimirAliados_Random
        
    
    add ejeY,1
    add numAliados,2
    add numEnemigos,10
    cmp ejeY,7
    jne ImprimirEnemigos_Random
;__________________________________________________________________________________________________________________________-

 
Juego:     ;ciclo principal del juego

              
     Setpos NaveX,21  ;toma la posicion de la nave
     
     mov ax,0003h ; Funcion para solicitar infomacion del mouse.
    int 33h

    cmp bx,1 ; Comparacion de Click izquierdo activo.
    je Disparar ; si es igual salta a la etiqueta disparar
    

     
     mov  ah,00h ;Lee el caracter 
     int  16h  ; Interrupcion para obtener el signo de teclado en buffer.  
     
     cmp al,"R" ;Comparacion de entrada de teclado con "R" para generar reset del juego. 
     je Resetear
     
     cmp al,"r" ;Comparacion de entrada de teclado con "r" para generar reset del juego. 
     je Resetear  
    
     cmp al," " ; Comparacion de entrada de teclado con espacio para generar el disparo
    je Disparar
     
     
     cmp al,"Q" ; Comparacion de entrada de teclado con "Q" para generar salidaa del juego.
     je Salir 
    
     cmp al,"q" ; Comparacion de entrada de teclado con "q" para generar salidaa del juego.
     je Salir
     
     cmp  ah,77  ;compara si se presiono la direccional derecha
     je Derecha
     
     cmp  ah,75  ;compara si se presiono la direccional Izquierda
     je Izq 
     
     jmp sonido

       

;________________________________________________________________________________________________________
   
Disparar:
     
     Setpos NaveX,DispY
     mov color,0100b ;asigna color rojo
 
     
     mov bl,color
     mov ah,09h
     mov cx,1
     mov al,offset[Disparo]
     int 10h 
     
     mov ah, 09h 
     mov al,OFFSET[Vacio] ;Permite que el caracter se mueva sin copiarlo seguidamente
     mov bl,07h
     mov cx,0001b
     int 10h
     
     sub DispY,1 ;resta una posicion en "Y" 
     
     mov bl,color  ;asigna de nuevo el color
     Setpos NaveX,DispY  ;toma la nueva posicion del disparo
     
     mov ah, 08h ;lee el caracter que hay en esa posicion
     int 10h
     cmp ah,1111b ;Si es un enemigo salta a sumar puntos
     je SumarPuntos
    
     cmp al,"Ñ"  ;Si es un aliado salta a restar puntos
     je RestarPuntos
       
     cmp DispY,3   ;Compara la posicion de "Y" del disparo con 3 que es el limite
     jg Disparar  ;si no es igual salta de nuevo a disparar
     
     
     mov bl,color    
     mov ah,09h
     mov cx,1
     mov al,offset[Disparo]
     int 10h 
                              ;cuando DispY es 3 vuelve a copiar 
                              ;el disparo una vez mas, luego lo vuelve a 
                              ;borrar y brinca de nuevo a juego
     mov ah, 09h 
     mov al,OFFSET[Vacio]
     mov bl,07h
     mov cx,0001b
     int 10h
     mov DispY,20 
     
     
     jmp juego                                                                                                       
;________________________________________________________________________________________________________

Izq:         ;Etiqueta encargada de mover la nave hacia la izquierda

   MoverIzq
   jmp juego ;Salta a juego
;________________________________________________________________________________________________________
 
 Derecha:  ;Etiqueta encargada de mover la nave hacia la derecha
    
   Moverderecha 
   jmp juego ;Salta a juego
;________________________________________________________________________________________________________     
 
 RestarPuntos:   ;Etiqueta encargada de restar puntos en caso de que se haya golpeado un aliado
     
     cmp puntaje,10
     jle gameover
     sub DispY,1
     sub puntaje,20 ;se resta 20 al puntaje
     score     ;llama al macro score
                                            
     setpos contVidas,01 
     
     mov ah, 09h 
     mov al,OFFSET[Vacio] 
     mov bl,07h            ;posiciona el cursor en las vidas y elimina una
     mov cx,0001b
     int 10h
     add contVidas,1
     cmp contVidas,79  ;Comprueba si ya no hay vidas 
     je GAMEOVER       ;si no hay salta a GAMEOVER
     jmp Disparar
;________________________________________________________________________________________________________     
SumarPuntos:   ;Etiqueta encargada de sumar puntos en caso de que se haya golpeado un enemigo
   
    sub conta_enemigos,1
    add puntaje,10   ;Suma 10 al 
    score 
    cmp conta_enemigos,0
    je  comparaciones_finales
    jne disparar
;________________________________________________________________________________________________________     
 comparaciones_finales:
 cmp puntaje,150
  jge YouWIN  
  jl  TryAgain
;________________________________________________________________________________________________________     
GAMEOVER:

     mov ah,00h
     mov al,03h ;Obtencion de la posicion del cursor.
     int 10h 
     
     Setpos 40,15     ;Impresion de las instrucciones.   
     mov ah, 09h
     mov dx, offset [Game_over]
     int 21h     
     
     mov ah,0ah
     int 21h
     jmp salir
     
;________________________________________________________________________________________________________     
YouWin:

     mov ah,00h
     mov al,03h ;Obtencion de la posicion del cursor.
     int 10h 
     
     Setpos 40,15     ;Impresion de las instrucciones.   
     mov ah, 09h
     mov dx, offset [You_Win]
     int 21h     
     
     mov ah,0ah
     int 21h 
;________________________________________________________________________________________________________     
TryAgain:

     mov ah,00h
     mov al,03h ;Obtencion de la posicion del cursor.
     int 10h 
     
     Setpos 40,15     ;Impresion de las instrucciones.   
     mov ah, 09h
     mov dx, offset [Try_Again]
     int 21h     
     
     mov ah,0ah
     int 21h
     jmp resetear
;________________________________________________________________________________________________________     
 Sonido:  ; Etiqueta de sonido al ingresar tecla que no corresponda al programa.
    mov ah,2
    mov dl,07h
    int 21h
    jmp juego
;________________________________________________________________________________________________________     
   
Resetear:        ;Reset del juego

    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor cx, cx

    
    mov NaveX, 40 
    mov Cen, 0
    mov Dece, 0
    mov Uni, 0
    mov DispY, 20
    mov Limite, 0           ;Pone su valor inicial las variables 
    mov ContVIdas, 74
    mov conta_enemigos, 0 
    mov conta_aliados, 0
    mov ejeX, 0 
    mov ejeY, 04  
    mov numAliados, 1
    mov numEnemigos, 5
    mov cont, 0
    mov Puntaje, 000
    mov Color, 1111b
    jmp

;________________________________________________________________________________________________________________


Pos0Nave:
   
   mov NaveX,0
   jmp Derecha

;________________________________________________________________________________________________________________

PosFinNave:

   mov NaveX,79
   jmp Izq
;________________________________________________________________________________________________________________

 Salir: 
    int 20h ; Finaliza el programa
.exit



;___________________________________________________________________________________________________________________
    
