set_wire_load_model -name 5K_hvratio_1_4
compile -exact_map -map_effort high -area_effort high -power_effort high -gate_clock
report_power > POWER_REPORTS/optimised1_power.rpt
report_timing > TIMING_REPORTS/optimised1_timing.rpt
report_area > AREA_REPORTS/optimised1_area.rpt
write -hierarchy -f ddc -output dlx_optimised1_syn.ddc
write -hierarchy -f verilog -output dlx_optimised1.v

