module filter_sel(clk_i, reset_i, switch, filter, v_o);

input logic clk_i, reset_i;
input logic [1:0] switch;
output logic [2:0][2:0][8:0] filter;
output logic v_o;

always_ff @(posedge clk_i) begin
if (!reset_i) begin
filter <= {{9'b0,9'b0,9'b0},{9'b0,9'b1,9'b0},{9'b0,9'b0,9'b0}};
v_o <= 0;
end else begin
case(switch)
2'b00: begin // identity
filter <= {{9'b0,9'b0,9'b0},{9'b0,9'b1,9'b0},{9'b0,9'b0,9'b0}};
v_o <= 1;
end

//2'b01: begin // highpass
//filter <= {{9'b0,9'b111111111,9'b0},{9'b111111111,9'd4,9'b111111111},{9'b0,9'b111111111,9'b0}};
//v_o <= 1;
//end

2'b01: begin // highpass
filter <= {{9'b111111111,9'b111111111,9'b111111111},{9'b111111111,9'd8,9'b111111111},{9'b111111111,9'b111111111,9'b111111111}};
v_o <= 1;
end

2'b10: begin // sharpen
filter <= {{9'b0,9'b111111111,9'b0},{9'b111111111,9'd5,9'b111111111},{9'b0,9'b111111111,9'b0}};
v_o <= 1;
end

2'b11: begin // Emboss
filter <= {{9'b111111110,9'b111111111,9'b0},{9'b111111111,9'b1,9'b1},{9'b0,9'b1,9'd2}};
v_o <= 1;
end

default: begin
filter <= {{9'b0,9'b0,9'b0},{9'b0,9'b1,9'b0},{9'b0,9'b0,9'b0}};
v_o <= 0;
end
endcase
end
end

endmodule
