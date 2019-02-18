.section .data

.section .text
.globl _start

_start:
 pushq $9
 call square
 movq %rax, %rbx
 movq $1, %rax
 int $0x80
.type square, @function
 square: 
 pushq %rbp
 movq %rsp, %rbp
 movq 16(%rbp), %rax
 movq %rax, %rbx
 imulq %rbx, %rax
 pop %rbp
 ret 
