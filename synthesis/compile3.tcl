set_wire_load_model -name 5K_hvratio_1_4
create_clock -name "CLK_DLX" -period 5 {"CLK_DLX"} 
create_clock -name "CLKNEG_DLX" -period 5 {"CLKNEG_DLX"}
set_max_delay 5 -from [all_inputs] -to [all_outputs]
compile_ultra -gate_clock
report_power > POWER_REPORTS/optimised3_power.rpt
report_timing > TIMING_REPORTS/optimised3_timing.rpt
report_area > AREA_REPORTS/optimised3_area.rpt
write -hierarchy -f ddc -output dlx_optimised3_syn.ddc
write -hierarchy -f verilog -output dlx_optimised3.v
write_sdc DLX.sdc
