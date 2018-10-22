;  Executable name : EATSYSCALL64
;  Version         : 1.0
;  Created date    : 18.10.2018
;  Author          : Janick Stucki
;  Description     : A simple program in assembly for Linux, using NASM,
;
;    Looping over the Text 5 times
; 
;  Build using these commands:
;    nasm -f elf64 -g eatsyscall64.asm
;    ld -o eatsyscall64 eatsyscall64.o
;

SECTION .data			; Section containing initialised data	
	EatMsg: db "Eat at home :-)",10
	EatLen: equ $-EatMsg
	LoopNum: equ 5		; Loop 5 times
	
SECTION .bss			; Section containing uninitialized data	

SECTION .text			; Section containing code

global 	_start			; Linker needs this to find the entry point!
	
_start:
	nop			; This no-op keeps gdb happy...
	mov rdi, 1		  ; Specify File Descriptor 1: Standard Output
	mov rsi, EatMsg		  ; Pass offset of the message
	mov rdx, EatLen		  ; Pass the length of the message
	mov rax, LoopNum	; Put Loop number in rax for decreasing loop

Loop:
	mov rbx, rax		; store rax value in rbx
	mov rax,1		; Code for Sys_write call
	syscall			; print text
	mov rax, rbx		; more loop value back to rax
	dec rax			; rbx = rbx - 1
	jnz Loop

End:
	mov rax, 60		; Code for exit
	mov rdi, 0 		; Return a code of zero
	syscall			; Make kernel call



