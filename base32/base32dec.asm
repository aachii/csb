;  Executable name : base32dec
;  Created date    : 13.11.2018
;  Author          : Janick Stucki
;  Description     : Decodes base32 to text
;
SECTION .bss			; Section of uninitialised data
	BUFFLEN	equ 8		; read the input 8 bytes
	Buff: resb BUFFLEN	; Text buffer
	RESLEN equ 5
	Result: resb RESLEN
	
SECTION .data			; Section of initialised data
	Table: db "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
	TABLELEN equ $-Table
	
SECTION .text		; Section of code
	
GLOBAL 	_start		; Start point for linker
	
_start:
	nop		; This no-op keeps gdb happy...
	
; counter for newline each 76th character
	xor r9,r9	; newline counter
	xor r10,r10	; used for either 8 or 9 result bytes

; Read a buffer from stdin:
Read:
	mov rax,Buff		; Offset of Buffer to eax
	mov rbx,BUFFLEN		; Number of bytes to read to ebx
	call ReadBuff		; Call ReadBuff
	mov rbp,rax		; Save # of bytes read from file for later
	cmp rax,0		; If eax=0, sys_read reached EOF on stdin	
	je Done			; Jump If Equal (to 0, from compare)
	
; Code
	mov rax,qword [Buff]
	
	mov rax,Result		; where to read
	mov rbx,RESLEN		; how long to read
	call PrintString	; call PrintString
	jmp Read		; go back to read the buffer

; Exit
Done:
	mov rax,1	; Code for Exit Syscall
	mov rbx,0	; Return a code of zero	
	int 0x80	; Make kernel call

PrintString:
	; Input:
	;  rax -> address to print out
	;  rbx -> length of address to print
	; Output:
	;  Prints eax to console
	
	push rcx	; store rcx and rdx to stack
	push rdx
	
	mov rcx,rax	; input to correct register
	mov rdx,rbx	; lenght to correct register
	
	mov rax,4	; Specify sys_write call
	mov rbx,1	; Specify File Descriptor 1: Standard output
	int 0x80	; Make kernel call to display line string
	
	pop rdx		; get old values back from stack
	pop rcx		; order is important! 1,2 2,1
	
	ret	; end of PrintString

ReadBuff:
	; Input:
	;  rax -> where to read
	;  rbx -> number of characters to read
	; Output:
	;  rax -> number of read input

	mov rcx,rax	; input to correct register
	mov rdx,rbx	; length to correct register

	mov rax,3	; Specify sys_read call
	mov rbx,0	; Specify File Descriptor 0: Standard Input
	int 0x80	; Call sys_read to fill the buffer

	ret	; end of ReadBuff
