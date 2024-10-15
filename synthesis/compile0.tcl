set_wire_load_model -name 5K_hvratio_1_4
compile -exact_map
report_power > POWER_REPORTS/optimised0_power.rpt
report_timing > TIMING_REPORTS/optimised0_timing.rpt
report_area > AREA_REPORTS/optimised0_area.rpt
write -hierarchy -f ddc -output dlx_optimised0_syn.ddc
write -hierarchy -f verilog -output dlx_optimised0.v

