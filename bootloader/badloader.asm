section .text
    org 0x7c00

start:
    ; Set up segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Load Stage 2 bootloader
    ; Assume Stage 2 is at a known sector, e.g., second sector
    mov bx, 0x8000   ; Load Stage 2 into memory at 0x8000
    mov ah, 0x02     ; BIOS read sector function
    mov al, 1        ; Read 1 sector
    mov ch, 0        ; Cylinder number
    mov cl, 2        ; Sector number (2nd sector)
    mov dh, 0        ; Head number
    int 0x13         ; Call BIOS

    ; Check for errors in disk operation
    jc start         ; If carry flag is set, retry

    ; Jump to Stage 2 bootloader
    jmp 0x8000

times 510-($-$$) db 0
dw 0xAA55