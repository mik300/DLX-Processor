LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE myTypes IS

-- Control unit input sizes
	--The OPCODE has a size of 6 bits and FUNC has a size of 11 bits
	-- 
    CONSTANT OP_CODE_SIZE : integer :=  6;                                              -- OPCODE field size
    CONSTANT FUNC_SIZE    : integer :=  11;                                             -- FUNC field size
	CONSTANT ALU_OPC_SIZE : integer :=  4;                                              -- ALUOP field size


-- R-Type instruction -> FUNC field
    CONSTANT RTYPE_ADD : std_logic_vector(FUNC_SIZE - 1 DOWNTO 0) :=  "000" & x"20";    -- ADD RS1,RS2,RD
    CONSTANT RTYPE_SUB : std_logic_vector(FUNC_SIZE - 1 DOWNTO 0) :=  "000" & x"22";    -- SUB RS1,RS2,RD
	CONSTANT RTYPE_AND : std_logic_vector(FUNC_SIZE - 1 DOWNTO 0) :=  "000" & x"24";    -- AND RS1,RS2,RD
	CONSTANT RTYPE_OR :  std_logic_vector(FUNC_SIZE - 1 DOWNTO 0) :=  "000" & x"25";    -- OR  RS1,RS2,RD
	CONSTANT RTYPE_XOR : std_logic_vector(FUNC_SIZE - 1 DOWNTO 0) :=  "000" & x"26";    -- XOR RS1,RS2,RD
	CONSTANT RTYPE_SLL : std_logic_vector(FUNC_SIZE - 1 DOWNTO 0) :=  "000" & x"04";    -- SLL RS1,RS2,RD
	CONSTANT RTYPE_SRL : std_logic_vector(FUNC_SIZE - 1 DOWNTO 0) :=  "000" & x"06";    -- SRL RS1,RS2,RD
	CONSTANT RTYPE_SGE : std_logic_vector(FUNC_SIZE - 1 DOWNTO 0) :=  "000" & x"2D";    -- SGE RS1,RS2,RD
	CONSTANT RTYPE_SLE : std_logic_vector(FUNC_SIZE - 1 DOWNTO 0) :=  "000" & x"2C";    -- SLE RS1,RS2,RD
	CONSTANT RTYPE_SNE : std_logic_vector(FUNC_SIZE - 1 DOWNTO 0) :=  "000" & x"29";    -- SLE RS1,RS2,RD

-- R-Type instruction -> OPCODE field
    CONSTANT RTYPE :   std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) := "00" & x"0"; -- for ADD, SUB, AND, OR, XOR register-to-register operation

-- I-Type instruction -> OPCODE field --In this case, the OPCODE is the only thing that distinguishes the different operations
    CONSTANT ITYPE_ADDI : std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=   "00" & x"8";    -- (0x08) ADDI RS1,RD,Imm
	CONSTANT ITYPE_ANDI :  std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=  "00" & x"C";    -- (0x0C) ANDI RS1,RD,Imm
	CONSTANT ITYPE_SUBI :  std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=  "00" & x"A";    -- (0x0A) SUBI   RS1,RD,Imm
	CONSTANT ITYPE_LW :  std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=    "10" & x"3";    -- (0x23) LW   RS1,RD,Imm
	CONSTANT ITYPE_SW :  std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=    "10" & x"B";    -- (0x2B) SW   RS1,RD,Imm
	CONSTANT ITYPE_NOP : std_logic_vector(OP_CODE_SIZE- 1 downto 0) :=     "01" & x"5";    -- (0x15) NOP
	CONSTANT ITYPE_ORI : std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=    "00" & x"D";    -- (0x0D) ORI  RS1,RD,Imm
	CONSTANT ITYPE_XORI : std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=   "00" & x"E";    -- (0x0E) XORI RS1,RD,Imm
	CONSTANT ITYPE_SLLI : std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=   "01" & x"4";    -- (0x14) SLLI RS1,RD,Imm
	CONSTANT ITYPE_SRLI : std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=   "01" & x"6";    -- (0x16) SRLI RS1,RD,Imm
	CONSTANT ITYPE_SGEI : std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=      "01" & x"D";    -- (0x1D) SGEI RS1,RD,Imm
	CONSTANT ITYPE_SLEI : std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=      "01" & x"C";    -- (0x1C) SLEI RS1,RD,Imm
	CONSTANT ITYPE_SNEI : std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=      "01" & x"9";    -- (0x19) SNEI RS1,RD,Imm
	CONSTANT ITYPE_BEQZ : std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=      "00" & x"4";    -- (0x04) BEQZ 
	CONSTANT ITYPE_BNEZ : std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=      "00" & x"5";    -- (0x05) BNEZ

-- J-Type instruction -> OPCODE field 
	CONSTANT JTYPE_J: std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=       "00" & x"2";    -- (0x02) J Imm
	CONSTANT JTYPE_JAL: std_logic_vector(OP_CODE_SIZE - 1 DOWNTO 0) :=     "00" & x"3";    -- (0x03) JAL Imm







END myTypes;

