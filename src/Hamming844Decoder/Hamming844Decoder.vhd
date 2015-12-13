--! @file Hamming844Decoder.vhd
--! @author Jit Kanetkar (2015)
--! @brief Decodes a 8 bit Hamming 844 CW using the Viterbi Algorithm

library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

--! @brief Decodes a Hamming 844 message
--! @param c1..c8 input bits
--! @retval data most probable data
entity Hamming844Decoder is
	PORT (
		clk : in std_logic;
		c1 : in signed(9 downto 0);
		c2 : in signed(9 downto 0);
		c3 : in signed(9 downto 0);
		c4 : in signed(9 downto 0);
		c5 : in signed(9 downto 0);
		c6 : in signed(9 downto 0);
		c7 : in signed(9 downto 0);
		c8 : in signed(9 downto 0);
		data : out std_logic_vector(7 downto 0);
		maxprob : out signed(9 downto 0));
end Hamming844Decoder;

architecture implementation of Hamming844Decoder is

------------------------
----- Traverse Top -----
------------------------

---- stage 1 inputs
--11010100
--constant c1 : signed(9 downto 0) := "0001000111";
--constant c2 : signed(9 downto 0) := "0001011000";
--
---- stage 2 inputs
--constant c3 : signed(9 downto 0) := "0000001100";
--constant c5 : signed(9 downto 0) := "0000001111";
--
---- stage 3 inputs
--constant c4 : signed(9 downto 0) := "0001011000";
--constant c6 : signed(9 downto 0) := "0000111111";
--
---- stage 4 inputs
--constant c7 : signed(9 downto 0) := "0000011001";
--constant c8 : signed(9 downto 0) := "0000001111";

------------------------
----- Traverse Bot -----
------------------------
----10011001
---- stage 1 inputs
--constant c1 : signed(9 downto 0) := "0001000000";
--constant c2 : signed(9 downto 0) := "0000000000";
--
---- stage 2 inputs
--constant c3 : signed(9 downto 0) := "0000000000";
--constant c5 : signed(9 downto 0) := "0001000000";
--
---- stage 3 inputs
--constant c4 : signed(9 downto 0) := "0001000000";
--constant c6 : signed(9 downto 0) := "0000000000";
--
---- stage 4 inputs
--constant c7 : signed(9 downto 0) := "0000000000";
--constant c8 : signed(9 downto 0) := "0001000000";

------------------------
---- ONE FLIPPED BIT----
------------------------

---- stage 1 inputs
--constant c1 : signed(9 downto 0) := "0000000000";
--constant c2 : signed(9 downto 0) := "0000000000";
--
---- stage 2 inputs
--constant c3 : signed(9 downto 0) := "0001000000";
--constant c5 : signed(9 downto 0) := "0001000000";
--
---- stage 3 inputs
--constant c4 : signed(9 downto 0) := "0001000000";
--constant c6 : signed(9 downto 0) := "0001000000";	
--
---- stage 4 inputs
--constant c7 : signed(9 downto 0) := "0001000000";	-- FLIPPED BIT
--constant c8 : signed(9 downto 0) := "0000000000";

------------------------
-- THREE ERRONOUS BITS--
------------------------
----11101000
---- stage 1 inputs
--constant c1 : signed(9 downto 0) := "0001000000";	--0001000000
--constant c2 : signed(9 downto 0) := "0000100000";	--0001000000
--
---- stage 2 inputs
--constant c3 : signed(9 downto 0) := "0001000000";	--0001000000
--constant c5 : signed(9 downto 0) := "0000100000";	--0001000000
--
---- stage 3 inputs
--constant c4 : signed(9 downto 0) := "0000000000";	--0000000000
--constant c6 : signed(9 downto 0) := "0000100000";	--0000000000
--
---- stage 4 inputs
--constant c7 : signed(9 downto 0) := "0000000000";	--0000000000
--constant c8 : signed(9 downto 0) := "0000000000";	--0000000000

