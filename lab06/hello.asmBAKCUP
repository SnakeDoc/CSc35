# hello.asm, Author: Jason Sipula
# 3 shell commands to compile-link-run:
#   as hello.asm -o hello.o
#   ld hello -o hello
#   ./hello

.data                         # .data section starts
msg: .ascii "Hello, World!\n" # msg is ASCII chars (.ascii or .byte)
len: .int 14                  # msg length is 14 chars, an integer
                              # .int 32 bits, .word 16 bits, .byte 8 bits
.text                         # text (instruction code) section starts
.global _start                # _start is like main(), .global means public
                              # public symbols are for linker to link into runtime
_start:                       # _start starts here
   movl len,  %edx            # value 14 copied to CPU register edx
   movl $msg, %ecx            # memory addr of msg copied to CPU register ecx
   movl $1,   %ebx            # file descriptor 1 is computer display
   movl $4,   %eax            # system call 4 is sys_write (output)
   int  $128                  # interrupt 128 is entry to OS services

   movl $1,   %eax            # system call 1 is sys_exit (prog exits)
   movl $77,  %ebx            # status return (shell command: "echo $?" to see it)
   int  $128                  # call OS to do it via interrupt #128

