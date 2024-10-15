LIBRARY  IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE WORK.constants.ALL;

ENTITY TB_P4_ADDER IS
END TB_P4_ADDER;

ARCHITECTURE TEST OF TB_P4_ADDER IS
	
	-- P4 component declaration
	COMPONENT P4_ADDER IS
    	GENERIC(NBIT :  INTEGER := NBIT);
		PORT (A :		in	STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
			  B :		IN	STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
			  Cin :	    IN	STD_LOGIC;
			  S :		OUT STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
			  Cout :	OUT	STD_LOGIC); 
	END COMPONENT;

	SIGNAL A_s, B_s, S_s : STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
	SIGNAL Cin_s, Cout_s, CLK_s, RESET_s, LD1_s, LD2_s, EN_s:  STD_LOGIC;


	component Gen_lfsr is 
	Generic (N: integer); ---N should be a multiple of 16
		Port (
			CLK : in std_logic; 
			RESET : in std_logic; 
			LD : in std_logic; 
			EN : in std_logic; 
			DIN : in std_logic_vector (N-1 downto 0); 
			PRN : out std_logic_vector (N-1 downto 0); 
			ZERO_D : out std_logic);
	end component Gen_lfsr;
	
	SIGNAL DIN_s, PRN1_s, PRN2_s: std_logic_vector (NBIT-1 downto 0);
	CONSTANT clk_period: TIME:= 20 ns;	

BEGIN
	Adder: P4_ADDER GENERIC MAP(NBIT => NBIT) PORT MAP( A => A_s, B => B_s, Cin => Cin_s, S => S_s, Cout => Cout_s); 
	LFSR1: Gen_lfsr GENERIC MAP(N => NBIT) PORT MAP (CLK => CLK_s, RESET => RESET_s, LD => LD1_s, EN => EN_s, DIN => DIN_s, PRN => PRN1_s, ZERO_D => open);
	LFSR2: Gen_lfsr GENERIC MAP(N => NBIT) PORT MAP (CLK => CLK_s, RESET => RESET_s, LD => LD2_s, EN => EN_s, DIN => DIN_s, PRN => PRN2_s, ZERO_D => open);

	A_s <= PRN1_s;
	B_s <= PRN2_s;
	Cin_s <= '1'; --set Cin_s to 0 for addition, and 1 for subtraction

	clock_process: PROCESS
	BEGIN
		CLK_s <= '0';
		WAIT FOR clk_period/2;
		CLK_s <= '1';
		WAIT FOR clk_period/2;
	END PROCESS clock_process;

	RESET_s <= '1', '0' AFTER clk_period;


   
  STIMULUS1: PROCESS
  BEGIN
	  DIN_s <= (others => '1');
	  EN_s <='0';
	  LD1_s <='1';
	  LD2_s <='0';
	  WAIT FOR 2 * clk_period;
	  DIN_s(NBIT-1 downto 0) <= (OTHERS => '0');
	  DIN_s(NBIT-1 downto 1) <= (others => '0');  --The first inputs where the values related to the worst case, here A is set to 111...1
	  DIN_s(0) <= '1';
	  LD1_s <='0';
	  LD2_s <='1';
	  WAIT FOR 2 * clk_period;
	  DIN_s(NBIT-1 downto 0) <= (OTHERS => '0');  --And here B is set to 000...01
	  DIN_s(NBIT-1) <= '1';
	  DIN_s(12) <= '1';
	  DIN_s(8) <= '1';
	  DIN_s(7) <= '1';
	  DIN_s(0) <= '1';
	  LD1_s <='0';
	  LD2_s <='1';
	  WAIT FOR 2 * clk_period;		 
	  LD2_s <='0';
	  EN_s <= '1';
	  WAIT FOR (65600 * clk_period);  --The remaining values for the inputs are computed by the LFSR, which generate random values
  END PROCESS STIMULUS1;

END TEST;

