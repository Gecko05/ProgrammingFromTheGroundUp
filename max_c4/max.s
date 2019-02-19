.section .data
_dataList:
 .long 1, 2, 4, 5, 6, 7, 2, 3, 9, 0 #list must end in 0
 .section .text
 .globl _start
_start:
 pushq $_dataList
 call maximum
 movq %rax, %rbx
 movq $1, %rax
 int $0x80


.type maximum, @function
maximum:
 pushq %rbp
 movq %rsp, %rbp 
 movq 16(%rbp), %rcx
 movq $0, %rax # rax stores maximum
 movq $0, %rbx # rbx stores count
_cmpLoop:
 movl (%ecx, %ebx, 4), %edx
 cmpl $0, %edx
 je _endLoop
 incl %ebx
 cmpl %eax, %edx
 jle _cmpLoop
 movl %edx, %eax
 jmp _cmpLoop
_endLoop:
 popq %rbp
 ret
 
