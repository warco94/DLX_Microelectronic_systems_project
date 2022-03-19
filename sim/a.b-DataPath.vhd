library IEEE;
use IEEE.std_logic_1164.all;
use WORK.myTypes.all;

entity DPATH is
   port(Clk                : in  std_logic;  -- Clock
        Rst                : in  std_logic;  -- Reset:Active-Low
       
        -- EX Control Signals
        MUXA_SEL           : IN std_logic;  -- MUX-A Sel
        MUXB_SEL           : IN std_logic;  -- MUX-B Sel
        BR_EN              : IN std_logic;  -- Enable jumps and branching
        -- ALU Operation Code
        ALU_OPCODE         : IN aluOp;
        -- WB Control signals
        WB_MUX_SEL         : IN std_logic_vector(1 downto 0);  -- Write Back MUX Sel
        RF_WE              : IN std_logic;
        DRAM_OUT           : IN std_logic_vector(31 downto 0);
        IRAM_OUT           : IN std_logic_vector(31 downto 0);
        IR1                : OUT std_logic_vector(31 downto 0);
        DRAM_IN            : OUT std_logic_vector(31 downto 0);
        DRAM_ADD           : OUT std_logic_vector(11 downto 0);
        IR_ADD             : OUT std_logic_vector(7 downto 0)); 
end DPATH;


architecture STRUCTURAL of DPATH is

component MUX21_GENERIC is
  generic(N: integer:=32);
	Port (	A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(N-1 downto 0));
end component;

component mux_3to1 is
  generic(N: integer := 32);
	Port (	A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		C:	In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic_vector(1 downto 0);
		Y:	Out	std_logic_vector(N-1 downto 0));
end component;

component register_e is
generic(N: integer := 32);
port (D: IN std_logic_vector(N-1 downto 0);
      clk, rst: IN std_logic;
      O: OUT std_logic_vector(N-1 downto 0));
end component;

component register_file is
generic( N :		integer := 32; --data bit
		 addBit :	integer := 5);  --address bit 
 port (RESET,RE,WE: 	IN std_logic;
	 ADD_WR: 	IN std_logic_vector(addBit-1 downto 0);
	 ADD_RDA: 	IN std_logic_vector(addBit-1 downto 0);
	 ADD_RDB: 	IN std_logic_vector(addBit-1 downto 0);
	 DATAIN: 	IN std_logic_vector(N-1 downto 0);
     OUTA: 		OUT std_logic_vector(N-1 downto 0);
	 OUTB: 		OUT std_logic_vector(N-1 downto 0));
end component;

component sign_extender is
port(d_in: IN std_logic_vector(31 downto 0);
     rst: IN std_logic;
     d_ext: OUT std_logic_vector(31 downto 0));
end component;

component branch_cond is
generic(N: integer := 32);
port(A: IN std_logic_vector(N-1 downto 0);
     EN: IN std_logic;
     OP: IN aluOp;
     PRE: IN std_logic;
     DISCARD: OUT std_logic;
     WRONG: OUT std_logic;
     RIGHT: OUT std_logic;
     SEL: OUT std_logic);
end component;

component NPC_adder is
port (inPC: IN std_logic_vector(31 downto 0);
      outPC: OUT std_logic_vector(31 downto 0));
end component;

component ALU is
generic(N: integer := 32);
port(INA,INB: IN std_logic_vector(N-1 downto 0);
     OP: IN aluOp;
     alu_out: OUT std_logic_vector(N-1 downto 0));
end component;

component IR_decoder is
port(rst: IN std_logic;
     IR_OUT :IN std_logic_vector(20 downto 0);
     ADDS1  :OUT std_logic_vector(4 downto 0);
     ADDS2  :OUT std_logic_vector(4 downto 0);
     ADDD   :OUT std_logic_vector(4 downto 0));
end component;

