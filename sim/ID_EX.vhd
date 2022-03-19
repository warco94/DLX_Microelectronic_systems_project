library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- pipe registers between ID and EXE stages
entity ID_EX is
port(CLK,RST:IN std_logic; 
     NPC_IN         :IN std_logic_vector(31 downto 0);
     NPC_L_IN       :IN std_logic_vector(31 downto 0);
     A_IN           :IN std_logic_vector(31 downto 0);
     B_IN           :IN std_logic_vector(31 downto 0);
     IMM_IN         :IN std_logic_vector(31 downto 0);
     RS1_IN         :IN std_logic_vector(4 downto 0);
     RS2_IN         :IN std_logic_vector(4 downto 0);
     RD_IN          :IN std_logic_vector(4 downto 0);
     OPCODE_IN      :IN std_logic_vector(5 downto 0);
     IR_IN          :IN std_logic_vector(15 downto 0);
     PR_IN          :IN std_logic;
     NPC_OUT        :OUT std_logic_vector(31 downto 0);
     NPC_L_OUT        :OUT std_logic_vector(31 downto 0);
     A_OUT          :OUT std_logic_vector(31 downto 0);
     B_OUT          :OUT std_logic_vector(31 downto 0);
     IMM_OUT        :OUT std_logic_vector(31 downto 0);
     RS1_OUT        :OUT std_logic_vector(4 downto 0);
     RS2_OUT        :OUT std_logic_vector(4 downto 0);
     RD_OUT         :OUT std_logic_vector(4 downto 0);
     OPCODE_OUT     :OUT std_logic_vector(5 downto 0);
     IR_OUT         :OUT std_logic_vector(15 downto 0);
     PR_OUT         :OUT std_logic);
end ID_EX;

architecture Behavioral of ID_EX is

begin
process(CLK,RST)
begin
if(RST='0') then
   A_OUT <= (others => '0');
   B_OUT <= (others => '0');
   IMM_OUT <= (others => '0');
   NPC_OUT <= (others => '0');
   NPC_L_OUT <= (others => '0');
   RS1_OUT <= (others => '0');
   RS2_OUT <= (others => '0');
   RD_OUT <= (others => '0');
   OPCODE_OUT <= (others => '0');
   IR_OUT <= (others => '0');
   PR_OUT <= '0';
elsif(CLK='1' and CLK'event) then
   A_OUT <= A_IN;
   B_OUT <= B_IN;
   IMM_OUT <= IMM_IN;
   NPC_OUT <= NPC_IN;
   NPC_L_OUT <= NPC_L_IN;
   RS1_OUT <= RS1_IN;
   RS2_OUT <= RS2_IN;
   RD_OUT <= RD_IN;
   OPCODE_OUT <= OPCODE_IN;
   IR_OUT <= IR_IN;
   PR_OUT <= PR_IN;
end if;
end process;


end Behavioral;
