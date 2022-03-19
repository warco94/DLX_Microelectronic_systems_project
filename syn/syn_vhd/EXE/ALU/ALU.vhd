library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.myTypes.all;

-- structural construction of ALU
entity ALU is
generic(N: integer := 32);
port(INA,INB: IN std_logic_vector(N-1 downto 0);
     OP: IN aluOp;
     alu_out: OUT std_logic_vector(N-1 downto 0));
end ALU;

architecture Behavioral of ALU is

component comparator is
generic(N: integer := 32);
port(inA, inB: IN std_logic_vector(N-1 downto 0);
     op: aluOp;
     res: OUT std_logic_vector(N-1 downto 0));
end component;

component logic is
generic(N: integer := 32);
port(A,B: IN std_logic_vector(N-1 downto 0);
     SEL: IN aluOp;
     O: OUT std_logic_vector(N-1 downto 0));
end component;

component SHIFTER_GENERIC is
	generic(N: integer := 32);
	port(	A: in std_logic_vector(N-1 downto 0);
		B: in std_logic_vector(N-1 downto 0);
		sel: IN aluOp;
		OUTPUT: out std_logic_vector(N-1 downto 0)
	);

end component;

component add_wrapper is
generic(N: integer := 32);
port(A,B: IN std_logic_vector(N-1 downto 0);
     SEL: IN aluOp;
     O: OUT std_logic_vector(N-1 downto 0));
end component;

-- all outputs of different units enter this mux, that lets out the correct one depending on the operation required
component mux4to1 is
generic(N: integer := 32);
port(inadd: IN std_logic_vector(N-1 downto 0);
     inlog: IN std_logic_vector(N-1 downto 0);
     insh: IN std_logic_vector(N-1 downto 0);
     incom: IN std_logic_vector(N-1 downto 0);
     sel: IN aluOp;
     O: OUT std_logic_vector(N-1 downto 0));
end component;
signal sink: std_logic;
signal res1,res2,res3,res4: std_logic_vector(N-1 downto 0);
begin

adder: add_wrapper port map(A=>INA, B=>INB, SEL=>OP, O => res1);
log: logic port map(A=>INA, B=>INB, SEL=>OP, O => res2);
shifter: SHIFTER_GENERIC port map(A=>INA, B=>INB, sel=>OP, OUTPUT => res3);
comp: comparator port map(inA=>INA, inB=>INB, op=>OP, res => res4);
mux: mux4to1 port map (inadd=>res1,inlog=>res2,insh=>res3,incom=>res4,sel=>OP,O=>alu_out);

end Behavioral;
