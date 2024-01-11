section .text
    org 0x7c00   ; Set the origin to the standard bootloader location

    jmp start    ; Jump over the data section

message db 'Hello, world!', 0

start:
    mov si, message ; Load the address of the message into SI

print_loop:
    mov ah, 0x0e    ; BIOS teletype function
    mov al, [si]    ; Load the next character of the message
    int 0x10        ; Call BIOS interrupt to print character
    inc si          ; Move to the next character
    cmp al, 0       ; Check for the null terminator
    je  halt        ; If null terminator, jump to halt
    jmp print_loop  ; Otherwise, continue printing

halt:
    hlt            ; Halt the CPU

    times 510-($-$$) db 0   ; Pad the bootloader to 510 bytes
    dw 0xAA55               ; Boot signature at the end of the bootloader
