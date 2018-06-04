module horizontal_convolution(
	input clk, reset,
	output read_request, write_request, finished,
	input [7:0] pixel_i,
	output [7:0] pixel_o,
	input sw);

	logic [1:0] ps, ns;
	parameter DELAY=2'b00, GO=2'b01, STOP=2'b10;
	
	always_ff @(posedge clk) begin
		if (reset) ps <= DELAY;
		else ps <= ns;
	end

	parameter [15:0] delay_amount = 16'h00FF;
	
	logic [15:0] delay_counter;
	always_ff @(posedge clk) begin
		if (reset) delay_counter <= delay_amount;
		else if (ps == DELAY) delay_counter <= (delay_counter == 16'h0) ? 16'h0 : delay_counter - 1;
		else if (ps == STOP) delay_counter <= (delay_counter == delay_amount) ? delay_amount : delay_counter + 1;
	end
	
	logic [31:0] read_counter;
	always_ff @(posedge clk) begin
		if (reset) read_counter <= 0;
		else if (ps == GO) read_counter <= read_counter + 1;
	end

	always_comb begin
		case (ps)
			DELAY: ns <= ((delay_counter == 0) ? GO : DELAY);
			GO: ns <= ((read_counter == (640*480 - 1)) ? STOP : GO);
			STOP: ns <= STOP;
			default: ns <= STOP;
		endcase
	end
	
	assign read_request = (ps == GO);
	logic wr_ready;
	always_ff @(posedge clk) begin
		wr_ready <= read_request;
	end
		
	assign write_request = wr_ready;
	
	logic [2:0][7:0] buffer;
	always_ff @(posedge clk) begin
		buffer <= {buffer[1:0], pixel_i};
	end
	
	logic [15:0] temp;
	assign temp = (sw) ? buffer[1] : buffer[0] - buffer[2];
	assign pixel_o = (temp[15] == 1) ? 0 : ((|temp[14:8] == 1) ? 255 : temp[7:0]);
	assign finished = ((ps == STOP) && (delay_counter == delay_amount));
	
endmodule

module horizontal_convolution_testbench();
	logic clk, reset;
	wire read_request, write_request, finished;
	logic [7:0] pixel_i;
	wire [7:0] pixel_o;
	logic sw;

	horizontal_convolution dut(clk, reset, read_request, write_request, finished, pixel_i, pixel_o, sw);
	
	initial clk <= 1;
	parameter CLOCK_PERIOD = 2;
	always begin
		#(CLOCK_PERIOD/2); clk <= ~clk;
	end
	
	logic [31:0] writes;
	logic [31:0] reads;
	always_ff @(posedge clk) begin
		if (reset) begin writes <= 0; reads <= 0; end
		if (write_request) writes <= writes + 1;
		if (read_request) reads <= reads + 1;
	end
	
	initial begin
		reset <= 1; sw <= 1;
		#CLOCK_PERIOD; reset <= 0;
		for (int i = 0; i < 480; i++) begin
			for (int j = 0; j < 640; j++) begin
				pixel_i <= (j > 240) ? 255 : 0; #(CLOCK_PERIOD);
			end
		end
		for (int i =0; i < 10000; i++) #(CLOCK_PERIOD);
		$stop;
	end
endmodule

