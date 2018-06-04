module raw_2_grayscale_filter(
	input clk, reset, enable,
	input [9:0] raw_data,
	output [7:0] grayscale_data
	);

	logic [641:0][9:0] buffer;
	
	always_ff @(posedge clk) begin
		if (reset) buffer <= {642{10'b0}};
		else if (enable) buffer <= {buffer[640:0], raw_data};
	end
	
	logic [15:0] sum;
	assign sum = buffer[0] + buffer[1] + buffer[640] + buffer[641];
	
	assign grayscale_data = (|sum[15:14]) ? 8'd255 : sum[13:6];
	
endmodule

module raw_2_grayscale_filter_testbench();

	logic clk, reset, enable;
	logic [9:0] raw_data;
	wire [7:0] grayscale_data;

raw_2_grayscale_filter dut(
	clk, reset, enable,
	raw_data,
	grayscale_data
	);
	
	initial begin
		clk <= 0;
	end
	
	parameter CLOCK_PERIOD = 100;
	always begin
		#(CLOCK_PERIOD/2); clk <= ~clk;
	end
	
	initial begin
		reset <= 1; raw_data <= 8; enable <= 1;
		#(CLOCK_PERIOD);
		reset <= 0;
		for (int i = 8; i < 1024; i++) begin
			raw_data <= raw_data + 1;
			#(CLOCK_PERIOD);
		end
		$stop;
	end
	
endmodule
