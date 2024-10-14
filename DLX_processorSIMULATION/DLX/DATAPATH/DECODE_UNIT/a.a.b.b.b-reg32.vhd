library IEEE;
use IEEE.std_logic_1164.all; 

entity reg32 is
	Port 	(CK:	In	std_logic;
			RESET:	In	std_logic;
			EN: IN std_logic;
			D:	In	std_logic_vector (31 downto 0);
			Q:	Out	std_logic_vector (31 downto 0));
end entity reg32;



architecture BEH of reg32 is 	-- register with asyncronous reset

begin
	
	PASYNCH: process(CK,RESET)
	begin
	  if RESET='1' then
	    Q <= (others => '0');
	  elsif (EN = '1') then
		if (rising_edge(CK)) then 		-- positive edge triggered:
	    Q <= D; 
		end if;
	  end if;
	end process;

end architecture BEH;




