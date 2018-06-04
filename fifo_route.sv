module fifo_route (clk_i, reset_i, pixel_i, pixel_o, request_i, v_o, request_o);

input logic [7:0] pixel_i;
input logic clk_i, reset_i, request_i;
output logic [2:0][7:0] pixel_o;
output logic v_o, request_o;

logic v_o_1,v_o_2,v_o_3;
logic [7:0] row_1_o, row_2_o, row_3_o, in_buff;
logic enable_1,enable_2,enable_3;
logic [1:0] ps,ns;
logic [19:0] frame_co;

parameter rest = 00;
parameter fill = 01;
parameter read = 10;

// state assignment
always_comb begin
case(ps)
rest: begin
enable_1 = 0;
enable_2 = 0;
enable_3 = 0;
request_o = 0;
end

fill: begin
enable_1 = v_o_2;
enable_2 = v_o_3;
enable_3 = 1;
request_o = 1;
end

read: begin
enable_1 = v_o_1 && request_i;
enable_2 = v_o_2 && request_i;
enable_3 = v_o_3 && request_i;
request_o = request_i && (frame_co < 20'd307199);
end

default: begin
enable_1 = v_o_1 && request_i;
enable_2 = v_o_2 && request_i;
enable_3 = v_o_3 && request_i;
request_o = request_i && (frame_co < 20'd307199);
end

endcase
end

// state update
always_comb begin
case(ps)
rest: begin
if (request_i) ns = fill;
else ns =ps;
end

fill: begin
if (v_o_1) ns = read;
else ns = ps;
end

read: begin
if (!v_o_1) ns = rest;
else ns = ps;
end

default: begin
ns = ps;
end

endcase
end

conv_fifo #(.LEN(640)) row_1(.clk(clk_i), .reset(!reset_i), .enable(enable_1), .valid(v_o_1), .data(row_2_o), .first(row_1_o));
conv_fifo #(.LEN(640)) row_2(.clk(clk_i), .reset(!reset_i), .enable(enable_2), .valid(v_o_2), .data(row_3_o), .first(row_2_o));
conv_fifo #(.LEN(640)) row_3(.clk(clk_i), .reset(!reset_i), .enable(enable_3), .valid(v_o_3), .data(pixel_i), .first(row_3_o));

assign v_o = v_o_1;

assign pixel_o = {row_3_o,row_2_o,row_1_o};

always_ff @(posedge clk_i) begin
if (!reset_i) begin
ps <= rest;
frame_co <= 0;
in_buff <= 0;
end else if (request_o == 1) begin
ps <= ns;
frame_co <= frame_co + 1;
in_buff <= pixel_i;
end else begin
ps <= ns;
frame_co <= frame_co;
in_buff <= pixel_i;
end
end

endmodule
