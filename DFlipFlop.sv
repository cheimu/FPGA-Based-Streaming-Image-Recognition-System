module DFlipFlop(clock_i, reset_i, en_i, data_i, data_o);
	input logic en_i, clock_i, reset_i;
	input logic [8:0] data_i;
	output logic [8:0] data_o;
	
	always @(negedge reset_i or posedge clock_i)
	begin
		if (!reset_i)
			data_o <= 9'b0;
		else if (!en_i)
			data_o <= data_o;
		else 
			data_o <= data_i;
	end
endmodule
