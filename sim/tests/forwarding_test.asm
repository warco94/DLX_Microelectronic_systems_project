;simple test program to test forwarding, every instruction after the first one uses values from the previous one

addi r1, r0, 1
addi r2, r1, 1
add r3, r1, r2
subi r4, r3, 1
sub r5, r3, r4
slli r6, r5, 1
sll r7, r6, r6
srli r8, r7, 1
srl r9, r8, r5
sgt r10, r3, r1
slt r11, r10, r3
sgti r12, r11, 0
slti r13, r12, 2
sne r14, r13, r3
snei r15, r14, 2
seq r16, r15, r14
seqi r17, r16, 1
and r18, r17, r16
andi r19, r18, 1
or r20, r19, r0
ori r21, r20, 0
xor r22, r21, r2
xori r23, r22, 1