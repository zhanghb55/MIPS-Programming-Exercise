    .data
char_value:
    .space 12
stringaa1:
        .asciiz "\n"
int_array:
	.space 40
    .text
.global main
main:
	li $t0,0 #计数变量
	li $t2,0 #存整数的变量
	loop:
	li $t1,0 #读字符的的临时变量
	li $t3,0 #存48和57的临时变量
	la $s0, char_value #将char的地址存到s0寄存器
		loop1:
			bge $t0,10,sort #如果计数变量大于等于10则跳转，对应C代码中的break
			li $v0, 4003	#调用read函数
			li $a0, 0
			la $a1, char_value
			li $a2, 1
			syscall #读char，对应C代码中的getchar函数

			lb  $t1,0($s0)	#将读取的字节存到char变量中，便于下一步操作
			#接下来就判断读进来的字符是否在'0'到'9'之间，若不是则跳转到存数操作
			li $t3,47
			ble $t1,$t3,oper_1
			li $t3,58
			bge $t1,$t3,oper_1
			#将ASCII码减48得到字符对应的数字
			addi $t1,$t1,-48
			#然后更新当前读取的数字
			mul $t2,$t2,10
			add $t2,$t1,$t2
			#继续循环
			j loop1
	#若读取的是空格或回车等非数字字符，跳转到此处进行存数操作
	oper_1:
		la $a1,int_array
		mul $t4,$t0,4 #偏移量
		add $a1,$a1,$t4
		sw $t2,0($a1)
		addi $t0,$t0,1
		li $t2,0 #存整数的变量
		j loop

	sort:
		li $t0,-1		 #外层计数变量
		la $a1,int_array #整数数组的首地址
		loop4:			 #外层循环
			addi $t0,$t0,1
			bge $t0,10,end#如果外层计数变量到10则结束循环跳转到后面的end部分
			li $t1,-1	  #内层计数变量
			loop5:		 #内层循环
				addi $t1,$t1,1
				mul $t2,$t1,4
				bge $t1,9,loop4 #内层循环计数变量到达9则跳回外层循环
				add $t3,$a1,$t2	#获取当前数组中当前内存计数变量对应的索引的地址
				addi $t4,$t3,4	#获取当前数组中当前内存计数变量加1对应的索引的地址
				lw $t5,($t3)	#取值
				lw $t6,($t4)	#取值
				bgt $t6,$t5,swap#若出现a[j] < a[j+1] 则交换两段内存中的值
				j loop5

			swap:			#交换语句
				sw $t6,($t3)
				sw $t5,($t4)
				j loop5

	end:
		li $t0,-1 #第i个整数的索引
		loop2:
			li $t7,10     	#偏移量初始化为10
			la $t6,char_value
			la $a1,int_array #整数数组的首地址
			addi $t0,$t0,1
			bge $t0,10,bye	#处理完数组则跳转到结束部分
			mul $t1,$t0,4 #乘4得到偏移量
			add $a1,$a1,$t1#第i个整数的地址
			lw $t2,($a1) #取出第i个整数并存放在t2
			loop3:
				div $t2,10#将整数除10
				mflo $t2 #商赋值给t2做接下来的循环
				mfhi $t3 #t3储存余数
				addi $t3,$t3,48 #将余数装换为ascii码并存入t3
				add $t4,$t6,$t7 #用t4储存存储地址
				sb $t3,($t4)	#将t3存储到t4指向的地址
				addi $t7,$t7,-1 #偏移量减1
				beqz $t2,print
				j loop3

			print:
				li $v0, 4004 
	        	move $a1, $t4
	        	li $t6,10
	        	sub $t6,$t6,$t7
	        	move $a2,$t6  
	        	syscall 	#输出字符串表示的整数
		        li $v0, 4004
		        li $a0, 1
		        la $a1, stringaa1
		        li $a2, 1
		        syscall #输出换行符
	        	j loop2


	bye:
		li $v0,4001
		syscall
