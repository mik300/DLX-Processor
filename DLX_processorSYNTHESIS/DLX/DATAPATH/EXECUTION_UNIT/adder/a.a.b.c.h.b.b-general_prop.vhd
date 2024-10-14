library ieee; 
use ieee.std_logic_1164.all;

entity general_prop is
 port (Pik, Gik, Pk_1j, Gk_1j: in std_logic;
	   Pij, Gij: out std_logic);
end general_prop;


architecture behavioral of general_prop is
begin

process(Pik, Gik, Pk_1j, Gk_1j)
begin
	Gij <= Gik or (Pik and Gk_1j);
	Pij <= Pik and Pk_1j;
end process;

end architecture behavioral;
