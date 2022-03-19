library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;
use ieee.math_real.all;

entity CARRY_GENERATOR_PARAMETRIC is
		generic (
			NBIT :		integer := NumBit;
			NBIT_PER_BLOCK: integer := BitBlock);
		port (
			A :		in	std_logic_vector(NBIT-1 downto 0);
			B :		in	std_logic_vector(NBIT-1 downto 0);
			Cin :	in	std_logic;
			Co :	out	std_logic_vector((NBIT/NBIT_PER_BLOCK)-1 downto 0));
end CARRY_GENERATOR_PARAMETRIC;

architecture STRUCTURAL of CARRY_GENERATOR_PARAMETRIC is

component G is
	Port ( 	PA: IN std_logic;
	      	GA: IN std_logic;
       		GB: IN std_logic;
                G: OUT std_logic);
end component;

component PG is
	Port ( 	PA: IN std_logic;
			PB: IN std_logic;
			GA: IN std_logic;
			GB: IN std_logic;
			P: OUT std_logic;
			G: OUT std_logic);
end component;

component and_gate is
		port (
			A :		in	std_logic;
			B :		in	std_logic;
			O :	out	std_logic);
end component;

component xor_gate is
		port (
			A :		in	std_logic;
			B :		in	std_logic;
			O :	out	std_logic);
end component;

component BUFF is
	Port ( 	IG: IN std_logic;
			IP: IN std_logic;
			OG: OUT std_logic;
			OP: OUT std_logic);
end component;

type SignalVector is array (integer(ceil(log2(real(NBIT)))) downto 0) of std_logic_vector(NBIT-1 downto 0);

signal matrixG : SignalVector ; 
signal matrixP : SignalVector ; 
signal finalGvector: std_logic_vector((NBIT/NBIT_PER_BLOCK)-1 downto 0);     
signal finalindex: integer:=1;
signal Gsubtractor, Psubtractor: std_logic;


begin


Gsub: G
	port map (PA => Psubtractor, GA => Gsubtractor, GB => Cin, G => matrixG(0)(0)); --first G in line 0

looplines:	for riga in 0 to integer(ceil(log2(real(NBIT)))) generate

--LINE 0- BASIC PROPAGATE AND GENERATE ON INPUTS ---------------------- 
	riga0: 	if riga=0 generate
	
		line0: for i in 0 to NBIT-1 generate
 subsupport:if i=0 generate
			Xor_gsi: xor_gate
			port map (A(i),B(i),Psubtractor); -- propagate for the computation of G on line 0
			and_gsi: and_gate
			port map (A(i),B(i),Gsubtractor); -- generate for the computation of G on line 0
			end generate subsupport;
rest_line0: if i>0 generate			
			Xor_gsi: xor_gate
			port map (A(i),B(i),matrixP(0)(i)); --line 0 propagates
			and_gsi: and_gate
			port map (A(i),B(i),matrixG(0)(i)); --line 0 generates
			end generate rest_line0;
		end generate line0;	


	end generate riga0;

   
    
--FIRST LINES, HERE WE JUST HALVE THE NUMBER OF BLOCKS AT EACH STEP-----------------------------------------    
	riga2: if riga>0 and riga<integer(ceil(log2(real(NBIT_PER_BLOCK))))+1 generate

		for2: for d in 0 to NBIT-1 generate

			m4if: if ( ((d+1) rem 2**riga) = 0) generate

				ifG:if ((d+1) = 2**riga) generate --G generate
					Gs_d: G				
					port map (PA => matrixP(riga-1)(d), GA => matrixG(riga-1)(d), GB => matrixG(riga-1)(2**(riga-1)-1), G => matrixG(riga)(d)); 
			firstc:	if riga=integer(ceil(log2(real(NBIT_PER_BLOCK)))) generate --first generate to go into carry vector
						finalGvector(0)<=matrixG(riga)(d);
					end generate firstc;
				end generate ifG;
	
				ifPG:if(d > 2**riga) generate
					PGsi: PG
					port map (PA => matrixP(riga-1)(d), PB => matrixP(riga-1)(d-2**(riga-1)), GA => matrixG(riga-1)(d), GB => matrixG(riga-1)(d-2**(riga-1)), P => matrixP(riga)(d), G => matrixG(riga)(d)); 
				end generate ifPG;
	
			end generate m4if;

		end generate for2;
	end generate riga2;
	     

