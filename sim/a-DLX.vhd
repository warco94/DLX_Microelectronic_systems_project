library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;

entity DLX is
  generic (
    IR_SIZE      : integer := 32;       -- Instruction Register Size
    PC_SIZE      : integer := 32       -- Program Counter Size
    );       -- ALU_OPC_SIZE if explicit ALU Op Code Word Size
  port (
    Clk : in std_logic;
    Rst : in std_logic);                -- Active Low
end DLX;


-- This architecture is currently not complete
-- it just includes:
-- instruction register (complete)
-- program counter (complete)
-- instruction ram memory (complete)
-- control unit (UNCOMPLETE)
--
architecture dlx_rtl of DLX is

 --------------------------------------------------------------------
 -- Components Declaration
 --------------------------------------------------------------------
  
  --Instruction Ram
  component IRAM
--     generic (
--       RAM_DEPTH : integer;
--       I_SIZE    : integer);
    port (
      Rst  : in  std_logic;
      Addr : in  std_logic_vector(7 downto 0);
      Dout : out std_logic_vector(IR_SIZE - 1 downto 0));
  end component;

  -- Data Ram 
    component DRAM is
      generic (
        RAM_DEPTH : integer := 4096;
        I_SIZE : integer := 32);
        port (
          Rst : in  std_logic; 
          En : in  std_logic;
          Addr : in  std_logic_vector(11 downto 0);
          R_W  : in std_logic;
          SEL  : in std_logic_vector(2 downto 0); 
          Din  : in  std_logic_vector(I_SIZE - 1 downto 0);
          Dout : out std_logic_vector(I_SIZE - 1 downto 0));
    end component;
    
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
  signal IRam_DOut : std_logic_vector(IR_SIZE - 1 downto 0);
  signal IR_ADD_i: std_logic_vector(7 downto 0);
  signal IR_CU: std_logic_vector(31 downto 0);

  -- Control Unit Bus signals
  signal BR_EN_i : std_logic;
  signal ALU_OPCODE_i : aluOp;
  signal MUXA_SEL_i : std_logic;
  signal MUXB_SEL_i : std_logic;
  signal DRAM_RW_i : std_logic;
  signal DRAM_EN_i : std_logic;
  signal DRAM_SEL_i : std_logic_vector(2 downto 0);
  signal WB_MUX_SEL_i : std_logic_vector(1 downto 0);
  signal RF_WE_i : std_logic;
  

  -- Data Ram Bus signals
  signal DRAM_OUT_i: std_logic_vector(31 downto 0);  
  signal DRAM_IN_i: std_logic_vector(31 downto 0);
  signal DRAM_ADD_i: std_logic_vector(11 downto 0);

  begin  -- DLX

    

-- Instruction Ram Instantiation
IRAM_I: IRAM
  port map (
      Rst  => Rst,
      Addr => IR_ADD_i,
      Dout => IRam_DOut);

-- Data Ram Instantiation    
DataRAM: DRAM
    port map(
      Rst =>rst,
      Addr => DRAM_ADD_i,
      En => DRAM_EN_i,
      R_W => DRAM_RW_i,
      SEL => DRAM_SEL_i,
      Din => DRAM_IN_i,
      Dout => DRAM_OUT_i);


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
      DRAM_RW         => DRAM_RW_i,
      DRAM_EN         => DRAM_EN_i,
      DRAM_SEL        => DRAM_SEL_i,
      WB_MUX_SEL      => WB_MUX_SEL_i,
      RF_WE           => RF_WE_i);

-- Data path instantiation
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
        DRAM_OUT => DRAM_OUT_i,
        DRAM_IN => DRAM_IN_i,
        DRAM_ADD => DRAM_ADD_i,   
        IRAM_OUT => IRam_DOut,
        IR1 => IR_CU,
        IR_ADD => IR_ADD_i);
    
end dlx_rtl;
