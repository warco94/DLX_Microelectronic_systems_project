;euclidean algorithm for mcm and GCD calculation, for two numbers A and B

addi r1 r0 6            ;A
addi r2 r0 15           ;B

add r3 r1 r0            ;tmpA
add r4 r2 r0            ;tmpB

mcm_ext_while:          ;loop for mcm calculation
seq r6 r3 r4
bnez r6 done_mcm        ;terminal condition when tmpA = tmpB
mcm_while_ab:
sge r6 r3 r4
bnez r6 mcm_while_ba    ;the condition for this while loop is tmpA < tmpB, so we exit when tmpA >= tmpB
add r3 r3 r1            ;tmpA += A
j mcm_while_ab
mcm_while_ba:
sge r6 r4 r3
bnez r6 mcm_ext_while   ;the condition for this while loop is tmpB < tmpA, so we exit when tmpB >= tmpA
add r4 r4 r2            ;tmpB += B
j mcm_while_ba

done_mcm:

add r10 r3 r0           ;save mcm in r10

add r3 r1 r0            ;tmpA = A
add r4 r2 r0            ;tmpB = B

GCD_ext_while:          ;loop for GCD calculation
seq r6 r3 r4
bnez r6 done_GCD        ;terminal condition when tmpA = tmpB
GCD_while_ab:
sge r6 r3 r4
bnez r6 GCD_while_ba    ;the condition for this while loop is tmpA < tmpB, so we exit when tmpA >= tmpB
sub r4 r4 r3            ;tmpB -= tmpA
j GCD_while_ab
GCD_while_ba:
sge r6 r4 r3
bnez r6 GCD_ext_while   ;the condition for this while loop is tmpB < tmpA, so we exit when tmpB >= tmpA
sub r3 r3 r4            ;tmpA -= tmpB
j GCD_while_ba

done_GCD:

add r11 r3 r0           ;save GCD in r11