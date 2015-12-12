--! @file Hamming844Encoder.vhd
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
--! encoded_data (0->3) = data(0->3)
--! encoded_data (4) = data(0) + data(1) + data(2)
--! encoded_data (5) = data(0) + data(1) + data(3)
--! encoded_data (6) = data(0) + data(2) + data(3)
--! encoded_data (7) = data(1) + data(2) + data(3)
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
	encoded_data(3 downto 0) <= data;
	
	--! assign parity bits
	encoded_data(4) <= data(0) XOR data(1) XOR data(2);
	encoded_data(5) <= data(0) XOR data(1) XOR data(3);
	encoded_data(6) <= data(0) XOR data(2) XOR data(3);
	encoded_data(7) <= data(1) XOR data(2) XOR data(3);

end impl;
