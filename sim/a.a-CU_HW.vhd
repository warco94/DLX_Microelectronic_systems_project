library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.myTypes.all;

entity dlx_cu is
  generic (
    MICROCODE_MEM_SIZE :     integer := 63;  -- Microcode Memory Size
    FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
    -- ALU_OPC_SIZE       :     integer := 6;  -- ALU Op Code Word Size
    IR_SIZE            :     integer := 32;  -- Instruction Register Size    
    CW_SIZE            :     integer := 11);  -- Control Word Size
  port (
    Clk                : in  std_logic;  -- Clock
    Rst                : in  std_logic;  -- Reset:Active-Low
    -- Opcode and Function from instruction register
    OPCODE_IN          : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
    FUNC_IN            : in  std_logic_vector(FUNC_SIZE - 1 downto 0);
    
    -- EX Control Signals
    MUXA_SEL           : out std_logic;  -- MUX-A Sel
    MUXB_SEL           : out std_logic;  -- MUX-B Sel
    BR_EN              : out std_logic;  -- Enable jumps and branching
    -- ALU Operation Code
    ALU_OPCODE         : out aluOp; 
    
    -- MEM Control Signals
    DRAM_RW            : out std_logic;  -- Data RAM Write Enable
    DRAM_EN            : out std_logic;
    DRAM_SEL           : out std_logic_vector(2 downto 0);  -- Selector for different kind of load and store instructions

    -- WB Control signals
    WB_MUX_SEL         : out std_logic_vector(1 downto 0);  -- Write Back MUX Sel
    RF_WE              : out std_logic);  -- Register File Write Enable


end dlx_cu;

architecture dlx_cu_hw of dlx_cu is
  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  constant cw_mem : mem_array := ("00000000111", -- R type
                                "00000000000",
                                "11100000000", -- J (0X02) instruction encoding corresponds to the address to this ROM
                                "11100000101", -- JAL (0x03)
                                "11100000000", -- BEQZ (0x04)
                                "11100000000", -- BNEZ(0x05)
                                "00000000000", 
                                "00000000000",
                                "01000000111", -- ADD i (0X08)
                                "01000000111", -- ADDUI (0x09)
                                "01000000111", -- SUB i (0X0a)
                                "01000000111", -- SUBUI (0x0b)
                                "01000000111", -- AND i (0X0c)
                                "01000000111", -- OR i (0X0d)
                                "01000000111", -- XOR i (0X0e)
                                "00000000000", 
                                "00000000000", 
                                "00000000000", 
                                "01100000000", -- JR (0x12)
                                "01100000101", -- JALR (0x13)
                                "01000000111", -- SLL i (0x014)
                                "00000000000", -- NOP (0x15)
                                "01000000111", -- SRL i (0x16)
                                "01000000111", -- SRAI (0x17)
                                "01000000111", -- SEQI (0x18)
                                "01000000111", -- SNE i (0x19)
                                "01000000111", -- SLTI (0x1a)
                                "01000000111", -- SGTI (0x1b)
                                "01000000111", -- SLE i (0x1c)
                                "01000000111", -- SGE i (0x1d) 
                                "00000000000", 
                                "00000000000", 
                                "01001011011", -- LB (0x20)
                                "01001001011", -- LH (0x21)
                                "00000000000", 
                                "01001000011", -- LW (0x23)
                                "01001100011", -- LBU (0x24)
                                "01001010011", -- LHU (0x25)
                                "00000000000", 
                                "00000000000", 
                                "01011111010", -- SB (0x28)
                                "01011110010", -- SH (0x29)
                                "00000000000",  
                                "01011101010", -- SW (0x2b)
                                "00000000000",
                                "00000000000", 
                                "00000000000", 
                                "00000000000", 
                                "00000000000", 
                                "00000000000", 
                                "00000000000",
                                "00000000000",
                                "00000000000", 
                                "00000000000", 
                                "00000000000", 
                                "00000000000", 
                                "00000000000", 
                                "00000000000",
                                "01000000111", -- SLTUI (0x3a)
                                "01000000111", -- SGTUI (0x3b)
                                "01000000111", -- SLEUI (0x3c)
                                "01000000111", -- SGEUI (0x3d)
                                "00000000000");
                                
                                
  signal IR_opcode : std_logic_vector(OP_CODE_SIZE -1 downto 0);  -- OpCode part of IR
  signal IR_func : std_logic_vector(FUNC_SIZE-1 downto 0);   -- Func part of IR when Rtype
  signal cw   : std_logic_vector(CW_SIZE - 1 downto 0); -- full control word read from cw_mem


  -- control word is shifted to the correct stage
  signal cw1 : std_logic_vector(CW_SIZE -1 downto 0); -- first stage
  signal cw2 : std_logic_vector(CW_SIZE - 1 - 3 downto 0); -- third stage
  signal cw3 : std_logic_vector(CW_SIZE - 1 - 8 downto 0); -- fourth stage  

  signal aluOpcode_i: aluOp := NOP; -- ALUOP defined in package
  signal aluOpcode1: aluOp := NOP;


 
