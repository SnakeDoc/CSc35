# 8.s, Author: Jason Sipula
# 3 shell commands to compile-link-run:
#    as 8.s -o 8.out
#    ld 8.o -o 8
#    ./8
#
#    as -a 8.s (to see memory map)

.data
  clr:
    .byte 27
    .ascii "[2J" # ANSI terminal clear-screen cmd

  clr_len: .int 4

  pos:
    .byte 27
    .ascii "[10;79H" # position cursor to line 10, column 80 (columns 0 - 79)
  pos_len: .int 8

  repos:
    .byte 27
    .ascii "[2D"
  repos_len: .int 4

  repos2:
    .byte 27
    .ascii "[2D"
  repos2_len: .int 4

  msg: .ascii "*"
  msg_len: .int 1

  blank: .ascii " "
  blank_len: .int 1 

  col_count: .int 79

  sec: .int 0 # number of seconds
  nano_sec: .int 900000000 # 900M ns = 900 ms = .9 s

  kbmsg: .ascii "press Enter..."
  kbmsg_len: .int 14

  kbsec: .int 0	     # num of sec
  kbmicro_sec: .int 0 # num of micro sec

  kb_stuff:     # needs 128 bytes for structured data
    .rept 128
      .byte 0
    .endr

   keyin_char: .byte 0

.text
.global _start

_start:

  # clear screen   
  mov $4, %eax
  mov $1, %ebx
  mov $clr, %ecx
  mov clr_len, %edx
  int $128

  # write "press Enter..."
   mov $4, %eax
   mov $1, %ebx
   mov $kbmsg, %ecx
   mov kbmsg_len, %edx
   int $128

  # poitision cursor
   mov $4, %eax
   mov $1, %ebx
   mov $pos, %ecx
   mov pos_len, %edx
   int $128

  # write msg
   mov $4, %eax
   mov $1, %ebx
   mov $msg, %ecx
   mov msg_len, %edx
   int $128

  # poitision cursor
   mov $4, %eax
   mov $1, %ebx
   mov $repos, %ecx
   mov repos_len, %edx
   int $128

  # write blank (erase)
   mov $4, %eax
   mov $1, %ebx
   mov $blank, %ecx
   mov blank_len, %edx
   int $128


again:
  
  #write blank (erase)
  #mov $4, %eax
  #mov $1, %ebx
  #mov $blank, %ecx
  #mov blank_len, %edx
  #int $128

  # poitision cursor
   mov $4, %eax
   mov $1, %ebx
   mov $repos2, %ecx
   mov repos2_len, %edx
   int $128

  # write msg
   mov $4, %eax
   mov $1, %ebx
   mov $msg, %ecx
   mov msg_len, %edx
   int $128

  # poitision cursor
 #  mov $4, %eax
 #  mov $1, %ebx
 #  mov $repos, %ecx
 #  mov repos_len, %edx
 #  int $128

  # write blank (erase)
   mov $4, %eax
   mov $1, %ebx
   mov $blank, %ecx
   mov blank_len, %edx
   int $128

  sub $1, col_count
  mov col_count, %eax
  cmp $0, %eax

  je reset_col

  # keyboard poll
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

   cmp $0, %eax          # if 'enter' not pressed, eax is zero
   je again              # repeat poll

   jmp exit_prog

reset_col:

 # poitision cursor
   mov $4, %eax
   mov $1, %ebx
   mov $pos, %ecx
   mov pos_len, %edx
   int $128

  # write msg
  # mov $4, %eax
  # mov $1, %ebx
  # mov $msg, %ecx
  # mov msg_len, %edx
  # int $128

  mov col_count, %eax
  mov $79, %eax
  mov %eax, col_count

  jmp again

exit_prog:
  
  # clear screen
  mov $4, %eax
  mov $1, %ebx
  mov $clr, %ecx
  mov clr_len, %edx
  int $128


  # exit program
  mov $1, %eax
  int $128
