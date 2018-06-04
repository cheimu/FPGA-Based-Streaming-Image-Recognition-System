onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /horizontal_convolution_testbench/write_request
add wave -noupdate /horizontal_convolution_testbench/reset
add wave -noupdate /horizontal_convolution_testbench/read_request
add wave -noupdate /horizontal_convolution_testbench/pixel_o
add wave -noupdate /horizontal_convolution_testbench/pixel_i
add wave -noupdate /horizontal_convolution_testbench/clk
add wave -noupdate /horizontal_convolution_testbench/finished
add wave -noupdate /horizontal_convolution_testbench/writes
add wave -noupdate /horizontal_convolution_testbench/reads
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {633452 ps} {633803 ps}