begin  -- dlx_cu_rtl

  IR_opcode(5 downto 0) <= OPCODE_IN;
  IR_func(10 downto 0)  <= FUNC_IN;
  cw <= cw_mem(conv_integer(IR_opcode));

  
  -- stage three control signals
  MUXA_SEL      <= cw1(CW_SIZE - 1);
  MUXB_SEL      <= cw1(CW_SIZE - 2);
  BR_EN       <= cw1(CW_SIZE - 3);
  
  -- stage four control signals
  DRAM_RW      <= cw2(CW_SIZE - 4);
  DRAM_EN      <= cw2(CW_SIZE - 5);
  DRAM_SEL     <= cw2(CW_SIZE - 6 downto CW_SIZE - 8);
  
  -- stage five control signals
  WB_MUX_SEL <= cw3(CW_SIZE - 9 downto CW_SIZE - 10);
  RF_WE      <= cw3(CW_SIZE - 11);


  -- process to pipeline control words
  CW_PIPE: process (Clk, Rst)
  begin  -- process Clk
    if Rst = '0' then                   -- asynchronous reset (active low)
      cw1 <= (others => '0');
      cw2 <= (others => '0');
      cw3 <= (others => '0');
      aluOpcode1 <= NOP;
    elsif Clk'event and Clk = '1' then  -- rising clock edge
      cw1 <= cw;
      cw2 <= cw1(CW_SIZE - 1 - 3 downto 0);
      cw3 <= cw2(CW_SIZE - 1 - 8 downto 0);

      aluOpcode1 <= aluOpcode_i;
    end if;
  end process CW_PIPE;

  ALU_OPCODE <= aluOpcode1;

  -- purpose: Generation of ALU OpCode
  -- type   : combinational
  -- inputs : IR_i
  -- outputs: aluOpcode
   ALU_OP_CODE_P : process (IR_opcode, IR_func)
   begin  -- process ALU_OP_CODE_P
	case conv_integer(unsigned(IR_opcode)) is
	        -- case of R type requires analysis of FUNC
		when 0 =>
			case conv_integer(unsigned(IR_func)) is
				when 4 => aluOpcode_i <= LLS; -- sll according to instruction set coding
                when 6 => aluOpcode_i <= LRS; -- srl
                when 7 => aluOpcode_i <= RAS; -- sra
                when 32 => aluOpcode_i <= ADDS; -- add
                when 33 => aluOpcode_i <= ADDS; -- addu
                when 34 => aluOpcode_i <= SUBS; -- sub
                when 35 => aluOpcode_i <= SUBS; -- subu
                when 36 => aluOpcode_i <= ANDS; -- and
                when 37 => aluOpcode_i <= ORS; -- or
                when 38 => aluOpcode_i <= XORS; -- xor
                when 40 => aluOpcode_i <= SEQ; -- seq
                when 41 => aluOpcode_i <= SNE; -- sne
                when 42 => aluOpcode_i <= SLT; -- slt
                when 43 => aluOpcode_i <= SGT; -- sgt
                when 44 => aluOpcode_i <= SLE; -- sle
				when 45 => aluOpcode_i <= SGE; -- sge
				when 58 => aluOpcode_i <= SLTU; -- sltu
                when 59 => aluOpcode_i <= SGTU; -- sgtu
                when 60 => aluOpcode_i <= SLEU; -- sleu
                when 61 => aluOpcode_i <= SGEU; -- sgeu
				when others => aluOpcode_i <= NOP;
			end case;
        when 2 => aluOpcode_i <= J; -- j
        when 3 => aluOpcode_i <= JAL; -- jal
        when 4 => aluOpcode_i <= BEQZ; -- beqz
        when 5 => aluOpcode_i <= BNEZ; -- bnez
        when 8 => aluOpcode_i <= ADDS; -- addi
        when 9 => aluOpcode_i <= ADDS; -- addui
        when 10 => aluOpcode_i <= SUBS; -- subi
        when 11 => aluOpcode_i <= SUBS; -- subui
        when 12 => aluOpcode_i <= ANDS; -- andi
        when 13 => aluOpcode_i <= ORS; -- ori
        when 14 => aluOpcode_i <= XORS; -- xori
        when 18 => aluOpcode_i <= JR; -- jr
        when 19 => aluOpcode_i <= JALR; -- jalr
        when 20 => aluOpcode_i <= LLS; -- slli
        when 21 => aluOpcode_i <= NOP; -- nop
        when 22 => aluOpcode_i <= LRS; -- srli
        when 23 => aluOpcode_i <= RAS; -- sari
        when 24 => aluOpcode_i <= SEQ; -- seqi
        when 25 => aluOpcode_i <= SNE; -- snei
        when 26 => aluOpcode_i <= SLT; -- slti
        when 27 => aluOpcode_i <= SGT; -- sgti
        when 28 => aluOpcode_i <= SLE; -- slei
        when 29 => aluOpcode_i <= SGE; -- sgei
        when 32 => aluOpcode_i <= ADDS; -- lb
        when 33 => aluOpcode_i <= ADDS; -- lh
        when 35 => aluOpcode_i <= ADDS; -- lw
        when 36 => aluOpcode_i <= ADDS; -- lbu
        when 37 => aluOpcode_i <= ADDS; -- lhu
        when 40 => aluOpcode_i <= ADDS; -- sb
        when 41 => aluOpcode_i <= ADDS; -- sh
        when 43 => aluOpcode_i <= ADDS; -- sw
        when 58 => aluOpcode_i <= SLTU; -- sltui
        when 59 => aluOpcode_i <= SGTU; -- sgtui
        when 60 => aluOpcode_i <= SLEU; -- sleui
        when 61 => aluOpcode_i <= SGEU; -- sgeui
    when others => aluOpcode_i <= NOP;
	 end case;
	end process ALU_OP_CODE_P;


end dlx_cu_hw;
