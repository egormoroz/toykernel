; FILE: detect_lm.asm
; check whether long mode is supported or not
; if not, then print message and hang

[bits 32]

detect_lm_protected:
  pushad

  ; firstly, we do a convoluted test if CPUID utility is supported
  ; we try to change 21st bit in FLAGS and if it remains the same
  ; despite our writes, then CPUID is unavailable

  ; set eax to FLAGS indirectly
  pushfd
  pop eax

  ; save to ecx for comparision later
  mov ecx, eax

  ; flip 21st bit
  xor eax, 1 << 21

  ; and write the result in FLAGS
  push eax
  popfd
  
  ; read FLAGS again
  pushfd
  pop eax

  cmp eax, ecx
  ; if the bit did not change, then CPUID isn't supported
  je cpuid_not_found_protected

  ; now we can invoke cpuid to see if it supports
  ; extended functions needed for enabling long mode
  mov eax, 0x80000000
  cpuid

  ; if eax is > 0x80000001, then it is possible to enter long mode
  cmp eax, 0x80000001
  jb im_not_found_protected
  
  popad
  ret

cpuid_not_found_protected:
  call clear_protected
  mov esi, cpuid_not_found
  call print_protected
  jmp $

im_not_found_protected:
  call clear_protected
  mov esi, im_not_found
  call print_protected
  jmp $

cpuid_not_found: db `ERROR CPUID unsupported, but required for long mode`, 0
im_not_found: db `ERROR Long mode not supported`, 0

