.section .data
_data:
 .long 1,2,3,4,5,6,7,8,9,10
.section .text
.globl _start
_start:
 mov _data(1,,), %ebx
 mov $1, %eax
 int $0x80
