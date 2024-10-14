library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
--use work.CONSTANTS.all;


entity top_level is
  generic ( RAM_DEPTH : integer; I_SIZE : integer ; ADDR_LEN : NATURAL; DATA_LEN : NATURAL ; MICROCODE_MEM_SIZE : integer; 
			FUNC_SIZE          :     integer;  
			OP_CODE_SIZE       :     integer;  
			ALU_OPC_SIZE       :     integer; 
			IR_SIZE            :     integer;      
			CW_SIZE            :     integer);
  port 	 (CLK, CLKNEG, RST: IN STD_LOGIC);

end top_level;


architecture STRUCT of top_level is

	COMPONENT dlx_processor is
       generic (
			MICROCODE_MEM_SIZE :     integer;  -- Microcode Memory Size
			FUNC_SIZE          :     integer;  -- Func Field Size for R-Type Ops
			OP_CODE_SIZE       :     integer;  -- Op Code Size
			ALU_OPC_SIZE       :     integer;  -- ALU Op Code Word Size
			IR_SIZE            :     integer;  -- Instruction Register Size    
			CW_SIZE            :     integer);  -- Control Word Size
  		PORT( CLK_DLX, CLKNEG_DLX, RST_DLX : IN STD_LOGIC;
		  	  DATA_IRAM, DATA_DRAM :    IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		  	  ADDRESS_IRAM, DATA_REGDATAMEM :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			  ADDRESS_DRAM :  OUT STD_LOGIC_VECTOR(ADDR_LEN-1 DOWNTO 0);
		  	  RW_DRAM : OUT STD_LOGIC
		    );
	END COMPONENT dlx_processor; 

	
	COMPONENT IRAM is
	  generic ( RAM_DEPTH : integer; I_SIZE : integer);
	  port (
		CK : in std_logic;
		Rst  : in  std_logic;
		Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
		Dout : out std_logic_vector(I_SIZE - 1 downto 0)
		);

	END COMPONENT IRAM;

	COMPONENT DRAM IS
		GENERIC( ADDR_LEN : NATURAL;
				 DATA_LEN : NATURAL );
		PORT (CLK:      IN  std_logic;
		      RESET: 	IN  std_logic;
			  WR: 		IN  std_logic;
			  ADDRESS:	IN  std_logic_vector(ADDR_LEN-1 DOWNTO 0);
			  DATAIN: 	IN  std_logic_vector(DATA_LEN-1 DOWNTO 0); --1 WRITE AT A TIME
		      DATAOUT:  OUT std_logic_vector(DATA_LEN-1 DOWNTO 0));

	END COMPONENT DRAM;

	SIGNAL  top_address_IRAM, top_data_IRAM, top_dataout_DRAM, top_datain_DRAM : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL top_address_DRAM :  STD_LOGIC_VECTOR(ADDR_LEN-1 DOWNTO 0);
	SIGNAL top_RW : std_logic;
	

begin
	processor : dlx_processor  GENERIC MAP( MICROCODE_MEM_SIZE => MICROCODE_MEM_SIZE, FUNC_SIZE => FUNC_SIZE, OP_CODE_SIZE => OP_CODE_SIZE, ALU_OPC_SIZE  => ALU_OPC_SIZE, IR_SIZE => IR_SIZE, CW_SIZE => CW_SIZE) PORT MAP( CLK_DLX => CLK, CLKNEG_DLX => CLKNEG, RST_DLX => RST, DATA_IRAM => top_data_IRAM , DATA_DRAM => top_dataout_DRAM, ADDRESS_IRAM => top_address_IRAM, ADDRESS_DRAM => top_address_DRAM, DATA_REGDATAMEM => top_datain_DRAM, RW_DRAM => top_RW);

	instruction_memory : IRAM GENERIC MAP ( RAM_DEPTH => RAM_DEPTH, I_SIZE => I_SIZE) PORT MAP (
		CK => CLK, Rst => RST, Addr => top_address_IRAM, Dout => top_data_IRAM);

	data_memory: DRAM GENERIC MAP( ADDR_LEN => ADDR_LEN,  DATA_LEN => DATA_LEN ) PORT MAP (CLK => CLKNEG, 
		      RESET => RST, WR => top_RW, ADDRESS => top_address_DRAM, DATAIN => top_datain_DRAM, DATAOUT =>top_dataout_DRAM);
		
end STRUCT;

