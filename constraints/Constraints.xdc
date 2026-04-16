# -------------------------------------------------------------------------
# 1. Configuration & Voltage
# -------------------------------------------------------------------------
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]

# -------------------------------------------------------------------------
# 2. Clocking (Differential 200MHz - KC705)
# -------------------------------------------------------------------------
set_property PACKAGE_PIN AD12 [get_ports iCLK_p]
set_property PACKAGE_PIN AD11 [get_ports iCLK_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports iCLK_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports iCLK_n]

#create_clock -period 5.000 -name sys_clk [get_ports iCLK_p]

# -------------------------------------------------------------------------
# 3. Pushbuttons (HIT and RESET)
# -------------------------------------------------------------------------
# Center Pushbutton (GPIO_SW_C) for HIT
#set_property PACKAGE_PIN R19 [get_ports iHIT]
#set_property IOSTANDARD LVCMOS25 [get_ports iHIT]

# Center Pushbutton (GPIO_SW_C) for HIT
#set_property PACKAGE_PIN G12 [get_ports iHIT]
#set_property IOSTANDARD LVCMOS25 [get_ports iHIT]
set_property PACKAGE_PIN L25 [get_ports iHIT_P]   ;# USER_SMA_CLOCK_P
set_property PACKAGE_PIN K25 [get_ports iHIT_N]   ;# USER_SMA_CLOCK_N
set_property IOSTANDARD LVDS_25 [get_ports {iHIT_P iHIT_N}]
# South Pushbutton (GPIO_SW_S) for RST
set_property PACKAGE_PIN AB7 [get_ports iRST]
set_property IOSTANDARD LVCMOS15 [get_ports iRST]


set_property PACKAGE_PIN K24 [get_ports oUART_TXD]
set_property IOSTANDARD LVCMOS25 [get_ports oUART_TXD]
# -------------------------------------------------------------------------
# 4. IDELAY & IDELAYCTRL Grouping (Fixes [DRC PLIDC-10])
# -------------------------------------------------------------------------
set_property IODELAY_GROUP tdc_delay_grp [get_cells u_tdc/u_idelay_hit]
set_property IODELAY_GROUP tdc_delay_grp [get_cells u_tdc/u_idelayctrl]
# -------------------------------------------------------------------------
# 5. TDC Placement (Column X20)
# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
# TDC Carry Chain and Sampling FF Placement Constraints
# KC705 Kintex-7 - Column X20, Y150 to Y249 (clock region X0Y3)
# 100 CARRY4 blocks, 4 sampling FFs co-located in same slice as CARRY4
# Entire chain within single clock region - no boundary crossing
# -------------------------------------------------------------------------
# 5. Edge detector placement - column X12, below delay chain
# -------------------------------------------------------------------------

# Edge detectors near start of delay chain (chain starts at X20Y150)
set_property LOC SLICE_X21Y150 [get_cells {u_tdc/rCoarseEdgeDet_reg[0]}]
set_property LOC SLICE_X21Y150 [get_cells {u_tdc/rCoarseEdgeDet_reg[1]}]

set_property LOC SLICE_X21Y151 [get_cells {u_tdc/rArb1EdgeDet_reg[0]}]
set_property LOC SLICE_X21Y151 [get_cells {u_tdc/rArb1EdgeDet_reg[1]}]

set_property LOC SLICE_X21Y152 [get_cells {u_tdc/rArb2EdgeDet_reg[0]}]
set_property LOC SLICE_X21Y152 [get_cells {u_tdc/rArb2EdgeDet_reg[1]}]
# -------------------------------------------------------------------------
# Each clock domain gets its own slice
# CLK0 coarse edge detector

# CARRY4 block 0 - taps 0 to 3
set_property LOC SLICE_X20Y150 [get_cells {u_tdc/fine_inst/generate_block[0].carry4_1}]
set_property LOC SLICE_X20Y150 [get_cells {u_tdc/fine_inst/stage1[0].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[0].rTDCVALUE}]
set_property LOC SLICE_X20Y150 [get_cells {u_tdc/fine_inst/stage1[1].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[1].rTDCVALUE}]
set_property LOC SLICE_X20Y150 [get_cells {u_tdc/fine_inst/stage1[2].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[2].rTDCVALUE}]
set_property LOC SLICE_X20Y150 [get_cells {u_tdc/fine_inst/stage1[3].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[3].rTDCVALUE}]

# CARRY4 block 1 - taps 4 to 7
set_property LOC SLICE_X20Y151 [get_cells {u_tdc/fine_inst/generate_block[1].carry4_1}]
set_property LOC SLICE_X20Y151 [get_cells {u_tdc/fine_inst/stage1[4].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[4].rTDCVALUE}]
set_property LOC SLICE_X20Y151 [get_cells {u_tdc/fine_inst/stage1[5].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[5].rTDCVALUE}]
set_property LOC SLICE_X20Y151 [get_cells {u_tdc/fine_inst/stage1[6].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[6].rTDCVALUE}]
set_property LOC SLICE_X20Y151 [get_cells {u_tdc/fine_inst/stage1[7].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[7].rTDCVALUE}]

# CARRY4 block 2 - taps 8 to 11
set_property LOC SLICE_X20Y152 [get_cells {u_tdc/fine_inst/generate_block[2].carry4_1}]
set_property LOC SLICE_X20Y152 [get_cells {u_tdc/fine_inst/stage1[8].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[8].rTDCVALUE}]
set_property LOC SLICE_X20Y152 [get_cells {u_tdc/fine_inst/stage1[9].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[9].rTDCVALUE}]
set_property LOC SLICE_X20Y152 [get_cells {u_tdc/fine_inst/stage1[10].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[10].rTDCVALUE}]
set_property LOC SLICE_X20Y152 [get_cells {u_tdc/fine_inst/stage1[11].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[11].rTDCVALUE}]

# CARRY4 block 3 - taps 12 to 15
set_property LOC SLICE_X20Y153 [get_cells {u_tdc/fine_inst/generate_block[3].carry4_1}]
set_property LOC SLICE_X20Y153 [get_cells {u_tdc/fine_inst/stage1[12].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[12].rTDCVALUE}]
set_property LOC SLICE_X20Y153 [get_cells {u_tdc/fine_inst/stage1[13].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[13].rTDCVALUE}]
set_property LOC SLICE_X20Y153 [get_cells {u_tdc/fine_inst/stage1[14].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[14].rTDCVALUE}]
set_property LOC SLICE_X20Y153 [get_cells {u_tdc/fine_inst/stage1[15].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[15].rTDCVALUE}]

# CARRY4 block 4 - taps 16 to 19
set_property LOC SLICE_X20Y154 [get_cells {u_tdc/fine_inst/generate_block[4].carry4_1}]
set_property LOC SLICE_X20Y154 [get_cells {u_tdc/fine_inst/stage1[16].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[16].rTDCVALUE}]
set_property LOC SLICE_X20Y154 [get_cells {u_tdc/fine_inst/stage1[17].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[17].rTDCVALUE}]
set_property LOC SLICE_X20Y154 [get_cells {u_tdc/fine_inst/stage1[18].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[18].rTDCVALUE}]
set_property LOC SLICE_X20Y154 [get_cells {u_tdc/fine_inst/stage1[19].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[19].rTDCVALUE}]

# CARRY4 block 5 - taps 20 to 23
set_property LOC SLICE_X20Y155 [get_cells {u_tdc/fine_inst/generate_block[5].carry4_1}]
set_property LOC SLICE_X20Y155 [get_cells {u_tdc/fine_inst/stage1[20].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[20].rTDCVALUE}]
set_property LOC SLICE_X20Y155 [get_cells {u_tdc/fine_inst/stage1[21].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[21].rTDCVALUE}]
set_property LOC SLICE_X20Y155 [get_cells {u_tdc/fine_inst/stage1[22].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[22].rTDCVALUE}]
set_property LOC SLICE_X20Y155 [get_cells {u_tdc/fine_inst/stage1[23].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[23].rTDCVALUE}]

# CARRY4 block 6 - taps 24 to 27
set_property LOC SLICE_X20Y156 [get_cells {u_tdc/fine_inst/generate_block[6].carry4_1}]
set_property LOC SLICE_X20Y156 [get_cells {u_tdc/fine_inst/stage1[24].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[24].rTDCVALUE}]
set_property LOC SLICE_X20Y156 [get_cells {u_tdc/fine_inst/stage1[25].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[25].rTDCVALUE}]
set_property LOC SLICE_X20Y156 [get_cells {u_tdc/fine_inst/stage1[26].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[26].rTDCVALUE}]
set_property LOC SLICE_X20Y156 [get_cells {u_tdc/fine_inst/stage1[27].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[27].rTDCVALUE}]

# CARRY4 block 7 - taps 28 to 31
set_property LOC SLICE_X20Y157 [get_cells {u_tdc/fine_inst/generate_block[7].carry4_1}]
set_property LOC SLICE_X20Y157 [get_cells {u_tdc/fine_inst/stage1[28].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[28].rTDCVALUE}]
set_property LOC SLICE_X20Y157 [get_cells {u_tdc/fine_inst/stage1[29].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[29].rTDCVALUE}]
set_property LOC SLICE_X20Y157 [get_cells {u_tdc/fine_inst/stage1[30].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[30].rTDCVALUE}]
set_property LOC SLICE_X20Y157 [get_cells {u_tdc/fine_inst/stage1[31].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[31].rTDCVALUE}]

# CARRY4 block 8 - taps 32 to 35
set_property LOC SLICE_X20Y158 [get_cells {u_tdc/fine_inst/generate_block[8].carry4_1}]
set_property LOC SLICE_X20Y158 [get_cells {u_tdc/fine_inst/stage1[32].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[32].rTDCVALUE}]
set_property LOC SLICE_X20Y158 [get_cells {u_tdc/fine_inst/stage1[33].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[33].rTDCVALUE}]
set_property LOC SLICE_X20Y158 [get_cells {u_tdc/fine_inst/stage1[34].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[34].rTDCVALUE}]
set_property LOC SLICE_X20Y158 [get_cells {u_tdc/fine_inst/stage1[35].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[35].rTDCVALUE}]

