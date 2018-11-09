;  Executable name : base32enc
;  Created date    : 07.11.2018
;  Author          : Janick Stucki
;  Description     : Encodes text to base32
;
SECTION .bss			; Section of uninitialised data
	BUFFLEN	equ 5		; read the input 5 bytes
	Buff: resb BUFFLEN	; Text buffer
	
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
	xor rsi,rsi
	xor rdi,rdi
	xor rax,rax
	xor rcx,rcx
	xor r8,r8		; count up later when character is 00 (end of input)
	mov cl,35		; start of first 5 bits
	
Getbuff:	
	mov al,byte [Buff+rsi]	; load 40 bits of data in rax
	cmp al,0		; check if byte is 0000 0000
	ja Cont			; if not continue
	inc r8			; count up if read byte is 0
Cont:
	shl rax,8		; get the first 8 then shift by 8
	inc rsi
	cmp rsi,4
	jb Getbuff
	
	mov rdx,rax		; keep a backup of the read buffer
	mov rbx, 0x1F		; set 5 bit mask 0001 1111
	xor rdi,rdi

; Store the int value of the 5 pair bits in Result
Storebits:
	mov rax,rdx		; get the read buffer for working
	shr rax,cl		; shift to get 5 bits, cl-5 every loop
	and rax,rbx		; mask with 0001 1111 to kill high bits, only want 5
	
	mov byte [Result+rdi],al	; store in Result (rdi is offset, +1 each loop)
	
	inc rdi			; offset to store Result
	sub cl,5		; position of next 5 bit group is 5 less
	
	cmp rdi,7		; after 8 bytes we are done
	jna Storebits		; loop if not above 7
	
	xor rsi,rsi		; clear rsi
	
	cmp r8,4		; 4 empty bytes at end
	je Equiv1
	cmp r8,3
	je Equiv3
	cmp r8,2
	je Equiv4
	cmp r8,1
	je Equiv6
	
	mov r8,7	
	
Translate:
	xor rbx,rbx		; clear rbx and rcx
	xor rcx,rcx		; used for temp storage
	
	mov bl, byte [Result+rsi]	; get the first number from Result in bl
	mov cl, byte [Table+rbx]	; translate the first number from Table into cl
	mov byte [Result+rsi],cl	; put cl to Result
	
	inc rsi			; increase rsi for next Result value
	cmp rsi,7		; same as above, exactly 8 rounds needed
	jna Translate		; loop if not yet completed
	
; print out the result
	mov rax,Result		; Specify sys_write call
	mov rbx,8		; Specify File Descriptor 1: Standard output
	call PrintString	; call PrintString
	jmp Read		; Loop back and load file buffer again
	
; end of input cases for =
Equiv1:
	
	jmp Translate		; go back
Equiv3:
	
	jmp Translate		; go back
Equiv4:
	
	jmp Translate		; go back
Equiv6:
	
	jmp Translate		; go back

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
