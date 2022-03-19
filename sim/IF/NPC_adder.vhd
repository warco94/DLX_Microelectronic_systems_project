library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


-- simple adder, just takes a number as input and outputs that number +4
entity NPC_adder is
port (inPC: IN std_logic_vector(31 downto 0);
      outPC: OUT std_logic_vector(31 downto 0));
end NPC_adder;

architecture Behavioral of NPC_adder is

begin

process(inPC)
begin
if(signed(inPC) < 1020) then -- limit the value of PC to the maximum value addressable in the IRAM
    outPC <= std_logic_vector(signed(inPC) + 4);
end if;
end process;


end Behavioral;
