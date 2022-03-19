library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

entity DRAM is
  generic (
    RAM_DEPTH : integer := 4096;
    I_SIZE : integer := 32);
    port (
      Rst, En  : in  std_logic;
      Addr : in  std_logic_vector(11 downto 0);
      R_W  : in std_logic;
      SEL  : in std_logic_vector(2 downto 0);    -- Selector for different kind of load and store instructions
      Din  : in  std_logic_vector(I_SIZE - 1 downto 0);
      Dout : out std_logic_vector(I_SIZE - 1 downto 0));
end DRAM;

architecture Behavioral of DRAM is

-- 32 bit words
type RAMtype is array (0 to RAM_DEPTH - 1) of std_logic_vector(7 downto 0);

signal DRAM_mem : RAMtype;

begin
process(R_W, Addr,Rst,Din, En, SEL)
begin
if(rst='0') then
    for i in 0 to RAM_DEPTH-1 loop
      DRAM_mem(i) <= (others => '0');
    end loop;
    Dout <= (others => '0');
elsif(En = '1') then        -- data saved in big endian mode, so written and read values are converted
    if(R_W='0') then
        if(SEL = "000") then     -- lw
            Dout(31 downto 24) <= DRAM_mem(conv_integer(unsigned(Addr)));
            Dout(23 downto 16) <= DRAM_mem(conv_integer(unsigned(Addr)) + 1);
            Dout(15 downto 8) <= DRAM_mem(conv_integer(unsigned(Addr)) + 2);
            Dout(7 downto 0) <= DRAM_mem(conv_integer(unsigned(Addr)) + 3);
        elsif(SEL = "001") then  -- lh
            Dout(31 downto 16) <= (others => DRAM_mem(conv_integer(unsigned(Addr)))(7));
            Dout(15 downto 8) <= DRAM_mem(conv_integer(unsigned(Addr)));
            Dout(7 downto 0) <= DRAM_mem(conv_integer(unsigned(Addr)) + 1);
        elsif(SEL = "010") then  -- lhu
            Dout(31 downto 16) <= (others => '0');
            Dout(15 downto 8) <= DRAM_mem(conv_integer(unsigned(Addr)));
            Dout(7 downto 0) <= DRAM_mem(conv_integer(unsigned(Addr)) + 1);
        elsif(SEL = "011") then -- lb
            Dout(31 downto 8) <= (others => DRAM_mem(conv_integer(unsigned(Addr)))(7));
            Dout(7 downto 0) <= DRAM_mem(conv_integer(unsigned(Addr)));
        elsif(SEL = "100") then -- lbu
            Dout(31 downto 8) <= (others => '0');
            Dout(7 downto 0) <= DRAM_mem(conv_integer(unsigned(Addr)));
        end if;
    else
        if(SEL = "101") then     -- sw
            DRAM_mem(conv_integer(unsigned(Addr)) + 3)<=Din(7 downto 0);
            DRAM_mem(conv_integer(unsigned(Addr)) + 2)<=Din(15 downto 8);
            DRAM_mem(conv_integer(unsigned(Addr)) + 1)<=Din(23 downto 16);
            DRAM_mem(conv_integer(unsigned(Addr)))<=Din(31 downto 24);
        elsif(SEL = "110") then  -- sh
            DRAM_mem(conv_integer(unsigned(Addr)) + 1)<=Din(7 downto 0);
            DRAM_mem(conv_integer(unsigned(Addr)))<=Din(15 downto 8);
        elsif(SEL = "111") then  -- sb
            DRAM_mem(conv_integer(unsigned(Addr)))<=Din(7 downto 0);
        end if;
    end if;
end if;
end process;

end Behavioral;
