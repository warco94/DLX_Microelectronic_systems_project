library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;

entity DLX_syn is
  generic (
    IR_SIZE      : integer := 32;       -- Instruction Register Size
    PC_SIZE      : integer := 32       -- Program Counter Size
    );     
  port (
    Clk : IN std_logic;
    Rst : IN std_logic;           -- Active Low
    IRAM_DATA_OUT : IN std_logic_vector(IR_SIZE - 1 downto 0);
    DRAM_DATA_OUT : IN std_logic_vector(31 downto 0); 
    DRAM_DATA_IN  : OUT std_logic_vector(31 downto 0); 
    DRAM_ADDRESS  : OUT std_logic_vector(11 downto 0);
    DRAM_ENABLE   : OUT std_logic;
    DRAM_RW       : OUT std_logic;
    DRAM_SEL      : OUT std_logic_vector(2 downto 0);
    IRAM_ADDRESS  : OUT std_logic_vector(7 downto 0));              
    
end DLX_syn;



architecture structural of DLX_syn is

 --------------------------------------------------------------------
 -- Components Declaration
 --------------------------------------------------------------------
      
  -- Datapath 
  component DPATH is
  port(Clk                : in  std_logic;  -- Clock
        Rst                : in  std_logic;  -- Reset:Active-Low
       
        -- EX Control Signals
        MUXA_SEL           : IN std_logic;  -- MUX-A Sel
        MUXB_SEL           : IN std_logic;  -- MUX-B Sel
        BR_EN              : IN std_logic;  -- Enable jumps and branching
        -- ALU Operation Code
        ALU_OPCODE         : IN aluOp; -- choose between implicit or exlicit coding, like std_logic_vector(ALU_OPC_SIZE -1 downto 0);
        -- WB Control signals
        WB_MUX_SEL         : IN std_logic_vector(1 downto 0);  -- Write Back MUX Sel
        RF_WE              : IN std_logic;
        DRAM_OUT           : IN std_logic_vector(31 downto 0);
        IRAM_OUT           : IN std_logic_vector(31 downto 0);
        IR1                : OUT std_logic_vector(31 downto 0);
        DRAM_IN            : OUT std_logic_vector(31 downto 0);
        DRAM_ADD           : OUT std_logic_vector(11 downto 0);
        IR_ADD             : OUT std_logic_vector(7 downto 0)); 
    end component;
    
  -- Control Unit
  component dlx_cu
  generic (
    MICROCODE_MEM_SIZE :     integer := 63;  -- Microcode Memory Size
    FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
    --ALU_OPC_SIZE       :     integer := 6;  -- ALU Op Code Word Size
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
    BR_EN              : out std_logic;  -- Branch if (not) Equal to Zero
    -- ALU Operation Code
    ALU_OPCODE         : out aluOp; -- choose between implicit or exlicit coding, like std_logic_vector(ALU_OPC_SIZE -1 downto 0);
    
    -- MEM Control Signals
    DRAM_RW            : out std_logic;  -- Data RAM Write Enable
    DRAM_EN            : out std_logic;
    DRAM_SEL           : out std_logic_vector(2 downto 0);   -- Selector for different kind of load and store instructions

    -- WB Control signals
    WB_MUX_SEL         : out std_logic_vector(1 downto 0); -- Write Back MUX Sel
    RF_WE              : out std_logic);  -- Register File Write Enable

  end component;


  ----------------------------------------------------------------
  -- Signals Declaration
  ----------------------------------------------------------------

  -- Instruction Ram Bus signals
  signal IR_CU: std_logic_vector(31 downto 0);

  -- Control Unit Bus signals
  signal BR_EN_i : std_logic;
  signal ALU_OPCODE_i : aluOp;
  signal MUXA_SEL_i : std_logic;
  signal MUXB_SEL_i : std_logic;
  signal WB_MUX_SEL_i : std_logic_vector(1 downto 0);
  signal RF_WE_i : std_logic;  


  begin  -- DLX

    -- Control Unit Instantiation
    CU_I: dlx_cu
      port map (
          Clk             => Clk,
          Rst             => Rst,
          OPCODE_IN       => IR_CU(31 downto 26),
          FUNC_IN         => IR_CU(10 downto 0),
          MUXA_SEL        => MUXA_SEL_i,
          MUXB_SEL        => MUXB_SEL_i,
          BR_EN           => BR_EN_i,
          ALU_OPCODE      => ALU_OPCODE_i,
          DRAM_RW         => DRAM_RW,
          DRAM_EN         => DRAM_ENABLE,
          DRAM_SEL        => DRAM_SEL,
          WB_MUX_SEL      => WB_MUX_SEL_i,
          RF_WE           => RF_WE_i);

-- Data path instantiation --

DataP: DPATH
    port map(Clk => clk,
        Rst=>rst,
        -- EX Control Signals
        MUXA_SEL => MUXA_SEL_i,          
        MUXB_SEL => MUXB_SEL_i,     
        BR_EN => BR_EN_i,          
        -- ALU Operation Code
        ALU_OPCODE => ALU_OPCODE_i,   
        -- WB Control signals
        WB_MUX_SEL => WB_MUX_SEL_i,   
        RF_WE => RF_WE_i,          
        DRAM_OUT => DRAM_DATA_OUT,
        DRAM_IN => DRAM_DATA_IN,
        DRAM_ADD => DRAM_ADDRESS,   
        IRAM_OUT => IRAM_DATA_OUT,
        IR1 => IR_CU,
        IR_ADD => IRAM_ADDRESS);
    
end structural;
