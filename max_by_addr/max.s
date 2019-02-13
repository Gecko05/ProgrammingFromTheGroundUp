#	This program finds the maximum number of a list of numbers hehe
#	Varibales:
#
#	%edi - Index of the data
#	%edx - Maximum value found so far
#	%eax - Current data
.section .data
_data_list:
 .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

 .section .text

 .globl _start

_start:
 mov $0, %edi
 movl _data_list(,%edi,4), %eax #load the first byte of data
 movl %eax, %ebx

start_loop:
 cmpl $0, %eax
 je loop_exit
 incl %edi		#load next value
 movl _data_list(,%edi,4), %eax
 cmpl %ebx, %eax
 jle start_loop

 movl %eax, %ebx
 jmp start_loop

loop_exit:
 movl $1, %eax
 int $0x80
