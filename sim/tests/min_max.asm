;program to find the min and max values in an array
addi r20, r0, 56
addi r21, r0, 3
addi r22, r0, 25
addi r23, r0, 2
addi r24, r0, 1

sw 0(r0), r20               ;here I save the array (A) in memory
sw 4(r0), r21
sw 8(r0), r22
sw 12(r0), r23
sw 16(r0), r24

addi r5, r0, 4              ;initialize counter for loop       
addi r2, r0, 0              ;initialize pointer for array
lw r10, 0(r2)               ;load first element of A in r10 (max)
nop
nop
nop
add r11, r0, r10            ;initialize r11 (min) with the same value as max
addi r2, r2, 4              ;increment pointer (i)
nop
nop
nop

loop:
lw r3, 0(r2)                ;load new element A[i] from array
nop
nop
nop
sgt r6, r3, r10 
bnez r6, set_max            ;if A[i] > max we found a new max
slt r6, r3, r11
bnez r6, set_min            ;if A[i] < min we found a new min
j repeat_loop
set_max:
add r10, r0, r3             ;update max value
j repeat_loop
set_min:
add r11, r0, r3             ;update min value
repeat_loop:
addi r2, r2, 4  
slei r6, r2, 16 
bnez r6, loop
nop
nop
nop
sw 20(r0), r10
sw 24(r0), r11
