library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use work.myTypes.all;
use ieee.numeric_std.all;
--use work.all;

entity dlx_cu is
  generic (
    MICROCODE_MEM_SIZE :     integer:= 62;  -- Microcode Memory Size
    FUNC_SIZE          :     integer:= 11;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer:= 6;  -- Op Code Size
    ALU_OPC_SIZE       :     integer:= 4;  -- ALU Op Code Word Size
    IR_SIZE            :     integer:= 32;  -- Instruction Register Size    
    CW_SIZE            :     integer:= 25);  -- Control Word Size
  port (
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

end dlx_cu;

architecture dlx_cu_rtl of dlx_cu is
  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem : mem_array;

                                
  --signal IR_opcode : std_logic_vector(OP_CODE_SIZE -1 downto 0);  -- OpCode part of IR
  --signal IR_func : std_logic_vector(FUNC_SIZE downto 0);   -- Func part of IR when Rtype
  signal cw   : std_logic_vector(CW_SIZE - 1 downto 0); -- full control word read from cw_mem

  signal OPCODE_signal :  std_logic_vector(5 downto 0);
  signal FUNC_signal :  std_logic_vector(10 downto 0);


 -- control word is shifted to the correct stage
  signal cw1 : std_logic_vector(CW_SIZE - 1 downto 0); -- first stage
  signal cw2 : std_logic_vector(CW_SIZE - 1 - 3 downto 0); -- second stage
  signal cw3 : std_logic_vector(CW_SIZE - 1 - 3 - 8 downto 0); -- third stage
  signal cw4 : std_logic_vector(CW_SIZE - 1 - 3 - 8 - 8 downto 0); -- fourth stage
  signal cw5 : std_logic_vector(CW_SIZE - 1 - 3 - 8 - 8 - 3  downto 0); -- fifth stage


  signal aluOpcode_i: STD_LOGIC_VECTOR(ALU_OPC_SIZE-1  DOWNTO 0); 
  signal aluOpcode1:  STD_LOGIC_VECTOR(ALU_OPC_SIZE-1  DOWNTO 0); 
  signal aluOpcode2:  STD_LOGIC_VECTOR(ALU_OPC_SIZE-1  DOWNTO 0); 
  signal aluOpcode3:  STD_LOGIC_VECTOR(ALU_OPC_SIZE-1  DOWNTO 0); 
  
-- ALU_OPCODE operations
  CONSTANT NOP : STD_LOGIC_VECTOR(ALU_OPC_SIZE - 1 DOWNTO 0) := x"0";
  CONSTANT ADD : STD_LOGIC_VECTOR(ALU_OPC_SIZE - 1 DOWNTO 0) := x"1";
  CONSTANT SUB : STD_LOGIC_VECTOR(ALU_OPC_SIZE - 1 DOWNTO 0) := x"2";
  CONSTANT ANDD: STD_LOGIC_VECTOR(ALU_OPC_SIZE - 1 DOWNTO 0) := x"3";
  CONSTANT ORR : STD_LOGIC_VECTOR(ALU_OPC_SIZE - 1 DOWNTO 0) := x"4";
  CONSTANT XORR: STD_LOGIC_VECTOR(ALU_OPC_SIZE - 1 DOWNTO 0) := x"5";
  CONSTANT SGE:  STD_LOGIC_VECTOR(ALU_OPC_SIZE - 1 DOWNTO 0) := x"6"; 
  CONSTANT SLE:  STD_LOGIC_VECTOR(ALU_OPC_SIZE - 1 DOWNTO 0) := x"7";
  CONSTANT SNE:  STD_LOGIC_VECTOR(ALU_OPC_SIZE - 1 DOWNTO 0) := x"8";
  CONSTANT SLLL: STD_LOGIC_VECTOR(ALU_OPC_SIZE - 1 DOWNTO 0) := x"9";
  CONSTANT SRLL: STD_LOGIC_VECTOR(ALU_OPC_SIZE - 1 DOWNTO 0) := x"A";


 
begin  -- dlx_cu_rtl

  --IR_opcode(5 downto 0) <= IR_IN(31 downto 26); --The OPCODE corresponds to the 6 MSBs of the signal coming from the Instruction Register 
  --IR_func(10 downto 0)  <= IR_IN(FUNC_SIZE - 1 downto 0); --FUNC(which appear in R-Type instructions) has a size of 11 bits

  --We have to organize the instructions inside CW_mem in such a way they respect the decoder selection function
  OPCODE_signal <= IR_IN(31 downto 26) ;
  FUNC_signal <= IR_IN(10 downto 0);
  --cw <= cw_mem(to_integer(UNSIGNED(IR_IN(31 downto 26)))); --The control should has as output CW
 	cw_mem <=  					("1111100110010010010000101", -- (0x00) R type 
                                "0000000000000000000000000", -- (0x01) 
                                "1110011000101010000001000", -- (0X02) J  
                                "1110011101101010110001001", -- (0x03) JAL 
                                "1111011000001011000000000", -- (0x04) BEQZ 
                                "1111011000001111000000000", -- (0x05) BNEZ
                                "0000000000000000000000000", -- (0x06) 
                                "0000000000000000000000000", -- (0x07) 
                                "1111010100011010010000101", -- (0x08) ADDI
                                "0000000000000000000000000", -- (0x09) 
                                "1111010100011010010000101", -- (0x0A) SUBI 
                                "0000000000000000000000000", -- (0x0B) 
                                "1111010100011010010000101", -- (0x0C) ANDI
                                "1111010100011010010000101", -- (0x0D) ORI
                                "1111010100011010010000101", -- (0x0E) XORI
                                "0000000000000000000000000", -- (0x0F) 
                                "0000000000000000000000000", -- (0x10) 
                                "0000000000000000000000000", -- (0x11)
                                "0000000000000000000000000", -- (0x12) 
                                "0000000000000000000000000", -- (0x13) 
                                "1111010100011010010000101", -- (0x14) SLLI
                                "1110000000000000000000000", -- (0x15) NOP
                                "1111010100011010010000101", -- (0x16) SRLI
                                "0000000000000000000000000", -- (0x17) 
                                "0000000000000000000000000", -- (0x18) 
                                "1111010100011010010000101", -- (0x19) SNEI
                                "0000000000000000000000000", -- (0x1A) 
                                "0000000000000000000000000", -- (0x1B) 
                                "1111010100011010010000101", -- (0x1C) SLEI
                                "1111010100011010010000101", -- (0x1D) SGEI
                                "0000000000000000000000000", -- (0x1E) 
                                "0000000000000000000000000", -- (0x1F) 
                                "0000000000000000000000000", -- (0x20)
                                "0000000000000000000000000", -- (0x21)
                                "0000000000000000000000000", -- (0x22)
                                "1111010100011010010010011", -- (0x23) LW
                                "0000000000000000000000000", -- (0x24)
                                "0000000000000000000000000", -- (0x25)
                                "0000000000000000000000000", -- (0x26)
                                "0000000000000000000000000", -- (0x27)
                                "0000000000000000000000000", -- (0x28)
                                "0000000000000000000000000", -- (0x29)
                                "0000000000000000000000000", -- (0x2A)
                                "1111110000011010001110000", -- (0x2B) SW
                                "0000000000000000000000000", -- (0x2C)
                                "0000000000000000000000000", -- (0x2D)
                                "0000000000000000000000000", -- (0x2E)
                                "0000000000000000000000000", -- (0x2F)
                                "0000000000000000000000000", -- (0x30)
                                "0000000000000000000000000", -- (0x31)
                                "0000000000000000000000000", -- (0x32)
                                "0000000000000000000000000", -- (0x33)
                                "0000000000000000000000000", -- (0x34)
                                "0000000000000000000000000", -- (0x35)
                                "0000000000000000000000000", -- (0x36)
                                "0000000000000000000000000", -- (0x37)
                                "0000000000000000000000000", -- (0x38)
                                "0000000000000000000000000", -- (0x39)
                                "0000000000000000000000000", -- (0x3A)
                                "0000000000000000000000000", -- (0x3B)
                                "0000000000000000000000000", -- (0x3C)
                                "0000000000000000000000000");
  


  -- stage one control signals(IF)
  IR_LATCH_EN  <= cw1(CW_SIZE - 1);
  NPC_LATCH_EN <= cw1(CW_SIZE - 2);
  PC_LATCH_EN  <= cw1(CW_SIZE - 3); 
  
  -- stage two control signals
  RegA_LATCH_EN   <= cw2(CW_SIZE - 4);
  RegB_LATCH_EN   <= cw2(CW_SIZE - 5);
  RegIMM_LATCH_EN <= cw2(CW_SIZE - 6);
  NPC2_LATCH_EN   <= cw2(CW_SIZE - 7);
  RD1_LATCH_EN    <= cw2(CW_SIZE - 8);     
  MUXRD_SEL       <= cw2(CW_SIZE - 9); 
  MUXJAL_SEL      <= cw2(CW_SIZE - 10);
  MUXImm_SEL      <= cw2(CW_SIZE - 11);         
  
  -- stage three control signals
  MUXA_SEL      <= cw3(CW_SIZE - 12);
  MUXB_SEL      <= cw3(CW_SIZE - 13);	
  MUXBRANCH_SEL <= cw3(CW_SIZE - 14);
  ALU_OUTREG_EN <= cw3(CW_SIZE - 15);
  EQ_COND       <= cw3(CW_SIZE - 16);
  NPC3_LATCH_EN <= cw3(CW_SIZE - 17);    
  RD2_LATCH_EN  <= cw3(CW_SIZE - 18);   
  DATAMEM_LATCH_EN  <= cw3(CW_SIZE - 19);  
  
  -- stage four control signals
  DRAM_WE      <= cw4(CW_SIZE - 20);
  LMD_LATCH_EN <= cw4(CW_SIZE - 21);
  JUMP_EN      <= cw4(CW_SIZE - 22);
  --PC_LATCH_EN  <= cw4(CW_SIZE - 21);
  
  -- stage five control signals
  WB_MUX_SEL <= cw5(CW_SIZE - 23) & cw5(CW_SIZE - 24);
  RF_WE      <= cw5(CW_SIZE - 25);


  -- process to pipeline control words
  CW_PIPE: process (Clk, Rst, cw)
  begin  -- process Clk
    if Rst = '1' then                   -- asynchronous reset (active low)
      cw1 <= "1110000000000000000000000";
      cw2 <= (others => '0');
      cw3 <= (others => '0');
      cw4 <= (others => '0');
      cw5 <= (others => '0');
     -- aluOpcode1 <= NOP;
      --aluOpcode2 <= NOP;
     -- aluOpcode3 <= NOP;
    --elsif rising_edge(Clk) then  -- rising clock edge
	  else
      cw1 <= cw_mem(to_integer(UNSIGNED(IR_IN(31 downto 26))));
      cw2 <= cw1(CW_SIZE - 1 - 3 downto 0);
      cw3 <= cw2(CW_SIZE - 1 - 3 - 8 downto 0);
      cw4 <= cw3(CW_SIZE - 1 - 3 - 8 - 8 downto 0);
      cw5 <= cw4(CW_SIZE - 1 - 3 - 8 - 8 - 3  downto 0);



      aluOpcode1 <= aluOpcode_i;
      aluOpcode2 <= aluOpcode1;
      aluOpcode3 <= aluOpcode2;
    end if;
  end process CW_PIPE;

  ALU_OPCODE <= aluOpcode3; --This is the ALU_OP output that goes to the ALU

  -- purpose: Generation of ALU OpCode
  -- type   : combinational
  -- inputs : IR_i
  -- outputs: aluOpcode 
   ALU_OP_CODE_P : process (IR_IN)
   VARIABLE IR_FUNC_temp,IR_opcode_temp  : integer;
   begin  -- process ALU_OP_CODE_P
	IR_FUNC_temp := to_integer(unsigned(IR_IN(FUNC_SIZE - 1 downto 0)));  
	IR_opcode_temp := to_integer(unsigned(IR_IN(31 downto 26)));
		case IR_opcode_temp  is
			    -- case of R type requires analysis of FUNC
			when 0 => -- (0x00) R_type
				case IR_FUNC_temp  is
					when 32 => aluOpcode_i <= ADD;    -- (0x20) ADD
					when 34 => aluOpcode_i <= SUB;    -- (0x22) SUB
					when 36 => aluOpcode_i <= ANDD;   -- (0x23) AND
					when 37  => aluOpcode_i <= ORR;   -- (0x25) OR
					when 38 => aluOpcode_i <= XORR;   -- (0x26) XOR
					when 4 => aluOpcode_i <= SLLL;    -- (0x04) SLL
					when 6 => aluOpcode_i <= SRLL;    -- (0x06) SRL
					when 45 => aluOpcode_i <= SGE;   -- (0x2D) SGE
					when 44 => aluOpcode_i <= SLE;   -- (0x2C) AND
					when 41 => aluOpcode_i <= SNE;   -- (0x29) AND
					when others => aluOpcode_i <= NOP;-- (0x15) NOP
				end case;
			when 8 => aluOpcode_i <= ADD;  -- (0x08) ADDI
			when 12 => aluOpcode_i <= ANDD; -- (0x0C) ANDI 
			when 10 => aluOpcode_i <= SUB;  -- (0x0A) SUBI
			when 35   => aluOpcode_i <= ADD;  -- (0x23) LW 
			when 43  => aluOpcode_i <= ADD;  -- (0x2B) SW
			when 21  => aluOpcode_i <= NOP;  -- (0x15) NOP
			when 13  => aluOpcode_i <= ORR;  -- (0x0D) ORI
			when 14 => aluOpcode_i <= XORR; -- (0x0E) XORI
			when 20 => aluOpcode_i <= SLLL; -- (0x14) SLLI 
			when 22 => aluOpcode_i <= SRLL; -- (0x16) SRLI
			when 29 => aluOpcode_i <= SGE; -- (0x1D) SGEI
			when 28 => aluOpcode_i <= SLE; -- (0x1C) SLEI
			when 25 => aluOpcode_i <= SNE; -- (0x19) SNEI
			when 4 => aluOpcode_i <= ADD;   -- (0x04) BEQZ  
			when 5 => aluOpcode_i <= ADD;  -- (0x05) BNEZ
			when 2    => aluOpcode_i <= ADD;  -- (0x02) J
			when 3  => aluOpcode_i <= ADD;  -- (0x03) JAL
			when others => aluOpcode_i <= NOP;  -- (0x15) NOP
		 end case;
	end process ALU_OP_CODE_P;


end dlx_cu_rtl;
