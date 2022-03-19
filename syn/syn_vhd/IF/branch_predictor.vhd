library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- this unit is in charge of predicting whether a branch will be taken or not
-- it does this through the use of a BHT (except for unconditional jumps with immediate addresses, that are just taken and directly inserted in the NPC)
entity branch_predictor is
port(RST          :IN std_logic;
     PC_IN        :IN std_logic_vector(31 downto 0);  -- current PC
     PC_FAIL      :IN std_logic_vector(31 downto 0);  -- PC from two instructions ago, used in the EXE stage where the conditional branch is evaluated to "go back"
     IR_IN        :IN std_logic_vector(31 downto 0);  -- current IR
     IR_FAIL      :IN std_logic_vector(15 downto 0);  -- same as PC_FAIL but for the relative address for the NPC in the instruction code
     WRONG_PRE    :IN std_logic;                      -- signal received to signal a prediction was wrong, used to restart and then update the BHT
     RIGHT_PRE    :IN std_logic;                      -- signal received to signal a prediction was right, used to update the BHT
     NPC_OUT      :OUT std_logic_vector(31 downto 0); -- NPC value decided depending on branch prediction
     LINK_ADD     :OUT std_logic_vector(31 downto 0); -- address to save in R31 in case of jal instruction
     SEL          :OUT std_logic;                     -- selection signal used to control the mux at the input of the NPC adder
     TAKEN        :OUT std_logic);                    -- signal used to signal that the branch was taken, used in EXE stage to verify if prediction was correct or not
end branch_predictor;   

architecture Behavioral of branch_predictor is

-- this little cache memory (small for speed) is our BHT
-- sizing depends on instruction memory size, by supposing that it's full and that conditional branches are around 15% of all instructions
type CACHE_type is array (0 to 31) of std_logic_vector(1 downto 0);
signal CACHE_mem : CACHE_type;
signal MEM_WRONG: std_logic;
signal MEM_RIGHT: std_logic;



begin

-- main process in charge of deciding whether a branch is taken or not, depending on the BHT entry if it is a conditional branch
-- ir receives both the actual PC and IR and depending on that makes a choice
selection: process(RST, PC_IN, IR_IN, WRONG_PRE, RIGHT_PRE, IR_FAIL, PC_FAIL)
begin
SEL <= '0';
TAKEN <= '0';
MEM_WRONG <= '0';
MEM_RIGHT <= '0';

if(RST = '0') then
    NPC_OUT <= (others => '0');
    LINK_ADD <= (others => '0');
elsif(WRONG_PRE = '1') then
    SEL <= '1';  
    if(CACHE_mem(to_integer(unsigned(PC_FAIL(6 downto 2)))) = "00" or CACHE_mem(to_integer(unsigned(PC_FAIL(6 downto 2)))) = "01") then
        NPC_OUT <= PC_FAIL; -- if we predicted taken before, we now load the PC with the value it would've had if we didn't take the branch
        MEM_WRONG <= '1'; -- update BHT
    elsif(CACHE_mem(to_integer(unsigned(PC_FAIL(6 downto 2)))) = "10" or CACHE_mem(to_integer(unsigned(PC_FAIL(6 downto 2)))) = "11") then
        NPC_OUT <= std_logic_vector((signed(PC_FAIL) + resize(signed(IR_FAIL), 32))); -- if we predicted not taken, now we load the PC with the value as taken
        MEM_WRONG <= '1'; -- update BHT
    end if;
elsif(IR_IN(31 downto 26) = "000010" or IR_IN(31 downto 26) = "000011") then --unconditional jumps, always take
    TAKEN <= '0'; -- no need to signal it was taken since there are no conditions to be evaluated
    SEL <= '1';
    NPC_OUT <= std_logic_vector((signed(PC_IN) + resize(signed(IR_IN(25 downto 0)), 32)));
    LINK_ADD <= std_logic_vector(signed(PC_IN) + 4);
elsif(IR_IN(31 downto 26) = "000100" or IR_IN(31 downto 26) = "000101") then -- conditional branch instructions, BEQZ and BNEZ
    if(CACHE_mem(to_integer(unsigned(PC_IN(6 downto 2)))) = "00" or CACHE_mem(to_integer(unsigned(PC_IN(6 downto 2)))) = "01") then -- if BHT entry says taken
        TAKEN <= '1';
        SEL <= '1';
        NPC_OUT <= std_logic_vector((signed(PC_IN) + resize(signed(IR_IN(15 downto 0)), 32)));
    elsif(CACHE_mem(to_integer(unsigned(PC_IN(6 downto 2)))) = "10" or CACHE_mem(to_integer(unsigned(PC_IN(6 downto 2)))) = "11") then -- if BHT entry says not taken
        TAKEN <= '0';
    end if;
end if;

if(RIGHT_PRE = '1') then -- update BHT if prediction was correct
    MEM_RIGHT <= '1';
end if;

end process selection;

-- process to update and populate BHT
-- the BHT updating works this way: we start with every entry with a 2-bit value, initially '00'
-- we have so 4 states:
-- if 00 we predict taken: if we're wrong we go to 01, if we're right we stay at 00, value unchanged
-- if 01 we predict taken: if we're wrong we go to 10, if we're right we go to 00
-- if 10 we predict not taken: if we're wrong we go to 11, if we're right we stay at 10, value unchanged
-- if 11 we predict not taken: if we're wrong we go to 00, if we're right we go to 10
-- this means that when we're wrong we change value by incrementing the 2-bit number as a 2-bit counter
-- when we're right we go to the "stable" state depending on the prediction
-- that means if we predicted taken and it was right we go/stay to 00, if predicted not taken and it was right we go/stay to 10
mem: process(RST, MEM_WRONG, MEM_RIGHT)
begin
if(RST = '0') then
    for i in 0 to 31 loop
        CACHE_mem(i) <= "00";
    end loop;
elsif(MEM_WRONG = '1') then
    CACHE_mem(to_integer(unsigned(PC_FAIL(6 downto 2)))) <= std_logic_vector(unsigned(CACHE_mem(to_integer(unsigned(PC_FAIL(6 downto 2))))) + to_unsigned(1, 2));
elsif(MEM_RIGHT = '1') then
    if(CACHE_mem(to_integer(unsigned(PC_FAIL(6 downto 2)))) = "01") then
        CACHE_mem(to_integer(unsigned(PC_FAIL(6 downto 2)))) <= "00";
    elsif(CACHE_mem(to_integer(unsigned(PC_FAIL(6 downto 2)))) = "11") then
        CACHE_mem(to_integer(unsigned(PC_FAIL(6 downto 2)))) <= "10";
    end if;
end if;
end process mem;

end Behavioral;
