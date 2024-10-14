library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity RCA is 
	generic (NBit : integer:= 1);
	Port (	A:	In	std_logic_vector(NBit-1 downto 0);  --(5 downto 0)
		B:	In	std_logic_vector(NBit-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(NBit-1 downto 0);
		Co:	Out	std_logic);
end RCA; 

architecture STRUCTURAL of RCA is

  signal STMP : std_logic_vector(NBit-1 downto 0);
  signal CTMP : std_logic_vector(NBit downto 0);

  component FA 
  Port ( A:	In	std_logic;
	 B:	In	std_logic;
	 Ci:	In	std_logic; --carry in
	 S:	Out	std_logic;
	 Co:	Out	std_logic); --carry out
  end component; 

begin

  CTMP(0) <= Ci;
  S <= STMP;
  Co <= CTMP(NBit);
  
  ADDER1: for I in 1 to NBit generate
    FAI : FA Port Map (A(I-1), B(I-1), CTMP(I-1), STMP(I-1), CTMP(I)); 
  end generate;

end STRUCTURAL;


architecture BEHAVIORAL of RCA is
	signal Sum :  std_logic_vector(NBit downto 0); --NumBit+1 bits to manage the carry out, the MSB manages the Carry out, LSB manages the Carry in
    signal padding : unsigned(NBit - 1 downto 0);  --padding is used to extend the Ci to match the size of A and B
begin

  padding <= (others => '0'); --padding is always all zeros
  Sum <= std_logic_vector( unsigned(A) + unsigned(B) + (padding&Ci)); 
  S <= Sum(NBit-1 downto 0) ;
  Co <= Sum(NBit);

  
end BEHAVIORAL;

