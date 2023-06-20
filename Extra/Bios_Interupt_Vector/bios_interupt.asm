;
; A boot sector demonstrating some bios interupts
;
jmp main
; DATA 
hello_string:   db 'Hello World',0
goodbye_string: db 'Good Bye',0

;Includes
%include "../../Utilities_16bit_bios/bios_print.asm" 
main:
[org 0x7c00]        ; Memory offset based on where the BIOS loaded this program into memory
mov bp, 0x8000
mov sp, bp

mov ah, 0x0         ; Interupt 0x10 AH/0 Set video mode 
mov al, 0x12        ; al: mode VGA 640 x 480
int 0x10            ; Interupts 0x10 == Video Services

mov ah, 0x0b        ; Service 11, 0x0b set color palette
mov bh, 0x0         ; Pallet color id 0 == background 
mov bl, 0x1         ; Color id 0x1 == blue
int 0x10

mov ah, 0x0b        ; Service 11, 0x0b set color palette
mov bh, 0x1         ; Pallet color id 1 == foreground 
mov bl, 0x7         ; Color id 0x7 == white
int 0x10

mov si, hello_string
call _print

call _print_nl

mov si, goodbye_string
call _print

jmp $               ; Jump to current address or in other words loop forever

%include "../../Utilities_16bit_bios/vfd_padding.asm" ; Pad out to 1.44MB Floppy Disk