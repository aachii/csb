;  Executable name : io
;  Created date    : 29.10.2018
;  Author          : Janick Stucki
;  Description     : Input Output methods
;
SECTION	.bss			; Section containing uninitialized data
	
SECTION	.data			; Section containing initialised data
	
SECTION	.text			; Section containing code

GLOBAL	ReadBuff,PrintString	; Linker needs this to find the entry point!

SECTION	.code

PrintString:
	; Input:
	;  eax -> address to print out
	;  ebx -> length of address to print
	; Output:
	;  Prints eax to console
	
	push rcx
	push rdx
	
	mov ecx,eax
	mov edx,ebx

	mov eax,4		; Specify sys_write call
	mov ebx,1		; Specify File Descriptor 1: Standard output
	int 80h			; Make kernel call to display line string
	
	pop rdx
	pop rcx
	
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
 
