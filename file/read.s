.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

#standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

#system call interrupt
.equ LINUX_SYSCALL, 0x80

.equ END_OF_FILE, 0 

.equ NUMBER_ARGUMENTS, 2

.section .bss
 .equ BUFFER_SIZE, 500
 .lcomm BUFFER_DATA, BUFFER_SIZE

 .section .text

 #STACK POSITIONS
 .equ ST_SIZE_RESERVE, 16
 .equ ST_FD_IN, -8
 .equ ST_FD_OUT, -16
 .equ ST_ARGC, 0	#Number of arguments
 .equ ST_ARGV_0, 8	#Name of program
 .equ ST_ARGV_1, 16	#INput file name
 .equ ST_ARGV_2, 24	#Output file name

 .globl _start
_start:
 #save the stack pointer
 movq %rsp, %rbp
 #Allocate space for our file descriptors
 #on the stack
 subq $ST_SIZE_RESERVE, %rsp
 
open_files:
open_fd_in:
 #open syscall
 movq $SYS_OPEN, %rax
 #input filename into %rbx
 movq ST_ARGV_1(%rbp), %rbx
 #read-only flag 
 movq $O_RDONLY, %rcx
 #this doesn't really matter for reading
 movq $0666, %rdx
 #call Linux
 int $LINUX_SYSCALL

store_fd_in:
 #save the given file descriptor
 movq %rax, ST_FD_IN(%rbp)
 
open_fd_out:
 #open the file
 movq $SYS_OPEN, %rax
 #output filename into %rbx
 movq ST_ARGV_2(%rbp), %rbx
 #flags for writing to the file
 movq $O_CREAT_WRONLY_TRUNC, %rcx
 #mode for new file (if it's created)
 movq $0666, %rdx
 #call Linux
 int $LINUX_SYSCALL
 
store_fd_out:
 #store the file descriptor here
 movq %rax, ST_FD_OUT(%rbp)

 ###BEGIN MAIN LOOP###
read_loop_begin:

 ##READ IN A BLOCK FROM THE INPUT FILE###
 movq $SYS_READ, %rax
 #get the input file descriptor
 movq ST_FD_IN(%rbp), %rbx
 #the location to read into
 movq $BUFFER_DATA, %rcx
 #the size of the buffer
 movq $BUFFER_SIZE, %rdx
 #Size of buffer read is returned in %rax
 int $LINUX_SYSCALL

 ###EXIT IF WE'VE REACHED THE END###
 #check for end of file marker
 cmpq $END_OF_FILE, %rax
 #if found or onn error, go to the end
 jle end_loop

continue_read_loop:
 ###CONVERT THE BLOCK TO UPPER CASE###
 pushq $BUFFER_DATA	#location of buffer
 pushq %rax	#size of the buffer
 call convert_to_upper
 popq %rax	#get the size back
 addq $8, %rsp	#restore %rsp

 ###WRITE THE BLOCK OUT TO THE OUTPUT FILE###
 
 #size of the buffer
 movq %rax, %rdx
 movq $SYS_WRITE, %rax
 #file to use
 movq ST_FD_OUT(%rbp), %rbx
 #location of the buffer
 movq $BUFFER_DATA, %rcx
 int $LINUX_SYSCALL

 ###CONTINUE THE LOOP###
 jmp read_loop_begin

end_loop:
 ###CLOSE THE FILES###
 #NO NEED FOR ERROR CHECKING
 movq $SYS_CLOSE, %rax
 movq ST_FD_OUT(%rbp), %rbx
 int $LINUX_SYSCALL

 movq $SYS_CLOSE, %rax
 movq ST_FD_IN(%rbp), %rbx
 int $LINUX_SYSCALL

 ###EXIT###
 movq $SYS_EXIT, %rax
 movq $0, %rbx
 int $LINUX_SYSCALL

#PURPOSE: This function actually does the 
#	  conversion to upper case for a block
#VARIABLES:
#	%rax - beginning of buffer
#	%rbx - length of buffer
#	%rdi - current buffer offset
#	%cl - current byte being examined (first part of %rcx)

###CONSTANTS###
#The lower boundary of our search
.equ LOWERCASE_A, 'a'
#The upper boundary of our search
.equ LOWERCASE_Z, 'z'
#Conversion between upper and lower case
.equ UPPER_CONVERSION, 'A' - 'a'

###STACK STUFF###
.equ ST_BUFFER_LEN, 16 #Length of buffer
.equ ST_BUFFER, 24    #actual buffer
convert_to_upper:
 pushq %rbp
 movq %rsp, %rbp

###SET UP VARIABLES###
 movq ST_BUFFER(%rbp), %rax
 movq ST_BUFFER_LEN(%rbp), %rbx
 movq $0, %rdi

#if a buffer with zero length was given just leave
 cmpq $0, %rbx
 je end_convert_loop

convert_loop:
 #get the current byte
 movb (%rax, %rdi, 1), %cl
 #go to the next byte unless it is between
 #'a' and 'z'
 cmpb $LOWERCASE_A, %cl
 jl next_byte
 cmpb $LOWERCASE_Z, %cl
 jg next_byte

 #otherwise convert the byte to uppercase
 addb $UPPER_CONVERSION, %cl
 #and store it back
 movb %cl, (%rax, %rdi, 1)
next_byte:
 incq %rdi		#next byte
 cmpq %rdi, %rbx	#continue unless
			#we've reached end
 jne convert_loop

end_convert_loop:
 #no return value, just leave
 movq %rbp, %rsp
 popq %rbp
 ret
