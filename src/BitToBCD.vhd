--! @file BitToBCD.vhd
--! @author Jit Kanetkar (2015)
--! @brief Encodes a bit as a BCD

--! include standard library
library ieee;

--! include standard components
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

--! @brief Encodes a bit as a BCD
--! @param b input binary encoded decmial
--! @retval bcd `b` encoded as BCD
--! BCD is the of the following structure:
--!
--! | sign | integer | decimal | (component)
--! |  1   |    3    |    6    | (# of bits)
--!
entity BitToBCD is
	port (
		b : in std_logic;
		bcd : out signed(9 downto 0)
	);
end BitToBCD;

architecture impl of BitToBCD is

constant BCD_ZERO	: signed(9 downto 0) := "0000000000";
constant BCD_ONE	: signed(9 downto 0) := "0001000000";

begin 
	with b select bcd <=
		BCD_ZERO when '0',
		BCD_ONE when '1';
end impl;