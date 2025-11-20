%INCLUDE "src/HEADER_FILES/multiboot_header.asm"
%INCLUDE "src/hardware/memory.asm"

[BITS 16]
[ORG KERNELOFFSET]

jmp Main        ; jump over multiboot header / reserved space

%INCLUDE "src/hardware/disk.asm"
%INCLUDE "src/hardware/display.asm"
%INCLUDE "src/hardware/system.asm"
%INCLUDE "src/hardware/keyboard.asm"
%INCLUDE "src/libs/io.asm"

Main:
    call Stack
    call CleanScreen
    mov byte [color], 87h
    call SetBackGroundColor
    call Println

    ; enter the shell
    call Shell

    call Reboot
    call End


; Stack setup (16-bit real mode)
Stack:
    cli                 ; disable interrupts
    mov ax, 0x7000      ; example stack segment
    mov ss, ax
    mov sp, 0xFFFF
    sti                 ; enable interrupts
    ret
    
; End routine (placeholder)
End:
    hlt                 ; halt CPU
    jmp End             ; infinite loop
        

%INCLUDE "src/shell.asm"
