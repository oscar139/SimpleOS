; Prints a 0 terminated string of ascii bytes
; Requires the address of the string to be in si
; Also assuming 16 bit mode
%ifndef bios_print_asm
%define bios_print_asm
_print:
    pusha
        mov ah, 0x0e                ; int 0x10 / ah = 0x0e -> scrolling teletype BIOS Routine

._print_loop:
        mov al, [si]                ; Get the byte at string address pointer
        cmp al, 0x00                ; exit on 0
        je ._return_to_caller       ; exit on 0
        int 0x10                    ; print each character
        inc si                      ; incremnet address
        jmp ._print_loop

._return_to_caller:
    popa
    mov ax, 0x0
ret

_print_nl:
    mov ah, 0x0e
    mov al, 0xa
    int 0x10
    mov al, 0xd
    int 0x10
    mov ax, 0x0
ret

%endif