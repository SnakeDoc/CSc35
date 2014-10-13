# 9.s, Author: Jason Sipula, Derrick Sung
# 3 shell commands to compile-link-run:
#    as 9.s -o 9.o
#    as sub.s -o sub.o
#    ld 9.o sub.o -o 9
#    ./9
#
#    as -a 9.s (to see memory map)

.data
    enter_msg:
        .ascii "Enter your full name: "
    enter_msg_len:
        .int 22

    name:
        .ascii ""
        .set name_len, .-name
    #name_len:
    #    .long 0

    clr:
        .byte 27
        .ascii "[2J" # ANSI terminal clear-screen cmd
    clr_len: .int 4

    which:
        .int 0 # which char from array

    junk:
        .byte 0

    star:
        .ascii " "
    star_len:
        .int 1

########################

    pos:
      .byte 27
      .ascii "[10;80H" # position cursor to line 10, column 30
    pos_len: .int 8

    repos:
      .byte 27
      .ascii "[2D"
    repos_len: .int 4

    repos1:
      .byte 27
      .ascii "[1D"
    repos1_len: .int 4

    blank: .ascii " "
    blank_len: .int 1

    col_count: .int 80


.text
.global _start

_start:

# clear screen
    push $clr
    push clr_len
    call write

# Print "Enter your full name: "
    push $enter_msg
    push enter_msg_len
    call write

# Read name in
    call read
    mov %eax, name

loop:
    mov name, %ecx
    add which, %ecx

    mov %ecx, star

    push star
    push star_len
    call write

    add $1, which
    
    mov which, %eax
    mov name_len, %ebx
    cmp %eax, %ebx
    jne loop


    # junk enter key
    #mov $3, %eax
    #mov $0, %ebx
    #mov $junk, %ecx
    #mov $1, %edx
    #int $0x80

# exit program
exit_prog:
    #push $clr
    #push clr_len
    #call write

    mov $1, %eax
    mov junk, %ebx
    int $0x80

