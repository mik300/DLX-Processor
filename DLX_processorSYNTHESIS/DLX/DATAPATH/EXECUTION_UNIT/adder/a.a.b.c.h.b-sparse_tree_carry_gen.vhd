library ieee; 
use ieee.std_logic_1164.all;
--use WORK.constants.all;
use WORK.mypackage.all;

entity sparse_tree_carry_gen is
	generic (NBit: integer:= 1);
	port (A, B: in std_logic_vector(NBit - 1 downto 0);
		  Cin: in std_logic;
		  XORED_B: out std_logic_vector(NBit - 1 downto 0);
		  Cout: out std_logic_vector((NBit - 1)/4 downto 0)); --We need to change this in the feature because the system has to work with parametric 																	number of bits and number of Cout blocks(signals in this case). So it should be 																(Nbit-1)/Nblocks DOWNTO 0
end sparse_tree_carry_gen;


architecture structural of sparse_tree_carry_gen is

	component PG_block is
		port (a, b: in std_logic; --a and b correspond to the input signals that we want to add
			  g, p: out std_logic);
	end component;

	component general_prop is
		port (Pik, Gik, Pk_1j, Gk_1j: in std_logic;
		      Pij, Gij: out std_logic);
	end component;

	component general_generate is
		port (Pik, Gik, Gk_1j: in std_logic;
		      Gij: out std_logic);
	end component;

    component XOR_block is
        Port (a, b: in std_logic;
              z: out std_logic );
    end component;

	constant Nb_rows : integer := log2(NBit) + 1; --This parameter establishes the maximum number of rows. In this case, this is related to the last 								                                  column of the tree which is the only one that has a G block in that last row. We have 															  log2(Nbit) + 1 because we consider the PG network as well.
	--variable Nb_G_blocks, max_nb_G_blocks : integer := 1;
	type SignalVector is array (Nb_rows-1 downto 0) of std_logic_vector(Nbit-1 downto 0);
	signal p_matrix, g_matrix: SignalVector;
    signal out_XOR: std_logic_vector(Nbit-1 downto 0);

	begin
    XORED_B <= out_XOR;
	rows: for i in 0 to Nb_rows-1 generate --Important consideration: i => rows, j => columns

		 columns: for j in 0 to NBit-1 generate

			PG_network: if(i = 0) generate	--This block of code generate the PG network and connects it to its inputs(A and B) and outputs
			    XOR_block_j: XOR_block port map (a => Cin, b => B(j), z => out_XOR(j));
				exception1:  if(j = 0) generate 
					G_block_i_j: general_generate port map (Pik => A(j), Gik => out_XOR(j), Gk_1j=> Cin, Gij => g_matrix(i)(j));
			    end generate exception1; 

				others2: if(j /= 0 ) generate
					PG_j: PG_block port map (a => A(j), b=> out_XOR(j), p => p_matrix(i)(j), g => g_matrix(i)(j));
				end generate others2;
				
			end generate PG_network;			
	
			--The first row is only composed of PG BLOCKS expect for the first column(exception of G block)
			row0: if(i = 1) generate
				exception1: if(j = 0) generate  --This is the an exception because we only have one G block connected to the first column, and in this 													case, we also have as input Cin.
					G_block_i_j: general_generate port map (Pik => p_matrix(i-1)(j+1), Gik => g_matrix(i-1)(j+1), Gk_1j=> g_matrix(i-1)(j), Gij => g_matrix(i)(j+1));
				end generate exception1;

				others1: if((j*2 + 1 < Nbit) and (j/=0)) generate --In this case, we cover the columns in pairs and we specify that the the total 					 	                 number of columns has to be 1 unit smaller than the number of bits. Moreover, we don't consider the first column.
					PG_block_i_j: general_prop port map (Pik => p_matrix(i-1)(j*2+1), Gik => g_matrix(i-1)(j*2+1), Pk_1j => p_matrix(i-1)(j*2), Gk_1j => g_matrix(i-1)(j*2), Pij => p_matrix(i)(j*2+1), Gij => g_matrix(i)(j*2+1));
				end generate others1;
			end generate row0;

			row1: if(i = 2) generate
				exception2: if(j = 0) generate --In this case, we connect the block to the fourth column(index 3)
					G_block_i_j: general_generate port map (Pik => p_matrix(i-1)(3), Gik => g_matrix(i-1)(3), Gk_1j => g_matrix(i-1)(1), Gij => g_matrix(i)(3));
				end generate exception2;

				others2: if(((j mod 4) = 0) and (j/=0)) generate --values of j are: 4, 8, 12 (for Nbits = 16). Basically, we find a PG block when the column number is a multiple of 4(number of bits per each block--sumGenerator).
					PG_block_i_j: general_prop port map (Pik => p_matrix(i-1)(j+3), Gik => g_matrix(i-1)(j+3), Pk_1j => p_matrix(i-1)(j+1), Gk_1j => g_matrix(i-1)(j+1), Pij => p_matrix(i)(j+3), Gij => g_matrix(i)(j+3));
				end generate others2;			
			end generate row1;
		
			rowX: if(i >= 3) generate

				nb_elements: if( ((j mod (2**i)) >= 2**(i-1)) and ((i mod (2**i)) < 2**i) and ((j+1) mod 4 = 0)) generate --these conditions filter 																													 out the correct column indexes, 																												  		 so after this if statement, j 																									takes the required values for the sparse tree to work 																(for i=3: j = 7, 15, 23, 31 | for i=4: j = 11, 15, 27, 31 | for i=5: j = 19, 23, 27, 31)
					G: if(j < 2**i) generate
						G_block_i_j: general_generate port map (p_matrix(i-1)(j), g_matrix(i-1)(j), g_matrix(i-1)((j/(2**(i-1))*2**(i-1)) - 1), g_matrix(i)(j));
					end generate G;
					PG: if(j >= 2**i) generate
						PG_block_i_j: general_prop port map (p_matrix(i-1)(j), g_matrix(i-1)(j), p_matrix(i-1)((j/(2**(i-1))*2**(i-1)) - 1), g_matrix(i-1)((j/(2**(i-1))*2**(i-1)) - 1), p_matrix(i)(j), g_matrix(i)(j));
					end generate PG;
				end generate nb_elements;

				signals_connections: if( ((j mod (2**i)) < 2**(i-1)) and ((j mod (2**i)) >= 0) and (((j+1) mod 4) = 0) ) generate --This generate is 																to connect a specific column of the matrix in a row to the previous row (depending on the column index)
					p_matrix(i)(j) <= p_matrix(i-1)(j);
					g_matrix(i)(j) <= g_matrix(i-1)(j);
				end generate signals_connections;
			end generate rowX;

			--Here, we consider the final connection, and we say that if the column position is a multiple of 4, Cout is connected to that column
			Carry_out: if(i = (Nb_rows - 1)) generate
				radix4: if(((j+1) mod 4) = 0) generate
					Cout(j/4) <= g_matrix(i)(j);
				end generate radix4;
			end generate Carry_out;
			
		end generate columns;
	end generate rows;			
end architecture structural;





