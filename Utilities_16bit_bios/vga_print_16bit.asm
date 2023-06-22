%ifndef VGA_PRINT_ASM
%define VGA_PRINT_ASM

; 
; Prints string addressed in si to VGA memory
; 


; Constants
VIDEO_MEMORY_SEGMENT    equ 0xb800
WHITE_ON_BLACK          equ 0x0f

_vga_print:
    
    pusha               ; Push all or only the used registers
                        ; pushes in order [AX, CX, DX, BX, SP, BP, SI, DI]
        mov bp, sp      ; Establish Frame Stack
        sub sp, 0       ; (optional) create space for local variables by subtracting the needed bytes from sp
            mov bx, 0
            mov cx, VIDEO_MEMORY_SEGMENT
            mov es, cx
            mov di, 0xA0
            .print_loop:
                mov ds, bx
                call _print_hex_word
                call _print_nl
                cmp byte [si], 0                   ; Check if we reached the null pointer and end the loop
                je .exit_print_loop                 ; *
                movsb
                mov byte [es:di], WHITE_ON_BLACK      ; Move Attribute to current address poited at by edi
                inc di                             ; Move edi to next charater cell
            jmp .print_loop
            .exit_print_loop:
        mov sp, bp
    popa                ; Pop all or any pushed registers

    mov ax, 0          ; Typical implementation of a return value it should be assumed functions modify AX.

ret                     ; The return address is pushed onto the stack when the function is called
                        ; it should be the only thing left on the stack when the program reaches ret
                        ; ret pops an address off the stack regardless of what was placed there
%endif