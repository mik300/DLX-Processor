library ieee; 
use ieee.std_logic_1164.all;

entity general_generate is
port (Pik, Gik, Gk_1j: in std_logic;
	  Gij: out std_logic);
end general_generate;

architecture behavioral of general_generate is
begin

process(Pik, Gik, Gk_1j)
begin
	Gij <= Gik or (Pik and Gk_1j);
end process;

end architecture behavioral;
