onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /convolution_testbench/clk_i
add wave -noupdate /convolution_testbench/reset_i
add wave -noupdate -radix unsigned /convolution_testbench/pixel_i
add wave -noupdate /convolution_testbench/request_o
add wave -noupdate /convolution_testbench/v_o
add wave -noupdate /convolution_testbench/finished
add wave -noupdate -radix unsigned /convolution_testbench/conv_o
add wave -noupdate /convolution_testbench/fil_sw_i
add wave -noupdate -radix unsigned /convolution_testbench/dut/fifos/pixel_i
add wave -noupdate /convolution_testbench/dut/fifos/clk_i
add wave -noupdate /convolution_testbench/dut/fifos/reset_i
add wave -noupdate /convolution_testbench/dut/fifos/request_i
add wave -noupdate -radix unsigned /convolution_testbench/dut/fifos/pixel_o
add wave -noupdate /convolution_testbench/dut/fifos/v_o
add wave -noupdate /convolution_testbench/dut/fifos/request_o
add wave -noupdate /convolution_testbench/dut/fifos/ps
add wave -noupdate /convolution_testbench/dut/fifos/row_1/enable
add wave -noupdate /convolution_testbench/dut/fifos/row_1/size
add wave -noupdate -radix unsigned /convolution_testbench/writes
add wave -noupdate -radix unsigned /convolution_testbench/reads
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {192000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 101
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {761726 ps}
