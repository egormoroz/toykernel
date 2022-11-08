; FILE: clear.asm
; clear the VGA text screen

[bits 32]

clear_protected:
  pusha

  mov ebx, vga_start
  mov ecx, vga_end

  mov ah, style_wb
  mov al, ' '

  clear_protected_loop:
    mov word[ebx], ax
    
    add ebx, 2
    cmp ebx, ecx

    jl clear_protected_loop

  popa

  ret



