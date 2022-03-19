library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.myTypes.all;
use IEEE.NUMERIC_STD.ALL;

-- simple unit used to change sign of an operand in case of subtraction
entity add_sub is
generic(N: integer := 32);
port(A: IN std_logic_vector(N-1 downto 0);
     SEL: IN aluOp;
     O: OUT std_logic_vector(N-1 downto 0));
end add_sub;

architecture Behavioral of add_sub is

begin
process(A,SEL)
begin
if(SEL=SUBS) then
    O <= std_logic_vector(- signed(A));
else
    O <= A;
end if;    
end process;

end Behavioral;
