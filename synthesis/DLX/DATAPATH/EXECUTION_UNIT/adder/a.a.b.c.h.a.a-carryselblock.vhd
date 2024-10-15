LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY carryselblock IS
	GENERIC( NBIT: INTEGER := 1);
	PORT( cin: IN STD_LOGIC;
		  input1: IN STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0); ---Signal that goes in parallel to the RCA1 and the RCA2
		  input2: IN STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0); ---Signal that goes in parallel to the RCA1 and the RCA2
		  output: OUT STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0));
END;

ARCHITECTURE Structure OF carryselblock IS
	COMPONENT mux21_generic IS
		GENERIC (NBIT: INTEGER := 1);--defines input size
		PORT(	A:	IN	STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
				B:	IN	STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
				SEL:	IN	STD_LOGIC;
				Y:	OUT	STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0));
	END COMPONENT mux21_generic;

	COMPONENT rca IS
	 	GENERIC(NBIT : INTEGER := 1); 
		Port (	A:	In	STD_LOGIC_VECTOR(NBit-1 DOWNTO 0);  
				B:	IN  STD_LOGIC_VECTOR(NBit-1 DOWNTO 0);
				Ci:	IN	STD_LOGIC;
				S:	Out	STD_LOGIC_VECTOR(NBit-1 DOWNTO 0);
				Co:	Out	STD_LOGIC);
	
	END COMPONENT rca;

	SIGNAL rca1_out, rca2_out : STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
	SIGNAL Co1, Co2 : STD_LOGIC;


BEGIN
	rca1 : ENTITY WORK.rca(STRUCTURAL) GENERIC MAP(NBIT => NBIT ) PORT MAP(A => input1, B => input2, Ci => '0', S => rca1_out, Co => Co1); --RCA whose cin value is '0'
	rca2 : ENTITY WORK.rca(STRUCTURAL) GENERIC MAP(NBIT => NBIT ) PORT MAP(A => input1, B => input2, Ci => '1', S => rca2_out, Co => Co2); --RCA whose cin value es '1'
	mux1 : ENTITY WORK.mux21_generic(BEHAVIORAL) GENERIC MAP(NBIT => NBIT) PORT MAP(A => rca1_out, B => rca2_out, SEL => cin, Y => output);
	
END ARCHITECTURE;