# CARRY4 block 9 - taps 36 to 39
set_property LOC SLICE_X20Y159 [get_cells {u_tdc/fine_inst/generate_block[9].carry4_1}]
set_property LOC SLICE_X20Y159 [get_cells {u_tdc/fine_inst/stage1[36].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[36].rTDCVALUE}]
set_property LOC SLICE_X20Y159 [get_cells {u_tdc/fine_inst/stage1[37].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[37].rTDCVALUE}]
set_property LOC SLICE_X20Y159 [get_cells {u_tdc/fine_inst/stage1[38].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[38].rTDCVALUE}]
set_property LOC SLICE_X20Y159 [get_cells {u_tdc/fine_inst/stage1[39].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[39].rTDCVALUE}]

# CARRY4 block 10 - taps 40 to 43
set_property LOC SLICE_X20Y160 [get_cells {u_tdc/fine_inst/generate_block[10].carry4_1}]
set_property LOC SLICE_X20Y160 [get_cells {u_tdc/fine_inst/stage1[40].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[40].rTDCVALUE}]
set_property LOC SLICE_X20Y160 [get_cells {u_tdc/fine_inst/stage1[41].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[41].rTDCVALUE}]
set_property LOC SLICE_X20Y160 [get_cells {u_tdc/fine_inst/stage1[42].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[42].rTDCVALUE}]
set_property LOC SLICE_X20Y160 [get_cells {u_tdc/fine_inst/stage1[43].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[43].rTDCVALUE}]

# CARRY4 block 11 - taps 44 to 47
set_property LOC SLICE_X20Y161 [get_cells {u_tdc/fine_inst/generate_block[11].carry4_1}]
set_property LOC SLICE_X20Y161 [get_cells {u_tdc/fine_inst/stage1[44].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[44].rTDCVALUE}]
set_property LOC SLICE_X20Y161 [get_cells {u_tdc/fine_inst/stage1[45].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[45].rTDCVALUE}]
set_property LOC SLICE_X20Y161 [get_cells {u_tdc/fine_inst/stage1[46].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[46].rTDCVALUE}]
set_property LOC SLICE_X20Y161 [get_cells {u_tdc/fine_inst/stage1[47].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[47].rTDCVALUE}]

# CARRY4 block 12 - taps 48 to 51
set_property LOC SLICE_X20Y162 [get_cells {u_tdc/fine_inst/generate_block[12].carry4_1}]
set_property LOC SLICE_X20Y162 [get_cells {u_tdc/fine_inst/stage1[48].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[48].rTDCVALUE}]
set_property LOC SLICE_X20Y162 [get_cells {u_tdc/fine_inst/stage1[49].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[49].rTDCVALUE}]
set_property LOC SLICE_X20Y162 [get_cells {u_tdc/fine_inst/stage1[50].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[50].rTDCVALUE}]
set_property LOC SLICE_X20Y162 [get_cells {u_tdc/fine_inst/stage1[51].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[51].rTDCVALUE}]

# CARRY4 block 13 - taps 52 to 55
set_property LOC SLICE_X20Y163 [get_cells {u_tdc/fine_inst/generate_block[13].carry4_1}]
set_property LOC SLICE_X20Y163 [get_cells {u_tdc/fine_inst/stage1[52].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[52].rTDCVALUE}]
set_property LOC SLICE_X20Y163 [get_cells {u_tdc/fine_inst/stage1[53].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[53].rTDCVALUE}]
set_property LOC SLICE_X20Y163 [get_cells {u_tdc/fine_inst/stage1[54].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[54].rTDCVALUE}]
set_property LOC SLICE_X20Y163 [get_cells {u_tdc/fine_inst/stage1[55].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[55].rTDCVALUE}]

# CARRY4 block 14 - taps 56 to 59
set_property LOC SLICE_X20Y164 [get_cells {u_tdc/fine_inst/generate_block[14].carry4_1}]
set_property LOC SLICE_X20Y164 [get_cells {u_tdc/fine_inst/stage1[56].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[56].rTDCVALUE}]
set_property LOC SLICE_X20Y164 [get_cells {u_tdc/fine_inst/stage1[57].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[57].rTDCVALUE}]
set_property LOC SLICE_X20Y164 [get_cells {u_tdc/fine_inst/stage1[58].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[58].rTDCVALUE}]
set_property LOC SLICE_X20Y164 [get_cells {u_tdc/fine_inst/stage1[59].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[59].rTDCVALUE}]

# CARRY4 block 15 - taps 60 to 63
set_property LOC SLICE_X20Y165 [get_cells {u_tdc/fine_inst/generate_block[15].carry4_1}]
set_property LOC SLICE_X20Y165 [get_cells {u_tdc/fine_inst/stage1[60].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[60].rTDCVALUE}]
set_property LOC SLICE_X20Y165 [get_cells {u_tdc/fine_inst/stage1[61].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[61].rTDCVALUE}]
set_property LOC SLICE_X20Y165 [get_cells {u_tdc/fine_inst/stage1[62].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[62].rTDCVALUE}]
set_property LOC SLICE_X20Y165 [get_cells {u_tdc/fine_inst/stage1[63].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[63].rTDCVALUE}]

# CARRY4 block 16 - taps 64 to 67
set_property LOC SLICE_X20Y166 [get_cells {u_tdc/fine_inst/generate_block[16].carry4_1}]
set_property LOC SLICE_X20Y166 [get_cells {u_tdc/fine_inst/stage1[64].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[64].rTDCVALUE}]
set_property LOC SLICE_X20Y166 [get_cells {u_tdc/fine_inst/stage1[65].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[65].rTDCVALUE}]
set_property LOC SLICE_X20Y166 [get_cells {u_tdc/fine_inst/stage1[66].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[66].rTDCVALUE}]
set_property LOC SLICE_X20Y166 [get_cells {u_tdc/fine_inst/stage1[67].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[67].rTDCVALUE}]

# CARRY4 block 17 - taps 68 to 71
set_property LOC SLICE_X20Y167 [get_cells {u_tdc/fine_inst/generate_block[17].carry4_1}]
set_property LOC SLICE_X20Y167 [get_cells {u_tdc/fine_inst/stage1[68].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[68].rTDCVALUE}]
set_property LOC SLICE_X20Y167 [get_cells {u_tdc/fine_inst/stage1[69].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[69].rTDCVALUE}]
set_property LOC SLICE_X20Y167 [get_cells {u_tdc/fine_inst/stage1[70].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[70].rTDCVALUE}]
set_property LOC SLICE_X20Y167 [get_cells {u_tdc/fine_inst/stage1[71].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[71].rTDCVALUE}]

# CARRY4 block 18 - taps 72 to 75
set_property LOC SLICE_X20Y168 [get_cells {u_tdc/fine_inst/generate_block[18].carry4_1}]
set_property LOC SLICE_X20Y168 [get_cells {u_tdc/fine_inst/stage1[72].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[72].rTDCVALUE}]
set_property LOC SLICE_X20Y168 [get_cells {u_tdc/fine_inst/stage1[73].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[73].rTDCVALUE}]
set_property LOC SLICE_X20Y168 [get_cells {u_tdc/fine_inst/stage1[74].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[74].rTDCVALUE}]
set_property LOC SLICE_X20Y168 [get_cells {u_tdc/fine_inst/stage1[75].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[75].rTDCVALUE}]

# CARRY4 block 19 - taps 76 to 79
set_property LOC SLICE_X20Y169 [get_cells {u_tdc/fine_inst/generate_block[19].carry4_1}]
set_property LOC SLICE_X20Y169 [get_cells {u_tdc/fine_inst/stage1[76].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[76].rTDCVALUE}]
set_property LOC SLICE_X20Y169 [get_cells {u_tdc/fine_inst/stage1[77].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[77].rTDCVALUE}]
set_property LOC SLICE_X20Y169 [get_cells {u_tdc/fine_inst/stage1[78].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[78].rTDCVALUE}]
set_property LOC SLICE_X20Y169 [get_cells {u_tdc/fine_inst/stage1[79].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[79].rTDCVALUE}]

# CARRY4 block 20 - taps 80 to 83
set_property LOC SLICE_X20Y170 [get_cells {u_tdc/fine_inst/generate_block[20].carry4_1}]
set_property LOC SLICE_X20Y170 [get_cells {u_tdc/fine_inst/stage1[80].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[80].rTDCVALUE}]
set_property LOC SLICE_X20Y170 [get_cells {u_tdc/fine_inst/stage1[81].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[81].rTDCVALUE}]
set_property LOC SLICE_X20Y170 [get_cells {u_tdc/fine_inst/stage1[82].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[82].rTDCVALUE}]
set_property LOC SLICE_X20Y170 [get_cells {u_tdc/fine_inst/stage1[83].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[83].rTDCVALUE}]

# CARRY4 block 21 - taps 84 to 87
set_property LOC SLICE_X20Y171 [get_cells {u_tdc/fine_inst/generate_block[21].carry4_1}]
set_property LOC SLICE_X20Y171 [get_cells {u_tdc/fine_inst/stage1[84].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[84].rTDCVALUE}]
set_property LOC SLICE_X20Y171 [get_cells {u_tdc/fine_inst/stage1[85].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[85].rTDCVALUE}]
set_property LOC SLICE_X20Y171 [get_cells {u_tdc/fine_inst/stage1[86].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[86].rTDCVALUE}]
set_property LOC SLICE_X20Y171 [get_cells {u_tdc/fine_inst/stage1[87].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[87].rTDCVALUE}]

