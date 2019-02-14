.section .data

.section .text
.globl _start

_start:
 pushq $7
 call factorial
 movq %rax, %rbx
 movq $1, %rax
 int $0x80

.type factorial, @function
factorial:
 pushq %rbp
 movq %rsp, %rbp
 movq 16(%rbp), %rax
 cmpq $1, %rax
 je _endfactorial
 decq %rax
 pushq %rax
 call factorial
 movq 16(%rbp), %rbx
 imulq %rbx, %rax
_endfactorial:
 movq %rbp, %rsp
 popq %rbp
 ret

