library IEEE;
use IEEE.std_logic_1164.all; 

entity reg_generic3 is
	Port 	(CK:	In	std_logic;
			RESET:	In	std_logic;
			EN: IN std_logic;
			D2:	In	std_logic_vector (31 downto 0);
			Q2:	Out	std_logic_vector (31 downto 0));
end entity reg_generic3;



architecture PLUTO of reg_generic3 is 	-- register with asyncronous reset

begin
	
	PASYNCH: process(CK,RESET)
	begin
	  if RESET='1' then
	    Q2 <= x"00000004";
	  elsif (EN = '1') then
		if (rising_edge(CK)) then 		-- positive edge triggered:
	    Q2 <= D2; 
		end if;
	  end if;
	end process;

end architecture PLUTO;





