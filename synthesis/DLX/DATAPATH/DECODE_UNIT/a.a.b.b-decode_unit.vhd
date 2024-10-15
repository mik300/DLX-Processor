LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
--USE WORK.CONSTANTS.ALL;


ENTITY decode_unit IS

	PORT (CK: IN std_logic;
		  RESET: IN std_logic;
		  RegA_LATCH_EN: IN std_logic;
		  RegB_LATCH_EN: IN std_logic;
		  RegIMM_LATCH_EN: IN std_logic;
		  RF_WE: IN std_logic;
		  MUX_Rd_SEL: IN std_logic;
		  MUX_JAL_SEL: IN std_logic; 
		  Reg_Rd_LATCH_EN: IN std_logic;
		  MUX_IMM_SEL: IN std_logic;
		  Reg_NPC2_EN: IN std_logic;
		  Reg_Rd2_OUT: IN std_logic_vector(4 downto 0);
	      IR_OUT: IN std_logic_vector(31 downto 0);
		  WR_OUT: IN std_logic_vector(31 downto 0);
		  NPC_OUT: IN std_logic_vector(31 downto 0);
		  RegA_out: OUT std_logic_vector(31 downto 0);
		  RegB_out: OUT std_logic_vector(31 downto 0);
	      RegIMM_out: OUT std_logic_vector(31 downto 0);
		  NPC2_OUT: OUT std_logic_vector(31 downto 0);
		  Rd1_OUT: OUT std_logic_vector(4 downto 0));

END decode_unit;

ARCHITECTURE BEHAVIOR2 OF decode_unit IS

COMPONENT register_file IS
	GENERIC( ADDR_LEN : NATURAL := 5;
			 DATA_LEN : NATURAL := 32);
	PORT (CLK:      IN  std_logic;
          RESET: 	IN  std_logic;
	      WR: 		IN  std_logic;
	      ADD_WR: 	IN  std_logic_vector(ADDR_LEN-1 DOWNTO 0);
	      ADD_RD1: 	IN  std_logic_vector(ADDR_LEN-1 DOWNTO 0);
	      ADD_RD2: 	IN  std_logic_vector(ADDR_LEN-1 DOWNTO 0);
	      DATAIN: 	IN  std_logic_vector(DATA_LEN-1 DOWNTO 0); --1 WRITE AT A TIME
          OUT1:     OUT std_logic_vector(DATA_LEN-1 DOWNTO 0); --2 READS AT A TIME
	      OUT2:     OUT std_logic_vector(DATA_LEN-1 DOWNTO 0));

END COMPONENT register_file;

COMPONENT sign_extend IS

	PORT (DATAIN: IN std_logic_vector(15 downto 0);
		  DATAOUT: OUT std_logic_vector(31 downto 0));

END COMPONENT sign_extend;

COMPONENT sign_extend26 IS

	PORT (DATAIN: IN std_logic_vector(25 downto 0);
		  DATAOUT: OUT std_logic_vector(31 downto 0));

END COMPONENT sign_extend26;

COMPONENT reg32 is
	Port 	(CK:	In	std_logic;
			RESET:	In	std_logic;
			EN: IN std_logic;
			D:	In	std_logic_vector (31 downto 0);
			Q:	Out	std_logic_vector (31 downto 0));
end COMPONENT reg32;

COMPONENT reg_generic is
	generic (Nbits : integer := 5);
	Port 	(  CK:	In	std_logic;
			RESET:	In	std_logic;
			EN:	In	std_logic;
			D:	In	std_logic_vector (Nbits-1 downto 0);
			Q:	Out	std_logic_vector (Nbits-1 downto 0));
end COMPONENT reg_generic;

COMPONENT mux21_generic is
Generic (NBIT: integer := 5); 
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0) ;
		B:	In	std_logic_vector(NBIT-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0));
END COMPONENT mux21_generic;

