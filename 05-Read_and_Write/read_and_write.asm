;
; A boot sector that will read data from a drive into memory
;
jmp main

START_MSG:              db 'Booting OS!',0
READ_DISK_ATTEMPT_MSG:  db 'Attempting to Read Disk',0
DISK_READ_FAILURE_MSG:  db 'Disk Read Failure!',0
SECTORS_READ_MSG:       db 'Sectors Read: ',0
GOODBYE_MSG:            db 'Good Bye',0

;Includes
%include "../Utilities_16bit_bios/bios_print.asm"
%include "../Utilities_16bit_bios/bios_print_hex.asm"
%include "../Utilities_16bit_bios/bios_print_memory.asm"

main:
[org 0x7c00]                    ; Memory offset based on where the BIOS loaded this program into memory

mov bp, 8000
mov sp, bp

mov si, START_MSG
call _print

call _print_nl

mov si, READ_DISK_ATTEMPT_MSG
call _print

call _print_nl

mov ah, 0x02                    ; Service 2 to be used with int 0x13 Read sectors into memory
mov al, 0x05                    ; # of sectors to be read 
                                ; Play with the number of sectors to be read see if it dissapears find me by only reading 2 sectors
push ax                         ; Save al, to be compared to verify correct number of sectors read
mov ch, 0x0                     ; Cylinder #
mov cl, 0x02                    ; Sector 2 the sector after boot sector. Note sector indexing starts at 1 not 0.
mov dh, 0x0                     ; Head Number
mov dl, 0x0                     ; Disk Number
mov bx, 0x9000                  ; ES:BX Address of memory buffer 
int 0x13
jc _disk_error                  ; If carry bit set there was an error

pop dx                          ; ax saved from before is stored in dx
cmp dl, al                      ; al contains the number of sectors read if not the same as the number instructed there was an error
jne _disk_error
jmp _read_successful

_disk_error:
    mov si, DISK_READ_FAILURE_MSG
    call _print
    call _print_nl

_read_successful:
mov si, SECTORS_READ_MSG
call _print
mov ax, 0x01
mov si, dx
call _print_hex_byte
call _print_nl

mov si, 0x9000                  ; Expecting 4 words of 0x00 0xf0
mov di, 0x9007
call _print_bytes_in_range
call _print_nl

mov si, 0x91fc                  ; Expecing 2 words of 0x00 0xf0 and 2 of 0xaa 0xba 
mov di, 0x9203
call _print_bytes_in_range
call _print_nl

mov si, 0x9400                  ; Should print "Find Me"
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
db 'Find Me',0
times 16 - 8 db 0; Padded out to 16 bytes 

;  makes a 1.44MB VFD
times 1440*1024/16 - ($-$$)/16 dw 0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000