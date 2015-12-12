--! @file NoiseAdder.vhd
--! @author Jit Kanetkar (2015)
--! @brief sets nosie level

--! include standard library
library ieee;

--! include standard components
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

--! @brief sets nosie level
--! @param a input noise
--! @param level how much to shift noise
--! @retval noise_adj adjusted noise levels
entity NoiseAdder is
	port (
		noise : in signed(9 downto 0);
		level : in std_logic_vector(2 downto 0);
		noise_adj : out signed(9 downto 0)
	);
end NoiseAdder;

architecture impl of NoiseAdder is
begin
	noise_adj <= shift_right(noise, to_integer(unsigned(level)));
end impl;
