library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XOR_block is
Port (a, b: in std_logic;
      z: out std_logic );
end XOR_block;

architecture Behavioral of XOR_block is

begin
 z <= a xor b;

end Behavioral;
