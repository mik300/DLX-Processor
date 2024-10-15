library IEEE;
use IEEE.std_logic_1164.all;

entity compare_zero is
	Port 	(  OP1:	in	std_logic_vector (31 downto 0);
			   compare_zero_output:	out	std_logic);
end entity;

architecture BEHAVIOR of compare_zero is 	

begin
	
	zero_P: process(OP1)
	begin
	  if (OP1 = x"00000000") then
	    compare_zero_output <= '1';
	  else  		
	    compare_zero_output <= '0'; 
	  end if;
	end process;

end architecture BEHAVIOR;
