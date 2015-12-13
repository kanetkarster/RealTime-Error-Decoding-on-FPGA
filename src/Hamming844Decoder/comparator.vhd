 library ieee;


use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
-- use ieee.float_pkg.all;

entity comparator is
	PORT (
		prob1 : in signed(9 downto 0);
		prob2 : in signed(9 downto 0);
		maxprob : out signed(9 downto 0));
end comparator;

architecture implementation of comparator is
	signal data_max, data_min : signed(9 downto 0);
begin
	
	with prob1>=prob2 select data_max <=
		prob1 when true,
		prob2 when false;
	
	with prob1>=prob2 select data_min <=
		prob2 when true,
		prob1 when false;
	
	maxprob <= prob1 when prob1(9) = '1' and prob2(9) = '0' else 
				  prob2 when prob1(9) = '0' and prob2(9) = '1' else
				  data_min when prob1(9) = '0' and prob2(9) = '0' else
				  data_max;
	
end implementation;
	
	