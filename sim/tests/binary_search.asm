;binary search algorithm implementation

addi r20, r0, 2
addi r21, r0, 3
addi r22, r0, 7
addi r23, r0, 11
addi r24, r0, 13
addi r25, r0, 26
addi r26, r0, 78
addi r27, r0, 79
addi r28, r0, 90
addi r29, r0, 112


sw 0(r0), r20               ;here I save an ordered array (A) in memory
sw 4(r0), r21
sw 8(r0), r22
sw 12(r0), r23
sw 16(r0), r24
sw 20(r0), r25
sw 24(r0), r26
sw 28(r0), r27
sw 32(r0), r28
sw 36(r0), r29

addi r1 r0 0                ;initialization of lower/left bound (L)
addi r2 r0 9                ;initialization of higher/right bound (R)

addi r8 r0 78               ;value to be searched (S)


while_loop:                 
sgt r6 r1 r2                
bnez r6 done_fail           ;terminal condition, when R > L we exit, meaning we failed our search
add r3 r1 r2
srli r3 r3 1                ;m = floor((R+L)/2)
slli r7 r3 2
nop
nop
nop
lw r4 0(r7)                 ;r4 = A[m]
nop
nop
nop
seq r6 r4 r8
bnez r6 done_succ           ;if A[m] = S we exit, meaning we found the value we were looking for
sgt r6 r4 r8
bnez r6 cond_low            ;if A[m] > S jump to the second conditional, since it means we have to look in the lower half
addi r1 r3 1
j while_loop
cond_low:
subi r2 r3 1
j while_loop

done_succ:
add r10 r3 r0               ;save our final m in r10, indicating the index of the found value in the array
j end

done_fail:                  ;put -1 in r10 to signal the search failed, the value was not found inside the array
addi r10 r0 -1              
                            

end: