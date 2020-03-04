	.data
int_value:
	.space 4
char_value:
	.space 1
stringaa1:
        .asciiz "\n"
	.text
.global main
main:
	li $t0,0 #记录总分
	li $t1,0 #记录上一波得分
	loop:
		li $v0, 4003
		li $a0, 0
		la $a1, char_value #读字符串
		li $a2, 1
		syscall

		li $s0,48
		li $s1,49
		li $s2,50
		lb $t2,($a1)
		#等于0则跳转到打印区
    	beq $t2,$s0,end
    	beq $t2,$s1,case1
    	beq $t2,$s2,case2
    	blt $t2,$s0,case4
    	bgt $t2,$s2,case4
    case1:
    	add $t0,$t0,1
    	li $t1,1
    	j loop
    case2:
    	li $t3,1
    	beq $t1,$t3,case3 
    	addi $t1,$t1,2
    	add $t0,$t0,$t1
    	j loop
    case3:
    	addi $t0,$t0,2
    	li $t1,2
    	j loop
    case4:
    	j loop
   	end:	
   			move $t1,$t0
			li $t7,10
			la $t6,char_value
			loop3:
				div $t1,10#将整数除10
				mflo $t1 #商赋值给t2做接下来的循环
				mfhi $t3 #t3储存余数
				addi $t3,$t3,48 #将余数装换为ascii码并存入t3
				add $t4,$t6,$t7 #用t4储存存储地址
				sb $t3,($t4)
				addi $t7,$t7,-1
				beqz $t1,print
				j loop3 

			print:
				li $v0, 4004 # mips abi __NR_write __NR_Linux+4
	        	move $a1, $t4
	        	li $t6,10
	        	sub $t6,$t6,$t7
	        	move $a2,$t6  
	        	syscall
		        li $v0, 4004 # mips abi __NR_write __NR_Linux+4
		        li $a0, 1
		        la $a1, stringaa1
		        li $a2, 1
		        syscall#helloworld
				li $v0,4001
				syscall
