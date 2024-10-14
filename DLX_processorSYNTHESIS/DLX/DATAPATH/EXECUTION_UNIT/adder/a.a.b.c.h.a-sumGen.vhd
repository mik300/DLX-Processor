LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sumGen IS		
	GENERIC (NBIT_PER_BLOCK: INTEGER:= 1;
			 NBLOCKS: INTEGER:= 1);
	PORT (A:	IN	STD_LOGIC_VECTOR(NBIT_PER_BLOCK*NBLOCKS-1 DOWNTO 0);
		  B:	IN	STD_LOGIC_VECTOR(NBIT_PER_BLOCK*NBLOCKS-1 DOWNTO 0);
	      Ci:	IN	STD_LOGIC_VECTOR(NBLOCKS-1 DOWNTO 0); --Output of the sparse tree
		  Cinput: IN STD_LOGIC; --General Cinput 
	      S:	OUT	STD_LOGIC_VECTOR(NBIT_PER_BLOCK*NBLOCKS-1 DOWNTO 0));
END;

ARCHITECTURE STRUCTURAL OF sumGen IS
	COMPONENT carryselblock IS
		GENERIC( NBIT: INTEGER:= 1);
		PORT( cin: IN STD_LOGIC;
			  input1: IN STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0); ---Signal that goes in parallel to the RCA1 and the RCA2
			  input2: IN STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0); ---Signal that goes in parallel to the RCA1 and the RCA2
			  output: OUT STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0));
	END COMPONENT;

BEGIN
	carryblock: FOR i IN 0 TO (NBLOCKS-1) GENERATE
		exception1: IF(i = 0) GENERATE  
					selblock : carryselblock GENERIC MAP(NBIT => NBIT_PER_BLOCK) PORT MAP(cin => Cinput, input1 => A(((NBIT_PER_BLOCK * i) + (NBIT_PER_BLOCK-1)) DOWNTO (NBIT_PER_BLOCK * i)), input2 => B(((NBIT_PER_BLOCK * i) + (NBIT_PER_BLOCK-1)) DOWNTO (NBIT_PER_BLOCK * i)), output => S(((NBIT_PER_BLOCK * i) + (NBIT_PER_BLOCK-1)) DOWNTO (NBIT_PER_BLOCK * i)));
		END GENERATE exception1;
		
		
		others1 : IF(i /= 0) GENERATE
			selblock : carryselblock GENERIC MAP(NBIT => NBIT_PER_BLOCK) PORT MAP(cin => Ci(i-1), input1 => A(((NBIT_PER_BLOCK * i) + (NBIT_PER_BLOCK-1)) DOWNTO (NBIT_PER_BLOCK * i)), input2 => B(((NBIT_PER_BLOCK * i) + (NBIT_PER_BLOCK-1)) DOWNTO (NBIT_PER_BLOCK * i)), output => S(((NBIT_PER_BLOCK * i) + (NBIT_PER_BLOCK-1)) DOWNTO (NBIT_PER_BLOCK * i)));
		END GENERATE others1; 
	END GENERATE carryblock;

END ARCHITECTURE STRUCTURAL;
