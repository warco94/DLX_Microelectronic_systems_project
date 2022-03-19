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

  -- Data Ram (MISSING!You must include it in your final project!)
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
    
   component DLX_syn is

   port( Clk, Rst : in std_logic;  IRAM_DATA_OUT, DRAM_DATA_OUT : in 
         std_logic_vector (31 downto 0);  DRAM_DATA_IN : out std_logic_vector 
         (31 downto 0);  DRAM_ADDRESS : out std_logic_vector (11 downto 0);  
         DRAM_ENABLE, DRAM_RW : out std_logic;  DRAM_SEL : out std_logic_vector
         (2 downto 0);  IRAM_ADDRESS : out std_logic_vector (7 downto 0));

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

    -- Control Unit Instantiation
    

    -- Instruction Ram Instantiation
IRAM_I: IRAM
  port map (
      Rst  => Rst,
      Addr => IR_ADD_i,
      Dout => IRam_DOut);

-
    
DataRAM: DRAM
    port map(
      Rst =>rst,
      Addr => DRAM_ADD_i,
      En => DRAM_EN_i,
      R_W => DRAM_RW_i,
      SEL => DRAM_SEL_i,
      Din => DRAM_IN_i,
      Dout => DRAM_OUT_i);

DLXs:	DLX_syn
	port map( Clk => Clk, Rst => Rst,  IRAM_DATA_OUT => IRam_DOut, DRAM_DATA_OUT => DRAM_OUT_i,
         DRAM_DATA_IN => DRAM_IN_i, DRAM_ADDRESS => DRAM_ADD_i, DRAM_ENABLE => DRAM_EN_i, 
		 DRAM_RW => DRAM_RW_i,  DRAM_SEL => DRAM_SEL_i, IRAM_ADDRESS => IR_ADD_i);
    
end dlx_rtl;
