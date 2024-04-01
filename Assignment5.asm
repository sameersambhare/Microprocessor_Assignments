section .data
msg db "HEX to BCD"
msg_len equ $-msg
emsg db "Please enter valid hexadecimal value."
emsg_len equ $-emsg
amsg db "Enter the hexadecimal value:"
amsg_len equ $-amsg
omsg db "BCD value is:"
omsg equ $-omsg

section .bss
buff resb 5
temp resw 1
char_ans resb 5

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 0
mov rax,0
mov rdi,0
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
call accept_16
mov [temp],bx
print omsg,omsg_len
mov ax,[temp]
call disp_10
exit

;-----------------------------------------------
accept_16:
print amsg,amsg_len
read buff,5
mov rsi,buff
mov rcx,4
xor bx,bx

next_byte:
shl bx,4
mov al,[rsi]
cmp al,'0'
jb error
cmp al,'9'
jbe sub30

cmp al,'A'
jb error
cmp al,'F'
jbe sub37

cmp al,'a'
jb error
cmp al,'f'
jbe sub57

sub57: sub al,20h
sub37: sub al,07h
sub30: sub al,30h

add bx,ax
inc rsi
dec rcx
jnz next_byte
ret
;-----------------------------------------------
disp_10:
mov rbx,10
mov rcx,5
mov rsi,char_ans+4

cnt: 
mov rdx,0
div rbx
cmp dl,09h
jbe add30
add dl,07h

add30:
add dl,30h
mov [rsi],dl
dec rsi
dec rcx
jnz cnt
print char_ans,5
ret
;-----------------------------------------------
error:
print emsg,emsg_len
exit
