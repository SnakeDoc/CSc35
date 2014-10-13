# sub.s, Author: Jason Sipula, Derrick Sung

.data
    # stuff for poll()
    kbsec: .int 0      # num of sec
    kbmicro_sec: .int 0 # num of micro sec

    kb_stuff:     # needs 128 bytes for structured data
      .rept 128
        .byte 0
      .endr

    str:
        .ascii "                              "
    str_len:
        .int 30
    
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

    char:
        .ascii " "
    char_len:
        .int 1

.text
.global write, read, poll, star_loop

# Writes to screen
# To use from main program
#  push message, then push message length to stack
#  then call write()
#  ex: 
#    push $msg
#    push $msg_len
#    call write
write:
    push %ebp		# save base pointer
    mov %esp, %ebp	# new base pointer

    mov %ebp, %eax	# ebp + 8 is 2nd pushed
    add $8, %eax	# add 8 to ebp
    mov (%eax), %edx	# points to msg length
    add $4, %eax	# ebp + 12 is 1st pushed
    mov (%eax), %ecx	# points is msg addr

    mov $4, %eax	# print out msg
    mov $1, %ebx	# etc.
	
    int $0x80		# OS, serve!
    
    # prepare for exit
    leave
    ret

# Reads from stdin (keyboard)
# After calling, you must pop twice
#  the first pop will return the string length
#  the second pop will return the string
#  ex:
#    call read
#    pop %eax
#    pop %ebx
read:
    push %ebp           # save base pointer
    mov %esp, %ebp      # new base pointer

    mov $3, %eax
    mov $0, %ebx
    mov $str, %ecx
    mov $30, %edx
    int $0x80

    mov $str, %eax

    # prepare for exit
    leave
    ret

# Polls keyboard for ENTER key
#  saves result into %eax on stack
#   to retrieve value from main program
#   pop into a register
#   ex: pop %ecx
poll:
    push %ebp
    mov %esp, %ebp

    movl $0, kbsec
    movl $100000, kbmicro_sec
    movb $1, kb_stuff     # process STDIN channel

    mov $1, %ebx          # 1 channel, sys_select can be multichannel
    mov $kb_stuff, %ecx   # addr of file descriptor space
    mov $0, %edx          # nulify edx
    mov $0, %esi          # nulify esi
    mov $kbsec, %edi        # edi has addr of time period set above

    mov $142, %eax        # #142 is syscall 'sys_select'
    int $128

    # result is in %eax 

    # prepare for exit
    leave
    ret

star_loop:
    push %ebp
    mov %esp, %ebp

    mov %ebp, %eax      # ebp + 8 is 2nd pushed
    add $8, %eax        # add 8 to ebp
    mov (%eax), %edx    # points to msg length
    add $4, %eax        # ebp + 12 is 1st pushed
    mov (%eax), %ecx    # points is msg addr

    #mov 

    again:
        # write blank
        push $blank
        push blank_len
        call write

        # position cursor
        push $repos
        push repos_len
        call write

        # write char
        push $char
        push $1
        call write

        # position cursor
        push $repos1
        push repos1_len
        call write

        sub $1, col_count
        mov col_count, %eax
        cmp $0, %eax
        je reset_col

    reset_col:
        #write blank
        push $blank
        push blank_len
        call write

        # reset cursor
        push $pos
        push pos_len
        call write

        # reset column count
        mov col_count, %eax
        mov $80, %eax
        mov %eax, col_count

        # back into loop
        jmp again

    leave
    ret

