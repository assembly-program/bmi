# rdi holds the first argument
.global validation
.type validation, @function
validation:
    pushq %rbp
    movq %rsp, %rbp
    pushq %rbx
    pushq %rsi

    xor %rax, %rax
    movq %rdi, %rsi
    lodsb
    cmpb   $0, %al
	je 	   exit_valid
    cmpb $'.', %al
    jne validation+26
    movq $1, %rbx
    je LPV0
    cmpb $'0', %al      # validation+26
	jb exit_invalid
	cmpb $'9', %al
	ja exit_invalid
    jmp LPV0

sectionV0:
    cmpq $1, %rbx
    je  exit_invalid
    movq $1, %rbx

LPV0:
    lodsb
	cmpb   $0, %al
	je 	   exit_valid

    cmpb $'.', %al
    je sectionV0
	cmpb $'0', %al
	jb exit_invalid
	cmpb $'9', %al
	ja exit_invalid
    jmp LPV0

exit_invalid:
    movq $-1, %rax
    popq %rbx
    leave
    ret

exit_valid:
	movq $0, %rax
	popq %rsi
	popq %rbx
    leave
    ret