# CARRY4 block 22 - taps 88 to 91
set_property LOC SLICE_X20Y172 [get_cells {u_tdc/fine_inst/generate_block[22].carry4_1}]
set_property LOC SLICE_X20Y172 [get_cells {u_tdc/fine_inst/stage1[88].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[88].rTDCVALUE}]
set_property LOC SLICE_X20Y172 [get_cells {u_tdc/fine_inst/stage1[89].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[89].rTDCVALUE}]
set_property LOC SLICE_X20Y172 [get_cells {u_tdc/fine_inst/stage1[90].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[90].rTDCVALUE}]
set_property LOC SLICE_X20Y172 [get_cells {u_tdc/fine_inst/stage1[91].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[91].rTDCVALUE}]

# CARRY4 block 23 - taps 92 to 95
set_property LOC SLICE_X20Y173 [get_cells {u_tdc/fine_inst/generate_block[23].carry4_1}]
set_property LOC SLICE_X20Y173 [get_cells {u_tdc/fine_inst/stage1[92].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[92].rTDCVALUE}]
set_property LOC SLICE_X20Y173 [get_cells {u_tdc/fine_inst/stage1[93].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[93].rTDCVALUE}]
set_property LOC SLICE_X20Y173 [get_cells {u_tdc/fine_inst/stage1[94].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[94].rTDCVALUE}]
set_property LOC SLICE_X20Y173 [get_cells {u_tdc/fine_inst/stage1[95].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[95].rTDCVALUE}]

# CARRY4 block 24 - taps 96 to 99
set_property LOC SLICE_X20Y174 [get_cells {u_tdc/fine_inst/generate_block[24].carry4_1}]
set_property LOC SLICE_X20Y174 [get_cells {u_tdc/fine_inst/stage1[96].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[96].rTDCVALUE}]
set_property LOC SLICE_X20Y174 [get_cells {u_tdc/fine_inst/stage1[97].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[97].rTDCVALUE}]
set_property LOC SLICE_X20Y174 [get_cells {u_tdc/fine_inst/stage1[98].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[98].rTDCVALUE}]
set_property LOC SLICE_X20Y174 [get_cells {u_tdc/fine_inst/stage1[99].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[99].rTDCVALUE}]

# CARRY4 block 25 - taps 100 to 103
set_property LOC SLICE_X20Y175 [get_cells {u_tdc/fine_inst/generate_block[25].carry4_1}]
set_property LOC SLICE_X20Y175 [get_cells {u_tdc/fine_inst/stage1[100].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[100].rTDCVALUE}]
set_property LOC SLICE_X20Y175 [get_cells {u_tdc/fine_inst/stage1[101].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[101].rTDCVALUE}]
set_property LOC SLICE_X20Y175 [get_cells {u_tdc/fine_inst/stage1[102].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[102].rTDCVALUE}]
set_property LOC SLICE_X20Y175 [get_cells {u_tdc/fine_inst/stage1[103].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[103].rTDCVALUE}]

# CARRY4 block 26 - taps 104 to 107
set_property LOC SLICE_X20Y176 [get_cells {u_tdc/fine_inst/generate_block[26].carry4_1}]
set_property LOC SLICE_X20Y176 [get_cells {u_tdc/fine_inst/stage1[104].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[104].rTDCVALUE}]
set_property LOC SLICE_X20Y176 [get_cells {u_tdc/fine_inst/stage1[105].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[105].rTDCVALUE}]
set_property LOC SLICE_X20Y176 [get_cells {u_tdc/fine_inst/stage1[106].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[106].rTDCVALUE}]
set_property LOC SLICE_X20Y176 [get_cells {u_tdc/fine_inst/stage1[107].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[107].rTDCVALUE}]

# CARRY4 block 27 - taps 108 to 111
set_property LOC SLICE_X20Y177 [get_cells {u_tdc/fine_inst/generate_block[27].carry4_1}]
set_property LOC SLICE_X20Y177 [get_cells {u_tdc/fine_inst/stage1[108].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[108].rTDCVALUE}]
set_property LOC SLICE_X20Y177 [get_cells {u_tdc/fine_inst/stage1[109].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[109].rTDCVALUE}]
set_property LOC SLICE_X20Y177 [get_cells {u_tdc/fine_inst/stage1[110].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[110].rTDCVALUE}]
set_property LOC SLICE_X20Y177 [get_cells {u_tdc/fine_inst/stage1[111].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[111].rTDCVALUE}]

# CARRY4 block 28 - taps 112 to 115
set_property LOC SLICE_X20Y178 [get_cells {u_tdc/fine_inst/generate_block[28].carry4_1}]
set_property LOC SLICE_X20Y178 [get_cells {u_tdc/fine_inst/stage1[112].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[112].rTDCVALUE}]
set_property LOC SLICE_X20Y178 [get_cells {u_tdc/fine_inst/stage1[113].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[113].rTDCVALUE}]
set_property LOC SLICE_X20Y178 [get_cells {u_tdc/fine_inst/stage1[114].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[114].rTDCVALUE}]
set_property LOC SLICE_X20Y178 [get_cells {u_tdc/fine_inst/stage1[115].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[115].rTDCVALUE}]

# CARRY4 block 29 - taps 116 to 119
set_property LOC SLICE_X20Y179 [get_cells {u_tdc/fine_inst/generate_block[29].carry4_1}]
set_property LOC SLICE_X20Y179 [get_cells {u_tdc/fine_inst/stage1[116].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[116].rTDCVALUE}]
set_property LOC SLICE_X20Y179 [get_cells {u_tdc/fine_inst/stage1[117].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[117].rTDCVALUE}]
set_property LOC SLICE_X20Y179 [get_cells {u_tdc/fine_inst/stage1[118].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[118].rTDCVALUE}]
set_property LOC SLICE_X20Y179 [get_cells {u_tdc/fine_inst/stage1[119].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[119].rTDCVALUE}]

# CARRY4 block 30 - taps 120 to 123
set_property LOC SLICE_X20Y180 [get_cells {u_tdc/fine_inst/generate_block[30].carry4_1}]
set_property LOC SLICE_X20Y180 [get_cells {u_tdc/fine_inst/stage1[120].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[120].rTDCVALUE}]
set_property LOC SLICE_X20Y180 [get_cells {u_tdc/fine_inst/stage1[121].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[121].rTDCVALUE}]
set_property LOC SLICE_X20Y180 [get_cells {u_tdc/fine_inst/stage1[122].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[122].rTDCVALUE}]
set_property LOC SLICE_X20Y180 [get_cells {u_tdc/fine_inst/stage1[123].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[123].rTDCVALUE}]

# CARRY4 block 31 - taps 124 to 127
set_property LOC SLICE_X20Y181 [get_cells {u_tdc/fine_inst/generate_block[31].carry4_1}]
set_property LOC SLICE_X20Y181 [get_cells {u_tdc/fine_inst/stage1[124].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[124].rTDCVALUE}]
set_property LOC SLICE_X20Y181 [get_cells {u_tdc/fine_inst/stage1[125].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[125].rTDCVALUE}]
set_property LOC SLICE_X20Y181 [get_cells {u_tdc/fine_inst/stage1[126].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[126].rTDCVALUE}]
set_property LOC SLICE_X20Y181 [get_cells {u_tdc/fine_inst/stage1[127].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[127].rTDCVALUE}]

# CARRY4 block 32 - taps 128 to 131
set_property LOC SLICE_X20Y182 [get_cells {u_tdc/fine_inst/generate_block[32].carry4_1}]
set_property LOC SLICE_X20Y182 [get_cells {u_tdc/fine_inst/stage1[128].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[128].rTDCVALUE}]
set_property LOC SLICE_X20Y182 [get_cells {u_tdc/fine_inst/stage1[129].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[129].rTDCVALUE}]
set_property LOC SLICE_X20Y182 [get_cells {u_tdc/fine_inst/stage1[130].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[130].rTDCVALUE}]
set_property LOC SLICE_X20Y182 [get_cells {u_tdc/fine_inst/stage1[131].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[131].rTDCVALUE}]

# CARRY4 block 33 - taps 132 to 135
set_property LOC SLICE_X20Y183 [get_cells {u_tdc/fine_inst/generate_block[33].carry4_1}]
set_property LOC SLICE_X20Y183 [get_cells {u_tdc/fine_inst/stage1[132].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[132].rTDCVALUE}]
set_property LOC SLICE_X20Y183 [get_cells {u_tdc/fine_inst/stage1[133].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[133].rTDCVALUE}]
set_property LOC SLICE_X20Y183 [get_cells {u_tdc/fine_inst/stage1[134].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[134].rTDCVALUE}]
set_property LOC SLICE_X20Y183 [get_cells {u_tdc/fine_inst/stage1[135].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[135].rTDCVALUE}]

# CARRY4 block 34 - taps 136 to 139
set_property LOC SLICE_X20Y184 [get_cells {u_tdc/fine_inst/generate_block[34].carry4_1}]
set_property LOC SLICE_X20Y184 [get_cells {u_tdc/fine_inst/stage1[136].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[136].rTDCVALUE}]
set_property LOC SLICE_X20Y184 [get_cells {u_tdc/fine_inst/stage1[137].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[137].rTDCVALUE}]
set_property LOC SLICE_X20Y184 [get_cells {u_tdc/fine_inst/stage1[138].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[138].rTDCVALUE}]
set_property LOC SLICE_X20Y184 [get_cells {u_tdc/fine_inst/stage1[139].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[139].rTDCVALUE}]

