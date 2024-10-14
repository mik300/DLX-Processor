LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
--USE WORK.CONSTANTS.ALL;

ENTITY register_file IS
	GENERIC( ADDR_LEN : NATURAL := 5;
			 DATA_LEN : NATURAL := 32);
	PORT (CLK:      IN  std_logic;
          RESET: 	IN  std_logic;
	      WR: 		IN  std_logic;
	      ADD_WR: 	IN  std_logic_vector(ADDR_LEN-1 DOWNTO 0);
	      ADD_RD1: 	IN  std_logic_vector(ADDR_LEN-1 DOWNTO 0);
	      ADD_RD2: 	IN  std_logic_vector(ADDR_LEN-1 DOWNTO 0);
	      DATAIN: 	IN  std_logic_vector(DATA_LEN-1 DOWNTO 0); --1 WRITE AT A TIME
          OUT1:     OUT std_logic_vector(DATA_LEN-1 DOWNTO 0); --2 READS AT A TIME
	      OUT2:     OUT std_logic_vector(DATA_LEN-1 DOWNTO 0));

END register_file;

ARCHITECTURE A OF register_file IS

    -- suggested structures
	SUBTYPE REG_ADDR IS NATURAL RANGE 0 TO 2**ADDR_LEN -1; -- using natural type -- 2**ADDR_LEN Registers
	TYPE REG_ARRAY IS ARRAY(REG_ADDR) OF STD_LOGIC_VECTOR(DATA_LEN-1 DOWNTO 0);  --Each register has DATA_LEN bits
	SIGNAL REGISTERS: REG_ARRAY;

BEGIN

	
	--REGISTERS(0) <= x"00000000";
	WRITE :  PROCESS(CLK, RESET) --In this case, we define only one write process which take care of the writing in the given address
	BEGIN 
		IF (RESET = '1') THEN
			REGISTERS <= (OTHERS => (OTHERS => '0'));
		ELSIF (RISING_EDGE(CLK)) THEN
			IF(WR = '1') THEN 
				IF (ADD_WR = x"00000000") THEN
				REGISTERS(CONV_INTEGER(ADD_WR)) <= (OTHERS => '0');
				ELSE
				REGISTERS(CONV_INTEGER(ADD_WR)) <= DATAIN; 
				END IF;
			END IF;
		END IF;
	END PROCESS WRITE;

	Read1 : PROCESS(ADD_RD1, REGISTERS) --Process that takes care of one the read ports
	BEGIN
		OUT1 <= REGISTERS(CONV_INTEGER(ADD_RD1));				
	END PROCESS Read1;

	Read2 : PROCESS(ADD_RD2, REGISTERS) 
	BEGIN		
			OUT2 <= REGISTERS(CONV_INTEGER(ADD_RD2));			
	END PROCESS Read2;

END A;

CONFIGURATION CFG_RF_BEH OF register_file IS
  FOR A
  END FOR;
END CONFIGURATION;
