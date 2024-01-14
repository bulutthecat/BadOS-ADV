section .text
    org 0x8000   ; Set the origin to the standard bootloader location
    jmp start    ; Jump over the data section

section .data
    inputBuffer db 80 dup(0) ; Create a buffer for the input {80 characters}
    inputBufferPos db 0      ; Create a variable to store the input buffer position


start:
    call clear_screen
    call wait_for_key

print_loop:
    call get_key      ; Get a key press
    call print_char   ; Print the character

    ; if it is the enter key, we need to print a new line
    cmp al, 0x0D
    je clear_screen   ; If enter key, jump to clear_screen

    cmp al, 0x1B      ; Check if the key pressed is the escape key (0x1B)
    je  halt          ; If escape key, jump to halt

    jmp print_loop    ; Otherwise, continue in the loop

get_key:
    xor ah, ah        ; BIOS function: Wait for a keystroke
    int 0x16          ; Call BIOS interrupt for keyboard input
    ret

print_char:
    mov ah, 0x0e      ; BIOS teletype function
    int 0x10          ; Call BIOS interrupt to print character
    ret

wait_for_key:
    mov ah, 0          ; BIOS function: Wait for a keystroke
    int 0x16           ; Call BIOS interrupt for keyboard input
    jmp print_loop     ; Jump back to print_loop to print message again

newline:
    ; Carriage Return - move cursor to beginning of the line
    mov ah, 0x02      ; Function: Set cursor position
    mov bh, 0x00      ; Page number
    mov dh, 0x00      ; Row: don't change
    mov dl, 0x00      ; Column: 0 (beginning of the line)
    int 0x10          ; Call video interrupt

    ; Line Feed - move cursor to the next line
    mov ah, 0x03      ; Function: Get cursor position
    int 0x10          ; Call video interrupt
    inc dh            ; Increase row
    mov ah, 0x02      ; Function: Set cursor position
    int 0x10          ; Call video interrupt
    jmp cmd_stack     ; Jump to cmd_stack to print the command stack

clear_screen:
    mov ax, 0b800h     ; Video memory address
    mov es, ax         ; Set es to video memory address
    xor di, di         ; Set di to 0 (start of video memory)
    mov cx, 2000
    mov ax, 0x0720     ; Space character with black background
    rep stosw          ; Fill video memory with spaces

    ; Set cursor to top left corner
    mov ah, 2          ; BIOS set cursor function
    mov bh, 0          ; Page number
    mov dh, 0          ; Row
    mov dl, 0          ; Column
    int 0x10           ; Call BIOS interrupt to set cursor
    jmp cmd_stack      ; Jump to new_line to move cursor to next line

print_string:
    mov al, [si]    ; Load the character at SI into AL
    inc si          ; Increment SI to point to the next character
    cmp al, 0       ; Check if the character is the null terminator
    je  print_string_finish ; If it's the null terminator, jump to print_loop

    mov ah, 0x0e    ; Set AH to 0x0E, the teletype output function
    int 0x10        ; Call the BIOS interrupt to print the character
    jmp print_string; Jump back to print the next character

print_string_finish:
    pop si          ; Pop the return address from the stack
    jmp wait_for_key; Jump back to wait_for_key

cmd_stack:
    message db 'BADOS> / = ', 0
    mov si, message   ; Set SI to point to the message
    call print_string
    ; After printing the command stack, jump to wait_for_key
    ; make sure the si register is cleared, to the default value
    ; otherwise the message will be printed twice
    jmp start

halt:
    hlt                    ; Halt the CPU