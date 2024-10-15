library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity fetch_unit is
  port 	 ( CLK: IN std_logic;
		   CLK_NEG: IN std_logic;
		   RST: IN std_logic;
           FETCH_PC_LATCH_EN :  IN STD_LOGIC;
           FETCH_NPC_LATCH_EN: IN STD_LOGIC;
		   FETCH_IR_LATCH_EN: IN STD_LOGIC;
		   FETCH_PC_UPDATE :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		   FETCH_IRAM_OUTPUT : IN std_logic_vector(31 downto 0); --signal coming from the Instruction memory
		   FETCH_PC_ADDRESS : OUT std_logic_vector(31 downto 0); --signal going to the Instruction memory
		   FETCH_NPC_OUTPUT: OUT std_logic_vector (31 downto 0);
		   FETCH_IR_TOCU: OUT std_logic_vector (31 downto 0);
		   FETCH_IR_OUTPUT: OUT std_logic_vector (31 downto 0));
end fetch_unit;


architecture STRUCT1 of fetch_unit is

	COMPONENT reg_generic2 is
		Port (  CK:	    In	std_logic;
				RESET:	In	std_logic;
				EN:     IN  std_logic;
				D:	    In	std_logic_vector (31 downto 0);
				Q:	    Out	std_logic_vector (31 downto 0));
	END COMPONENT reg_generic2; 

	COMPONENT reg_generic3 is
		Port (  CK:	    In	std_logic;
				RESET:	In	std_logic;
				EN:     IN  std_logic;
				D2:	    In	std_logic_vector (31 downto 0);
				Q2:	    Out	std_logic_vector (31 downto 0));
	END COMPONENT reg_generic3; 

SIGNAL PC_OUTPUT_S, IRAM_OUTPUT_S,  ADDER_OUTPUT_S , FETCH_PC_UPDATE_S: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL IR_OUTPUT_S, NPC_OUTPUT_S, FETCH_IRAM_OUTPUT_S : STD_LOGIC_VECTOR(31 DOWNTO 0);
		   

begin
	ADDER_OUTPUT_S <= PC_OUTPUT_S + X"00000004"; --adder implementation
	FETCH_IRAM_OUTPUT_S <= FETCH_IRAM_OUTPUT; 
	FETCH_PC_UPDATE_S <= FETCH_PC_UPDATE;
	
	PC: reg_generic2 PORT MAP (CK => CLK_NEG, RESET => RST, EN => FETCH_PC_LATCH_EN ,  D => FETCH_PC_UPDATE_S, Q => PC_OUTPUT_S ); ---D  => NPC_OUTPUT_S has to be changed once we connect everything
	IR: reg_generic2 PORT MAP (CK => CLK, RESET => RST, EN => FETCH_IR_LATCH_EN, D => FETCH_IRAM_OUTPUT_S, Q => IR_OUTPUT_S);
	NPC: reg_generic2 PORT MAP (CK => CLK, RESET => RST, EN => FETCH_NPC_LATCH_EN, D => ADDER_OUTPUT_S, Q => NPC_OUTPUT_S);
	--NPC: reg_generic3 PORT MAP (CK => CLK, RESET => RST, EN => FETCH_NPC_LATCH_EN, D2 => ADDER_OUTPUT_S, Q2 => NPC_OUTPUT_S);

	
	--Stage outputs
	FETCH_IR_OUTPUT <= IR_OUTPUT_S;
	FETCH_NPC_OUTPUT <= NPC_OUTPUT_S ;
	FETCH_PC_ADDRESS <= PC_OUTPUT_S;
	FETCH_IR_TOCU <= FETCH_IRAM_OUTPUT_S;


end STRUCT1;

