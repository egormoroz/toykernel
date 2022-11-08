; FILE: load.asm
; load sectors using a BIOS utility function

[bits 16]

; in:
; bx - sector start point
; cx - number of sectors to load
; dx - destination address
load_bios:
  push ax
  push bx
  push cx
  push dx

  ; push cx again to use it later
  push cx

  ; now pass all the arguments to the BIOS utilty
  ; in the correct registers and invoke it using `int 0x13`

  ; the code for BIOS read utility
  mov ah, 0x02

  ; number of sectors to load
  mov al, cl

  ; sector number
  mov cl, bl

  ; cylinder number
  mov ch, 0

  ; destination address
  mov bx, dx

  ; cylinder head, should be zero
  mov dh, 0

  ; specify the drive to read from
  ; (we stored it in the boot_drive in boot.asm)
  mov dl, byte[boot_drive]

  ; invoke the BIOS read utility
  ; the number of sectors read is stored in al
  ; if an error occured, the error code is stored in ah
  ; and the 'carry' bit is set
  int 0x13

  ; jump if the carry bit is set
  jc boot_disk_error

  ; pop the requested number of sectors to read
  pop bx
  cmp al, bl
  ; it's an error if we have read less sectors than requested
  jne boot_disk_error

  ; otherwise we are good to go
  mov bx, load_success_msg
  call print_bios

  pop dx
  pop cx
  pop bx
  pop ax

  ret
  
; if an error occcured, just print its code and hang
boot_disk_error:
  mov bx, load_error_msg
  call print_bios

  movzx bx, ah
  call print_hex_bios

  ; nothing else we can do..
  jmp $

load_error_msg: db `ERROR Loading Sectors. Code: `, 0
load_success_msg: db `SUCCESS The sectors have been loaded!\r\n`, 0

