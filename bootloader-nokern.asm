ORG 0x7C00

jmp short start

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Print a message to the screen (optional)
    mov ah, 0x0E
    mov al, 'H'
    int 0x10
    mov al, 'e'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'o'
    int 0x10

    ; Jump to a specific memory address (0x8000 in this case)
    jmp 0x8000

times 510 - ($-$$) db 0
dw 0xAA55
