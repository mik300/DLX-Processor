#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Thu Oct 19 21:58:45 2023                
#                                                     
#######################################################

#@(#)CDS: Innovus v20.11-s130_1 (64bit) 08/05/2020 15:53 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 20.11-s130_1 NR200802-2257/20_11-UB (database version 18.20.512) {superthreading v2.9}
#@(#)CDS: AAE 20.11-s008 (64bit) 08/05/2020 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 20.11-s059_1 () Aug  2 2020 05:46:30 ( )
#@(#)CDS: SYNTECH 20.11-s028_1 () Aug  1 2020 06:14:27 ( )
#@(#)CDS: CPE v20.11-s013
#@(#)CDS: IQuantus/TQuantus 19.1.3-s260 (64bit) Thu May 28 10:57:28 PDT 2020 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
win
set defHierChar /
set delaycal_input_transition_delay 0.1ps
set fpIsMaxIoHeight 0
set init_gnd_net gnd
set init_mmmc_file Default.view
set init_oa_search_lib {}
set init_pwr_net vdd
set init_verilog dlx_optimised3.v
set init_lef_file /eda/dk/nangate45/lef/NangateOpenCellLibrary.lef
init_design
getIoFlowFlag
setIoFlowFlag 0
floorPlan -coreMarginsBy die -site FreePDK45_38x28_10R_NP_162NW_34O -r 1.0 0.6 5.0 5.0 5.0 5.0
uiSetTool select
getIoFlowFlag
fit
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer metal10 -stacked_via_bottom_layer metal1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {vdd gnd} -type core_rings -follow core -layer {top metal9 bottom metal9 left metal10 right metal10} -width {top 0.8 bottom 0.8 left 0.8 right 0.8} -spacing {top 0.8 bottom 0.8 left 0.8 right 0.8} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 1 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer metal10 -stacked_via_bottom_layer metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets {vdd gnd} -layer metal10 -direction vertical -width 0.8 -spacing 0.8 -set_to_set_distance 20 -start_from left -start_offset 15 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit metal10 -padcore_ring_bottom_layer_limit metal1 -block_ring_top_layer_limit metal10 -block_ring_bottom_layer_limit metal1 -use_wire_group 0 -snap_wire_center_to_grid None
setSrouteMode -viaConnectToShape { noshape }
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { metal1(1) metal10(10) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { metal1(1) metal10(10) } -nets { vdd gnd } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { metal1(1) metal10(10) }
setPlaceMode -prerouteAsObs {1 2 3 4 5 6 7 8}
setPlaceMode -fp false
place_design
zoomBox -33.94750 56.30950 166.32700 140.07500
zoomBox -20.23850 66.72800 149.99500 137.92900
zoomBox -34.56850 56.59500 165.70700 140.36100
zoomBox -51.42650 44.67350 184.19200 143.22200
zoomBox -71.62300 31.44050 205.57600 147.38000
zoomBox -123.42050 -2.35900 260.24600 158.11100
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 1 -spreadType center -spacing 0.14 -pin CLK_DLX
setPinAssignMode -pinEditInBatch false
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 1 -spreadType center -spacing 0.14 -pin CLKNEG_DLX
setPinAssignMode -pinEditInBatch false
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Right -layer 1 -spreadType side -pin {{ADDRESS_DRAM[0]} {ADDRESS_DRAM[1]} {ADDRESS_DRAM[2]} {ADDRESS_DRAM[3]} {ADDRESS_DRAM[4]} {ADDRESS_DRAM[5]} {ADDRESS_DRAM[6]} {ADDRESS_DRAM[7]}}
setPinAssignMode -pinEditInBatch false
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Right -layer 1 -spreadType side -pin {{ADDRESS_IRAM[0]} {ADDRESS_IRAM[1]} {ADDRESS_IRAM[2]} {ADDRESS_IRAM[3]} {ADDRESS_IRAM[4]} {ADDRESS_IRAM[5]} {ADDRESS_IRAM[6]} {ADDRESS_IRAM[7]} {ADDRESS_IRAM[8]} {ADDRESS_IRAM[9]} {ADDRESS_IRAM[10]} {ADDRESS_IRAM[11]} {ADDRESS_IRAM[12]} {ADDRESS_IRAM[13]} {ADDRESS_IRAM[14]} {ADDRESS_IRAM[15]} {ADDRESS_IRAM[16]} {ADDRESS_IRAM[17]} {ADDRESS_IRAM[18]} {ADDRESS_IRAM[19]} {ADDRESS_IRAM[20]} {ADDRESS_IRAM[21]} {ADDRESS_IRAM[22]} {ADDRESS_IRAM[23]} {ADDRESS_IRAM[24]} {ADDRESS_IRAM[25]} {ADDRESS_IRAM[26]} {ADDRESS_IRAM[27]} {ADDRESS_IRAM[28]} {ADDRESS_IRAM[29]} {ADDRESS_IRAM[30]} {ADDRESS_IRAM[31]}}
setPinAssignMode -pinEditInBatch false
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Left -layer 1 -spreadType side -pin {{DATA_DRAM[0]} {DATA_DRAM[1]} {DATA_DRAM[2]} {DATA_DRAM[3]} {DATA_DRAM[4]} {DATA_DRAM[5]} {DATA_DRAM[6]} {DATA_DRAM[7]} {DATA_DRAM[8]} {DATA_DRAM[9]} {DATA_DRAM[10]} {DATA_DRAM[11]} {DATA_DRAM[12]} {DATA_DRAM[13]} {DATA_DRAM[14]} {DATA_DRAM[15]} {DATA_DRAM[16]} {DATA_DRAM[17]} {DATA_DRAM[18]} {DATA_DRAM[19]} {DATA_DRAM[20]} {DATA_DRAM[21]} {DATA_DRAM[22]} {DATA_DRAM[23]} {DATA_DRAM[24]} {DATA_DRAM[25]} {DATA_DRAM[26]} {DATA_DRAM[27]} {DATA_DRAM[28]} {DATA_DRAM[29]} {DATA_DRAM[30]} {DATA_DRAM[31]}}
setPinAssignMode -pinEditInBatch false
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Left -layer 1 -spreadType side -pin {{DATA_IRAM[0]} {DATA_IRAM[1]} {DATA_IRAM[2]} {DATA_IRAM[3]} {DATA_IRAM[4]} {DATA_IRAM[5]} {DATA_IRAM[6]} {DATA_IRAM[7]} {DATA_IRAM[8]} {DATA_IRAM[9]} {DATA_IRAM[10]} {DATA_IRAM[11]} {DATA_IRAM[12]} {DATA_IRAM[13]} {DATA_IRAM[14]} {DATA_IRAM[15]} {DATA_IRAM[16]} {DATA_IRAM[17]} {DATA_IRAM[18]} {DATA_IRAM[19]} {DATA_IRAM[20]} {DATA_IRAM[21]} {DATA_IRAM[22]} {DATA_IRAM[23]} {DATA_IRAM[24]} {DATA_IRAM[25]} {DATA_IRAM[26]} {DATA_IRAM[27]} {DATA_IRAM[28]} {DATA_IRAM[29]} {DATA_IRAM[30]} {DATA_IRAM[31]}}
setPinAssignMode -pinEditInBatch false
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Bottom -layer 1 -spreadType side -pin {{DATA_REGDATAMEM[0]} {DATA_REGDATAMEM[1]} {DATA_REGDATAMEM[2]} {DATA_REGDATAMEM[3]} {DATA_REGDATAMEM[4]} {DATA_REGDATAMEM[5]} {DATA_REGDATAMEM[6]} {DATA_REGDATAMEM[7]} {DATA_REGDATAMEM[8]} {DATA_REGDATAMEM[9]} {DATA_REGDATAMEM[10]} {DATA_REGDATAMEM[11]} {DATA_REGDATAMEM[12]} {DATA_REGDATAMEM[13]} {DATA_REGDATAMEM[14]} {DATA_REGDATAMEM[15]} {DATA_REGDATAMEM[16]} {DATA_REGDATAMEM[17]} {DATA_REGDATAMEM[18]} {DATA_REGDATAMEM[19]} {DATA_REGDATAMEM[20]} {DATA_REGDATAMEM[21]} {DATA_REGDATAMEM[22]} {DATA_REGDATAMEM[23]} {DATA_REGDATAMEM[24]} {DATA_REGDATAMEM[25]} {DATA_REGDATAMEM[26]} {DATA_REGDATAMEM[27]} {DATA_REGDATAMEM[28]} {DATA_REGDATAMEM[29]} {DATA_REGDATAMEM[30]} {DATA_REGDATAMEM[31]}}
setPinAssignMode -pinEditInBatch false
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 1 -spreadType center -spacing 0.14 -pin RST_DLX
setPinAssignMode -pinEditInBatch false
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 1 -spreadType center -spacing 0.14 -pin RW_DRAM
setPinAssignMode -pinEditInBatch false
zoomBox -13.13850 84.33450 157.09650 155.53600
zoomBox 47.33850 127.93600 101.91250 150.76200
zoomBox 62.83050 137.77300 87.04650 147.90150
zoomBox 38.63350 120.82700 114.17500 152.42250
zoomBox 24.91800 111.30800 129.47400 155.03900
zoomBox -7.30500 91.67100 162.94800 162.88000
zoomBox -39.37750 72.15750 196.26650 170.71650
zoomBox -59.77350 59.74850 217.45450 175.70000
pan 3.96050 80.13800
pan 5.94050 13.91100
pan -15.84150 64.73650
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postCTS
optDesign -postCTS -hold
getFillerMode -quiet
addFiller -cell FILLCELL_X8 FILLCELL_X4 FILLCELL_X32 FILLCELL_X2 FILLCELL_X16 FILLCELL_X1 -prefix FILLER
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven false
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail
pan 12.32100 106.76050
zoomBox 24.42800 80.10100 194.68100 151.31000
zoomBox 58.81200 97.34950 181.82000 148.79800
zoomBox 114.81450 124.77200 161.20800 144.17650
zoomBox 130.95250 132.16350 155.17100 142.29300
pan 0.03850 2.15250
pan 0.21150 -4.69000
pan 0.36500 -11.55200
pan -0.13450 -18.20250
pan 0.25000 -23.08450
pan 0.00000 -30.52300
pan -0.11500 -37.65400
pan 0.13450 -44.68900
zoomBox 109.43350 83.55300 164.01900 106.38350
zoomBox 102.36950 82.49800 166.58750 109.35750
zoomBox 59.24650 76.05650 182.26950 127.51150
zoomBox 19.13000 53.43550 219.45450 137.22200
pan -40.06450 62.44650
zoomBox 37.94050 121.94450 113.49400 153.54500
zoomBox 60.07800 136.54350 88.57400 148.46200
zoomBox 68.50000 142.34650 79.24950 146.84250
zoomBox 57.04400 133.62450 96.49750 150.12600
zoomBox 24.02550 108.26800 147.09750 159.74350
zoomBox -36.96150 61.69450 240.41350 177.70750
pan -103.46550 66.51550
zoomBox -62.41900 82.94700 60.65450 134.42300
zoomBox -32.67900 103.33500 31.56700 130.20600
zoomBox -16.49600 114.35100 17.04100 128.37800
zoomBox -11.80650 117.56350 12.42500 127.69850
pan 0.44250 124.08150
pan -0.11550 117.25400
pan 1.00000 113.67700
zoomBox -24.90300 93.23000 39.34750 120.10300
zoomBox -53.96150 75.36050 90.84550 135.92650
pan 2.75850 121.16200
pan 5.05700 108.06050
pan 1.37900 100.01500
zoomBox -108.75200 27.98000 168.65500 144.00650
pan 10.78800 107.01000
pan 17.17300 57.69300
zoomBox -14.42100 -16.13700 90.20400 27.62300
zoomBox -2.58850 -8.84150 52.02650 14.00150
zoomBox 7.46050 -4.65450 35.97050 7.27000
zoomBox -23.81800 -12.31600 51.77850 19.30250
zoomBox -106.75350 -32.47900 93.69100 51.35750
pan 46.61150 114.36350
zoomBox -222.65200 -90.24000 402.60950 171.27800
zoomBox -187.74200 -59.42350 343.73050 162.86700
zoomBox -156.36000 -33.48250 295.39200 155.46450
zoomBox -129.68500 -11.43300 254.30400 149.17200
pan -7.92350 123.73750
setAnalysisMode -analysisType onChipVariation
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute
optDesign -postRoute -hold
zoomBox -106.75200 16.86350 219.63850 153.37750
zoomBox -79.39750 30.57950 198.03450 146.61650
zoomBox -36.38300 52.14800 164.06200 135.98500
zoomBox -19.60800 60.57150 150.77050 131.83300
pan 4.86800 79.50350
zoomBox -14.74050 70.58450 130.08200 131.15700
zoomBox -17.17450 64.11400 153.20500 135.37600
pan 1.21700 81.01800
zoomBox -4.07400 99.58200 50.54700 122.42750
zoomBox -2.87150 104.30950 36.59250 120.81550
pan -5.57500 107.55700
pan 0.68900 115.51250
zoomBox -6.52650 108.85600 27.01800 122.88600
zoomBox -16.11850 86.62500 88.52000 130.39050
zoomBox -33.57550 45.95650 202.25750 144.59450
pan -5.05350 103.48950
zoomBox -38.62900 52.50700 238.82150 168.55200
saveDesign dlx_routed
saveDesign dlx_routed
zoomBox -74.72250 -33.99400 456.78700 188.31200
zoomBox -88.04750 -65.92950 537.25800 195.60700
zoomBox -53.88900 32.66350 272.52500 169.18750
zoomBox -37.52950 51.08250 239.92250 167.12800
zoomBox 6.78200 100.97300 151.61400 161.54950
zoomBox -22.90200 69.70000 212.93200 168.33850
saveDesign dlx_routed.enc
zoomBox 30.82350 114.13800 135.46550 157.90500
zoomBox -24.46550 68.94900 211.37100 167.58850
zoomBox -74.35650 35.59250 252.06050 172.11750
pan -12.69400 72.38500
zoomBox -87.05050 -26.06450 296.96950 134.55350
pan -28.04000 79.88300
win
reset_parasitics
extractRC
rcOut -setload dlx_processor.setload -rc_corner standard
rcOut -setres dlx_processor.setres -rc_corner standard
rcOut -spf dlx_processor.spf -rc_corner standard
rcOut -spef dlx_processor.spef -rc_corner standard
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix dlx_processor_postRoute -outDir timingReports
getAnalysisMode -checkType
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 50 -prefix dlx_processor_postRoute -outDir timingReports
getAnalysisMode -checkType
reportGateCount -level 5 -limit 100 -outfile dlx_processor.gateCount
summaryReport -noHtml -outfile summaryReport.rpt
all_hold_analysis_views 
all_setup_analysis_views 
write_sdf  -ideal_clock_network dlx_processor.sdf
zoomBox -68.32050 31.06000 209.13450 147.10650
zoomBox -32.45150 58.25200 168.01050 142.09600
zoomBox -53.48050 45.78650 182.35750 144.42650
zoomBox -77.65900 31.71500 199.79750 147.76250
pan 0.88050 121.04500
zoomBox -53.75650 58.31500 182.08200 156.95550
zoomBox -34.18800 71.00550 166.27500 154.85000
zoomBox -3.41600 90.96100 141.41850 151.53850
zoomBox -17.55500 81.79200 152.83900 153.06000
