;
; A boot sector program making use of the stack and calling a function like print a string
;
jmp main

;DATA
boot_string:     db 'Booting OS!', 0xa, 0xd, 0x0

goodbye_string:  db 'Good Bye!', 0x0

;Includes
%include "../Utilities_16bit_bios/bios_print.asm"
%include "../Utilities_16bit_bios/bios_print_hex.asm"
%include "../Utilities_16bit_bios/bios_print_memory.asm"
%include "../Utilities_16bit_bios/bios_print_registers.asm"

main:
[org 0x7c00]        ; Memory offset based on where the BIOS loaded this program into memory
mov bp, 0x8000      ; Set Stack base pointer. Address 1KiB after program loaded into memory
mov sp, bp          ; Set Stack Pointer to base pointer

mov si, boot_string
call _print

mov ax, 1
mov si, 0x00f0
call _print_hex_byte

call _print_nl

mov ax, 0
mov si, 0x1A9F
call _print_hex_word

call _print_nl

mov si, 0x7c00
call _print_byte_at

call _print_nl

mov si, 0x7c00
mov di, 0x7c08
call _print_bytes_in_range

call _print_nl

mov ax, 0x1111
mov cx, 0xf00d
mov dx, 0xb00b
mov bx, 0x1A9F
push 1                  ; Push Junk onto stack to make sp 0x8000 - 4 = 0x0x7FFC
push 2                  ; *
call _print_registers
add sp, 4

call _print_nl

mov si, goodbye_string
call _print

jmp $               ; Jump to current address or in other words loop forever

%include "../Utilities_16bit_bios/vfd_padding.asm" ; Pad out to 1.44MB Floppy Disk