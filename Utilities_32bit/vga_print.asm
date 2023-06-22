%ifndef VGA_PRINT_ASM
%define VGA_PRINT_ASM

; 
; Prints string addressed in si to VGA memory
; 

; Constants
VIDEO_MEMORY    equ 0Xb8000
WHITE_ON_BLACK  equ 0x0f

_vga_print:
    pusha               ; Push all or only the used registers
                        ; pushes in order [AX, CX, DX, BX, SP, BP, SI, DI]
        mov ebp, esp      ; Establish Frame Stack
        sub esp, 0       ; (optional) create space for local variables by subtracting the needed bytes from sp
            mov edi, VIDEO_MEMORY
            .print_loop:
                cmp esi, 0                  ; Check if we reached the null pointer and end the loop
                je .exit_print_loop         ; *
                mov [edi], WHITE_ON_BLACK   ; Move Attribute to current address poited at by edi 
                inc edi                     ; Move edi to the character position
                movsb                       ; Copy character to [edi] from [esi] and increment
            jmp .print_loop
            .exit_print_loop:
        mov esp, ebp
    popa                ; Pop all or any pushed registers

    mov eax, 0           ; Typical implementation of a return value it should be assumed functions modify AX.

ret                     ; The return address is pushed onto the stack when the function is called
                        ; it should be the only thing left on the stack when the program reaches ret
                        ; ret pops an address off the stack regardless of what was placed there
%endif