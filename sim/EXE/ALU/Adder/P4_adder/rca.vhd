library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity RCA is 
	generic (DRCAS : 	Time := 0 ns;
	         DRCAC : 	Time := 0 ns;
                 N: integer:=NumBit);
	Port (	A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(N-1 downto 0);
		Co:	Out	std_logic);
end RCA; 


architecture BEHAVIORAL of RCA is
signal carry: std_logic_vector(N downto 0);
begin

    process(A,B)
    variable  carryint: std_logic_vector(N downto 0) := (others => '0');
    begin
    carryint(0):=Ci;
    for i in 0 to N-1 loop -- same calculation like in FA, but in loop of N times
    S(i) <= A(i) xor B(i) xor carryint(i);-- after DRCAS;
    carryint(i+1) := ( A(i) and B(i) ) or ( B(i) and carryint(i) ) or ( A(i) and carryint(i) ); -- carry in a variable
    carry(i) <= carryint(i);-- after DRCAC; -- variable in a signal
    end loop;
    Co <= carry(N);
    end process;


end BEHAVIORAL;

architecture STRUCTURAL of RCA is

  signal STMP : std_logic_vector(N-1 downto 0);
  signal CTMP : std_logic_vector(N downto 0);

  component FA 
  --generic (--DFAS : 	Time := 0 ns;
           --DFAC : 	Time := 0 ns);
  Port ( A:	In	std_logic;
	 B:	In	std_logic;
	 Ci:	In	std_logic;
	 S:	Out	std_logic;
	 Co:	Out	std_logic);
  end component; 

begin

  CTMP(0) <= Ci;
  S <= STMP;
  Co <= CTMP(N);
  
  ADDER1: for I in 1 to N generate
    FAI : FA 
	--  generic map (DFAS => DRCAS, DFAC => DRCAC) 
	  Port Map (A(I-1), B(I-1), CTMP(I-1), STMP(I-1), CTMP(I)); 
  end generate;

end STRUCTURAL;


configuration CFG_RCA_STRUCTURAL of RCA is
  for STRUCTURAL 
    for ADDER1
      for all : FA
        use configuration WORK.CFG_FA_BEHAVIORAL;
      end for;
    end for;
  end for;
end CFG_RCA_STRUCTURAL;

configuration CFG_RCA_BEHAVIORAL of RCA is
  for BEHAVIORAL 
  end for;
end CFG_RCA_BEHAVIORAL;
