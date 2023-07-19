; GDT
; Implementing flat memory model
; Comments reflect a Big endian view check in the binary output and see that it follows little endian.
times 8-(($-$$)% 8) db 0xaa
gdt_start:

gds_null:       ;mandatory null descriptor
    dd 0x0
    dd 0x0

; G for Granulari 1 = 4K 16*16*16
; D/B Default operation size 1 = 32 bit, 0 for 16bit
; L 64bit code segment off
; AVL Debugging off for now
; P Segment present true for now uesd in virtual memory
; DPL Descriptor Privilege Level ring 0 is highest privilege 2 bit value
; S Descriptor type 1 for code or data segments


gds_code:
    db 11111111b, 11111111b     ; Byte 0   Limit 7:0                   | Limit 15:8
    db 00000000b, 00000000b     ; Byte 2   Base 7:0                    | Base 15:8
    db 00000000b, 10011010b     ; Byte 4   Base 23:16                  | [P,DPL,S] Type 1:code 0:Expand Down 1:Readable 0:Accessed
    db 11001111b, 00000000b     ; Byte 6   G, D/b, L, AVL, Limit 19:16 | Base 31:24

gds_data:
    db 11111111b, 11111111b     ; Byte 0   Limit 7:0                   | Limit 15:8
    db 00000000b, 00000000b     ; Byte 2   Base 7:0                    | Base 15:8
    db 00000000b, 10010010b     ; Byte 4   Base 23:16                  | [P,DPL,S] Type 0:Data 0:Expand Down 1:Writable 0:Accessed
    db 11001111b, 00000000b     ; Byte 6   G, D/b, L, AVL, Limit 19:16 | Base 31:24

gdt_end:

; GDT
; **********************************************************************************************************************
; The GDT is not a segment itself; instead, it is a data structure in linear address space. The base linear address and
; limit of the GDT must be loaded into the GDTR register (see Section 2.4, “Memory-Management Registers”). The
; base address of the GDT should be aligned on an eight-byte boundary to yield the best processor performance. The
; limit value for the GDT is expressed in bytes. As with segments, the limit value is added to the base address to get
; the address of the last valid byte. A limit value of 0 results in exactly one valid byte. Because segment descriptors
; are always 8 bytes long, the GDT limit should always be one less than an integral multiple of eight (that is, 8N – 1).
; **********************************************************************************************************************
; From Intel® 64 and IA-32 Architectures Software Developer’s Manual
; **********************************************************************************************************************

gdt_register:
    dw gdt_end - gdt_start - 1  ; GDT Size
    dd gdt_start                ; Starting Address of GDT

; Calculated indexs in the GDT
NULL_SEG equ gds_null               ; 0x00
CODE_SEG equ gds_code - gdt_start   ; 0x08
DATA_SEG equ gds_data - gdt_start   ; 0x10