# CARRY4 block 35 - taps 140 to 143
set_property LOC SLICE_X20Y185 [get_cells {u_tdc/fine_inst/generate_block[35].carry4_1}]
set_property LOC SLICE_X20Y185 [get_cells {u_tdc/fine_inst/stage1[140].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[140].rTDCVALUE}]
set_property LOC SLICE_X20Y185 [get_cells {u_tdc/fine_inst/stage1[141].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[141].rTDCVALUE}]
set_property LOC SLICE_X20Y185 [get_cells {u_tdc/fine_inst/stage1[142].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[142].rTDCVALUE}]
set_property LOC SLICE_X20Y185 [get_cells {u_tdc/fine_inst/stage1[143].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[143].rTDCVALUE}]

# CARRY4 block 36 - taps 144 to 147
set_property LOC SLICE_X20Y186 [get_cells {u_tdc/fine_inst/generate_block[36].carry4_1}]
set_property LOC SLICE_X20Y186 [get_cells {u_tdc/fine_inst/stage1[144].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[144].rTDCVALUE}]
set_property LOC SLICE_X20Y186 [get_cells {u_tdc/fine_inst/stage1[145].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[145].rTDCVALUE}]
set_property LOC SLICE_X20Y186 [get_cells {u_tdc/fine_inst/stage1[146].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[146].rTDCVALUE}]
set_property LOC SLICE_X20Y186 [get_cells {u_tdc/fine_inst/stage1[147].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[147].rTDCVALUE}]

# CARRY4 block 37 - taps 148 to 151
set_property LOC SLICE_X20Y187 [get_cells {u_tdc/fine_inst/generate_block[37].carry4_1}]
set_property LOC SLICE_X20Y187 [get_cells {u_tdc/fine_inst/stage1[148].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[148].rTDCVALUE}]
set_property LOC SLICE_X20Y187 [get_cells {u_tdc/fine_inst/stage1[149].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[149].rTDCVALUE}]
set_property LOC SLICE_X20Y187 [get_cells {u_tdc/fine_inst/stage1[150].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[150].rTDCVALUE}]
set_property LOC SLICE_X20Y187 [get_cells {u_tdc/fine_inst/stage1[151].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[151].rTDCVALUE}]

# CARRY4 block 38 - taps 152 to 155
set_property LOC SLICE_X20Y188 [get_cells {u_tdc/fine_inst/generate_block[38].carry4_1}]
set_property LOC SLICE_X20Y188 [get_cells {u_tdc/fine_inst/stage1[152].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[152].rTDCVALUE}]
set_property LOC SLICE_X20Y188 [get_cells {u_tdc/fine_inst/stage1[153].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[153].rTDCVALUE}]
set_property LOC SLICE_X20Y188 [get_cells {u_tdc/fine_inst/stage1[154].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[154].rTDCVALUE}]
set_property LOC SLICE_X20Y188 [get_cells {u_tdc/fine_inst/stage1[155].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[155].rTDCVALUE}]

# CARRY4 block 39 - taps 156 to 159
set_property LOC SLICE_X20Y189 [get_cells {u_tdc/fine_inst/generate_block[39].carry4_1}]
set_property LOC SLICE_X20Y189 [get_cells {u_tdc/fine_inst/stage1[156].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[156].rTDCVALUE}]
set_property LOC SLICE_X20Y189 [get_cells {u_tdc/fine_inst/stage1[157].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[157].rTDCVALUE}]
set_property LOC SLICE_X20Y189 [get_cells {u_tdc/fine_inst/stage1[158].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[158].rTDCVALUE}]
set_property LOC SLICE_X20Y189 [get_cells {u_tdc/fine_inst/stage1[159].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[159].rTDCVALUE}]

# CARRY4 block 40 - taps 160 to 163
set_property LOC SLICE_X20Y190 [get_cells {u_tdc/fine_inst/generate_block[40].carry4_1}]
set_property LOC SLICE_X20Y190 [get_cells {u_tdc/fine_inst/stage1[160].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[160].rTDCVALUE}]
set_property LOC SLICE_X20Y190 [get_cells {u_tdc/fine_inst/stage1[161].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[161].rTDCVALUE}]
set_property LOC SLICE_X20Y190 [get_cells {u_tdc/fine_inst/stage1[162].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[162].rTDCVALUE}]
set_property LOC SLICE_X20Y190 [get_cells {u_tdc/fine_inst/stage1[163].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[163].rTDCVALUE}]

# CARRY4 block 41 - taps 164 to 167
set_property LOC SLICE_X20Y191 [get_cells {u_tdc/fine_inst/generate_block[41].carry4_1}]
set_property LOC SLICE_X20Y191 [get_cells {u_tdc/fine_inst/stage1[164].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[164].rTDCVALUE}]
set_property LOC SLICE_X20Y191 [get_cells {u_tdc/fine_inst/stage1[165].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[165].rTDCVALUE}]
set_property LOC SLICE_X20Y191 [get_cells {u_tdc/fine_inst/stage1[166].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[166].rTDCVALUE}]
set_property LOC SLICE_X20Y191 [get_cells {u_tdc/fine_inst/stage1[167].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[167].rTDCVALUE}]

# CARRY4 block 42 - taps 168 to 171
set_property LOC SLICE_X20Y192 [get_cells {u_tdc/fine_inst/generate_block[42].carry4_1}]
set_property LOC SLICE_X20Y192 [get_cells {u_tdc/fine_inst/stage1[168].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[168].rTDCVALUE}]
set_property LOC SLICE_X20Y192 [get_cells {u_tdc/fine_inst/stage1[169].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[169].rTDCVALUE}]
set_property LOC SLICE_X20Y192 [get_cells {u_tdc/fine_inst/stage1[170].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[170].rTDCVALUE}]
set_property LOC SLICE_X20Y192 [get_cells {u_tdc/fine_inst/stage1[171].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[171].rTDCVALUE}]

# CARRY4 block 43 - taps 172 to 175
set_property LOC SLICE_X20Y193 [get_cells {u_tdc/fine_inst/generate_block[43].carry4_1}]
set_property LOC SLICE_X20Y193 [get_cells {u_tdc/fine_inst/stage1[172].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[172].rTDCVALUE}]
set_property LOC SLICE_X20Y193 [get_cells {u_tdc/fine_inst/stage1[173].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[173].rTDCVALUE}]
set_property LOC SLICE_X20Y193 [get_cells {u_tdc/fine_inst/stage1[174].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[174].rTDCVALUE}]
set_property LOC SLICE_X20Y193 [get_cells {u_tdc/fine_inst/stage1[175].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[175].rTDCVALUE}]

# CARRY4 block 44 - taps 176 to 179
set_property LOC SLICE_X20Y194 [get_cells {u_tdc/fine_inst/generate_block[44].carry4_1}]
set_property LOC SLICE_X20Y194 [get_cells {u_tdc/fine_inst/stage1[176].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[176].rTDCVALUE}]
set_property LOC SLICE_X20Y194 [get_cells {u_tdc/fine_inst/stage1[177].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[177].rTDCVALUE}]
set_property LOC SLICE_X20Y194 [get_cells {u_tdc/fine_inst/stage1[178].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[178].rTDCVALUE}]
set_property LOC SLICE_X20Y194 [get_cells {u_tdc/fine_inst/stage1[179].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[179].rTDCVALUE}]

# CARRY4 block 45 - taps 180 to 183
set_property LOC SLICE_X20Y195 [get_cells {u_tdc/fine_inst/generate_block[45].carry4_1}]
set_property LOC SLICE_X20Y195 [get_cells {u_tdc/fine_inst/stage1[180].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[180].rTDCVALUE}]
set_property LOC SLICE_X20Y195 [get_cells {u_tdc/fine_inst/stage1[181].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[181].rTDCVALUE}]
set_property LOC SLICE_X20Y195 [get_cells {u_tdc/fine_inst/stage1[182].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[182].rTDCVALUE}]
set_property LOC SLICE_X20Y195 [get_cells {u_tdc/fine_inst/stage1[183].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[183].rTDCVALUE}]

# CARRY4 block 46 - taps 184 to 187
set_property LOC SLICE_X20Y196 [get_cells {u_tdc/fine_inst/generate_block[46].carry4_1}]
set_property LOC SLICE_X20Y196 [get_cells {u_tdc/fine_inst/stage1[184].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[184].rTDCVALUE}]
set_property LOC SLICE_X20Y196 [get_cells {u_tdc/fine_inst/stage1[185].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[185].rTDCVALUE}]
set_property LOC SLICE_X20Y196 [get_cells {u_tdc/fine_inst/stage1[186].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[186].rTDCVALUE}]
set_property LOC SLICE_X20Y196 [get_cells {u_tdc/fine_inst/stage1[187].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[187].rTDCVALUE}]

# CARRY4 block 47 - taps 188 to 191
set_property LOC SLICE_X20Y197 [get_cells {u_tdc/fine_inst/generate_block[47].carry4_1}]
set_property LOC SLICE_X20Y197 [get_cells {u_tdc/fine_inst/stage1[188].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[188].rTDCVALUE}]
set_property LOC SLICE_X20Y197 [get_cells {u_tdc/fine_inst/stage1[189].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[189].rTDCVALUE}]
set_property LOC SLICE_X20Y197 [get_cells {u_tdc/fine_inst/stage1[190].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[190].rTDCVALUE}]
set_property LOC SLICE_X20Y197 [get_cells {u_tdc/fine_inst/stage1[191].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[191].rTDCVALUE}]

# CARRY4 block 48 - taps 192 to 195
set_property LOC SLICE_X20Y198 [get_cells {u_tdc/fine_inst/generate_block[48].carry4_1}]
set_property LOC SLICE_X20Y198 [get_cells {u_tdc/fine_inst/stage1[192].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[192].rTDCVALUE}]
set_property LOC SLICE_X20Y198 [get_cells {u_tdc/fine_inst/stage1[193].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[193].rTDCVALUE}]
set_property LOC SLICE_X20Y198 [get_cells {u_tdc/fine_inst/stage1[194].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[194].rTDCVALUE}]
set_property LOC SLICE_X20Y198 [get_cells {u_tdc/fine_inst/stage1[195].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[195].rTDCVALUE}]

