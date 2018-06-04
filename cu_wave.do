onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /cu_testbench/clk_i
add wave -noupdate -radix decimal /cu_testbench/reset_i
add wave -noupdate -radix decimal /cu_testbench/v_i_in
add wave -noupdate -radix decimal /cu_testbench/v_i_fil
add wave -noupdate -radix decimal /cu_testbench/ready_o_in
add wave -noupdate -radix decimal /cu_testbench/v_o
add wave -noupdate -radix decimal /cu_testbench/fil_coe
add wave -noupdate -radix decimal /cu_testbench/data_i
add wave -noupdate -radix unsigned /cu_testbench/psum_3
add wave -noupdate -radix decimal /cu_testbench/finished
add wave -noupdate -radix unsigned /cu_testbench/dut/temp_result
add wave -noupdate -radix unsigned /cu_testbench/dut/temp_out
add wave -noupdate -radix unsigned /cu_testbench/dut/r_counter_r
add wave -noupdate -radix unsigned /cu_testbench/dut/c_counter_r
add wave -noupdate /cu_testbench/dut/finished
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27467 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 102
configure wave -valuecolwidth 145
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
WaveRestoreZoom {139344 ps} {140350 ps}
