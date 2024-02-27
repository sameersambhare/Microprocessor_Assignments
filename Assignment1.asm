section .data
msg db "Assignment 01", 10
msg_len equ $-msg
msg1 db "This is first message",10
msg1_len equ $-msg1

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro exit 0
mov rax,60
mov rdi,0
syscall
%endmacro


section .text
global _start
_start:
print msg,msg_len
print msg1,msg1_len
exit