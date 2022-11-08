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


; start loading from the 2nd sector (currently in 1st)
mov bx, 0x0002
; load only one sector
mov cx, 0x0001
; the address to store the new sector
mov dx, 0x7E00

; load the sector
call load_bios

; Elevate the cpu to 32-bit mode
call elevate_bios

; infinite loop
jmp $

; --- real includes ---

%include "real_mode/print.asm"
%include "real_mode/load.asm"
%include "real_mode/gdt.asm"
%include "real_mode/elevate.asm"


; --- real data storage ---

msg_hello_world: db `Hello World!\r\n`, 0

; boot drive storage
boot_drive: db 0x00

; pad with zeros until we are at 510th byte
times 510 - ($-$$) db 0x00

; magic number
dw 0xAA55


; SECOND SECTOR. 32-BIT CODE ONLY.

bootsector_extended:
begin_protected:

call clear_protected

mov esi, protected_alert
call print_protected

jmp $

; --- protected includes ---

%include "protected_mode/print.asm"
%include "protected_mode/clear.asm"

; --- protected data storage ---

protected_alert: db `Now in 32-bit protected mode.`, 0

vga_start: equ 0x000B8000
vga_extent: equ 80 * 25 * 2
vga_end: equ (vga_start + vga_extent)

style_wb: equ 0x0F

; pad w/ zeros
times 512 - ($ - bootsector_extended) db 0x00