--MIDDLE STAGE, HERE WE STILL HALVE THE NUMBER OF BLOCKS BUT NOW NEED TO INSTANTIATE BUFFERS AS WELL
	rigap: if riga = integer(ceil(log2(real(NBIT_PER_BLOCK))))+1 generate
		
				GenP:for h in 0 to NBIT generate

					m4ifP: if ((h+1) rem NBIT_PER_BLOCK = 0) generate -- create a block every NBIT_PER_BLOCK, not interested in ones inbetween

							ifGsP: if ((h+1)=2**riga) generate -- first block of the line is a G
	   							Gs_h: G				
								port map (PA => matrixP(riga-1)(h), GA => matrixG(riga-1)(h), GB => matrixG(riga-1)(2**(riga-1)-1), G => matrixG(riga)(h)); 
									finalGvector( ((h+1)/NBIT_PER_BLOCK)-1 )<=matrixG(riga)(h);							
							end generate ifGsP;
						
							ifPGsP: if (h>(2**riga)) and ((h+1) rem (2**riga)=0) generate
								PGsi: PG
								port map (PA => matrixP(riga-1)(h), PB => matrixP(riga)(h-2**(riga-1)), GA => matrixG(riga-1)(h), GB => matrixG(riga-1)(h-2**(riga-1)), P => matrixP(riga)(h), G => matrixG(riga)(h)); 
							end generate ifPGsP;
						
							BufferIfP: if (h>(2**riga)) and ((h+1) rem (2**riga)/=0) generate --alternate buffer and PG blocks
								Buf_h: BUFF
								port map(matrixG(riga-1)(h), matrixP(riga-1)(h), matrixG(riga)(h), matrixP(riga)(h));
							end generate BufferIfP;


				end generate m4ifP;

			end generate GenP;			
	end generate rigap;

		
--LAST LINES, HERE WE CREATE THE LAST LINES, DOUBLING THE NUMBER OF G AT EACH ROW-----------------------------------------   	
    riga3:	if riga>integer(ceil(log2(real(NBIT_PER_BLOCK))))+1 generate  

				Gen:for h in 0 to NBIT generate 

					m4if: if ((h+1) rem NBIT_PER_BLOCK = 0) generate

							ifGs: if (h<(2**riga)) and (h>(2**(riga-1))) generate -- first blocks always G
	   							Gs_h: G				
								port map (PA => matrixP(riga-1)(h), GA => matrixG(riga-1)(h), GB => matrixG(riga-1)(2**(riga-1)-1), G => matrixG(riga)(h)); 
									finalGvector( ((h+1)/NBIT_PER_BLOCK)-1 )<=matrixG(riga)(h);							
							end generate ifGs;
						
						loopPGb:for i in 0 to NBIT generate --here we create alternate series of PG and buffer blocks in the right order
							alt: if(i rem 2 = 0) generate --this is to use i in increments of 2
							ifPGs: if (h>(2**riga)+(i+1)*2**(riga-1)) and (h<(2**riga)+(i+2)*2**(riga-1)) generate
								PGsi: PG
								port map (PA => matrixP(riga-1)(h), PB => matrixP(riga-1)(2**riga+(i+1)*2**(riga-1)-1), GA => matrixG(riga-1)(h), GB => matrixG(riga-1)(2**riga+(i+1)*2**(riga-1)-1), P => matrixP(riga)(h), G => matrixG(riga)(h)); 
							end generate ifPGs;
						
							BufferIf: if (h>(2**riga)+(i)*2**(riga-1)) and (h<(2**riga)+(i+1)*2**(riga-1)) generate
								Buf_h: BUFF
								port map(matrixG(riga-1)(h), matrixP(riga-1)(h), matrixG(riga)(h), matrixP(riga)(h));
							end generate BufferIf;
							
							end generate alt;
						end generate loopPGb;

				end generate m4if;

			end generate Gen;			

	end generate riga3;

end generate looplines;

Co <= finalGvector;

end STRUCTURAL;


configuration CFG_CARRY_GENERATOR_PARAMETRIC_STRUCTURAL of CARRY_GENERATOR_PARAMETRIC is
  for STRUCTURAL
     
	end for;
end CFG_CARRY_GENERATOR_PARAMETRIC_STRUCTURAL;
