[org 0x7c00]

xor ax, ax
mov ds, ax
mov es, ax

mov ah, 0x0e
mov bx, Name  
string:
    mov al, [bx]
    cmp al, 0
    je end
    int 0x10 ; i try to print stupid text on screen
    inc bx
    jmp string
end:
jmp $
Name:
    db "Hello There, TAR here!", 0
times 510-($-$$) db 0
dw 0xaa55
