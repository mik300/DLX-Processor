library IEEE;
use IEEE.std_logic_1164.all; 

entity REG_GENERIC is
  	generic (Nbits : integer:=1);
	Port 	(  CK:	In	std_logic;
			RESET:	In	std_logic;
		    EN: In std_logic;
			D:	In	std_logic_vector (Nbits-1 downto 0);
			Q:	Out	std_logic_vector (Nbits-1 downto 0));
end entity REG_GENERIC;


architecture PLUTO of REG_GENERIC is 	-- register with asyncronous reset

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

end architecture PLUTO;




