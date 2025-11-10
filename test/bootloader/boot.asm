[BITS 16]
[ORG 0x7c00]

start:
    cli           ; Clear interupts
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    mov si, ms
    sti           ; Enable interrupts, allowing them to occur again

print:
    lodsb         ; Load byte at DS:SI into AL register and increment SI
    cmp al, 0     ; Compare the value in AL with 0 (null terminator)
    je done       ; Jump to 'done' label if zero (end of string)
    mov ah, 0x0E  ; Set AH register to 0x0E (BIOS teletype output function)
    int 0x10      ; Call BIOS interrupt 0x10 for teletype output
    jmp print     ; Jump back to 'print' label to process next character
    
done:
    cli           ; Clear interrupts, disabling all maskable interrupts
    hlt           ; Halt the CPU
    
 msg: db 'Hello World!', 0 ; Define the message 'Hello World!' followed by a null terminator

times 510 - ($ - $$) db 0 ; Fill the rest of the boot sector with zeros up to 510 bytes

dw 0xAA55        ; Boot sector signature, required to make the disk bootable