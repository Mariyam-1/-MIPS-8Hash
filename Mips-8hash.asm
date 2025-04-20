.data
.text
main:
lw $s2, 0($a1)
lb $s2 , 0($s2) 
addi $s2 , $s2 , -48 # s2 has the input value<<<< x
jal hash_fn
add $s0 ,$zero , $v0
add $t0 , $zero , $zero
lui $t0 , 0x1001
sw  $s0 ,0 ($t0)
addi $v0, $zero, 10
syscall
hash_fn:
addi $t0,$zero,0x73 #my last two digits of id in hexa 
add $t1 , $s2 ,$zero
srl $t1 , $t1 ,  24
andi $t1 , $t1 , 0xFF
xor $v0 , $t0 ,$t1  #first xor
addi $sp ,$sp ,-4
sw $ra, 0($sp) #saving the value of ra because of overwriting
jal fx         # giving the result of xor to my function 
add $t1 , $s2 ,$zero
srl $t1 , $t1 , 16
andi $t1 , $t1 , 0xff
xor $v0 , $t0 ,$t1   #second xor
jal fx 
add $t1 , $s2 ,$zero
srl $t1 , $t1 , 8
andi $t1 , $t1 , 0xff
xor $v0 , $t0 ,$t1  #third xor
jal fx
add $t1 , $s2 ,$zero
srl $t1 , $t1 , 0
andi $t1 , $t1 , 0xff
xor $v0 , $t0 ,$t1   #forth xor
jal fx 
andi $v0  , $v0 ,0xFF
lw  $ra ,0($sp)
addi $sp ,$sp, 4
jr $ra

  fx:
 #loop for x(squared)#
 add $t2,$v0,$zero
 add $t0,$zero,$zero
 add $t1,$zero,$zero 
 loopsq :
 beq $t2,$t0,endsq
 add $t1,$t1,$t2         #t1 has xsquared
 addi $t0,$t0,1
 j loopsq
 endsq:
 #______________________________
 #loop for x cubed#
 addi $t0,$zero,0
 add $t9,$zero,$zero
 addi $t3,$v0,0
 loopx3: 
 beq $t0,$t3,endx3
 add $t9,$t9,$t1 # t9 has x^3
 addi $t0,$t0,1
 j loopx3
 endx3:
 #______________________________
 
 # F(x) = 1044x^3 - 86x^2 - 74x +236
 sll $t3,$t9,10   #1024x^3
 sll $t4,$t9,4    #16x^3
 sll $t5,$t9,2    #4x^3
 add $t3, $t3,$t4 
 add $t3, $t3,$t5  #t3=1044x^3
 
 sll $t4,$t1,6  #64x^2
 sll $t5,$t1,4    #16x
 sll $t6,$t1,2    #4x
 sll $t7,$t1,1    #2x
 add $t4, $t4,$t5  #
 add $t4, $t4,$t6  #
 add $t4, $t4,$t7 #
 sub $t4,$zero,$t4 #t4= -86x^2
 
 add $t5 ,$t3,$t4 #1044x^3 - 86x^2
 
# calculating  - 74x +236
 sll $t6,$t2,6 
 sll $t4,$t2,3    
 sll $t7,$t2,1  
 add $t6,$t6,$t4
 add $t6,$t7,$t6
 sub $t6,$zero,$t6
 addi $t6,$t6,236 # - 74x +236
 
add $t0 , $t6 ,$t5   # 1044x^3 - 86x^2 - 74x +236
andi $t0 ,$t0 ,0xFF # taking the least 8 significant bits 
add $v0, $t0, $zero 
jr $ra

