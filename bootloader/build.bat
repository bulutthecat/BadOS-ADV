@echo off
SET NASM="nasm"
SET QEMU="qemu-system-i386"
SET DD="dd"

REM Compile the bootloader and OS
%nasm% -f bin badloader.asm -o badloader.bin
%nasm% -f bin bados.asm -o bados.bin

REM Create a blank floppy disk image
%dd% if=/dev/zero of=os.img bs=512 count=2880

REM Copy the bootloader to the first sector of the disk image
%dd% if=badloader.bin of=os.img conv=notrunc

REM Copy the OS to the disk image (after the bootloader)
%dd% if=bados.bin of=os.img seek=1 conv=notrunc

REM Run the OS in QEMU
%qemu% -drive format=raw,file=os.img

REM Pause the script if you want to see any output before it closes
pause