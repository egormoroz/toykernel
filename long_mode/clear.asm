; FILE: clear.asm
; clear VGA buffer (64 bit mode)

[bits 64]

; in: rdi - style
clear_long:
  push rdi
  push rax
  push rcx

  shl rdi, 8
  mov rax, rdi

  mov al, ' '

  mov rdi, vga_start
  mov rcx, vga_extent / 2

  rep stosw

  pop rcx
  pop rax
  pop rdi
  ret


