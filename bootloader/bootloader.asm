; Define the origin point (where the bootloader will be loaded in memory)
ORG 0x7C00

; Entry point for the bootloader
jmp short start

; Define the boot sector
start:
    ; Set up the segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Load the operating system kernel into memory
    mov ah, 0x02 ; BIOS read function
    mov al, 1    ; Number of sectors to read
    mov ch, 0    ; Cylinder number
    mov dh, 0    ; Head number
    mov cl, 2    ; Sector number (adjust as needed)
    mov bx, 0x1000 ; Load the kernel to address 0x1000:0x0000
    int 0x13     ; Call BIOS interrupt 0x13

    ; Jump to the loaded kernel
    jmp 0x1000:0x0000

; Padding and magic number
times 510 - ($-$$) db 0
dw 0xAA55 ; Boot signature (magic number)
