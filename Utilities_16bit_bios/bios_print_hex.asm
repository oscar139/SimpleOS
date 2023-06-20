%ifndef bios_print_hex_asm
%define bios_print_hex_asm

; Print Hex Byte Function
; si: Hex word (prints the least significant byte) ax: prefix option (0=off)

_print_hex_byte:
    pusha
        mov bp, sp

                                ; Hex to Ascii Numbers Offset +0x30
                                ; Ascii Numbers to Letters Offset +0x06
        cmp ax, 0x0             ; check for prefix option
        je ._skip_prefix
        mov ah, 0x0e            ; *
        mov al, '0'             ; *
        int 0x10                ; *
        mov al, 'x'             ; *
        int 0x10                ; Prints 0x
._skip_prefix:

        mov cx, 0               ; loop counter
        ror si, 8               ; Position the byte to be printed
.loop:
        rol si, 4               ; rotate the bytes back in to place
        mov ax, si              ; si holds the 2 byte word ; move to ax to manipiulate
        and ax, 0x000f          ; mask ax with 0x000f
        add ax, '0'             ; add ASCII 0 Offset 0x30 

        cmp al, 0x3A            ; If al is greater than equal to 57 hex 0x39 Add Letter Offset +0x07
        jl .offset_skip         ; *
        add ax, 0x07            ; *
.offset_skip:                   ; *
        mov ah, 0x0e            ; Print char
        int 0x10                ; *
        inc cx
        cmp cx, 2               ; *
        jl .loop                ; loop 2 times

._return_to_caller:
    popa
    mov ax, 0x0
ret

;
; Function bios print hex word
; si: Hex word ax: prefix option (0=off)
_print_hex_word:
    push bp
        mov bp, sp

        cmp ax, 0x0             ; check for prefix option
        je ._skip_prefix
        mov ah, 0x0e            ; *
        mov al, '0'             ; *
        int 0x10                ; *
        mov al, 'x'             ; *
        int 0x10                ; Prints 0x
._skip_prefix:

        mov ax, 0
        rol si, 8               ; Position higher byte into the lower byte 
        call _print_hex_byte
        ror si, 8               ; Reposition lower byte
        call _print_hex_byte

    pop bp
    mov ax, 0x0
ret

%endif