; GDT
; Implementing flat memory model  
; Comments reflect a Big endian view check in the binary output and see that it follows little endian. 

gdt_start:

gdt_null:       ;mandatory null descriptor 
    dd 0x0  
    dd 0x0

; G for Granulari 1 = 4K 16*16*16 
; D/B Default operation size 1 = 32 bit, 0 for 16bit
; L 64bit code segment off
; AVL Debugging off for now

gdt_code:           
    db 11111111b, 11111111b     ; Byte 0   Limit 7:0                   | Limit 15:8 
    db 00000000b, 00000000b     ; Byte 2   Base 7:0                    | Base 15:8
    db 00000000b, 10011010b     ; Byte 4   Base 23:16                  | [P,DPL,S] Type 1:code 0:Expand Down 1:Readable 0:Accessed
    db 11001111b, 00000000b     ; Byte 6   G, D/b, L, AVL, Limit 19:16 | Base 31:24   

gdt_data:           
    db 11111111b, 11111111b     ; Byte 0   Limit 7:0                   | Limit 15:8 
    db 00000000b, 00000000b     ; Byte 2   Base 7:0                    | Base 15:8
    db 00000000b, 10010010b     ; Byte 4   Base 23:16                  | [P,DPL,S] Type 0:Data 0:Expand Down 1:Writable 0:Accessed
    db 11001111b, 00000000b     ; Byte 6   G, D/b, L, AVL, Limit 19:16 | Base 31:24    
