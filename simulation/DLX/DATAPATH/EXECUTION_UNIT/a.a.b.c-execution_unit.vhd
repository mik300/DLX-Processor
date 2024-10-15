library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity execution_unit is
  port 	 ( EXEC_CK: IN std_logic;
		   RESET: IN std_logic;
		   EXEC_ALU_OPCODE: IN std_logic_vector(3 downto 0);
           EXEC_MUXA_SEL, EXEC_MUXB_SEL, EXEC_MUXBRANCH_SEL: IN std_logic;
           EXEC_ALU_OUTREG_EN: IN std_logic;
		   EXEC_EQ_COND: IN std_logic;
		   Reg_Rd2_LATCH_EN: IN std_logic;
		   DATAMEM_LATCH_EN: IN std_logic;
		   Reg_NPC3_EN: IN std_logic;
		   Rd1_OUT: IN std_logic_vector(4 downto 0);
		   EXEC_NPC2_OUT: IN std_logic_vector(31 downto 0);
		   EXEC_A, EXEC_B: IN std_logic_vector(31 downto 0);
		   EXEC_IMM: IN std_logic_vector(31 downto 0);
		   EXEC_UNIT_OUTPUT: OUT std_logic_vector (31 downto 0);
		   EXEC_COND_OUT: OUT std_logic;
		   Rd2_OUT: OUT std_logic_vector(4 downto 0);
		   NPC3_OUT: OUT std_logic_vector(31 downto 0);
		   DATAMEM_OUT: OUT std_logic_vector (31 downto 0));
end execution_unit;


architecture BEHAVIOR of execution_unit is

COMPONENT ALU is
       GENERIC( IVDELAY : time;
   		    NDDELAY : time;
   		    NDDELAYRISE : time;
   		    NDDELAYFALL : time;
   	        NRDELAY : time;
   			DRCAS : time;
   			DRCAC : time;
   			NumBit : integer;	
   			TP_MUX : time; 	
   			NBIT_EACH_BLOCK: INTEGER;
   			NBIT_BLOCKS: INTEGER;
   			NBIT : INTEGER);
  port 	 ( FUNC: IN std_logic_vector(3 downto 0);
           DATA1, DATA2: IN std_logic_vector(31 downto 0);
           OUTALU: OUT std_logic_vector(31 downto 0));
END COMPONENT ALU;

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

COMPONENT reg is
	Port 	(  CK:	In	std_logic;
			RESET:	In	std_logic;
			EN: In std_logic;
			D:	In	std_logic;
			Q:	Out	std_logic);
END COMPONENT reg;

COMPONENT reg_generic is
	generic (Nbits : integer);
	Port 	(  CK:	In	std_logic;
			RESET:	In	std_logic;
			EN:	In	std_logic;
			D:	In	std_logic_vector (Nbits-1 downto 0);
			Q:	Out	std_logic_vector (Nbits-1 downto 0));
end COMPONENT reg_generic;

COMPONENT mux21_1bit IS
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		SEL:	In	std_logic;
		Y:	Out	std_logic);
END COMPONENT mux21_1bit;

COMPONENT compare_zero is
	Port 	(  OP1:	In	std_logic_vector (31 downto 0);
			   compare_zero_output:	Out	std_logic);
END COMPONENT compare_zero;

COMPONENT AND_gate is
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		Y:	Out	std_logic);
END COMPONENT AND_gate;

signal MUX1_OUTPUT, MUX2_OUTPUT, ALU_OUTPUT, EXEC_NPC2_OUT_S, EXEC_A_S, EXEC_B_S, EXEC_IMM_S, EXEC_UNIT_OUTPUT_S: std_logic_vector (31 downto 0);
signal compare_zero_out, AND_gate_output, compare_zero_outNG: std_logic;
signal EXEC_CK_S, EXEC_COND_OUT_S, EXEC_MUXA_SEL_S, EXEC_MUXB_SEL_S, EXEC_MUXBRANCH_SEL_S,EXEC_MUXBRANCH_OUT_S,  EXEC_ALU_OUTREG_EN_S, EXEC_EQ_COND_S, Reg_Rd2_LATCH_EN_S, DATAMEM_LATCH_EN_S, Reg_NPC3_EN_S: std_logic;
signal EXEC_ALU_OPCODE_S: std_logic_vector(3 downto 0);
signal RESET_S: std_logic;
signal Rd1_OUT_S: std_logic_vector(4 downto 0);
signal EN_COND_REG: std_logic;	   

