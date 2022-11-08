; FILE: print.asm
; print text string in VGA buffer (in protected mode)

[bits 32]

; in: esi -- pointer to the null-terminated string
; doesn't check that the string fits
print_protected:
  pusha

  mov ebx, vga_start
  mov ah, style_wb

  print_protected_loop:
    mov al, byte[esi]

    ; we are done if char is zero
    test al, al
    je print_protected_done

    ; otherwise we print it
    mov word[ebx], ax

    inc esi
    add ebx, 2

    jmp print_protected_loop

print_protected_done:

  popa

  ret

