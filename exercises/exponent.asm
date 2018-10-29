; Version	: 1.0
; Created at	: 22.10.2018
; Author	: Janick Stucki
; Description	: Calculate x exponent expo

section .data
	num dd 35.0	; data double word 32bit
	x dq 5		; number quad word
	expo dq 3	; exponent quad word 8 bytes, 64bit
	
section .bss

section .text
global _start

_start:
	nop
	xor rax,rax	; reset of rax, all bits to 0
	mov eax,[num]	; 32bit register needed for num
	mov r15,rax	; copy it in r15
	nop
	mov rbx,[x]	; number to rbx (64bit)
	mov rcx,[expo]	; exponent to rcx
	mov rax,1	; start with 1 as result

Calc:
	mul rbx		; rax = rax * rbx -> 1 * rbx
	dec rcx		; decrease exponent by 1
	jnz Calc	; if rcx not 0 calc again

End:
	mov rax,60	; standard exit lines
	mov rdi,0
	syscall
