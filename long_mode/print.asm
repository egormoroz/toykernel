; FILE: print.asm
; print text string in VGA buffer (in 64-bit long mode)

[bits 64]

; in: 
;   rsi -- pointer to the null-terminated string
;   rdi -- style
; doesn't check that the string fits
print_long:
  push rax
  push rdx
  push rdi
  push rsi

  mov rdx, vga_start
  mov rax, rdi
  shl rax, 8

  print_long_loop:
    mov al, byte[rsi]

    ; we are done if char is zero
    test al, al
    je print_long_done

    ; otherwise we print it
    mov word[rdx], ax

    inc rsi
    add rdx, 2

    jmp print_long_loop

print_long_done:

  pop rsi
  pop rdi
  pop rdx
  pop rax

  ret

