# General basic entities and packages
analyze -library WORK -format vhdl {./000-globals.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/constants.vhd}
analyze -library WORK -format vhdl {{./basic components/basic_register.vhd}}
analyze -library WORK -format vhdl {{./basic components/mux3to1.vhd}}
analyze -library WORK -format vhdl {{./basic components/mux4to1.vhd}}

# IF stage entities
analyze -library WORK -format vhdl {./IF/NPC_adder.vhd}
analyze -library WORK -format vhdl {./IF/branch_predictor.vhd}

# IF/ID
analyze -library WORK -format vhdl {./IF_ID.vhd}

# ID stage entities
analyze -library WORK -format vhdl {./ID/IR_decoder.vhd}
analyze -library WORK -format vhdl {./ID/Register_file.vhd}
analyze -library WORK -format vhdl {./ID/sign_extender.vhd}

# ID/EXE
analyze -library WORK -format vhdl {./ID_EX.vhd}

# EXE stage entities
analyze -library WORK -format vhdl {./EXE/branch_cond.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/comparator.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/generic_shifter.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/logic.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/Buffer.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/G.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/PG.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/andg.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/xorg.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/fa.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/mux21_generic.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/carry_generator_parametric.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/rca.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/carry_select_block.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/sum_generator.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/P4_adder/P4_adder.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/add_sub.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/Adder/add_wrapper.vhd}
analyze -library WORK -format vhdl {./EXE/ALU/ALU.vhd}
analyze -library WORK -format vhdl {./EXE/Forwarding/FWD_CAM.vhd}
analyze -library WORK -format vhdl {./EXE/Forwarding/FWD_UNIT.vhd}
analyze -library WORK -format vhdl {./EXE/Forwarding/FWD_UNIT_BRANCH.vhd}

# EXE/MEM
analyze -library WORK -format vhdl {./EX_MEM.vhd}

# MEM/WB
analyze -library WORK -format vhdl {./MEM_WB.vhd}

# Top entity 
analyze -library WORK -format vhdl {./a.b-DataPath.vhd}
analyze -library WORK -format vhdl {./a.a-CU_HW.vhd}
analyze -library WORK -format vhdl {./DLX_syn.vhd}

# Elaboration step
elaborate DLX_SYN -architecture STRUCTURAL -library WORK

# Clock setup
create_clock -name "CLK" -period 1.67 Clk
set_max_delay 1.67 -from [all_inputs] -to [all_outputs]

# Compilation step
compile -map_effort high

# Report and netlist production
report_timing -nworst 10 > timing_600MHz_not_gated.txt
report_power > power_600MHz_not_gated.txt
report_area > area_600MHz_not_gated.txt
write -hierarchy -format vhdl -output DLX.vhdl
write -hierarchy -format verilog -output DLX.v
write_sdc DLX.sdc
