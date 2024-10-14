library IEEE;
use IEEE.std_logic_1164.all; 

entity reg is
	Port 	(  CK:	In	std_logic;
			RESET:	In	std_logic;
			EN: In std_logic;
			D:	In	std_logic;
			Q:	Out	std_logic);
end entity reg;

architecture BEH of reg is 	-- register with asyncronous reset

begin
	
	PASYNCH: process(CK,RESET)
	begin
	  if RESET='1' then
	    Q <= '0';
	  elsif (EN = '1') then
		if rising_edge(CK) then 		-- positive edge triggered:
	    Q <= D; 
		end if;
	  end if;
	end process;

end architecture BEH;




