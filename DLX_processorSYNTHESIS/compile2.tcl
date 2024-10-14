set_wire_load_model -name 5K_hvratio_1_4
compile_ultra -gate_clock
report_power > POWER_REPORTS/optimised2_power.rpt
report_timing > TIMING_REPORTS/optimised2_timing.rpt
report_area > AREA_REPORTS/optimised2_area.rpt
write -hierarchy -f ddc -output dlx_optimised2_syn.ddc
write -hierarchy -f verilog -output dlx_optimised2.v

