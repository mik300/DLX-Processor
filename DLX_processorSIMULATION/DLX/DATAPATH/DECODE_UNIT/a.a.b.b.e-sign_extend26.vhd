LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;


ENTITY sign_extend26 IS

	PORT (DATAIN: IN std_logic_vector(25 downto 0);
		  DATAOUT: OUT std_logic_vector(31 downto 0));

END sign_extend26;


ARCHITECTURE BEHAVIOR OF sign_extend26 IS

BEGIN

PROCESS(DATAIN)
BEGIN
	IF(DATAIN(25) = '0') then
		DATAOUT <= "000000"&DATAIN;
	ELSE
		DATAOUT <= "111111"&DATAIN;
	END IF;
END PROCESS;

END BEHAVIOR;
