SECTION .data			; Section containing initialised data	
	EatMsg: db "Eat at home :-)",10
	EatLen: equ $-EatMsg
	LoopNum: equ 5		; Loop 5 times
	
SECTION .bss			; Section containing uninitialized data	

SECTION .text			; Section containing code

global 	_start			; Linker needs this to find the entry point!
	
_start:
	nop			; This no-op keeps gdb happy...
	mov rsi, EatMsg		; Pass offset of the message
	mov rdx, EatLen		; Pass the length of the message
	mov rbx, LoopNum	; Put Loop number in rax for decreasing loop

Loop:
	mov rax, 1		; Code for Sys_write call
	mov rdi, 1		; Specify File Descriptor 1: Standard Output
	syscall			; print text
	dec rbx			; decrease rbx by 1
	jnz Loop		; goto Loop if not 0 (rbx)

End:
	mov rax, 60		; Code for exit
	mov rdi, 0 		; Return a code of zero
	syscall			; Make kernel call