# CARRY4 block 49 - taps 196 to 199
set_property LOC SLICE_X20Y199 [get_cells {u_tdc/fine_inst/generate_block[49].carry4_1}]
set_property LOC SLICE_X20Y199 [get_cells {u_tdc/fine_inst/stage1[196].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[196].rTDCVALUE}]
set_property LOC SLICE_X20Y199 [get_cells {u_tdc/fine_inst/stage1[197].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[197].rTDCVALUE}]
set_property LOC SLICE_X20Y199 [get_cells {u_tdc/fine_inst/stage1[198].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[198].rTDCVALUE}]
set_property LOC SLICE_X20Y199 [get_cells {u_tdc/fine_inst/stage1[199].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[199].rTDCVALUE}]

# CARRY4 block 50 - taps 200 to 203
set_property LOC SLICE_X20Y200 [get_cells {u_tdc/fine_inst/generate_block[50].carry4_1}]
set_property LOC SLICE_X20Y200 [get_cells {u_tdc/fine_inst/stage1[200].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[200].rTDCVALUE}]
set_property LOC SLICE_X20Y200 [get_cells {u_tdc/fine_inst/stage1[201].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[201].rTDCVALUE}]
set_property LOC SLICE_X20Y200 [get_cells {u_tdc/fine_inst/stage1[202].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[202].rTDCVALUE}]
set_property LOC SLICE_X20Y200 [get_cells {u_tdc/fine_inst/stage1[203].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[203].rTDCVALUE}]

# CARRY4 block 51 - taps 204 to 207
set_property LOC SLICE_X20Y201 [get_cells {u_tdc/fine_inst/generate_block[51].carry4_1}]
set_property LOC SLICE_X20Y201 [get_cells {u_tdc/fine_inst/stage1[204].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[204].rTDCVALUE}]
set_property LOC SLICE_X20Y201 [get_cells {u_tdc/fine_inst/stage1[205].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[205].rTDCVALUE}]
set_property LOC SLICE_X20Y201 [get_cells {u_tdc/fine_inst/stage1[206].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[206].rTDCVALUE}]
set_property LOC SLICE_X20Y201 [get_cells {u_tdc/fine_inst/stage1[207].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[207].rTDCVALUE}]

# CARRY4 block 52 - taps 208 to 211
set_property LOC SLICE_X20Y202 [get_cells {u_tdc/fine_inst/generate_block[52].carry4_1}]
set_property LOC SLICE_X20Y202 [get_cells {u_tdc/fine_inst/stage1[208].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[208].rTDCVALUE}]
set_property LOC SLICE_X20Y202 [get_cells {u_tdc/fine_inst/stage1[209].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[209].rTDCVALUE}]
set_property LOC SLICE_X20Y202 [get_cells {u_tdc/fine_inst/stage1[210].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[210].rTDCVALUE}]
set_property LOC SLICE_X20Y202 [get_cells {u_tdc/fine_inst/stage1[211].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[211].rTDCVALUE}]

# CARRY4 block 53 - taps 212 to 215
set_property LOC SLICE_X20Y203 [get_cells {u_tdc/fine_inst/generate_block[53].carry4_1}]
set_property LOC SLICE_X20Y203 [get_cells {u_tdc/fine_inst/stage1[212].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[212].rTDCVALUE}]
set_property LOC SLICE_X20Y203 [get_cells {u_tdc/fine_inst/stage1[213].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[213].rTDCVALUE}]
set_property LOC SLICE_X20Y203 [get_cells {u_tdc/fine_inst/stage1[214].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[214].rTDCVALUE}]
set_property LOC SLICE_X20Y203 [get_cells {u_tdc/fine_inst/stage1[215].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[215].rTDCVALUE}]

# CARRY4 block 54 - taps 216 to 219
set_property LOC SLICE_X20Y204 [get_cells {u_tdc/fine_inst/generate_block[54].carry4_1}]
set_property LOC SLICE_X20Y204 [get_cells {u_tdc/fine_inst/stage1[216].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[216].rTDCVALUE}]
set_property LOC SLICE_X20Y204 [get_cells {u_tdc/fine_inst/stage1[217].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[217].rTDCVALUE}]
set_property LOC SLICE_X20Y204 [get_cells {u_tdc/fine_inst/stage1[218].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[218].rTDCVALUE}]
set_property LOC SLICE_X20Y204 [get_cells {u_tdc/fine_inst/stage1[219].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[219].rTDCVALUE}]

# CARRY4 block 55 - taps 220 to 223
set_property LOC SLICE_X20Y205 [get_cells {u_tdc/fine_inst/generate_block[55].carry4_1}]
set_property LOC SLICE_X20Y205 [get_cells {u_tdc/fine_inst/stage1[220].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[220].rTDCVALUE}]
set_property LOC SLICE_X20Y205 [get_cells {u_tdc/fine_inst/stage1[221].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[221].rTDCVALUE}]
set_property LOC SLICE_X20Y205 [get_cells {u_tdc/fine_inst/stage1[222].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[222].rTDCVALUE}]
set_property LOC SLICE_X20Y205 [get_cells {u_tdc/fine_inst/stage1[223].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[223].rTDCVALUE}]

# CARRY4 block 56 - taps 224 to 227
set_property LOC SLICE_X20Y206 [get_cells {u_tdc/fine_inst/generate_block[56].carry4_1}]
set_property LOC SLICE_X20Y206 [get_cells {u_tdc/fine_inst/stage1[224].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[224].rTDCVALUE}]
set_property LOC SLICE_X20Y206 [get_cells {u_tdc/fine_inst/stage1[225].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[225].rTDCVALUE}]
set_property LOC SLICE_X20Y206 [get_cells {u_tdc/fine_inst/stage1[226].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[226].rTDCVALUE}]
set_property LOC SLICE_X20Y206 [get_cells {u_tdc/fine_inst/stage1[227].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[227].rTDCVALUE}]

# CARRY4 block 57 - taps 228 to 231
set_property LOC SLICE_X20Y207 [get_cells {u_tdc/fine_inst/generate_block[57].carry4_1}]
set_property LOC SLICE_X20Y207 [get_cells {u_tdc/fine_inst/stage1[228].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[228].rTDCVALUE}]
set_property LOC SLICE_X20Y207 [get_cells {u_tdc/fine_inst/stage1[229].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[229].rTDCVALUE}]
set_property LOC SLICE_X20Y207 [get_cells {u_tdc/fine_inst/stage1[230].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[230].rTDCVALUE}]
set_property LOC SLICE_X20Y207 [get_cells {u_tdc/fine_inst/stage1[231].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[231].rTDCVALUE}]

# CARRY4 block 58 - taps 232 to 235
set_property LOC SLICE_X20Y208 [get_cells {u_tdc/fine_inst/generate_block[58].carry4_1}]
set_property LOC SLICE_X20Y208 [get_cells {u_tdc/fine_inst/stage1[232].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[232].rTDCVALUE}]
set_property LOC SLICE_X20Y208 [get_cells {u_tdc/fine_inst/stage1[233].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[233].rTDCVALUE}]
set_property LOC SLICE_X20Y208 [get_cells {u_tdc/fine_inst/stage1[234].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[234].rTDCVALUE}]
set_property LOC SLICE_X20Y208 [get_cells {u_tdc/fine_inst/stage1[235].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[235].rTDCVALUE}]

# CARRY4 block 59 - taps 236 to 239
set_property LOC SLICE_X20Y209 [get_cells {u_tdc/fine_inst/generate_block[59].carry4_1}]
set_property LOC SLICE_X20Y209 [get_cells {u_tdc/fine_inst/stage1[236].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[236].rTDCVALUE}]
set_property LOC SLICE_X20Y209 [get_cells {u_tdc/fine_inst/stage1[237].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[237].rTDCVALUE}]
set_property LOC SLICE_X20Y209 [get_cells {u_tdc/fine_inst/stage1[238].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[238].rTDCVALUE}]
set_property LOC SLICE_X20Y209 [get_cells {u_tdc/fine_inst/stage1[239].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[239].rTDCVALUE}]

# CARRY4 block 60 - taps 240 to 243
set_property LOC SLICE_X20Y210 [get_cells {u_tdc/fine_inst/generate_block[60].carry4_1}]
set_property LOC SLICE_X20Y210 [get_cells {u_tdc/fine_inst/stage1[240].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[240].rTDCVALUE}]
set_property LOC SLICE_X20Y210 [get_cells {u_tdc/fine_inst/stage1[241].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[241].rTDCVALUE}]
set_property LOC SLICE_X20Y210 [get_cells {u_tdc/fine_inst/stage1[242].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[242].rTDCVALUE}]
set_property LOC SLICE_X20Y210 [get_cells {u_tdc/fine_inst/stage1[243].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[243].rTDCVALUE}]

# CARRY4 block 61 - taps 244 to 247
set_property LOC SLICE_X20Y211 [get_cells {u_tdc/fine_inst/generate_block[61].carry4_1}]
set_property LOC SLICE_X20Y211 [get_cells {u_tdc/fine_inst/stage1[244].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[244].rTDCVALUE}]
set_property LOC SLICE_X20Y211 [get_cells {u_tdc/fine_inst/stage1[245].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[245].rTDCVALUE}]
set_property LOC SLICE_X20Y211 [get_cells {u_tdc/fine_inst/stage1[246].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[246].rTDCVALUE}]
set_property LOC SLICE_X20Y211 [get_cells {u_tdc/fine_inst/stage1[247].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[247].rTDCVALUE}]

