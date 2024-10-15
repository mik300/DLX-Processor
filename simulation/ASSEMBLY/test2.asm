xori r1,r1,#184 	;r1=184=0xB8
xori r2,r2,#132 	;r2=132=0x84
xori r3,r3,#4		;r3=4
xori r10,r10,#149 	;r10=149=0x95
nop
xor r4, r4, r4
nop
cycle:
srli r10,r10,#2 	;arithmetic shift right by 2 bits, r10=0x25
srl r4,r1,r3		;arithmetic shift right by 4 bits, r4=0xB
sll r6,r1,r3		;logical shift left of r1 by 4 bits, r6=0xB80
slli r7,r2,#5		;r7=0x1080
sne r8,r1,r2		;r8 is set to 1 because r1 and r2 are not equal
snei r9,r1,#184		;r9 stays at 0 because r1 is equal to 184
xor r11,r11,r10 	;r11=r10
beqz r11, cycle		;branches only once
nop
xor r16,r16,r16
nop
j end
nop
xor r4,r4,r4
xori r17,r17,#82 	;r17, r18, r19 and r20 will stay 0 as these instructions are jumped over
xori r18,r18,#32 
xori r19,r19,#44	
xori r20,r20,#96
end:
xori r21,r21,#6
