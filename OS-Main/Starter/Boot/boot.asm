bits 16
org 0x7C00
;AX is the primary accumulator; it is used in input/output and most arithmetic instructions
;dsData Segment − It contains data, constants and work areas. A 16-bit Data Segment register or DS register stores the starting address of the data segment.
;ES:DI (ES is Extra Segment, DI is Destination Index) is typically used to point to the destination for a string copy, as mentioned above.
;SS:BP (SS is Stack Segment, BP is Stack Frame Pointer) points to the address of the top of the stack frame, i.e. the base of the data area in the call stack for the currently active subprogram. DS:SI (DS is Data Segment, SI is Source Index) is often used to point to string data that is about to be copied to ES:DI.
;
;


start:
    cli                     ; Clear interrupts
    xor ax, ax             ; Set AX to 0, xor - sets the resultant bit to 1, if and only if the bits from the operands are different,  clearing a register.
    mov ds, ax             ; Set DS to 0
    mov es, ax             ; Set ES to 0
    mov ss, ax             ; Set SS to 0
    mov sp, 0x7C00         ; Set stack pointer to the top of the boot sector
    sti               ; Set interrupts back on Set Interrupt Flag (sti) (IA-32 Assembly Language Reference Manual)

    mov si , msg_loading
    call print_string

    mov bx , 0x1000 ;branch to 0x1000
    mov es , bx ; The EX instruction is used to modify an existing instruction and then execute it
    xor bx , bx
    mov dh , 15
    call disk_load

    ;protect_mode
    cli
    lgdt [gdt32_desc]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE32_SEG:protected_mode

bits 32
protected_mode: 
    mov ax , DATA32_SEG
    mov ds , ax
    mov es , ax
    mov ss , ax
    mov esp , 0x7C00

    call setup_paging
    mov ecx, 0xC0000080
    rdmsr
    or eax, 0x00000100
    wrsmr
    mov eax, 0x80000000
    mov cr0, eax
    jmp CODE64_SEG:long_mode
bits 64
long_mode:
    mov ax, DATA64_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov rsp, 0x7C00

    ; Jump to 64-bit kernel
    jmp 0x100000

; Includes
%include "print16.asm"
%include "disk.asm"
%include "paging.asm"

; Data
msg_loading db "Loading x64 kernel...", 0

; 32-bit GDT
gdt32:
    dq 0x0000000000000000    ; Null descriptor
gdt32_code:
    dw 0xFFFF                ; Limit 0-15
    dw 0x0000                ; Base 0-15
    db 0x00                  ; Base 16-23
    db 0x9A                  ; Present, DPL 0, Code, Exec/Read
    db 0xCF                  ; 4K granularity, 32-bit
    db 0x00                  ; Base 24-31
gdt32_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x92                  ; Present, DPL 0, Data, Read/Write
    db 0xCF
    db 0x00
gdt32_end:

gdt32_desc:
    dw gdt32_end - gdt32 - 1
    dd gdt32

CODE32_SEG equ gdt32_code - gdt32
DATA32_SEG equ gdt32_data - gdt32

; 64-bit GDT
gdt64:
    dq 0x0000000000000000    ; Null descriptor
gdt64_code:
    dw 0x0000                ; Limit 0-15
    dw 0x0000                ; Base 0-15
    db 0x00                  ; Base 16-23
    db 0x9A                  ; Present, DPL 0, Code, Exec/Read
    db 0x20                  ; 64-bit segment
    db 0x00                  ; Base 24-31
gdt64_data:
    dw 0x0000
    dw 0x0000
    db 0x00
    db 0x92                  ; Present, DPL 0, Data, Read/Write
    db 0x00
    db 0x00
gdt64_end:

gdt64_desc:
    dw gdt64_end - gdt64 - 1
    dd gdt64

CODE64_SEG equ gdt64_code - gdt64
DATA64_SEG equ gdt64_data - gdt64

; Boot signature
times 510-($-$$) db 0
dw 0xAA55
