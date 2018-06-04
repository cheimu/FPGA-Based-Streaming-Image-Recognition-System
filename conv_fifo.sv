// This module is used to store lines of image data for the purpose of convolutions.
module conv_fifo #(parameter LEN=640) (
	input clk, reset, enable, // Whenever enable is high, shifts data into fifo
	output logic valid, // True when first, second and third can be read from.
	input [7:0] data, // Entry point for new data
	output [7:0] first, second, third // Provide access to reading the first elements in fifo for convolution
	
	);
	
	// The buffer to store all the data in
	logic [LEN-1:0][7:0] buffer;
	logic [15:0] size;
	
	assign valid = (LEN == size);
	
	always_ff @(posedge clk) begin
		if (reset) begin
			size <= 0;
			buffer <= {LEN{8'b0}};
		end else if (enable) begin
			if (LEN > size) size <= size + 1;
			else size <= LEN;
			buffer <= {buffer[LEN-2:0], data};
		end
	end
	
	assign first = buffer[LEN-1];
	assign second = buffer[LEN-2];
	assign third = buffer[LEN-3];
	
endmodule


//The testbench for above module
module conv_fifo_testbench(); 
	logic clk; 
	logic reset; 
	logic enable; 
	logic valid; 
	logic [7:0] data;
	logic [7:0] first, second, third;
	
	conv_fifo #(.LEN(5)) dut (clk, reset, enable, valid, data, first, second, third);
	
	// Set up the clock. 
	parameter CLOCK_PERIOD = 100; 
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; 
	end
	
	// Set up the inputs to the design. Each line is a clock cycle. 
	initial begin
	
	reset <= 0; 				@(posedge clk); 
 	reset <= 1;					@(posedge clk); 
	reset <= 0;					@(posedge clk); 
	data <= 1; 					@(posedge clk);
									@(posedge clk); 
									@(posedge clk); 				
	enable <= 1;				@(posedge clk); 
	enable <= 0;				@(posedge clk); 
									@(posedge clk);
	data <= 2;					@(posedge clk);
		 							@(posedge clk); 
									@(posedge clk); 
	enable <= 1;	  			@(posedge clk); 
	enable <= 0;				@(posedge clk); 
									@(posedge clk); 
	data <= 3;					@(posedge clk); 
									@(posedge clk);
									@(posedge clk);
	enable <= 1;				@(posedge clk);
	enable <= 0;				@(posedge clk);
									@(posedge clk);
	data <= 4;			 		@(posedge clk);
									@(posedge clk);
									@(posedge clk);
	enable <= 1;				@(posedge clk);
	enable <= 0;				@(posedge clk);
									@(posedge clk);
	data <= 5;					@(posedge clk);
									@(posedge clk);
									@(posedge clk);
	enable <= 1;				@(posedge clk);
	enable <= 0;				@(posedge clk);
									@(posedge clk);
									@(posedge clk);
		$stop; // End the simulation. 
	end 
endmodule	