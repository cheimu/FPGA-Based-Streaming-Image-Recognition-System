# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./convolution.sv"
vlog "./cu.sv"
vlog "./DFlipFlop.sv"
vlog "./fifo_route.sv"
vlog "./conv_fifo.sv"
vlog "./filter_sel.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work convolution_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do conv_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