component FWD_UNIT is
port(Rst        :IN std_logic;
     Rs1        :IN std_logic_vector(4 downto 0);
     Rs2        :IN std_logic_vector(4 downto 0);
     Rd_M       :IN std_logic_vector(4 downto 0);
     Rd_W       :IN std_logic_vector(4 downto 0);
     ICODE      :IN std_logic_vector(5 downto 0);
     ICODE_M    :IN std_logic_vector(5 downto 0);
     ICODE_W    :IN std_logic_vector(5 downto 0);
     SEL_A      :OUT std_logic_vector(1 downto 0);
     SEL_B      :OUT std_logic_vector(1 downto 0));
end component;

component FWD_UNIT_BRANCH is
port(Rst        :IN std_logic;
     Rs1        :IN std_logic_vector(4 downto 0);
     Rd_M       :IN std_logic_vector(4 downto 0);
     Rd_W       :IN std_logic_vector(4 downto 0);
     ICODE      :IN std_logic_vector(5 downto 0);
     ICODE_M    :IN std_logic_vector(5 downto 0);
     ICODE_W    :IN std_logic_vector(5 downto 0);
     SEL      :OUT std_logic_vector(1 downto 0));
end component;


component branch_predictor is
port(RST          :IN std_logic;
     PC_IN        :IN std_logic_vector(31 downto 0);
     PC_FAIL      :IN std_logic_vector(31 downto 0);
     IR_IN        :IN std_logic_vector(31 downto 0);
     IR_FAIL      :IN std_logic_vector(15 downto 0);
     WRONG_PRE    :IN std_logic;
     RIGHT_PRE    :IN std_logic;
     NPC_OUT      :OUT std_logic_vector(31 downto 0);
     LINK_ADD     :OUT std_logic_vector(31 downto 0);
     SEL          :OUT std_logic;
     TAKEN        :OUT std_logic);
end component;


component IF_ID is
port(CLK,RST,DISCARD:IN std_logic; 
     NPC_IN         :IN std_logic_vector(31 downto 0);
     NPC_L_IN       :IN std_logic_vector(31 downto 0); -- unaltered NPC in case of jal or jalr
     IR_IN          :IN std_logic_vector(31 downto 0);
     PR_IN          :IN std_logic;
     NPC_OUT        :OUT std_logic_vector(31 downto 0);
     NPC_L_OUT      :OUT std_logic_vector(31 downto 0);
     IR_OUT         :OUT std_logic_vector(31 downto 0);
     PR_OUT         :OUT std_logic);        
     
end component;

component ID_EX is
port(CLK,RST:IN std_logic; 
     NPC_IN         :IN std_logic_vector(31 downto 0);
     NPC_L_IN       :IN std_logic_vector(31 downto 0);
     A_IN           :IN std_logic_vector(31 downto 0);
     B_IN           :IN std_logic_vector(31 downto 0);
     IMM_IN         :IN std_logic_vector(31 downto 0);
     RS1_IN         :IN std_logic_vector(4 downto 0);
     RS2_IN         :IN std_logic_vector(4 downto 0);
     RD_IN          :IN std_logic_vector(4 downto 0);
     OPCODE_IN      :IN std_logic_vector(5 downto 0);
     IR_IN          :IN std_logic_vector(15 downto 0);
     PR_IN          :IN std_logic;
     NPC_OUT        :OUT std_logic_vector(31 downto 0);
     NPC_L_OUT        :OUT std_logic_vector(31 downto 0);
     A_OUT          :OUT std_logic_vector(31 downto 0);
     B_OUT          :OUT std_logic_vector(31 downto 0);
     IMM_OUT        :OUT std_logic_vector(31 downto 0);
     RS1_OUT        :OUT std_logic_vector(4 downto 0);
     RS2_OUT        :OUT std_logic_vector(4 downto 0);
     RD_OUT         :OUT std_logic_vector(4 downto 0);
     OPCODE_OUT     :OUT std_logic_vector(5 downto 0);
     IR_OUT         :OUT std_logic_vector(15 downto 0);
     PR_OUT         :OUT std_logic);
end component;

