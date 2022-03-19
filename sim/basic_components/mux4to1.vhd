library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.myTypes.all;


entity mux4to1 is
generic(N: integer := 32);
port(inadd: IN std_logic_vector(N-1 downto 0);
     inlog: IN std_logic_vector(N-1 downto 0);
     insh: IN std_logic_vector(N-1 downto 0);
     incom: IN std_logic_vector(N-1 downto 0);
     sel: IN aluOp;
     O: OUT std_logic_vector(N-1 downto 0));
end mux4to1;

architecture Behavioral of mux4to1 is

begin

process(inadd,inlog,insh,incom,sel)
begin

case sel is
    when ADDS => O <= inadd;
    when SUBS => O <= inadd;
    when ANDS => O <= inlog;
    when ORS => O <= inlog;
    when XORS => O <= inlog;
    when LLS => O <= insh;
    when LRS => O <= insh;
    when RAS => O <= insh;
    when SNE => O <= incom;
    when SGE => O <= incom;
    when SLE => O <= incom;
    when SEQ => O <= incom;
    when SGT => O <= incom;
    when SLT => O <= incom;
    when SGEU => O <= incom;
    when SLEU => O <= incom;
    when SGTU => O <= incom;
    when SLTU => O <= incom;
    when J => O <= inadd;
    when JAL => O <= inadd;
    when JR => O <= inadd;
    when JALR => O <= inadd;
    when BNEZ => O <= inadd;
    when BEQZ => O <= inadd;
    when others => O <= (others => '0');
end case;    

end process;


end Behavioral;
