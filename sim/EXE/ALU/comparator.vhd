library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.myTypes.all;

-- unit in charge of comparing the values of number depending on the ALUcode
-- used to implemento instructions like SLE, SNE, SEQ and so on
entity comparator is
generic(N: integer := 32);
port(inA, inB: IN std_logic_vector(N-1 downto 0);
     op: aluOp;
     res: OUT std_logic_vector(N-1 downto 0));
end comparator;

architecture Behavioral of comparator is

begin
process(inA,inB, op)
begin
res <= (others => '0');
if(op = SEQ or op = SNE or op = SLE or op = SGE or op = SLT or op = SGT) then
    if(signed(inA) = signed(inB)) then
        case op is
            when SEQ => res <= std_logic_vector(to_signed(1, 32));
            when SLE => res <= std_logic_vector(to_signed(1, 32));
            when SGE => res <= std_logic_vector(to_signed(1, 32));
            when others => res <= (others => '0');
        end case;
    elsif(signed(inA) < signed(inB)) then
        case op is
            when SLT => res <= std_logic_vector(to_signed(1, 32)); 
            when SLE => res <= std_logic_vector(to_signed(1, 32));
            when SNE => res <= std_logic_vector(to_signed(1, 32));
            when others => res <= (others => '0');
        end case;
    else
        case op is
            when SGT => res <= std_logic_vector(to_signed(1, 32));
            when SGE => res <= std_logic_vector(to_signed(1, 32));
            when SNE => res <= std_logic_vector(to_signed(1, 32));
            when others => res <= (others => '0');
        end case;
    end if;
else
     if(unsigned(inA) = unsigned(inB)) then
        case op is
            when SEQ => res <= std_logic_vector(to_signed(1, 32));
            when SLEU => res <= std_logic_vector(to_signed(1, 32));
            when SGEU => res <= std_logic_vector(to_signed(1, 32));
            when others => res <= (others => '0');
        end case;
    elsif(unsigned(inA) < unsigned(inB)) then
        case op is
            when SLTU => res <= std_logic_vector(to_signed(1, 32)); 
            when SLEU => res <= std_logic_vector(to_signed(1, 32));
            when SNE => res <= std_logic_vector(to_signed(1, 32));
            when others => res <= (others => '0');
        end case;
    else
        case op is
            when SGTU => res <= std_logic_vector(to_signed(1, 32));
            when SGEU => res <= std_logic_vector(to_signed(1, 32));
            when SNE => res <= std_logic_vector(to_signed(1, 32));
            when others => res <= (others => '0');
        end case;
    end if;
end if;
end process;

end Behavioral;
