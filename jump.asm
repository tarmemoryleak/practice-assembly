section .data
  msg_wel db "Hello Welcome", 0xA
  w_len equ $ - msg_wel
  msg_fail db "Still learning..", 0xA
  l_len equ $ - msg_fail
  
section .bss
input_buf resb 10 ; จองที่ว่าง 10 byte

section .text
  global _start
  MOV RAX, 0; sys_read = รหัสคือ 0 คล้ายๆ cin ใน c++ 
  MOV RDI, 0
  MOV RSI, input_buf
  MOV RDX, 10; ไม่เกิน 10 ตัว
  SYSCALL 
_start:
  MOV RAX, 100;
  CMP RAX, 50; เปรียบเทียบกับ 50
  JG win_label ; ถ้า RAX > 50 ให้กระโดดไป win

  MOV RAX, 1;
  MOV RDI, 1
  MOV RSI, msg_fail
  MOV RDX, l_len
  SYSCALL
  JMP exit_prog ; Terminated เลย

win_label:
  MOV RAX, 1;
  MOV RDI, 1
  MOV RSI, msg_wel
  MOV RDX, w_len
  SYSCALL

exit_prog: 
  MOV RAX, 60 ;
  XOR RDI, RDI ;
  SYSCALL ; จบโปรแกรม