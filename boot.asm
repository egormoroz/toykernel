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
; load the 32bit sector and the 64bit sector
mov cx, 0x0002
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

[bits 32]

bootsector_extended:
begin_protected:

call detect_lm_protected

call clear_protected
mov esi, lm_supported
call print_protected

call init_pt_protected

call elevate_protected

jmp $

; --- protected includes ---

%include "protected_mode/print.asm"
%include "protected_mode/clear.asm"
%include "protected_mode/detect_lm.asm"
%include "protected_mode/init_pt.asm"
%include "protected_mode/gdt.asm"
%include "protected_mode/elevate.asm"

; --- protected data storage ---

lm_supported: db `64-bit long mode is supported.`, 0

vga_start: equ 0x000B8000
vga_extent: equ 80 * 25 * 2
vga_end: equ (vga_start + vga_extent)

kernel_start: equ 0x00100000 ; kernel is at 1MB

style_wb: equ 0x0F

; pad w/ zeros
times 512 - ($ - bootsector_extended) db 0x00

begin_long_mode:
[bits 64]

mov rdi, style_blue
call clear_long

mov rsi, long_mode_note
call print_long

jmp $

; --- long includes ---

%include "long_mode/clear.asm"
%include "long_mode/print.asm"

; --- long data storage ---

long_mode_note: db `Now running in fully-enabled, 64-bit long mode!`, 0
style_blue: equ 0x1F


times 512 - ($ - begin_long_mode) db 0x00

