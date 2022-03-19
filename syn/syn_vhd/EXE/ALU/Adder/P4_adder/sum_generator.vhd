library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity SUM_GENERATOR is
	generic (
		NBIT_PER_BLOCK: integer := 4;
		NBLOCKS:	integer := 8);
	port (
		A:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
		B:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
		Cin:	in	std_logic_vector(NBLOCKS-1 downto 0);
		S:	out	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
end SUM_GENERATOR;

architecture STRUCTURAL of SUM_GENERATOR is

component carry_select_block is 
	generic (--DRCAS_csb 	: 	Time := 0 ns;
	         --DRCAC_csb	: 	Time := 0 ns;
             --DEL_MUX	:   Time := tp_mux;
             N			:	integer:=NumBit);
	Port (	A:	In	std_logic_vector(N-1 downto 0);
			B:	In	std_logic_vector(N-1 downto 0);
			Ci:	In	std_logic;
			S:	Out	std_logic_vector(N-1 downto 0));
end component;

begin

blocks: for I in 0 to NBLOCKS-1 generate
	BLI: carry_select_block
		generic map (N => NBIT_PER_BLOCK)
		port map (A=>A(NBIT_PER_BLOCK*(1+I)-1 downto NBIT_PER_BLOCK*i),B=>B(NBIT_PER_BLOCK*(1+I)-1 downto NBIT_PER_BLOCK*i),
				  Ci=>Cin(i), S=>S(NBIT_PER_BLOCK*(1+I)-1 downto NBIT_PER_BLOCK*i));
end generate;

end STRUCTURAL;


configuration CFG_SUM_GENERATOR_STRUCTURAL of SUM_GENERATOR is
  for STRUCTURAL 
     -- for all : carry_select_block
       -- use configuration WORK.CFG_carry_select_block_STRUCTURAL;
    --  end for;
    end for;
end CFG_SUM_GENERATOR_STRUCTURAL;
