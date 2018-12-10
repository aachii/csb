;  Executable name : base32enc
;  Created date    : 07.11.2018
;  Author          : Janick Stucki
;  Description     : Decodes base32 to text
;
SECTION .bss			; Section of uninitialised data
	BUFFLEN	equ 1		; read the input 1 byte
	Buff: resb BUFFLEN	; Text buffer
	CHARLEN equ 1		; result for translated 5bit pairs
	Char: resb CHARLEN	; length of result
	
SECTION .data			; Section of initialised data
	; reverse table to get 5 bit value from ASCII value -50 as offset
	Table: db 26,27,28,29,30,31,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
	TABLELEN equ $-Table
	
SECTION .text		; Section of code
	
GLOBAL 	_start		; Start point for linker
	
_start:
	nop		; This no-op keeps gdb happy...
	
; Read a buffer from stdin:
Read:
	mov rax,Buff		; Offset of Buffer to eax
	mov rbx,BUFFLEN		; Number of bytes to read to ebx
	call ReadBuff		; Call ReadBuff
	mov rbp,rax		; Save # of bytes read from file for later
	cmp rax,0		; If eax=0, sys_read reached EOF on stdin	
	je Done			; Jump If Equal (to 0, from compare)
	
	mov dl, byte [Buff]
	cmp dl,13
	je Read
	cmp dl,10
	je Read
	
	cmp dl,61
	jne NotEquiv
	inc r8
	jmp IsEquiv
	
NotEquiv:	
	sub rdx,50
	mov cl, byte [Table+rdx]
	add rdi,rcx
IsEquiv:
	inc rsi
	shl rdi,5
	cmp rsi,8
	je Translate
	
	jmp Read	; continue reading buffer
	
Translate:
	shr rdi,5
	mov r9,rdi
	xor rdi,rdi
	xor rcx,rcx
	xor rdx,rdx
	mov rdi,0
	mov cl,40
	
	cmp r8,6
	je Equiv6
	cmp r8,4
	je Equiv4
	cmp r8,3
	je Equiv3
	cmp r8,1
	je Equiv1
	
	jmp Printit
	
Equiv6:		; print 1 byte
	add rdi,8
	
Equiv4:		; print 2 bytes
	add rdi,8
	
Equiv3:		; print 3 bytes
	add rdi,8
	
Equiv1:		; print 4 bytes
	add rdi,8
	
Printit:	; print 5 bytes
	mov rdx,r9
	sub cl,8
	shr rdx,cl
	mov byte [Char], dl
	mov rax,Char
	mov rbx,CHARLEN
	call PrintString
	cmp rcx,rdi
	jne Printit
	
	xor rcx,rcx
	xor rdx,rdx
	xor rsi,rsi
	xor rdi,rdi
	xor r8,r8
	
	jmp Read
	
; Exit
Done:
	mov rax,60	; Code for Exit Syscall
	mov rdi,0	; Return a code of zero	
	syscall

PrintString:
	; Input:
	;  rax -> address to print out
	;  rbx -> length of address to print
	; Output:
	;  Prints eax to console
	
	push rcx
	push rdx
	push rdi
	push r8
	push r9
	
	mov rsi,rax	; input to correct register
	mov rdx,rbx	; lenght to correct register
	
	mov rax,1	; Specify sys_write call
	mov rdi,1	; Specify File Descriptor 1: Standard output
	syscall
	
	pop r9
	pop r8
	pop rdi
	pop rdx
	pop rcx
	
	ret	; end of PrintString

ReadBuff:
	; Input:
	;  rax -> where to read
	;  rbx -> number of characters to read
	; Output:
	;  rax -> number of read input
	
	push rcx
	push rdx
	push rsi
	push rdi
	push r8
	
	mov rsi,rax	; input to correct register
	mov rdx,rbx	; length to correct register

	mov rax,0	; Specify sys_read call
	mov rdi,0	; Specify File Descriptor 0: Standard Input
	syscall
	
	pop r8
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	
	ret	; end of ReadBuff
