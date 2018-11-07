;  Executable name : hexdump1
;  Created date    : 29.10.2018
;  Author          : Janick Stucki
;  Description     : prints out keyboard input and converts UPPERCASE to lowercase
;
SECTION .bss			; Section containing uninitialized data

	BUFFLEN	equ 16		; We read the file 16 bytes at a time
	Buff: 	resb BUFFLEN	; Text buffer itself
	
SECTION .data			; Section containing initialised data
	
SECTION .text			; Section containing code

GLOBAL 	_start			; Linker needs this to find the entry point!

EXTERN	ReadBuff,PrintString
	
_start:
	nop			; This no-op keeps gdb happy...

; Read a buffer full of text from stdin:
Read:
	mov eax,Buff		; Pass offset of the buffer to read to
	mov ebx,BUFFLEN		; Pass number of bytes to read at one pass
	call ReadBuff		; Call ReadBuff from io.asm to read Buffer
	mov ebp,eax		; Save # of bytes read from file for later
	cmp eax,0		; If eax=0, sys_read reached EOF on stdin
	je Done			; Jump If Equal (to 0, from compare)

; Make all UPPERCASE letter lowercase (add 32dec to char-> 20h)
	mov ebx,Buff		; ebx is Buffer address
	mov ecx,ebp		; ecx is length of input
	dec ebx			; ebx -1 to access last letter
Loop:
	cmp byte [ebx],41h	; compare first byte in ebx to 41h (letter A)
	jb Skip			; jump to Skip if below A
	cmp byte [ebx],5Ah	; compare first byte to 5Ah (letter Z)
	ja Skip			; jump to Skip if above Z

	add byte [ebx],32	; this is only executed if inside A-Z
				; add 32 to the byte at ebx (UPPERCASE to lowercase, see ASCII table)
Skip:
	inc ebx			; ebx +1 for next character
	dec ecx			; ecx -1 for check if we are done
	jnz Loop		; when ecx is 0 we continue, else goto Loop

; Write the line of hexadecimal values to stdout:
	mov eax,Buff		; Specify sys_write call
	mov ebx,ebp		; Specify File Descriptor 1: Standard output
	call PrintString	; call PrintString from io.asm
	
	mov eax,30h
	mov ebx,20
	call PrintString
	
	jmp Read		; Loop back and load file buffer again

; All done! Let's end this party:
Done:
	mov eax,1		; Code for Exit Syscall
	mov ebx,0		; Return a code of zero	
	int 80H			; Make kernel call
