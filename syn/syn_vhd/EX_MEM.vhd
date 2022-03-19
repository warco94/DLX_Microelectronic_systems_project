library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- pipe registers between EXE and MEM stages
entity EX_MEM is
port(CLK,RST:IN std_logic; 
     NPC_IN         :IN std_logic_vector(31 downto 0);
     NPC_L_IN       :IN std_logic_vector(31 downto 0);
     ALU_IN         :IN std_logic_vector(31 downto 0);
     B_IN           :IN std_logic_vector(31 downto 0);
     RD_IN          :IN std_logic_vector(4 downto 0);
     OPCODE_IN      :IN std_logic_vector(5 downto 0);
     NPC_OUT        :OUT std_logic_vector(31 downto 0);
     NPC_L_OUT      :OUT std_logic_vector(31 downto 0);
     ALU_OUT        :OUT std_logic_vector(31 downto 0);
     B_OUT          :OUT std_logic_vector(31 downto 0);
     RD_OUT         :OUT std_logic_vector(4 downto 0);
     OPCODE_OUT     :OUT std_logic_vector(5 downto 0));
end EX_MEM;

architecture Behavioral of EX_MEM is

begin
process(CLK,RST)
begin
if(RST='0') then
   ALU_OUT <= (others => '0');
   B_OUT <= (others => '0');
   NPC_OUT <= (others => '0');
   NPC_L_OUT <= (others => '0');
   RD_OUT <= (others => '0');
   OPCODE_OUT <= (others => '0');
elsif(CLK='1' and CLK'event) then
   ALU_OUT <= ALU_IN;
   B_OUT <= B_IN;
   NPC_OUT <= NPC_IN;
   NPC_L_OUT <= NPC_L_IN;
   RD_OUT <= RD_IN;
   OPCODE_OUT <= OPCODE_IN;
end if;
end process;

end Behavioral;
