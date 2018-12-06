;  Executable name : base32enc
;  Created date    : 07.11.2018
;  Author          : Janick Stucki
;  Description     : Encodes text to base32, makes newline every 76th character
;
SECTION .bss			; Section of uninitialised data
	BUFFLEN	equ 5		; read the input 5 bytes
	Buff: resb BUFFLEN	; Text buffer
	; 5 bits from input is the offset in data for base32
	RESLEN equ 8
	Result: resb RESLEN
	RESLEN9 equ 9		; 9 bytes needed for the
	Res9: resb RESLEN9	; newline case on each 76th character
	
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
	
; Get 5 bytes and translate from Table
	xor rsi,rsi	; clear multiple registers, rsi for source index offset
	xor rdi,rdi	; destination index offset
	xor rax,rax	; working register
	xor rcx,rcx	; shifting number to get 5 bits
	xor r8,r8	; count up later when character is 00 (end of input)
	mov r10,7	; standard length to read 0-7 (8 bytes)
	mov cl,35	; start of first 5 bits (shifting)
	
	mov al,byte [Buff]	; every scenario needs at least one byte read
	inc rsi

; Different cases that can occur at the end
; either 1,2,3 or 4 bytes of zeros can occur (5 zeros would mean no buffer left)
	cmp rbp,1	; buffer length is 1
	je Zero4
	cmp rbp,2	; buffer length is 2
	je Zero3
	cmp rbp,3	; buffer length is 3
	je Zero2
	cmp rbp,4	; buffer length is 4
	je Zero1
	jmp Getbuff	; buffer length is 5 -> standard case

Zero4:			; length 1
	shl rax,32	; shift rest -> all 0
	mov r8,2	; 1 byte input needs 2x5 bits to cover it
	jmp SkipMid
		
Zero3:			; length 2
	shl rax,8	; shift and read one more byte
	mov al, byte [Buff+rsi]
	shl rax,24	; rest -> all 0
	mov r8,4	; 2 bytes input need 4x5 bits to cover it
	jmp SkipMid
	
Zero2:			; length 3
	shl rax,8	; read one more byte
	mov al,byte [Buff+rsi]
	inc rsi		; increase source offset
	cmp rsi,3	; read another byte if rsi is not 3
	jb Zero2
	shl rax,16	; rest -> all 0
	mov r8,5	; 3 bytes input need 5x5 bits to cover it
	jmp SkipMid
	
Zero1:			; length 4
	shl rax,8	; read one more byte
	mov al,byte [Buff+rsi]
	inc rsi		; increase source offset
	cmp rsi,4	; read another byte if rsi is not 4
	jb Zero1
	shl rax,8	; last byte is all 0
	mov r8,7	; 4 bytes input need 7x5 bits to cover it
	jmp SkipMid
	
; Standard scenario when buffer is 5 bytes long
Getbuff:
	shl rax,8		; shift to the next 8 bit
	mov al,byte [Buff+rsi]	; load 40 bits of data in rax again
	inc rsi			; increase offset from buffer
	cmp rsi,5		; detect if all 5 bytes are in or not
	jb Getbuff

SkipMid:
	mov rdx,rax	; keep a backup of the read buffer (contains 40 bits)
	mov rbx, 0x1F	; set 5 bit mask 0001 1111
	xor rdi,rdi

; Store the int value of the 5 pair bits in Result
Storebits:
	mov rax,rdx	; get the read buffer for working
	shr rax,cl	; shift to get 5 bits, cl-5 every loop
	and rax,rbx	; mask with 0001 1111 to kill high bits, only want 5

; Equiv logic for end of buffer
	cmp rbp,4	; if read buffer length is 4 or less
	ja Cont
	cmp rdi,r8	; and destination index above the stored number of 5bit pairs
	jb Cont
	mov al,0x20	; then fill the 0 with the value 0x20 that translates later to =

Cont:
	mov byte [Result+rdi],al; store in Result (rdi is offset, +1 each loop)
	inc rdi			; offset to store Result
	sub cl,5		; position of next 5 bit group is 5 less
	cmp rdi,r10		; after 8 bytes we are done
	jna Storebits		; loop if not above 7
	
	xor rsi,rsi		; clear rsi
	xor rdi,rdi		; and rdi

Translate:
	xor rbx,rbx		; clear rbx and rcx
	xor rcx,rcx		; used for temp storage
	
	mov bl, byte [Result+rsi]	; get the first number from Result in bl
	mov cl, byte [Table+rbx]	; translate the first number from Table into cl
	
; logic for printing newline
	cmp r9,76
	jne Nonl	; insert newline when 76th character
	mov byte [Res9+rdi],0x0A
	inc rdi		; also increase Result offset
	xor r9,r9	; and reset newline counter
	mov r10,8	; to read the correct amount of characters

Nonl:			; jump here when no newline has to be set
	cmp r10,7
	jne ResOther	; when Result length is 9 fill Res9
	mov byte [Result+rdi],cl	; put cl to Result
	
ResOther:
	mov byte [Res9+rdi],cl	; put cl to Result
	inc r9			; increase character counter for newline
	inc rsi			; increase rsi for next Result value
	inc rdi			; same for Result
	cmp rdi,r10		; same as above, exactly 8 rounds needed
	jna Translate		; loop if not yet completed

; print out the result
	cmp r10,8		; when 76th character was reached do this
	jne Norm		; else jump to standard 8 byte print
	mov rax,Res9		; where to read
	mov rbx,RESLEN9		; how long to read
	call PrintString	; call PrintString
	jmp Read		; go back to read the buffer

; Standard case when Result is 8 bytes long
Norm:
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
