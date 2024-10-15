library ieee;
use ieee.std_logic_1164.all;




entity OR_gate is
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		Y:	Out	std_logic);
end entity;

architecture BEHAVIORAL of OR_gate is  
begin
 
   Y <= A OR B;  
    
end architecture BEHAVIORAL;



