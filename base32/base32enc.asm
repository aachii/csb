;  Executable name : base32enc
;  Created date    : 07.11.2018
;  Author          : Janick Stucki
;  Description     : Encodes text to base32, makes newline every 76th character
;
SECTION .bss			; Section of uninitialised data
	BUFFLEN	equ 5		; read the input 5 bytes
	Buff: resb BUFFLEN	; Text buffer
	CHARLEN equ 1		; variable for printing char by char
	Char: resb CHARLEN	; length of 1 char
	
SECTION .data			; Section of initialised data
	Table: db "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
	Newline: db 13,10
	
SECTION .text		; Section of code
	
GLOBAL 	_start		; Start point for linker
	
_start:
	nop		; This no-op keeps gdb happy...

; Read a buffer from stdin:
Read:
	mov rsi,Buff		; Offset of Buffer to eax
	mov rdx,BUFFLEN		; Number of bytes to read to ebx
	call ReadBuff		; Call ReadBuff
	mov rbp,rax		; Save # of bytes read from file for later
	cmp rax,0		; If eax=0, sys_read reached EOF on stdin	
	je Done			; Jump If Equal (to 0, from compare)

BuffToRegister:
	shl rax,8
	mov al,byte [Buff+rdi]
	inc rdi
	cmp rdi,5
	jne BuffToRegister

	mov rdi,rax
	xor rbx,rbx
	mov rcx,40
	xor rdx,rdx

	cmp rbp,1
	je Equiv6
	cmp rbp,2
	je Equiv4
	cmp rbp,3
	je Equiv3
	cmp rbp,4
	je Equiv1
	jmp Translate

Equiv6:	add rbx,10
	add r9,2
Equiv4: add rbx,5
	add r9,1
Equiv3: add rbx,10
	add r9,2
Equiv1: add rbx,5
	add r9,1

Translate:
	cmp r8,76
	jne SkipNewline
	mov rsi,Newline
	mov rdx,2
	call PrintString
	xor r8,r8

SkipNewline:
	mov rax,rdi
	sub cl,5
	shr rax,cl
	and rax,0x1F
	mov dl,byte [Table+rax]
	mov [Char],rdx
	mov rsi,Char
	mov rdx,CHARLEN
	call PrintString
	inc r8
	cmp cl,bl
	jne Translate

	cmp r9,0
	je SkipEquiv
Equiv:
	mov rsi,Table+32
	mov rdx,CHARLEN
	call PrintString
	dec r9
	cmp r9,0
	jne Equiv

SkipEquiv:
	xor rdi,rdi
	jmp Read	; continue reading buffer

; Exit
Done:
	mov rsi,Newline
	mov rdx,2
	call PrintString
	mov rax,60	; Code for Exit Syscall
	mov rdi,0	; Return a code of zero	
	syscall

PrintString:
	; Input:
	;  rsi -> address to print out
	;  rdx -> length of address to print
	; Output:
	;  Prints eax to console
	push rcx
	push rdi
	mov rax,1	; Specify sys_write call
	mov rdi,1	; Specify File Descriptor 1: Standard output
	syscall
	pop rdi
	pop rcx
	ret	; end of PrintString

ReadBuff:
	; Input:
	;  rsi -> where to read
	;  rdx -> number of characters to read
	; Output:
	;  rax -> number of read input

	mov rax,0	; Specify sys_read call
	mov rdi,0	; Specify File Descriptor 0: Standard Input
	syscall

	ret	; end of ReadBuff
