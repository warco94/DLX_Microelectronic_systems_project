library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity BUFF is
	Port ( 	IG: IN std_logic;
			IP: IN std_logic;
			OG: OUT std_logic;
			OP: OUT std_logic);
end BUFF;


architecture BEHAVIORAL of BUFF is
begin

--O <= I after 0.1 ns;
	OG<=IG;
	OP<=IP;
end BEHAVIORAL;

configuration CFG_BUFF_BEHAVIORAL of BUFF is
	for BEHAVIORAL
	end for;
end CFG_BUFF_BEHAVIORAL;