# CARRY4 block 62 - taps 248 to 251
set_property LOC SLICE_X20Y212 [get_cells {u_tdc/fine_inst/generate_block[62].carry4_1}]
set_property LOC SLICE_X20Y212 [get_cells {u_tdc/fine_inst/stage1[248].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[248].rTDCVALUE}]
set_property LOC SLICE_X20Y212 [get_cells {u_tdc/fine_inst/stage1[249].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[249].rTDCVALUE}]
set_property LOC SLICE_X20Y212 [get_cells {u_tdc/fine_inst/stage1[250].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[250].rTDCVALUE}]
set_property LOC SLICE_X20Y212 [get_cells {u_tdc/fine_inst/stage1[251].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[251].rTDCVALUE}]

# CARRY4 block 63 - taps 252 to 255
set_property LOC SLICE_X20Y213 [get_cells {u_tdc/fine_inst/generate_block[63].carry4_1}]
set_property LOC SLICE_X20Y213 [get_cells {u_tdc/fine_inst/stage1[252].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[252].rTDCVALUE}]
set_property LOC SLICE_X20Y213 [get_cells {u_tdc/fine_inst/stage1[253].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[253].rTDCVALUE}]
set_property LOC SLICE_X20Y213 [get_cells {u_tdc/fine_inst/stage1[254].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[254].rTDCVALUE}]
set_property LOC SLICE_X20Y213 [get_cells {u_tdc/fine_inst/stage1[255].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[255].rTDCVALUE}]

# CARRY4 block 64 - taps 256 to 259
set_property LOC SLICE_X20Y214 [get_cells {u_tdc/fine_inst/generate_block[64].carry4_1}]
set_property LOC SLICE_X20Y214 [get_cells {u_tdc/fine_inst/stage1[256].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[256].rTDCVALUE}]
set_property LOC SLICE_X20Y214 [get_cells {u_tdc/fine_inst/stage1[257].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[257].rTDCVALUE}]
set_property LOC SLICE_X20Y214 [get_cells {u_tdc/fine_inst/stage1[258].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[258].rTDCVALUE}]
set_property LOC SLICE_X20Y214 [get_cells {u_tdc/fine_inst/stage1[259].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[259].rTDCVALUE}]

# CARRY4 block 65 - taps 260 to 263
set_property LOC SLICE_X20Y215 [get_cells {u_tdc/fine_inst/generate_block[65].carry4_1}]
set_property LOC SLICE_X20Y215 [get_cells {u_tdc/fine_inst/stage1[260].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[260].rTDCVALUE}]
set_property LOC SLICE_X20Y215 [get_cells {u_tdc/fine_inst/stage1[261].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[261].rTDCVALUE}]
set_property LOC SLICE_X20Y215 [get_cells {u_tdc/fine_inst/stage1[262].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[262].rTDCVALUE}]
set_property LOC SLICE_X20Y215 [get_cells {u_tdc/fine_inst/stage1[263].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[263].rTDCVALUE}]

# CARRY4 block 66 - taps 264 to 267
set_property LOC SLICE_X20Y216 [get_cells {u_tdc/fine_inst/generate_block[66].carry4_1}]
set_property LOC SLICE_X20Y216 [get_cells {u_tdc/fine_inst/stage1[264].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[264].rTDCVALUE}]
set_property LOC SLICE_X20Y216 [get_cells {u_tdc/fine_inst/stage1[265].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[265].rTDCVALUE}]
set_property LOC SLICE_X20Y216 [get_cells {u_tdc/fine_inst/stage1[266].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[266].rTDCVALUE}]
set_property LOC SLICE_X20Y216 [get_cells {u_tdc/fine_inst/stage1[267].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[267].rTDCVALUE}]

# CARRY4 block 67 - taps 268 to 271
set_property LOC SLICE_X20Y217 [get_cells {u_tdc/fine_inst/generate_block[67].carry4_1}]
set_property LOC SLICE_X20Y217 [get_cells {u_tdc/fine_inst/stage1[268].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[268].rTDCVALUE}]
set_property LOC SLICE_X20Y217 [get_cells {u_tdc/fine_inst/stage1[269].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[269].rTDCVALUE}]
set_property LOC SLICE_X20Y217 [get_cells {u_tdc/fine_inst/stage1[270].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[270].rTDCVALUE}]
set_property LOC SLICE_X20Y217 [get_cells {u_tdc/fine_inst/stage1[271].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[271].rTDCVALUE}]

# CARRY4 block 68 - taps 272 to 275
set_property LOC SLICE_X20Y218 [get_cells {u_tdc/fine_inst/generate_block[68].carry4_1}]
set_property LOC SLICE_X20Y218 [get_cells {u_tdc/fine_inst/stage1[272].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[272].rTDCVALUE}]
set_property LOC SLICE_X20Y218 [get_cells {u_tdc/fine_inst/stage1[273].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[273].rTDCVALUE}]
set_property LOC SLICE_X20Y218 [get_cells {u_tdc/fine_inst/stage1[274].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[274].rTDCVALUE}]
set_property LOC SLICE_X20Y218 [get_cells {u_tdc/fine_inst/stage1[275].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[275].rTDCVALUE}]

# CARRY4 block 69 - taps 276 to 279
set_property LOC SLICE_X20Y219 [get_cells {u_tdc/fine_inst/generate_block[69].carry4_1}]
set_property LOC SLICE_X20Y219 [get_cells {u_tdc/fine_inst/stage1[276].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[276].rTDCVALUE}]
set_property LOC SLICE_X20Y219 [get_cells {u_tdc/fine_inst/stage1[277].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[277].rTDCVALUE}]
set_property LOC SLICE_X20Y219 [get_cells {u_tdc/fine_inst/stage1[278].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[278].rTDCVALUE}]
set_property LOC SLICE_X20Y219 [get_cells {u_tdc/fine_inst/stage1[279].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[279].rTDCVALUE}]

# CARRY4 block 70 - taps 280 to 283
set_property LOC SLICE_X20Y220 [get_cells {u_tdc/fine_inst/generate_block[70].carry4_1}]
set_property LOC SLICE_X20Y220 [get_cells {u_tdc/fine_inst/stage1[280].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[280].rTDCVALUE}]
set_property LOC SLICE_X20Y220 [get_cells {u_tdc/fine_inst/stage1[281].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[281].rTDCVALUE}]
set_property LOC SLICE_X20Y220 [get_cells {u_tdc/fine_inst/stage1[282].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[282].rTDCVALUE}]
set_property LOC SLICE_X20Y220 [get_cells {u_tdc/fine_inst/stage1[283].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[283].rTDCVALUE}]

# CARRY4 block 71 - taps 284 to 287
set_property LOC SLICE_X20Y221 [get_cells {u_tdc/fine_inst/generate_block[71].carry4_1}]
set_property LOC SLICE_X20Y221 [get_cells {u_tdc/fine_inst/stage1[284].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[284].rTDCVALUE}]
set_property LOC SLICE_X20Y221 [get_cells {u_tdc/fine_inst/stage1[285].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[285].rTDCVALUE}]
set_property LOC SLICE_X20Y221 [get_cells {u_tdc/fine_inst/stage1[286].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[286].rTDCVALUE}]
set_property LOC SLICE_X20Y221 [get_cells {u_tdc/fine_inst/stage1[287].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[287].rTDCVALUE}]

# CARRY4 block 72 - taps 288 to 291
set_property LOC SLICE_X20Y222 [get_cells {u_tdc/fine_inst/generate_block[72].carry4_1}]
set_property LOC SLICE_X20Y222 [get_cells {u_tdc/fine_inst/stage1[288].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[288].rTDCVALUE}]
set_property LOC SLICE_X20Y222 [get_cells {u_tdc/fine_inst/stage1[289].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[289].rTDCVALUE}]
set_property LOC SLICE_X20Y222 [get_cells {u_tdc/fine_inst/stage1[290].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[290].rTDCVALUE}]
set_property LOC SLICE_X20Y222 [get_cells {u_tdc/fine_inst/stage1[291].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[291].rTDCVALUE}]

# CARRY4 block 73 - taps 292 to 295
set_property LOC SLICE_X20Y223 [get_cells {u_tdc/fine_inst/generate_block[73].carry4_1}]
set_property LOC SLICE_X20Y223 [get_cells {u_tdc/fine_inst/stage1[292].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[292].rTDCVALUE}]
set_property LOC SLICE_X20Y223 [get_cells {u_tdc/fine_inst/stage1[293].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[293].rTDCVALUE}]
set_property LOC SLICE_X20Y223 [get_cells {u_tdc/fine_inst/stage1[294].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[294].rTDCVALUE}]
set_property LOC SLICE_X20Y223 [get_cells {u_tdc/fine_inst/stage1[295].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[295].rTDCVALUE}]

# CARRY4 block 74 - taps 296 to 299
set_property LOC SLICE_X20Y224 [get_cells {u_tdc/fine_inst/generate_block[74].carry4_1}]
set_property LOC SLICE_X20Y224 [get_cells {u_tdc/fine_inst/stage1[296].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[296].rTDCVALUE}]
set_property LOC SLICE_X20Y224 [get_cells {u_tdc/fine_inst/stage1[297].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[297].rTDCVALUE}]
set_property LOC SLICE_X20Y224 [get_cells {u_tdc/fine_inst/stage1[298].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[298].rTDCVALUE}]
set_property LOC SLICE_X20Y224 [get_cells {u_tdc/fine_inst/stage1[299].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[299].rTDCVALUE}]

# CARRY4 block 75 - taps 300 to 303
set_property LOC SLICE_X20Y225 [get_cells {u_tdc/fine_inst/generate_block[75].carry4_1}]
set_property LOC SLICE_X20Y225 [get_cells {u_tdc/fine_inst/stage1[300].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[300].rTDCVALUE}]
set_property LOC SLICE_X20Y225 [get_cells {u_tdc/fine_inst/stage1[301].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[301].rTDCVALUE}]
set_property LOC SLICE_X20Y225 [get_cells {u_tdc/fine_inst/stage1[302].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[302].rTDCVALUE}]
set_property LOC SLICE_X20Y225 [get_cells {u_tdc/fine_inst/stage1[303].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[303].rTDCVALUE}]

