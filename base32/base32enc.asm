;  Executable name : base32enc
;  Created date    : 07.11.2018
;  Author          : Janick Stucki
;  Description     : Encodes text to base32
;
SECTION .bss			; Section of uninitialised data
	BUFFLEN	equ 5		; read the input 5 bytes
	Buff: resb BUFFLEN	; Text buffer
	RESLEN equ 8
	Res: resb RESLEN
	
SECTION .data			; Section of initialised data
	Table: db "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
	TABLELEN equ $-Table
	; 5 bits from input is the offset in data for base32
	Result dq '0'
	
SECTION .text			; Section of code
	
GLOBAL 	_start			; Start point for linker
	
_start:
	nop			; This no-op keeps gdb happy...
	
; Read a buffer from stdin:
Read:
	mov rax,Buff		; Offset of Buffer to eax
	mov rbx,BUFFLEN		; Number of bytes to read to ebx
	call ReadBuff		; Call ReadBuff
	mov rbp,rax		; Save # of bytes read from file for later
	cmp rax,0		; If eax=0, sys_read reached EOF on stdin
	je Done			; Jump If Equal (to 0, from compare)

; Get 5 bytes and translate from Table
	xor rdi,rdi
	xor rax,rax
	xor rcx,rcx
	mov cl,35		; start of first 5 bits
	
	mov al,byte [Buff]	; load 40 bits of data in rax
	shl rax,8
	mov al,byte [Buff+1]
	shl rax,8
	mov al,byte [Buff+2]
	shl rax,8
	mov al,byte [Buff+3]
	shl rax,8
	mov al,byte [Buff+4]
	
	mov rdx,rax		; store loaded bits to rdx
	mov rbx, 0x1F		; set 5 bit mask 0001 1111
	
Loop:
	mov rax,rdx
	shr rax,cl
	and rax,rbx
	mov byte [Result+rdi],al
	
	inc rdi
	sub cl,5
	
	cmp rdi,rbp
	jna Loop
	
	xor rsi,rsi
	
Translate:
	xor rbx,rbx
	xor rcx,rcx
	
	mov bl, byte [Result+rsi]
	mov cl, byte [Table+rbx]
	mov byte [Result+rsi],cl
	
	inc rsi
	cmp rsi,8
	jna Translate
	
; print out the result
	mov rax,Result		; Specify sys_write call
	mov rbx,8		; Specify File Descriptor 1: Standard output
	call PrintString	; call PrintString
	jmp Read		; Loop back and load file buffer again
	
; Exit
Done:
	mov rax,1		; Code for Exit Syscall
	mov rbx,0		; Return a code of zero	
	int 0x80		; Make kernel call

PrintString:
	; Input:
	;  rax -> address to print out
	;  rbx -> length of address to print
	; Output:
	;  Prints eax to console
	
	push rcx
	push rdx
	
	mov rcx,rax
	mov rdx,rbx
	
	mov rax,4		; Specify sys_write call
	mov rbx,1		; Specify File Descriptor 1: Standard output
	int 0x80		; Make kernel call to display line string
	
	pop rdx
	pop rcx
	
	ret	; end of PrintString

ReadBuff:
	; Input:
	;  rax -> where to read
	;  rbx -> number of characters to read
	; Output:
	;  rax -> number of read input

	mov rcx,rax
	mov rdx,rbx

	mov rax,3		; Specify sys_read call
	mov rbx,0		; Specify File Descriptor 0: Standard Input
	int 0x80		; Call sys_read to fill the buffer

	ret	; end of ReadBuff
