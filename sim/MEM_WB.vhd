library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- pipe registers between MEM and WB stages
entity MEM_WB is
port(CLK,RST:IN std_logic; 
     NPC_L_IN         :IN std_logic_vector(31 downto 0);
     ALU_IN           :IN std_logic_vector(31 downto 0);
     LMD_IN           :IN std_logic_vector(31 downto 0);
     RD_IN          :IN std_logic_vector(4 downto 0);
     OPCODE_IN      :IN std_logic_vector(5 downto 0);
     NPC_L_OUT        :OUT std_logic_vector(31 downto 0);
     ALU_OUT          :OUT std_logic_vector(31 downto 0);
     LMD_OUT          :OUT std_logic_vector(31 downto 0);
     RD_OUT         :OUT std_logic_vector(4 downto 0);
     OPCODE_OUT      :OUT std_logic_vector(5 downto 0));
end MEM_WB;

architecture Behavioral of MEM_WB is

begin
process(CLK,RST)
begin
if(RST='0') then
   ALU_OUT <= (others => '0');
   LMD_OUT <= (others => '0');
   NPC_L_OUT <= (others => '0');
   RD_OUT <= (others => '0');
   OPCODE_OUT <= (others => '0');
elsif(CLK='1' and CLK'event) then
   ALU_OUT <= ALU_IN;
   LMD_OUT <= LMD_IN;
   NPC_L_OUT <= NPC_L_IN;
   RD_OUT <= RD_IN;
   OPCODE_OUT <= OPCODE_IN;
end if;
end process;

end Behavioral;
