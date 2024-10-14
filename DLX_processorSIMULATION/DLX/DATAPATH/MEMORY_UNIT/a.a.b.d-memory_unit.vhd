LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
--USE WORK.CONSTANTS.ALL;

ENTITY memory_unit IS

	PORT (CK: IN std_logic;
		  RESET: IN std_logic;
		  COND_REG_OUT: IN std_logic;
		  JUMP_EN: IN std_logic;
		  DRAM_WE: IN std_logic;
		  LMD_LATCH_EN: IN std_logic;
		  NPC_OUT: IN std_logic_vector(31 downto 0);
		  ALU_OUT: IN std_logic_vector(31 downto 0);
		  DATAMEM_OUT: IN std_logic_vector(31 downto 0);	  
		  MUX_PC_OUT: OUT std_logic_vector(31 downto 0);
		  FROMDATAMEM_DATA: IN std_logic_vector(31 downto 0); -- signal coming from the DRAM
		  TODRAM_ALUOUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --- signal going to the DRAM
		  TODATAMEM_OUT :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- signal going to the DRAM
		  LMD_OUT: OUT std_logic_vector(31 downto 0));

END memory_unit;

ARCHITECTURE BEHAVIOR OF memory_unit IS


COMPONENT mux21_generic is
Generic (NBIT: integer; DELAY_MUX: Time); 
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0) ;
		B:	In	std_logic_vector(NBIT-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0));
END COMPONENT mux21_generic;


COMPONENT reg32 is
	Port 	(  CK:	In	std_logic;
			RESET:	In	std_logic;
			EN: In std_logic;
			D:	In	std_logic_vector (31 downto 0);
			Q:	Out	std_logic_vector (31 downto 0));
END COMPONENT reg32; 

COMPONENT OR_GATE IS
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		Y:	Out	std_logic);
END COMPONENT OR_GATE;


SIGNAL CK_S, NOT_CK_S,RESET_S, COND_REG_OUT_S, JUMP_EN_S, DRAM_WE_S, LMD_LATCH_EN_S, OR_gate_OUT: std_logic;
SIGNAL NPC_OUT_S, ALU_OUT_S, DRAM_OUT: std_logic_vector (31 downto 0);

BEGIN

	CK_S <= CK;
	NOT_CK_S <= not CK;
	RESET_S <= RESET;
	COND_REG_OUT_S <= COND_REG_OUT;
	JUMP_EN_S <= JUMP_EN;
	DRAM_WE_S <= DRAM_WE;
	LMD_LATCH_EN_S <= LMD_LATCH_EN;
	NPC_OUT_S <= NPC_OUT;
	ALU_OUT_S <= ALU_OUT;

	--- outputs to the DRAM
	TODRAM_ALUOUT <= ALU_OUT(7 DOWNTO 0); -- Send the 15 LSB of the ALU output to the address input of the RAM
	TODATAMEM_OUT <= DATAMEM_OUT;
	


	LMD_REG_inst: reg32 PORT MAP (CK => NOT_CK_S, RESET => RESET_S, EN => LMD_LATCH_EN_S, D => FROMDATAMEM_DATA, Q => LMD_OUT);

	MUX_PC_inst: mux21_generic GENERIC MAP (NBIT => 32, DELAY_MUX => 0 ns) PORT MAP (A => NPC_OUT_S, B => ALU_OUT_S, SEL => OR_gate_OUT, Y => MUX_PC_OUT);

	OR_gate_inst: OR_gate PORT MAP (A => COND_REG_OUT_S, B => JUMP_EN_S, Y => OR_gate_OUT);



END BEHAVIOR;
