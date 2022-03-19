library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity and_gate is
		port (
			A :		in	std_logic;
			B :		in	std_logic;
			O :	out	std_logic);
end and_gate;

architecture behavioral of and_gate is
begin
    O <= A and B;
end behavioral;    
