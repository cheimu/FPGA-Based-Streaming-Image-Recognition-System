onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /square_convolution_testbench/writes
add wave -noupdate /square_convolution_testbench/write_request
add wave -noupdate -radix unsigned /square_convolution_testbench/sw
add wave -noupdate /square_convolution_testbench/reset
add wave -noupdate -radix unsigned /square_convolution_testbench/reads
add wave -noupdate /square_convolution_testbench/read_request
add wave -noupdate -radix unsigned /square_convolution_testbench/pixel_o
add wave -noupdate -radix unsigned /square_convolution_testbench/pixel_i
add wave -noupdate /square_convolution_testbench/finished
add wave -noupdate /square_convolution_testbench/clk
add wave -noupdate -radix decimal /square_convolution_testbench/dut/fil_ext
add wave -noupdate -radix decimal /square_convolution_testbench/dut/temp
add wave -noupdate -radix decimal /square_convolution_testbench/dut/mults
add wave -noupdate -radix decimal /square_convolution_testbench/dut/conv_d
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {307844 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 417
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
WaveRestoreZoom {633815 ps} {634433 ps}
