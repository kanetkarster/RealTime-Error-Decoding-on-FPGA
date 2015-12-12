library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Hamming844Encoder is
	port (
		data : in std_logic_vector(3 downto 0);
		encoded_data : out std_logic_vector(7 downto 0)
	);
end Hamming844Encoder;

architecture impl of Hamming844Encoder is

begin

end impl;