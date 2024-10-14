library ieee;
use ieee.std_logic_1164.all;




entity AND_gate is
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		Y:	Out	std_logic);
end entity;

architecture BEHAVIORAL of AND_gate is  
begin
 
   Y <= A AND B;  
    
end architecture BEHAVIORAL;



