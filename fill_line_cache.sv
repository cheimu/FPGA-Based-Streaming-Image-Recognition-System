module fill_line_cache(
	input clk, reset, 
	output rd_enable, finished,
	input [7:0] input_data
	);

	parameter WIDTH=640;
	
	logic [9:0] write_addr;
	logic [7:0] write_data;
	logic write;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			write_addr <= 0;
		end else if (write_addr == WIDTH) begin
			write_addr <= WIDTH;
		end else begin
			write_addr <= write_addr + 1;
		end
	end

	always_ff @(posedge clk) begin
		write_data <= input_data;
	end
	
	always_ff @(posedge clk) begin
		if (reset) write <= 0;
		else write <= 1;
	end
	
	
line_cache line(clk, 
	write_addr,
	write_data,
	write, 			// Write when high
	read_adx,
	odata);
	
endmodule
