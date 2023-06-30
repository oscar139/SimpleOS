; Boot Sector that switches to 32 bit protected mode
; Constants
DATA_ADDRESS equ 384

[org 0x7c00]
start:
    mov bp, 0x9000
    mov sp, bp

    mov si, _16BIT_REAL_MODE_MSG
    call _print

    call _switch_to_32Bit_PM

    jmp $

%include "../Utilities_16bit_bios/bios_print.asm"
%include "../Utilities_32bit/GDT.asm"
%include "../Utilities_32bit/32Bit_Protected_Mode.asm"
%include "../Utilities_32bit/vga_print.asm"

[bits 32]
_32Bit_PM:
    mov esi, _32BIT_PM_MSG
    call _vga_print

    jmp $


; Data
times DATA_ADDRESS-($-$$)    db 0
_16BIT_REAL_MODE_MSG:   db "Currently in 16-bit Real Mode!", 0
_32BIT_PM_MSG:          db "Success! Now operating in 32-bit protected mode!", 0

%include "../Utilities_16bit_bios/vfd_padding.asm"

