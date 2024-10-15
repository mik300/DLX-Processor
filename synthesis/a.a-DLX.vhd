library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
--use work.CONSTANTS.all;


entity dlx_processor is
  generic (
    MICROCODE_MEM_SIZE :     integer := 16;  -- Microcode Memory Size
    FUNC_SIZE          :     integer := 16;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 16;  -- Op Code Size
    ALU_OPC_SIZE       :     integer := 16;  -- ALU Op Code Word Size
    IR_SIZE            :     integer := 16;  -- Instruction Register Size    
    CW_SIZE            :     integer := 16);  -- Control Word Size
  port 	 (CLK_DLX, CLKNEG_DLX, RST_DLX : IN STD_LOGIC;
		  DATA_IRAM, DATA_DRAM :    IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		  ADDRESS_IRAM, DATA_REGDATAMEM :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		  ADDRESS_DRAM :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		  RW_DRAM : OUT STD_LOGIC
		  );
end dlx_processor;


architecture STRUCT of dlx_processor is

	---We add each stage of the datapath as components
	COMPONENT datapath is
	  port 	 (CLK, CLKNEG, RST : IN STD_LOGIC; --common signals for all the stages
			  -- control signals for fetch stage(coming from control unit)
			  CU_PC_LATCH_EN :  IN STD_LOGIC;
			  CU_NPC_LATCH_EN: IN STD_LOGIC;
			  CU_IR_LATCH_EN: IN STD_LOGIC;
			  -- control signals for decode stage(coming from control unit)
		      CU_RegA_LATCH_EN: IN std_logic;
			  CU_RegB_LATCH_EN: IN std_logic;
			  CU_RegIMM_LATCH_EN: IN std_logic;
			  CU_RF_WE: IN std_logic;
			  CU_MUX_Rd_SEL: IN std_logic;
			  CU_MUX_JAL_SEL: IN std_logic;
			  CU_Reg_Rd_LATCH_EN: IN std_logic;
			  CU_MUX_IMM_SEL: IN std_logic;
			  CU_Reg_NPC2_EN: IN std_logic;
			  -- control signals for execution stage(coming from control unit)
			  CU_ALU_OPCODE :  IN std_logic_vector(3 downto 0);
			  CU_MUXA_SEL : IN std_logic;
			  CU_MUXB_SEL : IN std_logic;
			  CU_MUXBRANCH_SEL :  IN std_logic;
			  CU_ALU_OUTREG_EN : IN std_logic;
		      CU_EQ_COND: IN std_logic;
			  CU_Rd2_LATCH_EN: IN std_logic;
			  CU_DATAMEM_LATCH_EN: IN std_logic;
			  CU_NPC3_EN: IN std_logic;
			  -- control signals for memory stage(coming from control unit)
			  CU_JUMP_EN : IN std_logic;
			  CU_DRAM_WE : IN std_logic;
			  CU_LMD_EN  : IN std_logic;
		      -- control signals for write back stage(coming from control unit)
		 	  CU_WB_MUXSEL :  IN std_logic_vector(1 downto 0);
		      --signal coming from the Instruction memory
			  DAT_IRAM_OUTPUT : IN std_logic_vector(31 downto 0); 
			  -- signal coming from the Data memory
			  DAT_DATAMEM_DATA: IN std_logic_vector(31 downto 0);
		      --signal going to the Instruction memory
		 	  DAT_PC_ADDRESS : OUT std_logic_vector(31 downto 0); 
			  --  signal that goes to the control unit
			  DAT_IR : OUT std_logic_vector(31 downto 0);
			  -- signal going to the Data memory
			  DAT_DRAM_ALUOUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 
			  -- signal going to the Data memory
			  DAT_DATAMEM_OUT :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
		);
	END COMPONENT datapath; 

	COMPONENT dlx_cu IS
		GENERIC (
		MICROCODE_MEM_SIZE :     integer:= 16;  -- Microcode Memory Size
		FUNC_SIZE          :     integer:= 16;  -- Func Field Size for R-Type Ops
		OP_CODE_SIZE       :     integer:= 16;  -- Op Code Size
		ALU_OPC_SIZE       :     integer:= 16;  -- ALU Op Code Word Size
		IR_SIZE            :     integer:= 16;  -- Instruction Register Size    
		CW_SIZE            :     integer:= 16);  -- Control Word Size
	 	PORT (
		Clk                : in  std_logic;  -- Clock
		Rst                : in  std_logic;  -- Reset:Active-Low
		-- Instruction Register
		IR_IN              : in  std_logic_vector(IR_SIZE - 1 downto 0); --IR_IN(Instruction register input) corresponds to the input coming from the instruction register and it contains the instruction in binary. These bits will be then splitted into OPCODE(6 bits) and the other fuctionalities
		
		-- IF Control Signal
		IR_LATCH_EN        : out std_logic;  -- Instruction Register Latch Enable
		NPC_LATCH_EN       : out std_logic;  -- NextProgramCounter Register Latch Enable
		PC_LATCH_EN        : out std_logic;  -- Program Counte Latch Enable
		                                    
		-- ID Control Signals
		RegA_LATCH_EN      : out std_logic;  -- Register A Latch Enable
		RegB_LATCH_EN      : out std_logic;  -- Register B Latch Enable
		RegIMM_LATCH_EN    : out std_logic;  -- Immediate Register Latch Enable
		NPC2_LATCH_EN      : out std_logic;  -- NextProgramCounter Register Latch Enable
		RD1_LATCH_EN       : out std_logic;  -- Destination Register Latch Enable
		MUXRD_SEL          : out std_logic;  -- MUX-RD Sel
		MUXJAL_SEL         : out std_logic;  -- MUX-JAL Sel
		MUXImm_SEL         : out std_logic;  -- MUX-Imm Sel

		-- EX Control Signals
		MUXA_SEL           : out std_logic;  -- MUX-A Sel
		MUXB_SEL           : out std_logic;  -- MUX-B Sel
	    MUXBRANCH_SEL      : out std_logic;  -- MUX-BRANCH Sel
		ALU_OUTREG_EN      : out std_logic;  -- ALU Output Register Enable
		EQ_COND            : out std_logic;  -- Branch if (not) Equal to Zero
		NPC3_LATCH_EN      : out std_logic;  -- NextProgramCounter Register Latch Enable
		RD2_LATCH_EN       : out std_logic;  -- Destination Register Latch Enable
		DATAMEM_LATCH_EN   : out std_logic;  -- DATA MEMORY Register Latch Enable
		-- ALU Operation Code
		ALU_OPCODE         : out STD_LOGIC_VECTOR(ALU_OPC_SIZE-1 DOWNTO 0); -- choose between implicit or exlicit coding, like    std_logic_vector(ALU_OPC_SIZE -1 downto 0);
		
		-- MEM Control Signals
		DRAM_WE            : out std_logic;  -- Data RAM Write Enable
		LMD_LATCH_EN       : out std_logic;  -- LMD Register Latch Enable
		JUMP_EN            : out std_logic;  -- JUMP Enable Signal for PC input MUX
		--PC_LATCH_EN        : out std_logic;  -- Program Counte Latch Enable

		-- WB Control signals
		WB_MUX_SEL         : out std_logic_vector(1 downto 0);  -- Write Back MUX Sel(selection of two bits now)
		RF_WE              : out std_logic);  -- Register File Write Enable

	END COMPONENT dlx_cu;
	
	SIGNAL PC_EN_intern, NPC_EN_intern, IR_EN_intern, RegA_EN_intern, RegB_EN_intern, RegIMM_EN_intern, RF_WE_intern, MUXRd_SEL_intern, MUXJAL_SEL_intern, RegRd_EN_intern, MUXIMM_SEL_intern, RegNPC2_EN_intern, MUXA_SEL_intern, MUXB_SEL_intern, MUXBRANCH_SEL_intern, ALUOUT_EN_intern, EQ_COND_intern, Rd2_EN_intern, DATAMEM_EN_intern, NPC3_EN_intern, JUMP_EN_intern, DRAM_WE_intern, LMD_EN_intern:  STD_LOGIC;
	SIGNAL ALUOPCODE_intern : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL WB_MUXSEL_intern : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL DAT_IR_intern : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
