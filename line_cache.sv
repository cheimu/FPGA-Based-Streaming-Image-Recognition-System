// Module courtesy of Jared
module line_cache(
	input							clk,
	input				[9:0]		write_adx,
	input				[7:0]		idata,
	input							we, 			// Write when high
	input				[9:0]		read_adx,
	output	logic	[7:0]		odata
);
	parameter WIDTH = 640;
	
	logic		[7:0]		mem [WIDTH-1:0];
	
	//initial mem = '{WIDTH{8'b0}};
	
	always_ff@(posedge clk) begin
		odata = mem[read_adx];
	end
	
	always_ff@(posedge clk) begin
		if(we) begin
			mem[write_adx] <= idata;
		end
		else begin
			mem[write_adx] <= mem[write_adx];
		end
	end
endmodule

module line_cache_testbench();

	logic clk;
	logic [9:0] write_addr;
	logic [7:0] write_data;
	logic write;
	logic [9:0] read_addr;
	wire [7:0] read_data;
	
	line_cache dut(clk, write_addr, write_data, write, read_addr, read_data);
	
	parameter CLOCK_PERIOD=100;
	initial clk <= 1;
	always begin
		#(CLOCK_PERIOD/2); clk <= ~clk;
	end
	
	initial begin
		for (int i = 0; i < 640; i++) begin
			write_addr <= i;
			write_data <= i;
			write <= 1;
			#(CLOCK_PERIOD);
		end
		write <= 0;
		for (int i = 0; i < 640; i++) begin
			read_addr <= i;
			#(CLOCK_PERIOD);
		end
		$stop;
	end
	
endmodule

