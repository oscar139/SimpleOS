;
; A boot sector that should find where it was loaded into memory by the bios
;

jmp main
; DATA
db 0,'F00Boot Sector Flag',0                    ; Find the position of this string then subtract 4 bytes to locate boot sector
db 'Boot Sector Found',0                          ; Located at byte 0x18 from start of boot sector

; Includes
%include "../Utilities_16bit_bios/bios_print_hex.asm"
%include "../Utilities_16bit_bios/bios_print.asm"

main:
mov si, 0               ; Starting at Address 0
._search_loop:
    mov al, [si]
    cmp al, 'F'             ; Check for Ascii "F"
    je ._exit_search_loop   ; Address stored in si
    mov ax, 1
    call _print_hex_word        ; Print the Address
    call _print_nl
    inc si                  ;
    jmp ._search_loop       ; loop

 ._exit_search_loop:
    call _print_nl
    call _print_nl
                            ; Check a few more bytes
    mov bx, si              ; "0"
    mov al, [bx + 1]        ;
    cmp al, '0'             ;
    jne ._check_fail       ; Return to search loop
    mov bx, si              ; "O"
    mov al, [bx + 2]        ;
    cmp al, '0'             ;
    jne ._check_fail       ; 
    mov bx, si              ; "B"
    mov al, [bx + 3]        ;
    cmp al, 'B'             ;
    jne ._check_fail       ; 
    mov bx, si              ; "o"
    mov al, [bx + 4]        ;
    cmp al, 'o'             ;
    jne ._check_fail       ;
    mov bx, si              ; "o"
    mov al, [bx + 5]        ;
    cmp al, 'o'             ;
    jne ._check_fail       ;
    mov bx, si              ; "t"
    mov al, [bx + 6]        ;
    cmp al, 't'             ;
    jne ._check_fail       ;
    jmp ._check_pass

._check_fail:
    inc si
    jmp ._search_loop
._check_pass:

mov ax, 1
call _print_hex_word        ; Print the Address
call _print_nl
call _print                 ; Use Address to print the flag
call _print_nl
mov ax, 1
sub si, 4                   ; Correct for start of Boot Sect
call _print_hex_word        ; Print the Address
call _print_nl
mov ax, 1
add si, 0x18                ; Address of second string
call _print_hex_word        ; Print the Address
call _print_nl
call _print                 ;


jmp $               ; Jump to current address or in other words loop forever

%include "../Utilities_16bit_bios/vfd_padding.asm" ; Pad out to 1.44MB Floppy Disk