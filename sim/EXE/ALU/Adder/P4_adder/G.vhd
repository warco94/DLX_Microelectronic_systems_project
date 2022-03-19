library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity G is
	Port ( 	PA: IN std_logic;
			GA: IN std_logic;
			GB: IN std_logic;
			G: OUT std_logic);
end G;


architecture BEHAVIORAL of G is
begin

G <= GA or (PA and GB);

end BEHAVIORAL;

configuration CFG_G_BEHAVIORAL of G is
	for BEHAVIORAL
	end for;
end CFG_G_BEHAVIORAL;
