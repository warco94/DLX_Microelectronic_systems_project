library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use WORK.constants.all;
use WORK.all;
use IEEE.math_real.all;

entity register_file is
generic( N :		integer := 32; --data bit
		 addBit :	integer := 5);  --address bit 
 port (RESET,RE,WE: 	IN std_logic;
	 ADD_WR: 	IN std_logic_vector(addBit-1 downto 0);
	 ADD_RDA: 	IN std_logic_vector(addBit-1 downto 0);
	 ADD_RDB: 	IN std_logic_vector(addBit-1 downto 0);
	 DATAIN: 	IN std_logic_vector(N-1 downto 0);
     OUTA: 		OUT std_logic_vector(N-1 downto 0);
	 OUTB: 		OUT std_logic_vector(N-1 downto 0));
end register_file;

architecture A of register_file is

        
        subtype REG_ADDR is natural range 0 to 2**addBit-1; -- using natural type
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(N-1 downto 0); 
	signal REGISTERS : REG_ARRAY; 

	
begin 
-- write your RF code 

registerfile: process(RESET, ADD_WR, ADD_RDA, ADD_RDB, DATAIN, RE, WE, REGISTERS)
begin

if (RESET = '0') then
    for i in 0 to 2**addBit-1 loop
      REGISTERS(i) <= (others => '0');
    end loop;    
    OUTA <= (others => '0');
    OUTB <= (others => '0');
else
    if( WE = '1' and unsigned(ADD_WR) /= 0)then -- ADD_WR has to be /= 0 because r0 is a read only register
        REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
    end if;
    if RE = '1' then
        OUTA <= REGISTERS(to_integer(unsigned(ADD_RDA)));
        OUTB <= REGISTERS(to_integer(unsigned(ADD_RDB)));
    end if;
end if;

end process registerfile;


end A;




configuration CFG_RF_BEH of register_file is
  for A
  end for;
end configuration;
