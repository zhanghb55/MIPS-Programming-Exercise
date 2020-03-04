        .data
stringaa1:
        .asciiz "Print this.\n"
        .set noreorder
        .set noat
.global main
        .text
main:
        li $v0, 4004 # mips abi __NR_write __NR_Linux+4
        li $a0, 1
        la $a1, stringaa1
        #lui $1, %hi(stringaa1)
        #addiu $5, $1, %lo(stringaa1)
        li $a2, 12
        syscall
        li $v0, 4001 # mips abi __NR_exit __NR_Linux+1
        syscall
