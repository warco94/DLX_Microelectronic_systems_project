library ieee;
use ieee.std_logic_1164.all;

package myTypes is

	type aluOp is (
		NOP, ADDS, SUBS, ANDS, ORS, XORS, LLS, LRS, SNE, SGE, SLE, J, JAL, BEQZ, BNEZ, --- basic
		RAS, JR, JALR, SLT, SGT, SEQ, SLTU, SLEU, SGTU, SGEU	
		);

end myTypes;

