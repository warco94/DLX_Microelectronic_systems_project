library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use WORK.myTypes.all;


-- simple behavioural shifter, does operations depending on ALUcode
entity SHIFTER_GENERIC is
	generic(N: integer := 32);
	port(	A: in std_logic_vector(N-1 downto 0);
		B: in std_logic_vector(N-1 downto 0);
		sel: IN aluOp;
		OUTPUT: out std_logic_vector(N-1 downto 0)
	);

end entity SHIFTER_GENERIC;


architecture BEHAVIORAL of SHIFTER_GENERIC is

begin
	process (A, B, sel) is
	begin
	case sel is
	   when LRS => OUTPUT <= to_StdLogicVector((to_bitvector(A)) srl (conv_integer(B(4 downto 0))));				
	   when LLS => OUTPUT <= to_StdLogicVector((to_bitvector(A)) sll (conv_integer(B(4 downto 0))));
	   when RAS => OUTPUT <= to_StdLogicVector((to_bitvector(A)) sra (conv_integer(B(4 downto 0))));
	   when others => OUTPUT <= A;
	end case;	
	end process;
end architecture BEHAVIORAL;



