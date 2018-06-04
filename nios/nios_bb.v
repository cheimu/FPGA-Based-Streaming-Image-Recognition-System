
module nios (
	address_sig_external_connection_export,
	clk_clk,
	data_sig_external_connection_export,
	interlock_input_external_connection_export,
	led_pio_external_connection_export,
	q_sig_external_connection_export,
	reset_reset_n,
	switches_external_connection_export,
	wren_external_connection_export);	

	output	[7:0]	address_sig_external_connection_export;
	input		clk_clk;
	output	[15:0]	data_sig_external_connection_export;
	output	[7:0]	interlock_input_external_connection_export;
	output	[7:0]	led_pio_external_connection_export;
	input	[15:0]	q_sig_external_connection_export;
	input		reset_reset_n;
	input	[7:0]	switches_external_connection_export;
	output		wren_external_connection_export;
endmodule
