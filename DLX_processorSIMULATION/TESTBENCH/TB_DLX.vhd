library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.CONSTANTS.all;

entity TB_dlx is
  generic ( RAM_DEPTH : integer := RAM_DEPTH;
			I_SIZE : integer :=  I_SIZE;
			ADDR_LEN : NATURAL := ADDR_LEN;
			DATA_LEN : NATURAL := DATA_LEN;
			MICROCODE_MEM_SIZE : integer := MICROCODE_MEM_SIZE;
			FUNC_SIZE          :     integer := FUNC_SIZE;  
			OP_CODE_SIZE       :     integer := OP_CODE_SIZE;
			ALU_OPC_SIZE       :     integer := ALU_OPC_SIZE; 
			IR_SIZE            :     integer := IR_SIZE;   
			CW_SIZE            :     integer := CW_SIZE);
end TB_dlx;

architecture tb of TB_dlx is

	component top_level is
	   generic ( RAM_DEPTH : integer; I_SIZE : integer ; ADDR_LEN : NATURAL; DATA_LEN : NATURAL ; MICROCODE_MEM_SIZE : integer; 
			FUNC_SIZE          :     integer;  
			OP_CODE_SIZE       :     integer;  
			ALU_OPC_SIZE       :     integer; 
			IR_SIZE            :     integer;      
			CW_SIZE            :     integer);
  		port (CLK, CLKNEG, RST: IN STD_LOGIC);
	end component top_level;	

	signal clk_s : std_logic := '0';		-- Clock 
	signal clkng_s: std_logic;
	signal reset_s : std_logic;		-- Reset:Active-Low



begin
	top: top_level GENERIC MAP( RAM_DEPTH => RAM_DEPTH, I_SIZE =>  I_SIZE, ADDR_LEN => ADDR_LEN,  DATA_LEN => DATA_LEN, MICROCODE_MEM_SIZE => MICROCODE_MEM_SIZE, FUNC_SIZE => FUNC_SIZE, OP_CODE_SIZE => OP_CODE_SIZE, ALU_OPC_SIZE => ALU_OPC_SIZE, IR_SIZE => IR_SIZE, CW_SIZE => CW_SIZE ) PORT MAP (CLK => clk_s , CLKNEG => clkng_s, RST => reset_s);

	
	ClockProcess :  process
	begin
		clk_s <= '0';
		clkng_s <= '1';
		WAIT FOR 10 ns;
		clk_s <= '1';
		clkng_s <= '0';
		WAIT FOR 10 ns;
	
	end process ClockProcess;
	
	vectorprocess :  process
	begin
		reset_s <= '1';
		WAIT for 10 ns;
		reset_s <= '0';
		WAIT FOR 3 us;
		reset_s <= '1';
		WAIT;
	end process vectorprocess;
	
	
end tb;
