--! @file xor10.vhd
--! @author Jit Kanetkar (2015)
--! @brief xors each bit in two 32 bit vectors

--! include standard library
library ieee;

--! include standard components
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

--! @brief 10 bit xor
--! @param a vector a
--! @param b vector b
--! @retval c a xor b
entity xor10 is
	port (
		a, b : in std_logic_vector(9 downto 0);
		c : out std_logic_vector(9 downto 0)
	);
end xor10;

architecture impl of xor10 is
begin
	c <= a xor b;
end impl;
