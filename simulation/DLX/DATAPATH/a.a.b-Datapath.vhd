library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
--use work.CONSTANTS.all;


entity datapath is
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

end datapath;


architecture STRUCT of datapath is

	---We add each stage of the datapath as components
	COMPONENT fetch_unit is
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
			   FETCH_IR_TOCU: OUT std_logic_vector (31 downto 0); ---signal going to the control unit
			   FETCH_IR_OUTPUT: OUT std_logic_vector (31 downto 0));
	END COMPONENT fetch_unit; 

	COMPONENT decode_unit is
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
	END COMPONENT decode_unit;

	COMPONENT execution_unit is
      PORT(   EXEC_CK: IN std_logic;
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

	END COMPONENT execution_unit;

	COMPONENT memory_unit is
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
	END COMPONENT memory_unit;		

	COMPONENT writeback_unit is
  	   PORT ( WB_MUXSEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		   	  WB_NPC3: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		      WB_LMD :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		      WB_ALUOUT :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		      WB_MUX_OUTPUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT writeback_unit;	
	
	SIGNAL ir_out_s, pc_update_s, npc_output_s, pc_address_s, ir_toCU_s: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL regimm_out_s, rega_out_s, regb_out_s, npc2_out_s, datamem_out_s, npc3_out_s, ex_output_s: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL wr_out_s :  STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL reg_rd2_s, rd1_out_s : STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL cond_out_s : STD_LOGIC;
	SIGNAL lmd_out_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
	


begin

	-- output signal that goes to the control unit
	DAT_IR <= ir_toCU_s;
	-- output signal that goes to the Instruction memory
	DAT_PC_ADDRESS <= pc_address_s;


	
	
	fetch: fetch_unit PORT MAP(
	 -- inputs
			   -- common signals
			   CLK => CLK,
			   CLK_NEG => CLKNEG,
			   RST => RST,
			   -- control signals coming from the CU
		       FETCH_PC_LATCH_EN => CU_PC_LATCH_EN,
		       FETCH_NPC_LATCH_EN => CU_NPC_LATCH_EN,
			   FETCH_IR_LATCH_EN => CU_IR_LATCH_EN,

			   -- signal coming from the memory unit 
			   FETCH_PC_UPDATE => pc_update_s,
			   --signal coming from the Instruction memory
		   	   FETCH_IRAM_OUTPUT => DAT_IRAM_OUTPUT,
		       
	-- outputs
			   -- signal going to the decode unit and memory unit
			   FETCH_NPC_OUTPUT => npc_output_s,
			   -- signal going to the decode_unit
			   FETCH_IR_OUTPUT => ir_out_s,
			   FETCH_IR_TOCU => ir_toCU_s, 
			   --signal going to the Instruction memory
	           FETCH_PC_ADDRESS => pc_address_s
			); 
	decode: decode_unit PORT MAP (
    -- inputs  
			   -- common signals
			   CK => CLK,
			   RESET => RST,
	     	   -- control signals coming from the CU
			   RegA_LATCH_EN => CU_RegA_LATCH_EN,
			   RegB_LATCH_EN => CU_RegB_LATCH_EN,
			   RegIMM_LATCH_EN => CU_RegIMM_LATCH_EN,
			   RF_WE => CU_RF_WE,
			   MUX_Rd_SEL => CU_MUX_Rd_SEL,
			   MUX_JAL_SEL => CU_MUX_JAL_SEL,
			   Reg_Rd_LATCH_EN => CU_Reg_Rd_LATCH_EN,
			   MUX_IMM_SEL => CU_MUX_IMM_SEL,
			   Reg_NPC2_EN => CU_Reg_NPC2_EN,

			   -- signal coming from the fetch unit
			   IR_OUT => ir_out_s,
			   -- signal coming from the write back unit
			   WR_OUT => wr_out_s,
			   -- signal coming from the fetch unit
			   NPC_OUT => npc_output_s,
			   -- signal coming from the execution unit
			   Reg_Rd2_OUT => reg_rd2_s,
	-- outputs
			   

			   -- signals going to the execution unit
			   RegA_out => rega_out_s,
			   RegB_out => regb_out_s,
			   RegIMM_out => regimm_out_s,
			   NPC2_OUT => npc2_out_s,
			   Rd1_OUT => rd1_out_s
			);

	execution: execution_unit PORT MAP(   
	-- inputs
			   -- common signals    
			   EXEC_CK => CLK, 
		       RESET => RST,
			   -- control signals coming from the CU 
		       EXEC_ALU_OPCODE => CU_ALU_OPCODE,
               EXEC_MUXA_SEL => CU_MUXA_SEL,
			   EXEC_MUXB_SEL => CU_MUXB_SEL,
			   EXEC_MUXBRANCH_SEL => CU_MUXBRANCH_SEL,
               EXEC_ALU_OUTREG_EN => CU_ALU_OUTREG_EN,
		       EXEC_EQ_COND => CU_EQ_COND,
		       Reg_Rd2_LATCH_EN => CU_Rd2_LATCH_EN,
		       DATAMEM_LATCH_EN => CU_DATAMEM_LATCH_EN,
		       Reg_NPC3_EN => CU_NPC3_EN,
			   -- signal coming from the decode unit
		       Rd1_OUT => rd1_out_s,
			   --signal coming from the decode unit
		       EXEC_NPC2_OUT => npc2_out_s,
		       EXEC_A => rega_out_s,
			   EXEC_B => regb_out_s,
			   --signal coming from the decode unit
		       EXEC_IMM => regimm_out_s,
    -- outputs
			   -- signals going to the memory unit and write back
		       EXEC_UNIT_OUTPUT => ex_output_s,
		       EXEC_COND_OUT => cond_out_s,
			   -- signal going to the decode unit
		       Rd2_OUT => reg_rd2_s,
			   -- signal going to the write back
		       NPC3_OUT => npc3_out_s,
		       DATAMEM_OUT => datamem_out_s
			);
	mem: memory_unit PORT MAP(
	-- inputs
			   -- common signals
			   CK => CLK,
		       RESET => RST,
			   -- signal coming from the execution unit
		       COND_REG_OUT => cond_out_s,
			   -- control signals coming from the CU
		       JUMP_EN => CU_JUMP_EN, 
		       DRAM_WE => CU_DRAM_WE,
		       LMD_LATCH_EN => CU_LMD_EN,

		       NPC_OUT => npc_output_s,
		       ALU_OUT => ex_output_s,
			   -- signal coming from the execution unit
		       DATAMEM_OUT => datamem_out_s,	
   -- outputs
			   -- signal going to the fetch unit  
		       MUX_PC_OUT => pc_update_s,
			   ---signals related to the DRAM
			   FROMDATAMEM_DATA => DAT_DATAMEM_DATA, -- signal coming from the DRAM
			   TODRAM_ALUOUT => DAT_DRAM_ALUOUT, --- signal going to the DRAM
			   TODATAMEM_OUT => DAT_DATAMEM_OUT, -- signal going to the DRAM
			   -- signal going to the write back unit
		       LMD_OUT => lmd_out_s
			);
  	wb: writeback_unit PORT MAP( 
	-- inputs
			   -- control signals coming from the CU
			   WB_MUXSEL => CU_WB_MUXSEL,
			   -- signal coming from the execution unit
		   	   WB_NPC3 => npc3_out_s,		
			   -- signal coming from the memory unit
		       WB_LMD => lmd_out_s,
			   -- signal coming from the execution unit
		       WB_ALUOUT => ex_output_s,
    -- outputs
			   -- signal going to the decode unit
		       WB_MUX_OUTPUT => wr_out_s
			);
	
end STRUCT;

