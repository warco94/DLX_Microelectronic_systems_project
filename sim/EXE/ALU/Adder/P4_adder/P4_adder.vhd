library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;
entity P4_ADDER is
	generic (
		NBIT :		integer := NumBit);
	port (
		A :		in	std_logic_vector(NBIT-1 downto 0);
		B :		in	std_logic_vector(NBIT-1 downto 0);
		Cin :	in	std_logic;
		S :		out	std_logic_vector(NBIT-1 downto 0);
		Cout :	out	std_logic);
end P4_ADDER;

architecture STRUCTURAL of P4_ADDER is

component CARRY_GENERATOR_PARAMETRIC is
		generic (
			NBIT :		integer := NumBit;
			NBIT_PER_BLOCK: integer := BitBlock);
		port (
			A :		in	std_logic_vector(NBIT-1 downto 0);
			B :		in	std_logic_vector(NBIT-1 downto 0);
			Cin :	in	std_logic;
			Co :	out	std_logic_vector((NBIT/NBIT_PER_BLOCK)-1 downto 0));
end component;

component SUM_GENERATOR is
	generic (
		NBIT_PER_BLOCK: integer := BitBlock;
		NBLOCKS:	integer := BLOCKS);
	port (
		A:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
		B:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
		Cin:	in	std_logic_vector(NBLOCKS-1 downto 0);
		S:	out	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
end component;
	
signal carryv, cinv: std_logic_vector((NBIT/BitBlock)-1 downto 0);	
	
begin

C_GEN: CARRY_GENERATOR_PARAMETRIC
	generic map (NBIT => NBIT, NBIT_PER_BLOCK => BitBlock)
	port map (A => A, B => B, Cin => Cin, Co => carryv);

cinv <= carryv((NBIT/BitBlock)-2 downto 0) & Cin; --da 6 a 0

S_GEN: SUM_GENERATOR
	generic map (NBIT_PER_BLOCK => BitBlock, NBLOCKS => NBIT/BitBlock)
	port map (A => A, B => B, Cin => cinv, S => S);

Cout <= carryv((NBIT/BitBlock)-1); --7
	
end STRUCTURAL;

configuration CFG_P4_ADDER_STRUCTURAL of P4_ADDER is
  for STRUCTURAL 
      for C_GEN : CARRY_GENERATOR_PARAMETRIC
        use configuration WORK.CFG_CARRY_GENERATOR_PARAMETRIC_STRUCTURAL;
      end for;
	  for S_GEN : SUM_GENERATOR
		USE CONFIGURATION WORK.CFG_SUM_GENERATOR_STRUCTURAL;
	  end for;
    end for;
end CFG_P4_ADDER_STRUCTURAL;
