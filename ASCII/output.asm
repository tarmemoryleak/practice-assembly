section .bss
  result resb 1 

section .text
  global _start
  
_start
  mov eax, 5
  add eax, 3 ; เราเอา 5 + 3 = 8 
  add eax, 48
  mov ebx, eax
  mov [result], al
  
  
  mov eax, 4
  mov ebx, 1
  mov ecx, result
  mov edx, 1
  int 0x80
  
  mov eax, 1
  mov ebx, 0
  int 0x80
