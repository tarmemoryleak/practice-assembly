section .data
  msg db "TAR01 IS HERE", 0xA
  len equ $ - msg

section .text
  global _start

_start:
MOV RCX, 10;


_loop1:
PUSH RCX ;
MOV RAX, 1 ;
MOV RDI, 1 ;
MOV RSI, msg 
MOV RDX, len 
SYSCALL ;
POP RCX ;
DEC RCX ;
jnz _loop1 ;


MOV RAX, 60 ;
XOR RDI, RDI ;
SYSCALL ;