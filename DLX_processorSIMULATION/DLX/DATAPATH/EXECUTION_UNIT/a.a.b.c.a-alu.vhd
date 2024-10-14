library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
--use WORK.constants.all;


entity ALU is
     GENERIC( IVDELAY : time := 0.1 ns;
   		    NDDELAY : time := 0.2 ns;
   		    NDDELAYRISE : time := 0.6 ns;
   		    NDDELAYFALL : time := 0.4 ns;
   	        NRDELAY : time := 0.2 ns;
   			DRCAS : time := 1 ns;
   			DRCAC : time := 2 ns;
   			NumBit : integer := 32;	
   			TP_MUX : time := 0.5 ns; 	
   			NBIT_EACH_BLOCK: INTEGER := 4;
   			NBIT_BLOCKS: INTEGER := 8;
   			NBIT : INTEGER := 32);
  port 	 ( FUNC: IN std_logic_vector(3 downto 0);
           DATA1, DATA2: IN std_logic_vector(31 downto 0);
           OUTALU: OUT std_logic_vector(31 downto 0));
end ALU;

architecture BEHAVIOR of ALU is

COMPONENT P4_ADDER IS
	GENERIC(IVDELAY : time;
			NDDELAY : time;
			NDDELAYRISE : time;
			NDDELAYFALL : time; 
			NRDELAY : time; 
			DRCAS : time;
			DRCAC : time; 
			NumBit : integer; 
			TP_MUX : time ;  	
			NBIT_EACH_BLOCK: INTEGER; 
			NBIT_BLOCKS: INTEGER; 
			NBIT : INTEGER);
	PORT (A :    IN	 STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
		  B :    IN	 STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
		  Cin :	 IN	 STD_LOGIC;
		  S :    OUT STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
	      Cout : OUT STD_LOGIC); 
END COMPONENT P4_ADDER;

	type shifts is array (32 downto 1) of std_logic_vector(31 downto 0);
	SIGNAL padding : std_logic_vector(31 downto 0); ---This signal helps us to concatenate the respective zeros once we have done the operation
	signal lsl, lsr : shifts;  	
	signal output_P4: std_logic_vector (31 downto 0);
    signal output_Cout: std_logic;
begin
	P4_adder_inst: P4_ADDER GENERIC MAP (
			IVDELAY => IVDELAY,
			NDDELAY => NDDELAY,
			NDDELAYRISE => NDDELAYRISE,
			NDDELAYFALL => NDDELAYFALL,
			NRDELAY => NRDELAY,
			DRCAS => DRCAS,
			DRCAC => DRCAC,
			NumBit  => NumBit,
			TP_MUX => TP_MUX,
			NBIT_EACH_BLOCK => NBIT_EACH_BLOCK,
			NBIT_BLOCKS => NBIT_BLOCKS,
			NBIT => NBIT ) 
	PORT MAP (A => DATA1, B => DATA2, Cin => FUNC(1), S => output_P4, Cout => output_Cout);
	-- generate all the possible shifts, then select on of them based on the value of data2
	padding <= (others => '0');
	-- uses the padding signal to shift the signal left or right
	g1: for i in 32 downto 1 generate
		lsl(i) <= data1(31-i downto 0)&padding(i-1 downto 0);
	end generate g1;

	g2: for i in 32 downto 1 generate
		lsr(i) <= padding(i-1 downto 0)&data1(31 downto i);
	end generate g2;

P_ALU: process (FUNC, DATA1, DATA2, output_P4)
  -- complete all the requested functions

  begin	
    case FUNC is
	when "0001" 	=> --ADD
		OUTALU <= output_P4; 

	when "0010" 	=> --SUB
		OUTALU <= output_P4;

	when "0011" 	=> -- Bitwise AND
		OUTALU <= DATA1 AND DATA2 ; 

	when "0100" 	=> --Bitwise OR
		OUTALU <= DATA1 OR DATA2;

	when "0101" 	=> --Bitwise XOR
		OUTALU <= DATA1 XOR DATA2;

	
	when "0110" 	=> -- sge >=
		if (DATA1 >= DATA2) then
		OUTALU <= x"00000001";
		else
		OUTALU <= (others => '0');
		end if;

	when "0111" 	=> -- sle <=
		if (DATA1 <= DATA2) then
		OUTALU <= x"00000001";
		else
		OUTALU <= (others => '0');
		end if;

	when "1000" 	=> -- sne !=
		if (DATA1 /= DATA2) then
		OUTALU <= x"00000001";
		else
		OUTALU <= (others => '0');
		end if;

	when "1001" 	=> -- logical shift left
		if (DATA2 < x"0020") then	
			if (conv_integer(DATA2) /= 0) then
			OUTALU <= lsl(conv_integer(DATA2));
			else
			OUTALU <= DATA1;
			end if;
		else
		OUTALU <= (others => '0');
		end if;

	when "1010" 	=> --logical shift right
		if (DATA2 < x"0020") then
			if (conv_integer(DATA2) /= 0) then		
			OUTALU <= lsr(conv_integer(DATA2));
			else
			OUTALU <= DATA1;
			end if;
		else
		OUTALU <= (others => '0');
		end if;

	when others => OUTALU <= (others => '0');
    end case; 
  end process P_ALU;

end BEHAVIOR;

configuration CFG_ALU_BEHAVIORAL of ALU is
  for BEHAVIOR
  end for;
end CFG_ALU_BEHAVIORAL;
