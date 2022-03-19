library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity register_e is
generic(N: integer := 32);
port (D: IN std_logic_vector(N-1 downto 0);
      clk, rst: IN std_logic;
      O: OUT std_logic_vector(N-1 downto 0));
end register_e;

architecture Behavioral of register_e is

begin

process(clk)
begin
if(clk='1' and clk'event) then
    if(rst='0') then
        O <= (others => '0');
    else
        O <= D;
    end if;
end if;
end process;


end Behavioral;
