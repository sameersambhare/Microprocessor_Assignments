%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro
%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro
section .data
    bmsg db 10,"Before transfer:"
    bmsg_len equ $-bmsg
    amsg db 10, 10, "After transfer: "
    amsg_len equ $-amsg
    sblock db 10h, 20h, 30h, 40h, 50h
    dblock times 5 db 0
    smsg db 10, "Source block: "
    smsg_len equ $-smsg
    dmsg db 10, "Destination block: "
    dmsg_len equ $-dmsg
    space db " "
    space_len equ $-space
section .bss
    char_ans resb 2
section .text
    global _start
_start:
    print bmsg, bmsg_len
    print smsg, smsg_len
    mov rsi, sblock
    call block_display
    print dmsg, dmsg_len
    mov rsi, dblock - 2
    call block_display
    call block_transfer
    print amsg, amsg_len
    print smsg, smsg_len
    mov rsi, sblock
    call block_display
    print dmsg, dmsg_len
    mov rsi, dblock - 2
    call block_display
    exit   
  block_transfer:
    mov rsi, sblock + 4
    mov rdi, dblock + 2
    mov rcx, 5   
back:
    std
    rep movsb
    ret   
block_display:
    mov rbp, 5
    next_num:
    mov al, [rsi]
    push rsi
    call Disp_8
    print space, space_len
    pop rsi
    inc rsi
    dec rbp
    jnz next_num
ret
Disp_8:
    mov rsi, char_ans + 1
    mov rcx, 2
    mov rbx, 16
next_digit:
    xor rdx, rdx
    div rbx
    cmp dl, 9
    jbe add30
    add dl, 07H   
add30:
    add dl, 30H
    mov [rsi], dl
    dec rsi
   dec rcx
    jnz next_digit
    print char_ans, 2
ret
