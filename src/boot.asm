[BITS 16]
[ORG 0x7C00]

start:
	cli ; Disable interrupts
	mov ax, 0x00
	mov ds, ax
	mov es,ax 
	mox ss,ax
	mov sp, 0x7C00 ; Set stack pointer to the end of the boot sector
	sti si ;  Enable interrupts

print:
    lodsb ; Load byte from DS:SI into AL register and increments si
    cmp al, 0
    je done
    mov ah, 0x0E ; BIOS teletype output function
    int 0x10
    jmp print ; Loop to print the next character

done:
    cli
    hlt ; Halt the CPU


msg: db 'Hello, World!', 0

dw 0xAA55 ; Boot sector signature
times 510 - ($ - $$) db 0 ; Fill the rest of the boot sector with zeros
