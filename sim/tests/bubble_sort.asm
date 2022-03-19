;easy bubble sort implementation
addi r20, r0, 56
addi r21, r0, 3
addi r22, r0, 25
addi r23, r0, 2
addi r24, r0, 1

sw 0(r0), r20
sw 4(r0), r21
sw 8(r0), r22
sw 12(r0), r23
sw 16(r0), r24

nop
nop

addi r1, r0, 0      ;initialization
addi r5, r0, 5      ;loop counter

sort_loop:
addi r1 r0 0        ;pointer re-initialization
addi r8 r0 0        ;flag for swaps
nop
nop
inner_loop:
lw r10, 0(r1)
lw r11, 4(r1)
nop
nop
nop
sge r6 r11 r10
bnez r6 next_inn    ;if value pointed in position i+1 is bigger or equal than one pointed in position i, we don't swap and just go to the next iteration
sw 0(r1), r11
sw 4(r1), r10
addi r8 r0 1        ;raise flag if at least a swap during this pass
next_inn:
addi r1, r1, 4
slei r6 r1 12
bnez r6 inner_loop
beqz r8 done        ;if no swaps during last pass, we're done with the sorting, so we exit the loop early
subi r5 r5 1
bnez r5 sort_loop

done: