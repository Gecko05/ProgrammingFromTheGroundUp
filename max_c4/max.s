.section .data
_dataList:
 .long 1, 2, 4, 5, 6, 7, 2, 3, 4, 0
 .section .text
 .globl _start
_start:
 pushq _dataList
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
 movq (%rcx, %rbx, 8), %rdx
 cmpq $0, %rdx
 je _endLoop
 incq %rbx
 cmpq %rax, %rdx
 jle _cmpLoop
 mov %rdx, %rax
 jmp _cmpLoop
_endLoop:
 pop %rbp
 ret
 
