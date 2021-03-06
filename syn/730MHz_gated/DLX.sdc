###################################################################

# Created by write_sdc on Thu Aug 20 23:18:35 2020

###################################################################
set sdc_version 1.9

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
create_clock [get_ports Clk]  -name CLK  -period 1.37  -waveform {0 0.685}
set_max_delay 1.37  -from [list [get_ports Clk] [get_ports Rst] [get_ports {IRAM_DATA_OUT[31]}]   \
[get_ports {IRAM_DATA_OUT[30]}] [get_ports {IRAM_DATA_OUT[29]}] [get_ports     \
{IRAM_DATA_OUT[28]}] [get_ports {IRAM_DATA_OUT[27]}] [get_ports                \
{IRAM_DATA_OUT[26]}] [get_ports {IRAM_DATA_OUT[25]}] [get_ports                \
{IRAM_DATA_OUT[24]}] [get_ports {IRAM_DATA_OUT[23]}] [get_ports                \
{IRAM_DATA_OUT[22]}] [get_ports {IRAM_DATA_OUT[21]}] [get_ports                \
{IRAM_DATA_OUT[20]}] [get_ports {IRAM_DATA_OUT[19]}] [get_ports                \
{IRAM_DATA_OUT[18]}] [get_ports {IRAM_DATA_OUT[17]}] [get_ports                \
{IRAM_DATA_OUT[16]}] [get_ports {IRAM_DATA_OUT[15]}] [get_ports                \
{IRAM_DATA_OUT[14]}] [get_ports {IRAM_DATA_OUT[13]}] [get_ports                \
{IRAM_DATA_OUT[12]}] [get_ports {IRAM_DATA_OUT[11]}] [get_ports                \
{IRAM_DATA_OUT[10]}] [get_ports {IRAM_DATA_OUT[9]}] [get_ports                 \
{IRAM_DATA_OUT[8]}] [get_ports {IRAM_DATA_OUT[7]}] [get_ports                  \
{IRAM_DATA_OUT[6]}] [get_ports {IRAM_DATA_OUT[5]}] [get_ports                  \
{IRAM_DATA_OUT[4]}] [get_ports {IRAM_DATA_OUT[3]}] [get_ports                  \
{IRAM_DATA_OUT[2]}] [get_ports {IRAM_DATA_OUT[1]}] [get_ports                  \
{IRAM_DATA_OUT[0]}] [get_ports {DRAM_DATA_OUT[31]}] [get_ports                 \
{DRAM_DATA_OUT[30]}] [get_ports {DRAM_DATA_OUT[29]}] [get_ports                \
{DRAM_DATA_OUT[28]}] [get_ports {DRAM_DATA_OUT[27]}] [get_ports                \
{DRAM_DATA_OUT[26]}] [get_ports {DRAM_DATA_OUT[25]}] [get_ports                \
{DRAM_DATA_OUT[24]}] [get_ports {DRAM_DATA_OUT[23]}] [get_ports                \
{DRAM_DATA_OUT[22]}] [get_ports {DRAM_DATA_OUT[21]}] [get_ports                \
{DRAM_DATA_OUT[20]}] [get_ports {DRAM_DATA_OUT[19]}] [get_ports                \
{DRAM_DATA_OUT[18]}] [get_ports {DRAM_DATA_OUT[17]}] [get_ports                \
{DRAM_DATA_OUT[16]}] [get_ports {DRAM_DATA_OUT[15]}] [get_ports                \
{DRAM_DATA_OUT[14]}] [get_ports {DRAM_DATA_OUT[13]}] [get_ports                \
{DRAM_DATA_OUT[12]}] [get_ports {DRAM_DATA_OUT[11]}] [get_ports                \
{DRAM_DATA_OUT[10]}] [get_ports {DRAM_DATA_OUT[9]}] [get_ports                 \
{DRAM_DATA_OUT[8]}] [get_ports {DRAM_DATA_OUT[7]}] [get_ports                  \
{DRAM_DATA_OUT[6]}] [get_ports {DRAM_DATA_OUT[5]}] [get_ports                  \
{DRAM_DATA_OUT[4]}] [get_ports {DRAM_DATA_OUT[3]}] [get_ports                  \
{DRAM_DATA_OUT[2]}] [get_ports {DRAM_DATA_OUT[1]}] [get_ports                  \
{DRAM_DATA_OUT[0]}]]  -to [list [get_ports {DRAM_DATA_IN[31]}] [get_ports {DRAM_DATA_IN[30]}]       \
[get_ports {DRAM_DATA_IN[29]}] [get_ports {DRAM_DATA_IN[28]}] [get_ports       \
{DRAM_DATA_IN[27]}] [get_ports {DRAM_DATA_IN[26]}] [get_ports                  \
{DRAM_DATA_IN[25]}] [get_ports {DRAM_DATA_IN[24]}] [get_ports                  \
{DRAM_DATA_IN[23]}] [get_ports {DRAM_DATA_IN[22]}] [get_ports                  \
{DRAM_DATA_IN[21]}] [get_ports {DRAM_DATA_IN[20]}] [get_ports                  \
{DRAM_DATA_IN[19]}] [get_ports {DRAM_DATA_IN[18]}] [get_ports                  \
{DRAM_DATA_IN[17]}] [get_ports {DRAM_DATA_IN[16]}] [get_ports                  \
{DRAM_DATA_IN[15]}] [get_ports {DRAM_DATA_IN[14]}] [get_ports                  \
{DRAM_DATA_IN[13]}] [get_ports {DRAM_DATA_IN[12]}] [get_ports                  \
{DRAM_DATA_IN[11]}] [get_ports {DRAM_DATA_IN[10]}] [get_ports                  \
{DRAM_DATA_IN[9]}] [get_ports {DRAM_DATA_IN[8]}] [get_ports {DRAM_DATA_IN[7]}] \
[get_ports {DRAM_DATA_IN[6]}] [get_ports {DRAM_DATA_IN[5]}] [get_ports         \
{DRAM_DATA_IN[4]}] [get_ports {DRAM_DATA_IN[3]}] [get_ports {DRAM_DATA_IN[2]}] \
[get_ports {DRAM_DATA_IN[1]}] [get_ports {DRAM_DATA_IN[0]}] [get_ports         \
{DRAM_ADDRESS[11]}] [get_ports {DRAM_ADDRESS[10]}] [get_ports                  \
{DRAM_ADDRESS[9]}] [get_ports {DRAM_ADDRESS[8]}] [get_ports {DRAM_ADDRESS[7]}] \
[get_ports {DRAM_ADDRESS[6]}] [get_ports {DRAM_ADDRESS[5]}] [get_ports         \
{DRAM_ADDRESS[4]}] [get_ports {DRAM_ADDRESS[3]}] [get_ports {DRAM_ADDRESS[2]}] \
[get_ports {DRAM_ADDRESS[1]}] [get_ports {DRAM_ADDRESS[0]}] [get_ports         \
DRAM_ENABLE] [get_ports DRAM_RW] [get_ports {DRAM_SEL[2]}] [get_ports          \
{DRAM_SEL[1]}] [get_ports {DRAM_SEL[0]}] [get_ports {IRAM_ADDRESS[7]}]         \
[get_ports {IRAM_ADDRESS[6]}] [get_ports {IRAM_ADDRESS[5]}] [get_ports         \
{IRAM_ADDRESS[4]}] [get_ports {IRAM_ADDRESS[3]}] [get_ports {IRAM_ADDRESS[2]}] \
[get_ports {IRAM_ADDRESS[1]}] [get_ports {IRAM_ADDRESS[0]}]]
