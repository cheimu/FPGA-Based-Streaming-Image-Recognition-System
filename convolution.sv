module convolution(clk_i, reset_i, pixel_i, request_o, fil_sw_i, conv_o, v_o, finished);

input logic clk_i, reset_i;
input logic [7:0] pixel_i;
output logic request_o, v_o, finished;
output logic [7:0] conv_o;
input logic [1:0] fil_sw_i;

logic [2:0][7:0] pixel_o;
logic conv_request;
logic fifo_v_o,fil_v_o;
logic [2:0][2:0][7:0] fil_coe;

fifo_route fifos(clk_i, reset_i, pixel_i, pixel_o, conv_request, fifo_v_o, request_o);

cu convol(clk_i, reset_i, fil_coe, pixel_o, conv_o, fifo_v_o, fil_v_o, conv_request, v_o, finished);

filter_sel filters(clk_i, reset_i, fil_sw_i, fil_coe, fil_v_o);

endmodule 

module convolution_testbench();

logic clk_i, reset_i;
logic [7:0] pixel_i;
logic request_o, v_o, finished;
logic [7:0] conv_o;
logic [1:0] fil_sw_i;
logic [19:0] i;

convolution dut(clk_i, reset_i, pixel_i, request_o, fil_sw_i, conv_o, v_o, finished);

  initial begin
  clk_i = 1;
  i = 0;
  end
  
parameter CLOCK_PERIOD = 2;

always begin
	#(CLOCK_PERIOD/2); clk_i = ~clk_i;
end

	
	logic [31:0] writes;
	logic [31:0] reads;
	always_ff @(posedge clk_i) begin
		if (!reset_i) begin writes <= 0; reads <= 0; end
		if (v_o) writes <= writes + 1;
		if (request_o) reads <= reads + 1;
	end

initial begin
	#CLOCK_PERIOD; reset_i <= 0;
	#CLOCK_PERIOD;
	for (i = 0; i < 1000; i++) begin
		#CLOCK_PERIOD;
	end
	#CLOCK_PERIOD; reset_i <= 1; fil_sw_i <= 00; pixel_i <= 1;
	for (i = 1; i < 320000; i++) begin
	#CLOCK_PERIOD; pixel_i <= i[7:0];
	end
	#CLOCK_PERIOD; 
	#CLOCK_PERIOD;
	$stop;
end

endmodule
