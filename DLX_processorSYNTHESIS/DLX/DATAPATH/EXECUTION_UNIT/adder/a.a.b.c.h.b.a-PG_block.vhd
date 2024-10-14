library ieee; 
use ieee.std_logic_1164.all;

entity PG_block is
port (a, b: in std_logic;
	  p, g: out std_logic);
end PG_block;

architecture behavioral of PG_block is
begin
process(a, b)
begin
	g <= a and b;
	p <= a xor b;
end process;
end architecture behavioral;
