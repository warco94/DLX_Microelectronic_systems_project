library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- simple forwarding unit for the branch instructions
entity FWD_UNIT_BRANCH is
port(Rst        :IN std_logic;
     Rs1        :IN std_logic_vector(4 downto 0);
     Rd_M       :IN std_logic_vector(4 downto 0);
     Rd_W       :IN std_logic_vector(4 downto 0);
     ICODE      :IN std_logic_vector(5 downto 0);
     ICODE_M    :IN std_logic_vector(5 downto 0);
     ICODE_W    :IN std_logic_vector(5 downto 0);
     SEL      :OUT std_logic_vector(1 downto 0));
end FWD_UNIT_BRANCH;

architecture Behavioral of FWD_UNIT_BRANCH is

-- CAM containing compatible instructions
component FWD_CAM is
port(RST             :IN std_logic;
     DATA_IN_1       :IN std_logic_vector(5 downto 0);
     DATA_IN_2       :IN std_logic_vector(5 downto 0);
     DATA_IN_3       :IN std_logic_vector(5 downto 0);
     MATCH_1         :OUT std_logic;
     MATCH_2         :OUT std_logic;
     MATCH_3         :OUT std_logic);
end component;

signal match_op     :std_logic;     -- signal raised if current operation compatible with forwarding
signal match_op_M   :std_logic;     -- signal raised if previous operation compatible with forwarding
signal match_op_W   :std_logic;     -- signal raised if operation from 2 cycles ago compatible with forwarding

begin

-- CAM instantiation
CAM: FWD_CAM port map(RST => Rst, DATA_IN_1 => ICODE, DATA_IN_2 => ICODE_M, DATA_IN_3 => ICODE_W,
                      MATCH_1 => match_op, MATCH_2 => match_op_M, MATCH_3 => match_op_W);

process(Rst, Rs1, Rd_M, Rd_W, ICODE, ICODE_M, ICODE_W, match_op_M, match_op_W)
begin
if (Rst = '0') then
    SEL <= "00";
else
    if(ICODE = "000100" or ICODE = "000101") then -- OPCODEs for BEQZ and BNEZ
        if((ICODE_M="000000" or match_op_M = '1') and Rd_M /= "00000" and Rs1 = Rd_M) then  -- if destination register of previous operation same as source register of current, we forward that
            SEL <= "01";                                                                    -- if RD = R0 then not a compatible instruction, in those cases RD = R0 was forced to signal that
        elsif((ICODE_W="000000" or match_op_W = '1') and Rd_W /= "00000" and Rs1 = Rd_W) then            
            SEL <= "10";
        else
            SEL <= "00"; -- this lets the value from the RF pass, standard behaviour
        end if;   
    end if;
end if;
end process;


end Behavioral;
