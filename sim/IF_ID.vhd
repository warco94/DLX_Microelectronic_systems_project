library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- pipe registers between IF and ID stages
entity IF_ID is
port(CLK,RST,DISCARD:IN std_logic; 
     NPC_IN         :IN std_logic_vector(31 downto 0);
     NPC_L_IN       :IN std_logic_vector(31 downto 0); -- unaltered NPC in case of jal or jalr
     IR_IN          :IN std_logic_vector(31 downto 0);
     PR_IN          :IN std_logic;
     NPC_OUT        :OUT std_logic_vector(31 downto 0);
     NPC_L_OUT      :OUT std_logic_vector(31 downto 0);
     IR_OUT         :OUT std_logic_vector(31 downto 0);
     PR_OUT         :OUT std_logic);        
     
end IF_ID;

architecture Behavioral of IF_ID is

begin
process(CLK,RST,DISCARD)
begin

if(RST='0') then
   IR_OUT <= x"54000000";
   NPC_OUT <= (others => '0');
   NPC_L_OUT <= (others => '0');
   PR_OUT <= '0';
elsif(DISCARD = '1') then --discard used to flush the pipeline in case of wrong prediction of jump with register
   IR_OUT <= x"54000000"; -- insert nope instruction
   NPC_OUT <= NPC_IN; --still allow PC value to pass for re-evaluation of a branch
elsif(CLK='1' and CLK'event) then
   IR_OUT <= IR_IN;
   NPC_OUT <= NPC_IN;
   NPC_L_OUT <= NPC_L_IN;
   PR_OUT <= PR_IN;
end if;

end process;

end Behavioral;
