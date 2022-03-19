library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- small CAM used by the forwarding units to search for compatible instructions in the recently completed ones 
entity FWD_CAM is
port(RST             :IN std_logic;
     DATA_IN_1       :IN std_logic_vector(5 downto 0); -- OPCODE of instruction
     DATA_IN_2       :IN std_logic_vector(5 downto 0);
     DATA_IN_3       :IN std_logic_vector(5 downto 0);
     MATCH_1         :OUT std_logic;                   -- signal raised if related OPCODE is in the CAM
     MATCH_2         :OUT std_logic;
     MATCH_3         :OUT std_logic);
end FWD_CAM;

architecture Behavioral of FWD_CAM is

type CAMtype is array (0 to 19) of std_logic_vector(5 downto 0);

-- memory containing all the OPCODEs of instructions (not R-type) that write to a register the result of a calculation done by the ALU and need some register as source
constant CAM_mem : CAMtype := ("001000", --addi
                             "001001", --addui
                             "001010", --subi
                             "001011", --subui
                             "001100", --andi
                             "001101", --ori
                             "001110", --xori
                             "010100", --slli
                             "010110", --srli
                             "010111", --srai
                             "011000", --seqi
                             "011001", --snei
                             "011010", --slti
                             "011011", --sgti
                             "011100", --slei
                             "011101", --sgei
                             "111010", --sltui
                             "111011", --sgtui
                             "111100", --sleui
                             "111101"  --sgeui                             
                             );

begin
process(RST, DATA_IN_1, DATA_IN_2, DATA_IN_3)
begin
if(RST='0') then
    MATCH_1 <= '0';
    MATCH_2 <= '0';
    MATCH_3 <= '0';
else
    MATCH_1 <= '0';
    MATCH_2 <= '0';
    MATCH_3 <= '0';
    for i in 0 to 19 loop
        if(DATA_IN_1 = CAM_mem(i)) then
            MATCH_1 <= '1';
        end if;
        if(DATA_IN_2 = CAM_mem(i)) then
            MATCH_2 <= '1';
        end if;
        if(DATA_IN_3 = CAM_mem(i)) then
            MATCH_3 <= '1';
        end if;
    end loop;
end if;
end process;

end Behavioral;
