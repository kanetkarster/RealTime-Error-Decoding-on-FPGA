library ieee;


use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
-- use ieee.float_pkg.all;

entity adder_top is
	PORT (
		data_in1 : in signed(9 downto 0);
		data_in2 : in signed(9 downto 0);
		prob_out : out signed(9 downto 0));
		
	end adder_top;
		
architecture implementation of adder_top is
component bcd_add is
	PORT (
		data_in1 : in signed(9 downto 0);
		data_in2 : in signed(9 downto 0);
		sum : out signed(9 downto 0));	
end component;

signal sum1, sum2, sum3 : signed(9 downto 0);
constant BCD_ONE : signed(9 downto 0) := "0001000000";
constant BCD_NEG : signed(9 downto 0) := "1000000000";

begin
	addr1 : bcd_add
		port map (
			data_in1 => BCD_ONE,
			data_in2 => shift_left(data_in1, 1) or BCD_NEG,
			sum => sum1
		);

	addr2 : bcd_add
		port map (
			data_in1 => BCD_ONE,
			data_in2 => shift_left(data_in2, 1) or BCD_NEG,
			sum => sum2
		);

	addr3 : bcd_add
		port map (
			data_in1 => sum1,
			data_in2 => sum2,
			sum => prob_out
		);

	--prob_out <= prob_in + 1 - shift_left(data_in1, 1) +1 - shift_left(data_in2, 1);
end implementation;
	
	