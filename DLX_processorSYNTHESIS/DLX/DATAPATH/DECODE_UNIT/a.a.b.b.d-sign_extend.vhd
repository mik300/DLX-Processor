LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;


ENTITY sign_extend IS

	PORT (DATAIN: IN std_logic_vector(15 downto 0);
		  DATAOUT: OUT std_logic_vector(31 downto 0));

END sign_extend;


ARCHITECTURE BEHAVIOR OF sign_extend IS

BEGIN

PROCESS(DATAIN)
BEGIN
	IF(DATAIN(15) = '0') then
		DATAOUT <= x"0000"&DATAIN;
	ELSE
		DATAOUT <= x"FFFF"&DATAIN;
	END IF;
END PROCESS;

END BEHAVIOR;
