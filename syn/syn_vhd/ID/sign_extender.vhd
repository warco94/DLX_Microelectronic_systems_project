library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



-- this is used to add the remaining bit to reach 32 bit starting from the immediates contained in the instructions that use them
-- it takes the instraction code as input and outputs a 32 bit vector containing the sign extended immediate
-- depending on the instruction it will be extended as signed or unsigned
entity sign_extender is
port(d_in: IN std_logic_vector(31 downto 0);
     rst: IN std_logic;
     d_ext: OUT std_logic_vector(31 downto 0));
end sign_extender;

architecture Behavioral of sign_extender is

begin

process(rst,d_in)
begin
if(rst='0') then
    d_ext <=  (others => '0');
elsif(d_in(31 downto 26) = "000010" or d_in(31 downto 26) = "000011") then
    d_ext <= std_logic_vector(resize(signed(d_in(25 downto 0)), 32));
elsif(d_in(31 downto 26) = "001001" or d_in(31 downto 26) = "001011" or d_in(31 downto 26) = "111010"               -- for instructions using unsigned immediates
      or d_in(31 downto 26) = "111011" or d_in(31 downto 26) = "111100" or d_in(31 downto 26) = "111101"
      or d_in(31 downto 26) = "001100" or d_in(31 downto 26) = "001101" or d_in(31 downto 26) = "001110"
      or d_in(31 downto 26) = "010100" or d_in(31 downto 26) = "010110" or d_in(31 downto 26) = "010111") then          
    d_ext <= std_logic_vector(resize(unsigned(d_in(15 downto 0)), 32));
else
    d_ext <= std_logic_vector(resize(signed(d_in(15 downto 0)), 32));
end if;
end process;


end Behavioral;
