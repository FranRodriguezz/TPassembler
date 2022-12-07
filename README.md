# TPassembler
Se ingresa el nombre de un archivo, y un operando inicial binario (de 16 bits). El codigo utiliza el operando inicial, y el primer operando del registro, y procede a realizar entre ellos la operacion leida del registro (X(xor), N(and), O(or)), almacenando el resultado parcial. A ese resultado parcial se le aplica la siguiente operacion del registro, con su siguiente operando, y asi hasta que finaliza el archivo.

### Compilacion:
```
nasm .\TrabajoPractico.asm -f elf64

gcc .\TrabajoPractico.o -o TrabajoPractico

.\TrabajoPractico.exe
```