------------------------
-- THREE ERRONOUS BITS--
------------------------
----10001110
---- stage 1 inputs
--constant c1 : signed(9 downto 0) := "0001000000";
--constant c2 : signed(9 downto 0) := "0000000000";
--
---- stage 2 inputs
--constant c3 : signed(9 downto 0) := "0000100000";	--0000000000
--constant c5 : signed(9 downto 0) := "0000100000";	--0001000000
--
---- stage 3 inputs
--constant c4 : signed(9 downto 0) := "0000100000";	--0000000000
--constant c6 : signed(9 downto 0) := "0001000000";
--
---- stage 4 inputs
--constant c7 : signed(9 downto 0) := "0001000000";	
--constant c8 : signed(9 downto 0) := "0000000000";

signal s1_t, s2_t, s3_t, s4_t : std_logic_vector(1 downto 0);
signal s1_b, s2_b, s3_b, s4_b : std_logic_vector(1 downto 0);
component st1
	PORT (
		c1 : in signed(9 downto 0);
		c2 : in signed(9 downto 0);
		p1_o, p2_o, p3_o, p4_o : out signed(9 downto 0);
		top : out std_logic_vector(1 downto 0);
		bot : out std_logic_vector(1 downto 0));
end component;

component st2
	PORT (
		c1 : in signed(9 downto 0);
		c2 : in signed(9 downto 0);
		p1_i, p2_i, p3_i, p4_i : in signed(9 downto 0);
		p1_o, p2_o, p3_o, p4_o : out signed(9 downto 0);
		top : out std_logic_vector(1 downto 0);
		bot : out std_logic_vector(1 downto 0));
end component;

component st4
	PORT (
		c1 : in signed(9 downto 0);
		c2 : in signed(9 downto 0);
		p1_i, p2_i, p3_i, p4_i : in signed(9 downto 0);
		stage : out std_logic;
		top : out std_logic_vector(1 downto 0);
		bot : out std_logic_vector(1 downto 0));
end component;

component bcd_add is
	PORT (
		data_in1 : in signed(9 downto 0);
		data_in2 : in signed(9 downto 0);
		sum : out signed(9 downto 0));	
end component;

signal p1_s1, p2_s1, p3_s1, p4_s1 : signed(9 downto 0);
signal p1_s2, p2_s2, p3_s2, p4_s2 : signed(9 downto 0);
signal p1_s3, p2_s3, p3_s3, p4_s3 : signed(9 downto 0);
signal which : std_logic;
begin
	stage1 : st1 
		port map (
			c1 => c1,
			c2 => c2,
			p1_o => p1_s1,
			p2_o => p2_s1,
			p3_o => p3_s1,
			p4_o => p4_s1,
			top => s1_t,
			bot => s1_b
		);
	stage2 : st2
		port map (
			c1 => c3,
			c2 => c5,
			p1_i => p1_s1,
			p2_i => p2_s1,
			p3_i => p3_s1,
			p4_i => p4_s1,
			p1_o => p1_s2,
			p2_o => p2_s2,
			p3_o => p3_s2,
			p4_o => p4_s2,
			top => s2_t,
			bot => s2_b
		);
	stage3 : st2
		port map (
			c1 => c4,
			c2 => c6,
			p1_i => p1_s2,
			p2_i => p2_s2,
			p3_i => p3_s2,
			p4_i => p4_s2,
			p1_o => p1_s3,
			p2_o => p2_s3,
			p3_o => p3_s3,
			p4_o => p4_s3,
			top => s3_t,
			bot => s3_b
		);
	
	stage4 : st4
		port map (
			c1 => c7,
			c2 => c8,
			p1_i => p1_s3, p2_i => p2_s3, p3_i => p3_s3, p4_i => p4_s3,
			stage => which,
			top => s4_t,
			bot => s4_b
		);
	data <= s1_t(1) & s1_t(0) & s2_t(1) & s3_t(1) & s2_t(0) & s3_t(0) & s4_t(1) & s4_t(0) when which = '0' else 
			  s1_b(1) & s1_b(0) & s2_b(1) & s3_b(1) & s2_b(0) & s3_b(0) & s4_b(1) & s4_b(0);

	--maxprob <= to_signed(0, 10);
end implementation;
