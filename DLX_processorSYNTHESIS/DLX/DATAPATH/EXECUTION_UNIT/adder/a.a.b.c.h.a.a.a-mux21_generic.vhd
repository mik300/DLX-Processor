library ieee;
use ieee.std_logic_1164.all;




entity mux21_generic is
	Generic (NBIT: integer:= 1); 
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0) ;
		B:	In	std_logic_vector(NBIT-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0));
	end entity;

architecture BEHAVIORAL of mux21_generic is  
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



