library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.myTypes.all;
use IEEE.NUMERIC_STD.ALL;

-- unit that evaluates the condition of a branch
-- depending on previous prediction it decides if the prediction was right or not and signals that
entity branch_cond is
generic(N: integer := 32);
port(A: IN std_logic_vector(N-1 downto 0);
     EN: IN std_logic;          -- enable from CU
     OP: IN aluOp;
     PRE: IN std_logic;         -- decision on branch done by previous prediction: 1 taken, 0 not taken
     DISCARD: OUT std_logic;    -- flush signal, force 2 NOP in pipeline if prediction was wrong
     WRONG: OUT std_logic;      -- signal raised when prediction was wrong
     RIGHT: OUT std_logic;      -- signal raised when prediction was right
     SEL: OUT std_logic);       -- signal to control mux at input of PC, to write to it in case of jr or jalr instructions
end branch_cond;

architecture Behavioral of branch_cond is

begin


-- small delays inserted in this process to deal with pulse caused by delta delays creating some trouble in simulation
process(PRE, A, OP, EN)
begin
SEL <= '0'; 
WRONG <= '0'; 
DISCARD <= '0'; 
RIGHT <= '0'; 
if(EN='1') then
    case OP is
        when JR => SEL <= '1'; DISCARD <= '1';
        when JALR => SEL <='1'; DISCARD <= '1';
        when BNEZ => if(unsigned(A) /= TO_UNSIGNED(0, 32)) then   
                        if(PRE = '0') then                  -- if PRE = 0 then the branch was not taken, but we now see it should've been taken, so we signal that
                            WRONG <= inertial '1' after 0.01 ns;         
                            DISCARD <= inertial '1' after 0.01 ns;
                        elsif(PRE = '1') then               -- if PRE = 1 then the branch was taken, we now see that was the right decision, so we signal that
                            RIGHT <= inertial '1' after 0.01 ns;     -- similar behaviour as previous two comments is repeated in the rest of the process                      
                        end if;
                      else
                        if(PRE = '0') then  
                            RIGHT <= inertial '1' after 0.01 ns;           
                        elsif(PRE = '1') then
                            WRONG <= inertial '1' after 0.01 ns;     
                            DISCARD <= inertial '1' after 0.01 ns;         
                        end if;
                      end if;
        when BEQZ => if(unsigned(A) = TO_UNSIGNED(0, 32)) then  
                        if(PRE = '0') then                       
                            WRONG <= inertial '1' after 0.01 ns;
                            DISCARD <= inertial '1' after 0.01 ns;      
                        elsif(PRE = '1') then
                            RIGHT <= inertial '1' after 0.01 ns;    
                        end if;
                     else
                        if(PRE = '0') then  
                            RIGHT <= inertial '1' after 0.01 ns;           
                        elsif(PRE = '1') then
                            WRONG <= inertial '1' after 0.01 ns;  
                            DISCARD <= inertial '1' after 0.01 ns;                         
                        end if;
                     end if;
        when others => SEL <= '0'; WRONG <= '0'; DISCARD <= '0'; RIGHT <= '0';
    end case;
end if;
end process;

end Behavioral;
