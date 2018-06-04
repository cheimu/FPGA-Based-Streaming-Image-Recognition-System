module square_convolution(
	input clk, reset,
	output read_request, write_request, finished,
	input [7:0] pixel_i,
	output [7:0] pixel_o,
	input [1:0] sw,
	input max_en);

	logic [1:0] ps, ns;
	logic [7:0] pixel_temp;
	parameter DELAY=2'b00, R_W=2'b01, W = 2'b10, STOP=2'b11;
	logic [31:0] write_counter;
	logic wr_ready;
	logic [2:0][7:0] max_pool_buffer;
	
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
		if (reset) begin 
		read_counter <= 0;
		write_counter <= 0;
		end else if (ps == R_W) begin 
		read_counter <= read_counter + 1;
		write_counter <= (wr_ready == 1) ? (write_counter+1):write_counter;
		end else if (ps == W) write_counter <= write_counter + 1;
	end

	always_comb begin
		case (ps)
			DELAY: ns = ((delay_counter == 0) ? R_W : DELAY);
			R_W: ns = ((read_counter == (640*480 - 1)) ? W : R_W);
			W: ns = ((write_counter == (640*480 - 1)) ? STOP : W);
			STOP: ns = STOP;
			//default: ns = STOP;
		endcase
	end
	
	assign read_request = (ps == R_W);

	assign wr_ready = (read_counter < 1283) ? 0:1;
		
	assign write_request = wr_ready && (ps != STOP);
	
	logic [1282:0][7:0] buffer;
	always_ff @(posedge clk) begin
		buffer <= {buffer[1282:0], pixel_i};
	end
	
	logic signed [2:0][2:0][8:0] fil_ext;
	logic signed [2:0][2:0][8:0] conv_d;
	logic v_filter;
	
	
	assign conv_d[0][0] = {1'b0,buffer[0]};
	assign conv_d[0][1] = {1'b0,buffer[1]};
	assign conv_d[0][2] = {1'b0,buffer[2]};
	assign conv_d[1][0] = {1'b0,buffer[640]};
	assign conv_d[1][1] = {1'b0,buffer[641]};
	assign conv_d[1][2] = {1'b0,buffer[642]};
	assign conv_d[2][0] = {1'b0,buffer[1280]};
	assign conv_d[2][1] = {1'b0,buffer[1281]};
	assign conv_d[2][2] = {1'b0,buffer[1282]};	
	
	filter_sel filters(clk, !reset, sw, fil_ext, v_filter);
	logic signed [31:0] temp;
	
	logic signed [2:0][2:0][18:0] mults;
	
	assign mults[0][0] = $signed(fil_ext[0][0])*$signed(conv_d[0][0]);
	assign mults[0][1] = $signed(fil_ext[0][1])*$signed(conv_d[0][1]);
	assign mults[0][2] = $signed(fil_ext[0][2])*$signed(conv_d[0][2]);
	assign mults[1][0] = $signed(fil_ext[1][0])*$signed(conv_d[1][0]);
	assign mults[1][1] = $signed(fil_ext[1][1])*$signed(conv_d[1][1]);
	assign mults[1][2] = $signed(fil_ext[1][2])*$signed(conv_d[1][2]);
	assign mults[2][0] = $signed(fil_ext[2][0])*$signed(conv_d[2][0]);
	assign mults[2][1] = $signed(fil_ext[2][1])*$signed(conv_d[2][1]);
	assign mults[2][2] = $signed(fil_ext[2][2])*$signed(conv_d[2][2]);
	
	assign temp = $signed(mults[0][0]) + 
					  $signed(mults[0][1]) +
					  $signed(mults[0][2]) +
					  $signed(mults[1][0]) +
					  $signed(mults[1][1]) +
					  $signed(mults[1][2]) +
					  $signed(mults[2][0]) +
					  $signed(mults[2][1]) +
					  $signed(mults[2][2]);

  always_comb begin
  if(temp[31] == 1) begin // negative
  pixel_temp = 8'b0;
  end else if (|temp[31:8]) begin // positive greater than 0
  pixel_temp = 8'd255;
  end else begin
  pixel_temp = temp[7:0];
  end
  end
  
  assign pixel_o = (max_en) ? max_pool_o:pixel_temp;
  
	always_ff @(posedge clk) begin
		max_pool_buffer <= {max_pool_buffer[1:0], pixel_temp};
	end 
	
  assign finished = ((ps == STOP) && (delay_counter == delay_amount));
  
  
  comp max_pool_simple(max_pool_buffer, max_pool_o);
  
endmodule

module sign_extend #(parameter len) (data_i, data_o);
input logic [len-1:0] data_i;
output logic [len:0] data_o;

assign data_o = {data_i[len-1],data_i};

endmodule

module square_convolution_testbench();
	logic clk, reset;
	wire read_request, write_request, finished;
	logic [7:0] pixel_i;
	wire [7:0] pixel_o;
	logic [1:0] sw;

	square_convolution dut(clk, reset, read_request, write_request, finished, pixel_i, pixel_o, sw);
	
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
		reset <= 1; sw <= 2'b01;
		#CLOCK_PERIOD; reset <= 0;
		for (int i = 0; i < 480; i++) begin
			for (int j = 0; j < 640; j++) begin
				pixel_i <= (i == 240 && j == 320) ? 255 : 0; #(CLOCK_PERIOD);
			end
		end
		for (int i =0; i < 10000; i++) #(CLOCK_PERIOD);
		$stop;
	end
endmodule