component EX_MEM is
port(CLK,RST:IN std_logic; 
     NPC_IN         :IN std_logic_vector(31 downto 0);
     NPC_L_IN       :IN std_logic_vector(31 downto 0);
     ALU_IN         :IN std_logic_vector(31 downto 0);
     B_IN           :IN std_logic_vector(31 downto 0);
     RD_IN          :IN std_logic_vector(4 downto 0);
     OPCODE_IN      :IN std_logic_vector(5 downto 0);
     NPC_OUT        :OUT std_logic_vector(31 downto 0);
     NPC_L_OUT      :OUT std_logic_vector(31 downto 0);
     ALU_OUT        :OUT std_logic_vector(31 downto 0);
     B_OUT          :OUT std_logic_vector(31 downto 0);
     RD_OUT         :OUT std_logic_vector(4 downto 0);
     OPCODE_OUT     :OUT std_logic_vector(5 downto 0));
end component;

component MEM_WB is
port(CLK,RST:IN std_logic; 
     NPC_L_IN         :IN std_logic_vector(31 downto 0);
     ALU_IN           :IN std_logic_vector(31 downto 0);
     LMD_IN           :IN std_logic_vector(31 downto 0);
     RD_IN          :IN std_logic_vector(4 downto 0);
     OPCODE_IN      :IN std_logic_vector(5 downto 0);
     NPC_L_OUT        :OUT std_logic_vector(31 downto 0);
     ALU_OUT          :OUT std_logic_vector(31 downto 0);
     LMD_OUT          :OUT std_logic_vector(31 downto 0);
     RD_OUT         :OUT std_logic_vector(4 downto 0);
     OPCODE_OUT      :OUT std_logic_vector(5 downto 0));
end component;

------------------------------------------ SIGNALS ------------------------------------------ 

--IF stage signals
signal pc_out       :std_logic_vector(31 downto 0);
signal pc_in        :std_logic_vector(31 downto 0);
signal ireg_out     :std_logic_vector(31 downto 0);
signal npc          :std_logic_vector(31 downto 0);
signal link_addr_F  :std_logic_vector(31 downto 0);
signal npc_pre      :std_logic_vector(31 downto 0);
signal npc_mux_out  :std_logic_vector(31 downto 0);
signal npc_mux_sel  :std_logic;
signal prediction   :std_logic;
signal wrong_br     :std_logic;
signal right_br     :std_logic;

--ID stage signals
signal dest_D       :std_logic_vector(4 downto 0);
signal npc_D        :std_logic_vector(31 downto 0);
signal link_addr_D  :std_logic_vector(31 downto 0);
signal a_out        :std_logic_vector(31 downto 0);
signal b_out        :std_logic_vector(31 downto 0);
signal imm_out      :std_logic_vector(31 downto 0);
signal add_S1       :std_logic_vector(4 downto 0);
signal add_S2       :std_logic_vector(4 downto 0);
signal add_D        :std_logic_vector(4 downto 0);
signal pr_D         :std_logic;

--EX stage signals
signal A_s          :std_logic_vector(31 downto 0);
signal B_s          :std_logic_vector(31 downto 0);
signal IMM_s        :std_logic_vector(31 downto 0);
signal jr_sel       :std_logic;
signal Rs1          :std_logic_vector(4 downto 0);
signal Rs2          :std_logic_vector(4 downto 0);
signal dest_E       :std_logic_vector(4 downto 0);
signal npc_E        :std_logic_vector(31 downto 0);
signal link_addr_E  :std_logic_vector(31 downto 0);
signal ir_E         :std_logic_vector(15 downto 0);
signal mux_a_in     :std_logic_vector(31 downto 0);
signal mux_b_in     :std_logic_vector(31 downto 0);
signal alu_a_in     :std_logic_vector(31 downto 0);
signal alu_b_in     :std_logic_vector(31 downto 0);
signal alu_out      :std_logic_vector(31 downto 0);
signal opcode_E     :std_logic_vector(5 downto 0);
signal FWD_MUX_A_S  :std_logic_vector(1 downto 0);
signal FWD_MUX_B_S  :std_logic_vector(1 downto 0);
signal FWD_MUX_BR_S :std_logic_vector(1 downto 0);
signal br_mux_out   :std_logic_vector(31 downto 0);
signal pr_E         :std_logic;
signal discard_s    :std_logic;

