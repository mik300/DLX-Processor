library ieee;
use ieee.std_logic_1164.all;


entity mux21_1bit is
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		SEL:	In	std_logic;
		Y:	Out	std_logic);
end entity;

architecture BEHAVIORAL of mux21_1bit is  
begin
  process(A, B, SEL)
    begin
      if(SEL = '0') then       
        Y <= A; 
      else
        Y <= B;
      end if;

      end process;

  end architecture BEHAVIORAL;



