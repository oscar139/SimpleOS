%ifndef _32Bit_Protected_Mode_ASM
%define _32Bit_Protected_Mode_ASM

; Switches to 32 bit Protected mode

[bits 16]
_switch_to_32Bit_PM:
    cli                     ; We must switch of interrupts until we have
                            ; set - up the protected mode interrupt vector
                            ; otherwise interrupts will run riot.


lgdt [gdt_register]         ; Load our global descriptor table , which defines
                            ; the protected mode segments ( e.g. for code and data )

mov eax, cr0                ; To make the switch to protected mode , we set
or eax, 0x1                 ; the first bit of CR0 , a control register
mov cr0, eax


jmp CODE_SEG:init_pm        ; Make a far jump ( i.e. to a new segment ) to our 32 - bit
                            ; code. This also forces the CPU to flush its cache of
                            ; pre - fetched and real - mode decoded instructions , which can
                            ; cause problems.

[bits 32]
; Initialise registers and the stack once in PM.
init_pm:
    mov ax, DATA_SEG        ; Set segment registers (less code segment) segments to the DATA_SEG in GDT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call _32Bit_PM

%endif