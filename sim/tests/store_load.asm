;test for store and load instruction for word, half-word and byte

addi r20, r0, -1
nop
nop
nop

sw 0(r0), r20
sh 4(r0), r20
sb 8(r0), r20
nop

lw r1, 0(r0)
lw r2, 4(r0)
lw r3, 8(r0)
lh r4, 0(r0)
lhu r5, 0(r0)
lb r6, 0(r0)
lbu r7, 0(r0)