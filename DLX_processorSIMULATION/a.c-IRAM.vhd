library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;


-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
-- file name is "test.asm.mem"
entity IRAM is
  generic ( RAM_DEPTH : integer; I_SIZE : integer);
  port (
	CK : in std_logic;
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    );

end IRAM;

architecture IRam_Bhe of IRAM is
	
  SUBTYPE MEM_ADDR IS NATURAL RANGE 0 TO RAM_DEPTH - 1; 
  TYPE RAMtype IS ARRAY(MEM_ADDR) OF STD_LOGIC_VECTOR((I_SIZE / 4) - 1 DOWNTO 0); 


  --type word is array(0 to 3) of std_logic_vector((I_SIZE / 4) - 1 downto 0);
  --type RAMtype is array (0 to RAM_DEPTH - 1) of word;--integer

  signal IRAM_mem : RAMtype := (others => (others => '0'));
  --signal temp  :  std_logic_vector(I_SIZE - 1 downto 0);
  --signal byte1, byte2, byte3, byte4 : std_logic_vector((I_SIZE / 4) -1  downto 0);

begin  -- IRam_Bhe

	Read : PROCESS(Addr, IRAM_mem) 
	BEGIN
		Dout <= IRAM_mem(CONV_INTEGER(UNSIGNED(Addr))) & IRAM_mem(CONV_INTEGER(UNSIGNED(Addr))+1) & IRAM_mem(CONV_INTEGER(UNSIGNED(Addr))+2) & IRAM_mem(CONV_INTEGER(UNSIGNED(Addr))+3);				
	END PROCESS Read;

	
	
  
	--Dout <= conv_std_logic_vector(IRAM_mem(conv_integer(unsigned(Addr))),I_SIZE);
	  --Dout <= IRAM_mem(conv_integer(unsigned(Addr)))(0) & IRAM_mem(conv_integer(unsigned(Addr)))(1) & IRAM_mem(conv_integer(unsigned(Addr)))(2) & IRAM_mem(conv_integer(unsigned(Addr)))(3) ;

	

  -- purpose: This process is in charge of filling the Instruction RAM with the firmware
  -- type   : combinational
  -- inputs : Rst
  -- outputs: IRAM_mem
  FILL_MEM_P: process (Rst)
    file mem_fp: text;
    variable file_line : line;
    variable index : integer := 0;
    variable tmp_data_u : std_logic_vector(I_SIZE-1 downto 0);
	-- We want to have an aligned-memory. Therefore, each instructions is splitted into 4 parts(each of 1 byte). Then, the next instruction is saved in PC + 4

  begin  -- process FILL_MEM_P
    if (Rst = '1') then ---We fill the memory once when Rst = '1'
      file_open(mem_fp,"ASSEMBLY/test.mem",READ_MODE);
      while not endfile(mem_fp) loop
        readline(mem_fp,file_line);
        hread(file_line,tmp_data_u);
		for i in 0 to 3 loop
			-- The idea is to read the instruction and store it in 4 different rows, each one with a byte. With this, we get the proper alignment
			--IRAM_mem(index) <= conv_integer(unsigned(tmp_data_u((I_SIZE - 1 ) - (8 * i ) downto ( ( I_SIZE - 8 )-( 8 * i ) ) )));
			--IRAM_mem(index) <= tmp_data_u((I_SIZE - 1 ) - (8 * i ) downto ( ( I_SIZE - 8 )-( 8 * i ) ) );
			--IRAM_mem(index)(i)<= tmp_data_u((I_SIZE - 1 ) - (8 * i ) downto ( ( I_SIZE - 8 )-( 8 * i ) ) );
			IRAM_mem(CONV_INTEGER(index)) <= tmp_data_u((I_SIZE - 1 ) - (8 * i ) downto ( ( I_SIZE - 8 )-( 8 * i ) ) ); 
			index := index + 1;
		end loop;
		
		
        --IRAM_mem(index) <= conv_integer(unsigned(tmp_data_u));       
        
      end loop;
    end if;
  end process FILL_MEM_P;

end IRam_Bhe;
