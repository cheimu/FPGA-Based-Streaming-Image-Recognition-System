/*
 * This module will write to SDRAM starting at address 0 incrementing values,
 * then it will slowly read back from SDRAM the values.
 */
module sdram_tester(
	input clk, reset,
	output read_enable, write_enable,
	output [7:0] write_data);

	parameter [1:0] RESET = 2'b00, WRITE = 2'b01, READ = 2'b10, DONE = 2'b11;
	logic [1:0] ps, ns;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= RESET;
		end else begin
			ps <= ns;
		end
	end
	
	logic [31:0] delay_counter;
	always_ff @(posedge clk) begin
		if (reset)
			delay_counter <= 0;
		else
			delay_counter <= delay_counter + 1;
	end
	
	logic [7:0] write_counter, read_counter;
	always_ff @(posedge clk) begin
		case (ps)
			RESET: write_counter <= 254;
			WRITE: write_counter <= write_counter - 1;
			READ: write_counter <= 0;
			DONE: write_counter <= 0;
		endcase
	end
	
	logic [1:0] edges;
	
	always_ff @(posedge clk) begin
		edges <= {edges[0], delay_counter[24]};
		if (reset) read_counter <= 0;
		else if (edges == {1'b0, 1'b1}) //posedge delay_counter[]
			case (ps)
				RESET: read_counter <= 0;
				WRITE: read_counter <= 0;
				READ: read_counter <= read_counter + 1;
				DONE: read_counter <= 0;
			endcase
	end
	
	always_comb begin
		case(ps)
			RESET: ns = WRITE;
			WRITE: ns = (write_counter == 255) ? READ : WRITE;
			READ: ns = (read_counter == 255) ? DONE : READ;
			DONE: ns = DONE;
		endcase
	end
	
	assign write_enable = (ps == WRITE);
	logic [7:0] prev_read_counter, temp_read_counter;
	
	always_ff @(posedge clk) begin
		if (reset) begin 
			prev_read_counter <= 0;
			temp_read_counter <= 0;
		end else begin
			temp_read_counter <= read_counter;
			prev_read_counter <= temp_read_counter;
		end
	end
	
	assign read_enable = (prev_read_counter != temp_read_counter) ? 1 : 0;
	
	assign write_data = (ps == WRITE) ? write_counter : 0;
	
endmodule

module sdram_tester_testbench();

	logic clk, reset;
	logic read_enable, write_enable;
	logic [7:0] write_data;

	sdram_tester dut(clk, reset, read_enable, write_enable, write_data);
	
	initial
		clk <= 1;
		
	parameter CLOCK_PERIOD = 10;
	always begin
		#(CLOCK_PERIOD/2); clk <= ~clk;
	end
	
	initial begin
		reset <= 1;
		#(CLOCK_PERIOD);
		reset <= 0;
		#(CLOCK_PERIOD);
		for (int i = 0; i < 2048; i++) begin
			#(CLOCK_PERIOD);
		end
		$stop;
	end
	
endmodule
