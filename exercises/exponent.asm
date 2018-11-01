;  Executable name : Exponent procedure
;  Version         : 1.0
;  Created date    : 01.11.2018
;  Author          : Janick Stucki
;  Description     : Exponent procedure for other programs
;  Usage           : RAX^RCX
;  Result          : RAX

SECTION .data			; Section containing initialised data	

SECTION .bss			; Section containing uninitialized data	

SECTION .text			; Section containing code

global 	exponent		; Linker needs this to find the entry point!
	
exponent:
	nop			; used for debugger
	mov R9,RAX		; store argument in R9 (base)
	mov RAX,1		; starting result is 1

loop:
	mul R9			; RAX = RAX * R9
	dec RCX			; decrease exponent by 1
	jnz loop		; when exponent is 0 we are done

	; RAX contains result of RAX^RCX

