--! @file Hamming844Encoder.vhd
--! @author Jit Kanetkar (2015)
--! @brief Encodes a 4 bit input using the Hamming 844 formula

--! include standard library
library ieee;

--! include standard components
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

--! @brief Encodes a 4 bit input using the Hamming 844 formula
--! @param data data to be encoded. (m0 = data(0), ... m3 = data(3))
--! @retval encoded_data data encoded with the Hamming formula
--! 
--! implemeted as follows:
--! encoded_data (7->4) = data(3->0)
--! encoded_data (3) = data(0) + data(1) + data(2)
--! encoded_data (2) = data(0) + data(1) + data(3)
--! encoded_data (1) = data(0) + data(2) + data(3)
--! encoded_data (0) = data(1) + data(2) + data(3)
entity Hamming844Encoder is
	port (
		data : in std_logic_vector(3 downto 0);
		encoded_data : out std_logic_vector(7 downto 0)
	);
end Hamming844Encoder;

--! @brief the standard Hamming 844 Implementation
architecture impl of Hamming844Encoder is

begin
	--! assign top 4 bits to be same as input bits
	encoded_data(7 downto 4) <= data;
	
	--! assign parity bits
	encoded_data(3) <= data(3) XOR data(2) XOR data(1);
	encoded_data(2) <= data(3) XOR data(2) XOR data(0);
	encoded_data(1) <= data(3) XOR data(1) XOR data(0);
	encoded_data(0) <= data(2) XOR data(1) XOR data(0);

end impl;
