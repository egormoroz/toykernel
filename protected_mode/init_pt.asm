; FILE: init_pt.asm
; initialize the page table

; Initialize the page table
; 
; The Page Table has 4 components which will be mapped as follows:
;
; PML4T -> 0x1000 (Page Map Level 4 Table)
; PDPT  -> 0x2000 (Page Directory Pointer Table)
; PDT   -> 0x3000 (Page Directory Table)
; PT    -> 0x4000 (Page table)

[bits 32]

init_pt_protected:
  pushad

  ; first we initialize page table w/ zeros
  ; the page table is located in range [0x1000; 0x4FFF]
  ; use rep stosd for this purpose


  mov edi, 0x1000 ; the base address

  mov cr3, edi ; save the PML4T start address for later

  xor eax, eax ; set eax to zero

  mov ecx, 4096 ; repeat 4096. Each page table is 4096 bytes
                ; and each iteration we write 4 bytes

  rep stosd ; zero out the page table entries

  mov edi, cr3 ; set edi back to PML4T address

  mov dword[edi], 0x2003
  add edi, 0x1000
  mov dword[edi], 0x3003
  add edi, 0x1000
  mov dword[edi], 0x4003

  add edi, 0x1000
  mov ebx, 0x03
  mov ecx, 512

  add_page_entry_protected:
    mov dword[edi], ebx
    add ebx, 0x1000
    add edi, 8

    loop add_page_entry_protected

  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  popad
  ret

