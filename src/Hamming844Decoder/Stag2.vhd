library ieee;


use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
-- use ieee.float_pkg.all;

entity st2 is
	PORT (
		c1 : in signed(9 downto 0);
		c2 : in signed(9 downto 0);
		p1_i, p2_i, p3_i, p4_i : in signed(9 downto 0);
		p1_o, p2_o, p3_o, p4_o : out signed(9 downto 0);
		top : out std_logic_vector(1 downto 0);
		bot : out std_logic_vector(1 downto 0));
	end st2;
		
architecture implementation of st2 is
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

signal prob_1to1, prob_2to1,
		 prob_1to2, prob_2to2,
		 prob_3to3, prob_4to3,
		 prob_3to4, prob_4to4 : signed(9 downto 0);
signal p1, p2, p3, p4 : signed(9 downto 0);
signal ptop, pbot : signed(9 downto 0);
signal ptop_prev, pbot_prev : signed(9 downto 0);
begin
	-- calculate change weights
	
	same_top <= to_signed(0, 10);
	
	change_addr_top : adder_top
	port map (
		data_in1 => c1,
		data_in2 => c2,
		prob_out => change_top
	);
	
	change_addr_bot : adder_bottom
	port map (
		data_in => c1,
		prob_out => change_bottom
	);
	
	same_addr_bot : adder_bottom
	port map (
		data_in => c2,
		prob_out => same_bottom
	);
	
	-- find max probabilities
	-- stage 00
	trans_top_1to1 : bcd_add
		port map (
			data_in1 => p1_i,
			data_in2 => same_top,
			sum => prob_1to1
		);
	trans_top_2to1 : bcd_add
		port map (
			data_in1 => p2_i,
			data_in2 => change_top,
			sum => prob_2to1
		);
	max_stage_00 : comparator
		port map (
			prob1 => prob_1to1,
			prob2 => prob_2to1,
			maxprob => p1
		);

	-- stage 11
	trans_top_1to2 : bcd_add
		port map (
			data_in1 => p1_i,
			data_in2 => change_top,
			sum => prob_1to2
		);
	trans_top_2to2 : bcd_add
		port map (
			data_in1 => p2_i,
			data_in2 => same_top,
			sum => prob_2to2
		);
	max_stage_11 : comparator
		port map (
			prob1 => prob_1to2,
			prob2 => prob_2to2,
			maxprob => p2
		);
	-- stage 01
	trans_bot_3to3 : bcd_add
		port map (
			data_in1 => p3_i,
			data_in2 => same_bottom,
			sum => prob_3to3
		);
	trans_bot_4to3 : bcd_add 
		port map (
			data_in1 => p4_i,
			data_in2 => change_bottom,
			sum => prob_4to3
		);
	max_stage_01 : comparator
		port map (
			prob1 => prob_3to3,
			prob2 => prob_4to3,
			maxprob => p3
		);
	-- stage 10
	trans_bot_3to4 : bcd_add
		port map (
			data_in1 => p3_i,
			data_in2 => change_bottom,
			sum => prob_3to4
		);
	trans_bot_4to4 : bcd_add
		port map (
			data_in1 => p4_i,
			data_in2 => same_bottom,
			sum => prob_4to4
		);
	max_stage_10 : comparator
		port map (
			prob1 => prob_3to4,
			prob2 => prob_4to4,
			maxprob => p4
		);
	max_top : comparator
		port map (
			prob1 => p1,
			prob2 => p2,
			maxprob => ptop
		);
	max_bot : comparator
		port map (
			prob1 => p3,
			prob2 => p4,
			maxprob => pbot
		);
	max_prev_top : comparator
		port map (
			prob1 => p1_i,
			prob2 => p2_i,
			maxprob => ptop_prev
	);
	max_prev_bot : comparator
		port map (
			prob1 => p3_i,
			prob2 => p4_i,
			maxprob => pbot_prev
	);
	top <= "00" when (ptop = p1 and (p1_i = ptop_prev)) or (ptop = p2 and (p2_i = ptop_prev)) else 
			 "11";

	bot <= "01" when (pbot = p3 and (p3_i = pbot_prev)) or (pbot = p4 and (p4_i = pbot_prev)) else 
			 "10";

	p1_o <= p1; p2_o <= p2; p3_o <= p3; p4_o <= p4;
end implementation;
	
	