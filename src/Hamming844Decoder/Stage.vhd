library ieee;


use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
-- use ieee.float_pkg.all;

entity st1 is
	PORT (
		c1 : in signed(9 downto 0);
		c2 : in signed(9 downto 0);
		--prob_in : in signed(9 downto 0);
		p1_o, p2_o, p3_o, p4_o : out signed(9 downto 0);
		top : out std_logic_vector(1 downto 0);
		bot : out std_logic_vector(1 downto 0));
	end st1;
		
architecture implementation of st1 is
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

-- SIGNALS --
signal ptop, pbot : signed(9 downto 0);
signal p1, p2, p3, p4 : signed(9 downto 0);
begin
	p1 <= to_signed(0, 10);
	state_11_addr : adder_top
		port map (
			data_in1 => c1,
			data_in2 => c2,
			prob_out => p2
		);
	
	stage_01_addr : adder_bottom
		port map (
			data_in => c2,
			prob_out => p3
		);
	
	stage_10_addr : adder_bottom
		port map (
			data_in => c1,
			prob_out => p4
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
	top <= "00" when ptop = p1 else 
			 "11" when ptop = p2;

	bot <= "01" when pbot = p3 else 
			 "10" when pbot = p4;
	p1_o <= p1; p2_o <= p2; p3_o <= p3; p4_o <= p4;
end implementation;
	
	