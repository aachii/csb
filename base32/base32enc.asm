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
	mov rsi,Buff
	xor rcx,rcx
	
Loop:
	xor rax,rax		; clear eax
	mov rax,Buff
	mov rbx, 0x1F
	
	
	
	;mov al,byte [rsi+rcx]	; get byte from buffer with offset
	;shr al,3
	;sub rsi,3
	;and al,1Fh		; mask out the 5 first bits
	;mov bl,byte [Table+rax]; get the matching character from data Table
	;mov byte [Res+rcx], bl	; put character to Res in memory
	
	add rcx,1		; shift to the next byte
	cmp rcx,rbp		; compare pointer to buffer
	jna Loop		; 
	
; print out the result
	mov rax,Res		; Specify sys_write call
	mov rbx,RESLEN		; Specify File Descriptor 1: Standard output
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
