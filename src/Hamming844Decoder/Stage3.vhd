--! @file Stage3.vhd
--! @author Jit Kanetkar (2015)
--! @brief Decodes a 8 bit Hamming 844 CW using the Viterbi Algorithm

library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

--! @brief Stage 3 of Viterbi Decoder
--! @param c1,c2 noisy input bits
--! @param p1..p4 probabilites of each state in trellis from previous stage
--! @retval top most probable data from top of trellis
--! @retval bot most probable data from bottom of trellis
--! @retval stage whether the top path or bottom path was more likely
entity st4 is
	PORT (
		c1 : in signed(9 downto 0);
		c2 : in signed(9 downto 0);
		p1_i, p2_i, p3_i, p4_i : in signed(9 downto 0);
		stage : out std_logic;
		top : out std_logic_vector(1 downto 0);
		bot : out std_logic_vector(1 downto 0));
	end st4;
		
architecture implementation of st4 is
-- COMPONENTS --
component adder_bottom
	port (
		data_in : in signed(9 downto 0);
		prob_out : out signed(9 downto 0));
end component;

component adder_top
	port (
		data_in1 : in signed(9 downto 0);
		data_in2 : in signed(9 downto 0);
		prob_out : out signed(9 downto 0));
end component;

component comparator
	port (
		prob1 : in signed(9 downto 0);
		prob2 : in signed(9 downto 0);
		maxprob : out signed(9 downto 0));
end component;

component bcd_add is
	PORT (
		data_in1 : in signed(9 downto 0);
		data_in2 : in signed(9 downto 0);
		sum : out signed(9 downto 0));	
end component;

-- SIGNALS --
signal change_top, change_bottom : signed(9 downto 0);
signal same_top, same_bottom : signed(9 downto 0);
signal p1_o, p2_o, p3_o, p4_o : signed(9 downto 0);
signal prob : signed(9 downto 0);

constant BCD_ZERO : signed(9 downto 0) := "0000000000";

signal prob_1to1, prob_2to2,
		 prob_3to3, prob_4to4 : signed(9 downto 0);

signal min_1, min_2 : signed(9 downto 0);
begin
	-- calculate change weights
	prob_1to1 <= BCD_ZERO;
	addr_top_2 : adder_top
		port map (
			data_in1 => c1,
			data_in2 => c2,
			prob_out => prob_2to2
		);
	
	addr_bot_3 : adder_bottom
		port map (
			data_in => c2,
			prob_out => prob_3to3
		);
	
	addr_bot_4 : adder_bottom
		port map (
			data_in => c1,
			prob_out => prob_4to4
		);
	-- add previous weights
	addr_prob1 : bcd_add
		port map (
			data_in1 => p1_i,
			data_in2 => prob_1to1,
			sum => p1_o
		);
	addr_prob2 : bcd_add
		port map (
			data_in1 => prob_2to2,
			data_in2 => p2_i,
			sum => p2_o
		);
	addr_prob3 : bcd_add
		port map (
			data_in1 => prob_3to3,
			data_in2 => p3_i,
			sum => p3_o
		);
	addr_prob4 : bcd_add
		port map (
			data_in1 => prob_4to4,
			data_in2 => p4_i,
			sum => p4_o
		);
	-- find max probabilities
	min_top : comparator
		port map (
			prob1 => p1_o,
			prob2 => p2_o,
			maxprob => min_1
		);
	min_bot : comparator
		port map (
			prob1 => p3_o,
			prob2 => p4_o,
			maxprob => min_2
		);
	min_final : comparator
		port map (
			prob1 => min_1,
			prob2 => min_2,
			maxprob => prob
		);

	stage <= '0' when prob = min_1 else 
				'1';
	top <= "00" when p1_o = min_1 else 
			 "11" when p2_o = min_1;
			 
	bot <= "01" when p3_o = min_2 else 
			 "10" when p4_o = min_2;
end implementation;
	
	