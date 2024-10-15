package CONSTANTS is
    --- constants related to processor
    --- constants related to control unit
	constant    CLK_PERIOD         :     TIME    := 10 ns;
	constant	MICROCODE_MEM_SIZE :     integer := 62;  -- Microcode Memory Size
	constant	FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
	constant	OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
	constant	ALU_OPC_SIZE       :     integer := 4;  -- ALU Op Code Word Size
	constant	IR_SIZE            :     integer := 32;  -- Instruction Register Size    
	constant	CW_SIZE            :     integer := 25;  -- Control Word Size

	-- constants related to execution unit
	--Adder constants
   	constant IVDELAY : time := 0.1 ns;
   	constant NDDELAY : time := 0.2 ns;
   	constant NDDELAYRISE : time := 0.6 ns;
   	constant NDDELAYFALL : time := 0.4 ns;
   	constant NRDELAY : time := 0.2 ns;
   	constant DRCAS : time := 1 ns;
   	constant DRCAC : time := 2 ns;
   	constant NumBit : integer := 32;	
   	constant TP_MUX : time := 0.5 ns; 	
   	constant NBIT_EACH_BLOCK: INTEGER := 4;
   	constant NBIT_BLOCKS: INTEGER := 8;
   	constant NBIT : INTEGER := 32;
	
	-- constants related to the memory unit
	--constant CLK_PERIOD : TIME    := 10 ns;
	--constant ADDR_LENGTH: NATURAL := 32;
	--constant DATA_LENGTH: NATURAL := 32;
	--constant M			: NATURAL := 4;
	--constant N			: NATURAL := 2;
	--constant F			: NATURAL := 4;
	--constants related to write back unit
    --constant NBIT: integer := 32;    --size of the inputs of the mux of the write back stage 
	constant DELAY_MUX: Time := 0 ns;   --delay of the mux of the write back stage 

	--Constants related to the instruction memory
	CONSTANT RAM_DEPTH : integer := 2000; 
	CONSTANT I_SIZE : integer := 32; 
	CONSTANT clockPeriod : time := 20 ns; 
	-- Constant related to the data memory
	constant ADDR_LEN: NATURAL := 8;
	constant DATA_LEN: NATURAL := 32;

	
end CONSTANTS;
