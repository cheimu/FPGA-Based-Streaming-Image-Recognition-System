module max_pool(
   input              clk_i
  ,input              reset_i
  ,input              en_i
  ,input   [1:0]      stride
  ,input   [1:0]      pool_size
  ,input   [7:0]      data_i
  ,output  [7:0]      data_o
  ,input              v_i
  ,output             ready_o
  ,output             v_o
  ,input              yumi_i
);

  logic [7:0][2:0][7:0] temp;
  logic [7:0][7:0] temp_result,data_o_temp;
  enum{star, calc,done} ps, ns;
  logic [1:0] counter_r,counter_n;
  logic [7:0][7:0] data_i_n,data_i_r;
  logic r_o,init;

  logic [1282:0][7:0] buffer;
  always_ff @(posedge clk) begin
		buffer <= {buffer[1282:0], pixel_i};
  end
  
  always_comb begin
       case(ps)
         star: begin
               if (v_i) begin
                  ns = calc;
                  counter_n = 0;
                  data_i_n = data_i;
               end else begin
                  ns = ps;
                  counter_n = counter_r;
                  data_i_n = data_i_r;
               end
               end

         calc: begin
               if (counter_r == pool_size - 1) begin
                  ns = done;
                  counter_n = counter_r;
                  data_i_n = data_i_r;
               end else if(v_i)begin
                  counter_n = counter_r + 1;
                  ns = ps;
                  data_i_n = data_i;
               end else begin
                  counter_n = counter_r;
                  ns = ps;
                  data_i_n = data_i_r;
               end
               end

         done: begin
               if (yumi_i) begin
                   ns = star;
                   counter_n = 0;
                   data_i_n = data_i;
               end else begin
                   ns = ps;
                   counter_n = counter_r;
                   data_i_n = data_i_r;
               end
               end
      endcase
  end

  always_comb begin 
  case(ps)
  star: begin 
  if (v_i) begin
  r_o = 1;
  init = 1;
  end else begin
  r_o = 0;
  init = 1;
  end
  end
  
  calc: begin
  if(counter_r < pool_size -1)begin
  r_o = 1;
  init = 0;
  end else begin
  r_o = 0;
  init = 0;
  end
  end
 
  done: begin
  r_o = 0;
  init = 1;
  end
  endcase
  end



  assign ready_o = r_o;
  assign v_o = ps == done;

  always_ff @(posedge clk_i) begin
  if (reset_i)begin
  ps <= star;
  counter_r <= 0;
  data_i_r <= 0;
  end else begin 
  ps <= ns;
  counter_r <= counter_n;
  data_i_r <= data_i_n;
  end 
  end  
  
  
  always_comb begin
	if (stride == 1 & pool_size == 2) begin
		temp[0] = {data_i_r[0], data_i_r[7], 0};
		temp[1] = {data_i_r[1], data_i_r[0], 0};
		temp[2] = {data_i_r[2], data_i_r[1], 0};
		temp[3] = {data_i_r[3], data_i_r[2], 0};
		temp[4] = {data_i_r[4], data_i_r[3], 0};
		temp[5] = {data_i_r[5], data_i_r[4], 0};
		temp[6] = {data_i_r[6], data_i_r[5], 0};
		temp[7] = {data_i_r[7], data_i_r[6], 0};
	end else if (stride == 2 & pool_size == 2) begin
		temp[0] = {data_i_r[0], data_i_r[6], 0};		
		temp[1] = {data_i_r[2], data_i_r[0], 0};
		temp[2] = {data_i_r[4], data_i_r[2], 0};
		temp[3] = {data_i_r[6], data_i_r[4], 0};
	end else if (stride == 4 & pool_size == 2) begin
		temp[0] = {data_i_r[4], data_i_r[0], 0};
		temp[1] = {data_i_r[0], data_i_r[4], 0};
	end else if (stride == 1 & pool_size == 3) begin
		temp[0] = {data_i_r[0], data_i_r[7], data_i_r[6]};	
		temp[1] = {data_i_r[1], data_i_r[0], data_i_r[7]};	
      temp[2] = {data_i_r[2], data_i_r[1], data_i_r[0]};
		temp[3] = {data_i_r[3], data_i_r[2], data_i_r[1]};
		temp[4] = {data_i_r[4], data_i_r[3], data_i_r[2]};
		temp[5] = {data_i_r[5], data_i_r[4], data_i_r[3]};
		temp[6] = {data_i_r[6], data_i_r[5], data_i_r[4]};
		temp[7] = {data_i_r[7], data_i_r[6], data_i_r[5]};
	end else if (stride == 2 & pool_size == 3) begin
		temp[0] = {data_i_r[0], data_i_r[6], data_i_r[4]};
		temp[1] = {data_i_r[2], data_i_r[0], data_i_r[6]};
		temp[2] = {data_i_r[4], data_i_r[2], data_i_r[0]};
		temp[3] = {data_i_r[6], data_i_r[4], data_i_r[2]};
	end else if (stride == 4 & pool_size == 3) begin
		temp[0] = {data_i_r[0], data_i_r[4], data_i_r[0]};
	end
  end
  sub_max_pool smp_0(.init(init), .clk_i(clk_i), .reset_i(reset_i), .en_i(en_i), .data_i(temp[0]), .data_o(temp_result[0]));
  sub_max_pool smp_1(.init(init), .clk_i(clk_i), .reset_i(reset_i), .en_i(en_i), .data_i(temp[1]), .data_o(temp_result[1]));
  sub_max_pool smp_2(.init(init), .clk_i(clk_i), .reset_i(reset_i), .en_i(en_i), .data_i(temp[2]), .data_o(temp_result[2]));
  sub_max_pool smp_3(.init(init), .clk_i(clk_i), .reset_i(reset_i), .en_i(en_i), .data_i(temp[3]), .data_o(temp_result[3]));
  sub_max_pool smp_4(.init(init), .clk_i(clk_i), .reset_i(reset_i), .en_i(en_i), .data_i(temp[4]), .data_o(temp_result[4]));
  sub_max_pool smp_5(.init(init), .clk_i(clk_i), .reset_i(reset_i), .en_i(en_i), .data_i(temp[5]), .data_o(temp_result[5]));
  sub_max_pool smp_6(.init(init), .clk_i(clk_i), .reset_i(reset_i), .en_i(en_i), .data_i(temp[6]), .data_o(temp_result[6]));
  sub_max_pool smp_7(.init(init), .clk_i(clk_i), .reset_i(reset_i), .en_i(en_i), .data_i(temp[7]), .data_o(temp_result[7]));
  
  always_comb begin
	if (stride == 1) begin
		data_o_temp = temp_result;
	end else if (stride == 2) begin
		data_o_temp[3:0] = temp_result[3:0];
		data_o_temp[7:4] = 0;
	end else if (stride == 4 & pool_size == 2) begin
		data_o_temp[1:0] = temp_result[1:0];
		data_o_temp[7:2] = 0;
	end else if (stride == 4 & pool_size == 3) begin
		data_o_temp[0] = temp_result[0];
		data_o_temp[7:1] = 0;
	end
  end

generate

genvar i;

     for (i = 0; i < 8; i=i+1)
     begin: Relu
     
     assign data_o[i] = (data_o_temp[i][15]==1) ? 0:data_o_temp[i];
     end
     endgenerate

endmodule
