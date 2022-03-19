library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.myTypes.all;

-- simple behavioural unit that does boolean logic operations
entity logic is
generic(N: integer := 32);
port(A,B: IN std_logic_vector(N-1 downto 0);
     SEL: IN aluOp;
     O: OUT std_logic_vector(N-1 downto 0));
end logic;

architecture Behavioral of logic is

begin
process(A,B,SEL)
begin
case SEL is
    WHEN ANDS => O <= (A AND B);
    WHEN ORS => O <= (A OR B);
    WHEN XORS => O <= (A XOR B);
    WHEN others => O <= (others => '0');
end case;
end process;

end Behavioral;
