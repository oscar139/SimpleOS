;
; A boot sector Template
;
jmp main

;
; DATA Goes here
;

;Includes

main:
[org 0x7c00]        ; Memory offset based on where the BIOS loaded this program into memory


jmp $               ; Jump to current address or in other words loop forever

%include "../Utilities_16bit_bios/vfd_padding.asm" ; Pad out to 1.44MB Floppy Disk