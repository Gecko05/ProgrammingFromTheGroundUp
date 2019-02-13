.section .data
 _itemsData:
  .long 1,2,3,4,5,6,7,2,1
 _dataLen:
  .long 9
.section .text
.globl _start
_start:
  movl $0, %eax 	# Holding the index
  movl $0, %ebx   # Max number in ebx
 _loop:
  cmpl %eax, _dataLen
  je _exit 
  movl _itemsData(, %eax, 4), %edx
  cmpl %edx, %ebx
  jge _notmax
  movl %edx, %ebx
_notmax:
  incl %eax
  jmp _loop 
_exit:
  movl $1, %eax
  int $0x80


