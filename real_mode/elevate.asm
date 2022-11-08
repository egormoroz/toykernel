; FILE: elevate.asm
; Enter the protected mode

[bits 16]

; raise the CPU to 32-bit protected mode
elevate_bios:
  ; disable interrupts, because elevating causes lots of interrupts
  ; which we cannot handle since we haven't set up our GDT
  cli

  ; 32-bit protected mode requires GDT, so we set it up
  lgdt [gdt_32_descriptor]

  ; to enable 32-bit mode we must set the 0th bit of 
  ; the control register cr0
  ; we cannot do it directly, so we use eax
  mov eax, cr0
  or eax, 0x00000001
  mov cr0, eax

  ; to clear the cpu pipeline of all 16-bit instructions
  ; we make a far jump
  jmp code_seg:init_pm

  [bits 32]
  init_pm:

  ; do some extra initialization for the 32-bit mode
  mov ax, data_seg
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  ; stack pointers get messed up during the elevation process
  ; so we reset them
  mov ebp, 0x90000
  mov esp, ebp

  ; go to the 2nd sector with 32-bit code
  jmp begin_protected

