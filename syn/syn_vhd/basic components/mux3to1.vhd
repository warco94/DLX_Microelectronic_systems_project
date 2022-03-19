library IEEE;
use IEEE.std_logic_1164.all;

entity mux_3to1 is
  generic(N: integer := 32);
	Port (	A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		C:	In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic_vector(1 downto 0);
		Y:	Out	std_logic_vector(N-1 downto 0));
end mux_3to1;


architecture BEHAVIORAL of mux_3to1 is

begin
	pmux: process(A,B,C,SEL)
	begin
		if SEL="01" then
			Y <= B;
	    elsif SEL="10" then
	        Y <= C;
		else
			Y <= A;
		end if;

	end process;

end BEHAVIORAL;