begin
	EN_COND_REG <= '1';
	EXEC_CK_S <= EXEC_CK;
	EXEC_ALU_OPCODE_S <= EXEC_ALU_OPCODE;
	EXEC_MUXA_SEL_S <= EXEC_MUXA_SEL;
	EXEC_MUXB_SEL_S <= EXEC_MUXB_SEL;
	EXEC_MUXBRANCH_SEL_S <= EXEC_MUXBRANCH_SEL;
	EXEC_ALU_OUTREG_EN_S <= EXEC_ALU_OUTREG_EN;
	EXEC_EQ_COND_S <= EXEC_EQ_COND;
	EXEC_NPC2_OUT_S <= EXEC_NPC2_OUT;
	EXEC_A_S <= EXEC_A;
	EXEC_B_S <= EXEC_B;
	EXEC_IMM_S <= EXEC_IMM;
	RESET_S <= RESET;
	Reg_Rd2_LATCH_EN_S <= Reg_Rd2_LATCH_EN;
	DATAMEM_LATCH_EN_S <= DATAMEM_LATCH_EN;
	Rd1_OUT_S <= Rd1_OUT;
	Reg_NPC3_EN_S <= Reg_NPC3_EN;
	compare_zero_outNG <= not(compare_zero_out);

	ALU_inst: ALU GENERIC MAP(IVDELAY => 0 ns,
   		    NDDELAY => 0 ns,
   		    NDDELAYRISE => 0 ns,
   		    NDDELAYFALL => 0 ns,
   	        NRDELAY => 0 ns,
   			DRCAS => 0 ns,
   			DRCAC => 0 ns,
   			NumBit => 32,	
   			TP_MUX => 0 ns, 	
   			NBIT_EACH_BLOCK => 4,
   			NBIT_BLOCKS => 8,
   			NBIT => 32) 
	PORT MAP (FUNC => EXEC_ALU_OPCODE_S, DATA1 => MUX1_OUTPUT, DATA2 => MUX2_OUTPUT, OUTALU => ALU_OUTPUT);

	MUX1: mux21_generic GENERIC MAP (NBIT => 32, DELAY_MUX => 0 ns) PORT MAP (A => EXEC_NPC2_OUT_S, B => EXEC_A_S, SEL => EXEC_MUXA_SEL_S, Y =>  MUX1_OUTPUT);

	MUX2: mux21_generic GENERIC MAP (NBIT => 32, DELAY_MUX => 0 ns) PORT MAP (A => EXEC_B_S, B => EXEC_IMM_S, SEL => EXEC_MUXB_SEL_S, Y => 			 MUX2_OUTPUT);

	MUXBRANCH: mux21_1bit PORT MAP (A => compare_zero_out, B => compare_zero_outNG, SEL => EXEC_MUXBRANCH_SEL_S, Y => EXEC_MUXBRANCH_OUT_S	);

	ZERO: compare_zero PORT MAP (OP1 => EXEC_A_S, compare_zero_output => compare_zero_out);

	AND_gate_inst: AND_gate PORT MAP (A => EXEC_MUXBRANCH_OUT_S, B => EXEC_EQ_COND_S, Y =>  AND_gate_output);

	COND: reg PORT MAP (CK => EXEC_CK_S, RESET => RESET_S, EN => EN_COND_REG, D => AND_gate_output, Q => EXEC_COND_OUT);

	ALU_OUTP: reg32 PORT MAP (CK => EXEC_CK_S, RESET => RESET_S, EN => EXEC_ALU_OUTREG_EN_S, D => ALU_OUTPUT, Q => EXEC_UNIT_OUTPUT);

	Reg_Rd2_inst: reg_generic GENERIC MAP (Nbits => 5) PORT MAP (CK => EXEC_CK_S, RESET => RESET_S, EN => Reg_Rd2_LATCH_EN_S, D => Rd1_OUT_S, Q => Rd2_OUT);

	Reg_DATAMEM_inst: reg_generic GENERIC MAP (Nbits => 32) PORT MAP (CK => EXEC_CK_S, RESET => RESET_S, EN => DATAMEM_LATCH_EN_S, D => EXEC_B_S, Q => 	DATAMEM_OUT);

	REG_NPC3_inst: reg32 PORT MAP (CK => EXEC_CK_S, RESET => RESET_S, EN => Reg_NPC3_EN_S, D => EXEC_NPC2_OUT_S, Q => NPC3_OUT);

end BEHAVIOR;

configuration CFG_execution_unit_BEHAVIORAL of execution_unit is
  for BEHAVIOR
  end for;
end CFG_execution_unit_BEHAVIORAL;
