library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity xor_gate is
		port (
			A :		in	std_logic;
			B :		in	std_logic;
			O :	out	std_logic);
end xor_gate;

architecture behavioral of xor_gate is
begin
    O <= A xor B;
end behavioral;    
