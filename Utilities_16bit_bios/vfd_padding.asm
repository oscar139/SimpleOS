; zero padding and magic bios boot number
times 510-($-$$) db 0
dw 0xaa55

; padding VFloppyDisk
; 92160-32 makes a 1.44MB VFD
times 92160 - 32 dw 0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000  