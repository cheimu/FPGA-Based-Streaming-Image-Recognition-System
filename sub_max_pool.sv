module sub_max_pool(
   input              init
  ,input              clk_i
  ,input              reset_i
  ,input              en_i
  ,input   [2:0][7:0] data_i
  ,output       [7:0] data_o
);

    logic    [3:0][7:0] data;   
    logic         [7:0] max,max_temp;
    //dff

  always_comb begin
  if(init)begin
  max_temp = 0;
  end else begin
  max_temp = max;
  end
  end 
  
   bsg_dff_reset_en #(.width_p(8), .harden_p(1))
      update_input0
 	(.clock_i(clk_i), .reset_i(reset_i), .en_i(en_i), .data_i(max_temp), .data_o(data[0]));

   bsg_dff_reset_en #(.width_p(8), .harden_p(1))
      update_input1
	(.clock_i(clk_i), .reset_i(reset_i), .en_i(en_i), .data_i(data_i[0]), .data_o(data[1]));

   bsg_dff_reset_en #(.width_p(8), .harden_p(1))
      update_input2
	(.clock_i (clk_i), .reset_i(reset_i), .en_i(en_i), .data_i(data_i[1]), .data_o(data[2]));

   bsg_dff_reset_en #(.width_p(8), .harden_p(1))
      update_input3
	(.clock_i (clk_i), .reset_i (reset_i), .en_i(en_i), .data_i(data_i[2]), .data_o(data[3]));
   

    comp find_max (.data_i(data), .data_o(max));
    assign data_o = max;

endmodule

		

