LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE WORK.constants.ALL;
ENTITY P4_ADDER IS
   GENERIC(
   			NumBit : integer := 32;		
   			NBIT_EACH_BLOCK: INTEGER := 4;
   			NBIT_BLOCKS: INTEGER := 8;
   			NBIT : INTEGER := 32);
	PORT (A :    IN	 STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
		  B :    IN	 STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
		  Cin :	 IN	 STD_LOGIC;
		  S :    OUT STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
	      Cout : OUT STD_LOGIC); 
END ENTITY;	

ARCHITECTURE STRUCT OF P4_ADDER IS
	COMPONENT sparse_tree_carry_gen is
		GENERIC (NBit: INTEGER := NBIT);
			PORT(A, B: IN STD_LOGIC_VECTOR(NBit - 1 DOWNTO 0);
				 Cin:  IN STD_LOGIC;
				 XORED_B: out std_logic_vector(NBit - 1 downto 0);
				 Cout: OUT STD_LOGIC_VECTOR((NBit - 1)/4 DOWNTO 0)); 
	END COMPONENT sparse_tree_carry_gen;

	COMPONENT sumGen IS		
		GENERIC (NBIT_PER_BLOCK: INTEGER;
				 NBLOCKS: INTEGER);
		PORT (A:	IN	STD_LOGIC_VECTOR(NBIT_PER_BLOCK*NBLOCKS-1 DOWNTO 0);
			  B:	IN	STD_LOGIC_VECTOR(NBIT_PER_BLOCK*NBLOCKS-1 DOWNTO 0);
			  Ci:	IN	STD_LOGIC_VECTOR(NBLOCKS-1 DOWNTO 0);
			  Cinput: IN STD_LOGIC;
			  S:	OUT	STD_LOGIC_VECTOR(NBIT_PER_BLOCK*NBLOCKS-1 DOWNTO 0));
	END COMPONENT sumGen;


	SIGNAL Co_s: STD_LOGIC_VECTOR(NBIT_BLOCKS-1 DOWNTO 0); --Signal that connects the sparse tree output with the sum generator 
	SIGNAL Cin_s : STD_LOGIC;
    SIGNAL XORED_B_s: STD_LOGIC_VECTOR(NBit - 1 downto 0);
BEGIN
	Cout <= Co_s(7);
	tree : sparse_tree_carry_gen GENERIC MAP(Nbit => NBIT_BLOCKS * NBIT_EACH_BLOCK) PORT MAP( A => A, B => B, Cin => Cin, XORED_B => XORED_B_s ,Cout => Co_s);
	sumNetwork : sumGen GENERIC MAP(NBIT_PER_BLOCK => NBIT_EACH_BLOCK, NBLOCKS => NBIT_BLOCKS) PORT MAP( A => A, B => XORED_B_s, Ci => Co_s, S => S, Cinput => Cin);
	
END ARCHITECTURE STRUCT; 
