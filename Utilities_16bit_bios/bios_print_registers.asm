%ifndef bios_print_registers_asm
%define bios_print_registers_asm

%include "../Utilities_16bit_bios/bios_print.asm"
%include "../Utilities_16bit_bios/bios_print_hex.asm"

; 
; Prints the current state of all the registers 
; 

register_names:      db 'AX: ',0,'CX: ',0,'DX: ',0,'BX: ',0,'SP: ',0,'BP: ',0,'SI: ',0,'DI: ',0

_print_registers:
    pusha               ; Push all or only the used registers
        mov bp, sp
        sub sp, 16
        mov [bp-2], ax
        mov [bp-4], cx
        mov [bp-6], dx
        mov [bp-8], bx
        mov ax, [bp+6]          ; Position of sp on call stack
        add ax, 2               ; sp was adjusted by 2 prior to call by the return address being pushed onto the stack
        mov [bp-10], ax         ; ax should contain the pre call adjusted value of sp 
        mov ax, [bp+4]          ; *
        mov [bp-12], ax         ; ax should contain the value of bp accquired from the call stack 
        mov [bp-14], si
        mov [bp-16], di

        mov cx, 0
._print_loop:
        cmp cx, 8
        je ._print_loop_exit
        mov bx, cx                      ; Index of string
        lea si, [register_names]        ; Print the register name from the string array
        imul bx, 5                      ; 5 bytes per string
        add si, bx                      ; Address of string
        call _print                     ; *

        mov ax, cx                      ; Calculate Address of saved register value
        imul ax, 2                      ; *
        mov bx, bp                      ; *
        sub bx, 2                       ; *
        sub bx, ax                      ; *
        mov ax, 1                       ; Prefix the hex word
        mov si, [bx]                    ; *
        call _print_hex_word
        mov ah, 0x0e
        mov al, ' '
        int 0x10

        cmp cx, 3                       ; After bx (4 interations) print on new line
        jne ._skip_nl                   ; *
        call _print_nl                  ; *
._skip_nl:
        inc cx
        jmp ._print_loop
._print_loop_exit:
        mov sp, bp
    popa
    mov ax, 0x0
ret
%endif