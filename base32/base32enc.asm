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
	Table: db "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567=" ;Table + Offset translates 5bit pair to char
	Newline: db 13,10	; newline after each 76th char and at end
	
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
	shl rax,8		; shift one character to left
	mov al,byte [Buff+rdi]	; get next character from buffer
	inc rdi			; count until 5 are read, also offset for Buff
	cmp rdi,5
	jne BuffToRegister	; if not 5 read next character

	mov rdi,rax		; make backup to work with (40 bit)
	xor rbx,rbx		; clear some registers to work with
	mov rcx,40		; number to shift back 1 byte to print
	xor rdx,rdx

	cmp rbp,1		; when 1 char read from buffer
	je Equiv6		; go to 6 = logic
	cmp rbp,2		; 2 chars read
	je Equiv4		; 4 = logic
	cmp rbp,3		; 3 chars read
	je Equiv3		; 3 = logic
	cmp rbp,4		; 4 chars read
	je Equiv1		; 1 = logic
	jmp Translate

Equiv6:	add rbx,10		; to print 6 = we can skip 2*5bit + all below, aimed value: 30
	add r9,2		; to print 6 = we need 2 + below, aimed value: 6
Equiv4: add rbx,5		; to print 4 = we can skip 1*5bit + all below, aimed value: 20
	add r9,1		; to print 4 = we need 1 + below, aimed value: 4
Equiv3: add rbx,10		; same as above, aimed value: 15
	add r9,2		; same as above, aimed value: 3
Equiv1: add rbx,5		; same as above, aimed value: 5
	add r9,1		; same as above, aimed value: 1

Translate:
	cmp r8,76		; r8 is counter for characters printed
	jne SkipNewline
	mov rsi,Newline		; if 76, print new line
	mov rdx,2
	call PrintString
	xor r8,r8		; reset counter to start again at 0

SkipNewline:
	mov rax,rdi		; get backup to rax to work with
	sub cl,5		; value for shifting 5 bits to low register
	shr rax,cl
	and rax,0x1F		; mask 5 bits
	mov dl,byte [Table+rax]	; translate 5 bits from table
	mov [Char],rdx		; write translated character to memory
	mov rsi,Char		; print character
	mov rdx,CHARLEN
	call PrintString
	inc r8			; count printed character for newline logic
	cmp cl,bl		; default case: stop at 0, else its the number from Equiv logic above (30,20,15 or 5)
	jne Translate

	cmp r9,0		; when r9 is bigger 0 print some =
	je SkipEquiv		; else skip this (default case of 5 byte input)
Equiv:
	mov rsi,Table+32	; = is in Table at 32 position
	mov rdx,CHARLEN		; length of = is 1
	call PrintString	; print to console
	dec r9			; decrease = count
	cmp r9,0		; exit when r9 is 0
	jne Equiv		; else print next =

SkipEquiv:
	xor rdi,rdi	; clear to work with in next round
	jmp Read	; continue reading buffer

Done:			; when buffer read 0 bytes
	mov rsi,Newline	; print newline at end
	mov rdx,2
	call PrintString
	mov rax,60	; Code for Exit Syscall
	mov rdi,0	; Return a code of zero	
	syscall		; Exit

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
