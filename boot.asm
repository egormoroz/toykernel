; FILE: boot.asm
; the core of the bootloader

; tell nasm the origin address is 0x7C00
[org 0x7C00]

; tell nasm to generate 16 bit instructions
[bits 16]


; initialize base pointer and stack pointer
; so the stack size is 0x7C00 - 0x0500 = 0x7700 ?
mov bp, 0x0500
mov sp, bp

; save the id of the boot drive
mov byte[boot_drive], dl

mov bx, msg_hello_world
call print_bios


; start loading from the 2th sector (currently in 1st)
mov bx, 0x0002
; load only one sector
mov cx, 0x0001
; the address to store the new sector
mov dx, 0x7E00

; load the sector
call load_bios

; now we should be able to read from the second sector
mov bx, loaded_msg
call print_bios

; infinite loop
jmp $

; ---includes---

%include "print.asm"
%include "load.asm"


; ---data storage---

msg_hello_world: db `Hello World!\r\n`, 0

; boot drive storage
boot_drive: db 0x00

; pad with zeros until we are at 510th byte
times 510 - ($-$$) db 0x00

; magic number
dw 0xAA55


bootsector_extended:

loaded_msg: db `Now reading from the next sector!`, 0

; pad w/ zeros
times 512 - ($ - bootsector_extended) db 0x00

