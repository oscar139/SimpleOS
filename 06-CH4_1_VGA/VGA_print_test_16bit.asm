;
; A boot sector to test the 16bit VGA print function
;
jmp main

;
; DATA Goes here
;
HELLO_STRING:       db 'Well hello there!',0
START_MSG:          db 'Start Test',0
END_MSG:            db 'End Test',0
;Includes
%include "../Utilities_16bit_bios/vga_print_16bit.asm"
%include "../Utilities_16bit_bios/bios_print.asm"
%include "../Utilities_16bit_bios/bios_print_hex.asm"
%include "../Utilities_16bit_bios/bios_print_memory.asm"
main:
[org 0x7c00]        ; Memory offset based on where the BIOS loaded this program into memory
mov bp, 0x8000
mov sp, bp
mov si, START_MSG
call _print_nl
call _print
call _print_nl

mov si, HELLO_STRING
call _vga_print



mov ax, 0xb800
mov es, ax
mov ds, ax
mov di, 0x0008
mov si, 0x0
call _print_bytes_in_range
call _print_nl

xor ax, ax
mov ds, ax
mov si, END_MSG
call _print

jmp $               ; Jump to current address or in other words loop forever

%include "../Utilities_16bit_bios/vfd_padding.asm" ; Pad out to 1.44MB Floppy Disk