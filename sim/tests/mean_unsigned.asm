;basic program to calculate the mean value of a 4-element array with signed values

addi r1, r0, 56
addi r2, r0, 3
addi r3, r0, 25
addi r4, r0, 2

sw 0(r0), r1                ;save the values in array (A) in memory
sw 4(r0), r2
sw 8(r0), r3
sw 12(r0), r4

addi r1, r0, 0              ;initialize the register that will hold the sum of the values (S)
addi r2, r0, 0              ;initialize pointer to load values (i)
addi r5, r0, 4              ;initialize counter for loop
nop
nop

loop:
lw r3, 0(r2)                ;load new value A[i]
nop
nop
nop
add r1, r1, r3              ;S += A[i]
addi r2, r2, 4              ;increment pointer
subi r5, r5, 1
bnez r5, loop

srli r10, r1, 2             ;save final value in r10 as S/4