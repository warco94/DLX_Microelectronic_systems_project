library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity PG is
	Port ( 	PA: IN std_logic;
			PB: IN std_logic;
			GA: IN std_logic;
			GB: IN std_logic;
			P: OUT std_logic;
			G: OUT std_logic);
end PG;


architecture BEHAVIORAL of PG is
begin

P <= PA and PB;
G <= GA or (PA and GB);

end BEHAVIORAL;

configuration CFG_PG_BEHAVIORAL of PG is
	for BEHAVIORAL
	end for;
end CFG_PG_BEHAVIORAL;