--MEM stage signals
signal B_data       :std_logic_vector(31 downto 0);
signal alu_out_M    :std_logic_vector(31 downto 0);
signal dest_M       :std_logic_vector(4 downto 0);
signal npc_M        :std_logic_vector(31 downto 0);
signal link_addr_M  :std_logic_vector(31 downto 0);
signal opcode_M     :std_logic_vector(5 downto 0);

--WB stage signals
signal alu_out_W    :std_logic_vector(31 downto 0);
signal link_addr_W  :std_logic_vector(31 downto 0);
signal LMD_out      :std_logic_vector(31 downto 0);
signal WB           :std_logic_vector(31 downto 0);
signal opcode_W     :std_logic_vector(5 downto 0);



begin

-- IF stage

NPC_mux: MUX21_GENERIC port map(A=>alu_out, -- output or ALU from EXE stage in case of jr or jalr
                                B=>npc,     -- value coming from NPC adder
                                SEL=>jr_sel, 
                                Y=>pc_in);
                                
PC_reg: register_e port map(D=>pc_in, -- value coming from the NPC_mux output
                            clk=>Clk, 
                            rst=>Rst, 
                            O=>pc_out);   
                                                     
BR_pred: branch_predictor port map(RST => Rst, 
                                   PC_IN => pc_out,         -- value of current PC
                                   WRONG_PRE => wrong_br,   -- signal raised if previous prediction was wrong, coming after branch evaluation in EXE stage
                                   RIGHT_PRE => right_br,   -- signal raised if previous prediction was right, coming after branch evaluation in EXE stage
                                   PC_FAIL => npc_M,        -- PC of instruction currently in EXE stage
                                   IR_IN => IRAM_OUT,       -- IR of current instruction
                                   IR_FAIL => ir_E,         -- immediate address value from IR of instruction currently in EXE stage
                                   NPC_OUT => npc_pre,      -- PC of predicted next instruction
                                   LINK_ADD => link_addr_F, -- address to save in case of jal instruction
                                   TAKEN => prediction,     -- prediction on taken or not taken
                                   SEL => npc_mux_sel);     -- selection signal for mux at input of NPC adder
                                   
NPC_add_mux: MUX21_GENERIC port map(A=>npc_pre, 
                                    B=>pc_out, 
                                    SEL=>npc_mux_sel, 
                                    Y=>npc_mux_out); 
                                    
NPC_add: NPC_adder port map(inPC=>npc_mux_out,      -- value coming from mux at input
                            outPC=>npc);
                            
IR_ADD <= pc_out(9 downto 2);       -- address sent to IRAM, address goes up by 4 for each cycle so the 2 LSBs are cut out

----------------------------------------------------------------------------------------------------------------------------------------------------------------

IF_IDs: IF_ID port map(CLK => Clk,
                       RST => rst,
                       DISCARD => discard_s,    -- raised from EXE stage if need to flush pipeline
                       NPC_IN =>npc,            -- coming from NPC adder
                       NPC_L_IN => link_addr_F,
                       IR_IN => IRAM_OUT,       -- coming from IRAM output
                       PR_IN => prediction,     -- prediction made by BPU
                       NPC_OUT => npc_D,
                       NPC_L_OUT => link_addr_D,
                       IR_OUT => ireg_out,      -- going to CU
                       PR_OUT => pr_D);      
 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
 
-- ID stage                  
IR1 <= ireg_out;    -- instruction code for CU

dec: IR_decoder port map(rst=>rst, 
                         IR_OUT=>ireg_out(31 downto 11),  -- instruction code to be decoded
                         ADDS1=>add_S1,                   -- address of RS1, going to register file
                         ADDS2=>add_S2,                   -- address of RS2, going to register file
                         ADDD=>dest_D);                   -- address of RD, going to next stage
                         
Reg_F: register_file port map(RESET=>Rst, 
                              WE=>RF_WE,        -- write enable coming from CU
                              RE=>'1',          -- read enable always active
                              ADD_WR=>add_D,    -- address for writing, coming from WB stage
                              ADD_RDA=>add_S1, 
                              ADD_RDB=>add_S2, 
                              DATAIN=>WB,       -- data to write, coming from mux in WB stage
                              OUTA=>a_out, 
                              OUTB=>b_out);
                              
