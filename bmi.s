/*
    This program recieve 2 arguments: weight and height. which it uses to calculate bmi.
*/
.include "lib/readNumber.s"
.include "lib/printNumber.s"
.include "lib/validation.s"
.include "lib/sys_write.s"
.include "lib/sys_exit.s"

.global _start
.section .data
weight: .double 0
height: .double 0
bmi:    .double 0

usagemsg: .string "Usage: bmi <weight kg> <height m>\n"
usagemsg_len: .quad . - usagemsg

errormsg: .string "error: invalid input\n"
errormsg_len: .quad . - errormsg

.section .text
_start:
    movq %rsp, %rbp
    movq (%rbp), %rbx
    addq $8, %rbp   # skip argv[0], which contain the name of the file

    # the program must have 2 arguments, 3 including the program name
    cmpq $3, %rbx
    je section0

    cmpq $1, %rbx
    je exit_usage

	jmp exit_error

# read weight
section0:
    addq $8, %rbp       # rbp = argv[1]
    movq (%rbp), %rdi   # pass the string for validation
    call validation
    cmpq $0, %rax       # if not valid exit the program with an error
    jne exit_error

    movq (%rbp), %rdi   # pass the string to be parsed
    call readNumber     # the result is in %xmm0
    movsd %xmm0, weight(%rip)

# read height
section1:
    addq $8, %rbp       # rbp = argv[2]
    movq (%rbp), %rdi   # pass the string for validation
    call validation
    cmpq $0, %rax       # if not valid exit the program with an error
    jne exit_error

    movq (%rbp), %rdi   # pass the string to be parsed
    call readNumber     # the result is in %xmm0
    movsd %xmm0, height(%rip)

section2:
    # bmi = weight / (height * height)
    movsd height(%rip), %xmm1
    movsd weight(%rip), %xmm0
    mulsd   %xmm1, %xmm1
    divsd   %xmm1, %xmm0

    # print the result with 2 decimal points
    movq $2, %rdi
    call printNumber

exit_success:
    writeln $1     # print a new line before exiting
    exit $0

exit_usage:
    write $1, usagemsg(%rip), usagemsg_len     # write usage message
    exit  $-1

exit_error:
    write $1, errormsg(%rip), errormsg_len     # write error message
    write $1, usagemsg(%rip), usagemsg_len     # write usage message

    exit $-2
