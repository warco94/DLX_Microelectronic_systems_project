library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- unit whose purpose is to the decode the instruction and output the addresses of the registers involved
entity IR_decoder is
port(rst: IN std_logic;
     IR_OUT :IN std_logic_vector(20 downto 0);
     ADDS1  :OUT std_logic_vector(4 downto 0);  -- address for RS1
     ADDS2  :OUT std_logic_vector(4 downto 0);  -- address for RS2
     ADDD   :OUT std_logic_vector(4 downto 0)); -- for RD (destination register)
end IR_decoder;

architecture Behavioral of IR_decoder is

begin
process(IR_OUT, rst)
begin
ADDS1 <= (others => '0');
ADDS2 <= (others => '0');
ADDD <= (others => '0');
if(rst = '0') then
    ADDS1 <= (others => '0');
    ADDS2 <= (others => '0');
    ADDD <= (others => '0');
elsif(IR_OUT(20 downto 15) = "000000") then -- R-type instruction
    ADDS1 <= IR_OUT(14 downto 10);
    ADDS2 <= IR_OUT(9 downto 5);
    ADDD <= IR_OUT(4 downto 0);
elsif(IR_OUT(20 downto 15) = "101011" or IR_OUT(20 downto 15) = "101001" or IR_OUT(20 downto 15) = "101000") then -- sw, sb, sh instruction
    ADDS1 <= IR_OUT(14 downto 10);
    ADDS2 <= IR_OUT(9 downto 5);    
    ADDD <= (others => '0'); -- we don't write back to the register file, so RD forced to 0
else
    ADDS1 <= IR_OUT(14 downto 10);
    ADDD <= IR_OUT(9 downto 5);
    if(IR_OUT(20 downto 15) = "000011") then --jal instruction
        ADDD <= "11111"; -- R31
    elsif(IR_OUT(20 downto 15) = "000010" or IR_OUT(20 downto 15) = "010010"
		  or IR_OUT(20 downto 15) = "000100" or IR_OUT(20 downto 15) = "000101") then -- j, jr, beqz, bnez
        ADDD <= (others => '0');
    elsif(IR_OUT(20 downto 15) = "010011") then --jalr instruction
        ADDS2 <= IR_OUT(9 downto 5);    
        ADDD <= "11111"; -- R31
    end if;
end if;
end process;


end Behavioral;
