module cu
  (input                                   clk_i
  ,input                                   reset_i
  ,input           [2:0][2:0][7:0]         fil_coe
  ,input           [2:0][7:0]              data_i
  ,output          [7:0]                   psum_3
  ,input v_i_in
  ,input v_i_fil
  ,output ready_o_in
  ,output v_o
  ,output finished
  );
  
  logic [19:0] temp_result;
  logic r_o_fil,r_o_in,valid_o;
  logic en_s,edge_mux;
  logic [2:0][2:0][15:0] mul_result;
  logic [2:0][1:0][8:0]  dff_result;
  logic [9:0] r_counter_r,r_counter_n,c_counter_r,c_counter_n;
  logic [7:0] temp_out;
  logic [2:0][2:0][8:0] fil_ext;
  
  assign ready_o_in = r_o_in;
  assign v_o = valid_o && !finished;
  
  logic ps, ns;
  parameter rest = 0;
  parameter comp = 1;
  
  assign edge_mux = !(r_counter_r < 1||r_counter_r==479||c_counter_r < 1||c_counter_r==639);

  always_comb begin
  case(ps)
  rest: begin
  if(v_i_fil==0)begin
  valid_o = 0;
  r_o_in = 0;
  en_s = 0;
  end else if(v_i_in==0)begin
  valid_o = 0;
  r_o_in = 1;
  en_s = 0;
  end else begin
  valid_o = 0;
  r_o_in = 1;
  en_s = 0;  
  end
  end

  comp: begin
  if(v_i_in&v_i_fil&c_counter_r > 1)begin
  valid_o = 1;
  r_o_in = 1;
  en_s = 1;
  end else if(v_i_in&v_i_fil&c_counter_r<2)begin
  valid_o = 1;
  r_o_in = 1;
  en_s = 1;
  end else if(v_i_fil)begin
  valid_o = 1;
  r_o_in = 1;
  en_s = 1;
  end else begin
  valid_o = 1;
  r_o_in = 0;
  en_s = 0;
  end
  end
  endcase
  end    
  

  always_comb begin
  case(ps)
  rest: begin
  if(v_i_fil&v_i_in) begin
  ns = comp;
  r_counter_n = 0;
  c_counter_n = 0;
  end else begin
  ns = ps;
  r_counter_n = r_counter_r;
  c_counter_n = c_counter_r;
  end
  end
  
  comp: begin
  if (v_i_in&v_i_fil&c_counter_r<639)begin
  ns = ps;
  c_counter_n = c_counter_r + 1;
  r_counter_n = r_counter_r;
  end else if(v_i_in&v_i_fil&r_counter_r<479)begin
  ns = ps;
  c_counter_n = 0;
  r_counter_n = r_counter_r + 1;  
  end else if(~v_i_in&v_i_fil)begin
  ns = ps;
  r_counter_n = 0;
  c_counter_n = 0;
  end else begin
  ns = rest;
  r_counter_n = r_counter_r;
  c_counter_n = c_counter_r;
  end
  end
  endcase
  end

 
  
  always_ff @(posedge clk_i) begin
  if (!reset_i)begin
  ps<= rest;
  r_counter_r <= 0;
  c_counter_r <= 0;
  end else begin
  ps <= ns;
  r_counter_r <= r_counter_n;
  c_counter_r <= c_counter_n;  
  end
  end

  sign_extend #(.len(8)) ext_1(fil_coe[0][0],fil_ext[0][0]);
  sign_extend #(.len(8)) ext_2(fil_coe[0][1],fil_ext[0][1]);
  sign_extend #(.len(8)) ext_3(fil_coe[0][2],fil_ext[0][2]);
  sign_extend #(.len(8)) ext_4(fil_coe[1][0],fil_ext[1][0]);
  sign_extend #(.len(8)) ext_5(fil_coe[1][1],fil_ext[1][1]);
  sign_extend #(.len(8)) ext_6(fil_coe[1][2],fil_ext[1][2]);
  sign_extend #(.len(8)) ext_7(fil_coe[2][0],fil_ext[2][0]);
  sign_extend #(.len(8)) ext_8(fil_coe[2][1],fil_ext[2][1]);
  sign_extend #(.len(8)) ext_9(fil_coe[2][2],fil_ext[2][2]);
  
  // row 0
  // PE(0,0)
  assign mul_result[0][0] = {1'b0,data_i[0]}*fil_ext[0][0];
  DFlipFlop dff_00(.clock_i (clk_i), .reset_i (reset_i), .en_i(en_s), .data_i({1'b0,data_i[0]}), .data_o(dff_result[0][0]));
  //PE(0,1)
  assign mul_result[0][1] = dff_result[0][0]*fil_ext[0][1];
  DFlipFlop	dff_01(.clock_i (clk_i), .reset_i (reset_i), .en_i(en_s), .data_i(dff_result[0][0]), .data_o(dff_result[0][1]));
  //PE(0,2)
  assign mul_result[0][2] = dff_result[0][1]*fil_ext[0][2];
  
  // row 1
  // PE(1,0)
  assign mul_result[1][0] = {1'b0,data_i[1]}*fil_ext[1][0];
  DFlipFlop dff_10(.clock_i (clk_i), .reset_i (reset_i), .en_i(en_s), .data_i({1'b0,data_i[1]}), .data_o(dff_result[1][0]));
  // PE(1,1)
  assign mul_result[1][1] = dff_result[1][0]*fil_ext[1][1];
  DFlipFlop	dff_11(.clock_i (clk_i), .reset_i (reset_i), .en_i(en_s), .data_i(dff_result[1][0]), .data_o(dff_result[1][1]));
  // PE(1,2)
  assign mul_result[1][2] = dff_result[1][1]*fil_ext[1][2];
  
  // row 2
  // PE(2,0)
  assign mul_result[2][0] = {1'b0,data_i[2]}*fil_ext[2][0];
  DFlipFlop	dff_20(.clock_i (clk_i), .reset_i (reset_i), .en_i(en_s), .data_i({1'b0,data_i[2]}), .data_o(dff_result[2][0]));
  // PE(2,1)
  assign mul_result[2][1] = dff_result[2][0]*fil_ext[2][1];  
  DFlipFlop	dff_21 (.clock_i (clk_i), .reset_i (reset_i), .en_i(en_s), .data_i(dff_result[2][0]), .data_o(dff_result[2][1]));
  // PE(2,2)
  assign mul_result[2][2] = dff_result[2][1]*fil_ext[2][2];  
  
  assign temp_result = mul_result[0][0] + mul_result[0][1] + mul_result[0][2] + mul_result[1][0] + mul_result[1][1] + mul_result[1][2] + mul_result[2][0] + mul_result[2][1] + mul_result[2][2];

  always_comb begin
  if(temp_result[19]==1) begin
  temp_out = 8'b0;
  end else if (temp_result>20'd255) begin
  temp_out = 8'd255;
  end else begin
  temp_out = temp_result[7:0];
  end
  end

  assign psum_3 = (edge_mux) ? temp_out:0;
  assign finished = (r_counter_r==479&c_counter_r==639);
  
endmodule

module cu_testbench();

  logic clk_i,reset_i,v_i_in,v_i_fil,ready_o_in,v_o,finished;
  logic [2:0][2:0][7:0]         fil_coe;
  logic [2:0][7:0]              data_i;
  logic [7:0]                   psum_3;
  logic [19:0]                  i;
  
  cu dut(clk_i,reset_i,fil_coe,data_i,psum_3,v_i_in,v_i_fil,ready_o_in,v_o,finished);
  
  initial begin
  clk_i = 1;
  i = 0;
  end
  
parameter CLOCK_PERIOD = 100;

always begin
	#(CLOCK_PERIOD/2); clk_i = ~clk_i;
end

initial begin
	#CLOCK_PERIOD; reset_i <= 0; fil_coe = {{8'd3,8'd1,8'd27},{8'd6,8'd0,8'd33},{8'd2,8'd14,8'd52}}; data_i <= {8'd16,8'd2,8'd1}; v_i_in <= 0; v_i_fil <= 0;
	#CLOCK_PERIOD; reset_i <= 1;
	#CLOCK_PERIOD; v_i_in <= 1; v_i_fil <= 1;	
	#CLOCK_PERIOD; data_i <= {8'd1,8'd16,8'd2};
	#CLOCK_PERIOD; data_i <= {8'd2,8'd16,8'd1};
	#CLOCK_PERIOD; data_i <= {8'd6,8'd4,8'd7};
	#CLOCK_PERIOD; data_i <= {8'd1,8'd8,8'd2};
	#CLOCK_PERIOD; data_i <= {8'd255,8'd255,8'd255};
	#CLOCK_PERIOD; data_i <= {8'd2,8'd16,8'd1};
	for (i=0;i< 307255;i++)begin 
	#CLOCK_PERIOD;
	end
	$stop;
end

endmodule
