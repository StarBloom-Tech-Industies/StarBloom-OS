; x64 paging setup
setup_paging:
    ; Clear memory for PML4, PDP, PD
    mov edi, 0x1000
    mov cr3, edi
    xor eax, eax
    mov ecx, 0x3000
    rep stosd
    mov edi, cr3

    ; Set up PML4
    mov dword [edi], 0x2000 | 0x03  ; PDP at 0x2000, present + writable
    add edi, 0x1000

    ; Set up PDP
    mov dword [edi], 0x3000 | 0x03  ; PD at 0x3000, present + writable
    add edi, 0x1000

    ; Set up PD (2MB pages)
    mov ebx, 0x00000083            ; Present + writable + huge page
    mov ecx, 512
.set_entry:
    mov dword [edi], ebx
    add ebx, 0x200000
    add edi, 8
    loop .set_entry

    ; Enable PAE
    mov eax, cr4
    or eax, 0x20
    mov cr4, eax
    ret