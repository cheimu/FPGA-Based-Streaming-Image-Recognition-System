onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vga_sdram_module_testbench/clk
add wave -noupdate /vga_sdram_module_testbench/gray
add wave -noupdate /vga_sdram_module_testbench/reset
add wave -noupdate /vga_sdram_module_testbench/sdram_rd_data
add wave -noupdate /vga_sdram_module_testbench/sdram_rd_enable
add wave -noupdate /vga_sdram_module_testbench/x
add wave -noupdate /vga_sdram_module_testbench/y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7 ps} 0}
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
WaveRestoreZoom {0 ps} {905 ps}
