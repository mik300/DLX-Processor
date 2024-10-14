###################################################################

# Created by write_sdc on Thu Oct 19 21:55:49 2023

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_wire_load_model -name 5K_hvratio_1_4 -library NangateOpenCellLibrary
create_clock [get_ports CLK_DLX]  -period 5  -waveform {0 2.5}
create_clock [get_ports CLKNEG_DLX]  -period 5  -waveform {0 2.5}
set_max_delay 5  -from [list [get_ports CLK_DLX] [get_ports CLKNEG_DLX] [get_ports RST_DLX]    \
[get_ports {DATA_IRAM[31]}] [get_ports {DATA_IRAM[30]}] [get_ports             \
{DATA_IRAM[29]}] [get_ports {DATA_IRAM[28]}] [get_ports {DATA_IRAM[27]}]       \
[get_ports {DATA_IRAM[26]}] [get_ports {DATA_IRAM[25]}] [get_ports             \
{DATA_IRAM[24]}] [get_ports {DATA_IRAM[23]}] [get_ports {DATA_IRAM[22]}]       \
[get_ports {DATA_IRAM[21]}] [get_ports {DATA_IRAM[20]}] [get_ports             \
{DATA_IRAM[19]}] [get_ports {DATA_IRAM[18]}] [get_ports {DATA_IRAM[17]}]       \
[get_ports {DATA_IRAM[16]}] [get_ports {DATA_IRAM[15]}] [get_ports             \
{DATA_IRAM[14]}] [get_ports {DATA_IRAM[13]}] [get_ports {DATA_IRAM[12]}]       \
[get_ports {DATA_IRAM[11]}] [get_ports {DATA_IRAM[10]}] [get_ports             \
{DATA_IRAM[9]}] [get_ports {DATA_IRAM[8]}] [get_ports {DATA_IRAM[7]}]          \
[get_ports {DATA_IRAM[6]}] [get_ports {DATA_IRAM[5]}] [get_ports               \
{DATA_IRAM[4]}] [get_ports {DATA_IRAM[3]}] [get_ports {DATA_IRAM[2]}]          \
[get_ports {DATA_IRAM[1]}] [get_ports {DATA_IRAM[0]}] [get_ports               \
{DATA_DRAM[31]}] [get_ports {DATA_DRAM[30]}] [get_ports {DATA_DRAM[29]}]       \
[get_ports {DATA_DRAM[28]}] [get_ports {DATA_DRAM[27]}] [get_ports             \
{DATA_DRAM[26]}] [get_ports {DATA_DRAM[25]}] [get_ports {DATA_DRAM[24]}]       \
[get_ports {DATA_DRAM[23]}] [get_ports {DATA_DRAM[22]}] [get_ports             \
{DATA_DRAM[21]}] [get_ports {DATA_DRAM[20]}] [get_ports {DATA_DRAM[19]}]       \
[get_ports {DATA_DRAM[18]}] [get_ports {DATA_DRAM[17]}] [get_ports             \
{DATA_DRAM[16]}] [get_ports {DATA_DRAM[15]}] [get_ports {DATA_DRAM[14]}]       \
[get_ports {DATA_DRAM[13]}] [get_ports {DATA_DRAM[12]}] [get_ports             \
{DATA_DRAM[11]}] [get_ports {DATA_DRAM[10]}] [get_ports {DATA_DRAM[9]}]        \
[get_ports {DATA_DRAM[8]}] [get_ports {DATA_DRAM[7]}] [get_ports               \
{DATA_DRAM[6]}] [get_ports {DATA_DRAM[5]}] [get_ports {DATA_DRAM[4]}]          \
[get_ports {DATA_DRAM[3]}] [get_ports {DATA_DRAM[2]}] [get_ports               \
{DATA_DRAM[1]}] [get_ports {DATA_DRAM[0]}]]  -to [list [get_ports {ADDRESS_IRAM[31]}] [get_ports {ADDRESS_IRAM[30]}]       \
[get_ports {ADDRESS_IRAM[29]}] [get_ports {ADDRESS_IRAM[28]}] [get_ports       \
{ADDRESS_IRAM[27]}] [get_ports {ADDRESS_IRAM[26]}] [get_ports                  \
{ADDRESS_IRAM[25]}] [get_ports {ADDRESS_IRAM[24]}] [get_ports                  \
{ADDRESS_IRAM[23]}] [get_ports {ADDRESS_IRAM[22]}] [get_ports                  \
{ADDRESS_IRAM[21]}] [get_ports {ADDRESS_IRAM[20]}] [get_ports                  \
{ADDRESS_IRAM[19]}] [get_ports {ADDRESS_IRAM[18]}] [get_ports                  \
{ADDRESS_IRAM[17]}] [get_ports {ADDRESS_IRAM[16]}] [get_ports                  \
{ADDRESS_IRAM[15]}] [get_ports {ADDRESS_IRAM[14]}] [get_ports                  \
{ADDRESS_IRAM[13]}] [get_ports {ADDRESS_IRAM[12]}] [get_ports                  \
{ADDRESS_IRAM[11]}] [get_ports {ADDRESS_IRAM[10]}] [get_ports                  \
{ADDRESS_IRAM[9]}] [get_ports {ADDRESS_IRAM[8]}] [get_ports {ADDRESS_IRAM[7]}] \
[get_ports {ADDRESS_IRAM[6]}] [get_ports {ADDRESS_IRAM[5]}] [get_ports         \
{ADDRESS_IRAM[4]}] [get_ports {ADDRESS_IRAM[3]}] [get_ports {ADDRESS_IRAM[2]}] \
[get_ports {ADDRESS_IRAM[1]}] [get_ports {ADDRESS_IRAM[0]}] [get_ports         \
{DATA_REGDATAMEM[31]}] [get_ports {DATA_REGDATAMEM[30]}] [get_ports            \
{DATA_REGDATAMEM[29]}] [get_ports {DATA_REGDATAMEM[28]}] [get_ports            \
{DATA_REGDATAMEM[27]}] [get_ports {DATA_REGDATAMEM[26]}] [get_ports            \
{DATA_REGDATAMEM[25]}] [get_ports {DATA_REGDATAMEM[24]}] [get_ports            \
{DATA_REGDATAMEM[23]}] [get_ports {DATA_REGDATAMEM[22]}] [get_ports            \
{DATA_REGDATAMEM[21]}] [get_ports {DATA_REGDATAMEM[20]}] [get_ports            \
{DATA_REGDATAMEM[19]}] [get_ports {DATA_REGDATAMEM[18]}] [get_ports            \
{DATA_REGDATAMEM[17]}] [get_ports {DATA_REGDATAMEM[16]}] [get_ports            \
{DATA_REGDATAMEM[15]}] [get_ports {DATA_REGDATAMEM[14]}] [get_ports            \
{DATA_REGDATAMEM[13]}] [get_ports {DATA_REGDATAMEM[12]}] [get_ports            \
{DATA_REGDATAMEM[11]}] [get_ports {DATA_REGDATAMEM[10]}] [get_ports            \
{DATA_REGDATAMEM[9]}] [get_ports {DATA_REGDATAMEM[8]}] [get_ports              \
{DATA_REGDATAMEM[7]}] [get_ports {DATA_REGDATAMEM[6]}] [get_ports              \
{DATA_REGDATAMEM[5]}] [get_ports {DATA_REGDATAMEM[4]}] [get_ports              \
{DATA_REGDATAMEM[3]}] [get_ports {DATA_REGDATAMEM[2]}] [get_ports              \
{DATA_REGDATAMEM[1]}] [get_ports {DATA_REGDATAMEM[0]}] [get_ports              \
{ADDRESS_DRAM[7]}] [get_ports {ADDRESS_DRAM[6]}] [get_ports {ADDRESS_DRAM[5]}] \
[get_ports {ADDRESS_DRAM[4]}] [get_ports {ADDRESS_DRAM[3]}] [get_ports         \
{ADDRESS_DRAM[2]}] [get_ports {ADDRESS_DRAM[1]}] [get_ports {ADDRESS_DRAM[0]}] \
[get_ports RW_DRAM]]