# CARRY4 block 76 - taps 304 to 307
set_property LOC SLICE_X20Y226 [get_cells {u_tdc/fine_inst/generate_block[76].carry4_1}]
set_property LOC SLICE_X20Y226 [get_cells {u_tdc/fine_inst/stage1[304].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[304].rTDCVALUE}]
set_property LOC SLICE_X20Y226 [get_cells {u_tdc/fine_inst/stage1[305].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[305].rTDCVALUE}]
set_property LOC SLICE_X20Y226 [get_cells {u_tdc/fine_inst/stage1[306].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[306].rTDCVALUE}]
set_property LOC SLICE_X20Y226 [get_cells {u_tdc/fine_inst/stage1[307].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[307].rTDCVALUE}]

# CARRY4 block 77 - taps 308 to 311
set_property LOC SLICE_X20Y227 [get_cells {u_tdc/fine_inst/generate_block[77].carry4_1}]
set_property LOC SLICE_X20Y227 [get_cells {u_tdc/fine_inst/stage1[308].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[308].rTDCVALUE}]
set_property LOC SLICE_X20Y227 [get_cells {u_tdc/fine_inst/stage1[309].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[309].rTDCVALUE}]
set_property LOC SLICE_X20Y227 [get_cells {u_tdc/fine_inst/stage1[310].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[310].rTDCVALUE}]
set_property LOC SLICE_X20Y227 [get_cells {u_tdc/fine_inst/stage1[311].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[311].rTDCVALUE}]

# CARRY4 block 78 - taps 312 to 315
set_property LOC SLICE_X20Y228 [get_cells {u_tdc/fine_inst/generate_block[78].carry4_1}]
set_property LOC SLICE_X20Y228 [get_cells {u_tdc/fine_inst/stage1[312].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[312].rTDCVALUE}]
set_property LOC SLICE_X20Y228 [get_cells {u_tdc/fine_inst/stage1[313].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[313].rTDCVALUE}]
set_property LOC SLICE_X20Y228 [get_cells {u_tdc/fine_inst/stage1[314].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[314].rTDCVALUE}]
set_property LOC SLICE_X20Y228 [get_cells {u_tdc/fine_inst/stage1[315].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[315].rTDCVALUE}]

# CARRY4 block 79 - taps 316 to 319
set_property LOC SLICE_X20Y229 [get_cells {u_tdc/fine_inst/generate_block[79].carry4_1}]
set_property LOC SLICE_X20Y229 [get_cells {u_tdc/fine_inst/stage1[316].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[316].rTDCVALUE}]
set_property LOC SLICE_X20Y229 [get_cells {u_tdc/fine_inst/stage1[317].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[317].rTDCVALUE}]
set_property LOC SLICE_X20Y229 [get_cells {u_tdc/fine_inst/stage1[318].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[318].rTDCVALUE}]
set_property LOC SLICE_X20Y229 [get_cells {u_tdc/fine_inst/stage1[319].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[319].rTDCVALUE}]

# CARRY4 block 80 - taps 320 to 323
set_property LOC SLICE_X20Y230 [get_cells {u_tdc/fine_inst/generate_block[80].carry4_1}]
set_property LOC SLICE_X20Y230 [get_cells {u_tdc/fine_inst/stage1[320].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[320].rTDCVALUE}]
set_property LOC SLICE_X20Y230 [get_cells {u_tdc/fine_inst/stage1[321].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[321].rTDCVALUE}]
set_property LOC SLICE_X20Y230 [get_cells {u_tdc/fine_inst/stage1[322].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[322].rTDCVALUE}]
set_property LOC SLICE_X20Y230 [get_cells {u_tdc/fine_inst/stage1[323].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[323].rTDCVALUE}]

# CARRY4 block 81 - taps 324 to 327
set_property LOC SLICE_X20Y231 [get_cells {u_tdc/fine_inst/generate_block[81].carry4_1}]
set_property LOC SLICE_X20Y231 [get_cells {u_tdc/fine_inst/stage1[324].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[324].rTDCVALUE}]
set_property LOC SLICE_X20Y231 [get_cells {u_tdc/fine_inst/stage1[325].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[325].rTDCVALUE}]
set_property LOC SLICE_X20Y231 [get_cells {u_tdc/fine_inst/stage1[326].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[326].rTDCVALUE}]
set_property LOC SLICE_X20Y231 [get_cells {u_tdc/fine_inst/stage1[327].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[327].rTDCVALUE}]

# CARRY4 block 82 - taps 328 to 331
set_property LOC SLICE_X20Y232 [get_cells {u_tdc/fine_inst/generate_block[82].carry4_1}]
set_property LOC SLICE_X20Y232 [get_cells {u_tdc/fine_inst/stage1[328].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[328].rTDCVALUE}]
set_property LOC SLICE_X20Y232 [get_cells {u_tdc/fine_inst/stage1[329].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[329].rTDCVALUE}]
set_property LOC SLICE_X20Y232 [get_cells {u_tdc/fine_inst/stage1[330].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[330].rTDCVALUE}]
set_property LOC SLICE_X20Y232 [get_cells {u_tdc/fine_inst/stage1[331].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[331].rTDCVALUE}]

# CARRY4 block 83 - taps 332 to 335
set_property LOC SLICE_X20Y233 [get_cells {u_tdc/fine_inst/generate_block[83].carry4_1}]
set_property LOC SLICE_X20Y233 [get_cells {u_tdc/fine_inst/stage1[332].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[332].rTDCVALUE}]
set_property LOC SLICE_X20Y233 [get_cells {u_tdc/fine_inst/stage1[333].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[333].rTDCVALUE}]
set_property LOC SLICE_X20Y233 [get_cells {u_tdc/fine_inst/stage1[334].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[334].rTDCVALUE}]
set_property LOC SLICE_X20Y233 [get_cells {u_tdc/fine_inst/stage1[335].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[335].rTDCVALUE}]

# CARRY4 block 84 - taps 336 to 339
set_property LOC SLICE_X20Y234 [get_cells {u_tdc/fine_inst/generate_block[84].carry4_1}]
set_property LOC SLICE_X20Y234 [get_cells {u_tdc/fine_inst/stage1[336].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[336].rTDCVALUE}]
set_property LOC SLICE_X20Y234 [get_cells {u_tdc/fine_inst/stage1[337].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[337].rTDCVALUE}]
set_property LOC SLICE_X20Y234 [get_cells {u_tdc/fine_inst/stage1[338].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[338].rTDCVALUE}]
set_property LOC SLICE_X20Y234 [get_cells {u_tdc/fine_inst/stage1[339].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[339].rTDCVALUE}]

# CARRY4 block 85 - taps 340 to 343
set_property LOC SLICE_X20Y235 [get_cells {u_tdc/fine_inst/generate_block[85].carry4_1}]
set_property LOC SLICE_X20Y235 [get_cells {u_tdc/fine_inst/stage1[340].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[340].rTDCVALUE}]
set_property LOC SLICE_X20Y235 [get_cells {u_tdc/fine_inst/stage1[341].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[341].rTDCVALUE}]
set_property LOC SLICE_X20Y235 [get_cells {u_tdc/fine_inst/stage1[342].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[342].rTDCVALUE}]
set_property LOC SLICE_X20Y235 [get_cells {u_tdc/fine_inst/stage1[343].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[343].rTDCVALUE}]

# CARRY4 block 86 - taps 344 to 347
set_property LOC SLICE_X20Y236 [get_cells {u_tdc/fine_inst/generate_block[86].carry4_1}]
set_property LOC SLICE_X20Y236 [get_cells {u_tdc/fine_inst/stage1[344].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[344].rTDCVALUE}]
set_property LOC SLICE_X20Y236 [get_cells {u_tdc/fine_inst/stage1[345].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[345].rTDCVALUE}]
set_property LOC SLICE_X20Y236 [get_cells {u_tdc/fine_inst/stage1[346].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[346].rTDCVALUE}]
set_property LOC SLICE_X20Y236 [get_cells {u_tdc/fine_inst/stage1[347].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[347].rTDCVALUE}]

# CARRY4 block 87 - taps 348 to 351
set_property LOC SLICE_X20Y237 [get_cells {u_tdc/fine_inst/generate_block[87].carry4_1}]
set_property LOC SLICE_X20Y237 [get_cells {u_tdc/fine_inst/stage1[348].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[348].rTDCVALUE}]
set_property LOC SLICE_X20Y237 [get_cells {u_tdc/fine_inst/stage1[349].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[349].rTDCVALUE}]
set_property LOC SLICE_X20Y237 [get_cells {u_tdc/fine_inst/stage1[350].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[350].rTDCVALUE}]
set_property LOC SLICE_X20Y237 [get_cells {u_tdc/fine_inst/stage1[351].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[351].rTDCVALUE}]

# CARRY4 block 88 - taps 352 to 355
set_property LOC SLICE_X20Y238 [get_cells {u_tdc/fine_inst/generate_block[88].carry4_1}]
set_property LOC SLICE_X20Y238 [get_cells {u_tdc/fine_inst/stage1[352].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[352].rTDCVALUE}]
set_property LOC SLICE_X20Y238 [get_cells {u_tdc/fine_inst/stage1[353].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[353].rTDCVALUE}]
set_property LOC SLICE_X20Y238 [get_cells {u_tdc/fine_inst/stage1[354].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[354].rTDCVALUE}]
set_property LOC SLICE_X20Y238 [get_cells {u_tdc/fine_inst/stage1[355].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[355].rTDCVALUE}]

