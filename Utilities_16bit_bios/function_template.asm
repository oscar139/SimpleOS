%ifndef MY_FUNCTION_FILE_ASM
%define MY_FUNCTION_FILE_ASM

; 
; Function Template
; 
_function_name:
    pusha               ; Push all or only the used registers
                        ; pushes in order [AX, CX, DX, BX, SP, BP, SI, DI]
        mov bp, sp      ; Establish Frame Stack
        sub sp, 0       ; (optional) create space for local variables by subtracting the needed bytes from sp
        ;
        ; Function Code Goes Here
        ;
        mov sp, bp      ; (optional) Not strictly needed but you must ensure that popa lines up with pusha. 
                        ; For example any use of the stack for local variables would result in sp != bp.

    popa                ; Pop all or any pushed registers

    mov ax, 0           ; Typical implementation of a return value it should be assumed functions modify AX.

ret                     ; The return address is pushed onto the stack when the function is called
                        ; it should be the only thing left on the stack when the program reaches ret
                        ; ret pops an address off the stack regardless of what was placed there
%endif