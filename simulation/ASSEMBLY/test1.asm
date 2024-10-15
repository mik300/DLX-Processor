xori r1,r1,#27	;r1=27=0x1B
xori r2,r2,#54	;r2=54=0x36
nop
xor r3, r3, r3
nop
and r3,r1,r2 	;27 AND 54 = 18 = 0x12
sge r4, r1, r2  	;r4 will stay 0 because r1 is not greater or equal to r2  
sge r5, r2, r1		;r5 is set to 1
sgei r6, r1, #30	;r6 is not set to 1
sgei r7, r1, #26	;r7 is set to 1
sle r8, r1, r2  	;r8 is set to 1 because r1 is lower than or equal to r2 
sle r9, r2, r1		;r9 stays 0
slei r10, r1, #30	;r10 is set to 1
slei r11, r1, #26	;r11 is not set to 1
add r12,r1,r2		;r12=0x51
sub r13,r2,r1		;r13=0x1B
