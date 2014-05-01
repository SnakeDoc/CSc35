# 7.s, Author: Jason Sipula
# 3 shell commands to compile-link-run:
#    as 7.s -o 7.out
#    ld 7.s -o 7
#    ./7
#
#    as -a 7.s (to see memory map)

.data                           # .data section begins
name: .ascii "JSN"              # name is ASCII chars (.ascii or .byte)
len:  .int 3                    # name length is 4 chars, an integer
newline: .ascii "\n"            # new line character

count: .int 0                   # counter for loop (start at 0)

return: .byte 0                 # return code value
char0: .byte 0                  # character
      .rept 3
          .byte 0
      .endr
char1: .byte 0                  # character
      .rept 3
          .byte 0
      .endr
char2: .byte 0                  # character
      .rept 3
          .byte 0
      .endr


.text                           # text section starts
.global _start                  # main program entry

_start:                         # start instruction

again:                          # begin loop

    mov $1, %edx                # 1 byte at a time
    mov $name, %ecx             # mem addr
    add count, %ecx             # offset in string

    mov count, %edi             # copy count value
    mov name(%edi), %ebx        # copy current char
    add %ebx, return            # add current char value to return value

    mov $1, %ebx                # file descriptor 1 is computer display
    mov $4, %eax                # system call 4 is sys_write (output)
    int $128                    # interrupt 128 is entry to OS services

    add $1, count               # incr count

    mov count, %eax             # copy count to eax
    cmp %eax, len               #   and compare values

    jne again                   # if not equal, goto again

    # begin new line Space (skip 1 line so we can print extra credit value)

    mov $newline, %ecx          # mem addr
    
    mov $1, %ebx                # file desc 1
    mov $4, %eax                # sys call 4
    int $128                    # interrupt 128
    mov $1, %eax                # system call 1 is sys_exit
   
    mov $newline, %ecx          # mem addr

    mov $1, %ebx                # file desc 1
    mov $4, %eax                # sys call 4
    int $128                    # interrupt 128

    # end new line space 

    ### Begin Extra Credit ###

    # Take each number, add 48 (0x30) to convert to ASCII char, then print
    mov return, %eax            # dividend
    mov $10, %ecx               # divisor
    mov $0, %edx                # clear reg
    idiv %ecx

    add $0x30, %edx             # convert to ASCII
    mov %edx, char0             # found ones digit

    # eax already set
    mov $10, %ecx               # divide again
    mov $0, %edx
    idiv %ecx

    add $0x30, %edx             # convert to ASCII
    mov %edx, char1             # found tens digit

    add $0x30, %eax             # convert to ASCII
    mov %eax, char2             # found hundreds digit

    mov $4, %eax                # display hundreds digit
    mov $1, %ebx
    mov $char2, %ecx
    mov $1, %edx
    int $0x80

    mov $4, %eax                # display tens digit
    mov $1, %ebx
    mov $char1, %ecx
    mov $1, %edx
    int $0x80

    mov $4, %eax                # display ones digit
    mov $1, %ebx
    mov $char0, %ecx
    mov $1, %edx
    int $0x80

    ### End Extra Credit ###
   
    # begin new line Space

    mov $newline, %ecx          # mem addr

    mov $1, %ebx                # file desc 1
    mov $4, %eax                # sys call 4
    int $128                    # interrupt 128
    
    mov $1, %eax                # system call 1 is sys_exit
    mov return, %ebx            # status return
    int $128                    # interrupt 128

