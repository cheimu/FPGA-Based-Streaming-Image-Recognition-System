module convert_raw_frame_to_gray(
	input clk, reset,
	output read_en, write_en, finished,
	input [9:0] raw_data,
	output [7:0] gray_data);
	
	logic [31:0] count; // number of pixels processed 
	parameter FRAME_LEN=640*480;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			count <= 0;
		end else if (count == FRAME_LEN) begin
			count <= count;
		end else begin
			count <= count + 1;
		end
	end
	
	assign finished = (count == FRAME_LEN);
	
	assign read_en = ~finished;
	assign write_en = ~finished;
	
	raw_grayscale converter(raw_data, gray_data);
	
endmodule

module convert_raw_frame_to_gray_testbench();

	reg clk, reset;
	wire read_en, write_en, finished;
	reg [9:0] raw_data;
	wire [7:0] gray_data;
	
	convert_raw_frame_to_gray dut(clk, reset, read_en, write_en,
		finished, raw_data, gray_data);
		
	// Set up the clock. 
	parameter CLOCK_PERIOD = 2; 
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; 
	end
	
	initial begin
		reset <= 1;
		#(CLOCK_PERIOD);
		#(CLOCK_PERIOD); reset <= 0;
		for (int i = 0; i < 400000; i++) begin
			#(CLOCK_PERIOD); raw_data <= {i[4:0], i[4:0]};
		end
		$stop;
	end
	
endmodule
