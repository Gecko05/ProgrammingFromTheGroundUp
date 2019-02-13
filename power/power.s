.section .data

.section .text

.globl _start
_start:
 pushq $3
 pushq $5
 call power
 addq $16, %rsp
 pushq %rax
 pushq $2
 pushq $4
 call power
 addq $16, %rsp
 popq %rbx
 addq %rax, %rbx
 movq $1, %rax
 int $0x80

# Function POWER
#
# Description: Takes two arguments, sets the first one
# to the power of the second argument
#
# Input:	First argument - the base number
# 		Second arugment - the power to raise
#
# Output:	It will give the result as a return value
#
# Notes: 	The power must be 1 or greater
#
# Variables: 	-4(%ebp) return value
# 		%eax base number
# 		%ebx power
#		%ecx auxiliar storage
.type power, @function
power:
 pushq %rbp
 movq %rsp, %rbp 
 subq $8, %rsp
 movq 16(%rbp), %rax
 movq 24(%rbp), %rbx
 movq %rax, %rcx
_loopPow: 
 cmpq $1, %rbx
 je _endPow
 imulq %rax, %rcx 
 decq %rbx
 movq %rcx, -8(%rbp)
 jmp _loopPow
_endPow:
 movq -8(%rbp), %rax
 movq %rbp, %rsp
 popq %rbp
 ret
 
 
