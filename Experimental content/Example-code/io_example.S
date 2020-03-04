    .data
stringaa1:
    .asciiz "Print this.\n"
strbuf:
    .space 10
	.set noreorder
    .set noat
    .text
.global main
main:
	jal readstr
	nop # important to make program happy
	li $v0, 4004
    li $a0, 1
    la $a1, strbuf
    li $a2, 12
    syscall
    li $v0, 4001
    syscall
	nop

.global readstr
readstr:
	li $v0, 4003
	li $a0, 0
	la $a1, strbuf
	li $a2, 10
	syscall
	jr $ra
	nop


