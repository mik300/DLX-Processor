library IEEE;
use IEEE.std_logic_1164.all;
--use WORK.CONSTANTS.all;

entity writeback_unit is
  port 	 ( WB_MUXSEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		   WB_NPC3: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		   WB_LMD :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		   WB_ALUOUT :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		   WB_MUX_OUTPUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
end writeback_unit;


architecture STRUCT of writeback_unit is

	COMPONENT mux41_generic is
		Generic (NBIT: integer;  --defines input size
			 DELAY_MUX: Time); --defines the output delay during simulation
		Port (	A:	In	std_logic_vector(NBIT-1 downto 0) ;
				B:	In	std_logic_vector(NBIT-1 downto 0);
				C:	In	std_logic_vector(NBIT-1 downto 0);
				D:	In	std_logic_vector(NBIT-1 downto 0);
				SEL:	In	std_logic_vector(1 downto 0);
				Y:	Out	std_logic_vector(NBIT-1 downto 0));
	END COMPONENT mux41_generic; 

signal D_S: std_logic_vector(31 downto 0) := (others => '0');

begin

	MUX: mux41_generic GENERIC MAP(NBIT => 32, DELAY_MUX => 0 ns) PORT MAP (A => WB_NPC3, B => WB_LMD, C=> WB_ALUOUT, D => D_S, SEL => WB_MUXSEL, Y => WB_MUX_OUTPUT);	
	
end STRUCT;
