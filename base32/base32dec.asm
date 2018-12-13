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
	mov rax,Buff		; Offset of Buffer to rax
	mov rbx,BUFFLEN		; Number of bytes to read to rbx
	call ReadBuff		; Call ReadBuff
	mov rbp,rax		; Save # of bytes read from file
	cmp rax,0		; If eax=0, sys_read reached EOF on stdin	
	je Done			; Jump If Equal (to 0, from compare)
	
	mov dl, byte [Buff]	; get the read byte to rdx
	cmp dl,13		; if its CR
	je Read			
	cmp dl,10		; or LF (CRLF is a new line, skip that)
	je Read			; Read the next byte
	
	cmp dl,61	; if its a =
	jne NotEquiv
	inc r8		; increase the = counter in r8
	jmp IsEquiv	; and skip the translation from table
	
NotEquiv:		; standard case
	sub rdx,50	; remove 50 from ascii value of read character, this helps keeping the translation table smaller
	mov cl, byte [Table+rdx]; use the ascii value -50 as offset to get the 5bit value to cl
	add rdi,rcx	; add rcx to rdi, had an issue with keeping the result in rcx, adding solved this
IsEquiv:
	inc rsi		; increase counter for read bytes (will continue when 8)
	shl rdi,5	; shift 5 bits left
	cmp rsi,8	; continue translating if 8 bytes are read
	je Translate
	
	jmp Read	; continue reading buffer
	
Translate:
	shr rdi,5	; because of loop in Read we shift one too many, shift it back
	mov r9,rdi	; keep a backup of our shifted 5 bit pairs in r9 (40 bits together)
	xor rdi,rdi	; clear some registers for future use
	xor rcx,rcx
	xor rdx,rdx
	mov rdi,0	; rdi holds the value where to stop printing
	mov cl,40	; rcx holds the value how much shifting is needed to get 8 bits to print
	
	cmp r8,6	; different cases for = occurences
	je Equiv6	; go to according case
	cmp r8,4
	je Equiv4
	cmp r8,3
	je Equiv3
	cmp r8,1
	je Equiv1
	
	jmp Printit	; default case is no =
	
Equiv6:		; print 1 byte
	add rdi,8	; 6 = has to stop after 1 printed byte -> need 32
	
Equiv4:		; print 2 bytes
	add rdi,8	; 4 = has to stop after 2 printed bytes -> need 24
	
Equiv3:		; print 3 bytes
	add rdi,8	; 3 = has to stop after 3 printed bytes -> 16
	
Equiv1:		; print 4 bytes
	add rdi,8	; 1 = has to stop after 4 printed bytes -> 8
	
Printit:	; print 5 bytes
	mov rdx,r9	; get the backup in rdx to work with
	sub cl,8	; remove 8 from rcx for the correct shifting
	shr rdx,cl	; shift the first 8 bit
	mov byte [Char], dl	; put it in Char
	mov rax,Char	; and print Char
	mov rbx,CHARLEN	; length of Char
	call PrintString	; print to console
	cmp rcx,rdi	; compare rcx with rdi (either 0 or set by amount of = above)
	jne Printit	; print next if no match
	
	xor rcx,rcx	; clear registers to work with in next buffer round
	xor rdx,rdx
	xor rsi,rsi
	xor rdi,rdi
	xor r8,r8
	
	jmp Read	; continue read buffer
	
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
	
	push rcx	; put used registers to stack
	push rdx
	push rdi
	push r8
	push r9
	
	mov rsi,rax	; input to correct register
	mov rdx,rbx	; lenght to correct register
	
	mov rax,1	; Specify sys_write call
	mov rdi,1	; Specify File Descriptor 1: Standard output
	syscall
	
	pop r9		; get registers back from stack in reverse order
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