sign_ext: sign_extender port map(d_in=>ireg_out,    -- instruction to decode
                                 rst=>Rst, 
                                 d_ext=>imm_out);   -- 32-bit extended immediate

----------------------------------------------------------------------------------------------------------------------------------------------------------------
            
ID_EXs: ID_EX port map(CLK => clk,
                       RST => rst,
                       NPC_IN => npc_D,
                       NPC_L_IN => link_addr_D,
                       A_IN => a_out,                           -- RS1 from register file
                       B_IN => b_out,                           -- RS2 from register file
                       IMM_IN => imm_out,                       -- immediate value from sign extender 
                       RS1_IN => add_S1,                        -- address of RS1
                       Rs2_IN => add_S2,                        -- address of RS1
                       RD_IN => dest_D,                         -- address of RD (destination register)
                       OPCODE_IN => ireg_out(31 downto 26),     -- OPCODE of decoded instruction
                       PR_IN => pr_D,
                       IR_IN => ireg_out(15 downto 0),
                       NPC_OUT => npc_E,
                       NPC_L_OUT => link_addr_E,
                       A_OUT => A_s,    
                       B_OUT => B_s,      
                       IMM_OUT => IMM_s,
                       RS1_OUT => Rs1,
                       RS2_OUT => Rs2,   
                       RD_OUT => dest_E,
                       OPCODE_OUT => opcode_E,
                       PR_OUT => pr_E,
                       IR_OUT => ir_E); 
            
----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- EXE stage

-- mux controlled by CU to let NPC or value from register file pass
A_mux: MUX21_GENERIC port map(A=>npc_E,         
                              B=>A_s, 
                              SEL=>MUXA_SEL, 
                              Y=>mux_a_in);

-- mux controlled by CU to let immediate or value from register file pass                              
B_mux: MUX21_GENERIC port map(A=>IMM_s, 
                              B=>B_s, 
                              SEL=>MUXB_SEL, 
                              Y=>mux_b_in);
                              
FORWARDING: FWD_UNIT port map(Rst => Rst, 
                              Rs1 => Rs1,               -- address of RS1
                              Rs2 => Rs2,               -- address of RS2
                              Rd_M => dest_M,           -- address of RD coming from MEM stage (previous instruction)
                              Rd_W => add_D,            -- address of RD coming from WB stage (instruction from 2 cycles ago)
                              ICODE => opcode_E,        -- OPCODE of current instruction
                              ICODE_M => opcode_M,      -- OPCODE coming from MEM stage (previous instruction)
                              ICODE_W => opcode_W,      -- OPCODE coming from WB stage (instruction from 2 cycles ago)
                              SEL_A => FWD_MUX_A_S,     
                              SEL_B => FWD_MUX_B_S );
 
-- mux used for forwarding of RS1                             
FWD_MUX_A: mux_3to1 port map(A=>mux_a_in,           -- coming from A_MUX
                             B=>alu_out_M,          -- alu result from previous instruction, coming from MEM stage
                             C=> alu_out_W,         -- alu result from instruction 2 cycles ago, coming from WB stage
                             SEL=>FWD_MUX_A_S,      -- selection signal coming from forwarding unit
                             Y=>alu_a_in);

-- mux used for forwarding of RS2                          
FWD_MUX_B: mux_3to1 port map(A=>mux_b_in,           -- coming from B_MUX
                             B=>alu_out_M,          -- alu result from previous instruction, coming from MEM stage
                             C=> alu_out_W,         -- alu result from instruction 2 cycles ago, coming from WB stage
                             SEL=>FWD_MUX_B_S,      -- selection signal coming from forwarding unit
                             Y=>alu_b_in);
                             
ALU_C: ALU port map(INA=>alu_a_in,      -- first operand, coming from FWD_MUX_A
                    INB=>alu_b_in,      -- second operand, coming from FWD_MUX_B
                    OP=>ALU_OPCODE,     -- ALUCODE coming from CU
                    alu_out=>alu_out);  -- result
                    
