section    .data
	nline	db	10,10
	nline_len	equ	$-nline
	colon		db	":"
	rmsg 	db 	10,'Processor is in Real Mode...'
	rmsg_len	equ 	$-rmsg
	pmsg 	db 	10,'Processor is in Protected Mode...'
	pmsg_len	equ 	$-pmsg
	gmsg		db	10,"GDTR (Global Descriptor Table Register)	: "
	gmsg_len	equ	$-gmsg
	imsg		db	10,"IDTR (Interrupt Descriptor Table Register)	: "
	imsg_len	equ	$-imsg
	lmsg		db	10,"LDTR (Local Descriptor Table Register)	: "
	lmsg_len	equ	$-lmsg
	tmsg		db	10,"TR (Task Register)		: "
	tmsg_len	equ	$-tmsg
	mmsg		db	10,"MSW (Machine Status Word)	: "
	mmsg_len	equ	$-mmsg
Section   .bss
	GDTR		resw	3		
	IDTR		resw	3
	LDTR		resw	1		
	TR		resw	1
	MSW		resw	1
	char_ans	resb	4		
%macro  Print   2
	mov   rax, 1
	mov   rdi, 1
	mov   rsi, %1
	mov   rdx, %2
	syscall
%endmacro
%macro  Read   2
	mov   rax, 0
	mov   rdi, 0
	mov   rsi, %1
	mov   rdx, %2
	syscall
%endmacro
%macro	Exit	0
	mov  rax, 60
	mov  rdi, 0
	syscall
%endmacro
section    .text
	global   _start
_start:
	SMSW		[MSW]
	mov		rax,[MSW]
	ror 		rax,1			
	jc 		p_mode
	Print	rmsg,rmsg_len
	jmp		next
p_mode:	
	Print	pmsg,pmsg_len
next:
	SGDT		[GDTR]
	SIDT		[IDTR]
	SLDT		[LDTR]
	STR		[TR]
	SMSW		[MSW]
	Print	gmsg, gmsg_len								
	mov 		ax,[GDTR+4]		
	call 	disp16_proc		
	mov 		ax,[GDTR+2]		
	call 	disp16_proc		
	Print	colon,1
	mov 		ax,[GDTR+0]		
	call 	disp16_proc		
	Print	imsg, imsg_len		 
	mov 		ax,[IDTR+4]		
	call 	disp16_proc		
	mov 		ax,[IDTR+2]		
	call 	disp16_proc		
	Print	colon,1
	mov 		ax,[IDTR+0]		
	call 	disp16_proc				
	Print	lmsg, lmsg_len		
	mov 		ax,[LDTR]		
	call 	disp16_proc		
	Print	tmsg, tmsg_len		
	mov 		ax,[TR]		
	call 	disp16_proc		
	Print	mmsg, mmsg_len			
	mov 		ax,[MSW]		
	call 	disp16_proc		

	Print	nline, nline_len
	Exit
disp16_proc:
	mov 		rbx,16			
	mov 		rcx,4			 
	mov 		rsi,char_ans+3		
cnt:	mov 		rdx,0			
	div 		rbx
	cmp 		dl, 09h			
	jbe  	add30
	add  	dl, 07h 
add30:
	add 		dl,30h			
	mov 		[rsi],dl		
	dec 		rsi				
	dec 		rcx				
	jnz 		cnt				
	Print 	char_ans,4		
ret
