;long division algorithm https://en.wikipedia.org/wiki/Division_algorithm#Integer_division_(unsigned)_with_remainder
;this implementation works for every 32-bit unsigned integer

;r1 is the dividend (N), r2 is the divisor (D)
addi r1 r0 13
addi r2 r0 4

;inizialization, r5 is the counter for our while loop, will be called i from here on
addi r5 r0 32

;r3 is the register that will ultimately hold the quotient (Q), r4 will hold the remainder (R)
addi r3 r0 0
addi r4 r0 0

divide_loop:
subi r5 r5 1

slli r4 r4 1        
srl r7 r1 r5
andi r7 r7 1
or r4 r4 r7         ;set LSB of remainder to the i-th bit of N
slt r6 r4 r2
bnez r6 repeat_loop

;enter here if R >= D
sub r4 r4 r2        ;R = R - D    
addi r6 r0 1
sll r6 r6 r5
or r3 r3 r6         ;set the i-th bit of Q to 1
repeat_loop:
bnez r5 divide_loop

add r10 r3 r0       ;save final Q 
add r11 r4 r0       ;save final R