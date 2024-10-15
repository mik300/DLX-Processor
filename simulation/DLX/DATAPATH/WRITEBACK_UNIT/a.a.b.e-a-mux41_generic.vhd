library ieee;
use ieee.std_logic_1164.all;

entity mux41_generic is
	Generic (NBIT: integer;  --defines input size
		 DELAY_MUX: Time); --defines the output delay during simulation
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0) ;
			B:	In	std_logic_vector(NBIT-1 downto 0);
			C:	In	std_logic_vector(NBIT-1 downto 0);
			D:	In	std_logic_vector(NBIT-1 downto 0);
			SEL:	In	std_logic_vector(1 downto 0);
			Y:	Out	std_logic_vector(NBIT-1 downto 0));
end entity;

architecture BEHAVIORAL of mux41_generic is  
begin
  process(SEL, A, B, C, D)
    begin
      if(SEL = "00") then       
        Y <= A after DELAY_MUX; 
	  elsif(SEL = "01") then 
		Y <= B after DELAY_MUX;
	  elsif(SEL = "10") then 
		Y <= C after DELAY_MUX;
      else
		Y <= D after DELAY_MUX;
      end if;
      end process;

  end architecture BEHAVIORAL;



