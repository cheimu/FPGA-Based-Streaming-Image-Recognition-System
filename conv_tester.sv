module conv_tester(
	input clk, reset,
	output read_enable, write_enable,
	input [7:0] gray_in,
	output [7:0] gray_out,
	output conv_finished
	);

	logic [31:0] counter;
	
	assign gray_out = gray_in;
	
	assign conv_finished = (counter > 640*480);
	
	assign read_enable = (!reset) && (640*480 >= counter);
	assign write_enable = (!reset) && (640*480 >= counter);
	
	always_ff @(posedge clk) begin
		if (reset) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	
endmodule
