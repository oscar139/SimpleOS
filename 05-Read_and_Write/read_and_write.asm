;
; A boot sector that will read data from a drive into memory
;
jmp main

START_MSG:              db 'Booting OS!',0
READ_DISK_ATTEMPT_MSG:  db 'Attempting to Read Disk',0
DISK_READ_FAILURE_MSG:  db 'Disk Read Failure!',0
GOODBYE_MSG:            db 'Good Bye',0

;Includes
%include "../Utilities_16bit_bios/bios_print.asm"

main:
[org 0x7c00]        ; Memory offset based on where the BIOS loaded this program into memory

mov bp, 8000
mov sp, bp

mov si, START_MSG
call _print

call _print_nl

mov si, READ_DISK_ATTEMPT_MSG
call _print

call _print_nl

; TODO Read disk
; TODO Check for faliure via cary bit
; TODO Check and report number of bytes read 
; TODO View a few bytes read at the expected addresses
; TODO Demonstrate a failure

mov si, DISK_READ_FAILURE_MSG
call _print

call _print_nl

mov si, GOODBYE_MSG
call _print

jmp $               ; Jump to current address or in other words loop forever

; zero padding and magic bios boot number
times 510-($-$$) db 0
dw 0xaa55
; This space here is the rest of the disk

times 512/2 dw 0xf000
times 512/2 dw 0xbaaa

;  makes a 1.44MB VFD
times 1440*1024/16 - ($-$$)/16 dw 0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000