SIGNAL CK_S, RESET_S, RegA_LATCH_EN_S, RegB_LATCH_EN_S, RegIMM_LATCH_EN_S, RF_WE_S, MUX_Rd_SEL_S, MUX_JAL_SEL_S, Reg_Rd_LATCH_EN_S, MUX_IMM_SEL_S, Reg_NPC2_EN_S: std_logic;
SIGNAL IR_OUT_S, WR_OUT_S, RegA_IN_S, RegB_IN_S, RegIMM_IN_S, MUX_IMM_16, MUX_IMM_26, NPC_OUT_S: std_logic_vector (31 downto 0);
SIGNAL MUX_Rd1_OUT_S, Reg_Rd2_OUT_S, MUX_JAL_OUT_S : std_logic_vector (4 downto 0);
SIGNAL all_ones: std_logic_vector(4 downto 0);

BEGIN

CK_S <= CK;
RESET_S <= RESET;
RegA_LATCH_EN_S <= RegA_LATCH_EN;
RegB_LATCH_EN_S <= RegB_LATCH_EN;
RegIMM_LATCH_EN_S <= RegIMM_LATCH_EN;
RF_WE_S <= RF_WE;
IR_OUT_S <= IR_OUT;
WR_OUT_S <= WR_OUT;
MUX_Rd_SEL_S <= MUX_Rd_SEL;
MUX_JAL_SEL_S <= MUX_JAL_SEL;
Reg_Rd2_OUT_S <= Reg_Rd2_OUT;
Reg_Rd_LATCH_EN_S <= Reg_Rd_LATCH_EN;
MUX_IMM_SEL_S <= MUX_IMM_SEL;
NPC_OUT_S <= NPC_OUT;
Reg_NPC2_EN_S <= Reg_NPC2_EN;
all_ones <= "11111";


RF_inst: register_file GENERIC MAP (ADDR_LEN => 5, DATA_LEN => 32) PORT MAP (CLK => CK_S, RESET => RESET_S, WR => RF_WE_S, ADD_WR => Reg_Rd2_OUT, ADD_RD1 => IR_OUT_S(25 downto 21), ADD_RD2 => IR_OUT_S(20 downto 16), DATAIN => WR_OUT_S, OUT1 => RegA_IN_S, OUT2 => RegB_IN_S);

SIGN_inst: sign_extend PORT MAP (DATAIN => IR_OUT_S(15 downto 0), DATAOUT => MUX_IMM_16);

SIGN26_inst: sign_extend26 PORT MAP (DATAIN => IR_OUT_S(25 downto 0), DATAOUT => MUX_IMM_26);

RegA_inst: reg32 PORT MAP (CK => CK_S, RESET => RESET_S, EN => RegA_LATCH_EN_S, D => RegA_IN_S, Q => RegA_out);

RegB_inst: reg32 PORT MAP (CK => CK_S, RESET => RESET_S, EN => RegB_LATCH_EN_S, D => RegB_IN_S, Q => RegB_out);

RegIMM_inst: reg32 PORT MAP (CK => CK_S, RESET => RESET_S, EN => RegIMM_LATCH_EN_S, D => RegIMM_IN_S, Q => RegIMM_out);

Reg_Rd1_inst: reg_generic GENERIC MAP (Nbits => 5) PORT MAP (CK => CK_S, RESET => RESET_S, EN => Reg_Rd_LATCH_EN_S, D => MUX_JAL_OUT_S, Q => Rd1_OUT);

MUX_Rd1: mux21_generic GENERIC MAP (NBIT => 5) PORT MAP (A => IR_OUT_S(20 downto 16), B => IR_OUT_S(15 downto 11), SEL => MUX_Rd_SEL_S, Y => MUX_Rd1_OUT_S);

MUX_JAL: mux21_generic GENERIC MAP (NBIT => 5) PORT MAP (A => MUX_Rd1_OUT_S, B => all_ones, SEL => MUX_JAL_SEL_S, Y => MUX_JAL_OUT_S );

MUX_IMM: mux21_generic GENERIC MAP (NBIT => 32) PORT MAP (A => MUX_IMM_16, B => MUX_IMM_26, SEL => MUX_IMM_SEL_S, Y => RegIMM_IN_S);

REG_NPC2_inst: reg32 PORT MAP (CK => CK_S, RESET => RESET_S, EN => Reg_NPC2_EN_S, D => NPC_OUT_S, Q => NPC2_OUT);

END BEHAVIOR2;
