module comp(
  input   [3:0][7:0] data_i
 ,output       [7:0] data_o
);
  

   logic [1:0][7:0] comp_result;

   bsg_mux #(.width_p(8), .els_p(2), .harden_p(1))
     compare_d3_d2
       (.data_i({data_i[3],data_i[2]}), .sel_i(data_i[3]>data_i[2]), .data_o(comp_result[1]));

   bsg_mux #(.width_p(8), .els_p(2),.harden_p(1))
     compare_d1_d0
       (.data_i({data_i[1],data_i[0]}), .sel_i(data_i[1]>data_i[0]), .data_o(comp_result[0]));

   bsg_mux #(.width_p(8), .els_p(2),.harden_p(1))
     max
       (.data_i({comp_result[1],comp_result[0]}), .sel_i(comp_result[1]>comp_result[0]), .data_o(data_o));

endmodule
