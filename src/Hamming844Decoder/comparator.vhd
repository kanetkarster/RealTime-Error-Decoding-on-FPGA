--! @file comparator.vhd
--! @author Jit Kanetkar (2015)
--! @brief Decodes a 8 bit Hamming 844 CW using the Viterbi Algorithm

library ieee;


use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
-- use ieee.float_pkg.all;

--! @brief determines most probable state, by finding max BCD
--! @param prob1,prob2 input probabilities
--! @retval maxprob most probable data
entity comparator is
	PORT (
		prob1 : in signed(9 downto 0);
		prob2 : in signed(9 downto 0);
		maxprob : out signed(9 downto 0));
end comparator;

architecture implementation of comparator is
	signal data_max, data_min : signed(9 downto 0);
begin
	
	with std_logic_vector(prob1(8 downto 0))>=std_logic_vector(prob2(8 downto 0)) select data_max <=
		prob1 when true,
		prob2 when false;
	
	with std_logic_vector(prob1(8 downto 0))>=std_logic_vector(prob2(8 downto 0)) select data_min <=
		prob2 when true,
		prob1 when false;
	
	maxprob <= prob1 when prob1(9) = '1' and prob2(9) = '0' else 
				  prob2 when prob1(9) = '0' and prob2(9) = '1' else
				  data_min when prob1(9) = '0' and prob2(9) = '0' else
				  data_max;
	
end implementation;