FORWARDING_BR: FWD_UNIT_BRANCH port map(Rst => Rst, 
                                        Rs1 => Rs1,             -- address of RS1
                                        Rd_M => dest_M,         -- address of RD coming from MEM stage (previous instruction)
                                        Rd_W => add_D,          -- address of RD coming from WB stage (instruction from 2 cycles ago)
                                        ICODE => opcode_E,      -- OPCODE of current instruction
                                        ICODE_M => opcode_M,    -- OPCODE coming from MEM stage (previous instruction)
                                        ICODE_W => opcode_W,    -- OPCODE coming from WB stage (instruction from 2 cycles ago)
                                        SEL => FWD_MUX_BR_S);
                                        
FWD_MUX_BRANCH:  mux_3to1 port map(A=>A_s,                  -- value coming from RS1
                                   B=>alu_out_M,            -- alu result from previous instruction, coming from MEM stage
                                   C=> alu_out_W,           -- alu result from instruction 2 cycles ago, coming from WB stage
                                   SEL=>FWD_MUX_BR_S,       -- selection signal coming from branch forwarding unit
                                   Y=>br_mux_out);

-- evaluates branches                                   
branch: branch_cond port map(A=>br_mux_out,         -- coming from FWD_MUX_BRANCH
                             PRE => pr_E,           -- predicted action (if 1 branch was predicted taken, if 0 was predicted not taken)
                             WRONG => wrong_br,     -- raised if prediction was wrong
                             RIGHT => right_br,     -- raised if prediction was wrong
                             EN=>BR_EN,             -- enable coming from CU
                             DISCARD => discard_s,  -- raised to flush pipeline inserting 2 NOP instructions
                             OP=>ALU_OPCODE,        -- ALUCODE from CU
                             SEL=>jr_sel);          -- raised in case of jr or jalr instructions, controls mux at input of PC register

----------------------------------------------------------------------------------------------------------------------------------------------------------------
            
EX_MEM_s: EX_MEM port map(CLK => clk,
                   RST => rst,
                   NPC_IN => npc_E,
                   NPC_L_IN => link_addr_E,
                   ALU_IN => alu_out,      -- result from ALU  
                   B_IN => B_s,            -- value from RS2, used to write to DRAM         
                   RD_IN => dest_E,  
                   OPCODE_IN => opcode_E,    
                   NPC_OUT =>npc_M,    
                   NPC_L_OUT => link_addr_M,  
                   ALU_OUT => alu_out_M,       
                   B_OUT => B_data,        -- value going to write input of DRAM
                   RD_OUT => dest_M,
                   OPCODE_OUT => opcode_M);     

----------------------------------------------------------------------------------------------------------------------------------------------------------------
            
-- MEM stage
DRAM_ADD <= alu_out_M(11 downto 0);  -- address of selected word in DRAM
DRAM_IN <= B_data;                  -- data to be written in DRAM

----------------------------------------------------------------------------------------------------------------------------------------------------------------
            
MEM_WB_s: MEM_WB port map(CLK => clk,
                          RST => rst,     
                          NPC_L_IN => link_addr_M,  
                          ALU_IN => alu_out_M,       
                          LMD_IN => DRAM_OUT,    -- output from DRAM   
                          RD_IN => dest_M,    
                          OPCODE_IN => opcode_M, 
                          NPC_L_OUT => link_addr_W,      
                          ALU_OUT => alu_out_W,     
                          LMD_OUT => LMD_out,     
                          RD_OUT => add_D,
                          OPCODE_OUT => opcode_W);     
                          
----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- WB stage            
RF_in_mux: mux_3to1 port map(A=>alu_out_W,      -- output from ALU of current instruction
                             B=>LMD_out,        -- output from LMD of current instruction
                             C=> link_addr_W,   -- NPC of current instruction in case of JAL instruction
                             SEL=>WB_MUX_SEL,   -- selection signal coming from CU
                             Y=>WB);            -- data going into register file for write back


end STRUCTURAL;
