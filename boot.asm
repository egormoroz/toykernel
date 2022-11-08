; FILE: boot.asm
; the core of the bootloader

; tell nasm the origin address is 0x7C00
[org 0x7C00]

; tell nasm to generate 16 bit instructions
[bits 16]

mov bx, msg_hello_world
call print_bios

mov bx, 0x1234
call print_hex_bios

; infinite loop
jmp $

%include "print.asm"

msg_hello_world: db `\r\nHello World!\r\n`, 0

; pad with zeros until we are at 510th byte
times 510 - ($-$$) db 0x00

; magic number
dw 0xAA55
