;modified version of the example provided on branch prediction

l0:
addi r3 r1 #5
subi r1 r3 #6
add r6 r3 r4
bnez r0,l0
sll r1,r10,r9
sra r2,r20,r3
bnez r0,l0
jal l3
l2:
j l4
l3:
add r6 r3 r4
addi r3 r1 #5
subi r1 r3 #6
beqz r0,l2
l4:
j l0