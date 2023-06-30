; Zero padding and magic bios boot number
times 510-($-$$) db 0
dw 0xaa55

; Align to Memory
times 16 - ($-$$)% 16 db 0

; Makes a 1.44MB VFD
times 1440*1024/16 - ($-$$)/16 dw 0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000