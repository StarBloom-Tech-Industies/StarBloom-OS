header_start:
    dd 0xe85250d6 ; Magic number for boot header
    ;architecture
    dd 0 
    ;length
    dd header_end - header_start
    ;checksum
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start)) ; check if the numebr of 0's is correct

    ; end tage 

    dw 0 
    dw 0
    dd 8 ; 8 bytes for the header
header_end: