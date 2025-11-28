; Penny-DOS CLI shell (16-bit real mode, NASM)
; Built-in commands: help, echo, cls, reboot, man

%IFNDEF __SHELL_DRIVE__
%DEFINE __SHELL_DRIVE__

section .data
prompt          db 'penny-dos> ',0
cmd_not_found   db "Command not found",13,10,0

help1           db "Built-in commands:",13,10,0
help_help       db "  help   - show this help",13,10,0
help_echo       db "  echo   - echo text",13,10,0
help_cls        db "  cls    - clear screen",13,10,0
help_reboot     db "  reboot - reboot system",13,10,0
help_man        db "  man    - show docs URL",13,10,0

LINE_MAX        equ 128
linebuf         times LINE_MAX db 0

man_url         db "https://penny-dos.readthedocs.io/en/latest/",13,10,0

help_cmd_str    db 'help',0
echo_cmd_str    db 'echo',0
man_cmd_str     db 'man',0
cls_cmd_str     db 'cls',0
reboot_cmd_str  db 'reboot',0

section .text
global Shell

Shell:
_shell_loop:
    ; print prompt
    mov si, prompt
    call ShellPrintString

    ; read line
    mov bx, linebuf
    call ShellReadLine

    ; ignore empty lines
    mov al, [bx]
    cmp al, 0
    je _shell_loop

    ; null-terminate first token (space -> 0)
    mov di, bx
_find_space:
    mov al, [di]
    cmp al, 0
    je _token_ready
    cmp al, ' '
    jne _inc_di
    mov byte [di], 0
    inc di
    jmp _token_ready
_inc_di:
    inc di
    jmp _find_space

_token_ready:
    mov si, bx

    ; help
    mov dx, help_cmd_str
    call ShellStrCmp
    cmp al, 1
    je _do_help

    ; echo
    mov dx, echo_cmd_str
    call ShellStrCmp
    cmp al, 1
    je _do_echo

    ; man
    mov dx, man_cmd_str
    call ShellStrCmp
    cmp al, 1
    je _do_man

    ; cls
    mov dx, cls_cmd_str
    call ShellStrCmp
    cmp al, 1
    je _do_cls

    ; reboot
    mov dx, reboot_cmd_str
    call ShellStrCmp
    cmp al, 1
    je _do_reboot

    ; command not found
    mov si, cmd_not_found
    call ShellPrintString
    jmp _shell_loop

_do_help:
    mov si, help1
    call ShellPrintString
    mov si, help_help
    call ShellPrintString
    mov si, help_echo
    call ShellPrintString
    mov si, help_man
    call ShellPrintString
    mov si, help_cls
    call ShellPrintString
    mov si, help_reboot
    call ShellPrintString
    jmp _shell_loop

_do_echo:
    ; find end of token
    mov si, bx
_next_char:
    mov al, [si]
    cmp al, 0
    je _skip_spaces
    inc si
    jmp _next_char

_skip_spaces:
    inc si
_skip_space_loop:
    mov al, [si]
    cmp al, 0
    je _echo_done
    cmp al, ' '
    jne _echo_print
    inc si
    jmp _skip_space_loop

_echo_print:
    mov di, si
    mov si, di
    call ShellPrintString
    mov al, 13
    call ShellPutChar
    mov al, 10
    call ShellPutChar
    jmp _shell_loop

_echo_done:
    mov al, 13
    call ShellPutChar
    mov al, 10
    call ShellPutChar
    jmp _shell_loop

_do_man:
    mov si, man_url
    call ShellPrintString
    jmp _shell_loop

_do_cls:
    call cls_cmd_str
    jmp _shell_loop

_do_reboot:
    call reboot_cmd_str
    jmp _shell_loop

ShellReadLine:
    push bp
    mov bp, sp
    mov di, bx
    xor cx, cx

_read_loop:
    mov ah, 0
    int 0x16
    cmp al, 0x0d
    je _done_read
    cmp al, 0x08
    je _do_backspace
    cmp al, ' '
    jb _read_loop
    cmp cx, LINE_MAX-2
    jae _read_loop
    mov [di], al
    inc di
    inc cx
    push ax
    call ShellPutChar
    pop ax
    jmp _read_loop

_do_backspace:
    cmp cx, 0
    je _read_loop
    dec di
    dec cx
    mov al, 8
    call ShellPutChar
    mov al, ' '
    call ShellPutChar
    mov al, 8
    call ShellPutChar
    jmp _read_loop

_done_read:
    mov byte [di], 0
    mov al, 13
    call ShellPutChar
    mov al, 10
    call ShellPutChar
    pop bp
    ret

ShellPrintString:
    push bp
    mov bp, sp
_print_loop:
    mov al, [si]
    cmp al, 0
    je _print_done
    call ShellPutChar
    inc si
    jmp _print_loop
_print_done:
    pop bp
    ret

ShellPutChar:
    push ax
    push bx
    push cx
    push dx
    mov ah, 0x0E
    mov bh, 0
    mov bl, 7
    int 0x10
    pop dx
    pop cx
    pop bx
    pop ax
    ret

ShellStrCmp:
    push bp
    mov bp, sp
    ; push si
    push dx
_cmp_loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne _cmp_ne
    cmp al, 0
    je _cmp_eq
    inc si
    inc dx
    jmp _cmp_loop
_cmp_ne:
    mov al, 0
    jmp _cmp_ret
_cmp_eq:
    mov al, 1
_cmp_ret:
    pop dx
    pop si
    pop bp
    ret

%ENDIF ; __SHELL_DRIVE__
