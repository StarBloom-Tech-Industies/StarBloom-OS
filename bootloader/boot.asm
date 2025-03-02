; bootloader.asm - Simple Bootloader (512 bytes)

; BIOS loads this at memory address 0x7c00
org 0x7c00

;Set up segment registers
 xor ax, ax 
 mov ds, ax
 mov es, ax

 mov si, message
 call print_string

 cli
 hlt

 print_string: 
 mov ah, 0x0E

.loop:
    lodsb
    cmp al, 0 
    je, .done
    int 0x10
    jmp .loop
.done: 
    registers

message: db " Welcome to StarBloom", 0 

times 510 = ($-$$) db 0 

dw 0xAA55