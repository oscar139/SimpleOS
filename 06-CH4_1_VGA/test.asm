
mov edi, 0xb8000

mov al, 'X'
mov ah, 0x0f

mov [di], ax

jmp $               ; Jump to current address or in other words loop forever

%include "../Utilities_16bit_bios/vfd_padding.asm" ; Pad out to 1.44MB Floppy Disk