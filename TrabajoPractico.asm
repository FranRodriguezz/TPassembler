global main
;Errores:
;Al imprimir el operando inicial aparecen caracteres raros al final
;Imprime una vez extra el operando y operacion del registro.
extern printf
extern gets
extern fopen 
extern fread
extern fclose
extern fgets
extern sscanf
extern strtol
extern itoa


section .data

msjInicial          db  "Ingrese el operando inicial: ",0
msjIngresarArchivo  db "Ingrese el nombre del archivo: ",0
msjErrorArchivo     db "Error al abrir el archivo, intente nuevamente",0
modo                db "r",0
msjOpInicial        db "Operando inicial: %s ",10,0
msjOperacion        db "La operacion es: %s ",10,0
msjRegistro         db "El operando del registro es: %s ",10,0 
msjResParcial       db "Resultado parcial: %s ",10,0
numFormat           db "%lli",0
caracter            db "\0",0



section .bss

opInicial               resq 2
opInicialTransformado   resq 2
nombreArchivo           resb 30
idArchivo               resq 1
registroOperando        resb 20
opRegistroTransformado  resb 20
registroOperacion       resb 5
resParcial              resb 20
resParcialTransformado  resb 20
opRegistroBinario       resb 20


section .text

;***************************************************  MAIN  ******************************************************
;*******************************************************************************************************************
main:

    call pedirDato
    call imprimirInicial

abrirArchivo:
    call pedirNombreArchivo
    call leerArchivo

trabajarRegistros:
    call leerOperando

finPrograma:
ret




;***************************************************  ARCHIVO   ******************************************************
;*******************************************************************************************************************
pedirNombreArchivo: 
    mov rcx,msjIngresarArchivo
    sub rsp,28h
    call printf
    add rsp,28h

    mov rcx,nombreArchivo
    sub rsp,28h
    call gets
    add rsp,28h

ret

leerArchivo: 
    mov rcx,nombreArchivo
    mov rdx,modo
    sub rsp,28h
    call fopen
    add rsp,28h

    cmp rax,0
    jle errorOpen 
    mov [idArchivo],rax 

ret

leerOperando: 

    mov rcx,registroOperando
    mov rdx,17 
    mov r8,[idArchivo]
    sub rsp,28h
    call fgets
    add rsp,28h
    

    cmp rax,0   
    jle finalArchivo ;Se verifica aca el final del archivo pq no va a coincidir al leer la operacion
    call transformarOperandoRegistro
    call imprimirRegistroOperando
    call leerOperacion


transformarOperandoRegistro: 

    mov rcx,registroOperando
    mov rdx,caracter
    mov r8,2
    sub rsp,28h
    call strtol
    add rsp,28h
    mov [opRegistroTransformado],rax

ret

leerOperacion: 

    mov rcx,registroOperacion
    mov rdx,2 
    mov r8,[idArchivo]
    sub rsp,28h
    call fgets
    add rsp,28h

    
    call imprimirRegistroOperacion
    call resultadoParcial
    call leerOperando

finalArchivo: 

    mov rcx,[idArchivo]
    sub rsp,28h
    call fclose
    add rsp,28h
    jmp finPrograma


errorOpen: 
    mov rcx,msjErrorArchivo
    sub rsp,28h
    call printf
    add rsp,28h
    jmp finPrograma




;***************************************************   DATOS   ******************************************************
;********************************************************************************************************************
pedirDato: 
    mov rcx,msjInicial
    sub rsp,28h
    call printf
    add rsp,28h

    mov rcx,opInicial
    sub rsp,28h
    call gets
    add rsp,28h

    call transformarOperandoInicial

    mov rcx,[opInicialTransformado]
    mov [resParcial],rcx ;coloco el operando inicial en el resultado parcial
ret

transformarOperandoInicial: 
    mov rcx,opInicial
    mov rdx,caracter
    mov r8,2
    sub rsp,28h
    call strtol
    add rsp,28h
    mov [opInicialTransformado],rax
    
ret

imprimirInicial: 
    mov rcx,msjOpInicial
    mov rdx,opInicial ;imprimo como string, solo visualmente, luego opero con el transformado
    sub rsp,28h
    call printf
    add rsp,28h

ret

imprimirRegistroOperando: 
    
    mov rcx,[opRegistroTransformado]
    mov rdx,caracter
    mov r8,2
    sub rsp,28h
    call itoa
    add rsp,28h
    mov [opRegistroBinario],rax

    mov rcx,msjRegistro
    mov rdx,[opRegistroBinario]
    sub rsp,28h
    call printf
    add rsp,28h

ret

imprimirRegistroOperacion: 
    mov rcx,msjOperacion
    mov rdx,registroOperacion
    sub rsp,28h
    call printf
    add rsp,28h
    
ret

imprimirResParcial:
    mov rcx,msjResParcial
    mov rdx,[resParcial]
    sub rsp,28h
    call printf
    add rsp,28h
    
ret


;***************************************************  CALCULO  ******************************************************
;*******************************************************************************************************************
resultadoParcial:
    cmp byte[registroOperacion],"O"
    je  calcularOR

    cmp byte[registroOperacion],"X"
    je  calcularXOR

    cmp byte[registroOperacion],"N"
    je  calcularAND
ret

calcularOR:
    mov rcx,[opRegistroTransformado]
    or  [resParcial],rcx

    mov rcx,[resParcial]
    mov rdx,caracter
    mov r8,2
    sub rsp,28h
    call itoa
    add rsp,28h
    mov [resParcialTransformado],rax

    mov rcx,msjResParcial
    mov rdx,[resParcialTransformado] 
    sub rsp,28h
    call printf
    add rsp,28h

ret

calcularXOR:
    mov rcx,[opRegistroTransformado]
    xor [resParcial],rcx

    mov rcx,[resParcial]
    mov rdx,caracter
    mov r8,2
    sub rsp,28h
    call itoa
    add rsp,28h
    mov [resParcialTransformado],rax

    mov rcx,msjResParcial
    mov rdx,[resParcialTransformado] 
    sub rsp,28h
    call printf
    add rsp,28h

ret

calcularAND:
    mov rcx,[opRegistroTransformado]
    and  [resParcial],rcx

    mov rcx,[resParcial]
    mov rdx,caracter
    mov r8,2
    sub rsp,28h
    call itoa
    add rsp,28h
    mov [resParcialTransformado],rax

    mov rcx,msjResParcial
    mov rdx,[resParcialTransformado] 
    sub rsp,28h
    call printf
    add rsp,28h

ret