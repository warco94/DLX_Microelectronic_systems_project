library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity carry_select_block is 
	generic (--DRCAS_csb : 	Time := 0 ns;
	         --DRCAC_csb : 	Time := 0 ns;
             --DEL_MUX   :    Time := tp_mux;
             N         :    integer:=NumBit);
	Port (	A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(N-1 downto 0));
end carry_select_block;

architecture STRUCTURAL of carry_select_block is

  signal S0 : std_logic_vector(N-1 downto 0);
  signal Co : std_logic;
  signal S1 : std_logic_vector(N-1 downto 0);--added signal

  component RCA 
  generic (--DRCAS : 	Time := 0 ns;
           --DRCAC : 	Time := 0 ns;
           N :       integer:=NumBit);
  Port (A:	In	std_logic_vector(N-1 downto 0);
       	B:	In	std_logic_vector(N-1 downto 0);
        Ci:	In	std_logic;
	S:	Out	std_logic_vector(N-1 downto 0);
	Co:	Out	std_logic);
  end component; 

-----------------------------------------------------------------
  component MUX21_GENERIC
  generic(N :           integer:=NumBit);
          --DELAY_MUX:     Time:=tp_mux);
  Port(	A:	In	std_logic_vector(N-1 downto 0);
	B:	In	std_logic_vector(N-1 downto 0);
	SEL:	In	std_logic;
	Y:	Out	std_logic_vector(N-1 downto 0));
  end component;
-------------------------------------------------------------------

  begin

    RCA0 : RCA 
	  --generic map (DRCAS => DRCAS_csb, DRCAC => DRCAC_csb, N => N) 
	  generic map (N => N) 
	  Port Map (A, B, '1', S0, Co);

    RCA1 : RCA
      --generic map (DRCAS => DRCAS_csb, DRCAC => DRCAC_csb, N => N)
	 generic map (N => N)
      port map (A, B, '0', S1, Co);
    
    MUXSUM : MUX21_GENERIC
      generic map (N => N) --, DELAY_MUX => DEL_MUX)
      port map (S0, S1, Ci, S);  
  ---------------------------------------------------------------
end STRUCTURAL;

configuration CFG_carry_select_block_STRUCTURAL of carry_select_block is
  for STRUCTURAL 
      for RCA0 : RCA
        use configuration WORK.CFG_RCA_STRUCTURAL;
      end for;
	for RCA1 : RCA
        use configuration WORK.CFG_RCA_STRUCTURAL;
      end for;
      for MUXSUM : MUX21_GENERIC
        use configuration WORK.CFG_MUX21_BEHAVIORAL;
      end for;
    end for;
end CFG_carry_select_block_STRUCTURAL;
