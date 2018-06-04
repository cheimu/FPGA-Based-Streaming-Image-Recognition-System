#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************
#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "50.0 MHz"  -name CLOCK2_50 [get_ports CLOCK2_50]
create_clock -period "50.0 MHz"  -name CLOCK3_50 [get_ports CLOCK3_50]
create_clock -period "50.0 MHz"  -name CLOCK_50  [get_ports CLOCK_50 ]
create_clock -period "25.0 MHz"  -name MIPI_PIXEL_CLK [get_ports MIPI_PIXEL_CLK]


# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

#SDRAM CLK
create_generated_clock -source [get_pins {u0|pll_sys|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] \
                      -name clk_dram_ext [get_ports {DRAM_CLK}]
#VGA CLK
create_generated_clock -source [get_pins { u0|pll_sys|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk }] \
                      -name clk_vga_ext [get_ports {VGA_CLK}] -invert

#D8M							 
create_clock -period "25.0 MHz" -name MIPI_PIXEL_CLK [get_ports MIPI_PIXEL_CLK]
create_clock -period "25.0 MHz" -name MIPI_PIXEL_CLK_ext


#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************
# tpd  min 1ns ,max 6ns
# suppose +- 100 ps skew
# Board Delay (Data) + Propagation Delay - Board Delay (Clock)

# D8M						  
# tpd  min 1ns ,max 6ns
set_input_delay -max 6.1 -clock  MIPI_PIXEL_CLK_ext  [get_ports {MIPI_PIXEL_VS MIPI_PIXEL_HS MIPI_PIXEL_D[*]}]
set_input_delay -min 0.9 -clock  MIPI_PIXEL_CLK_ext  [get_ports {MIPI_PIXEL_VS MIPI_PIXEL_HS MIPI_PIXEL_D[*]}]

# SDRAM
# max 5.4(max) +0.4(trace delay) +0.1  = 5.9
# min 2.7(min) +0.4(trace delay) -0.1  = 3.0
set_input_delay -max -clock clk_dram_ext 5.9 [get_ports DRAM_DQ*]
set_input_delay -min -clock clk_dram_ext 3.0 [get_ports DRAM_DQ*]
#shift-window
set_multicycle_path -from [get_clocks {clk_dram_ext}] \
                    -to [get_clocks {u0|pll_sys|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] \
						  -setup 2           



#**************************************************************
# Set Output Delay
#**************************************************************
# suppose +- 100 ps skew
# max : Board Delay (Data) - Board Delay (Clock) + tsu (External Device)
# min : Board Delay (Data) - Board Delay (Clock) - th (External Device)

#SDRAM
# max  1.5+0.1 =  1.6
# min -0.8-0.1 = -0.9
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_DQ* DRAM_*DQM}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_DQ* DRAM_*DQM}]
set_output_delay -max -clock clk_dram_ext 1.6  [get_ports {DRAM_ADDR* DRAM_BA* DRAM_RAS_N DRAM_CAS_N DRAM_WE_N DRAM_CKE DRAM_CS_N}]
set_output_delay -min -clock clk_dram_ext -0.9 [get_ports {DRAM_ADDR* DRAM_BA* DRAM_RAS_N DRAM_CAS_N DRAM_WE_N DRAM_CKE DRAM_CS_N}]

#VGA
# max  0.2+0.1 =  0.3
# min -1.5-0.1 = -1.6
set_output_delay -max -clock clk_vga_ext  0.3 [get_ports {VGA_R* VGA_G* VGA_B* VGA_BLANK}]
set_output_delay -min -clock clk_vga_ext -1.6 [get_ports {VGA_R* VGA_G* VGA_B* VGA_BLANK}]

#**************************************************************
# Set Clock Groups
#**************************************************************
set_clock_groups -asynchronous -group [get_clocks {u0|pll_sys|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] \
                               -group [get_clocks {MIPI_PIXEL_CLK}]


#**************************************************************
# Set False Path
#**************************************************************
set_false_path -from [get_ports {KEY* SW*}] -to *
set_false_path -from * -to [get_ports {LED* HEX*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



