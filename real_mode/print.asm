; FILE: print.asm
; printing procedures

[bits 16]

; print null-terminated string
; in: bx - string pointer
print_bios:

  push ax
  push bx

  mov ah, 0x0E

  print_bios_loop:
    cmp byte[bx], 0
    je print_bios_end

    mov al, byte[bx]
    int 0x10

    inc bx
    jmp print_bios_loop
    

print_bios_end:

  pop bx
  pop ax

  ret


; prints the given number in hex
; in: bx - the number
print_hex_bios:
  push ax
  push bx
  push cx

  mov ah, 0x0E
  ; for some reason `mov al, byte[cx]` doesnt work (error: invalid effective address)
  ; so we will instead store the digits pointer in bx
  ; and the number in cx
  mov cx, bx

  mov al, '0'
  int 0x10

  mov al, 'x'
  int 0x10

  ; high byte: high 4 bits
  movzx bx, ch
  shr bl, 4
  add bx, digits
  mov al, byte[bx]
  int 0x10

  ; high byte: low 4 bits
  movzx bx, ch
  and bl, 0xF
  add bx, digits
  mov al, byte[bx]
  int 0x10

  ; low byte: high 4 bits
  movzx bx, cl
  shr bl, 4
  add bx, digits
  mov al, byte[bx]
  int 0x10

  ; low byte: low 4 bits
  movzx bx, cl
  and bl, 0xF
  add bx, digits
  mov al, byte[bx]
  int 0x10

  pop cx
  pop bx
  pop ax

  ret


digits: db '0123456789ABCDEF'