# CARRY4 block 89 - taps 356 to 359
set_property LOC SLICE_X20Y239 [get_cells {u_tdc/fine_inst/generate_block[89].carry4_1}]
set_property LOC SLICE_X20Y239 [get_cells {u_tdc/fine_inst/stage1[356].rTDCVALUE}]
set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[356].rTDCVALUE}]
set_property LOC SLICE_X20Y239 [get_cells {u_tdc/fine_inst/stage1[357].rTDCVALUE}]
set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[357].rTDCVALUE}]
set_property LOC SLICE_X20Y239 [get_cells {u_tdc/fine_inst/stage1[358].rTDCVALUE}]
set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[358].rTDCVALUE}]
set_property LOC SLICE_X20Y239 [get_cells {u_tdc/fine_inst/stage1[359].rTDCVALUE}]
set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[359].rTDCVALUE}]

# CARRY4 block 90 - taps 360 to 363
#set_property LOC SLICE_X20Y240 [get_cells {u_tdc/fine_inst/generate_block[90].carry4_1}]
#set_property LOC SLICE_X20Y240 [get_cells {u_tdc/fine_inst/stage1[360].rTDCVALUE}]
#set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[360].rTDCVALUE}]
#set_property LOC SLICE_X20Y240 [get_cells {u_tdc/fine_inst/stage1[361].rTDCVALUE}]
#set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[361].rTDCVALUE}]
#set_property LOC SLICE_X20Y240 [get_cells {u_tdc/fine_inst/stage1[362].rTDCVALUE}]
#set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[362].rTDCVALUE}]
#set_property LOC SLICE_X20Y240 [get_cells {u_tdc/fine_inst/stage1[363].rTDCVALUE}]
#set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[363].rTDCVALUE}]

# CARRY4 block 91 - taps 364 to 367
#set_property LOC SLICE_X20Y241 [get_cells {u_tdc/fine_inst/generate_block[91].carry4_1}]
#set_property LOC SLICE_X20Y241 [get_cells {u_tdc/fine_inst/stage1[364].rTDCVALUE}]
#set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[364].rTDCVALUE}]
#set_property LOC SLICE_X20Y241 [get_cells {u_tdc/fine_inst/stage1[365].rTDCVALUE}]
#set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[365].rTDCVALUE}]
#set_property LOC SLICE_X20Y241 [get_cells {u_tdc/fine_inst/stage1[366].rTDCVALUE}]
#set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[366].rTDCVALUE}]
#set_property LOC SLICE_X20Y241 [get_cells {u_tdc/fine_inst/stage1[367].rTDCVALUE}]
#set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[367].rTDCVALUE}]

# CARRY4 block 92 - taps 368 to 371
#set_property LOC SLICE_X20Y242 [get_cells {u_tdc/fine_inst/generate_block[92].carry4_1}]
#set_property LOC SLICE_X20Y242 [get_cells {u_tdc/fine_inst/stage1[368].rTDCVALUE}]
#set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[368].rTDCVALUE}]
#set_property LOC SLICE_X20Y242 [get_cells {u_tdc/fine_inst/stage1[369].rTDCVALUE}]
#set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[369].rTDCVALUE}]
#set_property LOC SLICE_X20Y242 [get_cells {u_tdc/fine_inst/stage1[370].rTDCVALUE}]
#set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[370].rTDCVALUE}]
#set_property LOC SLICE_X20Y242 [get_cells {u_tdc/fine_inst/stage1[371].rTDCVALUE}]
#set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[371].rTDCVALUE}]

# CARRY4 block 93 - taps 372 to 375
#set_property LOC SLICE_X20Y243 [get_cells {u_tdc/fine_inst/generate_block[93].carry4_1}]
#set_property LOC SLICE_X20Y243 [get_cells {u_tdc/fine_inst/stage1[372].rTDCVALUE}]
#set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[372].rTDCVALUE}]
#set_property LOC SLICE_X20Y243 [get_cells {u_tdc/fine_inst/stage1[373].rTDCVALUE}]
#set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[373].rTDCVALUE}]
#set_property LOC SLICE_X20Y243 [get_cells {u_tdc/fine_inst/stage1[374].rTDCVALUE}]
#set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[374].rTDCVALUE}]
#set_property LOC SLICE_X20Y243 [get_cells {u_tdc/fine_inst/stage1[375].rTDCVALUE}]
#set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[375].rTDCVALUE}]

# CARRY4 block 94 - taps 376 to 379
#set_property LOC SLICE_X20Y244 [get_cells {u_tdc/fine_inst/generate_block[94].carry4_1}]
#set_property LOC SLICE_X20Y244 [get_cells {u_tdc/fine_inst/stage1[376].rTDCVALUE}]
#set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[376].rTDCVALUE}]
#set_property LOC SLICE_X20Y244 [get_cells {u_tdc/fine_inst/stage1[377].rTDCVALUE}]
#set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[377].rTDCVALUE}]
#set_property LOC SLICE_X20Y244 [get_cells {u_tdc/fine_inst/stage1[378].rTDCVALUE}]
#set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[378].rTDCVALUE}]
#set_property LOC SLICE_X20Y244 [get_cells {u_tdc/fine_inst/stage1[379].rTDCVALUE}]
#set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[379].rTDCVALUE}]

# CARRY4 block 95 - taps 380 to 383
#set_property LOC SLICE_X20Y245 [get_cells {u_tdc/fine_inst/generate_block[95].carry4_1}]
#set_property LOC SLICE_X20Y245 [get_cells {u_tdc/fine_inst/stage1[380].rTDCVALUE}]
#set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[380].rTDCVALUE}]
#set_property LOC SLICE_X20Y245 [get_cells {u_tdc/fine_inst/stage1[381].rTDCVALUE}]
#set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[381].rTDCVALUE}]
#set_property LOC SLICE_X20Y245 [get_cells {u_tdc/fine_inst/stage1[382].rTDCVALUE}]
#set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[382].rTDCVALUE}]
#set_property LOC SLICE_X20Y245 [get_cells {u_tdc/fine_inst/stage1[383].rTDCVALUE}]
#set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[383].rTDCVALUE}]

# CARRY4 block 96 - taps 384 to 387
#set_property LOC SLICE_X20Y246 [get_cells {u_tdc/fine_inst/generate_block[96].carry4_1}]
#set_property LOC SLICE_X20Y246 [get_cells {u_tdc/fine_inst/stage1[384].rTDCVALUE}]
#set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[384].rTDCVALUE}]
#set_property LOC SLICE_X20Y246 [get_cells {u_tdc/fine_inst/stage1[385].rTDCVALUE}]
#set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[385].rTDCVALUE}]
#set_property LOC SLICE_X20Y246 [get_cells {u_tdc/fine_inst/stage1[386].rTDCVALUE}]
#set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[386].rTDCVALUE}]
#set_property LOC SLICE_X20Y246 [get_cells {u_tdc/fine_inst/stage1[387].rTDCVALUE}]
#set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[387].rTDCVALUE}]

# CARRY4 block 97 - taps 388 to 391
#set_property LOC SLICE_X20Y247 [get_cells {u_tdc/fine_inst/generate_block[97].carry4_1}]
#set_property LOC SLICE_X20Y247 [get_cells {u_tdc/fine_inst/stage1[388].rTDCVALUE}]
#set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[388].rTDCVALUE}]
#set_property LOC SLICE_X20Y247 [get_cells {u_tdc/fine_inst/stage1[389].rTDCVALUE}]
#set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[389].rTDCVALUE}]
#set_property LOC SLICE_X20Y247 [get_cells {u_tdc/fine_inst/stage1[390].rTDCVALUE}]
#set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[390].rTDCVALUE}]
#set_property LOC SLICE_X20Y247 [get_cells {u_tdc/fine_inst/stage1[391].rTDCVALUE}]
#set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[391].rTDCVALUE}]

# CARRY4 block 98 - taps 392 to 395
#set_property LOC SLICE_X20Y248 [get_cells {u_tdc/fine_inst/generate_block[98].carry4_1}]
#set_property LOC SLICE_X20Y248 [get_cells {u_tdc/fine_inst/stage1[392].rTDCVALUE}]
#set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[392].rTDCVALUE}]
#set_property LOC SLICE_X20Y248 [get_cells {u_tdc/fine_inst/stage1[393].rTDCVALUE}]
#set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[393].rTDCVALUE}]
#set_property LOC SLICE_X20Y248 [get_cells {u_tdc/fine_inst/stage1[394].rTDCVALUE}]
#set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[394].rTDCVALUE}]
#set_property LOC SLICE_X20Y248 [get_cells {u_tdc/fine_inst/stage1[395].rTDCVALUE}]
#set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[395].rTDCVALUE}]

# CARRY4 block 99 - taps 396 to 399
#set_property LOC SLICE_X20Y249 [get_cells {u_tdc/fine_inst/generate_block[99].carry4_1}]
#set_property LOC SLICE_X20Y249 [get_cells {u_tdc/fine_inst/stage1[396].rTDCVALUE}]
#set_property BEL AFF [get_cells {u_tdc/fine_inst/stage1[396].rTDCVALUE}]
#set_property LOC SLICE_X20Y249 [get_cells {u_tdc/fine_inst/stage1[397].rTDCVALUE}]
#set_property BEL BFF [get_cells {u_tdc/fine_inst/stage1[397].rTDCVALUE}]
#set_property LOC SLICE_X20Y249 [get_cells {u_tdc/fine_inst/stage1[398].rTDCVALUE}]
#set_property BEL CFF [get_cells {u_tdc/fine_inst/stage1[398].rTDCVALUE}]
#set_property LOC SLICE_X20Y249 [get_cells {u_tdc/fine_inst/stage1[399].rTDCVALUE}]
#set_property BEL DFF [get_cells {u_tdc/fine_inst/stage1[399].rTDCVALUE}]


