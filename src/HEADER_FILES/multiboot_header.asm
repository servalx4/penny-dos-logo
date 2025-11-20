[BITS 32]
section .multiboot
align 4

multiboot_header:
    ; magic number
    dd 0x1BADB002
    ; flags: 0 = minimal
    dd 0x00000000
    ; checksum = -(magic + flags)
    dd -(0x1BADB002 + 0x00000000)