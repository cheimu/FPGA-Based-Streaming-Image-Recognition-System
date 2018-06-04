module vga_sdram_module(
	input clk, // must be clock_50
	input reset,
	input [9:0] x, y,
	output [7:0] gray,
	input [7:0] sdram_rd_data,
	input sdram_rd_enable
	);

	logic [9:0] write_addr, read_addr;
	logic [7:0] write_data, read_data;
	logic write;
	
	logic clk_25;
	// 25 MHz
	always_ff @(posedge clk) begin
		if (reset) clk_25 <= 0;
		else clk_25 <= ~clk_25;
	end
	
	// use a shifted clock for the line buffer so that it updates within a closer cycle
	logic clk_25_shifted_90;
	assign clk_25_shifted_90 = clk_25 ^ clk;
	
	// we want to read from sdram once per 25 MHz cycle, since VGA updates one pixel in that time
	//assign sdram_rd_enable = ~(clk_25 | clk);
	
/*******************************************************************************
											 Line Buffer
*******************************************************************************/
	reg		[7:0]		temp_buf;
	
	always_ff@(negedge clk_25) begin
		temp_buf <= sdram_rd_data;
	end
	
	line_cache line_buf(
		clk_25_shifted_90,
		x-1,
		temp_buf,
		~sdram_rd_enable,
		x,
		gray
	);
	
endmodule

module vga_sdram_module_testbench();

	logic clk, reset;
	logic [9:0] x, y;
	wire [7:0] gray;
	logic [7:0] sdram_rd_data;
	wire sdram_rd_enable;
	
	vga_sdram_module dut(
	clk, // must be clock_50
	reset,
	x, y,
	gray,
	sdram_rd_data,
	sdram_rd_enable
	);
	
	parameter CLOCK_PERIOD=100;
	
	initial clk <= 1;
	initial x <= 0;
	
	always begin
		#(CLOCK_PERIOD/2); clk <= ~clk;
	end
	
	initial begin
		reset <= 1;
		#(CLOCK_PERIOD);
		reset <= 0;
		#(CLOCK_PERIOD);
		for (int i = 0; i < 1024; i++) begin
			#(CLOCK_PERIOD);
			sdram_rd_data <= i; x <= x+1; if (x == 640) x <= 0;
			#(CLOCK_PERIOD);
		end
		$stop;
	end

endmodule
