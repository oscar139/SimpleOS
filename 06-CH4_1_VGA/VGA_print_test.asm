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
%include "../Utilities_32bit/vga_print.asm"
main:
 [org 0x7c00]        ; Memory offset based on where the BIOS loaded this program into memory
mov ebp, 0x8000
mov esp, ebp

mov esi, HELLO_STRING
call _vga_print

jmp $               ; Jump to current address or in other words loop forever

%include "../Utilities_16bit_bios/vfd_padding.asm" ; Pad out to 1.44MB Floppy Disk