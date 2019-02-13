.section .data

.section .text
.globl _start
_start:
 pushq $10
 pushq $5
 call power




 # -4(rbp) = result?
 type .function, power
 power:
 pushq %rbp
 movq %rsp, $rbp
 subq $8, %rsp
 movq 8(%rbp), %rax #power
 movq 16(%rbp), %rbx
  
 movl $1, %eax
 int $0x80
