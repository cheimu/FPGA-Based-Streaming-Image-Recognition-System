onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /convert_raw_frame_to_gray_testbench/clk
add wave -noupdate /convert_raw_frame_to_gray_testbench/finished
add wave -noupdate /convert_raw_frame_to_gray_testbench/gray_data
add wave -noupdate /convert_raw_frame_to_gray_testbench/raw_data
add wave -noupdate /convert_raw_frame_to_gray_testbench/read_en
add wave -noupdate /convert_raw_frame_to_gray_testbench/reset
add wave -noupdate /convert_raw_frame_to_gray_testbench/write_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {107 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {547 ps}
