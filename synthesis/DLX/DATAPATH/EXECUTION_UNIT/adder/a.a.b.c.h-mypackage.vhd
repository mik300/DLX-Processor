library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
--use work.constants.all;

package mypackage is
	constant nBits : integer := 32;
	function log2 (n: integer) return integer;
end mypackage;

package body mypackage is

	function log2(n: integer) return integer is
		variable temp : integer := n;
		variable ret_val : integer := 0;
	begin
		while temp > 1 loop 
			ret_val := ret_val + 1;
			temp := temp / 2;
		end loop;
	
	 return ret_val;
	end function;
end mypackage;
