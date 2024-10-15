library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use work.constants.all;

entity Tb_control is
end Tb_control;

architecture testbench of Tb_control is

	component dlx_cu
	  generic (
		MICROCODE_MEM_SIZE :     integer;  -- Microcode Memory Size
		FUNC_SIZE          :     integer;  -- Func Field Size for R-Type Ops
		OP_CODE_SIZE       :     integer;  -- Op Code Size
		ALU_OPC_SIZE       :     integer;  -- ALU Op Code Word Size
		IR_SIZE            :     integer;  -- Instruction Register Size    
		CW_SIZE            :     integer);  -- Control Word Size
	  port (
		Clk                : in  std_logic;  -- Clock
		Rst                : in  std_logic;  -- Reset:Active-Low
		-- Instruction Register
		IR_IN              : in  std_logic_vector(IR_SIZE - 1 downto 0); 
		
		-- IF Control Signal
		IR_LATCH_EN        : out std_logic;  -- Instruction Register Latch Enable
		NPC_LATCH_EN       : out std_logic;
		                                    -- NextProgramCounter Register Latch Enable
		-- ID Control Signals
		RegA_LATCH_EN      : out std_logic;  -- Register A Latch Enable
		RegB_LATCH_EN      : out std_logic;  -- Register B Latch Enable
		RegIMM_LATCH_EN    : out std_logic;  -- Immediate Register Latch Enable

		-- EX Control Signals
		MUXA_SEL           : out std_logic;  -- MUX-A Sel
		MUXB_SEL           : out std_logic;  -- MUX-B Sel
		ALU_OUTREG_EN      : out std_logic;  -- ALU Output Register Enable
		EQ_COND            : out std_logic;  -- Branch if (not) Equal to Zero

		-- ALU Operation Code
		ALU_OPCODE         : out STD_LOGIC_VECTOR(ALU_OPC_SIZE-1 DOWNTO 0); 

		-- MEM Control Signals
		DRAM_WE            : out std_logic;  -- Data RAM Write Enable
		LMD_LATCH_EN       : out std_logic;  -- LMD Register Latch Enable
		JUMP_EN            : out std_logic;  -- JUMP Enable Signal for PC input MUX
		PC_LATCH_EN        : out std_logic;  -- Program Counte Latch Enable

		-- WB Control signals
		WB_MUX_SEL         : out std_logic;  -- Write Back MUX Sel
		RF_WE              : out std_logic);  -- Register File Write Enable

	end component dlx_cu;

	signal clk: std_logic := '0';
	signal rst: std_logic := '1';

	signal IR_LATCH_EN_i, NPC_LATCH_EN_i, RegA_LATCH_EN_i, RegB_LATCH_EN_i, RegIMM_LATCH_EN_i, MUXA_SEL_i, MUXB_SEL_i,  ALU_OUTREG_EN_i, EQ_COND_i, DRAM_WE_i, LMD_LATCH_EN_i, JUMP_EN_i, PC_LATCH_EN_i, WB_MUX_SEL_i, RF_WE_i : std_logic := '0';
	signal ALU_OPCODE_i: STD_LOGIC_VECTOR(ALU_OPC_SIZE-1 DOWNTO 0) := (others => '0');
	
	signal cw, cw_expected : std_logic_vector(CW_SIZE- 1  + ALU_OPC_SIZE downto 0) := (OTHERS => '0'); --We add here the ALUOPCODE output as well
	signal IR_IN_i : std_logic_vector(IR_SIZE - 1 downto 0) := (OTHERS => '0'); 

begin

	cw <= IR_LATCH_EN_i & NPC_LATCH_EN_i & RegA_LATCH_EN_i & RegB_LATCH_EN_i & RegIMM_LATCH_EN_i & MUXA_SEL_i & MUXB_SEL_i & ALU_OUTREG_EN_i & EQ_COND_i & DRAM_WE_i & LMD_LATCH_EN_i & JUMP_EN_i & PC_LATCH_EN_i & WB_MUX_SEL_i & RF_WE_i & ALU_OPCODE_i; --we add the ALUOPCODE output at the end



	-- Instance of DLX Control unit
	DUT: dlx_cu generic map (MICROCODE_MEM_SIZE => MICROCODE_MEM_SIZE, FUNC_SIZE => FUNC_SIZE, OP_CODE_SIZE => OP_CODE_SIZE, ALU_OPC_SIZE => ALU_OPC_SIZE, IR_SIZE => IR_SIZE, CW_SIZE => CW_SIZE) port map (
		-- OUTPUTS
		IR_LATCH_EN        =>  IR_LATCH_EN_i,
		NPC_LATCH_EN       =>  NPC_LATCH_EN_i,
		RegA_LATCH_EN      =>  RegA_LATCH_EN_i,
		RegB_LATCH_EN      =>  RegB_LATCH_EN_i,
		RegIMM_LATCH_EN    =>  RegIMM_LATCH_EN_i,
		MUXA_SEL           =>  MUXA_SEL_i,
		MUXB_SEL           =>  MUXB_SEL_i,
		ALU_OUTREG_EN      =>  ALU_OUTREG_EN_i,
		EQ_COND            =>  EQ_COND_i,
		ALU_OPCODE         =>  ALU_OPCODE_i,
		DRAM_WE            =>  DRAM_WE_i,
		LMD_LATCH_EN       =>  LMD_LATCH_EN_i,
		JUMP_EN            =>  JUMP_EN_i,
		PC_LATCH_EN        =>  PC_LATCH_EN_i,
		WB_MUX_SEL         =>  WB_MUX_SEL_i,
		RF_WE              =>  RF_WE_i,
		-- INPUTS
		Clk                => clk,
		Rst                => rst,
		IR_IN              => IR_IN_i
	);

	clk_process : process
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;	
	end process clk_process;

	vector_process: process 
		file inputFile : text;		
		variable inputLine : line;
		variable inputBit  : bit;
	begin
		file_open(inputFile, "input.mem", read_mode);
		rst <= '0'; --active low reset
		wait until rising_edge(clk);
		rst <= '1';
		while not endfile(inputFile) loop
			readline(inputFile, inputline);
			-- first read opcode field from file 
			for i in IR_SIZE-1 downto 0 loop
				read(inputline, inputbit);
				if inputbit = '1' then
					IR_IN_i(i) <= '1';
				else
					IR_IN_i(i) <= '0';
				end if;
			end loop; 
			wait until rising_edge(clk);
		end loop;
		IR_IN_i <= (others => '0');
		file_close(inputFile);
		wait;
	end process vector_process;

	check_process: process
		file outputFile : text;		
		variable outputLine : line;
		variable outputBit  : bit;
	begin
		file_open(outputFile, "output.mem", read_mode);		
		wait until rising_edge(clk);		
		while not endfile(outputFile) loop
			readline(outputFile, outputline);
			-- first read opcode field from file 
			for i in CW_SIZE + ALU_OPC_SIZE -1 downto 0 loop
				read(outputline, outputbit);
				if outputbit = '1' then
					cw_expected(i) <= '1';
				else
					cw_expected(i) <= '0';
				end if;
			end loop; 
			wait until rising_edge(clk);
		end loop;
		file_close(outputFile);
		cw_expected <= (others => '0');
		wait;
	end process check_process;

	check: process	
	begin
		wait until rising_edge(clk); -- skip a clock cycle for the reset
		loop
		wait until rising_edge(clk);		
		assert cw = cw_expected report "incorrect code word" severity error;
		end loop;
	end process check;

end architecture testbench;