begin


	--Outputs going to the DRAM 
	RW_DRAM <= DRAM_WE_intern;
	

	dlx_datapath: datapath
    PORT MAP(
	-- inputs
			  CLK => CLK_DLX,
			  CLKNEG => CLKNEG_DLX,
			  RST => RST_DLX,
    -- internal connections
			  -- control signals for fetch stage(coming from control unit)
			  CU_PC_LATCH_EN => PC_EN_intern,
			  CU_NPC_LATCH_EN => NPC_EN_intern,
			  CU_IR_LATCH_EN => IR_EN_intern,
			  -- control signals for decode stage(coming from control unit)
		      CU_RegA_LATCH_EN => RegA_EN_intern,
			  CU_RegB_LATCH_EN => RegB_EN_intern,
			  CU_RegIMM_LATCH_EN => RegIMM_EN_intern,
			  CU_RF_WE => RF_WE_intern,
			  CU_MUX_Rd_SEL => MUXRd_SEL_intern,
			  CU_MUX_JAL_SEL => MUXJAL_SEL_intern,
			  CU_Reg_Rd_LATCH_EN => RegRd_EN_intern,
			  CU_MUX_IMM_SEL => MUXIMM_SEL_intern,
			  CU_Reg_NPC2_EN => RegNPC2_EN_intern,
			  -- control signals for execution stage(coming from control unit)
			  CU_ALU_OPCODE => ALUOPCODE_intern,
			  CU_MUXA_SEL => MUXA_SEL_intern,
			  CU_MUXB_SEL => MUXB_SEL_intern,
			  CU_MUXBRANCH_SEL => MUXBRANCH_SEL_intern,
			  CU_ALU_OUTREG_EN => ALUOUT_EN_intern,
		      CU_EQ_COND => EQ_COND_intern,
			  CU_Rd2_LATCH_EN => Rd2_EN_intern,
			  CU_DATAMEM_LATCH_EN => DATAMEM_EN_intern,
			  CU_NPC3_EN => NPC3_EN_intern,
			  -- control signals for memory stage(coming from control unit)
			  CU_JUMP_EN => JUMP_EN_intern,
			  CU_DRAM_WE => DRAM_WE_intern,
			  CU_LMD_EN => LMD_EN_intern,
		      -- control signals for write back stage(coming from control unit)
		 	  CU_WB_MUXSEL => WB_MUXSEL_intern,
              --signal coming from the Instruction memory
		      DAT_IRAM_OUTPUT => DATA_IRAM,
			  -- signal coming from the Data memory
			  DAT_DATAMEM_DATA => DATA_DRAM,
              --signal going to the Instruction memory
     	      DAT_PC_ADDRESS => ADDRESS_IRAM ,
			  DAT_IR => DAT_IR_intern,
			  -- signal going to the Data memory
			  DAT_DRAM_ALUOUT => ADDRESS_DRAM,
			  -- signal going to the Data memory
			  DAT_DATAMEM_OUT => DATA_REGDATAMEM
			); 

	control_unit: dlx_cu GENERIC MAP (
			MICROCODE_MEM_SIZE => 62,   -- Microcode Memory Size
			FUNC_SIZE => 11, -- Func Field Size for R-Type Ops
			OP_CODE_SIZE => 6,  -- Op Code Size
			ALU_OPC_SIZE => 4,  -- ALU Op Code Word Size
			IR_SIZE => 32,  -- Instruction Register Size    
			CW_SIZE => 25)  -- Control Word Size
		 	PORT MAP (
	-- inputs
			Clk => CLK_DLX,
			Rst => RST_DLX,
	-- internal connections
			-- Instruction Register
			IR_IN => DATA_IRAM,
		
			-- IF Control Signal
			IR_LATCH_EN => IR_EN_intern,
			NPC_LATCH_EN => NPC_EN_intern,
			PC_LATCH_EN => PC_EN_intern,
				                                
			-- ID Control Signals
			RegA_LATCH_EN => RegA_EN_intern,
			RegB_LATCH_EN => RegB_EN_intern,
			RegIMM_LATCH_EN => RegIMM_EN_intern,
			NPC2_LATCH_EN => RegNPC2_EN_intern,
			RD1_LATCH_EN => RegRd_EN_intern,
			MUXRD_SEL => MUXRd_SEL_intern,
			MUXJAL_SEL => MUXJAL_SEL_intern,
			MUXImm_SEL => MUXIMM_SEL_intern,

			-- EX Control Signals
			MUXA_SEL => MUXA_SEL_intern,
			MUXB_SEL => MUXB_SEL_intern,
			MUXBRANCH_SEL => MUXBRANCH_SEL_intern,
			ALU_OUTREG_EN => ALUOUT_EN_intern,
			EQ_COND => EQ_COND_intern,
			NPC3_LATCH_EN => NPC3_EN_intern,
			RD2_LATCH_EN => Rd2_EN_intern,
			DATAMEM_LATCH_EN => DATAMEM_EN_intern,
			-- ALU Operation Code
			ALU_OPCODE => ALUOPCODE_intern,
		
			-- MEM Control Signals
			DRAM_WE => DRAM_WE_intern,
			LMD_LATCH_EN => LMD_EN_intern,
			JUMP_EN => JUMP_EN_intern,
	
			-- WB Control signals
			WB_MUX_SEL => WB_MUXSEL_intern,
			RF_WE => RF_WE_intern

	    );


	

	
end STRUCT;

