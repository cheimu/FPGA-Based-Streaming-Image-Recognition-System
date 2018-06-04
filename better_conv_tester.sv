module better_conv_tester(
	input clk, reset,
	output read_enable, write_enable,
	input [7:0] gray_in,
	output [7:0] gray_out,
	output conv_finished
	);
	
	logic enable;
	logic [31:0] count;
	
	assign read_enable = enable && (!conv_finished);
	assign write_enable = enable && (!conv_finished);
	assign conv_finished = (count >= 640*480);
	
	assign gray_out = gray_in;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			enable <= 0;
		end else begin
			enable <= ~enable;
		end
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			count <= 0;
		end else begin
			if (enable) count <= count;
			else count <= count + 1;
		end
	end
	
endmodule
