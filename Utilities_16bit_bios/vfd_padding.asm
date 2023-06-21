; zero padding and magic bios boot number
times 510-($-$$) db 0
dw 0xaa55

;  makes a 1.44MB VFD
times 1440*1024/16 - 512/16 dw 0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000