library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity TBREGISTERFILE is
end TBREGISTERFILE;

architecture TESTA of TBREGISTERFILE is
	
	   signal CLK: std_logic := '0';
	   signal RESET: std_logic;
	   signal WR: std_logic;
	   signal ADD_WR: std_logic_vector(ADDR_LENGTH-1 downto 0);
	   signal ADD_RD1: std_logic_vector(ADDR_LENGTH-1 downto 0);
	   signal ADD_RD2: std_logic_vector(ADDR_LENGTH-1 downto 0);
	   signal DATA_IN: std_logic_vector(DATA_LENGTH-1 downto 0);
	   signal OUT1: std_logic_vector(DATA_LENGTH-1 downto 0);
	   signal OUT2: std_logic_vector(DATA_LENGTH-1 downto 0);

	component register_file
	GENERIC( ADDR_LEN : NATURAL := addr_length;
			 DATA_LEN : NATURAL := data_length );
	PORT (CLK:      IN  std_logic;
          RESET: 	IN  std_logic;
	      WR: 		IN  std_logic;
	      ADD_WR: 	IN  std_logic_vector(ADDR_LEN-1 DOWNTO 0);
	      ADD_RD1: 	IN  std_logic_vector(ADDR_LEN-1 DOWNTO 0);
	      ADD_RD2: 	IN  std_logic_vector(ADDR_LEN-1 DOWNTO 0);
	      DATAIN: 	IN  std_logic_vector(DATA_LEN-1 DOWNTO 0); --1 WRITE AT A TIME
          OUT1:     OUT std_logic_vector(DATA_LEN-1 DOWNTO 0); --2 READS AT A TIME
	      OUT2:     OUT std_logic_vector(DATA_LEN-1 DOWNTO 0));
	end component;

begin 

	RG:register_file PORT MAP (CLK, RESET, WR, ADD_WR, ADD_RD1, ADD_RD2, DATA_IN, OUT1, OUT2);
	-- RESET <= '1','0' after 5 ns;
	-- ENABLE <= '0','1' after 3 ns, '0' after 10 ns, '1' after 15 ns;
	-- WR <= '0','1' after 6 ns, '0' after 7 ns, '1' after 10 ns, '0' after 20 ns;
	-- RD1 <= '1','0' after 5 ns, '1' after 13 ns, '0' after 20 ns; 
	-- RD2 <= '0','1' after 17 ns;
	-- ADD_WR <= "10110", "01000" after 9 ns;
	-- ADD_RD1 <="10110", "01000" after 9 ns;
	-- ADD_RD2<= "11100", "01000" after 9 ns;
	-- DATAIN<=(others => '0'),(others => '1') after 8 ns;

	TEST_VECTOR : process
	begin
		RESET   <= '1';
		WR      <= '0';
		ADD_WR  <= "00000";
		ADD_RD1 <= "00000";
		ADD_RD2 <= "00000";
		DATA_IN <= (OTHERS => '0');
		WAIT FOR CLK_PERIOD;
		WAIT FOR CLK_PERIOD/10;
		RESET   <= '0';
		WR      <= '1';
		ADD_WR  <= "00110";
		ADD_RD1 <= "00110";
		ADD_RD2 <= "00110";
		DATA_IN <=  X"1F0BBC00";
		WAIT FOR CLK_PERIOD;
		WAIT FOR CLK_PERIOD/10;
		RESET   <= '0';
		WR      <= '0';
		ADD_WR  <= "00110";
		ADD_RD1 <= "00110";
		ADD_RD2 <= "00110";
		DATA_IN <=  X"1F0BBC00";
		WAIT FOR CLK_PERIOD;
		WAIT FOR CLK_PERIOD/10;
		RESET   <= '0';
		WR      <= '1';
		ADD_WR  <= "00100";
		ADD_RD1 <= "00101";
		ADD_RD2 <= "00100";
		DATA_IN <=  X"1F000000";
		WAIT FOR CLK_PERIOD;
		WAIT FOR CLK_PERIOD/10;
		RESET   <= '0';
		WR      <= '1';
		ADD_WR  <= "00100";
		ADD_RD1 <= "00101";
		ADD_RD2 <= "00100";
		DATA_IN <=  X"1F000000";
		WAIT FOR CLK_PERIOD;
		WAIT FOR CLK_PERIOD/10;
		RESET   <= '0';
		WR      <= '0';
		ADD_WR  <= "00100";
		ADD_RD1 <= "00101";
		ADD_RD2 <= "00100";
		DATA_IN <=  X"1F000000";
		WAIT FOR CLK_PERIOD;
		WAIT FOR CLK_PERIOD/10;
		RESET   <= '0';
		WR      <= '0';
		ADD_WR  <= "00100";
		ADD_RD1 <= "00101";
		ADD_RD2 <= "00100";
		DATA_IN <=  X"1F000000";
		WAIT FOR CLK_PERIOD;
		WAIT FOR CLK_PERIOD/10;
		RESET   <= '1';
		WR      <= '0';
		ADD_WR  <= "00100";
		ADD_RD1 <= "00101";
		ADD_RD2 <= "00100";
		DATA_IN <=  X"1F000000";
		WAIT FOR CLK_PERIOD;
		WAIT FOR CLK_PERIOD/10;
		RESET   <= '0';
		WR      <= '1';
		ADD_WR  <= "00000";
		ADD_RD1 <= "00110";
		ADD_RD2 <= "00110";
		DATA_IN <=  X"1F0BBC00";
		WAIT FOR CLK_PERIOD;
		WAIT FOR CLK_PERIOD/10;
		RESET   <= '0';
		WR      <= '1';
		ADD_WR  <= "00001";
		ADD_RD1 <= "00110";
		ADD_RD2 <= "00110";
		DATA_IN <=  X"1F0BBC00";
		WAIT;
	end process TEST_VECTOR; 

	PCLOCK : process(CLK)
	begin
		CLK <= not(CLK) after CLK_PERIOD/2;	
	end process;

end TESTA;

---
configuration CFG_TESTRF of TBREGISTERFILE is
  for TESTA
	for RG : register_file
		use configuration WORK.CFG_RF_BEH;
	end for; 
  end for;
end CFG_TESTRF;
