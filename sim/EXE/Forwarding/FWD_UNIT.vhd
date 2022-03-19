library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- unit responsible for register forwarding from ALU results. Does not support forwarding for memory operations (load and store)
entity FWD_UNIT is
port(Rst        :IN std_logic;
     Rs1        :IN std_logic_vector(4 downto 0);       -- first source register of current operation in EXE stage
     Rs2        :IN std_logic_vector(4 downto 0);       -- second source register of current operation in EXE stage
     Rd_M       :IN std_logic_vector(4 downto 0);       -- destination register of previous operation
     Rd_W       :IN std_logic_vector(4 downto 0);       -- destination register of operation from 2 cycles ago
     ICODE      :IN std_logic_vector(5 downto 0);       -- OPCODE of current operation in EXE stage
     ICODE_M    :IN std_logic_vector(5 downto 0);       -- OPCODE of previous operation
     ICODE_W    :IN std_logic_vector(5 downto 0);       -- OPCODE of operation from 2 cycles ago
     SEL_A      :OUT std_logic_vector(1 downto 0);      -- selection signal for mux that regulates forwarding for first source register
     SEL_B      :OUT std_logic_vector(1 downto 0));     -- selection signal for mux that regulates forwarding for second source register
end FWD_UNIT;

architecture Behavioral of FWD_UNIT is

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


-- raised by CAM
signal match_op     :std_logic; -- signal raised if current operation compatible with forwarding
signal match_op_M   :std_logic; -- signal raised if previous operation compatible with forwarding
signal match_op_W   :std_logic; -- signal raised if operation from 2 cycles ago compatible with forwarding

begin

-- CAM instantiation
CAM: FWD_CAM port map(RST => Rst, DATA_IN_1 => ICODE, DATA_IN_2 => ICODE_M, DATA_IN_3 => ICODE_W,
                      MATCH_1 => match_op, MATCH_2 => match_op_M, MATCH_3 => match_op_W);

process(Rst, Rs1, Rs2, Rd_M, Rd_W, ICODE, ICODE_M, ICODE_W, match_op, match_op_M, match_op_W)
begin
if (Rst = '0') then
    SEL_A <= "00";
    SEL_B <= "00";
else
    SEL_A <= "00"; -- this lets the value from the RF pass, standard behaviour
    SEL_B <= "00";
    if(ICODE = "000000") then -- if current instruction is R-type operation
        if((ICODE_M="000000" or match_op_M = '1') and Rd_M /= "00000") then -- if RD = R0 then not a compatible instruction, in those cases RD = R0 was forced to signal that
            if(Rs1 = Rd_M) then -- if destination register of previous operation same as source register of current, we forward that
                SEL_A <= "01";
            end if;
            if(Rs2 = Rd_M) then
                SEL_B <= "01";
            end if;
        end if;
        if((ICODE_W="000000" or match_op_W = '1') and Rd_W /= "00000") then
            if(Rs1 = Rd_W and Rd_W /= Rd_M) then -- destination register of more recent instruction takes precedence, so we only forward from
                SEL_A <= "10";                   -- 2 cycles ago if we don't have more recent operation writing to the same register, meaning we can 
            end if;                              -- do that only if the RD from 2 cycles ago is different from the one of the more recent one
            if(Rs2 = Rd_W and Rd_W /= Rd_M) then
                SEL_B <= "10";
            end if;
        end if;
    elsif(match_op = '1') then -- if current instruction is compatible one in CAM it has only one source register, other operand is immediate
        if((ICODE_M="000000" or match_op_M = '1') and Rd_M /= "00000" and Rs1 = Rd_M) then
                SEL_A <= "01";
        elsif((ICODE_W="000000" or match_op_W = '1') and Rd_W /= "00000" and Rs1 = Rd_W) then
                SEL_A <= "10";
        end if;
    end if;
end if;
end process;


end Behavioral;
