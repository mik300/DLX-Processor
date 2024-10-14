addi r1, r0, #3 	;r1=3
xori r2, r2, #5 	;r2=5

ciclo:
addi r3, r3, #10	;r3=r3+10
sw 6(r2), r3		;store r3 in address 6+r2
subi r1, r1, #1		;decrement r1
addi r2, r2, #4		;r2=r2+4
nop
lw r5, 6(r2)
bnez r1, ciclo		;branch if r1 not equal to 0
xor r16,r17,r18		;dummy instruction to freeze pipeline after a branch
nop
jal end				;jump and link to the end of the code

addi r4, r0, #65535 
ori r5, r4, #100000
add r6, r4, r5

end:
j end





