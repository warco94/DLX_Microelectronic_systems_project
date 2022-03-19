# Create library
vlib work

# Basic components and packages
vcom 000-globals.vhd
vcom constants.vhd
vcom basic_components/basic_register.vhd
vcom basic_components/mux3to1.vhd
vcom basic_components/mux4to1.vhd

# IF stage entities
vcom IF/NPC_adder.vhd
vcom IF/branch_predictor.vhd

# ID stage entities
vcom ID/Register_file.vhd
vcom ID/IR_decoder.vhd
vcom ID/sign_extender.vhd

# EXE stage entities
vcom EXE/ALU/Adder/P4_adder/andg.vhd
vcom EXE/ALU/Adder/P4_adder/xorg.vhd
vcom EXE/ALU/Adder/P4_adder/Buffer.vhd
vcom EXE/ALU/Adder/P4_adder/fa.vhd
vcom EXE/ALU/Adder/P4_adder/G.vhd
vcom EXE/ALU/Adder/P4_adder/PG.vhd
vcom EXE/ALU/Adder/P4_adder/mux21_generic.vhd
vcom EXE/ALU/Adder/P4_adder/rca.vhd
vcom EXE/ALU/Adder/P4_adder/carry_generator_parametric.vhd
vcom EXE/ALU/Adder/P4_adder/carry_select_block.vhd
vcom EXE/ALU/Adder/P4_adder/sum_generator.vhd
vcom EXE/ALU/Adder/P4_adder/P4_adder.vhd
vcom EXE/ALU/Adder/add_sub.vhd
vcom EXE/ALU/Adder/add_wrapper.vhd
vcom EXE/ALU/comparator.vhd
vcom EXE/ALU/generic_shifter.vhd
vcom EXE/ALU/logic.vhd
vcom EXE/ALU/ALU.vhd
vcom EXE/Forwarding/FWD_CAM.vhd
vcom EXE/Forwarding/FWD_UNIT.vhd
vcom EXE/Forwarding/FWD_UNIT_BRANCH.vhd
vcom EXE/branch_cond.vhd

# Pipeline registers
vcom IF_ID.vhd
vcom ID_EX.vhd
vcom EX_MEM.vhd
vcom MEM_WB.vhd

# Main omponents of the DLX
vcom a.a-CU_HW.vhd
vcom a.b-DataPath.vhd
vcom a.c-IRAM.vhd
vcom DRAM.vhd

# Top level entity to test
vcom a-DLX.vhd

# Testbench
vcom test_bench/TB_DLX.vhd

# Command to start the simulation
vsim -t 10ps work.tb_dlx
