; Version	: 1.0
; Created at	: 22.10.2018
; Author	: Janick Stucki
; Description	: Loop through Msg and write UPPERCASE

section .data
	Msg: db "its wednesday my dudes",10
	MsgLen: equ $-Msg
	
section .bss

section .text
global _start

_start:
	nop
	mov rax,MsgLen
	dec rax
	mov rbx,Msg

loop:
	; modify letters
	sub byte [rbx],32
	inc rbx
	dec rax
	jnz loop

	; print out Msg
	mov rax,1
	mov rdi,1
	mov rsi,Msg
	mov rdx,MsgLen
	syscall

End:
	mov rax,60
	mov rdi,0
	syscall
