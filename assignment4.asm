section .data
   amsg db "Assignment 4",10
   amsg_len equ $-amsg
   msg0 db "Conversion of BCD number to HEX number"
   msg0_len equ $-msg0
   msg db "Enter the five digit number: "
   msg_len equ $-msg
   msg2 db "Output number is: "
   msg2_len equ $-msg2
   
    ;------------------------------------------------------------------------
   
section .bss
   buf resb 6
   ans resb 5
   char_ans resb 5
   
   %macro print 2
   mov rax,1
   mov rdi,1
   mov rsi,%1
   mov rdx,%2
   syscall
   %endmacro
   
   %macro read 2
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
 
   ;---------------------------------------------------------------------------
   
section .text
   
   global _start
   _start:
   call bcd_hex_procedure
   exit
   
  ;-----------------------------------------------------------------------------------
  
bcd_hex_procedure:
    
   print amsg,amsg_len                     ;print the assignment no
   print msg0,msg0_len                     ;print the assignment name
   print msg,msg_len                       ;print the message to input the number
   read buf,6                              ;take the input
    
   mov rsi,buf                             ;move the source index to first index of buf
   xor ax,ax                               ;make the ax equal to zero
   mov rbp ,5                              ;make base pointer equal to five
   mov rbx,10                              ;make the bx equal to 10
    
   next:
   xor cx,cx                               ;make the counter equal to zero
   mul bx                                  ;multiply bx with ax and store in ax
   mov cl,[rsi]                            ;move the rsi value to cl
   sub cl,30h                              ;subtract 30h from cl
   add ax,cx                               ;add cl into the (product of ax and bx) stored in ax 
    
   inc rsi                                 ;increment the source pointer
   dec rbp                                 ;decrement the base pointer
   jnz next                                ;if rbp is not equal to zero then run from next
    
   mov [ans],ax                            ;move the answer to temp variable i.e ans
   print msg2,msg2_len                     ;print the output message
    
   mov ax,[ans]                            ;move the answer to again to accumulator
   call disp_16                            ;actual conversion of bcd to hex take place here
   ret
    
    ;------------------------------------------------------------------------------
disp_16:
    mov rsi,char_ans+3
    mov rcx,4
    mov rbx , 16

    next_digit:
    xor rdx,rdx
    div rbx

    cmp dl,9
    jbe add30
    add dl, 07h

    add30:
    add dl,30h
    mov [rsi],dl

    dec rsi
    dec rcx
    jnz next_digit

    print char_ans,4
    ret
  
    
    
