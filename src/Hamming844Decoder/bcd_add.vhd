--! @file bcd_add.vhd
--! @author Jit Kanetkar (2015)
--! @brief Decodes a 8 bit Hamming 844 CW using the Viterbi Algorithm
library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

--! @brief adds two 9 bit bcd vectors
--! @param data_in1,data_in2 values to be added
--! @retval overflow if the addition overflowed
--! @retval sum their sum
entity bcd_add is
	PORT (
		data_in1 : in signed(9 downto 0);
		data_in2 : in signed(9 downto 0);
		sum : out signed(9 downto 0));
		
	end bcd_add;
		
architecture implementation of bcd_add is
	signal sign1, sign2 : std_logic;
	signal data_max, data_min : signed(9 downto 0);
begin
	-- find absolute maximum
	with std_logic_vector(data_in1(8 downto 0))>=std_logic_vector(data_in2(8 downto 0)) select data_max <=
		data_in1 when true,
		data_in2 when false;
	
	with std_logic_vector(data_in1(8 downto 0))>=std_logic_vector(data_in2(8 downto 0)) select data_min <=
		data_in2 when true,
		data_in1 when false;

	-- do addition
	sum(8 downto 0) <= data_max(8 downto 0) + data_min(8 downto 0) when data_in1(9) = data_in2(9) else 
							 data_max(8 downto 0) - data_min(8 downto 0);
	
	-- set sign
	sum(9) <= '1' when data_max(9) = '1' else
				 '0';
--	sum <= data_in1 + data_in2;
end implementation;