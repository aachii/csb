;  Executable name : base32enc
;  Created date    : 07.11.2018
;  Author          : Janick Stucki
;  Description     : Encodes text to base32
;
SECTION .bss			; Section of uninitialised data
	BUFFLEN	equ 5		; read the input 5 bytes
	Buff: resb BUFFLEN	; Text buffer
	RESLEN equ 8		; Result length of 8 bytes
	Res: resb RESLEN	; Result variable
	
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
	mov eax,Buff		; Offset of Buffer to eax
	mov ebx,BUFFLEN		; Number of bytes to read to ebx
	call ReadBuff		; Call ReadBuff
	mov ebp,eax			; Save # of bytes read from file for later
	cmp eax,0			; If eax=0, sys_read reached EOF on stdin
	je Done				; Jump If Equal (to 0, from compare)

; Get 5 bits and translate from Table
	mov esi,Buff
	xor ecx,ecx
	
Loop:
	xor eax,eax			; clear eax
	mov edx,ecx			; store offset in edx
	
	mov al,byte [esi+edx]	; get byte from buffer with offset
	and al,1Fh				; mask out the 5 first bits 0001 1111
	mov bl,byte [Table+eax]	; get the matching character from data Table
	mov byte [Res+edx],bl	; store this character in memory (Res)
	
	add ecx,5			; shift to the next 5 bits
	cmp ecx,ebp			; compare pointer to buffer
	jna Loop			; 
	
; Write the line of hexadecimal values to stdout:
	mov eax,Res		; Specify sys_write call
	mov ebx,RESLEN		; Specify File Descriptor 1: Standard output
	call PrintString	; call PrintString from io.asm
	jmp Read		; Loop back and load file buffer again

; All done! Let's end this party:
Done:
	mov eax,1		; Code for Exit Syscall
	mov ebx,0		; Return a code of zero	
	int 80H			; Make kernel call

PrintString:
	; Input:
	;  eax -> address to print out
	;  ebx -> length of address to print
	; Output:
	;  Prints eax to console

	mov ecx,eax
	mov edx,ebx

	mov eax,4		; Specify sys_write call
	mov ebx,1		; Specify File Descriptor 1: Standard output
	int 80h			; Make kernel call to display line string

	ret	; end of PrintString

ReadBuff:
	; Input:
	;  eax -> where to read
	;  ebx -> number of characters to read
	; Output:
	;  eax -> number of read input

	mov ecx,eax
	mov edx,ebx

	mov eax,3		; Specify sys_read call
	mov ebx,0		; Specify File Descriptor 0: Standard Input
	int 80h			; Call sys_read to fill the buffer

	ret	; end of ReadBuff
