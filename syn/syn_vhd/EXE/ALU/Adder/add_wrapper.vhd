library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.myTypes.all;

-- structural wrapper for the adder
entity add_wrapper is
generic(N: integer := 32);
port(A,B: IN std_logic_vector(N-1 downto 0);
     SEL: IN aluOp;
     O: OUT std_logic_vector(N-1 downto 0));
end add_wrapper;

architecture Behavioral of add_wrapper is

-- Pentium 4 adder, as done in the labs
component P4_ADDER is
	generic (
		NBIT :		integer := 32);
	port (
		A :		in	std_logic_vector(NBIT-1 downto 0);
		B :		in	std_logic_vector(NBIT-1 downto 0);
		Cin :	in	std_logic;
		S :		out	std_logic_vector(NBIT-1 downto 0);
		Cout :	out	std_logic);
end component;

--unit used to invert sign of an operand if we need to do a subtraction
component add_sub is
generic(N: integer := 32);
port(A: IN std_logic_vector(N-1 downto 0);
     SEL: IN aluOp;
     O: OUT std_logic_vector(N-1 downto 0));
end component;

signal outp: std_logic_vector(N-1 downto 0);
signal sink: std_logic;  -- no use for carry-out in this design, so it's left floating

begin

sign: add_sub port map(A=>B, SEL => SEL, O => outp);
adder: P4_ADDER port map(A=>A, B=>outp, Cin=>'0', S=>O, Cout=>sink);

end Behavioral;
