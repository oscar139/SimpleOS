; 
; Print Memory at address si
; 
%ifndef bios_print_memory_asm
%define bios_print_memory_asm

%include "../Utilities_16bit_bios/bios_print_hex.asm"


_print_byte_at:
    pusha
        mov bp, sp
        mov ax, 0x1
        mov si, [si]
            call _print_hex_byte
    popa
    mov ax, 0x0
ret

;
; Print bytes in range si to di
;

_print_bytes_in_range:
    pusha
        mov bp, sp
        mov cx, 1                   ; Assume direction is higher addresses
        cmp si, di                  ; Determine direction of increment
        jle .print_loop             ; *
        mov cx, -1                  ; Switch direction towards lower addresses
.print_loop:
        mov ax, 0x1
        call _print_byte_at
        mov ah, 0x0e                ; *
        mov al, ' '                 ; * Spaces between bytes
        int 0x10                    ; *
        cmp si, di                  ; print till si and di are the same including di
        je ._return_to_caller
        add si, cx                  ; increment in direction specified by cx
        jmp .print_loop             ; *
._return_to_caller:
    popa
ret

%endif