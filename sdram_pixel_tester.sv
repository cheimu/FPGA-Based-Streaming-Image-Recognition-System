module sdram_pixel_tester(
	input clk, reset,
	output write_enable, write_finished,
	output [7:0] write_data);
	
	parameter [1:0] RESET = 2'b00, WRITE = 2'b01, READ = 2'b10, WAIT = 2'b11;
	logic [1:0] ps, ns;
	assign write_finished = (ps == READ || ps == WAIT) ? 1 : 0;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= RESET;
		end else begin
			ps <= ns;
		end
	end
	
	logic [9:0] rx, ry; // x and y pixel coordinates, changes ever 25 mhz
	logic clk_25;
	logic [1:0] clk_25_edges;
	
	// 25 mhz clock for pixel coords
	always_ff @(posedge clk) begin
		if (reset) clk_25 <= 0;
		else clk_25 <= ~clk_25;
	end
	
	// pixel coords
	always_ff @(posedge clk) begin
		if (reset || ps == RESET) begin
			rx <= 0;
			ry <= 0;
		end else if(ps == WRITE) begin
			if (rx == 639 && ry == 479) begin
				rx <= 0; ry <= 0;
			end else if (rx == 639) begin
				rx <= 0; ry <= ry + 1;
			end else begin
				rx <= rx + 1; ry <= ry;
			end
		end
	end

	// handle writing frame data
	logic [7:0] write_counter;
	always_ff @(posedge clk) begin
		case (ps)
			RESET: write_counter <= 0;
			WRITE: begin
				if (rx < 320 && ry < 240) write_counter <= 0;
				else if (rx >= 320 && ry < 240) write_counter <= 85;
				else if (rx < 320 && ry >= 240) write_counter <= 170;
				else write_counter <= 255;
			end
			READ: write_counter <= 0;
			WAIT: write_counter <= 0;
		endcase
	end
	
	// handle state machine
	always_comb begin
		case(ps)
			RESET: ns = WRITE;
			WRITE: ns = (rx == 639 && ry == 479) ? WAIT : WRITE;
			READ: ns = RESET;
			WAIT: ns = WAIT;
		endcase
	end
	
	assign write_enable = (ps == WRITE) ? 1 : 0;
	assign write_data = (ps == WRITE) ? write_counter : 0;
	
endmodule




module sdram_pixel_tester_testbench();

	logic clk, reset;
	logic read_enable, write_enable, write_finished;
	wire [7:0] write_data;
	wire [9:0] x, y;
	logic [9:0] pixel_x;
	logic [8:0] pixel_y;

	sdram_pixel_tester dut(clk, reset, write_enable, write_finished, write_data);
	
	initial
		clk <= 1;
		
	parameter CLOCK_PERIOD = 2;
	always begin
		#(CLOCK_PERIOD/2); clk <= ~clk;
	end
	
	initial begin
		reset <= 1; pixel_x <= 1; pixel_y <= 1;
		#(CLOCK_PERIOD);
		reset <= 0;
		#(CLOCK_PERIOD);
		for (int i = 0; i < 700000; i++) begin
			#(CLOCK_PERIOD);
		end
		pixel_x <= 0; pixel_y <= 0;
		for (int i = 0; i < 3000; i++) begin
			#(CLOCK_PERIOD);
		end
		$stop;
	end
	
endmodule
